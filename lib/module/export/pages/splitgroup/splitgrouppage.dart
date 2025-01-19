import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:galaxy/core/mycolor.dart';
import 'package:galaxy/module/export/pages/splitgroup/splitgroupsavepage.dart';
import 'package:galaxy/module/export/services/splitgroup/splitgrouplogic/splitgroupcubit.dart';
import 'package:galaxy/module/export/services/splitgroup/splitgrouplogic/splitgroupstate.dart';
import 'package:galaxy/utils/awbformatenumberutils.dart';
import 'package:galaxy/utils/sizeutils.dart';
import 'package:galaxy/widget/custometext.dart';
import 'package:galaxy/widget/roundbutton.dart';
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
import '../../model/splitgroup/splitgroupdetailsearchmodel.dart';


class SplitGroupPage extends StatefulWidget {
  String mainMenuName;
  String title;
  String refrelCode;
  LableModel? lableModel;
  int menuId;
  List<SubMenuName> importSubMenuList = [];
  List<SubMenuName> exportSubMenuList = [];


  SplitGroupPage(
      {super.key,
      required this.importSubMenuList,
      required this.exportSubMenuList,
      required this.title,
      required this.refrelCode,
      this.lableModel,
      required this.menuId,
      required this.mainMenuName});

  @override
  State<SplitGroupPage> createState() => _SplitGroupPageState();
}

class _SplitGroupPageState extends State<SplitGroupPage> {


  InactivityTimerManager? inactivityTimerManager;
  final SavedPrefrence savedPrefrence = SavedPrefrence();
  UserDataModel? _user;
  SplashDefaultModel? _splashDefaultData;
  final ScrollController scrollController = ScrollController();


  String isGroupBasedAcceptChar = "N";
  int isGroupBasedAcceptNumber = 1;


  TextEditingController scanNoEditingController = TextEditingController();
  FocusNode scanNoFocusNode = FocusNode();
  FocusNode scanBtnFocusNode = FocusNode();





  FocusNode uldListFocusNode = FocusNode();




  bool isBackPressed = false;

  GetSplitGroupDetailSearchModel? getSplitGroupDetailSearchModel;

  List<SplitGroupDetailList> splitGroupDetailList = []; // Track if the back button was pressed



