import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:galaxy/module/export/services/splitgroup/splitgrouplogic/splitgroupcubit.dart';
import 'package:galaxy/module/export/services/splitgroup/splitgrouplogic/splitgroupstate.dart';
import 'package:galaxy/utils/snackbarutil.dart';
import 'package:galaxy/widget/customdivider.dart';
import 'package:galaxy/widget/customebuttons/roundbuttonblue.dart';
import 'package:galaxy/widget/customedrawer/customedrawer.dart';
import 'package:galaxy/widget/uldnumberwidget.dart';
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
import '../../../../widget/roundbutton.dart';
import '../../../login/model/userlogindatamodel.dart';
import '../../../login/pages/signinscreenmethods.dart';
import '../../../onboarding/sizeconfig.dart';
import 'dart:ui' as ui;
import '../../../profile/page/profilepagescreen.dart';
import '../../../splash/model/splashdefaultmodel.dart';
import '../../../submenu/model/submenumodel.dart';
import '../../model/splitgroup/splitgroupdetailsearchmodel.dart';

class SplitGroupSavePage extends StatefulWidget {


  String mainMenuName;
  int menuId;
  LableModel lableModel;
  List<SubMenuName> importSubMenuList = [];
  List<SubMenuName> exportSubMenuList = [];
  String title;
  String refrelCode;

  SplitGroupDetailList splitGroup;
  String isGroupBasedAcceptChar;
  int isGroupBasedAcceptNumber;


  SplitGroupSavePage({
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
    required this.splitGroup
   });

  @override
  State<SplitGroupSavePage> createState() => _SplitGroupSavePageState();
}

class _SplitGroupSavePageState extends State<SplitGroupSavePage>{
  InactivityTimerManager? inactivityTimerManager;
  final SavedPrefrence savedPrefrence = SavedPrefrence();
  UserDataModel? _user;
  SplashDefaultModel? _splashDefaultData;




  final ScrollController scrollController = ScrollController();
  //FocusNode awbFocusNode = FocusNode();


  TextEditingController nopController = TextEditingController();
  TextEditingController weightController = TextEditingController();

  TextEditingController groupIdController = TextEditingController();
  FocusNode groupIdFocusNode = FocusNode();

  TextEditingController locationController = TextEditingController();
  FocusNode locationFocusNode = FocusNode();

  FocusNode nopFocusNode = FocusNode();
  FocusNode weightFocusNode = FocusNode();
  FocusNode splitBtnFocusNode = FocusNode();

  bool _isLocationSearchBtnEnable = false;
  bool _isvalidateLocation = false;

  double weightCount = 0.00;

  int totalNop = 0;
  double totalWt = 0.00;

  int differenceNop = 0;
  double differenceWeight = 0.00;

  bool isBackPressed = false;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();


    locationFocusNode.addListener(() {
      if (!locationFocusNode.hasFocus && !isBackPressed) {
        leaveLocationFocus();
      }
    });

    locationController.addListener(_validateLocationSearchBtn);

    totalNop = int.parse("${widget.splitGroup.nOP}");
    totalWt = double.parse("${widget.splitGroup.weight}");

