import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:galaxy/core/mycolor.dart';
import 'package:galaxy/module/export/services/palletstack/palletstacklogic/palletstackcubit.dart';
import 'package:galaxy/module/export/services/palletstack/palletstacklogic/palletstackstate.dart';
import 'package:galaxy/utils/sizeutils.dart';
import 'package:galaxy/widget/customebuttons/roundbuttongreen.dart';
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
import '../../model/palletstock/palletstacklistmodel.dart';
import '../../model/palletstock/palletstackpageloadmodel.dart';
import '../../model/palletstock/palletstackuldconditioncodemodel.dart';

class AddPalletStatckPage extends StatefulWidget {
  String mainMenuName;
  String title;
  String refrelCode;
  LableModel? lableModel;
  int menuId;
  List<SubMenuName> importSubMenuList = [];
  List<SubMenuName> exportSubMenuList = [];
  int uldSeqNo;
  String uldNo;
  String uldStatus;
  String flightDepartureStatus;
  String locationCode;


  AddPalletStatckPage(
      {super.key,
      required this.importSubMenuList,
      required this.exportSubMenuList,
      required this.title,
      required this.refrelCode,
      this.lableModel,
      required this.uldSeqNo,
      required this.uldNo,
      required this.uldStatus,
      required this.menuId,
      required this.mainMenuName,
      required this.flightDepartureStatus,
      required this.locationCode});

  @override
  State<AddPalletStatckPage> createState() => _AddPalletStatckPageState();
}

