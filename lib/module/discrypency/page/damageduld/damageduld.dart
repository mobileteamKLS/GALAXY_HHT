import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:galaxy/core/mycolor.dart';
import 'package:galaxy/module/discrypency/model/damageduld/getdamageduldsearchmodel.dart';
import 'package:galaxy/module/discrypency/services/damageduld/damageduldlogic/damageduldcubit.dart';
import 'package:galaxy/module/discrypency/services/damageduld/damageduldlogic/damageduldstate.dart';
import 'package:galaxy/utils/sizeutils.dart';
import 'package:galaxy/utils/snackbarutil.dart';
import 'package:galaxy/widget/uldnumberwidget.dart';
import 'package:vibration/vibration.dart';
import '../../../../../../../widget/customeuiwidgets/header.dart';
import '../../../../../core/images.dart';
import '../../../../../language/appLocalizations.dart';
import '../../../../../language/model/lableModel.dart';
import '../../../../../manager/timermanager.dart';
import '../../../../../prefrence/savedprefrence.dart';
import '../../../../../utils/commonutils.dart';
import '../../../../../utils/dialogutils.dart';
import '../../../../../widget/customebuttons/roundbuttonblue.dart';
import '../../../../../widget/customedrawer/customedrawer.dart';
import '../../../../../widget/custometext.dart';
import '../../../../../widget/customtextfield.dart';
import '../../../../../widget/header/mainheadingwidget.dart';
import 'dart:ui' as ui;

import '../../../import/pages/uldacceptance/ulddamagedpage.dart';
import '../../../login/model/userlogindatamodel.dart';
import '../../../login/pages/signinscreenmethods.dart';
import '../../../onboarding/sizeconfig.dart';
import '../../../profile/page/profilepagescreen.dart';
import '../../../splash/model/splashdefaultmodel.dart';
import '../../../submenu/model/submenumodel.dart';


class DamagedULDPage extends StatefulWidget {
  String mainMenuName;
  String title;
  String refrelCode;
  LableModel? lableModel;
  int menuId;
  List<SubMenuName> importSubMenuList = [];
  List<SubMenuName> exportSubMenuList = [];

  DamagedULDPage(
      {super.key,
      required this.importSubMenuList,
      required this.exportSubMenuList,
      required this.title,
      required this.refrelCode,
      this.lableModel,
      required this.menuId,
      required this.mainMenuName});

  @override
  State<DamagedULDPage> createState() => _DamagedULDPageState();
}

class _DamagedULDPageState extends State<DamagedULDPage> with SingleTickerProviderStateMixin{


  InactivityTimerManager? inactivityTimerManager;
  final SavedPrefrence savedPrefrence = SavedPrefrence();
  UserDataModel? _user;
  SplashDefaultModel? _splashDefaultData;
  final ScrollController scrollController = ScrollController();

  TextEditingController groupIdController = TextEditingController();
  FocusNode groupIdFocusNode = FocusNode();
  FocusNode scanBtnFocusNode = FocusNode();



  bool isBackPressed = false; // Track if the back button was pressed


  List<ULDDetailsList>?  uldDetailsList = [];


  late AnimationController _blinkController;
  late Animation<Color?> _colorAnimation;




  bool isInactivityDialogOpen = false; // Flag to track inactivity dialog state



