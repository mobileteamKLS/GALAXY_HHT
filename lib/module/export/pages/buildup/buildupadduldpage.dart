import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animation_progress_bar/flutter_animation_progress_bar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:galaxy/core/mycolor.dart';
import 'package:galaxy/module/export/pages/buildup/buildupuldpage.dart';
import 'package:galaxy/module/export/services/buildup/builduplogic/buildupcubit.dart';
import 'package:galaxy/utils/sizeutils.dart';
import 'package:galaxy/widget/customebuttons/roundbuttonblue.dart';
import 'package:galaxy/widget/custometext.dart';
import 'package:galaxy/widget/groupidcustomtextfield.dart';
import 'package:galaxy/widget/uldnumberwidget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
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
import '../../../../utils/uldvalidationutil.dart';
import '../../../../widget/customdivider.dart';
import '../../../../widget/customedrawer/customedrawer.dart';
import '../../../../widget/customeedittext/customeedittextwithborder.dart';
import '../../../../widget/customtextfield.dart';
import '../../../../widget/header/mainheadingwidget.dart';
import '../../../login/pages/signinscreenmethods.dart';
import '../../../profile/page/profilepagescreen.dart';
import '../../../splash/model/splashdefaultmodel.dart';
import '../../../onboarding/sizeconfig.dart';
import 'dart:ui' as ui;

import '../../../login/model/userlogindatamodel.dart';
import '../../../submenu/model/submenumodel.dart';
import '../../model/buildup/flightsearchmodel.dart';
import '../../model/closeuld/getcontourlistmodel.dart';
import '../../services/buildup/builduplogic/buildupstate.dart';


class BuildUpAddULDPage extends StatefulWidget {
  String mainMenuName;
  String title;
  String refrelCode;
  LableModel? lableModel;
  int menuId;
  List<SubMenuName> importSubMenuList = [];
  List<SubMenuName> exportSubMenuList = [];
  int flightSeqNo;
  String offPoint;

  BuildUpAddULDPage(
      {super.key,
      required this.importSubMenuList,
      required this.exportSubMenuList,
      required this.title,
      required this.refrelCode,
      this.lableModel,
      required this.menuId,
      required this.mainMenuName,
      required this.flightSeqNo,
      required this.offPoint});

  @override
  State<BuildUpAddULDPage> createState() => _BuildUpAddULDPageState();
}

class _BuildUpAddULDPageState extends State<BuildUpAddULDPage> {


  InactivityTimerManager? inactivityTimerManager;
  final SavedPrefrence savedPrefrence = SavedPrefrence();
  UserDataModel? _user;
  SplashDefaultModel? _splashDefaultData;
  final ScrollController scrollController = ScrollController();

  TextEditingController tareWeightController = TextEditingController();
  FocusNode tareWeightFocusNode = FocusNode();
  TextEditingController heightController = TextEditingController();
  FocusNode heightFocusNode = FocusNode();
  TextEditingController scanULDController = TextEditingController();
  FocusNode scanULDFocusNode = FocusNode();
  TextEditingController priorityController = TextEditingController();
  FocusNode priorityFocusNode = FocusNode();
  TextEditingController routeController = TextEditingController();
  FocusNode routeFocusNode = FocusNode();

  FocusNode saveBtnFocusNode = FocusNode();

  String tUnit = "C";
  String uldSpecification = "LD";
  String selectedSwitchIndex = "";

  GetContourListModel? getContourListModel;




  @override
  void initState() {
    super.initState();
    _loadUser(); //load user data

    routeController.text = widget.offPoint;

  }

  @override
  void dispose() {
    super.dispose();
    //all controller and focus node dispose
    inactivityTimerManager?.stopTimer(); // Stop the timer when the screen is disposed

    scrollController.dispose();


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

    getContourList();

    inactivityTimerManager = InactivityTimerManager(
      context: context,
      timeoutMinutes: _splashDefaultData!.activeLoginTime!,  // Set the desired inactivity time here
      onTimeout: _handleInactivityTimeout,  // Define what happens when timeout occurs
    );
    inactivityTimerManager?.startTimer();

  }