class _AddPalletStatckPageState extends State<AddPalletStatckPage>
    with SingleTickerProviderStateMixin {

  String status = "";
  String statusMessage = "";

  PalletStackListModel? palletStackListModel;
  List<PalletDetailList> filterPalletDetailList = [];


  InactivityTimerManager? inactivityTimerManager;
  final SavedPrefrence savedPrefrence = SavedPrefrence();
  UserDataModel? _user;
  SplashDefaultModel? _splashDefaultData;
  final ScrollController scrollController = ScrollController();



  TextEditingController scanNoEditingController = TextEditingController();



  FocusNode scanNoFocusNode = FocusNode();
  FocusNode scanBtnFocusNode = FocusNode();

  bool _suffixIconUld = false;
  bool _uldNotExit = false;
  bool _isvalidULDNo = false;

  int uldSeqNo = 0;
  String uldNo = "";

  @override
  void initState() {
    super.initState();
    _loadUser(); //load user data




    scanNoFocusNode.addListener(() {
      if(!scanNoFocusNode.hasFocus){
        if(scanNoEditingController.text.isNotEmpty){
          //getPageLoadDetail(scanNoEditingController.text);
        }else{

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
    scanNoEditingController.dispose();
    scanNoFocusNode.dispose();
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

      getPalletListDetail(widget.uldSeqNo);

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


    if(status != "C"){

      bool? exitConfirmed = await DialogUtils.showPalletCompleteDialog(context, widget.uldNo, widget.lableModel!);
      if (exitConfirmed == true) {

        // Call complete close pallet
        context.read<PalletStackCubit>().reopenClosePalletStack(uldSeqNo, "C", _user!.userProfile!.userIdentity!, _splashDefaultData!.companyCode!, widget.menuId,);
      }
      else {
        FocusScope.of(context).unfocus();
        scanNoEditingController.clear();
        Navigator.pop(context, "Done");
      }


    }
    else{
      FocusScope.of(context).unfocus();

      scanNoEditingController.clear();
      Navigator.pop(context, "Done");
    }






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
                                title: "${lableModel!.addPallet}",
                                onBack: _onWillPop,
                                clearText: lableModel!.clear,
                                //add clear text to clear all feild
                                onClear: () {
                                  scanNoEditingController.clear();
                                  updateSearchList("");
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
                                else if (state is PalletStackListSuccessState){
                                  DialogUtils.hideLoadingDialog(context);
                                  if(state.palletStackListModel.status == "E"){
                                    Vibration.vibrate(duration: 500);
                                    SnackbarUtil.showSnackbar(
                                        context,
                                        state.palletStackListModel.statusMessage!,
                                        MyColor.colorRed,
                                        icon: FontAwesomeIcons.times);
                                  }
                                 /* else if(state.palletStackListModel.status == "C"){



                                  }*/
                                  else{
                                    status = state.palletStackListModel.status!;
                                    statusMessage = state.palletStackListModel.statusMessage!;
                                    palletStackListModel =  state.palletStackListModel;
                                    filterPalletDetailList = List.from(palletStackListModel!.palletDetailList!);
                                    setState(() {

                                    });
                                  }
                                }
                                else if (state is PalletStackListFailureState){
                                  Vibration.vibrate(duration: 500);
                                  SnackbarUtil.showSnackbar(
                                      context,
                                      state.error,
                                      MyColor.colorRed,
                                      icon: FontAwesomeIcons.times);
                                }
                                else if (state is PalletStackULDConditionCodeASuccessState){
                                  DialogUtils.hideLoadingDialog(context);
                                  if(state.palletStackULDConditionCodeModel.status == "E"){
                                    Vibration.vibrate(duration: 500);
                                    SnackbarUtil.showSnackbar(
                                        context,
                                        state.palletStackULDConditionCodeModel.statusMessage!,
                                        MyColor.colorRed,
                                        icon: FontAwesomeIcons.times);
                                  }
                                  else{

                                    List<ULDConditionCodeList> uldConditionCodeList = state.palletStackULDConditionCodeModel.uLDConditionCodeList!;

                                    var result = await DialogUtils.showULDConditionCodeDialog(context, uldSeqNo, lableModel, textDirection, _user!.userProfile!.userIdentity!, _splashDefaultData!.companyCode!, widget.menuId, "${lableModel.uldConditioncode}", uldNo, uldConditionCodeList);
                                    if (result != null) {
                                      if (result.containsKey('status')) {
                                        String? status = result['status'];

                                        if(status == "N"){
                                          _resumeTimerOnInteraction();
                                        }else if(status == "D"){
                                          _resumeTimerOnInteraction();
                                          getPalletListDetail(widget.uldSeqNo);
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
                                else if (state is PalletStackULDConditionCodeAFailureState){
                                  DialogUtils.hideLoadingDialog(context);
                                  Vibration.vibrate(duration: 500);
                                  SnackbarUtil.showSnackbar(
                                      context,
                                      state.error,
                                      MyColor.colorRed,
                                      icon: FontAwesomeIcons.times);
                                }
                                else if (state is AddPalletStackSuccessState){
                                  DialogUtils.hideLoadingDialog(context);
                                  if(state.removePalletStackModel.status == "E"){
                                    Vibration.vibrate(duration: 500);
                                    SnackbarUtil.showSnackbar(
                                        context,
                                        state.removePalletStackModel.statusMessage!,
                                        MyColor.colorRed,
                                        icon: FontAwesomeIcons.times);
                                  }
                                  else{
                                    scanNoEditingController.clear();
                                    SnackbarUtil.showSnackbar(
                                        context,
                                        state.removePalletStackModel.statusMessage!,
                                        MyColor.colorGreen,
                                        icon: Icons.done);
                                    getPalletListDetail(widget.uldSeqNo);
                                  }
                                }
                                else if (state is AddPalletStackFailureState){
                                  DialogUtils.hideLoadingDialog(context);
                                  Vibration.vibrate(duration: 500);
                                  SnackbarUtil.showSnackbar(
                                      context,
                                      state.error,
                                      MyColor.colorRed,
                                      icon: FontAwesomeIcons.times);
                                }
                                else if (state is RemovePalletStackSuccessState){
                                  DialogUtils.hideLoadingDialog(context);
                                  if(state.removePalletStackModel.status == "E"){
                                    Vibration.vibrate(duration: 500);
                                    SnackbarUtil.showSnackbar(
                                        context,
                                        state.removePalletStackModel.statusMessage!,
                                        MyColor.colorRed,
                                        icon: FontAwesomeIcons.times);
                                  }
                                  else{
                                    SnackbarUtil.showSnackbar(
                                        context,
                                        state.removePalletStackModel.statusMessage!,
                                        MyColor.colorGreen,
                                        icon: Icons.done);
                                    getPalletListDetail(widget.uldSeqNo);
                                  }
                                }
                                else if (state is RemovePalletStackFailureState){
                                  DialogUtils.hideLoadingDialog(context);
                                  Vibration.vibrate(duration: 500);
                                  SnackbarUtil.showSnackbar(
                                      context,
                                      state.error,
                                      MyColor.colorRed,
                                      icon: FontAwesomeIcons.times);
                                }
                                else if (state is ReopenClosePalletStackSuccessState){
                                  DialogUtils.hideLoadingDialog(context);
                                  if(state.reopenClosePalletStackModel.status == "E"){
                                    Vibration.vibrate(duration: 500);
                                    SnackbarUtil.showSnackbar(context, state.reopenClosePalletStackModel.statusMessage!, MyColor.colorRed, icon: FontAwesomeIcons.times);

                                  }else{

                                    SnackbarUtil.showSnackbar(context, state.reopenClosePalletStackModel.statusMessage!, MyColor.colorGreen, icon: Icons.done);
                                    Navigator.pop(context, "Done");
                                  }
                                }
                                else if (state is ReopenClosePalletStackFailureState){
                                  Vibration.vibrate(duration: 500);
                                  SnackbarUtil.showSnackbar(context, state.error, MyColor.colorRed, icon: FontAwesomeIcons.times);
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
                                                  /*Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      CustomeText(text: "Base pallet ${widget.uldNo}", fontColor: MyColor.textColorGrey2, fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_4, fontWeight: FontWeight.w400, textAlign: TextAlign.start),
                                                      Container(
                                                        padding : EdgeInsets.symmetric(horizontal: SizeConfig.blockSizeHorizontal * 2.5, vertical: SizeConfig.blockSizeVertical * 0.2),
                                                        decoration : BoxDecoration(
                                                            borderRadius: BorderRadius.circular(20),
                                                            color: (widget.uldStatus == "O") ? MyColor.flightFinalize : MyColor.flightNotArrived
                                                        ),
                                                        child: CustomeText(
                                                          text: (widget.uldStatus == "O") ? "Open" : "Close",
                                                          fontColor: MyColor.textColorGrey3,
                                                          fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_35,
                                                          fontWeight: FontWeight.w500,
                                                          textAlign: TextAlign.center,
                                                        ),
                                                      )
                                                    ],
                                                  ),*/
                                                  SizedBox(height: SizeConfig.blockSizeVertical),
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Expanded(
                                                        flex: 1,
                                                        child: CustomTextField(
                                                          textDirection: textDirection,
                                                          controller: scanNoEditingController,
                                                          focusNode: scanNoFocusNode,
                                                          onPress: () {},
                                                          hasIcon: false,
                                                          hastextcolor: true,
                                                          animatedLabel: true,
                                                          needOutlineBorder: true,
                                                          labelText: "${lableModel.scan}",
                                                          readOnly: false,
                                                          maxLength: 14,
                                                          onChanged: (value) {
                                                            updateSearchList(value);
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
                                                        /*child: CustomeEditTextWithBorder(
                                                          lablekey: "ULD",
                                                          textDirection: textDirection,
                                                          controller: scanNoEditingController,
                                                          hasIcon: false,
                                                          hastextcolor: true,
                                                          isShowSuffixIcon: scanNoEditingController.text.isEmpty ? false : (_suffixIconUld) ? true : false,
                                                          animatedLabel: true,
                                                          needOutlineBorder: true,
                                                          labelText: "Scan pallet",
                                                          focusNode: scanNoFocusNode,
                                                          readOnly: false,
                                                          maxLength: 11,

                                                          onChanged: (value, validate) async {

                                                            _suffixIconUld = true;
                                                            _uldNotExit = false;
                                                            setState(() {
                                                              if (validate) {
                                                                _isvalidULDNo = true;


                                                              } else {
                                                                _isvalidULDNo = false;
                                                                WidgetsBinding.instance.addPostFrameCallback((_) {
                                                                  FocusScope.of(context).requestFocus(scanNoFocusNode);
                                                                });
                                                              }

                                                            });

                                                          },
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
                                                        ),*/
                                                      ),
                                                      SizedBox(
                                                        width: SizeConfig.blockSizeHorizontal,
                                                      ),
                                                      InkWell(
                                                        onTap: () {
                                                          FocusScope.of(context).unfocus();

                                                          if(palletStackListModel != null){
                                                            scanQR();
                                                          }
                                                          else{
                                                            scanNoEditingController.clear();
                                                            palletStackListModel = null;
                                                            scanQR();
                                                          }

                                                        },
                                                        child: Padding(padding: const EdgeInsets.all(8.0),
                                                          child: SvgPicture.asset(search, height: SizeConfig.blockSizeVertical * SizeUtils.ICONSIZE3,),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(height: SizeConfig.blockSizeVertical),
                                                  (widget.flightDepartureStatus == "N")
                                                      ? RoundedButtonBlue(
                                                    text: "${lableModel!.addPallet}",
                                                    press: () async {
                                                      if(status == "C"){
                                                        var result = await DialogUtils.showPalletCloseDialog(context, widget.uldSeqNo, lableModel, textDirection, _user!.userProfile!.userIdentity!, _splashDefaultData!.companyCode!, widget.menuId, "Closed pallet", "${widget.uldNo} $statusMessage",  uldNo);
                                                        if (result != null) {
                                                          if (result.containsKey('status')) {
                                                            String? status = result['status'];
                                                            if(status == "N"){
                                                              _resumeTimerOnInteraction();
                                                              // Navigator.pop(context);
                                                            }else if(status == "D"){
                                                              _resumeTimerOnInteraction();
                                                              getPalletListDetail(widget.uldSeqNo);
                                                            }else{
                                                              _resumeTimerOnInteraction();
                                                            }
                                                          }else{
                                                            _resumeTimerOnInteraction();
                                                          }
                                                        }
                                                        else{
                                                          _resumeTimerOnInteraction();
                                                        }
                                                      }
                                                      else{


                                                        // Add Pallate logic

                                                        addPalletStack(widget.uldSeqNo, scanNoEditingController.text, widget.locationCode);

                                                        /*String validationMessage = UldValidationUtil.validateUldNumberwithSpace1(scanNoEditingController.text);

                                                        if(validationMessage == "Valid"){
                                                          addPalletStack(widget.uldSeqNo, scanNoEditingController.text, widget.locationCode);
                                                        }else{

                                                          SnackbarUtil.showSnackbar(context, "Please enter valid ULD No.", MyColor.colorRed, icon: FontAwesomeIcons.times);
                                                          Vibration.vibrate(duration: 500);
                                                          WidgetsBinding.instance.addPostFrameCallback((_) {
                                                            FocusScope.of(context).requestFocus(scanNoFocusNode);
                                                          });


                                                        }*/

                                                      }


                                                    },
                                                  )
                                                      : SizedBox()
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: SizeConfig.blockSizeVertical,),

                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 14,
                                            right: 14,
                                            top: 0,
                                            bottom: 5),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            CustomeText(text: "${lableModel.basepallet} ${widget.uldNo}", fontColor: MyColor.textColorGrey2, fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_6, fontWeight: FontWeight.w700, textAlign: TextAlign.start),
                                            CustomeText(text: "${lableModel.stacksize} ${filterPalletDetailList.length + 1}", fontColor: MyColor.textColorGrey2, fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_6, fontWeight: FontWeight.w700, textAlign: TextAlign.start),

                                          ],
                                        ),
                                      ),


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


                                          child: (palletStackListModel != null)
                                              ? (filterPalletDetailList.isNotEmpty)
                                              ? ListView.builder(
                                            itemCount: filterPalletDetailList.length,
                                            physics: const NeverScrollableScrollPhysics(),
                                            shrinkWrap: true,
                                            controller: scrollController,
                                            itemBuilder: (context, index) {
                                              PalletDetailList palletDetailList = filterPalletDetailList[index];

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
                                                  child: Container(
                                                    padding: const EdgeInsets.all(8),
                                                    decoration: BoxDecoration(
                                                      color: MyColor.colorWhite,
                                                      borderRadius: BorderRadius.circular(8),
                                                    ),
                                                    child: Column(
                                                      children: [
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
                                                              text: (palletDetailList.uldConditionCode!.isEmpty) ? "-" : "${palletDetailList.uldConditionCode}",
                                                              fontColor: MyColor.colorBlack,
                                                              fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_6,
                                                              fontWeight: FontWeight.w600,
                                                              textAlign: TextAlign.start,
                                                            ),
                                                            const SizedBox(width: 10),
                                                            Container(
                                                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
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

                                                                  if(status == "C"){
                                                                    var result = await DialogUtils.showPalletCloseDialog(context, uldSeqNo, lableModel, textDirection, _user!.userProfile!.userIdentity!, _splashDefaultData!.companyCode!, widget.menuId, "Closed pallet", "${widget.uldNo} $statusMessage",  uldNo);
                                                                    if (result != null) {
                                                                      if (result.containsKey('status')) {
                                                                        String? status = result['status'];
                                                                        if(status == "N"){
                                                                          _resumeTimerOnInteraction();
                                                                          // Navigator.pop(context);
                                                                        }else if(status == "D"){
                                                                          _resumeTimerOnInteraction();
                                                                          getPalletListDetail(widget.uldSeqNo);
                                                                        }else{
                                                                          _resumeTimerOnInteraction();
                                                                        }
                                                                      }else{
                                                                        _resumeTimerOnInteraction();
                                                                      }
                                                                    }
                                                                    else{
                                                                      _resumeTimerOnInteraction();
                                                                    }
                                                                  }
                                                                  else{
                                                                    uldSeqNo = palletDetailList.uLDSeqNo!;
                                                                    uldNo = palletDetailList.uLDNo!;
                                                                    getULDConditionCodeList();
                                                                  }




                                                                },
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        Row(
                                                          children: [
                                                            Expanded(
                                                              flex: 5,
                                                              child: Padding(
                                                                padding: const EdgeInsets.symmetric(vertical: 8),
                                                                child: Row(
                                                                  children: [
                                                                    SvgPicture.asset(palletsSvg, height: SizeConfig.blockSizeVertical * SizeUtils.TEXTSIZE_2_5,),
                                                                    SizedBox(width: 8,),
                                                                    CustomeText(text: "${palletDetailList.uLDNo}", fontColor: MyColor.colorBlack, fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_6, fontWeight: FontWeight.w600, textAlign: TextAlign.start),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                            Expanded(
                                                              flex: 2,
                                                              child:(widget.flightDepartureStatus == "N") ? RoundedButtonGreen(text: "${lableModel.remove}",
                                                                color: MyColor.colorRed,
                                                                textSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_7,
                                                                verticalPadding: SizeConfig.blockSizeVertical * SizeUtils.HEIGHT_1_5,
                                                                press: () async {
                                                                  if(status == "C"){
                                                                    var result = await DialogUtils.showPalletCloseDialog(context, uldSeqNo, lableModel, textDirection, _user!.userProfile!.userIdentity!, _splashDefaultData!.companyCode!, widget.menuId, "Closed pallet", "${widget.uldNo} $statusMessage",  uldNo);
                                                                    // var result = await DialogUtils.showPalletCloseDialog(context, "Closed pallet", "${widget.uldNo} $statusMessage");
                                                                    if (result != null) {
                                                                      if (result.containsKey('status')) {
                                                                        String? status = result['status'];
                                                                        if(status == "N"){
                                                                          _resumeTimerOnInteraction();
                                                                        }else if(status == "D"){
                                                                          _resumeTimerOnInteraction();
                                                                          getPalletListDetail(widget.uldSeqNo);
                                                                        }else{
                                                                          _resumeTimerOnInteraction();
                                                                        }
                                                                      }else{
                                                                        _resumeTimerOnInteraction();
                                                                      }
                                                                    }
                                                                    else{
                                                                      _resumeTimerOnInteraction();
                                                                    }
                                                                  }
                                                                  else{
                                                                    // remove Pallate logic
                                                                    removePalletStack(palletDetailList.uLDSeqNo!);
                                                                  }
                                                                },) : SizedBox(),
                                                            )
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  )
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
        scanNoEditingController.clear();

        WidgetsBinding.instance.addPostFrameCallback((_) {
          FocusScope.of(context).requestFocus(scanNoFocusNode);
        });
      }else{



        String result = barcodeScanResult.replaceAll(" ", "");

       /* String truncatedResult = result.length > 15
            ? result.substring(0, 15)
            : result;*/

        scanNoEditingController.text = result;
        updateSearchList(result);
       // getPageLoadDetail(scanNoEditingController.text);

      }
    }
  }

  void updateSearchList(String searchString) {
    setState(() {
      filterPalletDetailList = _applyFiltersAndSorting(
          palletStackListModel!.palletDetailList!,
          searchString
      );
    });
  }

  //appliying filter for sorting
  List<PalletDetailList> _applyFiltersAndSorting(List<PalletDetailList> list, String searchString) {
    // Filter by search string
    List<PalletDetailList> filteredList = list.where((item) {
      return item.uLDNo!.replaceAll(" ", "").toLowerCase().contains(searchString.toLowerCase());
    }).toList();

    return filteredList;
  }


  //
  void getPalletListDetail(int uldSeqNo) {
    context.read<PalletStackCubit>().getPalletListLoad(uldSeqNo, _user!.userProfile!.userIdentity!, _splashDefaultData!.companyCode!, widget.menuId,);
  }

  void getULDConditionCodeList() {
    context.read<PalletStackCubit>().getPalletULDConditionCodeA(_user!.userProfile!.userIdentity!, _splashDefaultData!.companyCode!, widget.menuId,);
  }

  void addPalletStack(int uldSeqNo, String uldNo, String locationCode) {
    context.read<PalletStackCubit>().addPalletStack(uldSeqNo, uldNo, locationCode , _user!.userProfile!.userIdentity!, _splashDefaultData!.companyCode!, widget.menuId,);
  }

  void removePalletStack(int uldSeqNo) {
    context.read<PalletStackCubit>().removePalletStack(uldSeqNo, _user!.userProfile!.userIdentity!, _splashDefaultData!.companyCode!, widget.menuId,);
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

