import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:galaxy/module/export/services/offload/offloadlogic/offloadcubit.dart';
import 'package:galaxy/module/export/services/offload/offloadlogic/offloadstate.dart';
import 'package:galaxy/utils/snackbarutil.dart';
import 'package:galaxy/widget/customebuttons/roundbuttonblue.dart';
import 'package:galaxy/widget/customedrawer/customedrawer.dart';
import 'package:vibration/vibration.dart';
import '../../../../core/mycolor.dart';
import '../../../../language/appLocalizations.dart';
import '../../../../language/model/lableModel.dart';
import '../../../../manager/timermanager.dart';
import '../../../../prefrence/savedprefrence.dart';
import '../../../../utils/awbformatenumberutils.dart';
import '../../../../utils/commonutils.dart';
import '../../../../utils/dialogutils.dart';
import '../../../../utils/sizeutils.dart';
import '../../../../widget/customdivider.dart';
import '../../../../widget/customeedittext/remarkedittextfeild.dart';
import '../../../../widget/custometext.dart';
import '../../../../widget/customeuiwidgets/header.dart';
import '../../../../widget/customtextfield.dart';
import '../../../../widget/header/mainheadingwidget.dart';
import '../../../../widget/roundbutton.dart';
import '../../../../widget/uldnumberwidget.dart';
import '../../../import/pages/uldacceptance/ulddamagedpage.dart';
import '../../../login/model/userlogindatamodel.dart';
import '../../../login/pages/signinscreenmethods.dart';
import '../../../onboarding/sizeconfig.dart';
import 'dart:ui' as ui;
import '../../../profile/page/profilepagescreen.dart';
import '../../../splash/model/splashdefaultmodel.dart';
import '../../../submenu/model/submenumodel.dart';
import '../../model/offload/getoffloadsearchmodel.dart';
import '../../model/offload/offloadgetpageload.dart';

class OffloadULDPage extends StatefulWidget {


  String mainMenuName;
  int menuId;
  LableModel lableModel;
  List<SubMenuName> importSubMenuList = [];
  List<SubMenuName> exportSubMenuList = [];
  String title;
  String refrelCode;

  //SplitGroupDetailList splitGroup;
  String isGroupBasedAcceptChar;
  int isGroupBasedAcceptNumber;
  List<OffloadReasonList> offloadReasonList;
  OffloadULDDetailsList offloadULDDetail;
  String locationCode;


  OffloadULDPage({
    super.key,
    required this.importSubMenuList,
    required this.exportSubMenuList,
    required this.mainMenuName,
    required this.menuId,
    required this.lableModel,
    required this.title,
    required this.refrelCode,
    required this.isGroupBasedAcceptChar,
    required this.isGroupBasedAcceptNumber,
    required this.offloadReasonList,
    required this.offloadULDDetail,
    required this.locationCode
   });

  @override
  State<OffloadULDPage> createState() => _OffloadULDPageState();
}

class _OffloadULDPageState extends State<OffloadULDPage>{
  InactivityTimerManager? inactivityTimerManager;
  final SavedPrefrence savedPrefrence = SavedPrefrence();
  UserDataModel? _user;
  SplashDefaultModel? _splashDefaultData;

  String selectedSwitchIndex = "";


  final ScrollController scrollController = ScrollController();
  //FocusNode awbFocusNode = FocusNode();

  TextEditingController tempretureController = TextEditingController();
  FocusNode tempretureFocusNode = FocusNode();

  TextEditingController batteryController = TextEditingController();
  FocusNode batteryFocusNode = FocusNode();

  TextEditingController groupIdController = TextEditingController();
  FocusNode groupIdFocusNode = FocusNode();

  TextEditingController reasonController = TextEditingController();
  FocusNode reasonFocusNode = FocusNode();


  FocusNode splitBtnFocusNode = FocusNode();

  String tUnit = "C" ;

  String btnClick = "";

  bool isBackPressed = false;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();


