import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:galaxy/core/mycolor.dart';
import 'package:galaxy/utils/sizeutils.dart';
import 'package:galaxy/widget/customebuttons/roundbuttongreen.dart';
import 'package:vibration/vibration.dart';
import '../../../../../../widget/customeuiwidgets/header.dart';
import '../../../../core/images.dart';
import '../../../../language/appLocalizations.dart';
import '../../../../language/model/lableModel.dart';
import '../../../../manager/timermanager.dart';
import '../../../../prefrence/savedprefrence.dart';
import '../../../../utils/commonutils.dart';
import '../../../../utils/dialogutils.dart';
import '../../../../utils/snackbarutil.dart';
import '../../../../widget/customdivider.dart';
import '../../../../widget/customebuttons/roundbuttonblue.dart';
import '../../../../widget/customedrawer/customedrawer.dart';
import '../../../../widget/custometext.dart';
import '../../../../widget/customtextfield.dart';
import '../../../../widget/header/mainheadingwidget.dart';
import '../../../../widget/uldnumberwidget.dart';
import '../../../login/pages/signinscreenmethods.dart';
import '../../../profile/page/profilepagescreen.dart';
import '../../../splash/model/splashdefaultmodel.dart';
import '../../../onboarding/sizeconfig.dart';
import 'dart:ui' as ui;
import '../../../login/model/userlogindatamodel.dart';
import '../../../submenu/model/submenumodel.dart';
import '../../model/closeuld/getscaleistmodel.dart';
import '../../services/closeuld/closeuldlogic/closeuldcubit.dart';
import '../../services/closeuld/closeuldlogic/closeuldstate.dart';

class ScaleULDPage extends StatefulWidget {
  String mainMenuName;
  String title;
  String refrelCode;
  LableModel? lableModel;
  int menuId;
  List<SubMenuName> importSubMenuList = [];
  List<SubMenuName> exportSubMenuList = [];
  String uldNo;
  int flightSeqNo;
  int uldSeqNo;
  String uldType;

  ScaleULDPage(
      {super.key,
      required this.importSubMenuList,
      required this.exportSubMenuList,
      required this.title,
      required this.refrelCode,
      this.lableModel,
      required this.menuId,
      required this.mainMenuName,
        required this.uldNo,
        required this.flightSeqNo,
        required this.uldSeqNo,
        required this.uldType
      });

  @override
  State<ScaleULDPage> createState() => _ScaleULDPageState();
}

class _ScaleULDPageState extends State<ScaleULDPage>{



  TextEditingController weightController = TextEditingController();
  FocusNode weightFocusNode = FocusNode();

  InactivityTimerManager? inactivityTimerManager;
  final SavedPrefrence savedPrefrence = SavedPrefrence();
  UserDataModel? _user;
  SplashDefaultModel? _splashDefaultData;
  final ScrollController scrollController = ScrollController();

  GetScaleListModel? getScaleListModel;



  bool isBackPressed = false; // Track if the back button was pressed

  bool isInactivityDialogOpen = false; // Flag to track inactivity dialog state


  String selectedSwitchIndex = "";

  List<ULDScaleWeightList> scaleWeightList = [];


 /* final List<String> scaleWeightList = [
    "ETV00001",
    "ETV00002",
    "ETV00003",
    "ETV00004",
    "ETV00005",
  ];*/

  bool _showFullList = false;

  @override
  void initState() {
    super.initState();

    _loadUser(); //load user data

    weightController.text = "0";
  }




  Future<void> openValidationDialog(String message, FocusNode focuseNode) async {
    bool? empty = await DialogUtils.showDataNotFoundDialogbot(
        context, message, widget.lableModel!);

    if (empty == true) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        FocusScope.of(context).requestFocus(focuseNode);
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    inactivityTimerManager?.stopTimer(); // Stop the timer when the screen is disposed
  }

  Future<void> _loadUser() async {
    final user = await savedPrefrence.getUserData();
    final splashDefaultData = await savedPrefrence.getSplashDefaultData();
    if (user != null && splashDefaultData != null) {
      setState(() {
        _user = user;
        _splashDefaultData = splashDefaultData;
      });
    }
    getScaleList();

    inactivityTimerManager = InactivityTimerManager(
      context: context,
      timeoutMinutes: _splashDefaultData!.activeLoginTime!,
      // Set the desired inactivity time here
      onTimeout: _handleInactivityTimeout, // Define what happens when timeout occurs
    );
    inactivityTimerManager?.startTimer();
  }

