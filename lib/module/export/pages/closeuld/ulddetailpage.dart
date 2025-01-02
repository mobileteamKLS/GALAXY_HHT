import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:galaxy/core/mycolor.dart';
import 'package:galaxy/utils/sizeutils.dart';
import 'package:vibration/vibration.dart';
import '../../../../../../widget/customeuiwidgets/header.dart';
import '../../../../core/images.dart';
import '../../../../language/appLocalizations.dart';
import '../../../../language/model/lableModel.dart';
import '../../../../manager/timermanager.dart';
import '../../../../prefrence/savedprefrence.dart';
import '../../../../utils/awbformatenumberutils.dart';
import '../../../../utils/commonutils.dart';
import '../../../../utils/dialogutils.dart';
import '../../../../utils/snackbarutil.dart';
import '../../../../widget/customdivider.dart';
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
import '../../model/closeuld/getdocumentlistmodel.dart';
import '../../services/closeuld/closeuldlogic/closeuldcubit.dart';
import '../../services/closeuld/closeuldlogic/closeuldstate.dart';

class ULDDetailPage extends StatefulWidget {
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

  ULDDetailPage(
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
        required this.uldType
      });

  @override
  State<ULDDetailPage> createState() => _ULDDetailPageState();
}

class _ULDDetailPageState extends State<ULDDetailPage>{


  GetDocumentListModel? getDocumentListModel;
  List<AirWaybillDetail> airWaybillDetail = [];
  List<MailDetail> mailDetail = [];
  List<CourierDetail> courierDetail = [];

  double totalAirwayBillWeight = 0.00;
  double totalAirwayBillVolume = 0.00;

  double totalMailWeight = 0.00;
  double totalMailVolume = 0.00;

  double totalCourierWeight = 0.00;
  double totalCourierVolume = 0.00;

  double totalScaleWeight = 0.00;


  InactivityTimerManager? inactivityTimerManager;
  final SavedPrefrence savedPrefrence = SavedPrefrence();
  UserDataModel? _user;
  SplashDefaultModel? _splashDefaultData;
  final ScrollController scrollController = ScrollController();





  bool isBackPressed = false; // Track if the back button was pressed

  bool isInactivityDialogOpen = false; // Flag to track inactivity dialog state


  int? selectedSwitchIndex;




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

