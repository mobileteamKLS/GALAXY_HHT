import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:galaxy/core/mycolor.dart';
import 'package:galaxy/module/export/pages/palletstatck/addpalletstackpage.dart';
import 'package:galaxy/module/export/services/palletstack/palletstacklogic/palletstackcubit.dart';
import 'package:galaxy/module/export/services/palletstack/palletstacklogic/palletstackstate.dart';
import 'package:galaxy/utils/sizeutils.dart';
import 'package:galaxy/widget/custometext.dart';
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
import '../../../../widget/customebuttons/roundbuttonblue.dart';
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
import '../../model/palletstock/palletstackpageloadmodel.dart';
import '../../model/palletstock/palletstackuldconditioncodemodel.dart';

class PalletStatckPage extends StatefulWidget {
  String mainMenuName;
  String title;
  String refrelCode;
  LableModel? lableModel;
  int menuId;
  List<SubMenuName> importSubMenuList = [];
  List<SubMenuName> exportSubMenuList = [];


  PalletStatckPage(
      {super.key,
      required this.importSubMenuList,
      required this.exportSubMenuList,
      required this.title,
      required this.refrelCode,
      this.lableModel,
      required this.menuId,
      required this.mainMenuName});

  @override
  State<PalletStatckPage> createState() => _PalletStatckPageState();
}