  Future<void> _handleInactivityTimeout() async {
    isInactivityDialogOpen = true; // Set flag before showing dialog

    bool? activateORNot = await DialogUtils.showingActivateTimerDialog(
        context, _user!.userProfile!.userId!, _splashDefaultData!.companyCode!);

    isInactivityDialogOpen = false; // Reset flag after dialog closes

    if (activateORNot == true) {
      inactivityTimerManager!.resetTimer();
    } else {
      _logoutUser();
    }
  }

  Future<void> _logoutUser() async {
    await savedPrefrence.logout();
    Navigator.pushAndRemoveUntil(
      context,
      CupertinoPageRoute(
        builder: (context) => const SignInScreenMethod(),
      ),
      (route) => false,
    );
  }

  void _resumeTimerOnInteraction() {
    inactivityTimerManager?.resetTimer();
    print('Activity detected, timer reset');
  }

  Future<bool> _onWillPop() async {


    isBackPressed = true; // Set to true to avoid showing snackbar on back press
    FocusScope.of(context).unfocus();
    Navigator.pop(context, "true");
    inactivityTimerManager?.stopTimer();


    return false; // Prevents the default back button action
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  String tUnit = "C";



  @override
  Widget build(BuildContext context) {
    // localize value form assets
    AppLocalizations? localizations = AppLocalizations.of(context);
    LableModel? lableModel = localizations!.lableModel;

    //ui direction not change for arabic
    ui.TextDirection uiDirection =
        localizations.locale.languageCode == CommonUtils.ARABICCULTURECODE
            ? ui.TextDirection.ltr
            : ui.TextDirection.ltr;

    //text direction change for arabic
    ui.TextDirection textDirection =
        localizations.locale.languageCode == CommonUtils.ARABICCULTURECODE
            ? ui.TextDirection.rtl
            : ui.TextDirection.ltr;

    // ui direction change arabic language
    return WillPopScope(
      onWillPop: _onWillPop,
      child: GestureDetector(
        onTap: _resumeTimerOnInteraction,
        // Resuming on any tap
        onPanDown: (details) => _resumeTimerOnInteraction(),
        // Resuming on any gesture
        child: Directionality(
          textDirection: uiDirection,
          child: SafeArea(
            child: Scaffold(
              key: _scaffoldKey,
              drawer: _user != null && _splashDefaultData != null
                  ? BuildCustomeDrawer(
                importSubMenuList: widget.importSubMenuList,
                exportSubMenuList: widget.exportSubMenuList,
                user: _user!,
                splashDefaultData: _splashDefaultData!,
              onDrawerCloseIcon: () {
                isBackPressed = false; // Set to true to avoid showing snackbar on back press
                _scaffoldKey.currentState?.closeDrawer();
              },) : null, // Add custom drawer widget here
              body: Stack(
                children: [
                  MainHeadingWidget(mainMenuName: widget.mainMenuName,
                  onDrawerIconTap: () {
                    isBackPressed = true; // Set to true to avoid showing snackbar on back press
                    _scaffoldKey.currentState?.openDrawer();
                  },
                    onUserProfileIconTap: () {
                      isBackPressed = true; // Set to true to avoid showing snackbar on back press
                      FocusScope.of(context).unfocus();
                      _scaffoldKey.currentState?.closeDrawer();
                      // navigate to profile picture
                      inactivityTimerManager?.stopTimer(); // Stop the timer when the screen is disposed
                      Navigator.push(context, CupertinoPageRoute(builder: (context) => const Profilepagescreen(),));
                    },

                  /*  onDrawerIconTap: () => _scaffoldKey.currentState?.openDrawer(),*/
                  ),
                  Positioned(
                    top: SizeConfig.blockSizeVertical * SizeUtils.HEIGHT8,
                    bottom: 0,
                    right: 0,
                    left: 0,
                    child: NotificationListener<ScrollNotification>(
                      onNotification: (ScrollNotification scroll) {
                        _resumeTimerOnInteraction(); // Reset the timer on scroll event
                        return true;
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            color: MyColor.bgColorGrey,
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(SizeConfig.blockSizeVertical * SizeUtils.WIDTH2),
                                topLeft: Radius.circular(SizeConfig.blockSizeVertical * SizeUtils.WIDTH2))),
                        child: Column(
                          children: [
                            // header of title and clear function
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 10, right: 15, top: 12, bottom: 12),
                              child: HeaderWidget(
                                titleTextColor: MyColor.colorBlack,
                                title: widget.title,
                                onBack: () {
                                  _onWillPop();
                                },
                                clearText: lableModel!.clear,
                                //add clear text to clear all feild
                                onClear: () {
                                  weightController.clear();
                                  selectedSwitchIndex = "";
                                  setState(() {

                                  });
                                },
                              ),
                            ),

                            // start api responcer

                            BlocListener<CloseULDCubit, CloseULDState>(
                              listener: (context, state) async {
                                if (state is CloseULDInitialState) {}
                                else if (state is CloseULDLoadingState) {
                                  // showing loading dialog in this state
                                  DialogUtils.showLoadingDialog(context, message: lableModel.loading);
                                }
                                else if (state is GetScaleListSuccessState){
                                  DialogUtils.hideLoadingDialog(context);
                                  if(state.getScaleListModel.status == "E"){
                                    Vibration.vibrate(duration: 500);
                                    SnackbarUtil.showSnackbar(context, state.getScaleListModel.statusMessage!, MyColor.colorRed, icon: FontAwesomeIcons.times);
                                  }else{

                                    getScaleListModel = state.getScaleListModel;
                                    scaleWeightList = getScaleListModel!.uLDScaleWeightList!;



                                    //weightController.text = CommonUtils.formateToTwoDecimalPlacesValue(getScaleListModel!.uLDScaleWeightDetail!.scaleWeight!);
                                    weightController.text = "${getScaleListModel!.uLDScaleWeightDetail!.scaleWeight!.toInt()}";
                                    selectedSwitchIndex = getScaleListModel!.uLDScaleWeightDetail!.machineNo!;
                                    setState(() {

                                    });
                                    // responce

                                  }
                                }
                                else if (state is GetScaleListFailureState){
                                  DialogUtils.hideLoadingDialog(context);
                                  Vibration.vibrate(duration: 500);
                                  SnackbarUtil.showSnackbar(context, state.error, MyColor.colorRed, icon: FontAwesomeIcons.times);
                                }
                                else if (state is SaveScaleSuccessState){
                                  DialogUtils.hideLoadingDialog(context);
                                  if(state.saveScaleModel.status == "E"){
                                    Vibration.vibrate(duration: 500);
                                    SnackbarUtil.showSnackbar(context, state.saveScaleModel.statusMessage!, MyColor.colorRed, icon: FontAwesomeIcons.times);
                                  }else{
                                    SnackbarUtil.showSnackbar(context, state.saveScaleModel.statusMessage!, MyColor.colorGreen, icon: Icons.done);
                                    getScaleList();
                                  }
                                }
                                else if (state is SaveScaleFailureState){
                                  DialogUtils.hideLoadingDialog(context);
                                  Vibration.vibrate(duration: 500);
                                  SnackbarUtil.showSnackbar(context, state.error, MyColor.colorRed, icon: FontAwesomeIcons.times);
                                }


                              },
                              child:Expanded(
                                  child: SingleChildScrollView(
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 10,
                                          right: 10,
                                          top: 0,
                                          bottom: 0),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [

                                          Container(
                                            padding: const EdgeInsets.all(10),
                                            decoration: BoxDecoration(
                                              color: MyColor.colorWhite,
                                              borderRadius: BorderRadius.circular(8),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: MyColor.colorBlack.withOpacity(0.09),
                                                  spreadRadius: 2,
                                                  blurRadius: 15,
                                                  offset: Offset(0, 3), // changes position of shadow
                                                ),
                                              ],
                                            ),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Directionality(
                                                  textDirection: textDirection,
                                                  child: Row(
                                                    children: [
                                                      SvgPicture.asset(info, height: SizeConfig.blockSizeVertical * SizeUtils.ICONSIZE2,),
                                                      SizedBox(width: SizeConfig.blockSizeHorizontal,),
                                                      ULDNumberWidget(
                                                        uldNo: widget.uldNo,
                                                        smallFontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                                        bigFontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_8,
                                                        fontColor: MyColor.textColorGrey2,
                                                        uldType: "U",
                                                      )
                                                    ],
                                                  ),
                                                ),
                                                SizedBox(height: SizeConfig.blockSizeVertical * SizeUtils.HEIGHT_1_5),
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      flex:1,
                                                      child: Directionality(
                                                        textDirection: textDirection,
                                                        child: CustomTextField(
                                                          textDirection: textDirection,
                                                          controller: weightController,
                                                          focusNode: weightFocusNode,
                                                          onPress: () {},
                                                          hasIcon: false,
                                                          hastextcolor: true,
                                                          animatedLabel: true,
                                                          needOutlineBorder: true,
                                                          labelText: "${lableModel.weight}*",
                                                          readOnly: false,
                                                          maxLength: 10,
                                                          digitsOnly: false,
                                                          doubleDigitOnly: true,
                                                          onChanged: (value) {
                                                           /* setState(() {
                                                              weightController.text = "${double.parse(CommonUtils.formateToTwoDecimalPlacesValue(value))}";
                                                            });*/

                                                          },
                                                          fillColor:  Colors.grey.shade100,
                                                          textInputType: TextInputType.number,
                                                          inputAction: TextInputAction.next,
                                                          hintTextcolor: Colors.black45,
                                                          verticalPadding: 0,
                                                          fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_8,
                                                          circularCorner: SizeConfig.blockSizeHorizontal * SizeUtils.CIRCULARCORNER,
                                                          boxHeight: SizeConfig.blockSizeVertical * SizeUtils.BOXHEIGHT,
                                                          validator: (value) {
                                                            if (value!.isEmpty) {
                                                              return "Please fill out this field";
                                                            } else {
                                                              return null;
                                                            }
                                                          },
                                                        ),
                                                      ),
                                                    ),

                                                    const SizedBox(width: 10),
                                                    IntrinsicHeight(
                                                      child: Row(
                                                        children: [
                                                          // Yes Option
                                                          InkWell(
                                                            onTap: () {

                                                              setState(() {
                                                                tUnit = "C";
                                                              });

                                                            },
                                                            child: Container(
                                                              decoration: BoxDecoration(
                                                                color:  tUnit == "C" ? MyColor.primaryColorblue : MyColor.colorWhite, // Selected blue, unselected white
                                                                borderRadius: BorderRadius.only(
                                                                  topLeft: Radius.circular(10),
                                                                  bottomLeft: Radius.circular(10),
                                                                ),
                                                                border: Border.symmetric(horizontal: BorderSide(color: MyColor.primaryColorblue), vertical: BorderSide(color: MyColor.primaryColorblue)), // Border color
                                                              ),
                                                              padding: EdgeInsets.symmetric(vertical:10, horizontal: 20),
                                                              child: Center(
                                                                  child: CustomeText(text: "KG", fontColor:  tUnit == "C" ? MyColor.colorWhite : MyColor.textColorGrey3, fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5_5, fontWeight: FontWeight.w600, textAlign: TextAlign.center)
                                                              ),
                                                            ),
                                                          ),

                                                          // No Option
                                                          InkWell(
                                                            onTap: () {

                                                              setState(() {
                                                                tUnit = "F";
                                                              });

                                                            },
                                                            child: Container(
                                                              decoration: BoxDecoration(
                                                                color: tUnit == "F" ? MyColor.primaryColorblue : MyColor.colorWhite, // Selected blue, unselected white
                                                                borderRadius: BorderRadius.only(
                                                                  topRight: Radius.circular(10),
                                                                  bottomRight: Radius.circular(10),
                                                                ),
                                                                border: Border.symmetric(horizontal: BorderSide(color: MyColor.primaryColorblue), vertical: BorderSide(color: MyColor.primaryColorblue)), // Border color
                                                              ),
                                                              padding: EdgeInsets.symmetric(vertical:10, horizontal: 20),
                                                              child: Center(
                                                                  child: CustomeText(text: "LB", fontColor: tUnit == "F" ? MyColor.colorWhite : MyColor.textColorGrey3, fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5_5, fontWeight: FontWeight.w600, textAlign: TextAlign.center)
                                                              ),
                                                            ),
                                                          )

                                                        ],
                                                      ),
                                                    )
                                                  ],
                                                ),
                                                SizedBox(height: SizeConfig.blockSizeVertical),
                                                ListView.builder(
                                                  itemCount: scaleWeightList.length,
                                                  shrinkWrap: true,
                                                  physics: const NeverScrollableScrollPhysics(),
                                                  itemBuilder: (context, index) {
                                                    Color backgroundColor = MyColor.colorList[index % MyColor.colorList.length];

                                                    ULDScaleWeightList content = scaleWeightList[index];
                                                    return Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Padding(
                                                          padding: EdgeInsets.symmetric(vertical: SizeUtils.HEIGHT5),
                                                          child: Row(
                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                            children: [
                                                              Expanded(
                                                                child: Row(
                                                                  children: [
                                                                    CircleAvatar(
                                                                      radius: SizeConfig.blockSizeVertical * SizeUtils.TEXTSIZE_2_2,
                                                                      backgroundColor: backgroundColor,
                                                                      child: CustomeText(text: "${content.referenceDescription}".substring(0, 2).toUpperCase(), fontColor: MyColor.colorBlack, fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_8, fontWeight: FontWeight.w500, textAlign: TextAlign.center),
                                                                    ),
                                                                    SizedBox(
                                                                      width: 15,
                                                                    ),
                                                                    Flexible(child: CustomeText(text: content.referenceDescription!, fontColor: MyColor.colorBlack, fontSize: SizeConfig.textMultiplier * 1.5, fontWeight: FontWeight.w400, textAlign: TextAlign.start)),
                                                                  ],
                                                                ),
                                                              ),
                                                              SizedBox(width: 2,),
                                                              Switch(
                                                                value: selectedSwitchIndex == content.referenceDataIdentifier,
                                                                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                                                activeColor: MyColor.primaryColorblue,
                                                                inactiveThumbColor: MyColor.thumbColor,
                                                                inactiveTrackColor: MyColor.textColorGrey2,
                                                                trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
                                                                onChanged: (value) {
                                                                  setState(() {
                                                                    selectedSwitchIndex = value ? content.referenceDataIdentifier! : "";
                                                                  });
                                                                },
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                        CustomDivider(
                                                          space: 0,
                                                          color: Colors.black,
                                                          hascolor: true,
                                                        ),
                                                      ],
                                                    );
                                                  },
                                                ),
                                                SizedBox(height: SizeConfig.blockSizeVertical),
                                                RoundedButtonGreen(
                                                  color: MyColor.btnColor1,
                                                  textColor: MyColor.colorBlack,
                                                  verticalPadding: SizeConfig.blockSizeVertical * SizeUtils.ICONSIZE_2_5,
                                                  textSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_2_0,
                                                  text: "Get Weight",
                                                  press: () async {
                                                    bool? closeReopenTrolley = await DialogUtils.commingSoonDialog(context, "Coming soon..." , lableModel);

                                                  },
                                                )


                                              ],
                                            ),
                                          ),




                                        ],
                                      ),
                                    ),
                                  )),
                            ),


                            SizedBox(height: SizeConfig.blockSizeVertical),
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: MyColor.colorWhite,
                                borderRadius: BorderRadius.circular(8),
                                boxShadow: [
                                  BoxShadow(
                                    color: MyColor.colorBlack.withOpacity(0.09),
                                    spreadRadius: 2,
                                    blurRadius: 15,
                                    offset: Offset(0, 3), // changes position of shadow
                                  ),
                                ],
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: RoundedButtonBlue(
                                      text: "${lableModel.cancel}",
                                      isborderButton: true,
                                      press: () {
                                        _onWillPop();  // Return null when "Cancel" is pressed
                                      },
                                    ),
                                  ),
                                  SizedBox(width: SizeConfig.blockSizeHorizontal * SizeUtils.HEIGHT7,),
                                  Expanded(
                                    flex: 1,
                                    child: RoundedButtonBlue(
                                      text: "Save",
                                      press: () {
                                        if(weightController.text.isNotEmpty){
                                          if(selectedSwitchIndex.isNotEmpty){
                                            saveScale();
                                          }else{
                                            Vibration.vibrate(duration: 500);
                                            SnackbarUtil.showSnackbar(context, "Please select 1 machine.", MyColor.colorRed, icon: FontAwesomeIcons.times);
                                          }
                                        }else{
                                          Vibration.vibrate(duration: 500);
                                          SnackbarUtil.showSnackbar(context, "Please enter weight.", MyColor.colorRed, icon: FontAwesomeIcons.times);
                                        }

                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),

                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }


  Future<void> getScaleList() async {
    await context.read<CloseULDCubit>().getScaleList(
        widget.uldSeqNo,
        _user!.userProfile!.userIdentity!,
        _splashDefaultData!.companyCode!,
        widget.menuId);
  }

  Future<void> saveScale() async {
    await context.read<CloseULDCubit>().saveScale(
        widget.flightSeqNo,
        widget.uldSeqNo,
        double.parse(CommonUtils.formateToTwoDecimalPlacesValue(double.parse(weightController.text))),
        selectedSwitchIndex,
        _user!.userProfile!.userIdentity!,
        _splashDefaultData!.companyCode!,
        widget.menuId);
  }



}