  @override
  void initState() {
    super.initState();
  //  switchStates = List<bool>.filled(listValue.length, false);

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





  Future<void> leaveGroupIdFocus() async {

    // Skip the focus leave logic if inactivity dialog is open
    if (isInactivityDialogOpen) return;



    print("CHECK_GROUP_ID==== ${groupIdController.text}");

    if (groupIdController.text.isNotEmpty) {
      getDamagedULDSearch();
    }else{

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

    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(groupIdFocusNode);
    });

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
                                  WidgetsBinding.instance.addPostFrameCallback((_) {
                                    FocusScope.of(context).requestFocus(groupIdFocusNode);
                                  });
                                  // Reset UI
                                  setState(() {});
                                },
                              ),
                            ),

                            // start api responcer
                            BlocListener<DamagedULDCubit, DamagedULDState>(
                              listener: (context, state) async {
                                if (state is DamagedULDInitialState) {
                                }
                                else if (state is DamagedULDLoadingState) {
                                  // showing loading dialog in this state
                                  DialogUtils.showLoadingDialog(context, message: lableModel.loading);
                                }
                                else if(state is GetDamagedULDSearchSuccessState){
                                  DialogUtils.hideLoadingDialog(context);
                                  if(state.getDamagedULDSearchModel.status == "E"){
                                    Vibration.vibrate(duration: 500);
                                    SnackbarUtil.showSnackbar(context, state.getDamagedULDSearchModel.statusMessage!, MyColor.colorRed, icon: FontAwesomeIcons.times);
                                    uldDetailsList!.clear();
                                    WidgetsBinding.instance.addPostFrameCallback((_) {
                                      FocusScope.of(context).requestFocus(groupIdFocusNode);
                                    });
                                  }else{
                                    uldDetailsList = state.getDamagedULDSearchModel.uLDDetailsList;
                                    setState(() {

                                    });
                                  }
                                }
                                else if(state is GetDamagedULDSearchFailureState){
                                  DialogUtils.hideLoadingDialog(context);
                                  Vibration.vibrate(duration: 500);
                                  SnackbarUtil.showSnackbar(context, state.error, MyColor.colorRed, icon: FontAwesomeIcons.times);
                                  uldDetailsList!.clear();
                                  WidgetsBinding.instance.addPostFrameCallback((_) {
                                    FocusScope.of(context).requestFocus(groupIdFocusNode);
                                  });
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
                                                      flex : 1,
                                                      child: CustomTextField(
                                                        textDirection: textDirection,
                                                        controller: groupIdController,
                                                        focusNode: groupIdFocusNode,
                                                        onPress: () {},
                                                        hasIcon: false,
                                                        hastextcolor: true,
                                                        animatedLabel: true,
                                                        needOutlineBorder: true,
                                                        labelText: "${lableModel.scanuld} / ${lableModel.uldGroupId}",
                                                        readOnly: false,
                                                        maxLength: 30,
                                                        onChanged: (value) {
                                                          uldDetailsList!.clear();
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
                                                      focusNode: scanBtnFocusNode,
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
                                                padding: const EdgeInsets.all(10),
                                                child: (uldDetailsList!.isNotEmpty)
                                                    ? Column(
                                                  children: [

                                                    ListView.builder(
                                                      itemCount: (uldDetailsList!.isNotEmpty) ?  uldDetailsList!.length : 0,
                                                      physics: const NeverScrollableScrollPhysics(),
                                                      shrinkWrap: true,
                                                      controller: scrollController,
                                                      itemBuilder: (context, index) {
                                                        ULDDetailsList uldDetail = uldDetailsList![index];

                                                        return InkWell(
                                                            onTap: () {
                                                              FocusScope.of(context).unfocus();
                                                            },
                                                            onDoubleTap: () async {

                                                            },
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
                                                                                  ULDNumberWidget(uldNo: "${uldDetail.uLDNo}", smallFontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5, bigFontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_8, fontColor: MyColor.textColorGrey3, uldType: "U"),
                                                                                  SizedBox(width: SizeConfig.blockSizeHorizontal * SizeUtils.WIDTH2,),
                                                                                  (uldDetail.intact == "Y") ? Padding(
                                                                                    padding: const EdgeInsets.symmetric(horizontal: 2),
                                                                                    child:
                                                                                    Container(
                                                                                      width: SizeConfig.blockSizeVertical * SizeUtils.TEXTSIZE_2_2,  // Set width and height for the circle
                                                                                      decoration: BoxDecoration(
                                                                                        shape: BoxShape.circle,
                                                                                        border: Border.all(  // Add border
                                                                                          color: MyColor.primaryColorblue,  // Border color
                                                                                          width: 1.3,  // Border width
                                                                                        ),
                                                                                      ),
                                                                                      child: Center(
                                                                                        child: CustomeText(
                                                                                            text: "I",
                                                                                            fontColor: MyColor.primaryColorblue,
                                                                                            fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_3,
                                                                                            fontWeight: FontWeight.w500,
                                                                                            textAlign: TextAlign.center),
                                                                                      ),
                                                                                    ),
                                                                                  ) : SizedBox()
                                                                                ],
                                                                              ),
                                                                              const SizedBox(width: 5),
                                                                              Row(
                                                                                children: [
                                                                                  CustomeText(
                                                                                    text: "${lableModel.status} : ",
                                                                                    fontColor: MyColor.textColorGrey2,
                                                                                    fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5_5,
                                                                                    fontWeight: FontWeight.w400,
                                                                                    textAlign: TextAlign.start,
                                                                                  ),
                                                                                  SizedBox(width: SizeConfig.blockSizeHorizontal),
                                                                                  Container(
                                                                                    padding : EdgeInsets.symmetric(horizontal: SizeConfig.blockSizeHorizontal * 2.0, vertical: SizeConfig.blockSizeVertical * 0.2),
                                                                                    decoration : BoxDecoration(
                                                                                        borderRadius: BorderRadius.circular(20),
                                                                                        color: (uldDetail.status == "O" || uldDetail.status == "R") ? MyColor.flightFinalize : MyColor.flightNotArrived
                                                                                    ),
                                                                                    child: CustomeText(
                                                                                      text: (uldDetail.status == "O" || uldDetail.status == "R") ? "${lableModel.open}" : "${lableModel!.closed}",
                                                                                      fontColor: MyColor.textColorGrey3,
                                                                                      fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_6,
                                                                                      fontWeight: FontWeight.bold,
                                                                                      textAlign: TextAlign.center,
                                                                                    ),
                                                                                  ),
                                                                                ],
                                                                              ),

                                                                            ],
                                                                          ),
                                                                          SizedBox(height: SizeConfig.blockSizeVertical,),
                                                                          Row(
                                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                            children: [
                                                                              CustomeText(
                                                                                text: "${uldDetail.flightNo} / ${uldDetail.flightDate!.replaceAll(" ", "-")}",
                                                                                fontColor: MyColor.textColorGrey3,
                                                                                fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5_5,
                                                                                fontWeight: FontWeight.w600,
                                                                                textAlign: TextAlign.start,
                                                                              ),
                                                                              Row(
                                                                                children: [
                                                                                  CustomeText(
                                                                                    text: "${lableModel.scaleWt} :",
                                                                                    fontColor: MyColor.textColorGrey2,
                                                                                    fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5_5,
                                                                                    fontWeight: FontWeight.w400,
                                                                                    textAlign: TextAlign.start,
                                                                                  ),
                                                                                  const SizedBox(width: 5),
                                                                                  CustomeText(
                                                                                    text:  CommonUtils.formateToTwoDecimalPlacesValue(uldDetail.scaleWeight!),
                                                                                    fontColor: MyColor.textColorGrey3,
                                                                                    fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_7,
                                                                                    fontWeight:  FontWeight.w600,
                                                                                    textAlign: TextAlign.start,
                                                                                  ),
                                                                                ],
                                                                              ),

                                                                            ],
                                                                          ),
                                                                          SizedBox(height: SizeConfig.blockSizeVertical,),
                                                                          Row(
                                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                            children: [
                                                                              Row(
                                                                                children: [
                                                                                  CustomeText(
                                                                                    text: "Dest. :",
                                                                                    fontColor: MyColor.textColorGrey2,
                                                                                    fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5_5,
                                                                                    fontWeight:  FontWeight.w400,
                                                                                    textAlign: TextAlign.start,
                                                                                  ),
                                                                                  const SizedBox(width: 5),
                                                                                  CustomeText(
                                                                                    text: "${uldDetail.destination}",
                                                                                    fontColor: MyColor.textColorGrey3,
                                                                                    fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_7,
                                                                                    fontWeight:  FontWeight.w600,
                                                                                    textAlign: TextAlign.start,
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                              Row(
                                                                                children: [
                                                                                  CustomeText(
                                                                                    text: "Current Loc. :",
                                                                                    fontColor: MyColor.textColorGrey2,
                                                                                    fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5_5,
                                                                                    fontWeight:  FontWeight.w400,
                                                                                    textAlign: TextAlign.start,
                                                                                  ),
                                                                                  const SizedBox(width: 5),
                                                                                  CustomeText(
                                                                                    text: "${uldDetail.destination}",
                                                                                    fontColor: MyColor.textColorGrey3,
                                                                                    fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_7,
                                                                                    fontWeight:  FontWeight.w600,
                                                                                    textAlign: TextAlign.start,
                                                                                  ),
                                                                                ],
                                                                              ),



                                                                            ],
                                                                          ),
                                                                          SizedBox(height: SizeConfig.blockSizeVertical,),
                                                                          RoundedButtonBlue(text: "${lableModel.recordDamage}",
                                                                            press: () async {
                                                                              String damageOrNot = await Navigator.push(
                                                                                  context,
                                                                                  CupertinoPageRoute(
                                                                                    builder: (context) => UldDamagedPage(
                                                                                      importSubMenuList: widget.importSubMenuList,
                                                                                      exportSubMenuList: widget.exportSubMenuList,
                                                                                      locationCode: "",
                                                                                      menuId: widget.menuId,
                                                                                      ULDNo: uldDetail.uLDNo!,
                                                                                      ULDSeqNo: uldDetail.uLDSeqNo!,
                                                                                      flightSeqNo: uldDetail.flightSeqNo!,
                                                                                      groupId: "",
                                                                                      menuCode: widget.refrelCode,
                                                                                      isRecordView: 2,
                                                                                      mainMenuName: widget.mainMenuName,
                                                                                      buttonRightsList: const [],
                                                                                      flightType: uldDetail.flightType!,
                                                                                    ),
                                                                                  ));

                                                                              if(damageOrNot == "BUS"){
                                                                                getDamagedULDSearch();
                                                                              }
                                                                              else if(damageOrNot == "SER"){
                                                                                getDamagedULDSearch();
                                                                              }
                                                                              else{
                                                                                getDamagedULDSearch();
                                                                              }


                                                                            },),

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

                                              )
                                            )),
                                        SizedBox(height: SizeConfig.blockSizeVertical),


                                      ],
                                    ),
                                  ),
                                ),
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

  Future<void> scanGroupQR() async{
    String groupcodeScanResult =  await FlutterBarcodeScanner.scanBarcode(
      '#ff6666', // Color for the scanner overlay
      'Cancel', // Text for the cancel button
      true, // Enable flash option
      ScanMode.DEFAULT, // Scan mode
    );

    if(groupcodeScanResult == "-1"){
      WidgetsBinding.instance.addPostFrameCallback((_) {
        FocusScope.of(context).requestFocus(groupIdFocusNode);
      });
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
        String truncatedResult = result.length > 30
            ? result.substring(0, 30)
            : result;

        uldDetailsList!.clear();


        groupIdController.text = truncatedResult;

        getDamagedULDSearch();



      }

    }


  }





  Future<void> getDamagedULDSearch() async {

    await context.read<DamagedULDCubit>().getSearchDamagedULD(
        groupIdController.text,
        _user!.userProfile!.userIdentity!,
        _splashDefaultData!.companyCode!,
        widget.menuId);
  }






}

class TickerProviders extends TickerProvider {
  @override
  Ticker createTicker(onTick) => Ticker(onTick);
}