class _PalletStatckPageState extends State<PalletStatckPage>
    with SingleTickerProviderStateMixin {

  PalletStackPageLoadModel? palletStackPageLoadModel;

  InactivityTimerManager? inactivityTimerManager;
  final SavedPrefrence savedPrefrence = SavedPrefrence();
  UserDataModel? _user;
  SplashDefaultModel? _splashDefaultData;
  final ScrollController scrollController = ScrollController();
  String requiredLocation = "Y";
  int uldSeqNo = 0;
  String uldNo = "";


  TextEditingController locationController = TextEditingController();
  TextEditingController igmNoEditingController = TextEditingController();



  FocusNode locationFocusNode = FocusNode();
  FocusNode locationBtnFocusNode = FocusNode();
  FocusNode igmNoFocusNode = FocusNode();
  FocusNode scanBtnFocusNode = FocusNode();




  bool _isLocationSearchBtnEnable = false;
  bool _isvalidateLocation = false;




  @override
  void initState() {
    super.initState();
    _loadUser(); //load user data

    locationFocusNode.addListener(() {
      if (!locationFocusNode.hasFocus) {
        leaveLocationFocus();
      }
    });


    locationController.addListener(_validateLocationSearchBtn);


    igmNoFocusNode.addListener(() {
      if(!igmNoFocusNode.hasFocus){
        if(igmNoEditingController.text.isNotEmpty){
          getPageLoadDetail(igmNoEditingController.text);
        }else{
        //  getPageLoadDetail("");
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
    locationController.dispose();
    locationFocusNode.dispose();
    igmNoEditingController.dispose();
    igmNoFocusNode.dispose();
    scanBtnFocusNode.dispose();

  }

  Future<void> _loadUser() async {
    final user = await savedPrefrence.getUserData();
    final splashDefaultData = await savedPrefrence.getSplashDefaultData();
    if (user != null && splashDefaultData != null) {
      setState(() {
        _user = user;
        _splashDefaultData = splashDefaultData;
      });

      getDefaultPageLoadDetail();
     // getPageLoadDetail("");

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

  Future<void> leaveLocationFocus() async {
    if (locationController.text.isNotEmpty) {
      //call location validation api
      await context.read<PalletStackCubit>().getValidateLocation(
          locationController.text,
          _user!.userProfile!.userIdentity!,
          _splashDefaultData!.companyCode!,
          widget.menuId,
          "a");
    }else{
      //focus on location feild
      WidgetsBinding.instance.addPostFrameCallback((_) {
        FocusScope.of(context).requestFocus(igmNoFocusNode);
      },
      );
    }
  }

  void _validateLocationSearchBtn() {
    setState(() {
      _isLocationSearchBtnEnable = locationController.text.isNotEmpty;
    });
  }


  Future<bool> _onWillPop() async {
    FocusScope.of(context).unfocus();
    locationController.clear();
    igmNoEditingController.clear();
    _isvalidateLocation = false;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(locationFocusNode);
    },
    );

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
                                onBack: _onWillPop,
                                clearText: lableModel!.clear,
                                //add clear text to clear all feild
                                onClear: () {
                                  igmNoEditingController.clear();
                                  locationController.clear();
                                  _isvalidateLocation = false;
                                  getPageLoadDetail("");
                                  setState(() {

                                  });
                                },
                              ),
                            ),

                            // start api responcer
                            BlocListener<PalletStackCubit, PalletStackState>(
                              listener: (context, state) async {

                                if (state is PalletStackInitialState) {
                                }
                                else if (state is PalletStackLoadingState) {
                                  // showing loading dialog in this state
                                  DialogUtils.showLoadingDialog(context, message: lableModel.loading);
                                }
                                else if (state is PalletStackDefaultPageLoadSuccessState){
                                  DialogUtils.hideLoadingDialog(context);
                                  if(state.palletStackDefaultPageLoadModel.status == "E"){
                                    Vibration.vibrate(duration: 500);
                                    SnackbarUtil.showSnackbar(
                                        context,
                                        state.palletStackDefaultPageLoadModel.statusMessage!,
                                        MyColor.colorRed,
                                        icon: FontAwesomeIcons.times);
                                  }else{

                                    requiredLocation = state.palletStackDefaultPageLoadModel.isPalletStackLocationRequired!;
                                    getPageLoadDetail("");
                                    setState(() {

                                    });
                                  }

                                }
                                else if (state is PalletStackDefaultPageLoadFailureState){
                                  DialogUtils.hideLoadingDialog(context);
                                  Vibration.vibrate(duration: 500);
                                  SnackbarUtil.showSnackbar(
                                      context,
                                      state.error,
                                      MyColor.colorRed,
                                      icon: FontAwesomeIcons.times);
                                }
                                else if (state is PalletStackStatePageLoadSuccessState){
                                  DialogUtils.hideLoadingDialog(context);

                                  if(state.palletStackPageLoadModel.status == "E"){
                                    Vibration.vibrate(duration: 500);
                                    SnackbarUtil.showSnackbar(
                                        context,
                                        state.palletStackPageLoadModel.statusMessage!,
                                        MyColor.colorRed,
                                        icon: FontAwesomeIcons.times);
                                  }else{
                                    palletStackPageLoadModel = state.palletStackPageLoadModel;
                                    setState(() {

                                    });
                                  }
                                }
                                else if (state is PalletStackStatePageLoadFailureState){
                                  DialogUtils.hideLoadingDialog(context);
                                  Vibration.vibrate(duration: 500);
                                  SnackbarUtil.showSnackbar(
                                      context,
                                      state.error,
                                      MyColor.colorRed,
                                      icon: FontAwesomeIcons.times);
                                }
                                else if (state is ValidateLocationSuccessState) {
                                  DialogUtils.hideLoadingDialog(context);
                                  if (state.validateLocationModel.status == "E") {
                                    setState(() {
                                      _isvalidateLocation = false;
                                    });
                                    Vibration.vibrate(duration: 500);
                                    SnackbarUtil.showSnackbar(
                                        context,
                                        state.validateLocationModel.statusMessage!,
                                        MyColor.colorRed,
                                        icon: FontAwesomeIcons.times);

                                    WidgetsBinding.instance.addPostFrameCallback((_) {
                                      FocusScope.of(context).requestFocus(locationFocusNode);
                                    },
                                    );
                                  } else {
                                    // DialogUtils.hideLoadingDialog(context);
                                    _isvalidateLocation = true;
                                    setState(() {});
                                    WidgetsBinding.instance.addPostFrameCallback((_) {
                                      FocusScope.of(context).requestFocus(igmNoFocusNode);
                                    },
                                    );
                                  }
                                }
                                else if (state is ValidateLocationFailureState) {
                                  // validate location failure
                                  DialogUtils.hideLoadingDialog(context);
                                  _isvalidateLocation = false;
                                  Vibration.vibrate(duration: 500);
                                  SnackbarUtil.showSnackbar(
                                      context, state.error, MyColor.colorRed, icon: FontAwesomeIcons.times);
                                }
                                else if (state is PalletStackULDConditionCodeSuccessState){
                                  DialogUtils.hideLoadingDialog(context);
                                  if(state.palletStackULDConditionCodeModel.status == "E"){
                                    Vibration.vibrate(duration: 500);
                                    SnackbarUtil.showSnackbar(
                                        context,
                                        state.palletStackULDConditionCodeModel.statusMessage!,
                                        MyColor.colorRed,
                                        icon: FontAwesomeIcons.times);
                                  }else{

                                    List<ULDConditionCodeList> uldConditionCodeList = state.palletStackULDConditionCodeModel.uLDConditionCodeList!;

                                    var result = await DialogUtils.showULDConditionCodeDialog(context, uldSeqNo, lableModel, textDirection, _user!.userProfile!.userIdentity!, _splashDefaultData!.companyCode!, widget.menuId, "ULD Condition code", uldNo, uldConditionCodeList);
                                    if (result != null) {
                                      if (result.containsKey('status')) {
                                        String? status = result['status'];

                                        if(status == "N"){
                                          _resumeTimerOnInteraction();
                                        }else if(status == "D"){
                                          _resumeTimerOnInteraction();
                                          getPageLoadDetail(igmNoEditingController.text);
                                        }
                                      }else{
                                        _resumeTimerOnInteraction();
                                      }
                                    }
                                    else{
                                      _resumeTimerOnInteraction();
                                    }

                                  }
                                }
                                else if (state is PalletStackULDConditionCodeFailureState){
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
                                                  Directionality(
                                                    textDirection: textDirection,
                                                    child: Row(
                                                      children: [
                                                        // add location in text
                                                        Expanded(
                                                          flex: 1,
                                                          child: CustomeEditTextWithBorder(
                                                            lablekey: "LOCATION",
                                                            textDirection: textDirection,
                                                            controller: locationController,
                                                            focusNode: locationFocusNode,
                                                            hasIcon: false,
                                                            hastextcolor: true,
                                                            animatedLabel: true,
                                                            needOutlineBorder: true,
                                                            labelText: (requiredLocation == "Y") ? "${lableModel.location} * ": "${lableModel.location}",
                                                            readOnly: false,
                                                            maxLength: 15,
                                                            isShowSuffixIcon: _isvalidateLocation,
                                                            onChanged: (value, validate) {

                                                              setState(() {
                                                                _isvalidateLocation = false;
                                                              });
                                                              if (value.toString().isEmpty) {
                                                                _isvalidateLocation = false;
                                                              }
                                                            },
                                                            fillColor: Colors.grey.shade100,
                                                            textInputType: TextInputType.text,
                                                            inputAction: TextInputAction.next,
                                                            hintTextcolor: MyColor.colorBlack,
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
                                                          focusNode: locationBtnFocusNode,
                                                          onTap: () {
                                                            scanLocationQR();

                                                          },
                                                          child: Padding(padding: const EdgeInsets.all(8.0),
                                                            child: SvgPicture.asset(search, height: SizeConfig.blockSizeVertical * SizeUtils.ICONSIZE3,),
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: SizeConfig.blockSizeVertical * SizeUtils.HEIGHT_1_5,
                                                  ),
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Expanded(
                                                        flex: 1,
                                                        child: CustomTextField(
                                                          textDirection: textDirection,
                                                          hasIcon: false,
                                                          hastextcolor: true,
                                                          animatedLabel: true,
                                                          needOutlineBorder: true,
                                                          labelText: "${lableModel.scanbasepallet}",
                                                          readOnly:false,
                                                          controller: igmNoEditingController,
                                                          focusNode: igmNoFocusNode,
                                                          maxLength: 30,
                                                          onChanged: (value) {

                                                            if(value == ""){
                                                              getPageLoadDetail("");
                                                            }

                                                         //   airSideReleaseSearchModel = null;
                                                            setState(() {});
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
                                                      InkWell(
                                                        onTap: () {
                                                          FocusScope.of(context).unfocus();

                                                          if(palletStackPageLoadModel != null){
                                                            scanQR();
                                                          }
                                                          else{
                                                            igmNoEditingController.clear();
                                                            palletStackPageLoadModel = null;
                                                            scanQR();
                                                          }

                                                        },
                                                        child: Padding(padding: const EdgeInsets.all(8.0),
                                                          child: SvgPicture.asset(search, height: SizeConfig.blockSizeVertical * SizeUtils.ICONSIZE3,),
                                                        ),
                                                      ),
                                                    ],
                                                  ),

                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: SizeConfig.blockSizeVertical,),

                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 10,
                                            right: 10,
                                            top: 0,
                                            bottom: 0),
                                        child: Container(
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
                                          child: (palletStackPageLoadModel != null)
                                              ? (palletStackPageLoadModel!.palletStackDetail == null) ? Center(
                                            child: Padding(
                                              padding: const EdgeInsets.symmetric(vertical: 20),
                                              child: CustomeText(
                                                  text: "${lableModel.recordNotFound}",
                                                  // if record not found
                                                  fontColor: MyColor.textColorGrey,
                                                  fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_2_0,
                                                  fontWeight: FontWeight.w500,
                                                  textAlign: TextAlign.center),
                                            ),
                                          )  : (palletStackPageLoadModel!.palletStackDetail!.isNotEmpty)
                                              ? ListView.builder(
                                            itemCount: palletStackPageLoadModel!.palletStackDetail!.length,
                                            physics: const NeverScrollableScrollPhysics(),
                                            shrinkWrap: true,
                                            controller: scrollController,
                                            itemBuilder: (context, index) {
                                              PalletStackDetail palletStackDetail = palletStackPageLoadModel!.palletStackDetail![index];

                                              return Directionality(
                                                textDirection: textDirection,
                                                child: InkWell(
                                                  // focusNode: uldListFocusNode,
                                                  onTap: () {


                                                  },
                                                  onDoubleTap: () async {


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
                                                    child: DottedBorder(
                                                      dashPattern: const [7, 7, 7, 7],
                                                      strokeWidth: 1,
                                                      borderType: BorderType.RRect,
                                                      color: Colors.transparent,
                                                      radius: const Radius.circular(8),
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
                                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                                  children: [
                                                                    Expanded(
                                                                        flex:4,
                                                                        child: Row(
                                                                          children: [
                                                                            SvgPicture.asset(palletsSvg, height: SizeConfig.blockSizeVertical * SizeUtils.TEXTSIZE_2_5,),
                                                                            SizedBox(width: 8,),
                                                                            CustomeText(text: "${palletStackDetail.uLDNo}", fontColor: MyColor.colorBlack, fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_6_5, fontWeight: FontWeight.w600, textAlign: TextAlign.start),
                                                                          ],
                                                                        )),
                                                                    Expanded(
                                                                      flex: 1,
                                                                      child: RoundedButtonBlue(text: "${lableModel.next}",
                                                                        textSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_6,
                                                                        verticalPadding: SizeConfig.blockSizeVertical * SizeUtils.TEXTSIZE_0_9,
                                                                        press: () async {

                                                                          if(requiredLocation == "Y"){
                                                                            if(locationController.text.isNotEmpty){
                                                                              if(_isvalidateLocation == true){
                                                                                String result = await Navigator.push(context, CupertinoPageRoute(builder: (context) => AddPalletStatckPage(
                                                                                    importSubMenuList: widget.importSubMenuList,
                                                                                    exportSubMenuList: widget.exportSubMenuList,
                                                                                    title: widget.title,
                                                                                    flightDepartureStatus: palletStackDetail.isFlightDeparted!,
                                                                                    locationCode: locationController.text,
                                                                                    refrelCode: widget.refrelCode,
                                                                                    uldSeqNo: palletStackDetail.uLDSeqNo!,
                                                                                    uldNo: palletStackDetail.uLDNo!,
                                                                                    menuId: widget.menuId,
                                                                                    uldStatus: palletStackDetail.uLDStatus!,
                                                                                    mainMenuName: widget.mainMenuName,
                                                                                    lableModel: lableModel,
                                                                                ),));
                                                                                if(result == "Done"){
                                                                                  getPageLoadDetail(igmNoEditingController.text);
                                                                                  _resumeTimerOnInteraction();
                                                                                }
                                                                                else{
                                                                                  getPageLoadDetail(igmNoEditingController.text);
                                                                                  _resumeTimerOnInteraction();
                                                                                }
                                                                              }else{
                                                                                openValidationDialog(lableModel.validateLocation!, locationFocusNode);
                                                                              }
                                                                            }else{
                                                                              openValidationDialog(lableModel.enterLocationMsg!, locationFocusNode);
                                                                            }

                                                                          }else{
                                                                            String result = await Navigator.push(context, CupertinoPageRoute(builder: (context) => AddPalletStatckPage(
                                                                                importSubMenuList: widget.importSubMenuList,
                                                                                exportSubMenuList: widget.exportSubMenuList,
                                                                                title: widget.title,
                                                                                flightDepartureStatus: palletStackDetail.isFlightDeparted!,
                                                                                refrelCode: widget.refrelCode,
                                                                                uldSeqNo: palletStackDetail.uLDSeqNo!,
                                                                                uldNo: palletStackDetail.uLDNo!,
                                                                                menuId: widget.menuId,
                                                                                uldStatus: palletStackDetail.uLDStatus!,
                                                                                mainMenuName: widget.mainMenuName,
                                                                                locationCode: locationController.text,
                                                                                lableModel: lableModel,
                                                                            ),));
                                                                            if(result == "Done"){
                                                                              getPageLoadDetail(igmNoEditingController.text);
                                                                              _resumeTimerOnInteraction();
                                                                            }
                                                                            else{
                                                                              getPageLoadDetail(igmNoEditingController.text);
                                                                              _resumeTimerOnInteraction();
                                                                            }
                                                                          }


                                                                        },
                                                                      ),
                                                                    )

                                                                  ],
                                                                ),
                                                                SizedBox(height: SizeConfig.blockSizeVertical,),
                                                                Row(
                                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                  children: [
                                                                    Row(
                                                                      children: [
                                                                        CustomeText(
                                                                          text: "${lableModel.stacksize} : ",
                                                                          fontColor: MyColor.textColorGrey2,
                                                                          fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_6,
                                                                          fontWeight: FontWeight.w500,
                                                                          textAlign: TextAlign.start,
                                                                        ),
                                                                        const SizedBox(width: 5),
                                                                        CustomeText(
                                                                          text: "${palletStackDetail.palletSize}",
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
                                                                          text: "${lableModel.scaleweight} : ",
                                                                          fontColor: MyColor.textColorGrey2,
                                                                          fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_6,
                                                                          fontWeight: FontWeight.w500,
                                                                          textAlign: TextAlign.start,
                                                                        ),
                                                                        const SizedBox(width: 5),
                                                                        CustomeText(
                                                                          text: CommonUtils.formateToTwoDecimalPlacesValue(palletStackDetail.scaleWeight!),
                                                                          fontColor: MyColor.colorBlack,
                                                                          fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_6,
                                                                          fontWeight: FontWeight.w600,
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
                                                                        SvgPicture.asset(map, height: SizeConfig.blockSizeVertical * SizeUtils.ICONSIZE2,),
                                                                        SizedBox(width: SizeConfig.blockSizeHorizontal,),
                                                                        CustomeText(
                                                                          text: (palletStackDetail.uLDLocation == "") ? "-" : "${palletStackDetail.uLDLocation}",
                                                                          fontColor: MyColor.colorBlack,
                                                                          fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_6,
                                                                          fontWeight: FontWeight.w600,
                                                                          textAlign: TextAlign.start,
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    Row(
                                                                      children: [
                                                                        SvgPicture.asset(arrival, height: SizeConfig.blockSizeVertical * SizeUtils.ICONSIZE2,),
                                                                        SizedBox(width: SizeConfig.blockSizeHorizontal,),
                                                                        CustomeText(
                                                                          text: (palletStackDetail.uLDDestination == "") ? "-" : "${palletStackDetail.uLDDestination}",
                                                                          fontColor: MyColor.colorBlack,
                                                                          fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_6,
                                                                          fontWeight: FontWeight.w600,
                                                                          textAlign: TextAlign.start,
                                                                        ),
                                                                      ],
                                                                    ),

                                                                  ],
                                                                ),
                                                                SizedBox(height: SizeConfig.blockSizeVertical,),
                                                                Row(
                                                                  children: [
                                                                    CustomeText(
                                                                      text: "${lableModel.uldCondition} : ",
                                                                      fontColor: MyColor.textColorGrey2,
                                                                      fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                                                      fontWeight: FontWeight.w500,
                                                                      textAlign: TextAlign.start,
                                                                    ),
                                                                    const SizedBox(width: 5),
                                                                    CustomeText(
                                                                      text: (palletStackDetail.uldConditionCode!.isEmpty) ? "-" : "${palletStackDetail.uldConditionCode}",
                                                                      fontColor: MyColor.colorBlack,
                                                                      fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_6,
                                                                      fontWeight: FontWeight.w600,
                                                                      textAlign: TextAlign.start,
                                                                    ),
                                                                    const SizedBox(width: 10),
                                                                    Container(
                                                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                                                      decoration: BoxDecoration(
                                                                          color: MyColor.dropdownColor,
                                                                          borderRadius: BorderRadius.circular(SizeConfig.blockSizeHorizontal * SizeUtils.WIDTH2)
                                                                      ),
                                                                      child: InkWell(
                                                                        child: Row(
                                                                          mainAxisSize: MainAxisSize.min,
                                                                          children: [
                                                                            SvgPicture.asset(pen, height: SizeConfig.blockSizeVertical * SizeUtils.HEIGHT2,)
                                                                          ],
                                                                        ),
                                                                        onTap: () async {
                                                                          uldSeqNo = palletStackDetail.uLDSeqNo!;
                                                                          uldNo = palletStackDetail.uLDNo!;
                                                                          getULDConditionCodeList();
                                                                        },
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                                SizedBox(height: SizeConfig.blockSizeVertical,),
                                                                Row(
                                                                  children: [

                                                                    Expanded(
                                                                      flex:4,
                                                                      child: RoundedButtonBlue(text: (palletStackDetail.flightNo!.isEmpty) ? "${lableModel.assignFlight}" : "${palletStackDetail.flightAirline} ${palletStackDetail.flightNo}  ${palletStackDetail.flightDate!.replaceAll(" ", "-")}" /*"Assign flight"*/,
                                                                        textSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_7,
                                                                        verticalPadding: SizeConfig.blockSizeVertical * 0.7,
                                                                        press: () async {

                                                                        if(palletStackDetail.flightNo!.isEmpty){
                                                                          var result = await DialogUtils.showAssignFlightDialog(context, palletStackDetail.uLDSeqNo!, lableModel, textDirection, _user!.userProfile!.userIdentity!, _splashDefaultData!.companyCode!, widget.menuId, "Assign flight", "", "", palletStackDetail.uLDNo!);
                                                                          if (result != null) {
                                                                            if (result.containsKey('status')) {
                                                                              String? status = result['status'];

                                                                              if(status == "N"){
                                                                                _resumeTimerOnInteraction();
                                                                              }else if(status == "D"){
                                                                                _resumeTimerOnInteraction();
                                                                                getPageLoadDetail(igmNoEditingController.text);
                                                                              }
                                                                            }else{
                                                                              _resumeTimerOnInteraction();
                                                                            }
                                                                          }
                                                                          else{
                                                                            _resumeTimerOnInteraction();
                                                                          }
                                                                        }else{

                                                                        }



                                                                        },),
                                                                    ),

                                                                    SizedBox(width: SizeConfig.blockSizeHorizontal * 12,),
                                                                    Expanded(
                                                                      flex:2,
                                                                      child: Container(
                                                                        padding : EdgeInsets.symmetric(horizontal: SizeConfig.blockSizeHorizontal * 2.0, vertical: SizeConfig.blockSizeVertical * 0.5),
                                                                        decoration : BoxDecoration(
                                                                            borderRadius: BorderRadius.circular(20),
                                                                            color: (palletStackDetail.uLDStatus == "O") ? MyColor.flightFinalize : MyColor.flightNotArrived
                                                                        ),
                                                                        child: CustomeText(
                                                                          text: (palletStackDetail.uLDStatus == "O") ? "${lableModel.open}" : "${lableModel.closed}",
                                                                          fontColor: MyColor.textColorGrey3,
                                                                          fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_6,
                                                                          fontWeight: FontWeight.bold,
                                                                          textAlign: TextAlign.center,
                                                                        ),
                                                                      ),
                                                                    ),



                                                                    /*Expanded(
                                                                      flex: 4,
                                                                      child: Row(
                                                                        children: [
                                                                          CustomeText(
                                                                            text: "Flight : ",
                                                                            fontColor: MyColor.textColorGrey2,
                                                                            fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                                                            fontWeight: FontWeight.w500,
                                                                            textAlign: TextAlign.start,
                                                                          ),

                                                                          CustomeText(
                                                                            text: "${palletStackDetail.flightAirline} ${palletStackDetail.flightNo} / ${palletStackDetail.flightDate!.replaceAll(" ", "-")}",
                                                                            fontColor: MyColor.colorBlack,
                                                                            fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                                                            fontWeight: FontWeight.w600,
                                                                            textAlign: TextAlign.start,
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                    Expanded(
                                                                      flex: 2,
                                                                      child: RoundedButtonBlue(text:  "Next",
                                                                        textSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                                                        verticalPadding: SizeConfig.blockSizeVertical * SizeUtils.BUTTONVERTICALSIZE /SizeUtils.HEIGHT2,
                                                                        press: () {
                                                                          Navigator.push(context, CupertinoPageRoute(builder: (context) => AddPalletStatckPage(
                                                                              importSubMenuList: widget.importSubMenuList,
                                                                              exportSubMenuList: widget.exportSubMenuList,
                                                                              title: widget.title,
                                                                              refrelCode: widget.refrelCode,
                                                                              uldSeqNo: palletStackDetail.uLDSeqNo!,
                                                                              uldNo: palletStackDetail.uLDNo!,
                                                                              menuId: widget.menuId,
                                                                              uldStatus: palletStackDetail.uLDStatus!,
                                                                              mainMenuName: widget.mainMenuName),));
                                                                        },),
                                                                    )*/
                                                                  ],
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              );
                                            },
                                          )
                                              : Center(
                                            child: Padding(
                                              padding: const EdgeInsets.symmetric(vertical: 20),
                                              child: CustomeText(
                                                  text: "${lableModel.recordNotFound}",
                                                  // if record not found
                                                  fontColor: MyColor.textColorGrey,
                                                  fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_2_0,
                                                  fontWeight: FontWeight.w500,
                                                  textAlign: TextAlign.center),
                                            ),
                                          )
                                              : Center(
                                            child: Padding(
                                              padding: const EdgeInsets.symmetric(vertical: 20),
                                              child: CustomeText(
                                                  text: "${lableModel.recordNotFound}",
                                                  // if record not found
                                                  fontColor: MyColor.textColorGrey,
                                                  fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_2_0,
                                                  fontWeight: FontWeight.w500,
                                                  textAlign: TextAlign.center),
                                            ),
                                          )


                                         /* child: ListView.builder(
                                            itemCount: 5,
                                            physics: const NeverScrollableScrollPhysics(),
                                            shrinkWrap: true,
                                            controller: scrollController,
                                            itemBuilder: (context, index) {
                                              //PalletStackDetail palletStackDetail = palletStackPageLoadModel!.palletStackDetail![index];

                                              return InkWell(
                                                // focusNode: uldListFocusNode,
                                                onTap: () {


                                                },
                                                onDoubleTap: () async {


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
                                                  child: DottedBorder(
                                                    dashPattern: const [7, 7, 7, 7],
                                                    strokeWidth: 1,
                                                    borderType: BorderType.RRect,
                                                    color: Colors.transparent,
                                                    radius: const Radius.circular(8),
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
                                                                mainAxisAlignment: MainAxisAlignment.start,
                                                                children: [
                                                                  Expanded(
                                                                      flex:4,
                                                                      child: Row(
                                                                        children: [
                                                                          SvgPicture.asset(palletsSvg, height: SizeConfig.blockSizeVertical * SizeUtils.TEXTSIZE_2_5,),
                                                                          SizedBox(width: 8,),
                                                                          CustomeText(text: "PKC 12345 AJ", fontColor: MyColor.colorBlack, fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_6, fontWeight: FontWeight.w600, textAlign: TextAlign.start),
                                                                        ],
                                                                      )),
                                                                  Expanded(
                                                                    flex:1,
                                                                    child: Container(
                                                                      padding : EdgeInsets.symmetric(horizontal: SizeConfig.blockSizeHorizontal * 2.5, vertical: SizeConfig.blockSizeVertical * 0.2),
                                                                      decoration : BoxDecoration(
                                                                          borderRadius: BorderRadius.circular(20),
                                                                          color: MyColor.flightFinalize
                                                                      ),
                                                                      child: CustomeText(
                                                                        text: "Open",
                                                                        fontColor: MyColor.textColorGrey3,
                                                                        fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_35,
                                                                        fontWeight: FontWeight.w500,
                                                                        textAlign: TextAlign.center,
                                                                      ),
                                                                    ),
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
                                                                        text: "Stack size : ",
                                                                        fontColor: MyColor.textColorGrey2,
                                                                        fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                                                        fontWeight: FontWeight.w500,
                                                                        textAlign: TextAlign.start,
                                                                      ),
                                                                      const SizedBox(width: 5),
                                                                      CustomeText(
                                                                        text: "4",
                                                                        fontColor: MyColor.colorBlack,
                                                                        fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                                                        fontWeight: FontWeight.w600,
                                                                        textAlign: TextAlign.start,
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  Row(
                                                                    children: [
                                                                      CustomeText(
                                                                        text: "Scale weight : ",
                                                                        fontColor: MyColor.textColorGrey2,
                                                                        fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                                                        fontWeight: FontWeight.w500,
                                                                        textAlign: TextAlign.start,
                                                                      ),
                                                                      const SizedBox(width: 5),
                                                                      CustomeText(
                                                                        text: "500.00",
                                                                        fontColor: MyColor.colorBlack,
                                                                        fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                                                        fontWeight: FontWeight.w600,
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
                                                                        text: "Flight : ",
                                                                        fontColor: MyColor.textColorGrey2,
                                                                        fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                                                        fontWeight: FontWeight.w500,
                                                                        textAlign: TextAlign.start,
                                                                      ),
                                                                      const SizedBox(width: 5),
                                                                      CustomeText(
                                                                        text: "BA 199/25-Dec-24",
                                                                        fontColor: MyColor.colorBlack,
                                                                        fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                                                        fontWeight: FontWeight.w600,
                                                                        textAlign: TextAlign.start,
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  CustomeText(
                                                                    text: "BLR",
                                                                    fontColor: MyColor.colorBlack,
                                                                    fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                                                    fontWeight: FontWeight.w600,
                                                                    textAlign: TextAlign.start,
                                                                  ),
                                                                ],
                                                              ),
                                                              SizedBox(height: SizeConfig.blockSizeVertical,),
                                                              Row(
                                                                children: [
                                                                  Expanded(
                                                                    flex: 4,
                                                                    child: Row(
                                                                      children: [
                                                                        SvgPicture.asset(map, height: SizeConfig.blockSizeVertical * SizeUtils.ICONSIZE2,),
                                                                        SizedBox(width: SizeConfig.blockSizeHorizontal,),
                                                                        CustomeText(
                                                                          text: "SKT001",
                                                                          fontColor: MyColor.colorBlack,
                                                                          fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                                                          fontWeight: FontWeight.w600,
                                                                          textAlign: TextAlign.start,
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  Expanded(
                                                                    flex: 2,
                                                                    child: RoundedButtonBlue(text:  "Next",
                                                                      textSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                                                      verticalPadding: SizeConfig.blockSizeVertical * SizeUtils.BUTTONVERTICALSIZE /SizeUtils.HEIGHT2,
                                                                      press: () {
                                                                          Navigator.push(context, CupertinoPageRoute(builder: (context) => AddPalletStatckPage(importSubMenuList: widget.importSubMenuList, exportSubMenuList: widget.exportSubMenuList, title: widget.title, refrelCode: widget.refrelCode, uldSeqNo: 12345, uldNo: "PKC 12345 AJ", menuId: widget.menuId, mainMenuName: widget.mainMenuName),));
                                                                      },),
                                                                  )
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              );
                                            },
                                          ),*/

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


  Future<void> scanLocationQR() async{
    String locationcodeScanResult =  await FlutterBarcodeScanner.scanBarcode(
      '#ff6666', // Color for the scanner overlay
      'Cancel', // Text for the cancel button
      true, // Enable flash option
      ScanMode.DEFAULT, // Scan mode
    );

    if(locationcodeScanResult == "-1"){

    }else{
      bool specialCharAllow = CommonUtils.containsSpecialCharacters(locationcodeScanResult);

      if(specialCharAllow == true){
        SnackbarUtil.showSnackbar(context, widget.lableModel!.onlyAlphaNumericValueMsg!, MyColor.colorRed, icon: FontAwesomeIcons.times);
        Vibration.vibrate(duration: 500);
        locationController.clear();
        igmNoEditingController.clear();

       // airSideReleaseSearchModel = null;

        WidgetsBinding.instance.addPostFrameCallback((_) {
          FocusScope.of(context).requestFocus(locationFocusNode);
        });
      }else{

        String result = locationcodeScanResult.replaceAll(" ", "");

        String truncatedResult = result.length > 15
            ? result.substring(0, 15)
            : result;

        locationController.text = truncatedResult;
        // Call searchLocation api to validate or not
        context.read<PalletStackCubit>().getValidateLocation(
            truncatedResult,
            _user!.userProfile!.userIdentity!,
            _splashDefaultData!.companyCode!,
            widget.menuId, "a");
      }

    }


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
        SnackbarUtil.showSnackbar(context, "${widget.lableModel!.onlyNumericValueMsg}", MyColor.colorRed, icon: FontAwesomeIcons.times);
        Vibration.vibrate(duration: 500);

     //   airSideReleaseSearchModel = null;
        igmNoEditingController.clear();

        WidgetsBinding.instance.addPostFrameCallback((_) {
          FocusScope.of(context).requestFocus(igmNoFocusNode);
        });
      }else{



        String result = barcodeScanResult.replaceAll(" ", "");

       /* String truncatedResult = result.length > 15
            ? result.substring(0, 15)
            : result;*/

        igmNoEditingController.text = result;

        getPageLoadDetail(igmNoEditingController.text);

        // getAirsideReleaseDetail(context, locationController.text, igmNoEditingController.text, _user!.userProfile!.userIdentity!, _splashDefaultData!.companyCode!, widget.menuId);
      }
    }
  }

  //
  void getPageLoadDetail(String scan) {

    print("scan ==== ${scan}");

    if(scan.contains("")){
      context.read<PalletStackCubit>().getPageLoad(scan, _user!.userProfile!.userIdentity!, _splashDefaultData!.companyCode!, widget.menuId,);
    }else{
      String uldNumber = UldValidationUtil.validateUldNumberwithSpace1(scan.toUpperCase());


      context.read<PalletStackCubit>().getPageLoad(uldNumber, _user!.userProfile!.userIdentity!, _splashDefaultData!.companyCode!, widget.menuId,);
    }


  }

  void getDefaultPageLoadDetail() {
    context.read<PalletStackCubit>().getDefaultPageLoad(_user!.userProfile!.userIdentity!, _splashDefaultData!.companyCode!, widget.menuId,);
  }

  void getULDConditionCodeList() {
    context.read<PalletStackCubit>().getPalletULDConditionCode(_user!.userProfile!.userIdentity!, _splashDefaultData!.companyCode!, widget.menuId,);
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



}

