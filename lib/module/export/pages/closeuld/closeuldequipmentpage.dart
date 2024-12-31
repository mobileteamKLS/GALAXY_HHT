import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:galaxy/core/mycolor.dart';
import 'package:galaxy/utils/sizeutils.dart';
import 'package:galaxy/utils/snackbarutil.dart';
import 'package:vibration/vibration.dart';
import '../../../../../../widget/customeuiwidgets/header.dart';
import '../../../../core/images.dart';
import '../../../../language/appLocalizations.dart';
import '../../../../language/model/lableModel.dart';
import '../../../../manager/timermanager.dart';
import '../../../../prefrence/savedprefrence.dart';
import '../../../../utils/commonutils.dart';
import '../../../../utils/dialogutils.dart';
import '../../../../widget/customebuttons/roundbuttonblue.dart';
import '../../../../widget/customedrawer/customedrawer.dart';
import '../../../../widget/custometext.dart';
import '../../../../widget/customtextfield.dart';
import '../../../../widget/header/mainheadingwidget.dart';
import '../../../login/pages/signinscreenmethods.dart';
import '../../../profile/page/profilepagescreen.dart';
import '../../../splash/model/splashdefaultmodel.dart';
import '../../../onboarding/sizeconfig.dart';
import 'dart:ui' as ui;
import '../../../login/model/userlogindatamodel.dart';
import '../../../submenu/model/submenumodel.dart';
import '../../model/closeuld/equipmentmodel.dart';
import '../../services/closeuld/closeuldlogic/closeuldcubit.dart';
import '../../services/closeuld/closeuldlogic/closeuldstate.dart';

class CloseULDEquipmentPage extends StatefulWidget {
  String mainMenuName;
  String title;
  String refrelCode;
  LableModel? lableModel;
  int menuId;
  List<SubMenuName> importSubMenuList = [];
  List<SubMenuName> exportSubMenuList = [];
  String uldNo;
  int uldSeqNo;
  String uldType;

  CloseULDEquipmentPage(
      {super.key,
      required this.importSubMenuList,
      required this.exportSubMenuList,
      required this.title,
      required this.refrelCode,
      this.lableModel,
      required this.menuId,
      required this.mainMenuName,
      required this.uldNo,
      required this.uldSeqNo,
      required this.uldType});

  @override
  State<CloseULDEquipmentPage> createState() => _CloseULDEquipmentPageState();
}

class _CloseULDEquipmentPageState extends State<CloseULDEquipmentPage>{



  TextEditingController scanULDController = TextEditingController();
  FocusNode scanULDFocusNode = FocusNode();
  FocusNode scanULDBtnFocusNode = FocusNode();



  InactivityTimerManager? inactivityTimerManager;
  final SavedPrefrence savedPrefrence = SavedPrefrence();
  UserDataModel? _user;
  SplashDefaultModel? _splashDefaultData;
  final ScrollController scrollController = ScrollController();





  bool isBackPressed = false; // Track if the back button was pressed

  bool isInactivityDialogOpen = false; // Flag to track inactivity dialog state

  List<EequipmentList> equipmentList = [];

  List<TextEditingController> volumeControllers = [];
  List<TextEditingController> weightControllers = [];
  List<FocusNode> volumeFocusNodes = [];
  List<FocusNode> weightFocusNodes = [];

  @override
  void initState() {
    super.initState();

    _loadUser(); //load user data



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

    for (var controller in volumeControllers) {
      controller.dispose();
    }
    for (var focusNode in volumeFocusNodes) {
      focusNode.dispose();
    }

    for (var controller in weightControllers) {
      controller.dispose();
    }
    for (var focusNode in weightFocusNodes) {
      focusNode.dispose();
    }

    scanULDFocusNode.dispose();
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
await context.read<CloseULDCubit>().closeULDEquipmentList(
            widget.uldSeqNo,
            widget.uldType,
            _user!.userProfile!.userIdentity!,
            _splashDefaultData!.companyCode!,
            widget.menuId);

    inactivityTimerManager = InactivityTimerManager(
      context: context,
      timeoutMinutes: _splashDefaultData!.activeLoginTime!,
      // Set the desired inactivity time here
      onTimeout: _handleInactivityTimeout, // Define what happens when timeout occurs
    );
    inactivityTimerManager?.startTimer();
  }