    _loadUser(); //load user data

  }



  Future<void> _loadUser() async {
    final user = await savedPrefrence.getUserData();
    final splashDefaultData = await savedPrefrence.getSplashDefaultData();
    if (user != null && splashDefaultData != null) {
      setState(() {
        _user = user;
        _splashDefaultData = splashDefaultData;
      });
      WidgetsBinding.instance.addPostFrameCallback((_) {
        FocusScope.of(context).requestFocus(groupIdFocusNode);
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
                                title: widget.title,
                                onBack: () {
                                  _onWillPop();
                                },
                                clearText: "${lableModel!.clear}",
                                //add clear text to clear all feild
                                onClear: () {
                                  groupIdController.clear();
                                  tempretureController.clear();
                                  batteryController.clear();
                                  reasonController.clear();
                                  selectedSwitchIndex = "";
                                  tUnit = "C";
                                  setState(() {

                                  });
                                },
                              ),
                            ),

                            // start api responcer
                            BlocListener<OffloadCubit, OffloadState>(
                              listener: (context, state) async {

                                if (state is OffloadInitialState) {}
                                else if (state is OffloadLoadingState) {
                                  // showing loading dialog in this state
                                  DialogUtils.showLoadingDialog(context, message: lableModel.loading);
                                }
                                else if (state is OffloadULDSaveSuccessState){
                                  DialogUtils.hideLoadingDialog(context);
                                  if(state.offloadULDModel.status == "E"){
                                    Vibration.vibrate(duration: 500);
                                    SnackbarUtil.showSnackbar(context, state.offloadULDModel.statusMessage!, MyColor.colorRed, icon: FontAwesomeIcons.times);
                                  }
                                  else if(state.offloadULDModel.status == "V"){
                                    Vibration.vibrate(duration: 500);
                                    SnackbarUtil.showSnackbar(context, state.offloadULDModel.statusMessage!, MyColor.colorRed, icon: FontAwesomeIcons.times);
                                  }
                                  else{
                                    if(btnClick == "O"){
                                      SnackbarUtil.showSnackbar(context, state.offloadULDModel.statusMessage!, MyColor.colorGreen, icon: Icons.done);
                                      Navigator.pop(context, "true");
                                    }else{
                                      String damageOrNot = await Navigator.push(
                                          context,
                                          CupertinoPageRoute(
                                            builder: (context) => UldDamagedPage(
                                              importSubMenuList: widget.importSubMenuList,
                                              exportSubMenuList: widget.exportSubMenuList,
                                              locationCode: widget.locationCode,
                                              menuId: widget.menuId,
                                              ULDNo: widget.offloadULDDetail.uLDNo!,
                                              ULDSeqNo: widget.offloadULDDetail.uLDSeqNo!,
                                              flightSeqNo: widget.offloadULDDetail.flightSeqNo!,
                                              groupId: groupIdController.text,
                                              menuCode: widget.refrelCode,
                                              isRecordView: 2,
                                              mainMenuName: widget.mainMenuName,
                                              buttonRightsList: const [],
                                              flightType: "E",
                                            ),
                                          ));

                                      if(damageOrNot == "BUS"){
                                        Navigator.pop(context, "true");
                                      }
                                      else if(damageOrNot == "SER"){
                                        Navigator.pop(context, "true");
                                      }
                                      else{
                                        Navigator.pop(context, "true");
                                      }

                                    }
                                  }
                                }
                                else if (state is OffloadULDSaveFailureState){
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
                                          Padding(
                                            padding: EdgeInsets.only(left: 10, right: 10, top: 0, bottom: 8),
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
                                                    child: Row(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        ULDNumberWidget(uldNo: "${widget.offloadULDDetail.uLDNo}", smallFontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5, bigFontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_8, fontColor: MyColor.textColorGrey3, uldType: "U"),
                                                      ],
                                                    ),

                                                  ),
                                                )),

                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(left: 10, right: 10, top: 0, bottom: 10),
                                            child: Directionality(
                                                textDirection: textDirection,
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
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        SizedBox(height: SizeConfig.blockSizeVertical,),
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
                                                            labelText: widget.isGroupBasedAcceptChar == "Y" ? "${lableModel.groupId} *" : "${lableModel.groupId}",
                                                            readOnly: false,
                                                            maxLength: (widget.isGroupBasedAcceptNumber == 0) ? 1 : widget.isGroupBasedAcceptNumber,
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
                                                        SizedBox(height: SizeConfig.blockSizeVertical * SizeUtils.HEIGHT2,),
                                                        Directionality(
                                                          textDirection: textDirection,
                                                          child: Row(
                                                            children: [
                                                              Expanded(
                                                                flex:2,
                                                                child: CustomTextField(
                                                                  focusNode: tempretureFocusNode,
                                                                  textDirection: textDirection,
                                                                  hasIcon: false,
                                                                  hastextcolor: true,
                                                                  animatedLabel: true,
                                                                  needOutlineBorder: true,
                                                                  labelText: "${lableModel.temperature}",
                                                                  readOnly: false,
                                                                  controller: tempretureController,
                                                                  maxLength: 4,
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
                                                                  tempOnly: true,
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
                                                                width: SizeConfig.blockSizeHorizontal * SizeUtils.WIDTH3,
                                                              ),
                                                              Expanded(
                                                                flex: 1,
                                                                child: IntrinsicHeight(
                                                                  child: Row(
                                                                    children: [
                                                                      // Yes Option
                                                                      Expanded(
                                                                        flex:1,
                                                                        child: InkWell(
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
                                                                              ),
                                                                              border: Border.symmetric(horizontal: BorderSide(color: MyColor.primaryColorblue), vertical: BorderSide(color: MyColor.primaryColorblue)), // Border color
                                                                            ),
                                                                            padding: EdgeInsets.symmetric(vertical:10, horizontal: 5),
                                                                            child: Center(
                                                                                child: CustomeText(text: "C", fontColor:  tUnit == "C" ? MyColor.colorWhite : MyColor.textColorGrey3, fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5, fontWeight: FontWeight.w600, textAlign: TextAlign.center)
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),

                                                                      // No Option
                                                                      Expanded(
                                                                        flex: 1,
                                                                        child: InkWell(
                                                                          onTap: () {

                                                                            setState(() {
                                                                              tUnit = "F";
                                                                            });

                                                                          },
                                                                          child: Container(
                                                                            decoration: BoxDecoration(
                                                                              color: tUnit == "F" ? MyColor.primaryColorblue : MyColor.colorWhite, // Selected blue, unselected white
                                                                              borderRadius: BorderRadius.only(
                                                                                topRight: Radius.circular(10),
                                                                                bottomRight: Radius.circular(10),
                                                                              ),
                                                                              border: Border.symmetric(horizontal: BorderSide(color: MyColor.primaryColorblue), vertical: BorderSide(color: MyColor.primaryColorblue)), // Border color
                                                                            ),
                                                                            padding: EdgeInsets.symmetric(vertical:10, horizontal: 5),
                                                                            child: Center(
                                                                                child: CustomeText(text: "F", fontColor: tUnit == "F" ? MyColor.colorWhite : MyColor.textColorGrey3, fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5, fontWeight: FontWeight.w600, textAlign: TextAlign.center)
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),

                                                                    ],
                                                                  ),
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                        SizedBox(height: SizeConfig.blockSizeVertical * SizeUtils.HEIGHT2,),
                                                        Directionality(
                                                          textDirection: textDirection,
                                                          child: CustomTextField(
                                                            focusNode: batteryFocusNode,
                                                            textDirection: textDirection,
                                                            hasIcon: false,
                                                            hastextcolor: true,
                                                            animatedLabel: true,
                                                            needOutlineBorder: true,
                                                            labelText: "${lableModel.battery}",
                                                            readOnly: false,
                                                            controller: batteryController,
                                                            maxLength: 3,
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


                                                      ],
                                                    ),

                                                  ),
                                                ))),



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
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        SizedBox(height: SizeConfig.blockSizeVertical),
                                                        Directionality(
                                                          textDirection: textDirection,
                                                          child: RemarkCustomTextField(
                                                            textDirection: textDirection,
                                                            controller: reasonController,
                                                            focusNode: reasonFocusNode,
                                                            onPress: () {},
                                                            hasIcon: false,
                                                            hastextcolor: true,
                                                            animatedLabel: true,
                                                            needOutlineBorder: true,
                                                            labelText:  "${lableModel.reasonforoffload}",
                                                            readOnly: (selectedSwitchIndex.isEmpty) ? true : (selectedSwitchIndex == "OTH") ? false : true,
                                                            onChanged: (value) {},
                                                            fillColor: Colors.grey.shade100,
                                                            textInputType: TextInputType.text,
                                                            inputAction: TextInputAction.next,
                                                            hintTextcolor: Colors.black45,
                                                            maxLength: 30,
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
                                                        SizedBox(height: SizeConfig.blockSizeVertical),
                                                        ListView.builder(
                                                          itemCount: widget.offloadReasonList.length,
                                                          shrinkWrap: true,
                                                          physics: const NeverScrollableScrollPhysics(),
                                                          itemBuilder: (context, index) {
                                                            Color backgroundColor = MyColor.colorList[index % MyColor.colorList.length];

                                                            OffloadReasonList content = widget.offloadReasonList[index];
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
                                                                            const SizedBox(
                                                                              width: 15,
                                                                            ),
                                                                            Flexible(child: CustomeText(text: content.referenceDescription!, fontColor: MyColor.colorBlack, fontSize: SizeConfig.textMultiplier * 1.5, fontWeight: FontWeight.w400, textAlign: TextAlign.start)),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                      SizedBox(width: 2,),
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
                                                                            reasonController.text = value ? content.referenceDescription! : "";

                                                                            if(selectedSwitchIndex == "OTH"){
                                                                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                                                                FocusScope.of(context).requestFocus(reasonFocusNode);
                                                                              });

                                                                            }

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
                                                        ),

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
                                      text: "${lableModel.offloadandDamage}",
                                      isborderButton: true,
                                      press: () {
                                        btnClick = "D";


                                        /*if (tempretureController.text.isEmpty) {

                                          SnackbarUtil.showSnackbar(context, "${lableModel.templevelmsg}", MyColor.colorRed, icon: FontAwesomeIcons.times);

                                          WidgetsBinding.instance.addPostFrameCallback((_) {
                                            FocusScope.of(context).requestFocus(tempretureFocusNode);
                                          });
                                          Vibration.vibrate(duration: 500);
                                          return;
                                        }*/


                                        if(tempretureController.text.isNotEmpty){

                                          int? temperatureValue = int.tryParse(tempretureController.text);

                                          if (temperatureValue == null || temperatureValue < -100 || temperatureValue > 100) {
                                            SnackbarUtil.showSnackbar(context, "${lableModel.tempminimummsg}", MyColor.colorRed, icon: FontAwesomeIcons.times);

                                            WidgetsBinding.instance.addPostFrameCallback((_) {
                                              FocusScope.of(context).requestFocus(tempretureFocusNode);
                                            });
                                            Vibration.vibrate(duration: 500);
                                            return;
                                          }
                                        }else{

                                        }






                                        /*if (batteryController.text.isEmpty) {
                                          SnackbarUtil.showSnackbar(context, "${lableModel.betterymsg}", MyColor.colorRed, icon: FontAwesomeIcons.times);

                                          WidgetsBinding.instance.addPostFrameCallback((_) {
                                            FocusScope.of(context).requestFocus(batteryFocusNode);
                                          });
                                          Vibration.vibrate(duration: 500);
                                          return;
                                        }*/

                                        if(batteryController.text.isNotEmpty){

                                          int? batteryValue = int.tryParse(batteryController.text);
                                          if (batteryValue! < 0 || batteryValue > 100) {
                                            SnackbarUtil.showSnackbar(context, "${lableModel.betteryminimummsg}", MyColor.colorRed, icon: FontAwesomeIcons.times);

                                            WidgetsBinding.instance.addPostFrameCallback((_) {
                                              FocusScope.of(context).requestFocus(batteryFocusNode);
                                            });
                                            Vibration.vibrate(duration: 500);
                                            return;
                                          }
                                        }else{

                                        }




                                        if(widget.isGroupBasedAcceptChar == "Y"){
                                          if (groupIdController.text.isEmpty) {

                                            SnackbarUtil.showSnackbar(context, lableModel.enterGropIdMsg!, MyColor.colorRed, icon: FontAwesomeIcons.times);
                                            WidgetsBinding.instance.addPostFrameCallback((_) {
                                              FocusScope.of(context).requestFocus(groupIdFocusNode);
                                            });
                                            Vibration.vibrate(duration: 500);

                                            return;
                                          }


                                          if (groupIdController.text.length != widget.isGroupBasedAcceptNumber) {
                                            SnackbarUtil.showSnackbar(context, formatMessage("${lableModel.groupIdCharSizeMsg}", ["${widget.isGroupBasedAcceptNumber}"]), MyColor.colorRed, icon: FontAwesomeIcons.times);
                                            WidgetsBinding.instance.addPostFrameCallback((_) {
                                              FocusScope.of(context).requestFocus(groupIdFocusNode);
                                            });
                                            Vibration.vibrate(duration: 500);

                                            return;
                                          }

                                        }


                                        if (selectedSwitchIndex == "") {
                                          SnackbarUtil.showSnackbar(context, "Select any one reason for offload.", MyColor.colorRed, icon: FontAwesomeIcons.times);
                                          Vibration.vibrate(duration: 500);

                                          return;
                                        }
                                        if (reasonController.text.isEmpty) {
                                          SnackbarUtil.showSnackbar(context, "Please enter reason", MyColor.colorRed, icon: FontAwesomeIcons.times);
                                          WidgetsBinding.instance.addPostFrameCallback((_) {
                                            FocusScope.of(context).requestFocus(reasonFocusNode);
                                          });
                                          Vibration.vibrate(duration: 500);

                                          return;
                                        }


                                        offloadULDSave();
                                      },
                                    ),
                                  ),
                                  SizedBox(width: SizeConfig.blockSizeHorizontal * SizeUtils.HEIGHT3,),
                                  Expanded(
                                    flex: 1,
                                    child: RoundedButtonBlue(
                                      text: "${lableModel.offload}",
                                      press: () {

                                        btnClick = "O";

                                        if(tempretureController.text.isNotEmpty){

                                          int? temperatureValue = int.tryParse(tempretureController.text);

                                          if (temperatureValue == null || temperatureValue < -100 || temperatureValue > 100) {
                                            SnackbarUtil.showSnackbar(context, "${lableModel.tempminimummsg}", MyColor.colorRed, icon: FontAwesomeIcons.times);

                                            WidgetsBinding.instance.addPostFrameCallback((_) {
                                              FocusScope.of(context).requestFocus(tempretureFocusNode);
                                            });
                                            Vibration.vibrate(duration: 500);
                                            return;
                                          }
                                        }else{

                                        }



                                        if(batteryController.text.isNotEmpty){

                                          int? batteryValue = int.tryParse(batteryController.text);
                                          if (batteryValue! < 0 || batteryValue > 100) {
                                            SnackbarUtil.showSnackbar(context, "${lableModel.betteryminimummsg}", MyColor.colorRed, icon: FontAwesomeIcons.times);

                                            WidgetsBinding.instance.addPostFrameCallback((_) {
                                              FocusScope.of(context).requestFocus(batteryFocusNode);
                                            });
                                            Vibration.vibrate(duration: 500);
                                            return;
                                          }
                                        }else{

                                        }



                                        if(widget.isGroupBasedAcceptChar == "Y"){
                                          if (groupIdController.text.isEmpty) {
                                            SnackbarUtil.showSnackbar(context, lableModel.enterGropIdMsg!, MyColor.colorRed, icon: FontAwesomeIcons.times);
                                            WidgetsBinding.instance.addPostFrameCallback((_) {
                                              FocusScope.of(context).requestFocus(groupIdFocusNode);
                                            });
                                            Vibration.vibrate(duration: 500);

                                            return;
                                          }


                                          if (groupIdController.text.length != widget.isGroupBasedAcceptNumber) {
                                            SnackbarUtil.showSnackbar(context, formatMessage("${lableModel.groupIdCharSizeMsg}", ["${widget.isGroupBasedAcceptNumber}"]), MyColor.colorRed, icon: FontAwesomeIcons.times);
                                            WidgetsBinding.instance.addPostFrameCallback((_) {
                                              FocusScope.of(context).requestFocus(groupIdFocusNode);
                                            });
                                            Vibration.vibrate(duration: 500);

                                            return;
                                          }
                                        }

                                        if (selectedSwitchIndex == "") {
                                          SnackbarUtil.showSnackbar(context, "Select any one reason for offload.", MyColor.colorRed, icon: FontAwesomeIcons.times);
                                          Vibration.vibrate(duration: 500);

                                          return;
                                        }

                                        if (reasonController.text.isEmpty) {
                                          SnackbarUtil.showSnackbar(context, "Please enter reason", MyColor.colorRed, icon: FontAwesomeIcons.times);
                                          WidgetsBinding.instance.addPostFrameCallback((_) {
                                            FocusScope.of(context).requestFocus(reasonFocusNode);
                                          });
                                          Vibration.vibrate(duration: 500);

                                          return;
                                        }

                                        offloadULDSave();
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

  String formatMessage(String template, List<String> values) {
    String formattedMessage = template;
    for (int i = 0; i < values.length; i++) {
      formattedMessage = formattedMessage.replaceAll('{$i}', values[i]);
    }
    return formattedMessage;
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



  Future<void> offloadULDSave() async {
    await context.read<OffloadCubit>().offloadULDSave(
        widget.offloadULDDetail.uLDSeqNo!,
        widget.offloadULDDetail.flightSeqNo!,
        tempretureController.text,
        tUnit,
        (batteryController.text.isNotEmpty) ? int.parse(batteryController.text) : 0,
        groupIdController.text,
        selectedSwitchIndex,
        reasonController.text,
        widget.offloadULDDetail.offPoint!,
        widget.locationCode,
        _user!.userProfile!.userIdentity!,
        _splashDefaultData!.companyCode!,
        widget.menuId);
  }

}

