import 'package:dashed_circular_progress_bar/dashed_circular_progress_bar.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:galaxy/module/export/services/airsiderelease/airsidelogic/airsidereleasecubit.dart';
import 'package:galaxy/module/export/services/airsiderelease/airsidelogic/airsidereleasestate.dart';
import 'package:galaxy/utils/snackbarutil.dart';
import 'package:galaxy/widget/customdivider.dart';
import 'package:galaxy/widget/customebuttons/roundbuttonblue.dart';
import 'package:galaxy/widget/customedrawer/customedrawer.dart';
import 'package:vibration/vibration.dart';

import '../../../../core/images.dart';
import '../../../../core/mycolor.dart';
import '../../../../language/appLocalizations.dart';
import '../../../../language/model/lableModel.dart';
import '../../../../manager/timermanager.dart';
import '../../../../prefrence/savedprefrence.dart';
import '../../../../utils/awbformatenumberutils.dart';
import '../../../../utils/commonutils.dart';
import '../../../../utils/dialogutils.dart';
import '../../../../utils/sizeutils.dart';
import '../../../../widget/custometext.dart';
import '../../../../widget/customeuiwidgets/header.dart';
import '../../../../widget/customtextfield.dart';
import '../../../../widget/groupidcustomtextfield.dart';
import '../../../../widget/header/mainheadingwidget.dart';
import '../../../../widget/roundbutton.dart';
import '../../../import/model/uldacceptance/buttonrolesrightsmodel.dart';
import '../../../login/model/userlogindatamodel.dart';
import '../../../login/pages/signinscreenmethods.dart';
import '../../../onboarding/sizeconfig.dart';
import 'dart:ui' as ui;

import '../../../profile/page/profilepagescreen.dart';
import '../../../splash/model/splashdefaultmodel.dart';
import '../../../submenu/model/submenumodel.dart';
import '../../model/airsiderelease/airsideshipmentlistmodel.dart';


class AirsideShipmentListPage extends StatefulWidget {

  List<ButtonRight> buttonRightsList;
  String location;
  String mainMenuName;
  String uldNo;
  int flightSeqNo;
  int uldSeqNo;
  int menuId;
  LableModel lableModel;
  String uldType;
  List<SubMenuName> importSubMenuList = [];
  List<SubMenuName> exportSubMenuList = [];

  AirsideShipmentListPage({super.key,
    required this.importSubMenuList,
    required this.exportSubMenuList,
    required this.buttonRightsList,
    required this.uldNo,
    required this.uldType,
    required this.mainMenuName,
    required this.flightSeqNo,
    required this.uldSeqNo,
    required this.menuId,
    required this.location,
    required this.lableModel,
  });

  @override
  State<AirsideShipmentListPage> createState() => _AirsideShipmentListPageState();
}

class _AirsideShipmentListPageState extends State<AirsideShipmentListPage> with SingleTickerProviderStateMixin{
  InactivityTimerManager? inactivityTimerManager;
  final SavedPrefrence savedPrefrence = SavedPrefrence();
  UserDataModel? _user;
  SplashDefaultModel? _splashDefaultData;


  List<AirsideReleaseAWBDetailList> awbItemList = [];
  List<AirsideReleaseAWBDetailList> filterAWBDetailsList = [];


  AirsideShipmentListModel? awbModel;

  final ScrollController scrollController = ScrollController();
  FocusNode awbFocusNode = FocusNode();

  TextEditingController scanNoEditingController = TextEditingController();
  FocusNode scanAwbFocusNode = FocusNode();


  late AnimationController _blinkController;
  late Animation<Color?> _colorAnimation;

  int? _selectedIndex;

  int? _isExpandedDetails;

  final ValueNotifier<double> _valueNotifier = ValueNotifier(0);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadUser(); //load user data