  @override
  void initState() {
    super.initState();
    _loadUser(); //load user data

    scanNoFocusNode.addListener(() {
      if(!scanNoFocusNode.hasFocus){
        if(scanNoEditingController.text.isNotEmpty){
          getULDTrolleySearchList();
        }
      }

    },);

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


      getPageLoad();


    }

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
    isBackPressed = true;
    scanNoEditingController.clear();
    Navigator.pop(context, "true");

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
                                onBack: () {
                                  FocusScope.of(context).unfocus();
                                  _onWillPop();

                                },
                                clearText: lableModel!.clear,
                                //add clear text to clear all feild
                                onClear: () {
                                  scanNoEditingController.clear();

                                  getSplitGroupDetailSearchModel = null;
                                  setState(() {

                                  });
                                  WidgetsBinding.instance.addPostFrameCallback((_) {
                                    FocusScope.of(context).requestFocus(scanNoFocusNode);
                                  },
                                  );


                                  setState(() {});
                                },
                              ),
                            ),

                            // start api responc

                            BlocListener<SplitGroupCubit, SplitGroupState>(
                              listener: (context, state) async {
                                if (state is SplitGroupInitialState) {
                                }
                                else if (state is SplitGroupLoadingState) {
                                  // showing loading dialog in this state
                                  DialogUtils.showLoadingDialog(context, message: lableModel.loading);
                                }
                                else if (state is SplitGroupDefaultPageLoadSuccessState){
                                  DialogUtils.hideLoadingDialog(context);

                                  if(state.splitGroupDefaultPageLoadModel.status == "E"){
                                    Vibration.vibrate(duration: 500);
                                    SnackbarUtil.showSnackbar(context, state.splitGroupDefaultPageLoadModel.statusMessage!, MyColor.colorRed, icon: FontAwesomeIcons.times);
                                  }else{
                                    isGroupBasedAcceptChar = state.splitGroupDefaultPageLoadModel.IsGroupBasedAcceptChar!;
                                    isGroupBasedAcceptNumber = state.splitGroupDefaultPageLoadModel.IsGroupBasedAcceptNumber!;


                                    WidgetsBinding.instance.addPostFrameCallback((_) {
                                      FocusScope.of(context).requestFocus(scanNoFocusNode);
                                    },
                                    );
                                    setState(() {

                                    });
                                  }


                                }
                                else if (state is SplitGroupDefaultPageLoadFailureState){
                                  DialogUtils.hideLoadingDialog(context);
                                  Vibration.vibrate(duration: 500);
                                  SnackbarUtil.showSnackbar(context, state.error, MyColor.colorRed, icon: FontAwesomeIcons.times);
                                }
                                else if (state is SplitGroupDetailSearchSuccessState){
                                  DialogUtils.hideLoadingDialog(context);
                                  if(state.getSplitGroupDetailSearchModel.status == "E"){
                                    Vibration.vibrate(duration: 500);
                                    SnackbarUtil.showSnackbar(
                                        context,
                                        state.getSplitGroupDetailSearchModel.statusMessage!,
                                        MyColor.colorRed,
                                        icon: FontAwesomeIcons.times);
                                  }else{

                                    getSplitGroupDetailSearchModel = state.getSplitGroupDetailSearchModel;
                                    splitGroupDetailList = List.from(getSplitGroupDetailSearchModel!.splitGroupDetailList != null ? getSplitGroupDetailSearchModel!.splitGroupDetailList! : []);

                                    setState(() {

                                    });
                                  }
                                }
                                else if (state is SplitGroupDetailSearchFailureState){
                                  DialogUtils.hideLoadingDialog(context);
                                  Vibration.vibrate(duration: 500);
                                  SnackbarUtil.showSnackbar(context, state.error, MyColor.colorRed, icon: FontAwesomeIcons.times);
                                }



                              },
                              child:  Expanded(
                                child: SingleChildScrollView(
                                  child: Column(
                                    children: [
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
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
                                                      SizedBox( height: SizeConfig.blockSizeVertical ),
                                                      Directionality(
                                                        textDirection: textDirection,
                                                        child: Row(
                                                          children: [
                                                            // add location in text
                                                            Expanded(
                                                              flex: 1,
                                                              child: CustomTextField(
                                                                textDirection: textDirection,
                                                                hasIcon: false,
                                                                hastextcolor: true,
                                                                animatedLabel: true,
                                                                needOutlineBorder: true,
                                                                labelText: "${lableModel.scan}",
                                                                readOnly: false,
                                                                controller: scanNoEditingController,
                                                                focusNode: scanNoFocusNode,
                                                                maxLength: 14,
                                                                onChanged: (value) {
                                                                  getSplitGroupDetailSearchModel = null;
                                                                  setState(() {

                                                                  });
                                                                },
                                                                fillColor: Colors.grey.shade100,
                                                                textInputType: TextInputType.text,
                                                                inputAction: TextInputAction.next,
                                                                hintTextcolor: Colors.black,
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
                                                                scanQR();
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
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: SizeConfig.blockSizeVertical,),
                                          Padding(
                                            padding: const EdgeInsets.only(left: 10, right: 10, top: 0, bottom: 10),
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
                                                        offset: const Offset(0, 3), // changes position of shadow
                                                      ),
                                                    ],
                                                  ),
                                                  child: Column(
                                                    children: [

                                                      (getSplitGroupDetailSearchModel != null)
                                                          ? (splitGroupDetailList.isNotEmpty)
                                                          ? Column(
                                                        children: [
                                                          ListView.builder(
                                                            itemCount: (getSplitGroupDetailSearchModel != null)
                                                                ? splitGroupDetailList.length
                                                                : 0,
                                                            physics: NeverScrollableScrollPhysics(),
                                                            shrinkWrap: true,
                                                            controller: scrollController,
                                                            itemBuilder: (context, index) {

                                                              SplitGroupDetailList splitGroup = splitGroupDetailList[index];


                                                              return InkWell(
                                                                focusNode: uldListFocusNode,
                                                                onTap: () {
                                                                  FocusScope.of(context).unfocus();
                                                                  setState(() {

                                                                  });
                                                                },
                                                                onDoubleTap: () async {
                                                                  inactivityTimerManager?.stopTimer();
                                                                  String value = await Navigator.push(context, CupertinoPageRoute(builder: (context) => SplitGroupSavePage(importSubMenuList: widget.importSubMenuList, exportSubMenuList: widget.exportSubMenuList, mainMenuName: widget.mainMenuName, menuId: widget.menuId, lableModel: lableModel, title: widget.title, refrelCode: widget.refrelCode, isGroupBasedAcceptChar: isGroupBasedAcceptChar, isGroupBasedAcceptNumber: isGroupBasedAcceptNumber, splitGroup: splitGroup)));
                                                                  if(value == "true"){
                                                                    getULDTrolleySearchList();
                                                                  }else{
                                                                    _resumeTimerOnInteraction();
                                                                  }

                                                                },
                                                                child: Container(
                                                                  margin: const EdgeInsets.symmetric(vertical: 4),
                                                                  decoration: BoxDecoration(
                                                                    color: MyColor.colorWhite,
                                                                    borderRadius: BorderRadius.circular(8),

                                                                    boxShadow: [
                                                                      BoxShadow(
                                                                        color: MyColor.colorBlack.withOpacity(0.09),
                                                                        spreadRadius: 2,
                                                                        blurRadius: 15,
                                                                        offset: const Offset(0, 3), // changes position of shadow
                                                                      ),
                                                                    ],

                                                                  ),
                                                                  child: Container(
                                                                    margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                                                                    decoration: BoxDecoration(
                                                                      color: MyColor.colorWhite,
                                                                      borderRadius: BorderRadius.circular(8),

                                                                    ),
                                                                    child: Container(
                                                                      padding: const EdgeInsets.all(8),
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
                                                                                      CustomeText(
                                                                                        text: AwbFormateNumberUtils.formatAWBNumber(splitGroup.aWBNo!),
                                                                                        fontColor: MyColor.textColorGrey3,
                                                                                        fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_7,
                                                                                        fontWeight: FontWeight.w600,
                                                                                        textAlign: TextAlign.start,
                                                                                      ),
                                                                                      SizedBox(width: SizeConfig.blockSizeHorizontal * SizeUtils.WIDTH3),
                                                                                      CustomeText(
                                                                                        text: "#${splitGroup.shipmentNo}",
                                                                                        fontColor: MyColor.textColorGrey3,
                                                                                        fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_7,
                                                                                        fontWeight: FontWeight.w600,
                                                                                        textAlign: TextAlign.start,
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                  SizedBox(width: SizeConfig.blockSizeHorizontal),

                                                                                  Row(
                                                                                    children: [
                                                                                      CustomeText(
                                                                                        text: "House :",
                                                                                        fontColor: MyColor.textColorGrey2,
                                                                                        fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                                                                        fontWeight: FontWeight.w400,
                                                                                        textAlign: TextAlign.start,
                                                                                      ),
                                                                                      CustomeText(
                                                                                        text: (splitGroup.houseNo!.isNotEmpty) ? splitGroup.houseNo! : "-",
                                                                                        fontColor: MyColor.textColorGrey3,
                                                                                        fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_7,
                                                                                        fontWeight: FontWeight.w600,
                                                                                        textAlign: TextAlign.start,
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                ],
                                                                              ),

                                                                              SizedBox(height: SizeConfig.blockSizeVertical),
                                                                              IntrinsicHeight(
                                                                                child: Row(
                                                                                  children: [
                                                                                    Expanded(
                                                                                      flex: 5,
                                                                                      child: Column(
                                                                                        children: [
                                                                                          Row(
                                                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                            children: [
                                                                                              Row(
                                                                                                children: [
                                                                                                  CustomeText(
                                                                                                    text: "Pcs :",
                                                                                                    fontColor: MyColor.textColorGrey2,
                                                                                                    fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                                                                                    fontWeight: FontWeight.w500,
                                                                                                    textAlign: TextAlign.start,
                                                                                                  ),
                                                                                                  const SizedBox(width: 5),
                                                                                                  CustomeText(
                                                                                                    text: "${splitGroup.nOP}",
                                                                                                    fontColor: MyColor.colorBlack,
                                                                                                    fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_6,
                                                                                                    fontWeight: FontWeight.w600,
                                                                                                    textAlign: TextAlign.start,
                                                                                                  ),
                                                                                                ],
                                                                                              ),
                                                                                              Row(
                                                                                                children: [
                                                                                                  CustomeText(
                                                                                                    text: "Wt :",
                                                                                                    fontColor: MyColor.textColorGrey2,
                                                                                                    fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                                                                                    fontWeight: FontWeight.w500,
                                                                                                    textAlign: TextAlign.start,
                                                                                                  ),
                                                                                                  const SizedBox(width: 5),
                                                                                                  CustomeText(
                                                                                                    text: "${CommonUtils.formateToTwoDecimalPlacesValue(splitGroup.weight!)} Kg",
                                                                                                    fontColor: MyColor.colorBlack,
                                                                                                    fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_6,
                                                                                                    fontWeight: FontWeight.w600,
                                                                                                    textAlign: TextAlign.start,
                                                                                                  ),
                                                                                                ],
                                                                                              ),
                                                                                            ],
                                                                                          ),
                                                                                          SizedBox(height: SizeConfig.blockSizeVertical),
                                                                                          Row(
                                                                                            children: [
                                                                                              CustomeText(
                                                                                                text: "Location :",
                                                                                                fontColor: MyColor.textColorGrey2,
                                                                                                fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                                                                                fontWeight: FontWeight.w500,
                                                                                                textAlign: TextAlign.start,
                                                                                              ),
                                                                                              const SizedBox(width: 5),
                                                                                              CustomeText(
                                                                                                text: "${splitGroup.locationCode}",
                                                                                                fontColor: MyColor.colorBlack,
                                                                                                fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_6,
                                                                                                fontWeight: FontWeight.w600,
                                                                                                textAlign: TextAlign.start,
                                                                                              ),
                                                                                            ],
                                                                                          ),
                                                                                          SizedBox(height: SizeConfig.blockSizeVertical),
                                                                                          Row(
                                                                                            children: [
                                                                                              CustomeText(
                                                                                                text: "Group :",
                                                                                                fontColor: Colors.pink.shade500,
                                                                                                fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_7,
                                                                                                fontWeight: FontWeight.bold,
                                                                                                textAlign: TextAlign.start,
                                                                                              ),
                                                                                              const SizedBox(width: 5),
                                                                                              CustomeText(
                                                                                                text: "${splitGroup.groupId}",
                                                                                                fontColor: Colors.pink.shade500,
                                                                                                fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_7,
                                                                                                fontWeight: FontWeight.bold,
                                                                                                textAlign: TextAlign.start,
                                                                                              ),
                                                                                            ],
                                                                                          ),
                                                                                        ],
                                                                                      ),
                                                                                    ),
                                                                                    SizedBox(width: SizeConfig.blockSizeHorizontal * SizeUtils.WIDTH3,),
                                                                                    Expanded(
                                                                                      flex: 2,
                                                                                      child: RoundedButton(text: "Split",
                                                                                        color: MyColor.primaryColorblue,
                                                                                        press: () async {
                                                                                          inactivityTimerManager?.stopTimer();
                                                                                          var value = await Navigator.push(context, CupertinoPageRoute(builder: (context) => SplitGroupSavePage(importSubMenuList: widget.importSubMenuList, exportSubMenuList: widget.exportSubMenuList, mainMenuName: widget.mainMenuName, menuId: widget.menuId, lableModel: lableModel, title: widget.title, refrelCode: widget.refrelCode, isGroupBasedAcceptChar: isGroupBasedAcceptChar, isGroupBasedAcceptNumber: isGroupBasedAcceptNumber, splitGroup: splitGroup)));
                                                                                          if(value == "true"){
                                                                                            getULDTrolleySearchList();
                                                                                          }else{
                                                                                            _resumeTimerOnInteraction();
                                                                                          }
                                                                                        },),
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                              ),
                                                                              SizedBox(height: SizeConfig.blockSizeVertical),






                                                                            ],
                                                                          ),

                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
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
                                                )),

                                          ),


                                        ],
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }





  Future<void> scanQR() async {
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
        SnackbarUtil.showSnackbar(context, "Please enter valid no.", MyColor.colorRed, icon: FontAwesomeIcons.times);
        Vibration.vibrate(duration: 500);
        splitGroupDetailList.clear();
        getSplitGroupDetailSearchModel = null;
        scanNoEditingController.clear();
        WidgetsBinding.instance.addPostFrameCallback((_) {
          FocusScope.of(context).requestFocus(scanNoFocusNode);
        });
      }else{


        String result = barcodeScanResult.replaceAll(" ", "");



        WidgetsBinding.instance.addPostFrameCallback((_) {
          FocusScope.of(context).requestFocus(scanBtnFocusNode);
        },
        );

        scanNoEditingController.text = result;

        getULDTrolleySearchList();
      }
    }
  }




  // validation dialog
  Future<void> openValidationDialog(String message, FocusNode focuseNode) async {
    bool? empty = await DialogUtils.showDataNotFoundDialogbot(
        context, message, widget.lableModel!);

    if (empty == true) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        FocusScope.of(context).requestFocus(focuseNode);
      });
    }
  }





  Future<void> getPageLoad() async {
    context.read<SplitGroupCubit>().getDefaultPageLoad(_user!.userProfile!.userIdentity!, _splashDefaultData!.companyCode!, widget.menuId,);
  }



  Future<void> getULDTrolleySearchList() async {
    await context.read<SplitGroupCubit>().getSplitGroupSearchList(
        scanNoEditingController.text,
        _user!.userProfile!.userIdentity!,
        _splashDefaultData!.companyCode!,
        widget.menuId);
  }



}