  Future<void> _handleInactivityTimeout() async {
    scanULDFocusNode.unfocus();
    isInactivityDialogOpen = true; // Set flag before showing dialog

    bool? activateORNot = await DialogUtils.showingActivateTimerDialog(
        context, _user!.userProfile!.userId!, _splashDefaultData!.companyCode!);

    isInactivityDialogOpen = false; // Reset flag after dialog closes

    if (activateORNot == true) {
      inactivityTimerManager!.resetTimer();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        FocusScope.of(context).requestFocus(scanULDFocusNode);
      },
      );
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
    Navigator.pop(context);
    inactivityTimerManager?.stopTimer();


    return false; // Prevents the default back button action
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();





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
                      scanULDFocusNode.unfocus();
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
                                  //unloadUldListModel = null;
                                  scanULDController.clear();

                                  setState(() {

                                  });
                                },
                              ),
                            ),

                            BlocListener<CloseULDCubit, CloseULDState>(
                              listener: (context, state) async {
                                if (state is CloseULDInitialState) {}
                                else if (state is CloseULDInitialState) {
                                  // showing loading dialog in this state
                                  DialogUtils.showLoadingDialog(context, message: lableModel.loading);
                                }
                                else if (state is CloseULDEquipmentSuccessState){
                                  DialogUtils.hideLoadingDialog(context);
                                  if(state.closeULDEquipmentModel.status == "E"){
                                    Vibration.vibrate(duration: 500);
                                    SnackbarUtil.showSnackbar(context, state.closeULDEquipmentModel.statusMessage!, MyColor.colorRed, icon: FontAwesomeIcons.times);
                                  }else{
                                    equipmentList = state.closeULDEquipmentModel.eequipmentList!;


                                    volumeControllers = List.generate(
                                      equipmentList.length,
                                          (index) => TextEditingController(
                                        text: equipmentList[index].quantity?.toString() ?? "",
                                      ),
                                    );
                                    weightControllers = List.generate(
                                      equipmentList.length,
                                          (index) => TextEditingController(
                                        text: equipmentList[index].weight?.toString() ?? "",
                                      ),
                                    );

                                    volumeFocusNodes = List.generate(equipmentList.length, (index) => FocusNode());
                                    weightFocusNodes = List.generate(equipmentList.length, (index) => FocusNode());

                                    setState(() {

                                    });

                                  }
                                }
                                else if (state is CloseULDEquipmentFailureState){
                                  DialogUtils.hideLoadingDialog(context);
                                  Vibration.vibrate(duration: 500);
                                  SnackbarUtil.showSnackbar(context, state.error, MyColor.colorRed, icon: FontAwesomeIcons.times);
                                }



                              },
                              child:  Expanded(
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
                                                      CustomeText(
                                                          text: widget.uldNo,
                                                          fontColor: MyColor.textColorGrey2,
                                                          fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_6,
                                                          fontWeight: FontWeight.w700,
                                                          textAlign: TextAlign.start)
                                                    ],
                                                  ),
                                                ),
                                                SizedBox(height: SizeConfig.blockSizeVertical),
                                                ListView.builder(
                                                  itemCount: equipmentList.length,
                                                  shrinkWrap: true,
                                                  physics: const NeverScrollableScrollPhysics(),
                                                  itemBuilder: (context, index) {
                                                    EequipmentList content = equipmentList[index];
                                                    TextEditingController volumeController = volumeControllers[index];
                                                    TextEditingController weightController = weightControllers[index];
                                                    FocusNode volumeFocusNode = volumeFocusNodes[index];
                                                    FocusNode weightFocusNode = weightFocusNodes[index];

                                                    return Container(
                                                      padding: const EdgeInsets.only(right: 8, left: 8, bottom: 8),
                                                      margin: EdgeInsets.only(bottom: 8),
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
                                                          CustomeText(text: content.referenceDescription!, fontColor: MyColor.textColorGrey3, fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_7, fontWeight: FontWeight.w600, textAlign: TextAlign.start),
                                                          SizedBox(height: SizeConfig.blockSizeVertical * SizeUtils.HEIGHT_1_5),
                                                          Row(
                                                            children: [
                                                              Expanded(
                                                                flex:1,
                                                                child: Directionality(
                                                                  textDirection: textDirection,
                                                                  child: CustomTextField(
                                                                    textDirection: textDirection,
                                                                    controller: volumeController,
                                                                    focusNode: volumeFocusNode,
                                                                    onPress: () {

                                                                    },
                                                                    hasIcon: false,
                                                                    maxLength: 5,
                                                                    hastextcolor: true,
                                                                    animatedLabel: true,
                                                                    needOutlineBorder: true,
                                                                    labelText: "Quantity",
                                                                    readOnly: false,
                                                                    onChanged: (value) {
                                                                      //updateSelectedContentList(index, value);
                                                                    },
                                                                    fillColor:  Colors.grey.shade100,
                                                                    textInputType: TextInputType.number,
                                                                    inputAction: TextInputAction.next,
                                                                    hintTextcolor: Colors.black45,
                                                                    verticalPadding: 0,
                                                                    digitsOnly: true,

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
                                                              SizedBox(width: 15,),
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
                                                                    labelText: "${lableModel.weight}",
                                                                    readOnly: false,
                                                                    maxLength: 10,
                                                                    digitsOnly: false,
                                                                    doubleDigitOnly: true,
                                                                    onChanged: (value) {
                                                                      setState(() {
                                                                        weightController.text = "${double.parse(CommonUtils.formateToTwoDecimalPlacesValue(value))}";
                                                                      });

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
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    );
                                                  },
                                                ),



                                              ],
                                            ),
                                          ),




                                        ],
                                      ),
                                    ),
                                  )),
                            ),


                            // start api responcer

                            SizedBox(height: SizeConfig.blockSizeVertical),

                            Container(
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
                              padding: const EdgeInsets.only(
                                  left: 10, right: 15, top: 12, bottom: 12),
                              child:  Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      CustomeText(
                                        text: "Total Weight : ",
                                        fontColor: MyColor.textColorGrey2,
                                        fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_7,
                                        fontWeight: FontWeight.w700,
                                        textAlign: TextAlign.start,
                                      ),
                                      Row(
                                        children: [
                                          CustomeText(
                                            text: CommonUtils.formateToTwoDecimalPlacesValue(0),
                                            fontColor: MyColor.colorBlack,
                                            fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_7,
                                            fontWeight: FontWeight.w700,
                                            textAlign: TextAlign.start,
                                          ),
                                          CustomeText(
                                            text: " Kg",
                                            fontColor: MyColor.colorBlack,
                                            fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_7,
                                            fontWeight: FontWeight.w700,
                                            textAlign: TextAlign.start,
                                          ),
                                        ],
                                      )

                                    ],
                                  ),
                                  SizedBox(height: SizeConfig.blockSizeVertical),
                                  Row(
                                    children: [
                                      Expanded(
                                        flex: 1,
                                        child: RoundedButtonBlue(
                                          text: "${lableModel.cancel}",
                                          isborderButton: true,
                                          press: () {
                                            Navigator.pop(context, null);  // Return null when "Cancel" is pressed
                                          },
                                        ),
                                      ),
                                      SizedBox(width: SizeConfig.blockSizeHorizontal * SizeUtils.HEIGHT7,),
                                      Expanded(
                                        flex: 1,
                                        child: RoundedButtonBlue(
                                          text: "Save",
                                          press: () {

                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              )
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




}

