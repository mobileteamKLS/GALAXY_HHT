import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:galaxy/module/import/pages/flightcheck/damageshipment/damageshipment.dart';
import 'package:galaxy/module/import/services/flightcheck/flightchecklogic/flightcheckcubit.dart';
import 'package:galaxy/module/import/services/flightcheck/flightchecklogic/flightcheckstate.dart';
import 'package:galaxy/utils/awbformatenumberutils.dart';
import 'package:galaxy/utils/sizeutils.dart';
import 'package:galaxy/utils/snackbarutil.dart';
import 'package:galaxy/widget/customebuttons/roundbuttonblue.dart';
import 'package:galaxy/widget/customedrawer/customedrawer.dart';
import 'package:galaxy/widget/custometext.dart';
import 'package:vibration/vibration.dart';


import 'dart:ui' as ui;

import '../../../../../core/images.dart';
import '../../../../../core/mycolor.dart';
import '../../../../../language/appLocalizations.dart';
import '../../../../../language/model/lableModel.dart';
import '../../../../../manager/timermanager.dart';
import '../../../../../prefrence/savedprefrence.dart';
import '../../../../../utils/commonutils.dart';
import '../../../../../utils/dialogutils.dart';
import '../../../../../utils/validationmsgcodeutils.dart';
import '../../../../../widget/customeuiwidgets/header.dart';
import '../../../../../widget/customtextfield.dart';
import '../../../../../widget/header/mainheadingwidget.dart';
import '../../../../login/model/userlogindatamodel.dart';
import '../../../../login/pages/signinscreenmethods.dart';
import '../../../../onboarding/sizeconfig.dart';
import '../../../../splash/model/splashdefaultmodel.dart';
import '../../../../submenu/model/submenumodel.dart';
import '../../../model/flightcheck/awblistmodel.dart';
import '../../../model/flightcheck/flightcheckuldlistmodel.dart';
import '../../../model/flightcheck/hawblistmodel.dart';
import '../../../model/uldacceptance/buttonrolesrightsmodel.dart';



class CheckHAWBPage extends StatefulWidget {

  List<ButtonRight> buttonRightsList;
  int uldSeqNo;
  FlightCheckInHAWBBDList haWBItem;
  FlightCheckInAWBBDList aWBItem;
  String mainMenuName;
  FlightDetailSummary flightDetailSummary;
  String location;
  int menuId;
  LableModel lableModel;
  String groupIDRequires;
  int groupIDCharSize;
  List<SubMenuName> importSubMenuList = [];
  List<SubMenuName> exportSubMenuList = [];

  CheckHAWBPage({super.key,
    required this.importSubMenuList,
    required this.exportSubMenuList,
    required this.buttonRightsList,
    required this.haWBItem,
    required this.aWBItem,
    required this.mainMenuName, required this.flightDetailSummary, required this.location, required this.uldSeqNo, required this.menuId, required this.lableModel, required this.groupIDRequires, required this.groupIDCharSize});

  @override
  State<CheckHAWBPage> createState() => _CheckHAWBPageState();
}

class _CheckHAWBPageState extends State<CheckHAWBPage> with SingleTickerProviderStateMixin{

  InactivityTimerManager? inactivityTimerManager;

  final SavedPrefrence savedPrefrence = SavedPrefrence();
  UserDataModel? _user;
  SplashDefaultModel? _splashDefaultData;


  String Clicks = "";



  TextEditingController piecesController = TextEditingController();
  TextEditingController weightController = TextEditingController();
  TextEditingController groupIdController = TextEditingController();




  FocusNode piecesFocusNode = FocusNode();
  FocusNode weightFocusNode = FocusNode();
  FocusNode groupIdFocusNode = FocusNode();



  late AnimationController _blinkController;
  late Animation<Color?> _colorAnimation;

