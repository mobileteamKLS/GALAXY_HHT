import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:galaxy/module/discrypency/model/foundutt/getfounduttsearchmodel.dart';
import 'package:galaxy/module/discrypency/services/foundutt/founduttlogic/founduttcubit.dart';
import 'package:galaxy/module/discrypency/services/foundutt/founduttlogic/founduttstate.dart';
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
import '../../../../widget/customeedittext/customeedittextwithborder.dart';
import '../../../../widget/custometext.dart';
import '../../../../widget/customeuiwidgets/header.dart';
import '../../../../widget/customtextfield.dart';
import '../../../../widget/header/mainheadingwidget.dart';
import '../../../../widget/uldnumberwidget.dart';
import '../../../login/model/userlogindatamodel.dart';
import '../../../login/pages/signinscreenmethods.dart';
import '../../../onboarding/sizeconfig.dart';
import 'dart:ui' as ui;
import '../../../profile/page/profilepagescreen.dart';
import '../../../splash/model/splashdefaultmodel.dart';
import '../../../submenu/model/submenumodel.dart';


class FoundUTTRecordPage extends StatefulWidget {


  String mainMenuName;
  int menuId;
  LableModel lableModel;
  List<SubMenuName> importSubMenuList = [];
  List<SubMenuName> exportSubMenuList = [];
  String title;
  String refrelCode;
  String type;
  FoundUTTAWBDetailList? awbDetailsList;
  FoundUTTULDDetailList? uldDetailsList;
  int isGroupIdLength;
  String isRequiredGroupId;


  FoundUTTRecordPage({
    super.key,
    required this.importSubMenuList,
    required this.exportSubMenuList,
    required this.mainMenuName,
    required this.menuId,
    required this.lableModel,
    required this.title,
    required this.refrelCode,
    required this.type,
    required this.isGroupIdLength,
    required this.isRequiredGroupId,
    this.awbDetailsList,
    this.uldDetailsList
   });

  @override
  State<FoundUTTRecordPage> createState() => _FoundUTTRecordPageState();
}

class _FoundUTTRecordPageState extends State<FoundUTTRecordPage>{
  InactivityTimerManager? inactivityTimerManager;
  final SavedPrefrence savedPrefrence = SavedPrefrence();
  UserDataModel? _user;
  SplashDefaultModel? _splashDefaultData;



  final ScrollController scrollController = ScrollController();
  //FocusNode awbFocusNode = FocusNode();


  TextEditingController nopController = TextEditingController();
  TextEditingController weightController = TextEditingController();
  FocusNode nopFocusNode = FocusNode();
  FocusNode weightFocusNode = FocusNode();

  TextEditingController groupIdController = TextEditingController();
  FocusNode groupIdFocusNode = FocusNode();

  TextEditingController locationController = TextEditingController();
  FocusNode locationFocusNode = FocusNode();

  String isMergeIndicator = "N";

  double weightCount = 0.00;

  int totalNop = 0;
  double totalWt = 0.00;

  int differenceNop = 0;
  double differenceWeight = 0.00;

  bool isBackPressed = false;

  bool _isLocationSearchBtnEnable = false;
  bool _isvalidateLocation = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    if(widget.type == "A"){
      totalNop = int.parse("${widget.awbDetailsList!.nOP!}");
      totalWt = double.parse("${widget.awbDetailsList!.weightKg!}");

      nopController.text = totalNop.toString();
      weightController.text = totalWt.toStringAsFixed(2);
    }

    locationFocusNode.addListener(() {
      if (!locationFocusNode.hasFocus && !isBackPressed) {
        leaveLocationFocus();
      }
    });

    locationController.addListener(_validateLocationSearchBtn);