    getDocumentList();
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
                                clearText: "",
                                //add clear text to clear all feild
                                onClear: () {

                                },
                              ),
                            ),

                            // start api responcer

                            BlocListener<CloseULDCubit, CloseULDState>(
                              listener: (context, state) async {
                                if (state is CloseULDInitialState) {}
                                else if (state is CloseULDLoadingState) {
                                  // showing loading dialog in this state
                                  DialogUtils.showLoadingDialog(context, message: lableModel!.loading);
                                }
                                else if (state is GetDocumentListSuccessState){
                                  DialogUtils.hideLoadingDialog(context);
                                  if(state.getDocumentListModel.status == "E"){
                                    Vibration.vibrate(duration: 500);
                                    SnackbarUtil.showSnackbar(context, state.getDocumentListModel.statusMessage!, MyColor.colorRed, icon: FontAwesomeIcons.times);
                                  }else{

                                    getDocumentListModel = state.getDocumentListModel;
                                    airWaybillDetail = getDocumentListModel!.airWaybillDetail!;
                                    mailDetail = getDocumentListModel!.mailDetail!;
                                    courierDetail = getDocumentListModel!.courierDetail!;


                                    totalAirwayBillWeight = airWaybillDetail.fold(0.0, (sum, item) {
                                      return sum + (item.weight ?? 0.0);
                                    });
                                    totalAirwayBillVolume = airWaybillDetail.fold(0.0, (sum, item) {
                                      return sum + (item.volume ?? 0.0);
                                    });

                                    totalMailWeight = mailDetail.fold(0.0, (sum, item) {
                                      return sum + (item.weight ?? 0.0);
                                    });
                                    totalMailVolume = mailDetail.fold(0.0, (sum, item) {
                                      return sum + (item.volume ?? 0.0);
                                    });

                                    totalCourierWeight = courierDetail.fold(0.0, (sum, item) {
                                      return sum + (item.weight ?? 0.0);
                                    });

                                    totalCourierVolume = courierDetail.fold(0.0, (sum, item) {
                                      return sum + (item.volume ?? 0.0);
                                    });

                                    totalScaleWeight = (totalAirwayBillWeight + totalMailWeight + totalCourierWeight);


                                    setState(() {

                                    });

                                    // responce

                                  }
                                }
                                else if (state is GetDocumentListFailureState){
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
                                                      CustomeText(
                                                          text: "${widget.uldNo}",
                                                          fontColor: MyColor.textColorGrey2,
                                                          fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_6,
                                                          fontWeight: FontWeight.w700,
                                                          textAlign: TextAlign.start)
                                                    ],
                                                  ),
                                                ),
                                                SizedBox(height: SizeConfig.blockSizeVertical),
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    CustomeText(
                                                      text: "ULD Tare Weight : ",
                                                      fontColor: MyColor.textColorGrey2,
                                                      fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                                      fontWeight: FontWeight.w500,
                                                      textAlign: TextAlign.start,
                                                    ),
                                                    const SizedBox(width: 5),
                                                    Row(
                                                      children: [
                                                        CustomeText(
                                                          text: (getDocumentListModel != null) ? getDocumentListModel!.uLDDetails![0].uLDTareWeight! : "-",
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
                                                      text: "ULD Net Weight : ",
                                                      fontColor: MyColor.textColorGrey2,
                                                      fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                                      fontWeight: FontWeight.w500,
                                                      textAlign: TextAlign.start,
                                                    ),
                                                    const SizedBox(width: 5),
                                                    Row(
                                                      children: [
                                                        CustomeText(
                                                          text: "$totalScaleWeight",
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
                                                    Expanded(
                                                      flex : 3,
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [

                                                          CustomeText(
                                                            text: "Document No.",
                                                            fontColor: MyColor.textColorGrey3,
                                                            fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_6,
                                                            fontWeight: FontWeight.w700,
                                                            textAlign: TextAlign.start,
                                                          ),
                                                        ],),
                                                    ),
                                                    Expanded(
                                                      flex :2,
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                        children: [
                                                          CustomeText(
                                                            text: "Weight",
                                                            fontColor: MyColor.textColorGrey3,
                                                            fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_6,
                                                            fontWeight: FontWeight.w700,
                                                            textAlign: TextAlign.start,
                                                          ),

                                                        ],),
                                                    ),
                                                    Expanded(
                                                      flex : 2,
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                        children: [

                                                          CustomeText(
                                                            text: "Vol. (m\u00B3)",
                                                            fontColor: MyColor.textColorGrey3,
                                                            fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_6,
                                                            fontWeight: FontWeight.w700,
                                                            textAlign: TextAlign.start,
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
                                                CustomeText(
                                                    text: "Air Waybill",
                                                    fontColor: MyColor.textColorGrey3,
                                                    fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_8,
                                                    fontWeight: FontWeight.w700,
                                                    textAlign: TextAlign.start),
                                                SizedBox(height: SizeConfig.blockSizeVertical * 0.8),
                                                ListView.builder(
                                                  itemCount: airWaybillDetail.length,
                                                  shrinkWrap: true,
                                                  physics: const NeverScrollableScrollPhysics(),
                                                  itemBuilder: (context, index) {
                                                    AirWaybillDetail content = airWaybillDetail![index];
                                                    return Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        Expanded(
                                                          flex : 3,
                                                          child: Column(
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              CustomeText(
                                                                text: AwbFormateNumberUtils.formatAWBNumber(content.aWBNo!),
                                                                fontColor: MyColor.textColorGrey2,
                                                                fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                                                fontWeight: FontWeight.w500,
                                                                textAlign: TextAlign.start,
                                                              ),
                                                            ],),
                                                        ),
                                                        Expanded(
                                                          flex :2,
                                                          child: Column(
                                                            crossAxisAlignment: CrossAxisAlignment.center,
                                                            children: [
                                                              CustomeText(
                                                                text: CommonUtils.formateToTwoDecimalPlacesValue(content.weight!),
                                                                fontColor: MyColor.textColorGrey2,
                                                                fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                                                fontWeight: FontWeight.w500,
                                                                textAlign: TextAlign.start,
                                                              ),

                                                            ],),
                                                        ),
                                                        Expanded(
                                                          flex : 2,
                                                          child: Column(
                                                            crossAxisAlignment: CrossAxisAlignment.center,
                                                            children: [
                                                              CustomeText(
                                                                text: CommonUtils.formateToTwoDecimalPlacesValue(content.volume!),
                                                                fontColor: MyColor.textColorGrey2,
                                                                fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                                                fontWeight: FontWeight.w500,
                                                                textAlign: TextAlign.start,
                                                              ),


                                                            ],),
                                                        ),
                                                      ],
                                                    );
                                                  },
                                                ),

                                                SizedBox(height: SizeConfig.blockSizeVertical * 0.8),
                                                CustomDivider(space: 0, color: Colors.black, hascolor: true,),
                                                SizedBox(height: SizeConfig.blockSizeVertical * 0.8),
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Expanded(
                                                      flex : 3,
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [

                                                          CustomeText(
                                                            text: "Total",
                                                            fontColor: MyColor.textColorGrey3,
                                                            fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                                            fontWeight: FontWeight.w500,
                                                            textAlign: TextAlign.start,
                                                          ),
                                                        ],),
                                                    ),
                                                    Expanded(
                                                      flex :2,
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                        children: [
                                                          CustomeText(
                                                            text: CommonUtils.formateToTwoDecimalPlacesValue(totalAirwayBillWeight),
                                                            fontColor: MyColor.textColorGrey3,
                                                            fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                                            fontWeight: FontWeight.w500,
                                                            textAlign: TextAlign.start,
                                                          ),

                                                        ],),
                                                    ),
                                                    Expanded(
                                                      flex : 2,
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                        children: [

                                                          CustomeText(
                                                            text: CommonUtils.formateToTwoDecimalPlacesValue(totalAirwayBillVolume),
                                                            fontColor: MyColor.textColorGrey3,
                                                            fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                                            fontWeight: FontWeight.w500,
                                                            textAlign: TextAlign.start,
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
                                                CustomeText(
                                                    text: "Mail",
                                                    fontColor: MyColor.textColorGrey3,
                                                    fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_8,
                                                    fontWeight: FontWeight.w700,
                                                    textAlign: TextAlign.start),
                                                SizedBox(height: SizeConfig.blockSizeVertical * 0.8),
                                                ListView.builder(
                                                  itemCount: mailDetail.length,
                                                  shrinkWrap: true,
                                                  physics: const NeverScrollableScrollPhysics(),
                                                  itemBuilder: (context, index) {
                                                    MailDetail content = mailDetail![index];
                                                    return Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        Expanded(
                                                          flex : 3,
                                                          child: Column(
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              CustomeText(
                                                                text: content.docNo!,
                                                                fontColor: MyColor.textColorGrey2,
                                                                fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                                                fontWeight: FontWeight.w500,
                                                                textAlign: TextAlign.start,
                                                              ),
                                                            ],),
                                                        ),
                                                        Expanded(
                                                          flex :2,
                                                          child: Column(
                                                            crossAxisAlignment: CrossAxisAlignment.center,
                                                            children: [
                                                              CustomeText(
                                                                text: CommonUtils.formateToTwoDecimalPlacesValue(content.weight!),
                                                                fontColor: MyColor.textColorGrey2,
                                                                fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                                                fontWeight: FontWeight.w500,
                                                                textAlign: TextAlign.start,
                                                              ),

                                                            ],),
                                                        ),
                                                        Expanded(
                                                          flex : 2,
                                                          child: Column(
                                                            crossAxisAlignment: CrossAxisAlignment.center,
                                                            children: [
                                                              CustomeText(
                                                                text: CommonUtils.formateToTwoDecimalPlacesValue(content.volume!),
                                                                fontColor: MyColor.textColorGrey2,
                                                                fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                                                fontWeight: FontWeight.w500,
                                                                textAlign: TextAlign.start,
                                                              ),


                                                            ],),
                                                        ),
                                                      ],
                                                    );
                                                  },
                                                ),
                                                SizedBox(height: SizeConfig.blockSizeVertical * 0.8),
                                                CustomDivider(space: 0, color: Colors.black, hascolor: true,),
                                                SizedBox(height: SizeConfig.blockSizeVertical * 0.8),
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Expanded(
                                                      flex : 3,
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [

                                                          CustomeText(
                                                            text: "Total",
                                                            fontColor: MyColor.textColorGrey3,
                                                            fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                                            fontWeight: FontWeight.w500,
                                                            textAlign: TextAlign.start,
                                                          ),
                                                        ],),
                                                    ),
                                                    Expanded(
                                                      flex :2,
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                        children: [
                                                          CustomeText(
                                                            text: CommonUtils.formateToTwoDecimalPlacesValue(totalMailWeight),
                                                            fontColor: MyColor.textColorGrey3,
                                                            fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                                            fontWeight: FontWeight.w500,
                                                            textAlign: TextAlign.start,
                                                          ),

                                                        ],),
                                                    ),
                                                    Expanded(
                                                      flex : 2,
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                        children: [

                                                          CustomeText(
                                                            text: CommonUtils.formateToTwoDecimalPlacesValue(totalMailVolume),
                                                            fontColor: MyColor.textColorGrey3,
                                                            fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                                            fontWeight: FontWeight.w500,
                                                            textAlign: TextAlign.start,
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
                                                CustomeText(
                                                    text: "Courier",
                                                    fontColor: MyColor.textColorGrey3,
                                                    fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_8,
                                                    fontWeight: FontWeight.w700,
                                                    textAlign: TextAlign.start),
                                                SizedBox(height: SizeConfig.blockSizeVertical * 0.8),
                                                ListView.builder(
                                                  itemCount: courierDetail.length,
                                                  shrinkWrap: true,
                                                  physics: const NeverScrollableScrollPhysics(),
                                                  itemBuilder: (context, index) {
                                                    CourierDetail content = courierDetail[index];
                                                    return Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        Expanded(
                                                          flex : 3,
                                                          child: Column(
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              CustomeText(
                                                                text: AwbFormateNumberUtils.formatAWBNumber(content.docNo!),
                                                                fontColor: MyColor.textColorGrey2,
                                                                fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                                                fontWeight: FontWeight.w500,
                                                                textAlign: TextAlign.start,
                                                              ),
                                                            ],),
                                                        ),
                                                        Expanded(
                                                          flex :2,
                                                          child: Column(
                                                            crossAxisAlignment: CrossAxisAlignment.center,
                                                            children: [
                                                              CustomeText(
                                                                text: CommonUtils.formateToTwoDecimalPlacesValue(content.weight!),
                                                                fontColor: MyColor.textColorGrey2,
                                                                fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                                                fontWeight: FontWeight.w500,
                                                                textAlign: TextAlign.start,
                                                              ),

                                                            ],),
                                                        ),
                                                        Expanded(
                                                          flex : 2,
                                                          child: Column(
                                                            crossAxisAlignment: CrossAxisAlignment.center,
                                                            children: [
                                                              CustomeText(
                                                                text: CommonUtils.formateToTwoDecimalPlacesValue(content.volume!),
                                                                fontColor: MyColor.textColorGrey2,
                                                                fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                                                fontWeight: FontWeight.w500,
                                                                textAlign: TextAlign.start,
                                                              ),


                                                            ],),
                                                        ),
                                                      ],
                                                    );
                                                  },
                                                ),
                                                SizedBox(height: SizeConfig.blockSizeVertical * 0.8),
                                                CustomDivider(space: 0, color: Colors.black, hascolor: true,),
                                                SizedBox(height: SizeConfig.blockSizeVertical * 0.8),
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Expanded(
                                                      flex : 3,
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [

                                                          CustomeText(
                                                            text: "Total",
                                                            fontColor: MyColor.textColorGrey3,
                                                            fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                                            fontWeight: FontWeight.w500,
                                                            textAlign: TextAlign.start,
                                                          ),
                                                        ],),
                                                    ),
                                                    Expanded(
                                                      flex :2,
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                        children: [
                                                          CustomeText(
                                                            text: CommonUtils.formateToTwoDecimalPlacesValue(totalCourierWeight),
                                                            fontColor: MyColor.textColorGrey3,
                                                            fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                                            fontWeight: FontWeight.w500,
                                                            textAlign: TextAlign.start,
                                                          ),

                                                        ],),
                                                    ),
                                                    Expanded(
                                                      flex : 2,
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                        children: [

                                                          CustomeText(
                                                            text: CommonUtils.formateToTwoDecimalPlacesValue(totalCourierVolume),
                                                            fontColor: MyColor.textColorGrey3,
                                                            fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                                            fontWeight: FontWeight.w500,
                                                            textAlign: TextAlign.start,
                                                          ),

                                                        ],),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),


                                        ],
                                      ),
                                    ),
                                  )),
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


  Future<void> getDocumentList() async {
    await context.read<CloseULDCubit>().getDocumentList(
        widget.uldSeqNo,
        _user!.userProfile!.userIdentity!,
        _splashDefaultData!.companyCode!,
        widget.menuId);
  }





}