    _blinkController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: TickerProviders(), // Manually providing Ticker
    )..repeat(reverse: true); // Loop the animation

    _colorAnimation = ColorTween(
      begin: MyColor.shcColorList[0],
      end: Colors.transparent,
    ).animate(_blinkController); // color animation

  }


  Future<void> _loadUser() async {
    final user = await savedPrefrence.getUserData();
    final splashDefaultData = await savedPrefrence.getSplashDefaultData();
    if (user != null && splashDefaultData != null) {
      setState(() {
        _user = user;
        _splashDefaultData = splashDefaultData;
      });


      context.read<AirSideReleaseCubit>().getAirsideShipmentList(widget.flightSeqNo, widget.uldSeqNo, widget.uldType, _user!.userProfile!.userIdentity!, _splashDefaultData!.companyCode!, widget.menuId);

      inactivityTimerManager = InactivityTimerManager(
        context: context,
        timeoutMinutes: _splashDefaultData!.activeLoginTime!,  // Set the desired inactivity time here
        onTimeout: _handleInactivityTimeout,  // Define what happens when timeout occurs
      );
      inactivityTimerManager?.startTimer();

    }



  }

  Future<void> _handleInactivityTimeout() async {

    bool? activateORNot = await DialogUtils.showingActivateTimerDialog(context, _user!.userProfile!.userId!, _splashDefaultData!.companyCode!);
    print("CHECK_ACTIVATE_OR_NOT FLIGHT_CHECK====== ${activateORNot}");
    if(activateORNot == true){
      inactivityTimerManager!.resetTimer();
    }else{
      _logoutUser();
    }

  }
  Future<void> _logoutUser() async {
    await savedPrefrence.logout();
    Navigator.pushAndRemoveUntil(
      context, CupertinoPageRoute(builder: (context) => const SignInScreenMethod(),), (route) => false,
    );
  }

  void _resumeTimerOnInteraction() {
    inactivityTimerManager?.resetTimer();
    print('Activity detected, timer reset');
  }

  Future<bool> _onWillPop() async {
    FocusScope.of(context).unfocus();

    Navigator.pop(context, "Done");

    return false; // Stay in the app (Cancel was clicked)


  }
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    inactivityTimerManager!.stopTimer();
  }


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
        onTap: _resumeTimerOnInteraction,  // Resuming on any tap
        onPanDown: (details) => _resumeTimerOnInteraction(), // Resuming on any gesture
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
                  _scaffoldKey.currentState?.closeDrawer();
                },
              ) : null,
              body: Stack(
                children: [
                  MainHeadingWidget(mainMenuName: widget.mainMenuName,
                    onDrawerIconTap: () => _scaffoldKey.currentState?.openDrawer(),
                    onUserProfileIconTap: () {
                      _scaffoldKey.currentState?.closeDrawer();
                      // navigate to profile picture
                      inactivityTimerManager?.stopTimer(); // Stop the timer when the screen is disposed
                      Navigator.push(context, CupertinoPageRoute(builder: (context) => const Profilepagescreen(),));
                    },
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
                                topRight: Radius.circular(
                                    SizeConfig.blockSizeVertical * SizeUtils.WIDTH2),
                                topLeft: Radius.circular(
                                    SizeConfig.blockSizeVertical *
                                        SizeUtils.WIDTH2))),
                        child: Column(
                          children: [
                            // header of title and clear function
                            Padding(
                              padding: const EdgeInsets.only(left: 10, right: 15, top: 12, bottom: 12),
                              child: HeaderWidget(
                                titleTextColor: MyColor.colorBlack,
                                title: "${lableModel!.awbListing}",
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
                            BlocListener<AirSideReleaseCubit, AirSideReleaseState>(
                              listener: (context, state) {

                                if (state is AirSideMainInitialState) {
                                }
                                else if (state is AirSideMainLoadingState) {
                                  // showing loading dialog in this state
                                  DialogUtils.showLoadingDialog(context, message: lableModel.loading);
                                }
                                else if(state is AirsideShipmentListSuccessState){
                                  print("CHECK_AWB_PAGE______SUCCESS");
                                  DialogUtils.hideLoadingDialog(context);

                                  _resumeTimerOnInteraction();

                                  if(state.airsideShipmentListModel.status == "E"){
                                    SnackbarUtil.showSnackbar(context, state.airsideShipmentListModel.statusMessage!, MyColor.colorRed, icon: FontAwesomeIcons.times);
                                    Vibration.vibrate(duration: 500);
                                  }else{

                                    awbModel = state.airsideShipmentListModel;



                                    awbItemList = List.from(awbModel!.airsideReleaseAWBDetailList != null ? awbModel!.airsideReleaseAWBDetailList! : []);

                                    filterAWBDetailsList = List.from(awbItemList);
                                    filterAWBDetailsList.sort((a, b) => b.priority!.compareTo(a.priority!));


                                    print("CHECK_LIST====== ${awbItemList.length}");
                                    setState(() {

                                    });

                                  }


                                }
                                else if(state is AirsideShipmentListFailureState){
                                  print("CHECK_AWB_PAGE______FAILURE");
                                  DialogUtils.hideLoadingDialog(context);
                                  SnackbarUtil.showSnackbar(context, state.error, MyColor.colorRed, icon: FontAwesomeIcons.times);

                                }

                              },
                              child: Expanded(
                                child: SingleChildScrollView(
                                  child: Column(
                                    children: [
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.only(left: 10, right: 10, top: 0, bottom: 10),
                                            child: Directionality(textDirection: textDirection,
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
                                                    child: Column(
                                                      children: [

                                                        Directionality(
                                                          textDirection: textDirection,
                                                          child: Row(
                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                            children: [
                                                              Flexible(
                                                                child: Row(
                                                                  children: [
                                                                    SvgPicture.asset(info, height: SizeConfig.blockSizeVertical * SizeUtils.ICONSIZE2,),
                                                                    SizedBox(width: SizeConfig.blockSizeHorizontal,),
                                                                    Expanded(
                                                                      child: CustomeText(
                                                                          text: "${lableModel.detailsForUldNo} ${widget.uldNo}",
                                                                          fontColor: MyColor.textColorGrey2,
                                                                          fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                                                          fontWeight: FontWeight.w500,
                                                                          textAlign: TextAlign.start),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),


                                                            ],
                                                          ),
                                                        ),
                                                        SizedBox(height: SizeConfig.blockSizeVertical,),
                                                        Directionality(
                                                          textDirection: textDirection,
                                                          child: Row(
                                                            children: [
                                                              Expanded(
                                                                child: GroupIdCustomTextField(
                                                                  controller: scanNoEditingController,
                                                                  focusNode: scanAwbFocusNode,
                                                                  textDirection: textDirection,
                                                                  hasIcon: true,
                                                                  hastextcolor: true,
                                                                  animatedLabel: false,
                                                                  needOutlineBorder: true,
                                                                  isIcon: true,
                                                                  isSearch: true,
                                                                  prefixIconcolor: MyColor.colorBlack,
                                                                  hintText: "${lableModel.scanAWB}",
                                                                  readOnly: false,
                                                                  onChanged: (value) async {

                                                                    updateSearchList(value);

                                                                  },
                                                                  fillColor: MyColor.colorWhite,
                                                                  textInputType: TextInputType.number,
                                                                  inputAction: TextInputAction.next,
                                                                  hintTextcolor: MyColor.colorBlack.withOpacity(0.7),
                                                                  verticalPadding: 0,
                                                                  maxLength: 11,
                                                                  fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_8,
                                                                  circularCorner: SizeConfig.blockSizeHorizontal * SizeUtils.CIRCULARBORDER,
                                                                  boxHeight: SizeConfig.blockSizeVertical * SizeUtils.HEIGHT6,
                                                                  isDigitsOnly: true,
                                                                  validator: (value) {
                                                                    if (value!.isEmpty) {
                                                                      return "Please fill out this field";
                                                                    } else {
                                                                      return null;
                                                                    }
                                                                  },
                                                                ),
                                                              ),
                                                              InkWell(
                                                                onTap: () async {
                                                                  scanQR(lableModel);
                                                                },
                                                                child: Padding(padding: const EdgeInsets.all(8.0),
                                                                  child: SvgPicture.asset(search, height: SizeConfig.blockSizeVertical * SizeUtils.ICONSIZE3,),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),

                                                      ],
                                                    ),

                                                  ),
                                                )),

                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(left: 10, right: 10, top: 0, bottom: 10),
                                            child: Directionality(textDirection: textDirection,
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
                                                    child: Column(
                                                      children: [

                                                        (awbModel != null) ? (awbItemList.isNotEmpty)
                                                            ? (filterAWBDetailsList.isNotEmpty) ? Column(
                                                          children: [
                                                            ListView.builder(
                                                              itemCount: (awbModel != null)
                                                                  ? filterAWBDetailsList.length
                                                                  : 0,
                                                              physics: NeverScrollableScrollPhysics(),
                                                              shrinkWrap: true,
                                                              controller: scrollController,
                                                              itemBuilder: (context, index) {
                                                                AirsideReleaseAWBDetailList aWBItem = filterAWBDetailsList[index];
                                                                bool isSelected = _selectedIndex == index;
                                                                bool isExpand = _isExpandedDetails == index;
                                                                List<String> shcCodes = aWBItem.sHCCode!.split(',');

                                                                return InkWell(
                                                                    focusNode: awbFocusNode,
                                                                    onTap: () {
                                                                      FocusScope.of(context).unfocus();
                                                                      setState(() {
                                                                        _selectedIndex = index; // Update the selected index
                                                                      });
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
                                                                        child: DottedBorder(
                                                                          dashPattern: [7, 7, 7, 7],
                                                                          strokeWidth: 1,
                                                                          borderType: BorderType.RRect,
                                                                          color: aWBItem.sHCCode!.contains("DGR") ? MyColor.colorRedLight : Colors.transparent,
                                                                          radius: Radius.circular(8),
                                                                          child: Container(
                                                                            /*    margin: aWBItem.sHCCode!.contains("DGR") ? EdgeInsets.all(3) : EdgeInsets.all(0),*/
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
                                                                                      children: [
                                                                                        CustomeText(text: AwbFormateNumberUtils.formatAWBNumber(aWBItem.aWBNo!), fontColor: MyColor.colorBlack, fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_6, fontWeight: FontWeight.w600, textAlign: TextAlign.start),
                                                                                        Row(
                                                                                          children: [
                                                                                            CustomeText(
                                                                                              text: "Screening :",
                                                                                              fontColor: MyColor.textColorGrey2,
                                                                                              fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                                                                              fontWeight: FontWeight.w400,
                                                                                              textAlign: TextAlign.start,
                                                                                            ),
                                                                                            SizedBox(width: 5),
                                                                                            CustomeText(
                                                                                              text: "${aWBItem.screeningStatus}",
                                                                                              fontColor: MyColor.colorBlack,
                                                                                              fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                                                                              fontWeight: FontWeight.w600,
                                                                                              textAlign: TextAlign.start,
                                                                                            ),
                                                                                          ],
                                                                                        ),
                                                                                      ],
                                                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                    ),
                                                                                    aWBItem.sHCCode!.isNotEmpty ? SizedBox(height: SizeConfig.blockSizeVertical * 0.8,) : SizedBox(),
                                                                                    Row(
                                                                                      children: [
                                                                                        aWBItem.sHCCode!.isNotEmpty
                                                                                            ? Row(
                                                                                          children:shcCodes.asMap().entries.take(3).map((entry) {
                                                                                            int index = entry.key; // Get the index for colorList assignment
                                                                                            String code = entry.value.trim(); // Get the code value and trim it

                                                                                            return Padding(
                                                                                              padding: EdgeInsets.only(right: 5.0),
                                                                                              child: AnimatedBuilder(
                                                                                                animation: _colorAnimation,
                                                                                                builder: (context, child) {
                                                                                                  return Container(
                                                                                                    padding : EdgeInsets.symmetric(horizontal: SizeConfig.blockSizeHorizontal * 1.2, vertical: 1),
                                                                                                    decoration : BoxDecoration(
                                                                                                      borderRadius: BorderRadius.circular(5),
                                                                                                      color: (code.trim() == "DGR") ? _colorAnimation.value! : MyColor.shcColorList[index % MyColor.shcColorList.length],),
                                                                                                    child: CustomeText(
                                                                                                      text: code.trim(),
                                                                                                      fontColor: MyColor.textColorGrey3,
                                                                                                      fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_3,
                                                                                                      fontWeight: FontWeight.w500,
                                                                                                      textAlign: TextAlign.center,
                                                                                                    ),
                                                                                                  );
                                                                                                },
                                                                                              ),
                                                                                            );
                                                                                          }).toList(),
                                                                                        )
                                                                                            : SizedBox(),
                                                                                      ],
                                                                                    ),
                                                                                    aWBItem.sHCCode!.isNotEmpty ? SizedBox(height: SizeConfig.blockSizeVertical) : SizedBox(height: SizeConfig.blockSizeVertical * 0.8,),
                                                                                    Row(
                                                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                      children: [
                                                                                        Row(
                                                                                          children: [
                                                                                            CustomeText(
                                                                                              text: "NOP :",
                                                                                              fontColor: MyColor.textColorGrey2,
                                                                                              fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                                                                              fontWeight: FontWeight.w400,
                                                                                              textAlign: TextAlign.start,
                                                                                            ),
                                                                                            SizedBox(width: 5),
                                                                                            CustomeText(
                                                                                              text: "10",
                                                                                              fontColor: MyColor.colorBlack,
                                                                                              fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                                                                              fontWeight: FontWeight.w600,
                                                                                              textAlign: TextAlign.start,
                                                                                            ),
                                                                                          ],
                                                                                        ),
                                                                                      /*  Row(
                                                                                          children: [
                                                                                            CustomeText(
                                                                                              text: "Weight :",
                                                                                              fontColor: MyColor.textColorGrey2,
                                                                                              fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                                                                              fontWeight: FontWeight.w400,
                                                                                              textAlign: TextAlign.start,
                                                                                            ),
                                                                                            SizedBox(width: 5),
                                                                                            CustomeText(
                                                                                              text: "100",
                                                                                              fontColor: MyColor.colorBlack,
                                                                                              fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                                                                              fontWeight: FontWeight.w600,
                                                                                              textAlign: TextAlign.start,
                                                                                            ),
                                                                                          ],
                                                                                        ),*/
                                                                                        (widget.uldType == "T") ? Row(
                                                                                          children: [
                                                                                            CustomeText(
                                                                                              text: "Temp. : ",
                                                                                              fontColor: MyColor.textColorGrey2,
                                                                                              fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                                                                              fontWeight: FontWeight.w400,
                                                                                              textAlign: TextAlign.start,
                                                                                            ),
                                                                                            const SizedBox(width: 5),
                                                                                            Container(
                                                                                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                                                                                              decoration: BoxDecoration(
                                                                                                  color: MyColor.dropdownColor,
                                                                                                  borderRadius: BorderRadius.circular(SizeConfig.blockSizeHorizontal * SizeUtils.WIDTH2)
                                                                                              ),
                                                                                              child: InkWell(
                                                                                                child: Row(
                                                                                                  mainAxisSize: MainAxisSize.min,
                                                                                                  children: [
                                                                                                    CustomeText(
                                                                                                        text: (aWBItem.temp!.isNotEmpty) ? "T - ${aWBItem.temp!}" : "T - 0",
                                                                                                        fontColor: MyColor.textColorGrey3,
                                                                                                        fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                                                                                        fontWeight: FontWeight.w700,
                                                                                                        textAlign: TextAlign.center),
                                                                                                    SizedBox(width: SizeConfig.blockSizeHorizontal,),
                                                                                                    SvgPicture.asset(pen, height: SizeConfig.blockSizeVertical * SizeUtils.HEIGHT_1_5,)
                                                                                                  ],
                                                                                                ),
                                                                                                onTap: () {

                                                                                                },
                                                                                              ),
                                                                                            ),
                                                                                            const SizedBox(width: 5),
                                                                                            CustomeText(
                                                                                                text: "C",
                                                                                                fontColor: MyColor.textColorGrey3,
                                                                                                fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                                                                                fontWeight: FontWeight.w700,
                                                                                                textAlign: TextAlign.center),
                                                                                          ],
                                                                                        ) : SizedBox()
                                                                                      ],
                                                                                    ),
                                                                                    SizedBox(height: SizeConfig.blockSizeVertical * 0.8,),
                                                                                    Row(
                                                                                      children: [
                                                                                        CustomeText(
                                                                                          text: "NoG :",
                                                                                          fontColor: MyColor.textColorGrey2,
                                                                                          fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                                                                          fontWeight: FontWeight.w400,
                                                                                          textAlign: TextAlign.start,
                                                                                        ),
                                                                                        SizedBox(width: 5),
                                                                                        CustomeText(
                                                                                          text: "${aWBItem.nOG}",
                                                                                          fontColor: MyColor.colorBlack,
                                                                                          fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                                                                          fontWeight: FontWeight.w500,
                                                                                          textAlign: TextAlign.start,
                                                                                        ),
                                                                                      ],
                                                                                    ),
                                                                                    SizedBox(height: SizeConfig.blockSizeVertical * 0.8,),
                                                                                    Row(
                                                                                      children: [
                                                                                        CustomeText(
                                                                                          text: "Commodity :",
                                                                                          fontColor: MyColor.textColorGrey2,
                                                                                          fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                                                                          fontWeight: FontWeight.w400,
                                                                                          textAlign: TextAlign.start,
                                                                                        ),
                                                                                        SizedBox(width: 5),
                                                                                        CustomeText(
                                                                                          text: "${aWBItem.commodity}",
                                                                                          fontColor: MyColor.colorBlack,
                                                                                          fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                                                                          fontWeight: FontWeight.w500,
                                                                                          textAlign: TextAlign.start,
                                                                                        ),
                                                                                      ],
                                                                                    ),


                                                                                    SizedBox(height: SizeConfig.blockSizeVertical,),
                                                                                    Row(
                                                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                      children: [
                                                                                        Row(
                                                                                          children: [
                                                                                            Container(
                                                                                              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 1),
                                                                                              decoration: BoxDecoration(
                                                                                                  color: MyColor.dropdownColor,
                                                                                                  borderRadius: BorderRadius.circular(SizeConfig.blockSizeHorizontal * SizeUtils.WIDTH2)
                                                                                              ),
                                                                                              child: InkWell(
                                                                                                child: Row(
                                                                                                  children: [
                                                                                                    CustomeText(
                                                                                                        text: "P - ${aWBItem.priority}",
                                                                                                        fontColor: MyColor.textColorGrey3,
                                                                                                        fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                                                                                        fontWeight: FontWeight.w700,
                                                                                                        textAlign: TextAlign.center),
                                                                                                    SizedBox(width: SizeConfig.blockSizeHorizontal,),
                                                                                                    SvgPicture.asset(pen, height: SizeConfig.blockSizeVertical * SizeUtils.HEIGHT_1_5,)
                                                                                                  ],
                                                                                                  mainAxisSize: MainAxisSize.min,
                                                                                                ),
                                                                                                onTap: () {
                                                                                                  setState(() {
                                                                                                    _selectedIndex = index; // Update the selected index
                                                                                                  });
                                                                                                  openEditPriorityBottomDialog(
                                                                                                      context,
                                                                                                      aWBItem.aWBNo!,
                                                                                                      "${aWBItem.priority}",
                                                                                                      index,
                                                                                                      aWBItem,
                                                                                                      lableModel,
                                                                                                      textDirection);

                                                                                                },
                                                                                              ),
                                                                                            ),
                                                                                          ],
                                                                                        ),
                                                                                        Row(
                                                                                          children: [
                                                                                            CustomeText(
                                                                                              text: "ShockWatch Alert :",
                                                                                              fontColor: MyColor.textColorGrey2,
                                                                                              fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                                                                              fontWeight: FontWeight.w400,
                                                                                              textAlign: TextAlign.start,
                                                                                            ),
                                                                                            const SizedBox(width: 5),
                                                                                            Transform.scale(
                                                                                              scale: 0.9,
                                                                                              child: Switch(
                                                                                                value: false,
                                                                                                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                                                                                activeColor: MyColor.primaryColorblue,
                                                                                                inactiveThumbColor: MyColor.thumbColor,
                                                                                                inactiveTrackColor: MyColor.textColorGrey2,
                                                                                                trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
                                                                                                onChanged: (value) {
                                                                                                  setState(() {
                                                                                              
                                                                                                  });
                                                                                                },
                                                                                              ),
                                                                                            )
                                                                                          ],
                                                                                        ),
                                                                                      ],
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ),)
                                                                    )
                                                                );
                                                              },
                                                            ),
                                                          ],
                                                        )
                                                            : Padding(
                                                              padding: const EdgeInsets.symmetric(vertical: 10.0),
                                                              child: Center(
                                                                child: CustomeText(text: "${lableModel.recordNotFound}", fontColor:
                                                                MyColor.textColorGrey,
                                                                fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_2_0,
                                                                fontWeight: FontWeight.w500,
                                                                textAlign: TextAlign.center),),
                                                            )
                                                            : Padding(
                                                              padding: const EdgeInsets.symmetric(vertical: 10.0),
                                                              child: Center(
                                                                child: CustomeText(text: "${lableModel.allShipment}",
                                                                fontColor: MyColor.textColorGrey,
                                                                fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_2_0,
                                                                fontWeight: FontWeight.w500,
                                                                textAlign: TextAlign.center),),
                                                            )
                                                            : Column(
                                                              children: [
                                                                Padding(
                                                                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                                                                  child: Center(
                                                                    child: CustomeText(text: "${lableModel.recordNotFound}",
                                                                    fontColor: MyColor.textColorGrey,
                                                                    fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_2_0,
                                                                    fontWeight: FontWeight.w500,
                                                                    textAlign: TextAlign.center),),
                                                                ),

                                                              ],
                                                            )
                                                      ],
                                                    ),

                                                  ),
                                                )),
                                          ),
                                        ],
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





  //update search
  void updateSearchList(String searchString) {
    setState(() {
      filterAWBDetailsList = _applyFiltersAndSorting(
        awbItemList,
        searchString
      );
    });
  }

  //appliying filter for sorting
  List<AirsideReleaseAWBDetailList> _applyFiltersAndSorting(List<AirsideReleaseAWBDetailList> list, String searchString) {
    // Filter by search string
    List<AirsideReleaseAWBDetailList> filteredList = list.where((item) {
      return item.aWBNo!.replaceAll(" ", "").toLowerCase().contains(searchString.toLowerCase());
    }).toList();

    return filteredList;
  }




  Future<void> scanQR(LableModel lableModel) async {


    String barcodeScanResult =  await FlutterBarcodeScanner.scanBarcode(
      '#ff6666', // Color for the scanner overlay
      'Cancel', // Text for the cancel button
      true, // Enable flash option
      ScanMode.DEFAULT, // Scan mode
    );

    if(barcodeScanResult == "-1"){
    }else{

      bool specialCharAllow = CommonUtils.containsSpecialCharacters(barcodeScanResult);


      if(specialCharAllow == true){
        scanNoEditingController.clear();
        updateSearchList("");
        SnackbarUtil.showSnackbar(context, "${lableModel.invalidAWBNo}", MyColor.colorRed, icon: FontAwesomeIcons.times);
        Vibration.vibrate(duration: 500);
        WidgetsBinding.instance.addPostFrameCallback((_) {
          FocusScope.of(context).requestFocus(scanAwbFocusNode);
        });
      }else{

        if (RegExp(r'[a-zA-Z]').hasMatch(barcodeScanResult)) {
          scanNoEditingController.clear();
          updateSearchList("");
          // Show invalid message if alphabet characters are present
          SnackbarUtil.showSnackbar(context, "${lableModel.invalidAWBNo}", MyColor.colorRed, icon: FontAwesomeIcons.times);
          Vibration.vibrate(duration: 500);

          WidgetsBinding.instance.addPostFrameCallback((_) {
            FocusScope.of(context).requestFocus(scanAwbFocusNode);
          });
        } else {
          String result = barcodeScanResult.replaceAll(" ", "");
          String truncatedResult = result.length > 11
              ? result.substring(0, 11)
              : result;

          scanNoEditingController.text = truncatedResult.toString();


          updateSearchList(truncatedResult);

        }




      }


    }
  }


  // open dialog for chnage bdpriority
  Future<void> openEditPriorityBottomDialog(
      BuildContext context,
      String awbNo,
      String priority,
      int index,
      AirsideReleaseAWBDetailList awbItm,
      LableModel lableModel,
      ui.TextDirection textDirection) async {
    FocusScope.of(context).unfocus();
    String? updatedPriority = await DialogUtils.showPriorityChangeBottomAWBDialog(context, awbNo, priority, lableModel, textDirection);
    if (updatedPriority != null) {
      int newPriority = int.parse(updatedPriority);

      if (newPriority != 0) {
    /*    // Call your API to update the priority in the backend
        await callbdPriorityApi(
            context,
            awbItm.iMPShipRowId!,
            newPriority,
            _user!.userProfile!.userIdentity!,
            _splashDefaultData!.companyCode!,
            widget.menuId);*/

        setState(() {
          // Update the BDPriority for the selected item
          filterAWBDetailsList[index].priority = newPriority;

          // Sort the list based on BDPriority
          filterAWBDetailsList.sort((a, b) => b.priority!.compareTo(a.priority!));
        });
      } else {
        Vibration.vibrate(duration: 500);
        SnackbarUtil.showSnackbar(context, "${lableModel.prioritymsg}", MyColor.colorRed, icon: FontAwesomeIcons.times);
      }
    } else {
      print("Priority update was canceled");
    }
  }



  Future<void> openValidationDialog(String message, FocusNode focuseNode) async {
    bool? empty = await DialogUtils.showDataNotFoundDialogbot(
        context, "${message}", widget.lableModel);

    if (empty == true) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        FocusScope.of(context).requestFocus(focuseNode);
      });
    }
  }

}

// ticker animation for DGR code blink animation
class TickerProviders extends TickerProvider {
  @override
  Ticker createTicker(onTick) => Ticker(onTick);
}