    _loadUser(); //load user data

  }

  Future<void> leaveLocationFocus() async {
    if (locationController.text.isNotEmpty) {
      if(_isvalidateLocation == false){
        //call location validation api
        await context.read<FoundUTTCubit>().getValidateLocation(
            locationController.text,
            _user!.userProfile!.userIdentity!,
            _splashDefaultData!.companyCode!,
            widget.menuId,
            "a");
      }else{

      }

    }else{
      //focus on location feild
/*      WidgetsBinding.instance.addPostFrameCallback((_) {
        FocusScope.of(context).requestFocus(locationBtnFocusNode);
      },
      );*/
    }
  }

  void _validateLocationSearchBtn() {
    setState(() {
      _isLocationSearchBtnEnable = locationController.text.isNotEmpty;
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

      if(widget.type == "A"){
        WidgetsBinding.instance.addPostFrameCallback((_) {
          FocusScope.of(context).requestFocus(nopFocusNode);
        });
      }else{
        WidgetsBinding.instance.addPostFrameCallback((_) {
          FocusScope.of(context).requestFocus(groupIdFocusNode);
        });
      }


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

                                  if(widget.type == "A"){
                                    totalNop = int.parse("${widget.awbDetailsList!.nOP}");
                                    totalWt = double.parse("${widget.awbDetailsList!.weightKg}");


                                    nopController.text = totalNop.toString();
                                    weightController.text = totalWt.toStringAsFixed(2);
                                    differenceNop = 0;
                                    differenceWeight = 0.00;
                                    WidgetsBinding.instance.addPostFrameCallback((_) {
                                      FocusScope.of(context).requestFocus(nopFocusNode);
                                    });
                                  }else{
                                    WidgetsBinding.instance.addPostFrameCallback((_) {
                                      FocusScope.of(context).requestFocus(groupIdFocusNode);
                                    });
                                  }

                                  groupIdController.clear();
                                  locationController.clear();
                                  _isvalidateLocation = false;
                                  isMergeIndicator = "N";

                                  setState(() {

                                  });
                                },
                              ),
                            ),

                            // start api responcer
                            BlocListener<FoundUTTCubit, FoundUTTState>(
                              listener: (context, state) async {

                                if (state is FoundUTTInitialState) {}
                                else if (state is FoundUTTLoadingState) {
                                  // showing loading dialog in this state
                                  DialogUtils.showLoadingDialog(context, message: lableModel.loading);
                                }
                                else if(state is GetFoundUTTGroupIdSuccessState){
                                  DialogUtils.hideLoadingDialog(context);
                                  if(state.getFoundUTTGroupIdModel.status == "E"){
                                    DialogUtils.hideLoadingDialog(context);
                                    SnackbarUtil.showSnackbar(context, state.getFoundUTTGroupIdModel.statusMessage!, MyColor.colorRed, icon: FontAwesomeIcons.times);
                                    Vibration.vibrate(duration: 500);
                                  }else if(state.getFoundUTTGroupIdModel.status == "V"){
                                    DialogUtils.hideLoadingDialog(context);
                                    SnackbarUtil.showSnackbar(context, state.getFoundUTTGroupIdModel.statusMessage!, MyColor.colorRed, icon: FontAwesomeIcons.times);
                                    Vibration.vibrate(duration: 500);
                                  }
                                  else if(state.getFoundUTTGroupIdModel.status == "Y"){
                                    locationController.text = state.getFoundUTTGroupIdModel.statusMessage!;
                                    setState(() {
                                      _isvalidateLocation = true;
                                    });

                                    bool? mergeDialog = await DialogUtils.commonDialogforWarning(context,  "${lableModel.merge}", "${lableModel.mergeMessage}" , lableModel);

                                    if(mergeDialog == true){
                                      isMergeIndicator = "Y";
                                      // call api record
                                      uttRecordShipmentSave();
                                    }
                                    else{
                                      /*isMergeIndicator = "N";
                                      if (locationController.text.isEmpty) {

                                        SnackbarUtil.showSnackbar(context, lableModel.enterLocationMsg!, MyColor.colorRed, icon: FontAwesomeIcons.times);
                                        WidgetsBinding.instance.addPostFrameCallback((_) {
                                          FocusScope.of(context).requestFocus(locationFocusNode);
                                        });
                                        Vibration.vibrate(duration: 500);

                                        return;
                                      }

                                      if (_isvalidateLocation == false) {

                                        SnackbarUtil.showSnackbar(context, lableModel.validateLocation!, MyColor.colorRed, icon: FontAwesomeIcons.times);
                                        WidgetsBinding.instance.addPostFrameCallback((_) {
                                          FocusScope.of(context).requestFocus(locationFocusNode);
                                        });
                                        Vibration.vibrate(duration: 500);

                                        return;
                                      }
                                      uttRecordShipmentSave();*/
                                    }
                                  }
                                  else{
                                    isMergeIndicator = "N";
                                    if (locationController.text.isEmpty) {

                                      SnackbarUtil.showSnackbar(context, lableModel.enterLocationMsg!, MyColor.colorRed, icon: FontAwesomeIcons.times);
                                      WidgetsBinding.instance.addPostFrameCallback((_) {
                                        FocusScope.of(context).requestFocus(locationFocusNode);
                                      });
                                      Vibration.vibrate(duration: 500);

                                      return;
                                    }

                                    if (_isvalidateLocation == false) {

                                      SnackbarUtil.showSnackbar(context, lableModel.validateLocation!, MyColor.colorRed, icon: FontAwesomeIcons.times);
                                      WidgetsBinding.instance.addPostFrameCallback((_) {
                                        FocusScope.of(context).requestFocus(locationFocusNode);
                                      });
                                      Vibration.vibrate(duration: 500);

                                      return;
                                    }
                                    uttRecordShipmentSave();
                                  }
                                }
                                else if(state is GetFoundUTTGroupIdFailureState){
                                  DialogUtils.hideLoadingDialog(context);
                                  Vibration.vibrate(duration: 500);
                                  SnackbarUtil.showSnackbar(context, state.error, MyColor.colorRed, icon: FontAwesomeIcons.times);
                                }
                                else if (state is ValidateLocationSuccessState){
                                  DialogUtils.hideLoadingDialog(context);
                                  if(state.validateLocationModel.status == "E"){
                                    Vibration.vibrate(duration: 500);
                                    SnackbarUtil.showSnackbar(context, state.validateLocationModel.statusMessage!, MyColor.colorRed, icon: FontAwesomeIcons.times);
                                    WidgetsBinding.instance.addPostFrameCallback((_) {
                                      FocusScope.of(context).requestFocus(locationFocusNode);
                                    });

                                  }else{
                                    _isvalidateLocation = true;
                                   /* WidgetsBinding.instance.addPostFrameCallback((_) {
                                      FocusScope.of(context).requestFocus(splitBtnFocusNode);
                                    });*/
                                    setState(() {

                                    });
                                  }
                                }
                                else if (state is ValidateLocationFailureState){
                                  DialogUtils.hideLoadingDialog(context);
                                  Vibration.vibrate(duration: 500);
                                  SnackbarUtil.showSnackbar(context, state.error, MyColor.colorRed, icon: FontAwesomeIcons.times);
                                }
                                else if(state is RecordFoundUTTUpdateSuccessState){

                                  DialogUtils.hideLoadingDialog(context);
                                  if(state.foundUTTRecordUpdateModel.status == "E"){
                                    Vibration.vibrate(duration: 500);
                                    SnackbarUtil.showSnackbar(context, state.foundUTTRecordUpdateModel.statusMessage!, MyColor.colorRed, icon: FontAwesomeIcons.times);
                                  }
                                  else if(state.foundUTTRecordUpdateModel.status == "V"){
                                    Vibration.vibrate(duration: 500);
                                    SnackbarUtil.showSnackbar(context, state.foundUTTRecordUpdateModel.statusMessage!, MyColor.colorRed, icon: FontAwesomeIcons.times);
                                  }
                                  else{
                                    SnackbarUtil.showSnackbar(context, state.foundUTTRecordUpdateModel.statusMessage!, MyColor.colorGreen, icon: Icons.done);
                                    Future.delayed(Duration(milliseconds: 200), () {
                                      Navigator.pop(context, "true");
                                    });
                                  }
                                  
                                }
                                else if (state is RecordFoundUTTUpdateFailureState){
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
                                                  child: Padding(
                                                    padding: const EdgeInsets.only(left: 12, right: 12, top: 12, bottom: 12),
                                                    child: (widget.type == "A") ? CustomeText(
                                                      text: AwbFormateNumberUtils.formatAWBNumber("${widget.awbDetailsList!.aWBNo}"),
                                                      fontColor: MyColor.textColorGrey3,
                                                      fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_7,
                                                      fontWeight: FontWeight.w600,
                                                      textAlign: TextAlign.start,
                                                    ) : Row(
                                                      children: [
                                                        ULDNumberWidget(uldNo: "${widget.uldDetailsList!.uLDNo}", smallFontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5, bigFontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_8, fontColor: MyColor.textColorGrey3, uldType: "U"),
                                                      ],
                                                    ),

                                                  ),
                                                )),

                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(left: 10, right: 10, top: 0, bottom: 10),
                                            child: Directionality(textDirection: textDirection,
                                                child: Container(
                                                  width: double.infinity,
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
                                                  child: Padding(
                                                    padding: const EdgeInsets.only(left: 12, right: 12, top: 12, bottom: 12),
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        (widget.type == "A") ? SizedBox(height: SizeConfig.blockSizeVertical,) : SizedBox(),
                                                        (widget.type == "A") ? Directionality(
                                                          textDirection: textDirection,
                                                          child: Row(
                                                            children: [
                                                              Expanded(
                                                                flex:1,
                                                                child: CustomTextField(
                                                                  textDirection: textDirection,
                                                                  controller: nopController,
                                                                  focusNode: nopFocusNode,
                                                                  onPress: () {},
                                                                  hasIcon: false,
                                                                  maxLength: 4,
                                                                  hastextcolor: true,
                                                                  animatedLabel: true,
                                                                  needOutlineBorder: true,
                                                                  labelText: "${lableModel.nop}",
                                                                  readOnly: (widget.awbDetailsList!.nOP == 1) ? true : false,
                                                                  onChanged: (value) {
                                                                    if (value.isNotEmpty) {
                                                                      int enteredNop = int.tryParse(value) ?? 0;

                                                                      if (enteredNop > totalNop) {
                                                                        // Exceeds total NOP, show an error

                                                                        Vibration.vibrate(duration: 500);
                                                                        setState(() {
                                                                          differenceNop = totalNop - enteredNop;
                                                                          weightCount = double.parse(((enteredNop * totalWt) / totalNop).toStringAsFixed(2));
                                                                          weightController.text = weightCount.toStringAsFixed(2);
                                                                          differenceWeight = totalWt - weightCount;
                                                                          SnackbarUtil.showSnackbar(context, lableModel.exceedstotalnop!, MyColor.colorRed, icon: FontAwesomeIcons.times);
                                                                          //errorText = "${lableModel.exceedstotalnop}";
                                                                        });
                                                                      } else {
                                                                        // Update the differences and weight
                                                                        setState(() {
                                                                          differenceNop = totalNop - enteredNop;
                                                                          //weightCount = (totalWt / totalNop) * enteredNop;
                                                                          weightCount = double.parse(((enteredNop * totalWt) / totalNop).toStringAsFixed(2));
                                                                          weightController.text = weightCount.toStringAsFixed(2);
                                                                          differenceWeight = totalWt - weightCount;
                                                                        });
                                                                      }
                                                                    } else {
                                                                      // Reset to defaults when cleared
                                                                      setState(() {
                                                                        differenceNop = totalNop;
                                                                        differenceWeight = totalWt;
                                                                        weightCount = 0.0;
                                                                        weightController.text = "";
                                                                      });
                                                                    }

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
                                                              /*SizedBox(width: SizeConfig.blockSizeHorizontal * SizeUtils.WIDTH3,),
                                                              Expanded(
                                                                flex: 1,
                                                                child: CustomTextField(
                                                                  textDirection: textDirection,
                                                                  controller: weightController,
                                                                  focusNode: weightFocusNode,
                                                                  onPress: () {},
                                                                  hasIcon: false,
                                                                  hastextcolor: true,
                                                                  animatedLabel: true,
                                                                  needOutlineBorder: true,
                                                                  labelText: "${lableModel!.weight}",
                                                                  readOnly: (differenceNop == 0) ? true : false,
                                                                  onChanged: (value) {
                                                                    if (value.isNotEmpty) {
                                                                      double enteredWeight = double.tryParse(value) ?? 0.00;

                                                                      if (enteredWeight > totalWt) {
                                                                        // Exceeds total weight, show an error
                                                                        Vibration.vibrate(duration: 500);
                                                                        setState(() {
                                                                          SnackbarUtil.showSnackbar(context, lableModel.exceedstotalWeight!, MyColor.colorRed, icon: FontAwesomeIcons.times);
                                                                          differenceWeight = totalWt - enteredWeight;
                                                                        });
                                                                      } else {
                                                                        // Update the weight difference
                                                                        setState(() {
                                                                          differenceWeight = totalWt - enteredWeight;
                                                                          if (differenceNop != 0 && differenceWeight == 0) {
                                                                            Vibration.vibrate(duration: 500);
                                                                            SnackbarUtil.showSnackbar(context, lableModel.remainingpcsavailable!, MyColor.colorRed, icon: FontAwesomeIcons.times);

                                                                          } else {

                                                                          }
                                                                        });
                                                                      }
                                                                    } else {
                                                                      // Reset to defaults when cleared
                                                                      setState(() {
                                                                        differenceWeight = totalWt;

                                                                      });
                                                                    }
                                                                  },
                                                                  fillColor:  Colors.grey.shade100,
                                                                  textInputType: TextInputType.number,
                                                                  inputAction: TextInputAction.next,
                                                                  hintTextcolor: Colors.black45,
                                                                  verticalPadding: 0,
                                                                  maxLength: 10,
                                                                  digitsOnly: false,
                                                                  doubleDigitOnly: true,
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
                                                              )*/
                                                            ],
                                                          ),
                                                        ) : const SizedBox(),
                                                        (widget.type == "A") ? Row(
                                                          children: [
                                                            Expanded(
                                                              flex:1,
                                                              child: CustomeText(
                                                                text: "${lableModel.remainingNop} : $differenceNop",
                                                                fontColor: MyColor.colorRed,
                                                                fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                                                fontWeight: FontWeight.w500,
                                                                textAlign: TextAlign.start,
                                                              ),
                                                            ),
                                                            /*SizedBox(width: SizeConfig.blockSizeHorizontal * SizeUtils.WIDTH3,),
                                                            Expanded(
                                                              flex: 1,
                                                              child: CustomeText(
                                                                text: "${lableModel.remainingWeight} : ${differenceWeight.toStringAsFixed(2)}",
                                                                fontColor: MyColor.colorRed,
                                                                fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                                                fontWeight: FontWeight.w500,
                                                                textAlign: TextAlign.start,
                                                              ),
                                                            ),*/
                                                          ],
                                                        ) : const SizedBox(),
                                                        SizedBox(height: SizeConfig.blockSizeVertical * SizeUtils.HEIGHT2),
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
                                                            labelText: widget.isRequiredGroupId == "Y" ? "${lableModel.groupId} *" : "${lableModel.groupId}",
                                                            readOnly: false,
                                                            maxLength: (widget.isGroupIdLength == 0) ? 1 : widget.isGroupIdLength,
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
                                                        CustomeEditTextWithBorder(
                                                          lablekey: "LOCATION",
                                                          textDirection: textDirection,
                                                          controller: locationController,
                                                          focusNode: locationFocusNode,
                                                          hasIcon: false,
                                                          hastextcolor: true,
                                                          animatedLabel: true,
                                                          needOutlineBorder: true,
                                                          labelText: "${lableModel.location}",
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
                                      text: "${lableModel.cancel}",
                                      isborderButton: true,
                                      press: () async {
                                        _onWillPop();
                                      },
                                    ),
                                  ),
                                  SizedBox(width: SizeConfig.blockSizeHorizontal * SizeUtils.HEIGHT7,),
                                  Expanded(
                                    flex: 1,
                                    child: RoundedButtonBlue(
                                      text: "${lableModel.save}",
                                      press: () {

                                        if(widget.type == "A"){

                                          if (nopController.text.isEmpty) {

                                            SnackbarUtil.showSnackbar(context, lableModel.piecesMsg!, MyColor.colorRed, icon: FontAwesomeIcons.times);
                                            WidgetsBinding.instance.addPostFrameCallback((_) {
                                              FocusScope.of(context).requestFocus(nopFocusNode);
                                            });
                                            Vibration.vibrate(duration: 500);

                                            return;
                                          }
                                          if(int.parse(nopController.text) == 0){

                                            SnackbarUtil.showSnackbar(context, lableModel.enterPiecesGrtMsg!, MyColor.colorRed, icon: FontAwesomeIcons.times);
                                            WidgetsBinding.instance.addPostFrameCallback((_) {
                                              FocusScope.of(context).requestFocus(nopFocusNode);
                                            });
                                            Vibration.vibrate(duration: 500);

                                            return;
                                          }

                                          if(widget.isRequiredGroupId == "Y"){
                                            if (groupIdController.text.isEmpty) {

                                              SnackbarUtil.showSnackbar(context, lableModel.enterGropIdMsg!, MyColor.colorRed, icon: FontAwesomeIcons.times);
                                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                                FocusScope.of(context).requestFocus(groupIdFocusNode);
                                              });
                                              Vibration.vibrate(duration: 500);

                                              return;
                                            }


                                           /* if (groupIdController.text.length != widget.isGroupIdLength) {
                                              SnackbarUtil.showSnackbar(context, formatMessage("${lableModel.groupIdCharSizeMsg}", ["${widget.isGroupIdLength}"]), MyColor.colorRed, icon: FontAwesomeIcons.times);
                                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                                FocusScope.of(context).requestFocus(groupIdFocusNode);
                                              });
                                              Vibration.vibrate(duration: 500);

                                              return;
                                            }*/

                                          }


                                          foundUTTGroupIdSearch();
                                        }
                                        else{

                                          if(widget.isRequiredGroupId == "Y"){
                                            if (groupIdController.text.isEmpty) {

                                              SnackbarUtil.showSnackbar(context, lableModel.enterGropIdMsg!, MyColor.colorRed, icon: FontAwesomeIcons.times);
                                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                                FocusScope.of(context).requestFocus(groupIdFocusNode);
                                              });
                                              Vibration.vibrate(duration: 500);

                                              return;
                                            }


                                            /*if (groupIdController.text.length != widget.isGroupIdLength) {
                                              SnackbarUtil.showSnackbar(context, formatMessage("${lableModel.groupIdCharSizeMsg}", ["${widget.isGroupIdLength}"]), MyColor.colorRed, icon: FontAwesomeIcons.times);
                                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                                FocusScope.of(context).requestFocus(groupIdFocusNode);
                                              });
                                              Vibration.vibrate(duration: 500);

                                              return;
                                            }*/

                                          }

                                          if (locationController.text.isEmpty) {

                                            SnackbarUtil.showSnackbar(context, lableModel.enterLocationMsg!, MyColor.colorRed, icon: FontAwesomeIcons.times);
                                            WidgetsBinding.instance.addPostFrameCallback((_) {
                                              FocusScope.of(context).requestFocus(locationFocusNode);
                                            });
                                            Vibration.vibrate(duration: 500);

                                            return;
                                          }

                                          if (_isvalidateLocation == false) {

                                            SnackbarUtil.showSnackbar(context, lableModel.validateLocation!, MyColor.colorRed, icon: FontAwesomeIcons.times);
                                            WidgetsBinding.instance.addPostFrameCallback((_) {
                                              FocusScope.of(context).requestFocus(locationFocusNode);
                                            });
                                            Vibration.vibrate(duration: 500);

                                            return;
                                          }


                                          uttRecordULDSave();
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

  String formatMessage(String template, List<String> values) {
    String formattedMessage = template;
    for (int i = 0; i < values.length; i++) {
      formattedMessage = formattedMessage.replaceAll('{$i}', values[i]);
    }
    return formattedMessage;
  }


  Future<void> openValidationDialog(String message, FocusNode focuseNode) async {
    bool? empty = await DialogUtils.showDataNotFoundDialogbot(
        context, message, widget.lableModel);

    if (empty == true) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        FocusScope.of(context).requestFocus(focuseNode);
      });
    }
  }



  Future<void> foundUTTGroupIdSearch() async {

    await context.read<FoundUTTCubit>().getFoundUTTGroupIdRecord(
        widget.awbDetailsList!.expShipRowId!,
        groupIdController.text,
        widget.awbDetailsList!.location!,
        widget.awbDetailsList!.moduleType!,
        _user!.userProfile!.userIdentity!,
        _splashDefaultData!.companyCode!,
        widget.menuId);
  }




  Future<void> uttRecordShipmentSave() async {

    print("CHECK AWB====== ${int.parse(nopController.text)} ${double.parse(weightController.text)} ${widget.awbDetailsList!.moduleType!} $isMergeIndicator");

    await context.read<FoundUTTCubit>().foundUTTRecordUpdate(
        "A",
        widget.awbDetailsList!.groupSeqNo!,
        groupIdController.text,
        locationController.text,
        int.parse(nopController.text),
        double.parse(weightController.text),
        isMergeIndicator,
        (differenceNop > 0) ? "Y" : "N",
        widget.awbDetailsList!.moduleType!,
        _user!.userProfile!.userIdentity!,
        _splashDefaultData!.companyCode!,
        widget.menuId);
  }

  Future<void> uttRecordULDSave() async {

    print("CHECK ULD====== U === ${widget.uldDetailsList!.uLDSeqNo!}");


    await context.read<FoundUTTCubit>().foundUTTRecordUpdate(
        "U",
        widget.uldDetailsList!.uLDSeqNo!,
        groupIdController.text,
        locationController.text,
        0,
        0.00,
        "",
        "",
        "",
        _user!.userProfile!.userIdentity!,
        _splashDefaultData!.companyCode!,
        widget.menuId);
  }

}