    nopController.text = totalNop.toString();
    weightController.text = totalWt.toStringAsFixed(2);
    locationController.text = widget.splitGroup.locationCode!;
    checkLocationValidation();
    _loadUser(); //load user data

  }

  Future<void> checkLocationValidation()async {
    if(widget.splitGroup.locationCode!.isNotEmpty){
      _isvalidateLocation = true;
    }else{
      _isvalidateLocation = false;
    }
    setState(() {

    });
  }


  Future<void> leaveLocationFocus() async {
    if (locationController.text.isNotEmpty) {
      if(_isvalidateLocation == false){
        //call location validation api
        await context.read<SplitGroupCubit>().getValidateLocation(
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
                                  totalNop = int.parse("${widget.splitGroup.nOP}");
                                  totalWt = double.parse("${widget.splitGroup.weight}");

                                  nopController.text = totalNop.toString();
                                  weightController.text = totalWt.toStringAsFixed(2);
                                  locationController.text = widget.splitGroup.locationCode!;
                                  checkLocationValidation();
                                  differenceNop = 0;
                                  differenceWeight = 0.00;
                                  setState(() {

                                  });
                                },
                              ),
                            ),

                            // start api responcer
                            BlocListener<SplitGroupCubit, SplitGroupState>(
                              listener: (context, state) async {

                                if (state is SplitGroupInitialState) {}
                                else if (state is SplitGroupLoadingState) {
                                  // showing loading dialog in this state
                                  DialogUtils.showLoadingDialog(context, message: lableModel!.loading);
                                }
                                else if (state is ValidateLocationSuccessState){
                                  DialogUtils.hideLoadingDialog(context);
                                  if(state.validateLocationModel.status == "E"){
                                    Vibration.vibrate(duration: 500);
                                    SnackbarUtil.showSnackbar(context, state.validateLocationModel.statusMessage!, MyColor.colorRed, icon: FontAwesomeIcons.times);
                                  }else{
                                    _isvalidateLocation = true;
                                    WidgetsBinding.instance.addPostFrameCallback((_) {
                                      FocusScope.of(context).requestFocus(splitBtnFocusNode);
                                    });
                                    setState(() {

                                    });
                                  }
                                }
                                else if (state is ValidateLocationFailureState){
                                  DialogUtils.hideLoadingDialog(context);
                                  Vibration.vibrate(duration: 500);
                                  SnackbarUtil.showSnackbar(context, state.error, MyColor.colorRed, icon: FontAwesomeIcons.times);
                                }
                                else if (state is SplitGroupSaveSuccessState){
                                  DialogUtils.hideLoadingDialog(context);
                                  if(state.splitGroupSaveModel.status == "E"){
                                    Vibration.vibrate(duration: 500);
                                    SnackbarUtil.showSnackbar(context, state.splitGroupSaveModel.statusMessage!, MyColor.colorRed, icon: FontAwesomeIcons.times);
                                  } else if (state.splitGroupSaveModel.status == "V"){
                                    Vibration.vibrate(duration: 500);
                                    SnackbarUtil.showSnackbar(context, state.splitGroupSaveModel.statusMessage!, MyColor.colorRed, icon: FontAwesomeIcons.times);
                                  }
                                  else{

                                    Navigator.pop(context, "true");
                                    SnackbarUtil.showSnackbar(context, state.splitGroupSaveModel.statusMessage!, MyColor.colorGreen, icon: Icons.done);

                                  }

                                }
                                else if (state is SplitGroupSaveFailureState){
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
                                                                CustomeText(
                                                                  text: AwbFormateNumberUtils.formatAWBNumber(widget.splitGroup.aWBNo!),
                                                                  fontColor: MyColor.textColorGrey3,
                                                                  fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_7,
                                                                  fontWeight: FontWeight.w600,
                                                                  textAlign: TextAlign.start,
                                                                ),
                                                                SizedBox(width: SizeConfig.blockSizeHorizontal * SizeUtils.WIDTH3),
                                                                CustomeText(
                                                                  text: "#${widget.splitGroup.shipmentNo}",
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
                                                                  text: (widget.splitGroup.houseNo!.isNotEmpty) ? widget.splitGroup.houseNo! : "-",
                                                                  fontColor: MyColor.textColorGrey3,
                                                                  fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_7,
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
                                                              text: "Group :",
                                                              fontColor: Colors.pink.shade500,
                                                              fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_7,
                                                              fontWeight: FontWeight.bold,
                                                              textAlign: TextAlign.start,
                                                            ),
                                                            const SizedBox(width: 5),
                                                            CustomeText(
                                                              text: "${widget.splitGroup.groupId}",
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
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        SizedBox(height: SizeConfig.blockSizeVertical,),
                                                        Directionality(
                                                          textDirection: textDirection,
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
                                                            labelText: "NoP",
                                                            readOnly: false,
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
                                                        CustomeText(
                                                          text: "${lableModel.remainingNop} : $differenceNop",
                                                          fontColor: MyColor.colorRed,
                                                          fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                                          fontWeight: FontWeight.w500,
                                                          textAlign: TextAlign.start,
                                                        ),
                                                        SizedBox(height: SizeConfig.blockSizeVertical * SizeUtils.HEIGHT2,),
                                                        Row(
                                                          children: [
                                                            Expanded(
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
                                                              ),
                                                            ),
                                                            SizedBox(width: SizeConfig.blockSizeHorizontal * SizeUtils.WIDTH3,),

                                                            RoundedButton(text: "Scale",
                                                              color: MyColor.primaryColorblue,
                                                              press: () async {
                                                                _resumeTimerOnInteraction();
                                                                bool? closeReopenTrolley = await DialogUtils.commingSoonDialog(context, "Coming soon..." , lableModel);

                                                              },),
                                                          ],
                                                        ),
                                                        CustomeText(
                                                          text: "${lableModel.remainingWeight} : ${differenceWeight.toStringAsFixed(2)}",
                                                          fontColor: MyColor.colorRed,
                                                          fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                                          fontWeight: FontWeight.w500,
                                                          textAlign: TextAlign.start,
                                                        ),

                                                        SizedBox(height: SizeConfig.blockSizeVertical * SizeUtils.HEIGHT2,),
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
                                      press: () {
                                        _onWillPop();  // Return null when "Cancel" is pressed
                                      },
                                    ),
                                  ),
                                  SizedBox(width: SizeConfig.blockSizeHorizontal * SizeUtils.HEIGHT7,),
                                  Expanded(
                                    flex: 1,
                                    child: RoundedButtonBlue(
                                      text: "Split",
                                      press: () {

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

                                        if (weightController.text.isEmpty) {
                                          SnackbarUtil.showSnackbar(context, lableModel.weightMsg!, MyColor.colorRed, icon: FontAwesomeIcons.times);
                                          WidgetsBinding.instance.addPostFrameCallback((_) {
                                            FocusScope.of(context).requestFocus(weightFocusNode);
                                          });
                                          Vibration.vibrate(duration: 500);

                                          return;
                                        }

                                        if(double.parse(weightController.text) == 0 || double.parse(weightController.text) == 0.0 || double.parse(weightController.text) == 0.00){
                                          SnackbarUtil.showSnackbar(context, lableModel.enterWeightGrtMsg!, MyColor.colorRed, icon: FontAwesomeIcons.times);
                                          WidgetsBinding.instance.addPostFrameCallback((_) {
                                            FocusScope.of(context).requestFocus(weightFocusNode);
                                          });
                                          Vibration.vibrate(duration: 500);
                                          return;
                                        }

                                        if (int.parse(nopController.text) > totalNop) {
                                          // Exceeds total NOP, show an error
                                          SnackbarUtil.showSnackbar(context, lableModel.exceedstotalnop!, MyColor.colorRed, icon: FontAwesomeIcons.times);
                                          WidgetsBinding.instance.addPostFrameCallback((_) {
                                            FocusScope.of(context).requestFocus(nopFocusNode);
                                          });
                                          Vibration.vibrate(duration: 500);
                                          return;
                                        }

                                        if (double.parse(weightController.text) > totalWt) {
                                          // Exceeds total weight, show an error
                                          SnackbarUtil.showSnackbar(context, lableModel.exceedstotalWeight!, MyColor.colorRed, icon: FontAwesomeIcons.times);
                                          Vibration.vibrate(duration: 500);
                                          WidgetsBinding.instance.addPostFrameCallback((_) {
                                            FocusScope.of(context).requestFocus(weightFocusNode);
                                          });
                                          return;
                                        }

                                        if (differenceNop != 0 && differenceWeight == 0) {
                                          SnackbarUtil.showSnackbar(context, lableModel.remainingpcsavailable!, MyColor.colorRed, icon: FontAwesomeIcons.times);
                                          Vibration.vibrate(duration: 500);
                                          WidgetsBinding.instance.addPostFrameCallback((_) {
                                            FocusScope.of(context).requestFocus(weightFocusNode);
                                          });


                                          return;
                                        }

                                        if (differenceNop == 0) {
                                          SnackbarUtil.showSnackbar(context, "Remaining NoP is 0 can't split group", MyColor.colorRed, icon: FontAwesomeIcons.times);
                                          Vibration.vibrate(duration: 500);
                                          WidgetsBinding.instance.addPostFrameCallback((_) {
                                            FocusScope.of(context).requestFocus(nopFocusNode);
                                          });


                                          return;
                                        }

                                        if (differenceWeight == 0.00) {
                                          SnackbarUtil.showSnackbar(context, "Remaining weight is 0 can't split group", MyColor.colorRed, icon: FontAwesomeIcons.times);
                                          Vibration.vibrate(duration: 500);
                                          WidgetsBinding.instance.addPostFrameCallback((_) {
                                            FocusScope.of(context).requestFocus(weightFocusNode);
                                          });


                                          return;
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


                                        splitGroupSave();
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



  Future<void> splitGroupSave() async {


    await context.read<SplitGroupCubit>().splitGroupSave(
        widget.splitGroup.expAWBRowId!,
        widget.splitGroup.expShipRowId!,
        widget.splitGroup.stockRowId!,
        int.parse(nopController.text),
        double.parse(weightController.text),
        groupIdController.text,
        locationController.text,
        _user!.userProfile!.userIdentity!,
        _splashDefaultData!.companyCode!,
        widget.menuId);
  }

}

