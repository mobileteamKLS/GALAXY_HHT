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
import 'package:galaxy/module/import/pages/flightcheck/awbremarklistack.dart';
import 'package:galaxy/module/import/services/flightcheck/flightchecklogic/flightcheckcubit.dart';
import 'package:galaxy/module/import/services/flightcheck/flightchecklogic/flightcheckstate.dart';
import 'package:galaxy/utils/snackbarutil.dart';
import 'package:galaxy/widget/customdivider.dart';
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
import '../../../login/model/userlogindatamodel.dart';
import '../../../login/pages/signinscreenmethods.dart';
import '../../../onboarding/sizeconfig.dart';
import 'dart:ui' as ui;

import '../../../splash/model/splashdefaultmodel.dart';
import '../../model/flightcheck/awblistmodel.dart';
import '../../model/flightcheck/flightcheckuldlistmodel.dart';
import '../../model/uldacceptance/buttonrolesrightsmodel.dart';
import 'checkawb.dart';
import 'damageshipment/damageshipment.dart';

class AWBListPage extends StatefulWidget {

  List<ButtonRight> buttonRightsList;
  String location;
  String mainMenuName;
  String uldNo;
  FlightDetailSummary flightDetailSummary;
  int uldSeqNo;
  int menuId;
  LableModel lableModel;

  String awbRemarkRequires;
  String groupIDRequires;
  int groupIDCharSize;
  String bDEndStatus;

  AWBListPage({super.key,
    required this.buttonRightsList,
    required this.uldNo, required this.mainMenuName, required this.flightDetailSummary, required this.uldSeqNo, required this.menuId, required this.location, required this.awbRemarkRequires, required this.lableModel, required this.groupIDRequires, required this.groupIDCharSize, required this.bDEndStatus});

  @override
  State<AWBListPage> createState() => _AWBListPageState();
}

class _AWBListPageState extends State<AWBListPage> with SingleTickerProviderStateMixin{
  InactivityTimerManager? inactivityTimerManager;
  final SavedPrefrence savedPrefrence = SavedPrefrence();
  UserDataModel? _user;
  SplashDefaultModel? _splashDefaultData;

  bool _isOpenULDFlagEnable = false;

  List<FlightCheckInAWBBDList> awbItemList = [];
  List<FlightCheckInAWBBDList> filterAWBDetailsList = [];

  AWBModel? awbModel;
  int uldProgress = 0;
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


      context.read<FlightCheckCubit>().getAWBList(widget.flightDetailSummary.flightSeqNo!, widget.uldSeqNo, _user!.userProfile!.userIdentity!, _splashDefaultData!.companyCode!, widget.menuId,  (_isOpenULDFlagEnable == true) ? 1 : 0);

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

    print("ULD_PROGRSS == ${uldProgress}");

    if(widget.bDEndStatus == "N"){
      bool? exitConfirmed = await DialogUtils.showULDBDCompleteDialog(context, widget.lableModel, widget.uldNo, uldProgress, widget.bDEndStatus);
      if (exitConfirmed == true) {
        bool hasIncompleteAWB = false;

        for (var item in filterAWBDetailsList) {
          if (item.progress == 0) {
            hasIncompleteAWB = true;
            String awbNo = item.aWBNo!;

            // Show Snackbar with the AWB number of the first item with Progress 0
            SnackbarUtil.showSnackbar(
              context,
              "All the AWBs have not yet been matched/recorded discrepancy.",
              MyColor.colorRed,
              icon: FontAwesomeIcons.times,
            );

            Vibration.vibrate(duration: 500);
            break; // Stop after finding the first item with Progress 0
          }
        }

        // Call breakDownEnd only if all items have non-zero progress
        if (!hasIncompleteAWB) {
          context.read<FlightCheckCubit>().breakDownEnd(
            widget.flightDetailSummary.flightSeqNo!,
            widget.uldSeqNo,
            uldProgress < 100 ? "Y" : "N",
            _user!.userProfile!.userIdentity!,
            _splashDefaultData!.companyCode!,
            widget.menuId,
          );
        }
      }
      else {
        Navigator.pop(context, "Done");
      }
    }else{
      Navigator.pop(context, "Done");
    }


