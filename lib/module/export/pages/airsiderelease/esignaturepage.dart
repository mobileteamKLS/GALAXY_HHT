import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:galaxy/core/mycolor.dart';
import 'package:galaxy/module/export/services/airsiderelease/airsidelogic/airsidereleasecubit.dart';
import 'package:galaxy/module/export/services/airsiderelease/airsidelogic/airsidereleasestate.dart';
import 'package:galaxy/utils/sizeutils.dart';
import 'package:galaxy/widget/customdivider.dart';
import 'package:galaxy/widget/custometext.dart';
import 'package:signature/signature.dart';
import 'package:vibration/vibration.dart';
import '../../../../../../widget/customeuiwidgets/header.dart';
import '../../../../language/appLocalizations.dart';
import '../../../../language/model/lableModel.dart';
import '../../../../manager/timermanager.dart';
import '../../../../prefrence/savedprefrence.dart';
import '../../../../utils/commonutils.dart';
import '../../../../utils/dialogutils.dart';
import '../../../../utils/snackbarutil.dart';
import '../../../../widget/customebuttons/roundbuttonblue.dart';
import '../../../../widget/customedrawer/customedrawer.dart';
import '../../../../widget/header/mainheadingwidget.dart';
import '../../../login/pages/signinscreenmethods.dart';
import '../../../profile/page/profilepagescreen.dart';
import '../../../splash/model/splashdefaultmodel.dart';
import '../../../onboarding/sizeconfig.dart';
import 'dart:ui' as ui;

import '../../../login/model/userlogindatamodel.dart';
import '../../../submenu/model/submenumodel.dart';
import '../../model/airsiderelease/airsidereleasepageloadmodel.dart';
import '../../model/airsiderelease/airsidereleasesearchmodel.dart';
import '../../model/airsiderelease/designtype.dart';

class ESignaturePage extends StatefulWidget {
  String mainMenuName;
  String title;
  String refrelCode;
  LableModel? lableModel;
  int menuId;
  List<SubMenuName> importSubMenuList = [];
  List<SubMenuName> exportSubMenuList = [];
  List<AirsideReleaseDetailList> selectedItems = [];
  String locationCode;
  int flightSeqNo;
  String isAirlineSignRequired;
  String iscustomerSignRequired;
  String issecuritySignRequired;
  String iscisfSignRequired;
  List<DesignationWiseSignatureSettingList> signatureList;

  ESignaturePage(
      {super.key,
      required this.importSubMenuList,
      required this.exportSubMenuList,
      required this.title,
      required this.refrelCode,
      required this.selectedItems,
      required this.locationCode,
      this.lableModel,
      required this.flightSeqNo,
      required this.menuId,
      required this.mainMenuName,
      required this.isAirlineSignRequired,
      required this.iscustomerSignRequired,
      required this.issecuritySignRequired,
      required this.iscisfSignRequired,
      required this.signatureList,
      });

  @override
  State<ESignaturePage> createState() => _ESignaturePageState();
}

class _ESignaturePageState extends State<ESignaturePage> {

  List<AirsideReleaseDetailList> selectedItemsC = [];

  InactivityTimerManager? inactivityTimerManager;
  final SavedPrefrence savedPrefrence = SavedPrefrence();
  UserDataModel? _user;
  SplashDefaultModel? _splashDefaultData;
  final ScrollController scrollController = ScrollController();
  String signatureUpload = "N";

  final List<DesignType> designTypeList = [
    DesignType(type: 'C', name: 'EGPC - Airline Rep.', enable: "N"),
    DesignType(type: 'A', name: 'EGPA - Customer Staff', enable: "N"),
    DesignType(type: 'S', name: 'EGPS - Security Staff', enable: "N"),
    DesignType(type: 'I', name: 'EGPI - CISF', enable: "N"),
  ];



  final List<SignatureController> _controllers = List.generate(
        4,
        (index) => SignatureController(
        penStrokeWidth: 2,
        penColor: Colors.black,
        exportBackgroundColor: Colors.white
    ),
  );


  SignatureController airlineRepController = SignatureController( penStrokeWidth: 2,
      penColor: Colors.black,
      exportBackgroundColor: Colors.white);

  String airlineSignDone = "";

  SignatureController customerStaffController = SignatureController( penStrokeWidth: 2,
      penColor: Colors.black,
      exportBackgroundColor: Colors.white);