  Future<void> _handleInactivityTimeout() async {

    bool? activateORNot = await DialogUtils.showingActivateTimerDialog(context, _user!.userProfile!.userId!, _splashDefaultData!.companyCode!);

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
  }




  Future<bool> _onWillPop() async {
    FocusScope.of(context).unfocus();
    Navigator.pop(context, "Done");

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
                                title: widget.title,
                                onBack: () => _onWillPop(),
                                clearText: lableModel!.clear,
                                //add clear text to clear all feild
                                onClear: () {
                                  WidgetsBinding.instance.addPostFrameCallback((_) {
                                    FocusScope.of(context).requestFocus(scanULDFocusNode);
                                  });
                                  scanULDController.clear();
                                  tareWeightController.clear();
                                  priorityController.clear();
                                  heightController.clear();
                                  selectedSwitchIndex = "";
                                  uldSpecification = "LD";
                                  setState(() {});
                                },
                              ),
                            ),

                            // start api responc

                            BlocListener<BuildUpCubit, BuildUpState>(
                              listener: (context, state) {
                                if (state is BuildUpInitialState) {
                                }
                                else if (state is BuildUpLoadingState) {
                                  // showing loading dialog in this state
                                  DialogUtils.showLoadingDialog(context, message: lableModel.loading);
                                }
                                else if (state is BuildUpGetContourListSuccessState){
                                  DialogUtils.hideLoadingDialog(context);
                                  if(state.getContourListModel.status == "E"){
                                    Vibration.vibrate(duration: 500);
                                    SnackbarUtil.showSnackbar(context, state.getContourListModel.statusMessage!, MyColor.colorRed, icon: FontAwesomeIcons.times);
                                  }else{

                                    getContourListModel =  state.getContourListModel;
                                    WidgetsBinding.instance.addPostFrameCallback((_) {
                                      FocusScope.of(context).requestFocus(scanULDFocusNode);
                                    });
                                    setState(() {

                                    });

                                  }
                                }
                                else if (state is BuildUpGetContourListFailureState){
                                  DialogUtils.hideLoadingDialog(context);
                                  Vibration.vibrate(duration: 500);
                                  SnackbarUtil.showSnackbar(context, state.error, MyColor.colorRed, icon: FontAwesomeIcons.times);
                                }
                                else if (state is GetULDTrolleySaveSuccessState){
                                  DialogUtils.hideLoadingDialog(context);
                                  if(state.getULDTrolleySaveModel.status == "E"){
                                    Vibration.vibrate(duration: 500);
                                    SnackbarUtil.showSnackbar(context, state.getULDTrolleySaveModel.statusMessage!, MyColor.colorRed, icon: FontAwesomeIcons.times);
                                  }else{
                                    WidgetsBinding.instance.addPostFrameCallback((_) {
                                      FocusScope.of(context).requestFocus(scanULDFocusNode);
                                    });
                                    scanULDController.clear();
                                    tareWeightController.clear();
                                    priorityController.clear();
                                    heightController.clear();
                                    selectedSwitchIndex = "";
                                    uldSpecification = "LD";
                                    setState(() {

                                    });

                                    SnackbarUtil.showSnackbar(context, state.getULDTrolleySaveModel.statusMessage!, MyColor.colorGreen, icon: Icons.done);
                                  }
                                }
                                else if (state is GetULDTrolleySaveFailureState){
                                  DialogUtils.hideLoadingDialog(context);
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
                                          // location textfield
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 10,
                                                right: 10,
                                                top: 0,
                                                bottom: 0),
                                            child: Directionality(
                                              textDirection: textDirection,
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: MyColor.colorWhite,
                                                  borderRadius:BorderRadius.circular(8),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: MyColor.colorBlack.withOpacity(0.09),
                                                      spreadRadius: 2,
                                                      blurRadius: 15,
                                                      offset: const Offset(0, 3), // changes position of shadow
                                                    ),
                                                  ],
                                                ),
                                                child: Padding(
                                                  padding: const EdgeInsets.only(
                                                      left: 12,
                                                      right: 12,
                                                      top: 12,
                                                      bottom: 12),
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      SizedBox(
                                                        height: SizeConfig.blockSizeVertical,
                                                      ),
                                                      Row(
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
                                                              labelText: "ULD No. *",
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
                                                          const SizedBox(width: 10),
                                                          IntrinsicHeight(
                                                            child: Row(
                                                              children: [
                                                                // Yes Option
                                                                InkWell(
                                                                  onTap: () {

                                                                    setState(() {
                                                                      uldSpecification = "LD";
                                                                    });

                                                                  },
                                                                  child: Container(
                                                                    decoration: BoxDecoration(
                                                                      color:  uldSpecification == "LD" ? MyColor.primaryColorblue : MyColor.colorWhite, // Selected blue, unselected white
                                                                      borderRadius: BorderRadius.only(
                                                                        topLeft: Radius.circular(10),
                                                                        bottomLeft: Radius.circular(10),
                                                                      ),
                                                                      border: Border.symmetric(horizontal: BorderSide(color: MyColor.primaryColorblue), vertical: BorderSide(color: MyColor.primaryColorblue)), // Border color
                                                                    ),
                                                                    padding: EdgeInsets.symmetric(vertical:10, horizontal: 20),
                                                                    child: Center(
                                                                        child: CustomeText(text: "LD", fontColor:  uldSpecification == "LD" ? MyColor.colorWhite : MyColor.textColorGrey3, fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5_5, fontWeight: FontWeight.w600, textAlign: TextAlign.center)
                                                                    ),
                                                                  ),
                                                                ),

                                                                // No Option
                                                                InkWell(
                                                                  onTap: () {

                                                                    setState(() {
                                                                      uldSpecification = "MD";
                                                                    });

                                                                  },
                                                                  child: Container(
                                                                    decoration: BoxDecoration(
                                                                      color: uldSpecification == "MD" ? MyColor.primaryColorblue : MyColor.colorWhite, // Selected blue, unselected white
                                                                      borderRadius: BorderRadius.only(
                                                                        topRight: Radius.circular(10),
                                                                        bottomRight: Radius.circular(10),
                                                                      ),
                                                                      border: Border.symmetric(horizontal: BorderSide(color: MyColor.primaryColorblue), vertical: BorderSide(color: MyColor.primaryColorblue)), // Border color
                                                                    ),
                                                                    padding: EdgeInsets.symmetric(vertical:10, horizontal: 20),
                                                                    child: Center(
                                                                        child: CustomeText(text: "MD", fontColor: uldSpecification == "MD" ? MyColor.colorWhite : MyColor.textColorGrey3, fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5_5, fontWeight: FontWeight.w600, textAlign: TextAlign.center)
                                                                    ),
                                                                  ),
                                                                )

                                                              ],
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                      SizedBox(height: SizeConfig.blockSizeVertical * SizeUtils.HEIGHT2,),
                                                      CustomTextField(
                                                        focusNode: tareWeightFocusNode,
                                                        textDirection: textDirection,
                                                        hasIcon: false,
                                                        hastextcolor: true,
                                                        animatedLabel: true,
                                                        needOutlineBorder: true,
                                                        labelText: "Tare Weight",
                                                        controller: tareWeightController,
                                                        readOnly: false,
                                                        maxLength: 10,
                                                        digitsOnly: false,
                                                        doubleDigitOnly: true,
                                                        onChanged: (value, validate) {


                                                        },
                                                        fillColor: Colors.grey.shade100,
                                                        textInputType: TextInputType.number,
                                                        inputAction: TextInputAction.next,
                                                        hintTextcolor: Colors.black,
                                                        verticalPadding: 0,
                                                        fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_7,
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
                                                      SizedBox(height: SizeConfig.blockSizeVertical * SizeUtils.HEIGHT2,),
                                                      Row(
                                                        children: [
                                                          Expanded(
                                                            flex:1,
                                                            child: CustomTextField(
                                                              focusNode: priorityFocusNode,
                                                              textDirection: textDirection,
                                                              hasIcon: false,
                                                              hastextcolor: true,
                                                              animatedLabel: true,
                                                              needOutlineBorder: true,
                                                              labelText: "Priority",
                                                              readOnly: false,
                                                              controller: priorityController,
                                                              maxLength: 2,
                                                              onChanged: (value, validate) {},
                                                              fillColor: Colors.grey.shade100,
                                                              textInputType: TextInputType.number,
                                                              inputAction: TextInputAction.next,
                                                              hintTextcolor: Colors.black,
                                                              verticalPadding: 0,
                                                              fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_7,
                                                              circularCorner: SizeConfig.blockSizeHorizontal * SizeUtils.CIRCULARCORNER,
                                                              boxHeight: SizeConfig.blockSizeVertical * SizeUtils.BOXHEIGHT,
                                                              digitsOnly: true,
                                                              validator: (value) {
                                                                if (value!.isEmpty) {
                                                                  return "Please fill out this field";
                                                                } else {
                                                                  return null;
                                                                }
                                                              },
                                                            ),
                                                          ),
                                                          SizedBox(width: SizeConfig.blockSizeHorizontal * SizeUtils.WIDTH4,),
                                                          Expanded(
                                                            flex: 1,
                                                            child: CustomTextField(
                                                              focusNode: routeFocusNode,
                                                              textDirection: textDirection,
                                                              hasIcon: false,
                                                              hastextcolor: true,
                                                              animatedLabel: true,
                                                              needOutlineBorder: true,
                                                              labelText: "OffPoint *",
                                                              readOnly: false,
                                                              controller: routeController,
                                                              maxLength: 3,
                                                              onChanged: (value, validate) {},
                                                              fillColor: Colors.grey.shade100,
                                                              textInputType: TextInputType.text,
                                                              inputAction: TextInputAction.next,
                                                              hintTextcolor: Colors.black,
                                                              verticalPadding: 0,
                                                              fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_7,
                                                              circularCorner: SizeConfig.blockSizeHorizontal * SizeUtils.CIRCULARCORNER,
                                                              boxHeight: SizeConfig.blockSizeVertical * SizeUtils.BOXHEIGHT,
                                                              digitsOnly: false,
                                                              textOnly: true,
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
                                                      SizedBox(height: SizeConfig.blockSizeVertical),

                                                      Container(
                                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                                                        decoration: BoxDecoration(
                                                          color: MyColor.cardBgColor,
                                                          borderRadius: BorderRadius.circular(8),
                                                        ),
                                                        child: Column(
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            CustomeText(
                                                              text: "Contour",
                                                              fontColor: MyColor.colorBlack,
                                                              fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_6,
                                                              fontWeight: FontWeight.w600,
                                                              textAlign: TextAlign.start,
                                                            ),
                                                            SizedBox(height: SizeConfig.blockSizeVertical * SizeUtils.HEIGHT2,),
                                                            Row(
                                                              children: [
                                                                Expanded(
                                                                  flex:1,
                                                                  child: CustomTextField(
                                                                    textDirection: textDirection,
                                                                    controller: heightController,
                                                                    focusNode: heightFocusNode,
                                                                    onPress: () {},
                                                                    hasIcon: false,
                                                                    hastextcolor: true,
                                                                    animatedLabel: true,
                                                                    needOutlineBorder: true,
                                                                    labelText: "Height",
                                                                    readOnly: false,
                                                                    maxLength: 10,
                                                                    digitsOnly: true,
                                                                    doubleDigitOnly: false,
                                                                    onChanged: (value) {

                                                                    },
                                                                    fillColor: Colors.grey.shade100,
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
                                                                              topRight: Radius.circular(10),
                                                                              bottomRight: Radius.circular(10),
                                                                            ),
                                                                            border: Border.symmetric(horizontal: BorderSide(color: MyColor.primaryColorblue), vertical: BorderSide(color: MyColor.primaryColorblue)), // Border color
                                                                          ),
                                                                          padding: EdgeInsets.symmetric(vertical:10, horizontal: 10),
                                                                          child: Center(
                                                                              child: CustomeText(text: "inch", fontColor:  tUnit == "C" ? MyColor.colorWhite : MyColor.textColorGrey3, fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5, fontWeight: FontWeight.w600, textAlign: TextAlign.center)
                                                                          ),
                                                                        ),
                                                                      ),


                                                                    ],
                                                                  ),
                                                                )
                                                              ],
                                                            ),
                                                            SizedBox(height: SizeConfig.blockSizeVertical),
                                                            (getContourListModel != null) ? ListView.builder(
                                                              itemCount: getContourListModel!.uLDContourList!.length,
                                                              shrinkWrap: true,
                                                              physics: const NeverScrollableScrollPhysics(),
                                                              itemBuilder: (context, index) {
                                                                Color backgroundColor = MyColor.colorList[index % MyColor.colorList.length];

                                                                ULDContourList content = getContourListModel!.uLDContourList![index];
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
                                                                          SizedBox(
                                                                            width:
                                                                            2,
                                                                          ),
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
                                                            ) : SizedBox(),
                                                          ],
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),




                                        ],
                                      ),
                                    ],
                                  ),
                                ),
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

                                        if(scanULDController.text.isNotEmpty){
                                          if(routeController.text.isNotEmpty){
                                            String uldNumber = UldValidationUtil.validateUldNumberwithSpace1(scanULDController.text.toUpperCase());
                                            if(uldNumber == "Valid"){
                                              saveULD();
                                            }else{
                                              openValidationDialog("Please enter valid ULD No.", scanULDFocusNode);
                                            }
                                          }else{
                                            openValidationDialog("Please enter offpoint.", routeFocusNode);
                                          }
                                        }else{
                                          openValidationDialog("Please enter ULD No.", scanULDFocusNode);
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




  Future<void> getContourList() async {
    await context.read<BuildUpCubit>().getContourList(
        -1,
        _user!.userProfile!.userIdentity!,
        _splashDefaultData!.companyCode!,
        widget.menuId);
  }

  Future<void> saveULD() async {

    String uldNumbes = CommonUtils.ULDNUMBERCEHCK;
    List<String> parts = uldNumbes.split(' ');
    String uldType = parts[0];
    String uldNumber = parts[1];
    String uldOwner = parts[2];

    await context.read<BuildUpCubit>().getULDTrolleySave(
        widget.flightSeqNo,
        uldType,
        uldNumber,
        uldOwner,
        uldSpecification,
        "",
        "",
        (tareWeightController.text.isNotEmpty) ? double.parse(tareWeightController.text) : 0.00,
        selectedSwitchIndex,
        (heightController.text.isNotEmpty) ? int.parse(heightController.text) : 0,
        (priorityController.text.isNotEmpty) ? int.parse(priorityController.text) : 1,
        routeController.text,
        "U",
        _user!.userProfile!.userIdentity!,
        _splashDefaultData!.companyCode!,
        widget.menuId);
  }





  // validation dialog
  Future<void> openValidationDialog(String message, FocusNode focuseNode) async {
    Vibration.vibrate(duration: 500);

    bool? empty = await DialogUtils.showDataNotFoundDialogbot(
        context, message, widget.lableModel!);

    if (empty == true) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        FocusScope.of(context).requestFocus(focuseNode);
      });
    }
  }


}