    return false; // Stay in the app (Cancel was clicked)


  }

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

    final flightParts = widget.flightDetailSummary.flightNo!.split(' ');

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
              body: Stack(
                children: [
                  MainHeadingWidget(mainMenuName: widget.mainMenuName),
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
                            BlocListener<FlightCheckCubit, FlightCheckState>(
                              listener: (context, state) {

                                if (state is MainInitialState) {
                                }
                                else if (state is MainLoadingState) {
                                  // showing loading dialog in this state
                                  DialogUtils.showLoadingDialog(context, message: lableModel!.loading);
                                }
                                else if(state is AWBListSuccessState){
                                  print("CHECK_AWB_PAGE______SUCCESS");
                                  DialogUtils.hideLoadingDialog(context);

                                  _resumeTimerOnInteraction();

                                  if(state.aWBModel.status == "E"){
                                    SnackbarUtil.showSnackbar(context, state.aWBModel.statusMessage!, MyColor.colorRed, icon: FontAwesomeIcons.times);
                                    Vibration.vibrate(duration: 500);
                                  }else{

                                    awbModel = state.aWBModel;
                                    uldProgress = awbModel!.ULDProgress!;


                                    awbItemList = List.from(awbModel!.flightCheckInAWBBDList != null ? awbModel!.flightCheckInAWBBDList! : []);

                                    filterAWBDetailsList = List.from(awbItemList);
                                    filterAWBDetailsList.sort((a, b) => b.bDPriority!.compareTo(a.bDPriority!));


                                    print("CHECK_LIST====== ${awbItemList.length}");
                                    setState(() {

                                    });

                                  }


                                }
                                else if(state is AWBListFailureState){
                                  print("CHECK_AWB_PAGE______FAILURE");
                                  DialogUtils.hideLoadingDialog(context);
                                  SnackbarUtil.showSnackbar(context, state.error, MyColor.colorRed, icon: FontAwesomeIcons.times);

                                }
                                else if (state is BDPriorityAWBSuccessState) {
                                  // responce bdpriority success

                                  DialogUtils.hideLoadingDialog(context);
                                  if (state.bdPriorityModel.status == "E") {
                                    Vibration.vibrate(duration: 500);
                                    SnackbarUtil.showSnackbar(
                                        context,
                                        state.bdPriorityModel.statusMessage!,
                                        MyColor.colorRed, icon: FontAwesomeIcons.times);
                                  } else {
                                    SnackbarUtil.showSnackbar(
                                        context,
                                        state.bdPriorityModel.statusMessage!,
                                        MyColor.colorGreen, icon: Icons.done);
                                    setState(() {});
                                    //callFlightCheckApi(context, locationController.text, igmNoEditingController.text, flightNoEditingController.text, dateEditingController.text, _user!.userProfile!.userIdentity!, _company!.companyCode!);
                                  }
                                }
                                else if (state is BDPriorityFailureState) {
                                  // bd priority fail responce
                                  DialogUtils.hideLoadingDialog(context);
                                  Vibration.vibrate(duration: 500);
                                  SnackbarUtil.showSnackbar(context, state.error, MyColor.colorRed, icon: FontAwesomeIcons.times);
                                }
                                else if (state is BreakDownEndSaveSuccessState){
                                  DialogUtils.hideLoadingDialog(context);
                                  if(state.breakDownEndModel.status == "E"){
                                    Vibration.vibrate(duration: 500);
                                    SnackbarUtil.showSnackbar(context, state.breakDownEndModel.statusMessage!, MyColor.colorRed, icon: FontAwesomeIcons.times);
                                  }else{
                                    Navigator.pop(context, "true");
                                  }
                                }
                                else if(state is BreakDownEndFailureState){
                                  Vibration.vibrate(duration: 500);
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
                                                          textDirection: uiDirection,
                                                          child: Row(
                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                            children: [
                                                              Row(
                                                                children: [
                                                                  SvgPicture.asset(info, height: SizeConfig.blockSizeVertical * SizeUtils.ICONSIZE2,),
                                                                  SizedBox(width: SizeConfig.blockSizeHorizontal,),
                                                                  CustomeText(
                                                                      text: "${lableModel.detailsForUldNo} ${widget.uldNo}",
                                                                      fontColor: MyColor.textColorGrey2,
                                                                      fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                                                      fontWeight: FontWeight.w500,
                                                                      textAlign: TextAlign.start),
                                                                ],
                                                              ),


                                                              (awbModel != null) ? Container(
                                                                height : SizeConfig.blockSizeVertical * SizeUtils.HEIGHT6,
                                                                width : SizeConfig.blockSizeVertical * SizeUtils.HEIGHT6,
                                                                child: DashedCircularProgressBar.aspectRatio(
                                                                  aspectRatio: 2.1, // width ÷ height
                                                                  valueNotifier: _valueNotifier,
                                                                  progress: awbModel!.ULDProgress!.toDouble(),
                                                                  maxProgress: 100,
                                                                  corners: StrokeCap.butt,
                                                                  foregroundColor:  (awbModel!.ULDProgress!.toDouble() == 100) ? MyColor.colorgreenProgress  : MyColor.colorOrangeProgress,
                                                                  backgroundColor: const Color(0xffF2F4F8),
                                                                  foregroundStrokeWidth: 5,
                                                                  backgroundStrokeWidth: 5,
                                                                  animation: true,
                                                                  child: Center(
                                                                    child: ValueListenableBuilder(
                                                                      valueListenable: _valueNotifier,
                                                                      builder: (_, double value, __) {
                                                                        return CustomeText(text: '${value.toInt()}%', fontColor:  MyColor.colorBlack, fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_3, fontWeight: FontWeight.w500, textAlign: TextAlign.center);
                                                                      },
                                                                    ),
                                                                  ),


                                                                ),
                                                              ) : SizedBox(),


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
                                                                  onChanged: (value) {
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
                                                                onTap: () {
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

                                                        Row(
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          children: [
                                                            Row(

                                                              children: [
                                                                SvgPicture.asset(info, height: SizeConfig.blockSizeVertical * SizeUtils.ICONSIZE2,),
                                                                SizedBox(
                                                                  width: SizeConfig.blockSizeHorizontal,
                                                                ),
                                                                CustomeText(
                                                                    text: "${lableModel.showAllShipments}",
                                                                    fontColor: MyColor.textColorGrey2,
                                                                    fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                                                    fontWeight: FontWeight.w500,
                                                                    textAlign: TextAlign.start)
                                                              ],
                                                            ),
                                                            Switch(
                                                              value: _isOpenULDFlagEnable,
                                                              materialTapTargetSize:
                                                              MaterialTapTargetSize.shrinkWrap,
                                                              activeColor: MyColor.primaryColorblue,
                                                              inactiveThumbColor: MyColor.thumbColor,
                                                              inactiveTrackColor: MyColor.textColorGrey2,
                                                              trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
                                                              onChanged: (value) {
                                                                setState(() {
                                                                  scanNoEditingController.clear();
                                                                  _isOpenULDFlagEnable = value;
                                                                });

                                                                context.read<FlightCheckCubit>().getAWBList(widget.flightDetailSummary.flightSeqNo!, widget.uldSeqNo, _user!.userProfile!.userIdentity!, _splashDefaultData!.companyCode!, widget.menuId,  (value == true) ? 1 : 0);


                                                              },
                                                            ),

                                                          ],
                                                        ),

                                                       /* (awbModel != null)
                                                            ?
                                                            : SizedBox(),*/

                                                        (awbModel != null) ? (awbItemList.isNotEmpty)
                                                            ? (filterAWBDetailsList.isNotEmpty) ? Column(
                                                          children: [

                                                            SizedBox(height: SizeConfig.blockSizeVertical,),
                                                            ListView.builder(
                                                              itemCount: (awbModel != null)
                                                                  ? filterAWBDetailsList.length
                                                                  : 0,
                                                              physics: NeverScrollableScrollPhysics(),
                                                              shrinkWrap: true,
                                                              controller: scrollController,
                                                              itemBuilder: (context, index) {
                                                                FlightCheckInAWBBDList aWBItem = filterAWBDetailsList![index];
                                                                bool isSelected = _selectedIndex == index;
                                                                bool isExpand = _isExpandedDetails == index;
                                                                List<String> shcCodes = aWBItem.sHCCode!.split(',');

                                                                final ValueNotifier<double> _valueNotifier1 = ValueNotifier(0);

                                                                return InkWell(
                                                                    focusNode: awbFocusNode,
                                                                    onTap: () {
                                                                      FocusScope.of(context).unfocus();
                                                                      setState(() {
                                                                        _selectedIndex = index; // Update the selected index
                                                                      });
                                                                    },
                                                                    onDoubleTap: () async {

                                                                      if(widget.flightDetailSummary.flightStatus == "A"){
                                                                        if(widget.bDEndStatus == "N"){
                                                                          if(widget.awbRemarkRequires == "Y"){
                                                                            if(aWBItem.remark == "Y"){
                                                                              // bool? value = await openDialog(context, aWBItem, widget.mainMenuName);

                                                                              List<AWBRemarksList> remarkList = filterAWBRemarksById(awbModel!.aWBRemarksList!, aWBItem.iMPAWBRowId!);

                                                                              var value = await Navigator.push(context, CupertinoPageRoute(builder: (context) => AWBRemarkListAckPage(
                                                                                  buttonRightsList: widget.buttonRightsList,
                                                                                  mainMenuName: widget.mainMenuName, aWBRemarkList: remarkList, aWBItem: aWBItem, menuId: widget.menuId),));

                                                                              if(value == "true"){

                                                                                gotoCheckAWBScreen(aWBItem);

                                                                              }else if(value == "Done"){
                                                                                _resumeTimerOnInteraction();
                                                                              }
                                                                            }else{
                                                                              gotoCheckAWBScreen(aWBItem);
                                                                            }
                                                                          }
                                                                          else{
                                                                            gotoCheckAWBScreen(aWBItem);
                                                                          }
                                                                        }
                                                                        else{
                                                                          if(widget.uldNo == "BULK"){

                                                                            if(aWBItem.damageNOP == 0){
                                                                              SnackbarUtil.showSnackbar(context, "Breakdown already completed.", MyColor.colorRed, icon: FontAwesomeIcons.times);
                                                                              Vibration.vibrate(duration: 500);
                                                                            }
                                                                            else{

                                                                              int npxPices = aWBItem.nPR!;
                                                                              double weightCo = double.parse(((npxPices * aWBItem.weightExp!) / aWBItem.nPX!).toStringAsFixed(2));


                                                                              var value = await Navigator.push(context, CupertinoPageRoute(builder: (context) => DamageShimentPage(
                                                                                pageView: 1,
                                                                                enterDamageNop: 0,
                                                                                enterDamageWt: 0.00,
                                                                                damageNop: aWBItem.damageNOP!,
                                                                                damageWt: aWBItem.damageWeight!,
                                                                                buttonRightsList: widget.buttonRightsList,
                                                                                aWBItem: aWBItem, flightDetailSummary: widget.flightDetailSummary, mainMenuName: widget.mainMenuName, userId: _user!.userProfile!.userIdentity!, companyCode: _splashDefaultData!.companyCode!,  menuId: widget.menuId, npxPieces: npxPices, npxWeightCo: weightCo, groupId: "",),));

                                                                              if(value == "Done"){
                                                                                _resumeTimerOnInteraction();
                                                                              }else if(value == "true"){
                                                                                //Navigator.pop(context, "true");

                                                                                context.read<FlightCheckCubit>().getAWBList(widget.flightDetailSummary.flightSeqNo!, widget.uldSeqNo, _user!.userProfile!.userIdentity!, _splashDefaultData!.companyCode!, widget.menuId,  (_isOpenULDFlagEnable == true) ? 1 : 0);

                                                                              }


                                                                            }



                                                                          }else{
                                                                            if(aWBItem.damageNOP == 0){
                                                                              SnackbarUtil.showSnackbar(context, "Breakdown already completed.", MyColor.colorRed, icon: FontAwesomeIcons.times);
                                                                              Vibration.vibrate(duration: 500);
                                                                            }
                                                                            else{

                                                                              int npxPices = aWBItem.nPR!;
                                                                              double weightCo = double.parse(((npxPices * aWBItem.weightExp!) / aWBItem.nPX!).toStringAsFixed(2));



                                                                              var value = await Navigator.push(context, CupertinoPageRoute(builder: (context) => DamageShimentPage(
                                                                                pageView: 1,
                                                                                enterDamageNop: 0,
                                                                                enterDamageWt: 0.00,
                                                                                damageNop: aWBItem.damageNOP!,
                                                                                damageWt: aWBItem.damageWeight!,
                                                                                buttonRightsList: widget.buttonRightsList,
                                                                                aWBItem: aWBItem, flightDetailSummary: widget.flightDetailSummary, mainMenuName: widget.mainMenuName, userId: _user!.userProfile!.userIdentity!, companyCode: _splashDefaultData!.companyCode!,  menuId: widget.menuId, npxPieces: npxPices, npxWeightCo: weightCo, groupId: "",),));


                                                                              if(value == "Done"){
                                                                                _resumeTimerOnInteraction();
                                                                              }else if(value == "true"){
                                                                                //Navigator.pop(context, "true");

                                                                                context.read<FlightCheckCubit>().getAWBList(widget.flightDetailSummary.flightSeqNo!, widget.uldSeqNo, _user!.userProfile!.userIdentity!, _splashDefaultData!.companyCode!, widget.menuId,  (_isOpenULDFlagEnable == true) ? 1 : 0);

                                                                              }

                                                                            }
                                                                          }

                                                                        }
                                                                      }else if(widget.flightDetailSummary.flightStatus == "F"){
                                                                        if(aWBItem.damageNOP == 0){
                                                                          SnackbarUtil.showSnackbar(context, "Breakdown already completed.", MyColor.colorRed, icon: FontAwesomeIcons.times);
                                                                          Vibration.vibrate(duration: 500);
                                                                        }
                                                                        else{

                                                                          int npxPices = aWBItem.nPR!;
                                                                          double weightCo = double.parse(((npxPices * aWBItem.weightExp!) / aWBItem.nPX!).toStringAsFixed(2));


                                                                          var value = await Navigator.push(context, CupertinoPageRoute(builder: (context) => DamageShimentPage(
                                                                            pageView: 1,
                                                                            enterDamageNop: 0,
                                                                            enterDamageWt: 0.00,
                                                                            damageNop: aWBItem.damageNOP!,
                                                                            damageWt: aWBItem.damageWeight!,
                                                                            buttonRightsList: widget.buttonRightsList,
                                                                            aWBItem: aWBItem, flightDetailSummary: widget.flightDetailSummary, mainMenuName: widget.mainMenuName, userId: _user!.userProfile!.userIdentity!, companyCode: _splashDefaultData!.companyCode!,  menuId: widget.menuId, npxPieces: npxPices, npxWeightCo: weightCo, groupId: "",),));

                                                                          if(value == "Done"){
                                                                            _resumeTimerOnInteraction();
                                                                          }else if(value == "true"){
                                                                            //Navigator.pop(context, "true");

                                                                            context.read<FlightCheckCubit>().getAWBList(widget.flightDetailSummary.flightSeqNo!, widget.uldSeqNo, _user!.userProfile!.userIdentity!, _splashDefaultData!.companyCode!, widget.menuId,  (_isOpenULDFlagEnable == true) ? 1 : 0);

                                                                          }


                                                                        }

                                                                        /*  SnackbarUtil.showSnackbar(context, "Flight is finalized.", MyColor.colorRed, icon: FontAwesomeIcons.times);
                                                                        Vibration.vibrate(duration: 500);*/
                                                                      }else if(widget.flightDetailSummary.flightStatus == "N"){
                                                                        SnackbarUtil.showSnackbar(context, "Flight is not arrived.", MyColor.colorRed, icon: FontAwesomeIcons.times);
                                                                        Vibration.vibrate(duration: 500);
                                                                      }





                                                                      setState(() {
                                                                        _selectedIndex = index; // Update the selected index
                                                                      });

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
                                                                                        SizedBox(width: SizeConfig.blockSizeHorizontal),


                                                                                        (aWBItem.damageNOP != 0)
                                                                                            ? Padding(
                                                                                          padding: const EdgeInsets.symmetric(horizontal: 5),
                                                                                          child: Row(
                                                                                            children: [
                                                                                              SvgPicture.asset(
                                                                                                damageIcon,
                                                                                                height: SizeConfig.blockSizeVertical * SizeUtils.ICONSIZE2,
                                                                                              ),
                                                                                              SizedBox(width: SizeConfig.blockSizeHorizontal),
                                                                                              CustomeText(
                                                                                                text: "DMG",
                                                                                                fontColor: MyColor.colorRed,
                                                                                                fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                                                                                fontWeight: FontWeight.w400,
                                                                                                textAlign: TextAlign.start,
                                                                                              ),
                                                                                            ],
                                                                                          ),
                                                                                        ) : SizedBox(),



                                                                                        Row(
                                                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                                                          children: [
                                                                                            (aWBItem.isIntact!.replaceAll(" ", "").isNotEmpty)
                                                                                                ? (aWBItem.isIntact! == "Y")
                                                                                                ? Padding(
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
                                                                                            )
                                                                                                : SizedBox()
                                                                                                : SizedBox(),
                                                                                            (aWBItem.transit!.isNotEmpty) ? Padding(
                                                                                              padding: const EdgeInsets.symmetric(horizontal: 2),
                                                                                              child: Container(
                                                                                                width: SizeConfig.blockSizeVertical * SizeUtils.TEXTSIZE_2_2,  // Set width and height for the circle
                                                                                                decoration: BoxDecoration(
                                                                                                  shape: BoxShape.circle,
                                                                                                  border: Border.all(  // Add border
                                                                                                    color: MyColor.primaryColorblue,  // Border color
                                                                                                    width: 1.3,  // Border width
                                                                                                  ),
                                                                                                ),
                                                                                                child: CustomeText(
                                                                                                    text: "${aWBItem.transit}",
                                                                                                    fontColor: MyColor.primaryColorblue,
                                                                                                    fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_3,
                                                                                                    fontWeight: FontWeight.w500,
                                                                                                    textAlign: TextAlign.center),
                                                                                              ),
                                                                                            )
                                                                                                : SizedBox(),
                                                                                          ],
                                                                                        )


                                                                                      ],
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
                                                                                      children: [
                                                                                        Expanded(
                                                                                          flex: 1,
                                                                                          child: Row(
                                                                                            children: [
                                                                                              CustomeText(
                                                                                                text: "NPX :",
                                                                                                fontColor: MyColor.textColorGrey2,
                                                                                                fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                                                                                fontWeight: FontWeight.w400,
                                                                                                textAlign: TextAlign.start,
                                                                                              ),
                                                                                              SizedBox(width: 5),
                                                                                              CustomeText(
                                                                                                text: "${aWBItem.nPX}",
                                                                                                fontColor: MyColor.colorBlack,
                                                                                                fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                                                                                fontWeight: FontWeight.w600,
                                                                                                textAlign: TextAlign.start,
                                                                                              ),
                                                                                            ],
                                                                                          ),
                                                                                        ),
                                                                                        Expanded(
                                                                                          flex: 1,
                                                                                          child: Row(
                                                                                            children: [
                                                                                              CustomeText(
                                                                                                text: "NPR :",
                                                                                                fontColor: MyColor.textColorGrey2,
                                                                                                fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                                                                                fontWeight: FontWeight.w400,
                                                                                                textAlign: TextAlign.start,
                                                                                              ),
                                                                                              SizedBox(width: 5),
                                                                                              CustomeText(
                                                                                                text: "${aWBItem.nPR}",
                                                                                                fontColor: MyColor.colorBlack,
                                                                                                fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                                                                                fontWeight: FontWeight.w600,
                                                                                                textAlign: TextAlign.start,
                                                                                              ),
                                                                                            ],
                                                                                          ),
                                                                                        ),
                                                                                      ],
                                                                                    ),

                                                                                    (isExpand)
                                                                                        ? Column(
                                                                                      children: [
                                                                                        SizedBox(height: SizeConfig.blockSizeVertical * 0.8,),
                                                                                        Row(
                                                                                          children: [
                                                                                            Expanded(
                                                                                              flex: 1,
                                                                                              child: Row(
                                                                                                children: [
                                                                                                  CustomeText(
                                                                                                    text: "Wt. Exp :",
                                                                                                    fontColor: MyColor.textColorGrey2,
                                                                                                    fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                                                                                    fontWeight: FontWeight.w400,
                                                                                                    textAlign: TextAlign.start,
                                                                                                  ),
                                                                                                  SizedBox(width: 5),
                                                                                                  CustomeText(
                                                                                                    text: "${CommonUtils.formateToTwoDecimalPlacesValue(aWBItem.weightExp!)}",
                                                                                                    fontColor: MyColor.colorBlack,
                                                                                                    fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                                                                                    fontWeight: FontWeight.w600,
                                                                                                    textAlign: TextAlign.start,
                                                                                                  ),
                                                                                                ],
                                                                                              ),
                                                                                            ),
                                                                                            Expanded(
                                                                                              flex: 1,
                                                                                              child: Row(
                                                                                                children: [
                                                                                                  CustomeText(
                                                                                                    text: "Wt. Rec. :",
                                                                                                    fontColor: MyColor.textColorGrey2,
                                                                                                    fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                                                                                    fontWeight: FontWeight.w400,
                                                                                                    textAlign: TextAlign.start,
                                                                                                  ),
                                                                                                  SizedBox(width: 5),
                                                                                                  CustomeText(
                                                                                                    text: "${CommonUtils.formateToTwoDecimalPlacesValue(aWBItem.weightRec!)}",
                                                                                                    fontColor: MyColor.colorBlack,
                                                                                                    fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                                                                                    fontWeight: FontWeight.w600,
                                                                                                    textAlign: TextAlign.start,
                                                                                                  ),
                                                                                                ],
                                                                                              ),
                                                                                            ),
                                                                                          ],
                                                                                        ),
                                                                                        SizedBox(height: SizeConfig.blockSizeVertical * 0.8,),
                                                                                        Row(
                                                                                          children: [
                                                                                            Expanded(
                                                                                              flex: 1,
                                                                                              child: Row(
                                                                                                children: [
                                                                                                  CustomeText(
                                                                                                    text: "Short :",
                                                                                                    fontColor: MyColor.textColorGrey2,
                                                                                                    fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                                                                                    fontWeight: FontWeight.w400,
                                                                                                    textAlign: TextAlign.start,
                                                                                                  ),
                                                                                                  SizedBox(width: 5),
                                                                                                  CustomeText(
                                                                                                    text: "${aWBItem.shortLanded}",
                                                                                                    fontColor: MyColor.colorBlack,
                                                                                                    fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                                                                                    fontWeight: FontWeight.w600,
                                                                                                    textAlign: TextAlign.start,
                                                                                                  ),
                                                                                                ],
                                                                                              ),
                                                                                            ),
                                                                                            Expanded(
                                                                                              flex: 1,
                                                                                              child: Row(
                                                                                                children: [
                                                                                                  CustomeText(
                                                                                                    text: "Excess :",
                                                                                                    fontColor: MyColor.textColorGrey2,
                                                                                                    fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                                                                                    fontWeight: FontWeight.w400,
                                                                                                    textAlign: TextAlign.start,
                                                                                                  ),
                                                                                                  SizedBox(width: 5),
                                                                                                  CustomeText(
                                                                                                    text: "${aWBItem.excessLanded}",
                                                                                                    fontColor: MyColor.colorBlack,
                                                                                                    fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                                                                                    fontWeight: FontWeight.w600,
                                                                                                    textAlign: TextAlign.start,
                                                                                                  ),
                                                                                                ],
                                                                                              ),
                                                                                            ),

                                                                                          ],
                                                                                        ),
                                                                                        SizedBox(height: SizeConfig.blockSizeVertical * 0.8,),
                                                                                        Row(
                                                                                          children: [
                                                                                            Expanded(
                                                                                              flex: 1,
                                                                                              child: Row(
                                                                                                children: [
                                                                                                  CustomeText(
                                                                                                    text: "Dmg. Pcs. :",
                                                                                                    fontColor: MyColor.textColorGrey2,
                                                                                                    fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                                                                                    fontWeight: FontWeight.w400,
                                                                                                    textAlign: TextAlign.start,
                                                                                                  ),
                                                                                                  SizedBox(width: 5),
                                                                                                  CustomeText(
                                                                                                    text: "${aWBItem.damageNOP}",
                                                                                                    fontColor: MyColor.colorBlack,
                                                                                                    fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                                                                                    fontWeight: FontWeight.w600,
                                                                                                    textAlign: TextAlign.start,
                                                                                                  ),
                                                                                                ],
                                                                                              ),
                                                                                            ),
                                                                                            Expanded(
                                                                                              flex: 1,
                                                                                              child: Row(
                                                                                                children: [
                                                                                                  CustomeText(
                                                                                                    text: "Dmg. Wt. :",
                                                                                                    fontColor: MyColor.textColorGrey2,
                                                                                                    fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                                                                                    fontWeight: FontWeight.w400,
                                                                                                    textAlign: TextAlign.start,
                                                                                                  ),
                                                                                                  SizedBox(width: 5),
                                                                                                  CustomeText(
                                                                                                    text: "${CommonUtils.formateToTwoDecimalPlacesValue(aWBItem.damageWeight!)}",
                                                                                                    fontColor: MyColor.colorBlack,
                                                                                                    fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                                                                                    fontWeight: FontWeight.w600,
                                                                                                    textAlign: TextAlign.start,
                                                                                                  ),
                                                                                                ],
                                                                                              ),
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

                                                                                      ],
                                                                                    )
                                                                                        : SizedBox(),


                                                                                    SizedBox(height: SizeConfig.blockSizeVertical,),
                                                                                    Row(
                                                                                      children: [
                                                                                        Expanded(
                                                                                          flex : 1,
                                                                                          child: Row(
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
                                                                                                          text: "P - ${aWBItem.bDPriority}",
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
                                                                                                        "${aWBItem.bDPriority}",
                                                                                                        index,
                                                                                                        aWBItem,
                                                                                                        lableModel,
                                                                                                        textDirection);

                                                                                                  },
                                                                                                ),
                                                                                              ),
                                                                                            ],
                                                                                          ),
                                                                                        ),

                                                                                        Expanded(
                                                                                            flex: 1,
                                                                                            child: (aWBItem.mAWBInd == "M") ? CustomeText(text: "House", fontColor: MyColor.textColorGrey2, fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5, fontWeight: FontWeight.w400, textAlign: TextAlign.start) : (aWBItem.transit!.isNotEmpty)
                                                                                                ? Row(
                                                                                              children: [
                                                                                                CustomeText(
                                                                                                  text: "Transit :",
                                                                                                  fontColor: MyColor.textColorGrey2,
                                                                                                  fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                                                                                  fontWeight: FontWeight.w400,
                                                                                                  textAlign: TextAlign.start,
                                                                                                ),
                                                                                                SizedBox(width: 5),
                                                                                                CustomeText(text: "${flightParts[0]} - ${aWBItem.destination}", fontColor: MyColor.textColorGrey, fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5, fontWeight: FontWeight.w400, textAlign: TextAlign.start),
                                                                                              ],
                                                                                            )
                                                                                                : Row(
                                                                                              children: [
                                                                                                CustomeText(
                                                                                                  text: "Agent :",
                                                                                                  fontColor: MyColor.textColorGrey2,
                                                                                                  fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                                                                                  fontWeight: FontWeight.w400,
                                                                                                  textAlign: TextAlign.start,
                                                                                                ),
                                                                                                SizedBox(width: 5),
                                                                                                CustomeText(text: aWBItem.agentName!, fontColor: MyColor.textColorGrey, fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5, fontWeight: FontWeight.w400, textAlign: TextAlign.start),
                                                                                              ],
                                                                                            )),
                                                                                      ],
                                                                                    ),
                                                                                    SizedBox(height: SizeConfig.blockSizeVertical,),
                                                                                    CustomDivider(
                                                                                      space: 0,
                                                                                      color: MyColor.textColorGrey,
                                                                                      hascolor: true,
                                                                                      thickness: 1,
                                                                                    ),
                                                                                    SizedBox(height: SizeConfig.blockSizeVertical,),
                                                                                    Row(
                                                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                      children: [
                                                                                        InkWell(
                                                                                            onTap: () async {

                                                                                              setState(() {
                                                                                                _selectedIndex = index;
                                                                                                // Toggle the expansion state of the item
                                                                                                if (_isExpandedDetails == index) {
                                                                                                  _isExpandedDetails = null; // Collapse if already expanded
                                                                                                } else {
                                                                                                  _isExpandedDetails = index; // Expand this item
                                                                                                }
                                                                                              });


                                                                                            },
                                                                                            child: CustomeText(text: isExpand ? "${lableModel.showLessDetails}" : "${lableModel.showMoreDetails}", fontColor: MyColor.primaryColorblue, fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_7, fontWeight: FontWeight.w500, textAlign: TextAlign.start)),
                                                                                        InkWell(
                                                                                          onTap: () async {

                                                                                            setState(() {
                                                                                              _selectedIndex = index; // Update the selected index
                                                                                            });





                                                                                            if(widget.flightDetailSummary.flightStatus == "A"){
                                                                                              if(widget.bDEndStatus == "N"){
                                                                                                if(widget.awbRemarkRequires == "Y"){
                                                                                                  if(aWBItem.remark == "Y"){

                                                                                                    List<AWBRemarksList> remarkList = filterAWBRemarksById(awbModel!.aWBRemarksList!, aWBItem.iMPAWBRowId!);
                                                                                                    var value = await Navigator.push(context, CupertinoPageRoute(builder: (context) => AWBRemarkListAckPage(
                                                                                                      buttonRightsList: widget.buttonRightsList,
                                                                                                      mainMenuName: widget.mainMenuName, aWBRemarkList:remarkList, aWBItem: aWBItem, menuId: widget.menuId,),));
                                                                                                    if(value == "true"){
                                                                                                      gotoCheckAWBScreen(aWBItem);
                                                                                                    }else if(value == "Done"){
                                                                                                      _resumeTimerOnInteraction();
                                                                                                    }
                                                                                                  }else{
                                                                                                    gotoCheckAWBScreen(aWBItem);
                                                                                                  }
                                                                                                }
                                                                                                else{
                                                                                                  gotoCheckAWBScreen(aWBItem);
                                                                                                }
                                                                                              }
                                                                                              else{
                                                                                                if(widget.uldNo == "BULK"){

                                                                                                  if(aWBItem.damageNOP == 0){
                                                                                                    SnackbarUtil.showSnackbar(context, "Breakdown already completed.", MyColor.colorRed, icon: FontAwesomeIcons.times);
                                                                                                    Vibration.vibrate(duration: 500);
                                                                                                  }
                                                                                                  else{

                                                                                                    int npxPices = aWBItem.nPR!;
                                                                                                    double weightCo = double.parse(((npxPices * aWBItem.weightExp!) / aWBItem.nPX!).toStringAsFixed(2));


                                                                                                    var value = await Navigator.push(context, CupertinoPageRoute(builder: (context) => DamageShimentPage(
                                                                                                      pageView: 1,
                                                                                                      enterDamageNop: 0,
                                                                                                      enterDamageWt: 0.00,
                                                                                                      damageNop: aWBItem.damageNOP!,
                                                                                                      damageWt: aWBItem.damageWeight!,
                                                                                                      buttonRightsList: widget.buttonRightsList,
                                                                                                      aWBItem: aWBItem, flightDetailSummary: widget.flightDetailSummary, mainMenuName: widget.mainMenuName, userId: _user!.userProfile!.userIdentity!, companyCode: _splashDefaultData!.companyCode!,  menuId: widget.menuId, npxPieces: npxPices, npxWeightCo: weightCo, groupId: "",),));

                                                                                                    if(value == "Done"){
                                                                                                      _resumeTimerOnInteraction();
                                                                                                    }else if(value == "true"){
                                                                                                      //Navigator.pop(context, "true");

                                                                                                      context.read<FlightCheckCubit>().getAWBList(widget.flightDetailSummary.flightSeqNo!, widget.uldSeqNo, _user!.userProfile!.userIdentity!, _splashDefaultData!.companyCode!, widget.menuId,  (_isOpenULDFlagEnable == true) ? 1 : 0);

                                                                                                    }


                                                                                                  }



                                                                                                }
                                                                                                else{
                                                                                                  if(aWBItem.damageNOP == 0){
                                                                                                    SnackbarUtil.showSnackbar(context, "Breakdown already completed.", MyColor.colorRed, icon: FontAwesomeIcons.times);
                                                                                                    Vibration.vibrate(duration: 500);
                                                                                                  }
                                                                                                  else{

                                                                                                    int npxPices = aWBItem.nPR!;
                                                                                                    double weightCo = double.parse(((npxPices * aWBItem.weightExp!) / aWBItem.nPX!).toStringAsFixed(2));



                                                                                                    var value = await Navigator.push(context, CupertinoPageRoute(builder: (context) => DamageShimentPage(
                                                                                                      pageView: 1,
                                                                                                      enterDamageNop: 0,
                                                                                                      enterDamageWt: 0.00,
                                                                                                      damageNop: aWBItem.damageNOP!,
                                                                                                      damageWt: aWBItem.damageWeight!,
                                                                                                      buttonRightsList: widget.buttonRightsList,
                                                                                                      aWBItem: aWBItem, flightDetailSummary: widget.flightDetailSummary, mainMenuName: widget.mainMenuName, userId: _user!.userProfile!.userIdentity!, companyCode: _splashDefaultData!.companyCode!,  menuId: widget.menuId, npxPieces: npxPices, npxWeightCo: weightCo, groupId: "",),));


                                                                                                    if(value == "Done"){
                                                                                                      _resumeTimerOnInteraction();
                                                                                                    }else if(value == "true"){
                                                                                                      //Navigator.pop(context, "true");

                                                                                                      context.read<FlightCheckCubit>().getAWBList(widget.flightDetailSummary.flightSeqNo!, widget.uldSeqNo, _user!.userProfile!.userIdentity!, _splashDefaultData!.companyCode!, widget.menuId,  (_isOpenULDFlagEnable == true) ? 1 : 0);

                                                                                                    }

                                                                                                  }
                                                                                                }

                                                                                              }
                                                                                            }else if(widget.flightDetailSummary.flightStatus == "F"){
                                                                                             /* SnackbarUtil.showSnackbar(context, "Flight is finalized", MyColor.colorRed, icon: FontAwesomeIcons.times);
                                                                                              Vibration.vibrate(duration: 500);*/

                                                                                              if(aWBItem.damageNOP == 0){
                                                                                                SnackbarUtil.showSnackbar(context, "Breakdown already completed.", MyColor.colorRed, icon: FontAwesomeIcons.times);
                                                                                                Vibration.vibrate(duration: 500);
                                                                                              }
                                                                                              else{

                                                                                                int npxPices = aWBItem.nPR!;
                                                                                                double weightCo = double.parse(((npxPices * aWBItem.weightExp!) / aWBItem.nPX!).toStringAsFixed(2));


                                                                                                var value = await Navigator.push(context, CupertinoPageRoute(builder: (context) => DamageShimentPage(
                                                                                                  pageView: 1,
                                                                                                  enterDamageNop: 0,
                                                                                                  enterDamageWt: 0.00,
                                                                                                  damageNop: aWBItem.damageNOP!,
                                                                                                  damageWt: aWBItem.damageWeight!,
                                                                                                  buttonRightsList: widget.buttonRightsList,
                                                                                                  aWBItem: aWBItem, flightDetailSummary: widget.flightDetailSummary, mainMenuName: widget.mainMenuName, userId: _user!.userProfile!.userIdentity!, companyCode: _splashDefaultData!.companyCode!,  menuId: widget.menuId, npxPieces: npxPices, npxWeightCo: weightCo, groupId: "",),));

                                                                                                if(value == "Done"){
                                                                                                  _resumeTimerOnInteraction();
                                                                                                }else if(value == "true"){
                                                                                                  //Navigator.pop(context, "true");

                                                                                                  context.read<FlightCheckCubit>().getAWBList(widget.flightDetailSummary.flightSeqNo!, widget.uldSeqNo, _user!.userProfile!.userIdentity!, _splashDefaultData!.companyCode!, widget.menuId,  (_isOpenULDFlagEnable == true) ? 1 : 0);

                                                                                                }


                                                                                              }

                                                                                            }else if(widget.flightDetailSummary.flightStatus == "N"){
                                                                                              SnackbarUtil.showSnackbar(context, "Flight is not arrived", MyColor.colorRed, icon: FontAwesomeIcons.times);
                                                                                              Vibration.vibrate(duration: 500);
                                                                                            }



                                                                                          },
                                                                                          child: Container(
                                                                                            padding: EdgeInsets.symmetric(vertical: 5, horizontal: 8),
                                                                                            decoration: BoxDecoration(
                                                                                                color: MyColor.dropdownColor,
                                                                                                borderRadius: BorderRadius.circular(SizeConfig.blockSizeHorizontal * SizeUtils.WIDTH3)
                                                                                            ),
                                                                                            child: Icon(Icons.navigate_next_rounded, color: MyColor.primaryColorblue, size: SizeConfig.blockSizeVertical * SizeUtils.ICONSIZE_2_5,),
                                                                                          ),
                                                                                        )
                                                                                      ],)
                                                                                  ],
                                                                                ),
                                                                                Positioned(
                                                                                  right: 0,
                                                                                  top: 0,
                                                                                  child: Column(
                                                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                                                    children: [
                                                                                      Container(
                                                                                        height : SizeConfig.blockSizeVertical * SizeUtils.HEIGHT6,
                                                                                        width : SizeConfig.blockSizeVertical * SizeUtils.HEIGHT6,
                                                                                        child: DashedCircularProgressBar.aspectRatio(
                                                                                          aspectRatio: 2.1, // width ÷ height
                                                                                          valueNotifier: _valueNotifier1,
                                                                                          progress: aWBItem.progress!.toDouble(),
                                                                                          maxProgress: 100,
                                                                                          corners: StrokeCap.butt,
                                                                                          foregroundColor: (aWBItem.progress!.toDouble() == 100) ? MyColor.colorgreenProgress  : MyColor.colorOrangeProgress,
                                                                                          backgroundColor: const Color(0xffF2F4F8),
                                                                                          foregroundStrokeWidth: 5,
                                                                                          backgroundStrokeWidth: 5,
                                                                                          animation: true,
                                                                                          child: Center(
                                                                                            child: ValueListenableBuilder(
                                                                                              valueListenable: _valueNotifier1,
                                                                                              builder: (_, double value, __) {
                                                                                                return CustomeText(text: '${value.toInt()}%', fontColor:  MyColor.colorBlack, fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_3, fontWeight: FontWeight.w500, textAlign: TextAlign.center);
                                                                                              },
                                                                                            ),
                                                                                          ),


                                                                                        ),
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                )

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
                                                            : Padding(
                                                              padding: const EdgeInsets.symmetric(vertical: 10.0),
                                                              child: Center(
                                                                child: CustomeText(text: "${lableModel.recordNotFound}",
                                                                fontColor: MyColor.textColorGrey,
                                                                fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_2_0,
                                                                fontWeight: FontWeight.w500,
                                                                textAlign: TextAlign.center),),
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


  Future<void> gotoCheckAWBScreen(FlightCheckInAWBBDList aWBItem) async {
    inactivityTimerManager!.stopTimer();
    var value = await Navigator.push(
        context,
        CupertinoPageRoute(
            builder: (context) => CheckAWBPage(
              buttonRightsList: widget.buttonRightsList,
              aWBItem: aWBItem,
              mainMenuName: widget.mainMenuName,
              flightDetailSummary: widget.flightDetailSummary,
              location: widget.location,
              uldSeqNo: widget.uldSeqNo,
              menuId: widget.menuId,
              lableModel: widget.lableModel,
              groupIDRequires: widget.groupIDRequires,
              groupIDCharSize: widget.groupIDCharSize,
            )));

    if(value == "Done"){
      _resumeTimerOnInteraction();
    }else if(value == "true"){
      context.read<FlightCheckCubit>().getAWBList(widget.flightDetailSummary.flightSeqNo!, widget.uldSeqNo, _user!.userProfile!.userIdentity!, _splashDefaultData!.companyCode!, widget.menuId,  (_isOpenULDFlagEnable == true) ? 1 : 0);
    }

  }


  // update serch list function
 /* void updateSearchList(String searchText, LableModel lableModel) {
    setState(() {
      _selectedIndex = -1;
      if (searchText.isEmpty) {
        filterAWBDetailsList = List.from(awbItemList);
        filterAWBDetailsList.sort((a, b) => b.bDPriority!.compareTo(a.bDPriority!));
      } else {
        filterAWBDetailsList = List.from(awbItemList);
        filterAWBDetailsList.sort((a, b) {
          final aContains = a.aWBNo!
              .replaceAll(" ", "")
              .toLowerCase()
              .contains(searchText.toLowerCase());
          final bContains = b.aWBNo!
              .replaceAll(" ", "")
              .toLowerCase()
              .contains(searchText.toLowerCase());

          if (aContains && !bContains) {
            return -1;
          } else if (!aContains && bContains) {
            return 1;
          } else {
            return 0;
          }
        });


        
      }
    });

    if (filterAWBDetailsList.isEmpty || !filterAWBDetailsList.any((awb) =>
        awb.aWBNo!.replaceAll(" ", "").toLowerCase().contains(searchText.toLowerCase()))) {


      SnackbarUtil.showSnackbar(context, "${lableModel.recordNotFound} $searchText", MyColor.colorRed, icon: FontAwesomeIcons.times);

    }
  }*/

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
  List<FlightCheckInAWBBDList> _applyFiltersAndSorting(List<FlightCheckInAWBBDList> list, String searchString) {
    // Filter by search string
    List<FlightCheckInAWBBDList> filteredList = list.where((item) {
      return item.aWBNo!.toLowerCase().contains(searchString.toLowerCase());
    }).toList();

    return filteredList;
  }



  List<AWBRemarksList> filterAWBRemarksById(List<AWBRemarksList> awbRemarkList, int iMPAWBRowId) {
    return awbRemarkList.where((remark) => remark.iMPAWBRowId == iMPAWBRowId).toList();
  }


  Future<void> scanQR(LableModel lableModel) async {
    String barcodeScanResult =  await FlutterBarcodeScanner.scanBarcode(
      '#ff6666', // Color for the scanner overlay
      'Cancel', // Text for the cancel button
      true, // Enable flash option
      ScanMode.DEFAULT, // Scan mode
    );

    print("barcode scann ==== ${barcodeScanResult}");
    if(barcodeScanResult == "-1"){
    }else{

      bool specialCharAllow = CommonUtils.containsSpecialCharacters(barcodeScanResult);

      print("SPECIALCHAR_ALLOW ===== ${specialCharAllow}");

      if(specialCharAllow == true){
        SnackbarUtil.showSnackbar(context, "Invalid AWB No.", MyColor.colorRed, icon: FontAwesomeIcons.times);
        Vibration.vibrate(duration: 500);
        scanNoEditingController.clear();
        WidgetsBinding.instance.addPostFrameCallback((_) {
          FocusScope.of(context).requestFocus(scanAwbFocusNode);
        });
      }else{

        if (RegExp(r'[a-zA-Z]').hasMatch(barcodeScanResult)) {
          // Show invalid message if alphabet characters are present
          SnackbarUtil.showSnackbar(context, "Invalid AWB No.", MyColor.colorRed, icon: FontAwesomeIcons.times);
          Vibration.vibrate(duration: 500);
          scanNoEditingController.clear();
          WidgetsBinding.instance.addPostFrameCallback((_) {
            FocusScope.of(context).requestFocus(scanAwbFocusNode);
          });
        } else {
          String result = barcodeScanResult.replaceAll(" ", "");
          String truncatedResult = result.length > 11
              ? result.substring(0, 11)
              : result;

          scanNoEditingController.text = truncatedResult.toString();
          updateSearchList(scanNoEditingController.text);
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
      FlightCheckInAWBBDList awbItm,
      LableModel lableModel,
      ui.TextDirection textDirection) async {
    FocusScope.of(context).unfocus();
    String? updatedPriority = await DialogUtils.showPriorityChangeBottomAWBDialog(context, awbNo, priority, lableModel, textDirection);
    if (updatedPriority != null) {
      int newPriority = int.parse(updatedPriority);

      if (newPriority != 0) {
        // Call your API to update the priority in the backend
        await callbdPriorityApi(
            context,
            awbItm.iMPShipRowId!,
            newPriority,
            _user!.userProfile!.userIdentity!,
            _splashDefaultData!.companyCode!,
            widget.menuId);

        setState(() {
          // Update the BDPriority for the selected item
          filterAWBDetailsList[index].bDPriority = newPriority;

          // Sort the list based on BDPriority
          filterAWBDetailsList.sort((a, b) => b.bDPriority!.compareTo(a.bDPriority!));
        });
      } else {
        Vibration.vibrate(duration: 500);
        SnackbarUtil.showSnackbar(context, "${lableModel.prioritymsg}", MyColor.colorRed, icon: FontAwesomeIcons.times);
      }
    } else {
      print("Priority update was canceled");
    }
  }

  Future<void> callbdPriorityApi(
      BuildContext context,
      int iMPShipRowId,
      int bdPriority,
      int userId,
      int companyCode,
      int menuId) async {
    await context.read<FlightCheckCubit>().bdPriorityAWB(iMPShipRowId, bdPriority, userId, companyCode, menuId);
  }

}

// ticker animation for DGR code blink animation
class TickerProviders extends TickerProvider {
  @override
  Ticker createTicker(onTick) => Ticker(onTick);
}