  double weightCount = 0.00;




  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadUser();
  //  weightController.text = "${CommonUtils.formateToTwoDecimalPlacesValue(weightCount)}";
    _blinkController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: TickerProviders(), // Manually providing Ticker
    )..repeat(reverse: true); // Loop the animation

    _colorAnimation = ColorTween(
      begin: MyColor.shcColorList[0],
      end: Colors.transparent,
    ).animate(_blinkController); // color animation

    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(piecesFocusNode);
    });

  }

  Future<void> _loadUser() async {
    final user = await savedPrefrence.getUserData();
    final splashDefaultData = await savedPrefrence.getSplashDefaultData();
    if (user != null && splashDefaultData != null) {
      setState(() {
        _user = user;
        _splashDefaultData = splashDefaultData;
      });

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
    Navigator.pop(context, "true");
    return false; // Prevents the default back button action
  }


  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    inactivityTimerManager!.stopTimer();
  }
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();


  @override
  Widget build(BuildContext context) {
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


    List<String> shcCodes = widget.haWBItem.sHCCode!.split(',');

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Directionality(
        textDirection: uiDirection,
        child: SafeArea(
            child: GestureDetector(
              onTap: _resumeTimerOnInteraction,  // Resuming on any tap
              onPanDown: (details) => _resumeTimerOnInteraction(), // Resuming on any gesture
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
                        backgroundColor: MyColor.colorWhite,
                        body: Stack(
              children: [

                MainHeadingWidget(mainMenuName: widget.mainMenuName,
                  onDrawerIconTap: () => _scaffoldKey.currentState?.openDrawer(),
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
                                      child: Directionality(
                      textDirection: textDirection,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 10, right: 15, top: 12, bottom: 12),
                            child: Directionality(
                              textDirection: uiDirection,
                              child: HeaderWidget(
                                titleTextColor: MyColor.colorBlack,
                                title: "${lableModel!.checkInHAWB}",
                                onBack: () {
                                  _onWillPop();
                                },
                                clearText: lableModel!.clear,
                                onClear: () {
                                  piecesController.clear();
                                  weightController.clear();
                                  groupIdController.clear();

                                  weightCount = 0.00;
                                 // weightController.text = "${weightCount.toStringAsFixed(2)}";
                                  weightController.clear();
                                  WidgetsBinding.instance.addPostFrameCallback((_) {
                                    FocusScope.of(context).requestFocus(piecesFocusNode);
                                  });
                                },
                              ),
                            ),
                          ),

                          BlocListener<FlightCheckCubit, FlightCheckState>(
                            listener: (context, state) async {
                              if(state is MainLoadingState){
                                DialogUtils.showLoadingDialog(context, message: lableModel.loading);
                              }
                              else if(state is ImportShipmentSaveSuccessState){
                                DialogUtils.hideLoadingDialog(context);

                                if(state.importShipmentModel.status == "E"){
                                  Vibration.vibrate(duration: 500);
                                  SnackbarUtil.showSnackbar(context, state.importShipmentModel.statusMessage!, MyColor.colorRed, icon: FontAwesomeIcons.times);
                                }else{
                                 // SnackbarUtil.showSnackbar(context, state.importShipmentModel.statusMessage!, MyColor.colorGreen, icon: Icons.done);

                                  if(Clicks == "S"){
                                    Navigator.pop(context, "true");
                                  }else if(Clicks == "D"){
                                    int damageNop = widget.haWBItem.damageNOP!;
                                    double damageWt = widget.haWBItem.damageWeight!;


                                    int npxPices = widget.haWBItem.nPR!;
                                    double weightCo = double.parse(((npxPices * widget.haWBItem.weightExp!) / widget.haWBItem.nPX!).toStringAsFixed(2));

                                    var value = await Navigator.push(context, CupertinoPageRoute(builder: (context) => DamageShimentPage(
                                      importSubMenuList: widget.importSubMenuList,
                                      exportSubMenuList: widget.exportSubMenuList,
                                      lableModel: lableModel,
                                      pageView: 0,
                                      enterDamageNop: int.parse(piecesController.text),
                                      enterDamageWt: double.parse(weightController.text),
                                      damageNop: damageNop,
                                      damageWt: damageWt,
                                      buttonRightsList: widget.buttonRightsList,
                                      haWBItem: widget.haWBItem, flightDetailSummary: widget.flightDetailSummary, mainMenuName: widget.mainMenuName, userId: _user!.userProfile!.userIdentity!, companyCode: _splashDefaultData!.companyCode!,  menuId: widget.menuId, npxPieces: npxPices, npxWeightCo: weightCo, groupId: groupIdController.text,),));

                                    if(value == "Done"){
                                      _resumeTimerOnInteraction();
                                      Navigator.pop(context, "true");
                                    }else if(value == "true"){
                                      Navigator.pop(context, "true");
                                    }
                                  }


                                }

                              }else if(state is ImportShipmentSaveFailureState){
                                Vibration.vibrate(duration: 500);
                                SnackbarUtil.showSnackbar(context, state.error, MyColor.colorRed, icon: FontAwesomeIcons.times);
                              }
                          },
                          child: Expanded(
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
                                                      text: "${lableModel.detailsforHAWBNo} ${widget.haWBItem.houseNo}",
                                                      fontColor: MyColor.textColorGrey2,
                                                      fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                                      fontWeight: FontWeight.w500,
                                                      textAlign: TextAlign.start)
                                                ],
                                              ),
                                            ),
                                            SizedBox(height: SizeConfig.blockSizeVertical * SizeUtils.HEIGHT2),
                                            // text manifest and recived in pices text counter
                                            Row(
                                              children: [
                                                Expanded(
                                                  flex:1,
                                                  child: Directionality(
                                                    textDirection: textDirection,
                                                    child: CustomTextField(
                                                      textDirection: textDirection,
                                                      controller: piecesController,
                                                      focusNode: piecesFocusNode,
                                                      nextFocus: groupIdFocusNode,
                                                      onPress: () {},
                                                      hasIcon: false,
                                                      hastextcolor: true,
                                                      animatedLabel: true,
                                                      needOutlineBorder: true,
                                                      labelText: "${lableModel.pieces} *",
                                                      readOnly: false,
                                                      maxLength: 4,
                                                      onChanged: (value) {
                                                        int piecesCount = int.tryParse(value) ?? 0;

                                                        // Calculate the weight count using the formula
                                                        setState(() {

                                                          weightCount = double.parse(((piecesCount * widget.haWBItem.weightExp!) / widget.haWBItem.nPX!).toStringAsFixed(2));


                                                         // weightCount = double.parse(((piecesCount / widget.aWBItem.nPX!) * widget.aWBItem.weightExp!).toStringAsFixed(2));
                                                          weightController.text = "${CommonUtils.formateToTwoDecimalPlacesValue(weightCount)}";
                                                        });

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
                                                SizedBox(width: SizeConfig.blockSizeHorizontal * SizeUtils.WIDTH2,),
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
                                                          weightCount = double.parse(CommonUtils.formateToTwoDecimalPlacesValue(value));
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
                                            SizedBox(height: SizeConfig.blockSizeVertical * SizeUtils.HEIGHT2),
                                            // text manifest and recived in pices text counter
                                            Directionality(
                                              textDirection: textDirection,
                                              child: CustomTextField(
                                                textDirection: textDirection,
                                                controller: groupIdController,
                                                focusNode: groupIdFocusNode,
                                                onPress: () {},
                                                hasIcon: false,
                                                hastextcolor: true,
                                                animatedLabel: true,
                                                needOutlineBorder: true,
                                                labelText: widget.groupIDRequires == "Y" ? "${lableModel.groupId} *" : "${lableModel.groupId}",
                                                readOnly: false,
                                                maxLength: widget.groupIDCharSize,
                                                onChanged: (value) {},
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
                                          ],
                                        ),
                                      ),

                                      SizedBox(
                                        height: SizeConfig.blockSizeVertical,
                                      ),

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
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Row(
                                                  children: [
                                                    CustomeText(
                                                      text: "${widget.flightDetailSummary.flightNo!}",
                                                      fontColor: MyColor.colorBlack,
                                                      fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                                      fontWeight: FontWeight.w600,
                                                      textAlign: TextAlign.start,
                                                    ),
                                                    SizedBox(width: 5),
                                                    CustomeText(
                                                      text: " ${widget.flightDetailSummary.flightDate!.replaceAll(" ", "-")}",
                                                      fontColor: MyColor.textColorGrey2,
                                                      fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                                      fontWeight: FontWeight.w600,
                                                      textAlign: TextAlign.start,
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    SvgPicture.asset(map, height: SizeConfig.blockSizeVertical * SizeUtils.ICONSIZE2,),
                                                    SizedBox(width: SizeConfig.blockSizeHorizontal,),
                                                    CustomeText(
                                                      text: widget.location,
                                                      fontColor: MyColor.colorBlack,
                                                      fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                                      fontWeight: FontWeight.w600,
                                                      textAlign: TextAlign.start,
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),

                                            (shcCodes.isNotEmpty) ? SizedBox(height: SizeConfig.blockSizeVertical,) : SizedBox(),

                                            Row(
                                              children: [
                                                widget.haWBItem.sHCCode!.isNotEmpty
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
                                            SizedBox(height: SizeConfig.blockSizeVertical,),
                                            Row(
                                              children: [
                                                CustomeText(
                                                  text: "NoG : ",
                                                  fontColor: MyColor.textColorGrey2,
                                                  fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                                  fontWeight: FontWeight.w400,
                                                  textAlign: TextAlign.start,
                                                ),
                                                SizedBox(width: 5),
                                                CustomeText(
                                                  text: "${widget.haWBItem.nOG}",
                                                  fontColor: MyColor.colorBlack,
                                                  fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                                  fontWeight: FontWeight.w600,
                                                  textAlign: TextAlign.start,
                                                ),
                                              ],
                                            ),

                                            SizedBox(height: SizeConfig.blockSizeVertical),
                                            Row(
                                              children: [
                                                CustomeText(
                                                  text: "Commodity : ",
                                                  fontColor: MyColor.textColorGrey2,
                                                  fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                                  fontWeight: FontWeight.w400,
                                                  textAlign: TextAlign.start,
                                                ),
                                                SizedBox(width: 5),
                                                CustomeText(
                                                  text: widget.haWBItem.commodity!,
                                                  fontColor: MyColor.colorBlack,
                                                  fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                                  fontWeight: FontWeight.w600,
                                                  textAlign: TextAlign.start,
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: SizeConfig.blockSizeVertical),
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
                                                        text: "${widget.haWBItem.nPX}",
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
                                                        text: "${widget.haWBItem.nPR}",
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

                                            SizedBox(height: SizeConfig.blockSizeVertical,),

                                            Row(
                                              children: [
                                                CustomeText(
                                                  text: "Suggestive Location : ",
                                                  fontColor: MyColor.textColorGrey2,
                                                  fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                                  fontWeight: FontWeight.w400,
                                                  textAlign: TextAlign.start,
                                                ),
                                                SizedBox(width: 5),
                                                CustomeText(
                                                  text: "-",
                                                  fontColor: MyColor.colorBlack,
                                                  fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                                  fontWeight: FontWeight.w600,
                                                  textAlign: TextAlign.start,
                                                ),
                                              ],
                                            ),



                                          ],
                                        ),
                                      ),

                                      SizedBox(
                                        height: SizeConfig.blockSizeVertical,
                                      ),
                                      Container(
                                        padding: EdgeInsets.all(10),
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
                                                text: "${lableModel.damageAndSave}",
                                                press: () async {

                                                  if(widget.flightDetailSummary.flightStatus == "A"){

                                                    print("widget.aWBItem.iMPAWBRowId ========= ${widget.aWBItem.iMPAWBRowId}");
                                                    print("widget.aWBItem.iMPShipRowId ========= ${widget.aWBItem.iMPShipRowId}");
                                                    print("widget.aWBItem.uSeqNo ========= ${widget.aWBItem.uSeqNo}");
                                                    print("widget.haWBItem.iMPAWBRowId ========= ${widget.haWBItem.iMPAWBRowId}");
                                                    print("widget.haWBItem.iMPSHIPRowId ========= ${widget.haWBItem.iMPSHIPRowId}");



                                                    String awbId = "${widget.aWBItem.iMPAWBRowId}~${widget.aWBItem.iMPShipRowId}~${widget.aWBItem.uSeqNo}";
                                                    String hawbId = "${widget.haWBItem.iMPAWBRowId}~${widget.haWBItem.iMPSHIPRowId}";

                                                    /*if (piecesController.text.isNotEmpty) {
                                                      if(int.parse(piecesController.text) == 0){
                                                        openValidationDialog("${lableModel.enterPiecesGrtMsg}", piecesFocusNode);
                                                        return;
                                                      }
                                                      return;
                                                    }*/

                                                    /*if (weightController.text.isNotEmpty) {
                                                      if(double.parse(weightController.text) == 0){
                                                        openValidationDialog("${lableModel.enterWeightGrtMsg}", weightFocusNode);
                                                        return;
                                                      }
                                                      return;
                                                    }
*/

                                                    if(isButtonEnabled("awbdamageandsave", widget.buttonRightsList)){


                                                      if(widget.groupIDRequires == "Y"){
                                                        if (groupIdController.text.isEmpty) {
                                                          openValidationDialog("${lableModel.enterGropIdMsg}", groupIdFocusNode);
                                                          return;
                                                        }

                                                        // Check if the groupId length is between 14 (min and max 14 characters)
                                                        if (groupIdController.text.length != widget.groupIDCharSize) {
                                                          openValidationDialog(formatMessage("${lableModel.groupIdCharSizeMsg}", ["${widget.groupIDCharSize}"]), groupIdFocusNode);
                                                          return;
                                                        }

                                                      }


                                                      CommonUtils.SELECTEDWHETHER = "";

                                                      CommonUtils.SELECTEDIMAGELIST.clear();

                                                      CommonUtils.shipTotalPcs = 0;
                                                      CommonUtils.ShipTotalWt = "0.00";
                                                      CommonUtils.shipDamagePcs = 0;
                                                      CommonUtils.ShipDamageWt = "0.00";
                                                      CommonUtils.shipDifferencePcs = 0;
                                                      CommonUtils.shipDifferenceWt = "0.00";
                                                      CommonUtils.individualWTPerDoc = "0.00";
                                                      CommonUtils.individualWTActChk = "0.00";
                                                      CommonUtils.individualWTDifference = "0.00";
                                                      CommonUtils.SELECTEDMATERIAL = "";
                                                      CommonUtils.SELECTEDTYPE = "";
                                                      CommonUtils.SELECTEDMARKANDLABLE = "";
                                                      CommonUtils.SELECTEDOUTRERPACKING = "";
                                                      CommonUtils.SELECTEDINNERPACKING = "";
                                                      CommonUtils.SELECTEDDAMAGEDISCOVER = "";
                                                      CommonUtils.SELECTEDDAMAGEAPPARENTLY = "";
                                                      CommonUtils.SELECTEDSALVAGEACTION = "";
                                                      CommonUtils.SELECTEDDISPOSITION = "";
                                                      CommonUtils.MISSINGITEM = "Y";
                                                      CommonUtils.VERIFIEDINVOICE = "Y";
                                                      CommonUtils.SUFFICIENT = "Y";
                                                      CommonUtils.EVIDENCE = "Y";
                                                      CommonUtils.REMARKS = "";

                                                      CommonUtils.SELECTEDCONTENT = "";

                                                      CommonUtils.SELECTEDCONTAINER = "";

                                                      Clicks = "D";

                                                      if(piecesController.text.isNotEmpty){
                                                        print("PICES HAWB NOT EMPTY");

                                                        if(int.parse(piecesController.text) == 0){
                                                          openValidationDialog("${lableModel.enterPiecesGrtMsg}", piecesFocusNode);
                                                          return;
                                                        }

                                                        if(double.parse(weightController.text) == 0){
                                                          openValidationDialog("${lableModel.enterWeightGrtMsg}", weightFocusNode);
                                                          return;
                                                        }

                                                        context.read<FlightCheckCubit>().importShipmentSave(widget.location, widget.flightDetailSummary.flightSeqNo!, widget.uldSeqNo, groupIdController.text, awbId, hawbId, int.parse(piecesController.text), weightController.text, _user!.userProfile!.userIdentity!, _splashDefaultData!.companyCode!, widget.menuId);

                                                      }
                                                      else{

                                                        print("PICES HAWB EMPTY");

                                                        int damageNop = widget.haWBItem.damageNOP!;
                                                        double damageWt = widget.haWBItem.damageWeight!;


                                                        int npxPices = widget.haWBItem.nPR!;
                                                        double weightCo = double.parse(((npxPices * widget.haWBItem.weightExp!) / widget.haWBItem.nPX!).toStringAsFixed(2));

                                                        var value = await Navigator.push(context, CupertinoPageRoute(builder: (context) => DamageShimentPage(
                                                          importSubMenuList: widget.importSubMenuList,
                                                          exportSubMenuList: widget.exportSubMenuList,
                                                          lableModel: lableModel,
                                                          pageView: 0,
                                                          enterDamageNop: (piecesController.text.isEmpty) ? 0 : int.parse(piecesController.text),
                                                          enterDamageWt: (weightController.text.isEmpty) ? 0.00 :  double.parse(weightController.text),
                                                          damageNop: damageNop,
                                                          damageWt: damageWt,
                                                          buttonRightsList: widget.buttonRightsList,
                                                          haWBItem: widget.haWBItem, flightDetailSummary: widget.flightDetailSummary, mainMenuName: widget.mainMenuName, userId: _user!.userProfile!.userIdentity!, companyCode: _splashDefaultData!.companyCode!,  menuId: widget.menuId, npxPieces: npxPices, npxWeightCo: weightCo, groupId: groupIdController.text,),));


                                                        if(value == "true"){
                                                          Navigator.pop(context, "true");
                                                        }else {
                                                          _resumeTimerOnInteraction();
                                                        }
                                                      }


                                                    }
                                                    else{
                                                      SnackbarUtil.showSnackbar(context, ValidationMessageCodeUtils.AuthorisedRolesAndRightsMsg, MyColor.colorRed, icon: FontAwesomeIcons.times);
                                                      Vibration.vibrate(duration: 500);
                                                    }
                                                  }else if(widget.flightDetailSummary.flightStatus == "F"){
                                                    SnackbarUtil.showSnackbar(context, "${lableModel.flightisFinalizedMsg}", MyColor.colorRed, icon: FontAwesomeIcons.times);
                                                    Vibration.vibrate(duration: 500);
                                                  }else if(widget.flightDetailSummary.flightStatus == "N"){
                                                    SnackbarUtil.showSnackbar(context, "${lableModel.flightisNotArrivedMsg}", MyColor.colorRed, icon: FontAwesomeIcons.times);
                                                    Vibration.vibrate(duration: 500);
                                                  }

                                                  },
                                              ),
                                            ),
                                            SizedBox(
                                              width: SizeConfig.blockSizeHorizontal * SizeUtils.WIDTH4,
                                            ),
                                            Expanded(
                                              flex: 1,
                                              child: RoundedButtonBlue(
                                                text: "${lableModel.save}",
                                                press: () async {

                                                  if(widget.flightDetailSummary.flightStatus == "A"){
                                                    if(isButtonEnabled("awbsave", widget.buttonRightsList)){


                                                      print("widget.aWBItem.iMPAWBRowId ========= ${widget.aWBItem.iMPAWBRowId}");
                                                      print("widget.aWBItem.iMPShipRowId ========= ${widget.aWBItem.iMPShipRowId}");
                                                      print("widget.aWBItem.uSeqNo ========= ${widget.aWBItem.uSeqNo}");
                                                      print("widget.haWBItem.iMPAWBRowId ========= ${widget.haWBItem.iMPAWBRowId}");
                                                      print("widget.haWBItem.iMPSHIPRowId ========= ${widget.haWBItem.iMPSHIPRowId}");



                                                      String awbId = "${widget.aWBItem.iMPAWBRowId}~${widget.aWBItem.iMPShipRowId}~${widget.aWBItem.uSeqNo}";

                                                      String hawbId = "${widget.haWBItem.iMPAWBRowId}~${widget.haWBItem.iMPSHIPRowId}";


                                                      if (piecesController.text.isEmpty) {
                                                        openValidationDialog("${lableModel.piecesMsg}", piecesFocusNode);
                                                        return;
                                                      }

                                                      if(int.parse(piecesController.text) == 0){
                                                        openValidationDialog("${lableModel.enterPiecesGrtMsg}", piecesFocusNode);
                                                        return;
                                                      }

                                                      if(double.parse(weightController.text) == 0){
                                                        openValidationDialog("${lableModel.enterWeightGrtMsg}", weightFocusNode);
                                                        return;
                                                      }


                                                      if(widget.groupIDRequires == "Y"){
                                                        if (groupIdController.text.isEmpty) {
                                                          openValidationDialog("${lableModel.enterGropIdMsg}", groupIdFocusNode);
                                                          return;
                                                        }

                                                        // Check if the groupId length is between 14 (min and max 14 characters)
                                                        if (groupIdController.text.length != widget.groupIDCharSize) {
                                                          openValidationDialog(formatMessage("${lableModel.groupIdCharSizeMsg}", ["${widget.groupIDCharSize}"]), groupIdFocusNode);
                                                          return;
                                                        }

                                                      }

                                                      Clicks = "S";

                                                      context.read<FlightCheckCubit>().importShipmentSave(widget.location, widget.flightDetailSummary.flightSeqNo!, widget.uldSeqNo, groupIdController.text, awbId, hawbId, int.parse(piecesController.text), weightController.text, _user!.userProfile!.userIdentity!, _splashDefaultData!.companyCode!, widget.menuId);

                                                    }
                                                    else{
                                                      SnackbarUtil.showSnackbar(context, ValidationMessageCodeUtils.AuthorisedRolesAndRightsMsg, MyColor.colorRed, icon: FontAwesomeIcons.times);
                                                      Vibration.vibrate(duration: 500);
                                                    }

                                                  }else if(widget.flightDetailSummary.flightStatus == "F"){
                                                    SnackbarUtil.showSnackbar(context, "${lableModel.flightisFinalizedMsg}", MyColor.colorRed, icon: FontAwesomeIcons.times);
                                                    Vibration.vibrate(duration: 500);
                                                  }else if(widget.flightDetailSummary.flightStatus == "N"){
                                                    SnackbarUtil.showSnackbar(context, "${lableModel.flightisNotArrivedMsg}", MyColor.colorRed, icon: FontAwesomeIcons.times);
                                                    Vibration.vibrate(duration: 500);
                                                  }








                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                      )


                                    ],
                                  ),
                                ),
                              )),
                          )


                        ],
                      ),),),
                    )),

              ],
                        ),
                      ),
            )),
      ),
    );
  }

  String formatMessage(String template, List<String> values) {
    String formattedMessage = template;
    for (int i = 0; i < values.length; i++) {
      formattedMessage = formattedMessage.replaceAll('{$i}', values[i]);
    }
    return formattedMessage;
  }

  // validation dialog
  Future<void> openValidationDialog(String message, FocusNode focuseNode) async {
    bool? empty = await DialogUtils.showDataNotFoundDialogbot(
        context, "${message}", widget.lableModel!);

    if (empty == true) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        FocusScope.of(context).requestFocus(focuseNode);
      });
    }
  }

  bool isButtonEnabled(String buttonId, List<ButtonRight> buttonList) {
    ButtonRight? button = buttonList.firstWhere(
          (button) => button.buttonId == buttonId,
    );
    return button.isEnable == 'Y';
  }

}

// ticker animation for DGR code blink animation
class TickerProviders extends TickerProvider {
  @override
  Ticker createTicker(onTick) => Ticker(onTick);
}

