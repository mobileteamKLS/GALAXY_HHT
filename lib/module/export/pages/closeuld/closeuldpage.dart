import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:galaxy/core/mycolor.dart';
import 'package:galaxy/module/export/pages/closeuld/closeuldequipmentpage.dart';
import 'package:galaxy/module/export/pages/closeuld/contouruldpage.dart';
import 'package:galaxy/module/export/pages/closeuld/remarkuldpage.dart';
import 'package:galaxy/module/export/pages/closeuld/scaleuldpage.dart';
import 'package:galaxy/module/export/services/closeuld/closeuldlogic/closeuldcubit.dart';
import 'package:galaxy/module/export/services/closeuld/closeuldlogic/closeuldstate.dart';
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
import '../../../../utils/uldvalidationutil.dart';
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
import '../../model/closeuld/closeuldsearchmodel.dart';

class CloseULDPage extends StatefulWidget {
  String mainMenuName;
  String title;
  String refrelCode;
  LableModel? lableModel;
  int menuId;
  List<SubMenuName> importSubMenuList = [];
  List<SubMenuName> exportSubMenuList = [];

  CloseULDPage(
      {super.key,
      required this.importSubMenuList,
      required this.exportSubMenuList,
      required this.title,
      required this.refrelCode,
      this.lableModel,
      required this.menuId,
      required this.mainMenuName});

  @override
  State<CloseULDPage> createState() => _CloseULDPageState();
}

class _CloseULDPageState extends State<CloseULDPage>{



  ULDDetailList? uldDetail;


  FocusNode equipmentBtnFocusNode = FocusNode();
  FocusNode contorBtnFocusNode = FocusNode();
  FocusNode scaleBtnFocusNode = FocusNode();
  FocusNode remarkBtnFocusNode = FocusNode();

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



  @override
  void initState() {
    super.initState();

    _loadUser(); //load user data

    scanULDFocusNode.addListener(() {
      if (!scanULDFocusNode.hasFocus && !isBackPressed) {
        leaveULDFocusNode();
      }
    });



  }


  Future<void> leaveULDFocusNode() async {
    if (scanULDController.text.isNotEmpty) {

      String uldNumber = UldValidationUtil.validateUldNumberwithSpace1(scanULDController.text.toUpperCase());
      if(uldNumber == "Valid"){

        callSearchApi(scanULDController.text);
      }
      else{
        SnackbarUtil.showSnackbar(context, "${widget.lableModel!.entervalidULDNo}", MyColor.colorRed, icon: FontAwesomeIcons.times);
        Vibration.vibrate(duration: 500);
        WidgetsBinding.instance.addPostFrameCallback((_) {
          FocusScope.of(context).requestFocus(scanULDFocusNode);
        });
      }


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
      FocusScope.of(context).requestFocus(scanULDFocusNode);
    });

