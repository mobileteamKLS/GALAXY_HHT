import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:galaxy/core/mycolor.dart';
import 'package:galaxy/module/export/services/move/movelogic/movecubit.dart';
import 'package:galaxy/module/export/services/move/movelogic/movestate.dart';
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
import '../../../../widget/roundbutton.dart';
import '../../../login/pages/signinscreenmethods.dart';
import '../../../profile/page/profilepagescreen.dart';
import '../../../splash/model/splashdefaultmodel.dart';
import '../../../onboarding/sizeconfig.dart';
import 'dart:ui' as ui;

import '../../../login/model/userlogindatamodel.dart';
import '../../../submenu/model/submenumodel.dart';

class MovePage extends StatefulWidget {
  String mainMenuName;
  String title;
  String refrelCode;
  LableModel? lableModel;
  int menuId;
  List<SubMenuName> importSubMenuList = [];
  List<SubMenuName> exportSubMenuList = [];

  MovePage(
      {super.key,
      required this.importSubMenuList,
      required this.exportSubMenuList,
      required this.title,
      required this.refrelCode,
      this.lableModel,
      required this.menuId,
      required this.mainMenuName});

  @override
  State<MovePage> createState() => _MovePageState();
}

class _MovePageState extends State<MovePage> with SingleTickerProviderStateMixin{


  InactivityTimerManager? inactivityTimerManager;
  final SavedPrefrence savedPrefrence = SavedPrefrence();
  UserDataModel? _user;
  SplashDefaultModel? _splashDefaultData;
  final ScrollController scrollController = ScrollController();

  TextEditingController groupIdController = TextEditingController();

  FocusNode groupIdFocusNode = FocusNode();
  bool _isOpenULDFlagEnable = false;

  bool isBackPressed = false; // Track if the back button was pressed

 // BinningDetailListModel? binningDetailListModel;




  late AnimationController _blinkController;
  late Animation<Color?> _colorAnimation;
  String selectedType = "G";
  String pickType = "";
  String dropLocation = "";


  String sourceSelection = "G";
  String targetSelection = "G";
  String countingSearchFlag = "F";

  bool isInactivityDialogOpen = false; // Flag to track inactivity dialog state

  List<String> listValue = ["A", "B" , "C", "D", "E"]; // Example list of values
  List<bool> switchStates = []; // Track switch states
  bool _isSelectAll = false; // "Select All" switch state
  List<String> selectedValues = []; // List of selected values

  @override
  void initState() {
    super.initState();
    switchStates = List<bool>.filled(listValue.length, false);

    _loadUser(); //load user data

    _blinkController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: TickerProviders(), // Manually providing Ticker
    )..repeat(reverse: true); // Loop the animation

    _colorAnimation = ColorTween(
      begin: MyColor.shcColorList[0],
      end: Colors.transparent,
    ).animate(_blinkController);