  String customerSignDone = "";

  SignatureController securityStaffController = SignatureController( penStrokeWidth: 2,
      penColor: Colors.black,
      exportBackgroundColor: Colors.white);

  String securitySignDone = "";


  SignatureController cisfController = SignatureController( penStrokeWidth: 2,
      penColor: Colors.black,
      exportBackgroundColor: Colors.white);

  String cisfSignDone = "";

  String signatureClickBtn = "";

  void updateDesignTypeList() {
    // Loop through the API response and update the designTypeList
    for (var designation in widget.signatureList) {
      for (var designType in designTypeList) {
        if (designType.name.contains(designation.text!)) {
          designType.enable = designation.char!; // Update enable property
        }
      }
    }
  }

  @override
  void initState() {
    super.initState();
    updateDesignTypeList();

/*    _controllers = List.generate(
      designTypeList.length,
          (index) => SignatureController(
        penStrokeWidth: 2,
        penColor: Colors.black,
        exportBackgroundColor: Colors.white,
      ),
    );*/

    _loadUser(); //load user data
    selectedItemsC = widget.selectedItems;
  }

  @override
  void dispose() {
    super.dispose();
    airlineRepController.dispose();
    customerStaffController.dispose();
    securityStaffController.dispose();
    cisfController.dispose();
    for (var controller in _controllers) {
      controller.dispose();
    }

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


    // Filter enabled design types
    final List<DesignType> enabledDesignTypes = designTypeList
        .where((item) => item.enable == "Y")
        .toList();
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
                                onBack: _onWillPop,
                                clearText: lableModel!.clear,
                                //add clear text to clear all feild
                                onClear: () {
                                  setState(() {
                                    airlineRepController.clear();
                                    customerStaffController.clear();
                                    securityStaffController.clear();
                                    cisfController.clear();
                                  });
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
                                else if (state is AirsideReleaseDataSuccessState){

                                  if(state.airsideReleaseDataModel.status == "E"){
                                    DialogUtils.hideLoadingDialog(context);
                                    Vibration.vibrate(duration: 500);
                                    SnackbarUtil.showSnackbar(
                                        context,
                                        state.airsideReleaseDataModel.statusMessage!,
                                        MyColor.colorRed,
                                        icon: FontAwesomeIcons.times);
                                  }else{
                                    if(selectedItemsC.isEmpty){
                                      DialogUtils.hideLoadingDialog(context);
                                      Navigator.pop(context, "true");
                                     /* SnackbarUtil.showSnackbar(
                                          context,
                                          state.airsideReleaseDataModel.statusMessage!,
                                          MyColor.colorGreen,
                                          icon: Icons.done);*/
                                    }else{

                                    }


                                  }
                                }
                                else if (state is AirsideReleaseDataFailureState){
                                  DialogUtils.hideLoadingDialog(context);
                                  Vibration.vibrate(duration: 500);
                                  SnackbarUtil.showSnackbar(
                                      context,
                                      state.error,
                                      MyColor.colorRed,
                                      icon: FontAwesomeIcons.times);
                                }
                                else if (state is AirsideSignUploadSuccesState){

                                  if(state.airsideSignUploadModel.status == "E"){
                                    DialogUtils.hideLoadingDialog(context);
                                    Vibration.vibrate(duration: 500);
                                    SnackbarUtil.showSnackbar(
                                        context,
                                        state.airsideSignUploadModel.statusMessage!,
                                        MyColor.colorRed,
                                        icon: FontAwesomeIcons.times);
                                  }else{
                                    if(signatureUpload == "Y"){

                                    /*  if(signatureClickBtn == "C"){
                                        airlineSignDone = "C";
                                      }else if(signatureClickBtn == "A"){
                                        customerSignDone = "A";
                                      }else if(signatureClickBtn == "S"){
                                        securitySignDone = "S";
                                      }else if(signatureClickBtn == "I"){
                                        cisfSignDone = "I";
                                      }*/

                                      DialogUtils.hideLoadingDialog(context);
                                       SnackbarUtil.showSnackbar(
                                          context,
                                          state.airsideSignUploadModel.statusMessage!,
                                          MyColor.colorGreen,
                                          icon: Icons.done);
                                    }else{

                                    }
                                  }

                                }
                                else if (state is AirsideSignUploadFailureState){
                                  DialogUtils.hideLoadingDialog(context);
                                  Vibration.vibrate(duration: 500);
                                  SnackbarUtil.showSnackbar(
                                      context,
                                      state.error,
                                      MyColor.colorRed,
                                      icon: FontAwesomeIcons.times);
                                }

                              },
                              child: Expanded(
                                child: SingleChildScrollView(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 10,
                                            right: 10,
                                            top: 0,
                                            bottom: 0),
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                                          width: double.infinity,
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
                                            children: [


                                            /*  GridView(
                                                shrinkWrap: true,
                                                physics: NeverScrollableScrollPhysics(),
                                                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                                    crossAxisCount: 2,
                                                    crossAxisSpacing: 4,
                                                    mainAxisSpacing: 5,
                                                    childAspectRatio: 0.9,),
                                                children: [
                                                  widget.isAirlineSignRequired == "Y" ? Container(
                                                    decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius: BorderRadius.circular(6),
                                                      boxShadow: [
                                                        BoxShadow(
                                                          color: MyColor.colorBlack.withOpacity(0.09),
                                                          spreadRadius: 1,
                                                          blurRadius: 20,
                                                          offset: const Offset(0, 3), // Shadow position
                                                        ),
                                                      ],
                                                    ),
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.stretch,
                                                      children: [
                                                        // Signature Pad
                                                        Padding(
                                                          padding: const EdgeInsets.only(top: 5),
                                                          child: CustomeText(text: "EGPC - Airline Rep.", fontColor: MyColor.colorBlack, fontSize: 12, fontWeight: FontWeight.w500, textAlign: TextAlign.center),
                                                        ),
                                                        const SizedBox(height: 2),
                                                        Expanded(
                                                          flex: 4,
                                                          child: Container(
                                                            padding: const EdgeInsets.all(2),
                                                            decoration: BoxDecoration(
                                                              borderRadius: BorderRadius.circular(6),
                                                              boxShadow: [
                                                                BoxShadow(
                                                                  color: MyColor.colorBlack.withOpacity(0.09),
                                                                  spreadRadius: 2,
                                                                  blurRadius: 15,
                                                                  offset: Offset(0, 3), // changes position of shadow
                                                                ),
                                                              ],
                                                            ),

                                                            child: Signature(
                                                              controller: airlineRepController,
                                                              backgroundColor: Colors.white,
                                                            ),
                                                          ),
                                                        ),
                                                        const SizedBox(height: 2),
                                                        Padding(
                                                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                                          child: CustomDivider(
                                                            space: 0,
                                                            color: Colors.black,
                                                            hascolor: true,
                                                            thickness: 1,
                                                          ),
                                                        ),
                                                        // Buttons
                                                        Row(
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          children: [
                                                            // Reset Button
                                                            Expanded(
                                                              child: Padding(
                                                                padding: const EdgeInsets.all(8.0),
                                                                child: RoundedButtonBlue(
                                                                  verticalPadding: 5,
                                                                  textSize: 12,
                                                                  text: "Reset",
                                                                  press: () {
                                                                    airlineRepController.clear();
                                                                  },
                                                                ),
                                                              ),
                                                            ),
                                                            const SizedBox(width: 5),
                                                            // Record Button
                                                            Expanded(
                                                              child: Padding(
                                                                padding: const EdgeInsets.all(8.0),
                                                                child: RoundedButtonBlue(
                                                                  verticalPadding: 5,
                                                                  textSize: 12,
                                                                  text: "Record",
                                                                  press: () async {
                                                                    signatureUpload = "N";
                                                                    print("Signature======= pending");

                                                                    Uint8List? signature = await airlineRepController.toPngBytes();
                                                                    if(signature != null){
                                                                      signatureClickBtn = "C";
                                                                      String base64Image = base64Encode(signature);

                                                                      String signatureImage = generateImageXMLData(base64Image);

                                                                      for (var item in widget.selectedItems) {
                                                                        await signUpload(item, widget.flightSeqNo, "C", signatureImage);
                                                                      }

                                                                      setState(() {
                                                                        signatureUpload = "Y";
                                                                      });

                                                                      print("Signature======= Success${base64Image}");
                                                                    }else{
                                                                      Vibration.vibrate(duration: 500);
                                                                      SnackbarUtil.showSnackbar(
                                                                          context,
                                                                          "Please enter sign first",
                                                                          MyColor.colorRed,
                                                                          icon: FontAwesomeIcons.times);
                                                                    }

                                                                    // Handle recording logic here
                                                                  },
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ) : SizedBox(),
                                                  widget.iscustomerSignRequired == "Y" ? Container(
                                                    decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius: BorderRadius.circular(6),
                                                      boxShadow: [
                                                        BoxShadow(
                                                          color: MyColor.colorBlack.withOpacity(0.09),
                                                          spreadRadius: 1,
                                                          blurRadius: 20,
                                                          offset: const Offset(0, 3), // Shadow position
                                                        ),
                                                      ],
                                                    ),
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.stretch,
                                                      children: [
                                                        // Signature Pad
                                                        Padding(
                                                          padding: const EdgeInsets.only(top: 5),
                                                          child: CustomeText(text: "EGPA - Customer Staff", fontColor: MyColor.colorBlack, fontSize: 12, fontWeight: FontWeight.w500, textAlign: TextAlign.center),
                                                        ),
                                                        const SizedBox(height: 2),
                                                        Expanded(
                                                          flex: 4,
                                                          child: Container(
                                                            padding: const EdgeInsets.all(2),
                                                            decoration: BoxDecoration(
                                                              borderRadius: BorderRadius.circular(6),
                                                              boxShadow: [
                                                                BoxShadow(
                                                                  color: MyColor.colorBlack.withOpacity(0.09),
                                                                  spreadRadius: 2,
                                                                  blurRadius: 15,
                                                                  offset: Offset(0, 3), // changes position of shadow
                                                                ),
                                                              ],
                                                            ),

                                                            child: Signature(
                                                              controller: customerStaffController,
                                                              backgroundColor: Colors.white,
                                                            ),
                                                          ),
                                                        ),
                                                        const SizedBox(height: 2),
                                                        Padding(
                                                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                                          child: CustomDivider(
                                                            space: 0,
                                                            color: Colors.black,
                                                            hascolor: true,
                                                            thickness: 1,
                                                          ),
                                                        ),
                                                        // Buttons
                                                        Row(
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          children: [
                                                            // Reset Button
                                                            Expanded(
                                                              child: Padding(
                                                                padding: const EdgeInsets.all(8.0),
                                                                child: RoundedButtonBlue(
                                                                  verticalPadding: 5,
                                                                  textSize: 12,
                                                                  text: "Reset",
                                                                  press: () {
                                                                    customerStaffController.clear();
                                                                  },
                                                                ),
                                                              ),
                                                            ),
                                                            const SizedBox(width: 5),
                                                            // Record Button
                                                            Expanded(
                                                              child: Padding(
                                                                padding: const EdgeInsets.all(8.0),
                                                                child: RoundedButtonBlue(
                                                                  verticalPadding: 5,
                                                                  textSize: 12,
                                                                  text: "Record",
                                                                  press: () async {
                                                                    signatureUpload = "N";
                                                                    print("Signature======= pending");

                                                                    Uint8List? signature = await customerStaffController.toPngBytes();
                                                                    if(signature != null){
                                                                      signatureClickBtn = "A";
                                                                      String base64Image = base64Encode(signature);

                                                                      String signatureImage = generateImageXMLData(base64Image);

                                                                      for (var item in widget.selectedItems) {
                                                                        await signUpload(item, widget.flightSeqNo, "A", signatureImage);
                                                                      }

                                                                      setState(() {
                                                                        signatureUpload = "Y";
                                                                      });

                                                                      print("Signature======= Success${base64Image}");
                                                                    }else{
                                                                      Vibration.vibrate(duration: 500);
                                                                      SnackbarUtil.showSnackbar(
                                                                          context,
                                                                          "Please enter sign first",
                                                                          MyColor.colorRed,
                                                                          icon: FontAwesomeIcons.times);
                                                                    }

                                                                    // Handle recording logic here
                                                                  },
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ) : SizedBox(),
                                                  widget.issecuritySignRequired == "Y" ?  Container(
                                                    decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius: BorderRadius.circular(6),
                                                      boxShadow: [
                                                        BoxShadow(
                                                          color: MyColor.colorBlack.withOpacity(0.09),
                                                          spreadRadius: 1,
                                                          blurRadius: 20,
                                                          offset: const Offset(0, 3), // Shadow position
                                                        ),
                                                      ],
                                                    ),
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.stretch,
                                                      children: [
                                                        // Signature Pad
                                                        Padding(
                                                          padding: const EdgeInsets.only(top: 5),
                                                          child: CustomeText(text: "EGPS - Security Staff", fontColor: MyColor.colorBlack, fontSize: 12, fontWeight: FontWeight.w500, textAlign: TextAlign.center),
                                                        ),
                                                        const SizedBox(height: 2),
                                                        Expanded(
                                                          flex: 4,
                                                          child: Container(
                                                            padding: const EdgeInsets.all(2),
                                                            decoration: BoxDecoration(
                                                              borderRadius: BorderRadius.circular(6),
                                                              boxShadow: [
                                                                BoxShadow(
                                                                  color: MyColor.colorBlack.withOpacity(0.09),
                                                                  spreadRadius: 2,
                                                                  blurRadius: 15,
                                                                  offset: Offset(0, 3), // changes position of shadow
                                                                ),
                                                              ],
                                                            ),

                                                            child: Signature(
                                                              controller: securityStaffController,
                                                              backgroundColor: Colors.white,
                                                            ),
                                                          ),
                                                        ),
                                                        const SizedBox(height: 2),
                                                        Padding(
                                                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                                          child: CustomDivider(
                                                            space: 0,
                                                            color: Colors.black,
                                                            hascolor: true,
                                                            thickness: 1,
                                                          ),
                                                        ),
                                                        // Buttons
                                                        Row(
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          children: [
                                                            // Reset Button
                                                            Expanded(
                                                              child: Padding(
                                                                padding: const EdgeInsets.all(8.0),
                                                                child: RoundedButtonBlue(
                                                                  verticalPadding: 5,
                                                                  textSize: 12,
                                                                  text: "Reset",
                                                                  press: () {
                                                                    securityStaffController.clear();
                                                                  },
                                                                ),
                                                              ),
                                                            ),
                                                            const SizedBox(width: 5),
                                                            // Record Button
                                                            Expanded(
                                                              child: Padding(
                                                                padding: const EdgeInsets.all(8.0),
                                                                child: RoundedButtonBlue(
                                                                  verticalPadding: 5,
                                                                  textSize: 12,
                                                                  text: "Record",
                                                                  press: () async {
                                                                    signatureUpload = "N";
                                                                    print("Signature======= pending");

                                                                    Uint8List? signature = await securityStaffController.toPngBytes();
                                                                    if(signature != null){
                                                                      signatureClickBtn = "S";
                                                                      String base64Image = base64Encode(signature);

                                                                      String signatureImage = generateImageXMLData(base64Image);

                                                                      for (var item in widget.selectedItems) {
                                                                        await signUpload(item, widget.flightSeqNo, "S", signatureImage);
                                                                      }

                                                                      setState(() {
                                                                        signatureUpload = "Y";
                                                                      });

                                                                      print("Signature======= Success${base64Image}");
                                                                    }else{
                                                                      Vibration.vibrate(duration: 500);
                                                                      SnackbarUtil.showSnackbar(
                                                                          context,
                                                                          "Please enter sign first",
                                                                          MyColor.colorRed,
                                                                          icon: FontAwesomeIcons.times);
                                                                    }

                                                                    // Handle recording logic here
                                                                  },
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ) : SizedBox(),
                                                  widget.iscisfSignRequired == "Y" ? Container(
                                                    decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius: BorderRadius.circular(6),
                                                      boxShadow: [
                                                        BoxShadow(
                                                          color: MyColor.colorBlack.withOpacity(0.09),
                                                          spreadRadius: 1,
                                                          blurRadius: 20,
                                                          offset: const Offset(0, 3), // Shadow position
                                                        ),
                                                      ],
                                                    ),
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.stretch,
                                                      children: [
                                                        // Signature Pad
                                                        Padding(
                                                          padding: const EdgeInsets.only(top: 5),
                                                          child: CustomeText(text: "EGPI - CISF", fontColor: MyColor.colorBlack, fontSize: 12, fontWeight: FontWeight.w500, textAlign: TextAlign.center),
                                                        ),
                                                        const SizedBox(height: 2),
                                                        Expanded(
                                                          flex: 4,
                                                          child: Container(
                                                            padding: const EdgeInsets.all(2),
                                                            decoration: BoxDecoration(
                                                              borderRadius: BorderRadius.circular(6),
                                                              boxShadow: [
                                                                BoxShadow(
                                                                  color: MyColor.colorBlack.withOpacity(0.09),
                                                                  spreadRadius: 2,
                                                                  blurRadius: 15,
                                                                  offset: Offset(0, 3), // changes position of shadow
                                                                ),
                                                              ],
                                                            ),

                                                            child: Signature(
                                                              controller: cisfController,
                                                              backgroundColor: Colors.white,
                                                            ),
                                                          ),
                                                        ),
                                                        const SizedBox(height: 2),
                                                        Padding(
                                                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                                          child: CustomDivider(
                                                            space: 0,
                                                            color: Colors.black,
                                                            hascolor: true,
                                                            thickness: 1,
                                                          ),
                                                        ),
                                                        // Buttons
                                                        Row(
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          children: [
                                                            // Reset Button
                                                            Expanded(
                                                              child: Padding(
                                                                padding: const EdgeInsets.all(8.0),
                                                                child: RoundedButtonBlue(
                                                                  verticalPadding: 5,
                                                                  textSize: 12,
                                                                  text: "Reset",
                                                                  press: () {
                                                                    cisfController.clear();
                                                                  },
                                                                ),
                                                              ),
                                                            ),
                                                            const SizedBox(width: 5),
                                                            // Record Button
                                                            Expanded(
                                                              child: Padding(
                                                                padding: const EdgeInsets.all(8.0),
                                                                child: RoundedButtonBlue(
                                                                  verticalPadding: 5,
                                                                  textSize: 12,
                                                                  text: "Record",
                                                                  press: () async {
                                                                    signatureUpload = "N";

                                                                    print("Signature======= pending");

                                                                    Uint8List? signature = await cisfController.toPngBytes();
                                                                    if(signature != null){
                                                                      signatureClickBtn = "I";
                                                                      String base64Image = base64Encode(signature);

                                                                      String signatureImage = generateImageXMLData(base64Image);

                                                                      for (var item in widget.selectedItems) {
                                                                        await signUpload(item, widget.flightSeqNo, "I", signatureImage);
                                                                      }

                                                                      setState(() {
                                                                        signatureUpload = "Y";
                                                                      });

                                                                      print("Signature======= Success${base64Image}");
                                                                    }else{
                                                                      Vibration.vibrate(duration: 500);
                                                                      SnackbarUtil.showSnackbar(
                                                                          context,
                                                                          "Please enter sign first",
                                                                          MyColor.colorRed,
                                                                          icon: FontAwesomeIcons.times);
                                                                    }

                                                                    // Handle recording logic here
                                                                  },
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ) : SizedBox()
                                                ],
                                              ),*/


                                              GridView.builder(
                                                shrinkWrap: true,
                                                physics: const NeverScrollableScrollPhysics(),
                                                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                                  crossAxisCount: 2,
                                                  crossAxisSpacing: 4,
                                                  mainAxisSpacing: 5,
                                                  childAspectRatio: 0.9, // Adjusted aspect ratio for better alignment
                                                ),
                                                itemCount: enabledDesignTypes.length,
                                                itemBuilder: (context, index) {

                                                  DesignType designType = enabledDesignTypes[index];

                                                  return Container(
                                                    decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius: BorderRadius.circular(6),
                                                      boxShadow: [
                                                        BoxShadow(
                                                          color: MyColor.colorBlack.withOpacity(0.09),
                                                          spreadRadius: 1,
                                                          blurRadius: 20,
                                                          offset: const Offset(0, 3), // Shadow position
                                                        ),
                                                      ],
                                                    ),
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.stretch,
                                                      children: [
                                                        // Signature Pad
                                                        Padding(
                                                          padding: const EdgeInsets.only(top: 5),
                                                          child: CustomeText(text: designType.name, fontColor: MyColor.colorBlack, fontSize: 12, fontWeight: FontWeight.w500, textAlign: TextAlign.center),
                                                        ),
                                                        const SizedBox(height: 2),
                                                        Expanded(
                                                          flex: 4,
                                                          child: Container(
                                                            padding: const EdgeInsets.all(2),
                                                            decoration: BoxDecoration(
                                                              borderRadius: BorderRadius.circular(6),
                                                              boxShadow: [
                                                                BoxShadow(
                                                                  color: MyColor.colorBlack.withOpacity(0.09),
                                                                  spreadRadius: 2,
                                                                  blurRadius: 15,
                                                                  offset: Offset(0, 3), // changes position of shadow
                                                                ),
                                                              ],
                                                            ),

                                                            child: Signature(
                                                              controller: _controllers[index],
                                                              backgroundColor: Colors.white,
                                                            ),
                                                          ),
                                                        ),
                                                        const SizedBox(height: 2),
                                                        Padding(
                                                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                                          child: CustomDivider(
                                                            space: 0,
                                                            color: Colors.black,
                                                            hascolor: true,
                                                            thickness: 1,
                                                          ),
                                                        ),
                                                        // Buttons
                                                        Row(
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          children: [
                                                            // Reset Button
                                                            Expanded(
                                                              child: Padding(
                                                                padding: const EdgeInsets.all(8.0),
                                                                child: RoundedButtonBlue(
                                                                  verticalPadding: 5,
                                                                  textSize: 12,
                                                                  text: "Reset",
                                                                  press: () {
                                                                    _controllers[index].clear();
                                                                  },
                                                                ),
                                                              ),
                                                            ),
                                                            const SizedBox(width: 5),
                                                            // Record Button
                                                            Expanded(
                                                              child: Padding(
                                                                padding: const EdgeInsets.all(8.0),
                                                                child: RoundedButtonBlue(
                                                                  verticalPadding: 5,
                                                                  textSize: 12,
                                                                  text: "Record",
                                                                  press: () async {
                                                                    signatureUpload = "N";
                                                                    print("Signature======= pending");

                                                                    Uint8List? signature = await _controllers[index].toPngBytes();
                                                                    if(signature != null){

                                                                      String base64Image = base64Encode(signature);

                                                                      String signatureImage = generateImageXMLData(base64Image);

                                                                      for (var item in widget.selectedItems) {
                                                                        await signUpload(item, widget.flightSeqNo, designType.type, signatureImage);
                                                                      }

                                                                      setState(() {
                                                                        signatureUpload = "Y";
                                                                      });

                                                                      print("Signature======= Success${base64Image}");
                                                                    }else{
                                                                      Vibration.vibrate(duration: 500);
                                                                      SnackbarUtil.showSnackbar(
                                                                          context,
                                                                         "Please enter sign first",
                                                                          MyColor.colorRed,
                                                                          icon: FontAwesomeIcons.times);
                                                                    }

                                                                                                                                      // Handle recording logic here
                                                                  },
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                },
                                              ),

                                              Padding(
                                                padding: const EdgeInsets.only(top:12),
                                                child: Row(
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
                                                    const SizedBox(width: 10),
                                                    Expanded(
                                                      flex: 1,
                                                      child: RoundedButtonBlue(
                                                        text: "Release",
                                                        press: () async {
                                                          for (var item in selectedItemsC) {
                                                            await releaseAirsideDetail(item);
                                                          }

                                                          setState(() {
                                                            selectedItemsC.clear();
                                                          });

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



  //
  void getAirsideReleaseDetail(
      BuildContext context,
      String locationCode,
      String scan,
      int userId,
      int companyCode,
      int menuId) {
    context.read<AirSideReleaseCubit>().getAirsideRelease(
        locationCode,
        scan,
        userId,
        companyCode,
        menuId);
  }

  Future<void> releaseAirsideDetail(AirsideReleaseDetailList item) async {
    await context.read<AirSideReleaseCubit>().releaseULDorTrolley(widget.locationCode, item.gpNo!, 0, item.uLDSeqNo!, (item.uLDType == "T") ? "T" : "U", _user!.userProfile!.userIdentity!, _splashDefaultData!.companyCode!, widget.menuId);
  }

  Future<void> signUpload(AirsideReleaseDetailList item, int flightSeqNo,String desigType, String image) async {
    await context.read<AirSideReleaseCubit>().airsideSignUpload(flightSeqNo, item.uLDSeqNo!, item.gpNo!, desigType, image, _user!.userProfile!.userIdentity!, _splashDefaultData!.companyCode!, widget.menuId);
  }

  String generateImageXMLData(String selectSign) {
    StringBuffer xmlBuffer = StringBuffer();
    xmlBuffer.write('<BinaryImageLists>');
    xmlBuffer.write('<BinaryImageList>');
    xmlBuffer.write('<BinaryImage>$selectSign</BinaryImage>');
    xmlBuffer.write('</BinaryImageList>');
    xmlBuffer.write('</BinaryImageLists>');
    return xmlBuffer.toString();
  }
}