    /*await context.read<EmptyULDTrolleyCubit>().emptyULDTrolleyPageLoad(
            _user!.userProfile!.userIdentity!,
            _splashDefaultData!.companyCode!,
            widget.menuId);*/

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
                                  scanULDController.clear();
                                  uldDetail = null;
                                  WidgetsBinding.instance.addPostFrameCallback((_) {
                                    FocusScope.of(context).requestFocus(scanULDFocusNode);
                                  });
                                  setState(() {

                                  });
                                },
                              ),
                            ),

                            // start api responcer
                            BlocListener<CloseULDCubit, CloseULDState>(
                              listener: (context, state) async {
                                if (state is CloseULDInitialState) {
                                }
                                else if (state is CloseULDLoadingState) {
                                  // showing loading dialog in this state
                                  DialogUtils.showLoadingDialog(context, message: lableModel.loading);
                                }
                                else if (state is CloseULDSearchSuccessState){
                                  DialogUtils.hideLoadingDialog(context);
                                  if(state.closeULDSearchModel.status == "E"){
                                    Vibration.vibrate(duration: 500);
                                    SnackbarUtil.showSnackbar(context, state.closeULDSearchModel.statusMessage!, MyColor.colorRed, icon: FontAwesomeIcons.times);
                                    WidgetsBinding.instance.addPostFrameCallback((_) {
                                      FocusScope.of(context).requestFocus(scanULDFocusNode);
                                    });
                                  }else{
                                    uldDetail = state.closeULDSearchModel.uLDDetailList![0];
                                    WidgetsBinding.instance.addPostFrameCallback((_) {
                                      FocusScope.of(context).requestFocus(scanULDBtnFocusNode);
                                    });
                                    setState(() {

                                    });
                                  }
                                }
                                else if (state is CloseULDSearchFailureState){
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
                                              SizedBox(height: SizeConfig.blockSizeVertical * 0.8,),
                                              Directionality(
                                                textDirection: textDirection,
                                                child: Row(
                                                  children: [
                                                    Expanded(
                                                      flex:1,
                                                      child: CustomTextField(
                                                        textDirection: textDirection,
                                                        controller: scanULDController,
                                                        focusNode: scanULDFocusNode,
                                                        onPress: () {},
                                                        hasIcon: false,
                                                        hastextcolor: true,
                                                        animatedLabel: true,
                                                        needOutlineBorder: true,
                                                        labelText: "${lableModel.scanuld} *",
                                                        readOnly: false,
                                                        maxLength: 11,
                                                        onChanged: (value) {

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
                                                      focusNode: scanULDBtnFocusNode,
                                                      onTap: () {
                                                        WidgetsBinding.instance.addPostFrameCallback((_) {
                                                          FocusScope.of(context).requestFocus(scanULDBtnFocusNode);
                                                        });
                                                        scanULDScanQR();
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
                                                      CustomeText(text: (uldDetail != null) ? uldDetail!.uLDNo! : "-", fontColor: MyColor.colorBlack, fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_8, fontWeight: FontWeight.w700, textAlign: TextAlign.start),
                                                    ],
                                                  ),
                                                  Row(
                                                    children: [
                                                      CustomeText(
                                                        text: "${lableModel.status} : ",
                                                        fontColor: MyColor.textColorGrey2,
                                                        fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                                        fontWeight: FontWeight.w400,
                                                        textAlign: TextAlign.start,
                                                      ),
                                                      const SizedBox(width: 5),
                                                      (uldDetail != null) ? Container(
                                                        padding : EdgeInsets.symmetric(horizontal: SizeConfig.blockSizeHorizontal * 2.0, vertical: SizeConfig.blockSizeVertical * 0.2),
                                                        decoration : BoxDecoration(
                                                            borderRadius: BorderRadius.circular(20),
                                                            color: (uldDetail!.uLDStatus == "O") ? MyColor.flightFinalize : MyColor.flightNotArrived
                                                        ),
                                                        child: CustomeText(
                                                          text: (uldDetail!.uLDStatus == "O") ? "${lableModel!.open}" : "${lableModel!.closed}",
                                                          fontColor: MyColor.textColorGrey3,
                                                          fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_6,
                                                          fontWeight: FontWeight.bold,
                                                          textAlign: TextAlign.center,
                                                        ),
                                                      ) : SizedBox(),
                                                    ],
                                                  ),

                                                ],
                                              ),
                                              SizedBox(height: SizeConfig.blockSizeVertical),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Expanded(
                                                    flex : 1,
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        children: [
                                                          CustomeText(
                                                            text: "Tare Wt. : ",
                                                            fontColor: MyColor.textColorGrey2,
                                                            fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                                            fontWeight: FontWeight.w500,
                                                            textAlign: TextAlign.start,
                                                          ),
                                                          const SizedBox(width: 5),
                                                          Row(
                                                            children: [
                                                              CustomeText(
                                                                text: (uldDetail != null) ? CommonUtils.formateToTwoDecimalPlacesValue(uldDetail!.tareWeight!): "-",
                                                                fontColor: MyColor.colorBlack,
                                                                fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                                                fontWeight: FontWeight.w700,
                                                                textAlign: TextAlign.start,
                                                              ),
                                                              CustomeText(
                                                                text: " Kg",
                                                                fontColor: MyColor.colorBlack,
                                                                fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                                                fontWeight: FontWeight.w700,
                                                                textAlign: TextAlign.start,
                                                              ),
                                                            ],
                                                          )

                                                        ],
                                                      ),
                                                        SizedBox(height: SizeConfig.blockSizeVertical),
                                                        Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        children: [
                                                          CustomeText(
                                                            text: "Net Wt. : ",
                                                            fontColor: MyColor.textColorGrey2,
                                                            fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                                            fontWeight: FontWeight.w500,
                                                            textAlign: TextAlign.start,
                                                          ),
                                                          const SizedBox(width: 5),
                                                          Row(
                                                            children: [
                                                              CustomeText(
                                                                text: (uldDetail != null) ? CommonUtils.formateToTwoDecimalPlacesValue(uldDetail!.netWeight!) : "-",
                                                                fontColor: MyColor.colorBlack,
                                                                fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                                                fontWeight: FontWeight.w700,
                                                                textAlign: TextAlign.start,
                                                              ),
                                                              CustomeText(
                                                                text: " Kg",
                                                                fontColor: MyColor.colorBlack,
                                                                fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                                                fontWeight: FontWeight.w700,
                                                                textAlign: TextAlign.start,
                                                              ),
                                                            ],
                                                          )

                                                        ],
                                                      ),
                                                        SizedBox(height: SizeConfig.blockSizeVertical),
                                                        Row(
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          children: [
                                                            CustomeText(
                                                              text: "Equip Wt. : ",
                                                              fontColor: MyColor.textColorGrey2,
                                                              fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                                              fontWeight: FontWeight.w500,
                                                              textAlign: TextAlign.start,
                                                            ),
                                                            const SizedBox(width: 5),
                                                            Row(
                                                              children: [
                                                                CustomeText(
                                                                  text: (uldDetail != null) ? CommonUtils.formateToTwoDecimalPlacesValue(uldDetail!.equipmentWeight!) : "-",
                                                                  fontColor: MyColor.colorBlack,
                                                                  fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                                                  fontWeight: FontWeight.w700,
                                                                  textAlign: TextAlign.start,
                                                                ),
                                                                CustomeText(
                                                                  text: " Kg",
                                                                  fontColor: MyColor.colorBlack,
                                                                  fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                                                  fontWeight: FontWeight.w700,
                                                                  textAlign: TextAlign.start,
                                                                ),
                                                              ],
                                                            )

                                                          ],
                                                        ),
                                                        SizedBox(height: SizeConfig.blockSizeVertical),
                                                        Row(
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          children: [
                                                            CustomeText(
                                                              text: "Scale Wt. : ",
                                                              fontColor: MyColor.textColorGrey2,
                                                              fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                                              fontWeight: FontWeight.w500,
                                                              textAlign: TextAlign.start,
                                                            ),
                                                            const SizedBox(width: 5),
                                                            Row(
                                                              children: [
                                                                CustomeText(
                                                                  text: (uldDetail != null) ? CommonUtils.formateToTwoDecimalPlacesValue(uldDetail!.scaleWeight!) : "-",
                                                                  fontColor: MyColor.colorBlack,
                                                                  fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                                                  fontWeight: FontWeight.w700,
                                                                  textAlign: TextAlign.start,
                                                                ),
                                                                CustomeText(
                                                                  text: " Kg",
                                                                  fontColor: MyColor.colorBlack,
                                                                  fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                                                  fontWeight: FontWeight.w700,
                                                                  textAlign: TextAlign.start,
                                                                ),
                                                              ],
                                                            )

                                                          ],
                                                        )
                                                    ],),
                                                  ),
                                                  SizedBox(width: SizeConfig.blockSizeHorizontal * SizeUtils.WIDTH6,),
                                                  Expanded(
                                                    flex : 1,
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Row(
                                                          mainAxisAlignment:MainAxisAlignment.spaceBetween,
                                                          children: [
                                                            CustomeText(
                                                              text: "Dev. : ",
                                                              fontColor: MyColor.textColorGrey2,
                                                              fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                                              fontWeight: FontWeight.w500,
                                                              textAlign: TextAlign.start,
                                                            ),
                                                            const SizedBox(width: 5),
                                                            CustomeText(
                                                              text: (uldDetail != null) ? "${uldDetail!.deviation!} Kg (${uldDetail!.deviationPer!} %)" : "-",
                                                              fontColor: MyColor.colorBlack,
                                                              fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                                              fontWeight: FontWeight.w700,
                                                              textAlign: TextAlign.start,
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(height: SizeConfig.blockSizeVertical),
                                                        Row(
                                                          mainAxisAlignment:MainAxisAlignment.spaceBetween,
                                                          children: [
                                                            CustomeText(
                                                              text: "Contour : ",
                                                              fontColor: MyColor.textColorGrey2,
                                                              fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                                              fontWeight: FontWeight.w500,
                                                              textAlign: TextAlign.start,
                                                            ),
                                                            const SizedBox(width: 5),
                                                            CustomeText(
                                                              text: (uldDetail != null) ? uldDetail!.contour! : "-",
                                                              fontColor: MyColor.colorBlack,
                                                              fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                                              fontWeight: FontWeight.w700,
                                                              textAlign: TextAlign.start,
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(height: SizeConfig.blockSizeVertical),
                                                        Row(
                                                          mainAxisAlignment:MainAxisAlignment.spaceBetween,
                                                          children: [
                                                            CustomeText(
                                                              text: "Equip. Count : ",
                                                              fontColor: MyColor.textColorGrey2,
                                                              fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                                              fontWeight: FontWeight.w500,
                                                              textAlign: TextAlign.start,
                                                            ),
                                                            const SizedBox(width: 5),
                                                            CustomeText(
                                                              text: (uldDetail != null) ? "${uldDetail!.equipmentCount!}" : "-",
                                                              fontColor: MyColor.colorBlack,
                                                              fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                                              fontWeight: FontWeight.w700,
                                                              textAlign: TextAlign.start,
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(height: SizeConfig.blockSizeVertical),
                                                        Row(
                                                          mainAxisAlignment:MainAxisAlignment.spaceBetween,
                                                          children: [
                                                            CustomeText(
                                                              text: "",
                                                              fontColor: MyColor.textColorGrey2,
                                                              fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                                              fontWeight: FontWeight.w500,
                                                              textAlign: TextAlign.start,
                                                            ),
                                                            const SizedBox(width: 5),
                                                            CustomeText(
                                                              text: "",
                                                              fontColor: MyColor.colorBlack,
                                                              fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                                              fontWeight: FontWeight.w700,
                                                              textAlign: TextAlign.start,
                                                            ),
                                                          ],
                                                        ),
                                                      ],),
                                                  ),
                                                ],
                                              ),






                                            ],
                                          ),
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
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [

                                              Row(
                                                children: [
                                                  CustomeText(
                                                    text: "Flight No. : ",
                                                    fontColor: MyColor.textColorGrey2,
                                                    fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                                    fontWeight: FontWeight.w500,
                                                    textAlign: TextAlign.start,
                                                  ),
                                                  const SizedBox(width: 5),
                                                  CustomeText(
                                                    text: (uldDetail != null) ? "${uldDetail!.flightNo} / ${uldDetail!.flightDate!.replaceAll(" ", "-")}" : "-",
                                                    fontColor: MyColor.colorBlack,
                                                    fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                                    fontWeight: FontWeight.w700,
                                                    textAlign: TextAlign.start,
                                                  )

                                                ],
                                              ),
                                              SizedBox(height: SizeConfig.blockSizeVertical),
                                              Row(
                                                children: [
                                                  CustomeText(
                                                    text: "Off Point : ",
                                                    fontColor: MyColor.textColorGrey2,
                                                    fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                                    fontWeight: FontWeight.w500,
                                                    textAlign: TextAlign.start,
                                                  ),
                                                  const SizedBox(width: 5),
                                                  CustomeText(
                                                    text: (uldDetail != null) ? "${uldDetail!.uLDOffPoint}" : "-",
                                                    fontColor: MyColor.colorBlack,
                                                    fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                                    fontWeight: FontWeight.w700,
                                                    textAlign: TextAlign.start,
                                                  )

                                                ],
                                              ),
                                              SizedBox(height: SizeConfig.blockSizeVertical),
                                              Row(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  CustomeText(
                                                    text: "Remarks : ",
                                                    fontColor: MyColor.textColorGrey2,
                                                    fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                                    fontWeight: FontWeight.w500,
                                                    textAlign: TextAlign.start,
                                                  ),
                                                  const SizedBox(width: 5),
                                                  Flexible(
                                                    child: CustomeText(
                                                      text: (uldDetail != null) ? "${uldDetail!.remarks}" : "-",
                                                      fontColor: MyColor.colorBlack,
                                                      fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                                      fontWeight: FontWeight.w700,
                                                      textAlign: TextAlign.start,
                                                    ),
                                                  ),
                                                ],
                                              ),

                                            ],
                                          ),
                                        ),

                                        SizedBox(height: SizeConfig.blockSizeVertical),
                                        Padding(
                                          padding: const EdgeInsets.only(top: 10, right:0, left: 0, bottom: 0),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                flex: 1,
                                                child: RoundedButtonBlue(
                                                  focusNode: equipmentBtnFocusNode,
                                                  text: "Equipment",
                                                  verticalPadding: SizeConfig.blockSizeVertical * SizeUtils.HEIGHT3,
                                                  textSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_2_0,
                                                  press: () {
                                                    scanULDFocusNode.unfocus();
                                                    scanULDBtnFocusNode.unfocus();
                                                   if(uldDetail != null){
                                                     Navigator.push(context, CupertinoPageRoute(builder: (context) => CloseULDEquipmentPage(
                                                       importSubMenuList: widget.importSubMenuList,
                                                       exportSubMenuList: widget.exportSubMenuList,
                                                       title: "Equipment",
                                                       refrelCode: widget.refrelCode,
                                                       menuId: widget.menuId,
                                                       mainMenuName: widget.mainMenuName,
                                                       uldNo: uldDetail!.uLDNo!,
                                                       uldType: "U",
                                                       uldSeqNo: uldDetail!.uLDSeqNo!,
                                                       flightSeqNo : uldDetail!.flightSeqNo!
                                                     ),));
                                                   }else{
                                                     SnackbarUtil.showSnackbar(context, "Please scan ULD/Trolley.", MyColor.colorRed, icon: FontAwesomeIcons.times);
                                                     WidgetsBinding.instance.addPostFrameCallback((_) {
                                                       FocusScope.of(context).requestFocus(scanULDFocusNode);
                                                     });
                                                   }

                                                  },
                                                ),
                                              ),
                                              SizedBox(width: SizeConfig.blockSizeHorizontal * SizeUtils.HEIGHT7,),
                                              Expanded(
                                                flex: 1,
                                                child: RoundedButtonBlue(
                                                  focusNode: contorBtnFocusNode,
                                                  verticalPadding: SizeConfig.blockSizeVertical * SizeUtils.HEIGHT3,
                                                  textSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_2_0,
                                                  text: "Contour",
                                                  press: () {
                                                    scanULDFocusNode.unfocus();
                                                    scanULDBtnFocusNode.unfocus();
                                                    if(uldDetail != null){
                                                      Navigator.push(context, CupertinoPageRoute(builder: (context) => ContourULDPage(
                                                          importSubMenuList: widget.importSubMenuList,
                                                          exportSubMenuList: widget.exportSubMenuList,
                                                          title: "Contour",
                                                          refrelCode: widget.refrelCode,
                                                          menuId: widget.menuId,
                                                          mainMenuName: widget.mainMenuName,
                                                          uldNo: uldDetail!.uLDNo!,
                                                          uldType: "U",
                                                          uldSeqNo: uldDetail!.uLDSeqNo!,
                                                      ),));
                                                    }else{
                                                      SnackbarUtil.showSnackbar(context, "Please scan ULD/Trolley.", MyColor.colorRed, icon: FontAwesomeIcons.times);
                                                      WidgetsBinding.instance.addPostFrameCallback((_) {
                                                        FocusScope.of(context).requestFocus(scanULDFocusNode);
                                                      });
                                                    }
                                                  },
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(top: 12, right:0, left:0, bottom: 0),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                flex: 1,
                                                child: RoundedButtonBlue(
                                                  focusNode: scaleBtnFocusNode,
                                                  verticalPadding: SizeConfig.blockSizeVertical * SizeUtils.HEIGHT3,
                                                  textSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_2_0,
                                                  text: "Scale",
                                                  press: () {
                                                    scanULDFocusNode.unfocus();
                                                    scanULDBtnFocusNode.unfocus();
                                                    if(uldDetail != null){
                                                      Navigator.push(context, CupertinoPageRoute(builder: (context) => ScaleULDPage(
                                                          importSubMenuList: widget.importSubMenuList,
                                                          exportSubMenuList: widget.exportSubMenuList,
                                                          title: "Scale", refrelCode: widget.refrelCode,
                                                          menuId: widget.menuId,
                                                          mainMenuName: widget.mainMenuName,
                                                          uldNo: uldDetail!.uLDNo!,
                                                          uldType: "U",
                                                          uldSeqNo: uldDetail!.uLDSeqNo!,
                                                      ),));
                                                    }else{
                                                      SnackbarUtil.showSnackbar(context, "Please scan ULD/Trolley.", MyColor.colorRed, icon: FontAwesomeIcons.times);
                                                      WidgetsBinding.instance.addPostFrameCallback((_) {
                                                        FocusScope.of(context).requestFocus(scanULDFocusNode);
                                                      });
                                                    }


                                                  },
                                                ),
                                              ),
                                              SizedBox(width: SizeConfig.blockSizeHorizontal * SizeUtils.HEIGHT7,),
                                              Expanded(
                                                flex: 1,
                                                child: RoundedButtonBlue(
                                                  focusNode: remarkBtnFocusNode,
                                                  verticalPadding: SizeConfig.blockSizeVertical * SizeUtils.HEIGHT3,
                                                  textSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_2_0,
                                                  text: "Remarks",
                                                  press: () {
                                                    scanULDFocusNode.unfocus();
                                                    scanULDBtnFocusNode.unfocus();
                                                    if(uldDetail != null){
                                                      Navigator.push(context, CupertinoPageRoute(builder: (context) => RemarkULDPage(
                                                          importSubMenuList: widget.importSubMenuList,
                                                          exportSubMenuList: widget.exportSubMenuList,
                                                          title: "Remarks", refrelCode: widget.refrelCode,
                                                          menuId: widget.menuId,
                                                          mainMenuName: widget.mainMenuName,
                                                          uldNo: uldDetail!.uLDNo!,
                                                          uldType: "U",
                                                          uldSeqNo: uldDetail!.uLDSeqNo!,
                                                      ),));
                                                    }else{
                                                      SnackbarUtil.showSnackbar(context, "Please scan ULD/Trolley.", MyColor.colorRed, icon: FontAwesomeIcons.times);
                                                      WidgetsBinding.instance.addPostFrameCallback((_) {
                                                        FocusScope.of(context).requestFocus(scanULDFocusNode);
                                                      });
                                                    }

                                                  },
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(height: SizeConfig.blockSizeVertical * SizeUtils.HEIGHT2),
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
                                                text: "Close",
                                                press: () {

                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
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



  Future<void> scanULDScanQR() async{
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
        // unloadUldListModel = null;
        SnackbarUtil.showSnackbar(context, "${widget.lableModel!.onlyAlphaNumericValueMsg}", MyColor.colorRed, icon: FontAwesomeIcons.times);
        Vibration.vibrate(duration: 500);
        scanULDController.clear();
        WidgetsBinding.instance.addPostFrameCallback((_) {
          FocusScope.of(context).requestFocus(scanULDFocusNode);
        });
      }else{
        // unloadUldListModel = null;
        String result = groupcodeScanResult.replaceAll(" ", "");
        scanULDController.text = result;
        String uldNumber = UldValidationUtil.validateUldNumberwithSpace1(scanULDController.text.toUpperCase());
        if(uldNumber == "Valid"){
          setState(() {
            String uldNumbes = CommonUtils.ULDNUMBERCEHCK;
            List<String> parts = uldNumbes.split(' ');
            // call search api
            callSearchApi(scanULDController.text);

          });
        }
        else{
          scanULDController.clear();
          SnackbarUtil.showSnackbar(context, "${widget.lableModel!.entervalidULDNo}", MyColor.colorRed, icon: FontAwesomeIcons.times);
          Vibration.vibrate(duration: 500);
          WidgetsBinding.instance.addPostFrameCallback((_) {
            FocusScope.of(context).requestFocus(scanULDFocusNode);
          });
        }

      }
    }
  }


  Future<void> callSearchApi(String scanNo) async {
    await context.read<CloseULDCubit>().closeULDSearchModel(
        scanNo,
        _user!.userProfile!.userIdentity!,
        _splashDefaultData!.companyCode!,
        widget.menuId);
  }
}