    groupIdFocusNode.addListener(() {
      if (!groupIdFocusNode.hasFocus && !isBackPressed) {
        leaveGroupIdFocus();
      }
    });



  }

  void _toggleSelectAll(bool value) {
    setState(() {
      _isSelectAll = value;
      switchStates = List<bool>.filled(listValue.length, value);
      selectedValues = value ? List<String>.from(listValue) : [];
    });
  }

  void _toggleSwitch(int index, bool value) {
    setState(() {
      switchStates[index] = value;
      if (value) {
        selectedValues.add(listValue[index]);
      } else {
        selectedValues.remove(listValue[index]);
      }
      // Update "Select All" state
      _isSelectAll = switchStates.every((state) => state);
    });
  }


  Future<void> leaveGroupIdFocus() async {

    // Skip the focus leave logic if inactivity dialog is open
    if (isInactivityDialogOpen) return;

    if (groupIdController.text.isNotEmpty) {


      // call binning details api
    /*  await context.read<BinningCubit>().getBinningDetailListApi(
          groupIdController.text,
          _user!.userProfile!.userIdentity!,
          _splashDefaultData!.companyCode!,
          widget.menuId);*/
    }else{
      FocusScope.of(context).requestFocus(groupIdFocusNode);
      SnackbarUtil.showSnackbar(context, widget.lableModel!.enterGropIdMsg!, MyColor.colorRed, icon: FontAwesomeIcons.times);
     // binningDetailListModel = null;
      setState(() {

      });
    }
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
    //all controller and focus node dispose
    groupIdFocusNode.dispose();
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

    //context.read<BinningCubit>().getPageLoadDefault(widget.menuId, _user!.userProfile!.userIdentity!, _splashDefaultData!.companyCode!);

    inactivityTimerManager = InactivityTimerManager(
      context: context,
      timeoutMinutes: _splashDefaultData!.activeLoginTime!,
      // Set the desired inactivity time here
      onTimeout: _handleInactivityTimeout, // Define what happens when timeout occurs
    );
    inactivityTimerManager?.startTimer();
  }

  Future<void> _handleInactivityTimeout() async {
    groupIdFocusNode.unfocus();
    isInactivityDialogOpen = true; // Set flag before showing dialog

    bool? activateORNot = await DialogUtils.showingActivateTimerDialog(
        context, _user!.userProfile!.userId!, _splashDefaultData!.companyCode!);

    isInactivityDialogOpen = false; // Reset flag after dialog closes

    if (activateORNot == true) {
      inactivityTimerManager!.resetTimer();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        FocusScope.of(context).requestFocus(groupIdFocusNode);
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
    groupIdFocusNode.unfocus();
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
                      groupIdFocusNode.unfocus();
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
                                  //binningDetailListModel = null;
                                  groupIdController.clear();
                                  WidgetsBinding.instance.addPostFrameCallback((_) {
                                    FocusScope.of(context).requestFocus(groupIdFocusNode);
                                  },
                                  );
                                  setState(() {

                                  });
                                },
                              ),
                            ),

                            // start api responcer
                            BlocListener<MoveCubit, MoveState>(
                              listener: (context, state) async {
                                if (state is MoveInitialState) {
                                }
                                else if (state is MoveLoadingState) {
                                  // showing loading dialog in this state
                                  DialogUtils.showLoadingDialog(context, message: lableModel.loading);
                                }
                                else if(state is MoveLocationSuccessState){
                                 DialogUtils.hideLoadingDialog(context);
                                 if(state.moveLocationModel.status == "E"){
                                   Vibration.vibrate(duration: 500);
                                   SnackbarUtil.showSnackbar(context, state.moveLocationModel.statusMessage!, MyColor.colorRed, icon: FontAwesomeIcons.times);
                                 }else if(state.moveLocationModel.status == "V"){
                                   Vibration.vibrate(duration: 500);
                                   SnackbarUtil.showSnackbar(context, state.moveLocationModel.statusMessage!, MyColor.colorRed, icon: FontAwesomeIcons.times);
                                 }else{
                                   SnackbarUtil.showSnackbar(context, state.moveLocationModel.statusMessage!, MyColor.colorGreen, icon: Icons.done);
                                 }

                                }
                                else if(state is MoveLocationFailureState){
                                  DialogUtils.hideLoadingDialog(context);
                                  Vibration.vibrate(duration: 500);
                                  SnackbarUtil.showSnackbar(context, state.error, MyColor.colorRed, icon: FontAwesomeIcons.times);
                                }


                              },
                              child: Expanded(
                                child: SingleChildScrollView(
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 10, right: 10, top: 0, bottom: 0),
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
                                              SizedBox(
                                                  height: SizeConfig.blockSizeVertical),
                                              // text manifest and recived in pices text counter
                                              Directionality(
                                                textDirection: textDirection,
                                                child: Row(
                                                  children: [
                                                    Expanded(
                                                      flex :1,
                                                      child: CustomTextField(
                                                        textDirection: textDirection,
                                                        controller: groupIdController,
                                                        focusNode: groupIdFocusNode,
                                                        onPress: () {},
                                                        hasIcon: false,
                                                        hastextcolor: true,
                                                        animatedLabel: true,
                                                        needOutlineBorder: true,
                                                        labelText: (selectedType == "G") ? "Scan Group Id Or Location" : (selectedType == "U") ? "Scan ULD Or Location" : "Scan Trolley Or Location",
                                                        readOnly: false,
                                                        maxLength: (selectedType == "G") ? 14 : (selectedType == "U") ? 11 : 15,
                                                        onChanged: (value) {
                                                          setState(() {

                                                          });
                                                        },
                                                        fillColor: Colors.grey.shade100,
                                                        textInputType: TextInputType.text,
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
                                                    SizedBox(
                                                      width: SizeConfig.blockSizeHorizontal,
                                                    ),
                                                    // click search button to validate location
                                                    InkWell(
                                                      onTap: () {
                                                        scanGroupQR();
                                                      },
                                                      child: Padding(padding: const EdgeInsets.all(8.0),
                                                        child: SvgPicture.asset(search, height: SizeConfig.blockSizeVertical * SizeUtils.ICONSIZE3,),
                                                      ),

                                                    )
                                                  ],
                                                ),
                                              ),
                                              SizedBox(height: SizeConfig.blockSizeVertical),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Row(
                                                    children: [
                                                      CustomeText(
                                                        text: "Pick :",
                                                        fontColor: MyColor.textColorGrey3,
                                                        fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_7,
                                                        fontWeight: FontWeight.w600,
                                                        textAlign: TextAlign.start,
                                                      ),
                                                      const SizedBox(width: 5),
                                                      CustomeText(
                                                        text: (pickType == "G") ? "Group" : (pickType == "U") ? "ULD" : (pickType == "T") ? "Trolley" : "",
                                                        fontColor: Colors.pink.shade500,
                                                        fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_7,
                                                        fontWeight: FontWeight.bold,
                                                        textAlign: TextAlign.start,
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    children: [
                                                      CustomeText(
                                                        text: "Drop :",
                                                        fontColor: MyColor.textColorGrey3,
                                                        fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_7,
                                                        fontWeight: FontWeight.w600,
                                                        textAlign: TextAlign.start,
                                                      ),
                                                      const SizedBox(width: 5),
                                                      CustomeText(
                                                        text: "AKE 12345 AJ",
                                                        fontColor: MyColor.colorGreen,
                                                        fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_7,
                                                        fontWeight: FontWeight.bold,
                                                        textAlign: TextAlign.start,
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                              SizedBox(height: SizeConfig.blockSizeVertical),
                                              Directionality(
                                                textDirection: textDirection,
                                                child: IntrinsicHeight(
                                                  child: Row(
                                                    children: [
                                                      Expanded(
                                                        flex:1,
                                                        child: Column(
                                                          children: [
                                                            RoundedButtonBlue(
                                                              text: "Clear",
                                                              isOutlined: true,
                                                              isborderButton: true,
                                                              press: () async {
                                                                _onWillPop();
                                                              },
                                                            ),
                                                            SizedBox(height: SizeConfig.blockSizeVertical,),
                                                            Row(
                                                              mainAxisAlignment: MainAxisAlignment.start,
                                                              children: [
                                                                Switch(
                                                                  value: _isSelectAll,
                                                                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                                                  activeColor: MyColor.primaryColorblue,
                                                                  inactiveThumbColor: MyColor.thumbColor,
                                                                  inactiveTrackColor: MyColor.textColorGrey2,
                                                                  trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
                                                                  onChanged: _toggleSelectAll,
                                                                ),
                                                                SizedBox(width: SizeConfig.blockSizeHorizontal,),
                                                                CustomeText(
                                                                    text: "Select All",
                                                                    fontColor: MyColor.textColorGrey2,
                                                                    fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_7,
                                                                    fontWeight: FontWeight.w500,
                                                                    textAlign: TextAlign.start),


                                                              ],
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                      SizedBox(width: SizeConfig.blockSizeHorizontal * SizeUtils.WIDTH2,),
                                                      Expanded(
                                                        flex:1,
                                                        child: Container(
                                                          height: double.infinity,
                                                          child: RoundedButton(
                                                            color:  MyColor.primaryColorblue,
                                                            text: "${lableModel.move}",
                                                            press: () async {
                                                              if (selectedValues.isEmpty) {
                                                                print("No items selected");
                                                                return;
                                                              }
                                                              String xmlData = generateImageXMLData(selectedValues);
                                                              print("Generated XML:$xmlData");

                                                            },
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(height: SizeConfig.blockSizeVertical),

                                        Directionality(textDirection: textDirection,
                                            child: Container(
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
                                              child: Padding(
                                                padding: const EdgeInsets.only(left: 12, right: 12, top: 12, bottom: 12),
                                                child: (listValue.isNotEmpty)
                                                    ? Column(
                                                  children: [

                                                    ListView.builder(
                                                      itemCount: listValue.length,
                                                      physics: NeverScrollableScrollPhysics(),
                                                      shrinkWrap: true,
                                                      controller: scrollController,
                                                      itemBuilder: (context, index) {
                                                        String value = listValue[index];

                                                        return InkWell(
                                                            onTap: () {
                                                              FocusScope.of(context).unfocus();

                                                            },
                                                            onDoubleTap: () async {



                                                            },
                                                            child: Container(
                                                                margin: EdgeInsets.symmetric(vertical: 4),
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
                                                                child: Container(
                                                                  padding: EdgeInsets.all(8),
                                                                  decoration: BoxDecoration(
                                                                    color: MyColor.colorWhite,
                                                                    borderRadius: BorderRadius.circular(8),
                                                                  ),
                                                                  child: Stack(
                                                                    children: [
                                                                      Column(
                                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                                        children: [
                                                                          Row(
                                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                            children: [
                                                                              Row(
                                                                                children: [
                                                                                  Switch(
                                                                                    value: switchStates[index],
                                                                                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                                                                    activeColor: MyColor.primaryColorblue,
                                                                                    inactiveThumbColor: MyColor.thumbColor,
                                                                                    inactiveTrackColor: MyColor.textColorGrey2,
                                                                                    trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
                                                                                    onChanged:  (value) => _toggleSwitch(index, value),
                                                                                  ),
                                                                                  CustomeText(
                                                                                    text: "${value}",
                                                                                    fontColor: MyColor.colorBlack,
                                                                                    fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                                                                    fontWeight: FontWeight.w600,
                                                                                    textAlign: TextAlign.start,
                                                                                  ),
                                                                                  const SizedBox(width: 5),
                                                                                ],
                                                                              ),

                                                                            ],
                                                                          ),
                                                                          SizedBox(height: SizeConfig.blockSizeVertical * 0.5,),


                                                                        ],
                                                                      ),
                                                                    ],
                                                                  ),
                                                                )
                                                            )
                                                        );
                                                      },
                                                    ),
                                                  ],
                                                )
                                                    : Padding(
                                                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                                                  child: Center(
                                                    child: CustomeText(text: "${lableModel.recordNotFound}",
                                                        fontColor: MyColor.textColorGrey,
                                                        fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_2_0,
                                                        fontWeight: FontWeight.w500,
                                                        textAlign: TextAlign.center),),
                                                ),

                                              ),
                                            )),


                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Directionality(
                                textDirection: uiDirection,
                                child: IntrinsicHeight(
                                  child: Row(
                                    children: [
                                      // Yes Option
                                      Expanded(
                                        flex: 1,
                                        child: InkWell(
                                          onTap: () {

                                            if (pickType == "G" || pickType == "" || pickType == "U") {
                                              setState(() {
                                                selectedType = "U";
                                              });
                                            }

                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: selectedType == "U" ? MyColor.primaryColorblue : MyColor.colorWhite, // Selected blue, unselected white
                                              borderRadius: const BorderRadius.only(
                                                topLeft: Radius.circular(10),
                                                bottomLeft: Radius.circular(10),
                                              ),
                                              border: const Border.symmetric(horizontal: BorderSide(color: MyColor.primaryColorblue), vertical: BorderSide(color: MyColor.primaryColorblue)), // Border color
                                            ),
                                            padding: const EdgeInsets.symmetric(vertical:16, horizontal: 10),
                                            child: Center(
                                                child: CustomeText(text: lableModel.uldLable!.toUpperCase(), fontColor: selectedType == "U" ? MyColor.colorWhite : MyColor.textColorGrey3, fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5, fontWeight: FontWeight.w600, textAlign: TextAlign.center)
                                            ),
                                          ),
                                        ),
                                      ),
                                      // No Option
                                      Expanded(
                                        flex: 1,
                                        child: InkWell(
                                          onTap: () {
                                            if (pickType == "G" || pickType == "") {
                                              setState(() {
                                                selectedType = "G";
                                              });
                                            }

                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: selectedType == "G" ? MyColor.primaryColorblue : MyColor.colorWhite, // Selected blue, unselected white
                                              border: const Border.symmetric(horizontal: BorderSide(color: MyColor.primaryColorblue)), // Border color
                                            ),
                                            padding: const EdgeInsets.symmetric(vertical:16, horizontal: 10),
                                            child: Center(
                                                child: CustomeText(text: lableModel.group!.toUpperCase(), fontColor: selectedType == "G" ? MyColor.colorWhite : MyColor.textColorGrey3, fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5, fontWeight: FontWeight.w600, textAlign: TextAlign.center)
                                            ),
                                          ),
                                        ),
                                      ),

                                      Expanded(
                                        flex: 1,
                                        child: InkWell(
                                          onTap: () {

                                            if (pickType == "G" || pickType == "" || pickType == "T") {
                                              setState(() {
                                                selectedType = "T";
                                              });
                                            }

                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: selectedType == "T" ? MyColor.primaryColorblue : MyColor.colorWhite, // Selected blue, unselected white
                                              borderRadius: const BorderRadius.only(
                                                topRight: Radius.circular(10),
                                                bottomRight: Radius.circular(10),
                                              ),
                                              border: const Border.symmetric(horizontal: BorderSide(color: MyColor.primaryColorblue), vertical: BorderSide(color: MyColor.primaryColorblue)), // Border color
                                            ),
                                            padding: const EdgeInsets.symmetric(vertical:16, horizontal: 10),
                                            child: Center(
                                                child: CustomeText(text: "TROLLEY", fontColor: selectedType == "T" ? MyColor.colorWhite : MyColor.textColorGrey3, fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5, fontWeight: FontWeight.w600, textAlign: TextAlign.center)
                                            ),
                                          ),
                                        ),
                                      ),

                                    ],
                                  ),
                                ),
                              ),
                            )

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

  Future<void> scanGroupQR() async{
    String groupcodeScanResult =  await FlutterBarcodeScanner.scanBarcode(
      '#ff6666', // Color for the scanner overlay
      'Cancel', // Text for the cancel button
      true, // Enable flash option
      ScanMode.DEFAULT, // Scan mode
    );

    if(groupcodeScanResult == "-1"){

    }else{
      bool specialCharAllow = CommonUtils.containsSpecialCharacters(groupcodeScanResult);

      if(specialCharAllow == true){
        SnackbarUtil.showSnackbar(context, "${widget.lableModel!.onlyAlphaNumericValueMsg}", MyColor.colorRed, icon: FontAwesomeIcons.times);
        Vibration.vibrate(duration: 500);
        groupIdController.clear();
        WidgetsBinding.instance.addPostFrameCallback((_) {
          FocusScope.of(context).requestFocus(groupIdFocusNode);
        });
      }else{

        String result = groupcodeScanResult.replaceAll(" ", "");

        String truncatedResult = result.length > 15
            ? result.substring(0, 15)
            : result;

        groupIdController.text = truncatedResult;
        // Call searchLocation api to validate or not
        // call binning details api

        /* await context.read<BinningCubit>().getBinningDetailListApi(
              groupIdController.text,
              _user!.userProfile!.userIdentity!,
              _splashDefaultData!.companyCode!,
              widget.menuId);*/


      }

    }


  }

  String generateImageXMLData(List<String> selectList) {
    StringBuffer xmlBuffer = StringBuffer();
    xmlBuffer.write('<Root>');
    for (String value in selectList) {
      xmlBuffer.write('<Move>');
      xmlBuffer.write('<SeqNo>$value</SeqNo>');
      xmlBuffer.write('</Move>');
    }
    xmlBuffer.write('</Root>');
    return xmlBuffer.toString();
  }


  Future<void> moveLocation() async {

    print("moveLocation Payload === ${pickType} == ${dropLocation} == ${generateImageXMLData(selectedValues)}");


    await context.read<MoveCubit>().moveLocation(
        pickType,
        dropLocation,
        generateImageXMLData(selectedValues),
        _user!.userProfile!.userIdentity!,
        _splashDefaultData!.companyCode!,
        widget.menuId);
  }

}

class TickerProviders extends TickerProvider {
  @override
  Ticker createTicker(onTick) => Ticker(onTick);
}

