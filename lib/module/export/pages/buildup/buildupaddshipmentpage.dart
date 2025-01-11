import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:galaxy/module/export/services/buildup/builduplogic/buildupcubit.dart';
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
import '../../../../widget/custometext.dart';
import '../../../../widget/customeuiwidgets/header.dart';
import '../../../../widget/customtextfield.dart';
import '../../../../widget/header/mainheadingwidget.dart';
import '../../../login/model/userlogindatamodel.dart';
import '../../../login/pages/signinscreenmethods.dart';
import '../../../onboarding/sizeconfig.dart';
import 'dart:ui' as ui;
import '../../../profile/page/profilepagescreen.dart';
import '../../../splash/model/splashdefaultmodel.dart';
import '../../../submenu/model/submenumodel.dart';
import '../../services/buildup/builduplogic/buildupstate.dart';

class BuildUpAddShipmentPage extends StatefulWidget {


  String mainMenuName;
  int menuId;
  LableModel lableModel;
  List<SubMenuName> importSubMenuList = [];
  List<SubMenuName> exportSubMenuList = [];
  String title;
  String refrelCode;

  int flightSeqNo;
  int uldSeqNo;
  String uldNo;
  String awbNo;
  int awbRowId;
  int awbShipRowId;
  String uldType;
  int pieces;
  double weight;
  String shcCodes;
  String offPoint;
  String dgType;
  int dgSeqNo;
  int dgReference;


  BuildUpAddShipmentPage({
    super.key,
    required this.importSubMenuList,
    required this.exportSubMenuList,
    required this.mainMenuName,
    required this.menuId,
    required this.lableModel,
    required this.title,
    required this.refrelCode,
    required this.flightSeqNo,
    required this.uldSeqNo,
    required this.uldNo,
    required this.awbNo,
    required this.awbRowId,
    required this.awbShipRowId,
    required this.uldType,
    required this.pieces,
    required this.weight,
    required this.shcCodes,
    required this.offPoint,
    required this.dgType,
    required this.dgSeqNo,
    required this.dgReference
   });

  @override
  State<BuildUpAddShipmentPage> createState() => _BuildUpAddShipmentPageState();
}

class _BuildUpAddShipmentPageState extends State<BuildUpAddShipmentPage>{
  InactivityTimerManager? inactivityTimerManager;
  final SavedPrefrence savedPrefrence = SavedPrefrence();
  UserDataModel? _user;
  SplashDefaultModel? _splashDefaultData;




  final ScrollController scrollController = ScrollController();
  //FocusNode awbFocusNode = FocusNode();


  TextEditingController nopController = TextEditingController();
  TextEditingController weightController = TextEditingController();

  TextEditingController shcController = TextEditingController();


  FocusNode nopFocusNode = FocusNode();
  FocusNode weightFocusNode = FocusNode();
  FocusNode shcFocusNode = FocusNode();


  double weightCount = 0.00;

  int totalNop = 0;
  double totalWt = 0.00;

  int differenceNop = 0;
  double differenceWeight = 0.00;



  String shcCodes = "";

  List<String> selectedShcCodes = [];
  String SHCCodes = "";


  @override
  void initState() {
    // TODO: implement initState
    super.initState();


    shcCodes = widget.shcCodes.trim();

    selectedShcCodes = shcCodes.split(",");

    totalNop = int.parse("${widget.pieces}");
    totalWt = double.parse("${widget.weight}");

    nopController.text = totalNop.toString();
    weightController.text = totalWt.toStringAsFixed(2);

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

                                },
                              ),
                            ),

                            // start api responcer
                            BlocListener<BuildUpCubit, BuildUpState>(
                              listener: (context, state) {

                                if (state is BuildUpInitialState) {
                                }
                                else if (state is BuildUpLoadingState) {
                                  // showing loading dialog in this state
                                  DialogUtils.showLoadingDialog(context, message: lableModel!.loading);
                                }
                                else if (state is SHCValidateSuccessState){
                                  DialogUtils.hideLoadingDialog(context);
                                  if(state.shcValidateModel.status == "E"){
                                    Vibration.vibrate(duration: 500);
                                    SnackbarUtil.showSnackbar(context, state.shcValidateModel.statusMessage!, MyColor.colorRed, icon: FontAwesomeIcons.times);
                                  }
                                  else{

                                    String newShcCode = shcController.text;

                                    if (!shcCodes.split(",").contains(newShcCode)) {
                                      setState(() {
                                        // Update the SHC codes list
                                        if (shcCodes.isEmpty) {
                                          shcCodes = newShcCode; // Set the first SHC code without a leading comma
                                        } else {
                                          shcCodes = "$shcCodes,$newShcCode"; // Append with a comma
                                        }

                                        // Add to selected SHC codes
                                        selectedShcCodes.add(newShcCode);

                                        // Clear the input field
                                        shcController.clear();
                                      });
                                      SnackbarUtil.showSnackbar(context, state.shcValidateModel.statusMessage!, MyColor.colorGreen, icon: Icons.done);

                                    } else {

                                      SnackbarUtil.showSnackbar(context, "SHC code already exists in the list.", MyColor.colorRed, icon: FontAwesomeIcons.times);
                                      Vibration.vibrate(duration: 500);

                                    }



                                  }
                                }
                                else if (state is SHCValidateFailureState){
                                  DialogUtils.hideLoadingDialog(context);
                                  Vibration.vibrate(duration: 500);
                                  SnackbarUtil.showSnackbar(context, state.error, MyColor.colorRed, icon: FontAwesomeIcons.times);
                                }
                                else if (state is AddShipmentSuccessState){
                                  DialogUtils.hideLoadingDialog(context);
                                  if(state.addShipmentModel.status == "E"){
                                    Vibration.vibrate(duration: 500);
                                    SnackbarUtil.showSnackbar(context, state.addShipmentModel.statusMessage!, MyColor.colorRed, icon: FontAwesomeIcons.times);
                                  } else if (state.addShipmentModel.status == "V"){
                                    Vibration.vibrate(duration: 500);
                                    SnackbarUtil.showSnackbar(context, state.addShipmentModel.statusMessage!, MyColor.colorRed, icon: FontAwesomeIcons.times);
                                  }else{
                                    Navigator.pop(context, "true");
                                    SnackbarUtil.showSnackbar(context, state.addShipmentModel.statusMessage!, MyColor.colorGreen, icon: Icons.done);

                                  }

                                }
                                else if (state is AddShipmentFailureState){
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
                                                                CustomeText(text: "ULD :", fontColor: MyColor.textColorGrey3, fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_6, fontWeight: FontWeight.w700, textAlign: TextAlign.end),
                                                                SizedBox(width: SizeConfig.blockSizeHorizontal,),
                                                                ULDNumberWidget(uldNo: widget.uldNo, smallFontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5, bigFontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_7, fontColor: MyColor.textColorGrey3, uldType: "U"),
                                                              ],
                                                            ),
                                                            Row(
                                                              children: [
                                                                CustomeText(text: "AWB :", fontColor: MyColor.textColorGrey3, fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_6, fontWeight: FontWeight.w700, textAlign: TextAlign.end),
                                                                SizedBox(width: SizeConfig.blockSizeHorizontal,),
                                                                CustomeText(text: AwbFormateNumberUtils.formatAWBNumber(widget.awbNo), fontColor: MyColor.textColorGrey3, fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5, fontWeight: FontWeight.w600, textAlign: TextAlign.end),
                                                              ],
                                                            )
                                                          ],
                                                        ),
                                                        SizedBox(height: SizeConfig.blockSizeVertical * SizeUtils.HEIGHT2,),
                                                        Row(
                                                          children: [
                                                            Expanded(
                                                                flex:1,
                                                                child: Directionality(
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
                                                                            SnackbarUtil.showSnackbar(context, lableModel!.exceedstotalnop!, MyColor.colorRed, icon: FontAwesomeIcons.times);
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
                                                                )
                                                            ),
                                                            SizedBox(width: SizeConfig.blockSizeHorizontal * SizeUtils.WIDTH2,),
                                                            Expanded(
                                                              flex: 1,
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
                                                          ],
                                                        ),
                                                        Row(
                                                          children: [
                                                            Expanded(
                                                              flex: 1,
                                                              child: CustomeText(
                                                                text: "${lableModel.remainingNop} : $differenceNop",
                                                                fontColor: MyColor.colorRed,
                                                                fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                                                fontWeight: FontWeight.w500,
                                                                textAlign: TextAlign.start,
                                                              ),
                                                            ),
                                                            SizedBox(width: SizeConfig.blockSizeHorizontal * SizeUtils.WIDTH2,),
                                                            Expanded(
                                                              flex: 1,
                                                              child: CustomeText(
                                                                text: "${lableModel.remainingWeight} : ${differenceWeight.toStringAsFixed(2)}",
                                                                fontColor: MyColor.colorRed,
                                                                fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                                                fontWeight: FontWeight.w500,
                                                                textAlign: TextAlign.start,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(height: SizeConfig.blockSizeVertical ),
                                                        RoundedButtonBlue(text: "Add Shipment", press: () {
                                                          SHCCodes = selectedShcCodes.join("~");
                                                          addShipment(SHCCodes);
                                                        },)
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

                                                        CustomeText(text: "SHC Codes", fontColor: MyColor.textColorGrey3, fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5, fontWeight: FontWeight.w600, textAlign: TextAlign.end),
                                                        SizedBox(height: SizeConfig.blockSizeVertical,),
                                                        (shcCodes.isNotEmpty)
                                                            ? ListView.builder(
                                                          itemCount: (shcCodes.isNotEmpty) ? shcCodes.split(",").length : 0,
                                                          shrinkWrap: true,
                                                          physics: const NeverScrollableScrollPhysics(),
                                                          itemBuilder: (context, index) {
                                                            Color backgroundColor = MyColor.colorList[index % MyColor.colorList.length];

                                                            String content = (shcCodes.isNotEmpty) ? shcCodes.split(",")[index] : "";
                                                            bool isSwitchOn = selectedShcCodes.contains(content);

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
                                                                              child: CustomeText(
                                                                                text : content.trim().isNotEmpty ? "${content.trim()}".substring(0, 2).toUpperCase() : "",
                                                                                fontColor: MyColor.colorBlack,
                                                                                fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_8,
                                                                                fontWeight: FontWeight.w500,
                                                                                textAlign: TextAlign.center,
                                                                              ),
                                                                            ),
                                                                            SizedBox(
                                                                              width: 15,
                                                                            ),
                                                                            Flexible(
                                                                              child: CustomeText(
                                                                                text: content.trim(),
                                                                                fontColor: MyColor.colorBlack,
                                                                                fontSize: SizeConfig.textMultiplier * 1.5,
                                                                                fontWeight: FontWeight.w400,
                                                                                textAlign: TextAlign.start,
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                      SizedBox(width: 2),
                                                                      Switch(
                                                                        value: isSwitchOn,
                                                                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                                                        activeColor: MyColor.primaryColorblue,
                                                                        inactiveThumbColor: MyColor.thumbColor,
                                                                        inactiveTrackColor: MyColor.textColorGrey2,
                                                                        trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
                                                                        onChanged: (value) {
                                                                          setState(() {
                                                                            if (value) {
                                                                              // Add to the selected list
                                                                              if (!selectedShcCodes.contains(content)) {
                                                                                selectedShcCodes.add(content);
                                                                              }
                                                                            } else {
                                                                              // Remove from the selected list
                                                                              selectedShcCodes.remove(content);
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
                                                        )
                                                            :  Padding(
                                                          padding: const EdgeInsets.symmetric(vertical: 10.0),
                                                          child: Center(
                                                            child: CustomeText(text: "No Any SHC code",
                                                                fontColor: MyColor.textColorGrey,
                                                                fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_2_0,
                                                                fontWeight: FontWeight.w500,
                                                                textAlign: TextAlign.center),),
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
                                    flex: 2,
                                    child: CustomTextField(
                                      textDirection: textDirection,
                                      controller: shcController,
                                      focusNode: shcFocusNode,
                                      onPress: () {},
                                      hasIcon: false,
                                      maxLength: 3,
                                      hastextcolor: true,
                                      animatedLabel: true,
                                      needOutlineBorder: true,
                                      labelText: "SHC *",
                                      readOnly: false,
                                      onChanged: (value) {

                                      },
                                      fillColor:  Colors.grey.shade100,
                                      textInputType: TextInputType.text,
                                      inputAction: TextInputAction.next,
                                      hintTextcolor: Colors.black45,
                                      verticalPadding: 0,
                                      digitsOnly: false,

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
                                  SizedBox(width: SizeConfig.blockSizeHorizontal * SizeUtils.HEIGHT3,),
                                  Expanded(
                                    flex: 1,
                                    child: RoundedButtonBlue(
                                      text: "Add to list",
                                      press: () {

                                        if(shcCodes.split(",").length < 9){
                                          if(shcController.text.isNotEmpty){
                                            shcValidate();
                                          }else{
                                            SnackbarUtil.showSnackbar(context, "Please enter SHC code.", MyColor.colorRed, icon: FontAwesomeIcons.times);
                                            Vibration.vibrate(duration: 500);
                                          }
                                        }else{
                                          SnackbarUtil.showSnackbar(context, "Add Only 9 SHC codes", MyColor.colorRed, icon: FontAwesomeIcons.times);
                                          Vibration.vibrate(duration: 500);
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




  Future<void> openValidationDialog(String message, FocusNode focuseNode) async {
    bool? empty = await DialogUtils.showDataNotFoundDialogbot(
        context, "${message}", widget.lableModel);

    if (empty == true) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        FocusScope.of(context).requestFocus(focuseNode);
      });
    }
  }


  Future<void> shcValidate() async {
    await context.read<BuildUpCubit>().shcCodeValidate(
         shcController.text,
        _user!.userProfile!.userIdentity!,
        _splashDefaultData!.companyCode!,
        widget.menuId);
  }

  Future<void> addShipment(String SHCCodes) async {

    print("DGTYPE === ${widget.dgType}");

    String awbNoCheck = AwbFormateNumberUtils.formatAWBNumber(widget.awbNo);
    String awbPrifix = awbNoCheck.split("-")[0];
    String awbNumber = awbNoCheck.split("-")[1];

    await context.read<BuildUpCubit>().addShipment(
        widget.flightSeqNo,
        widget.awbRowId, widget.awbShipRowId, widget.uldSeqNo,
        awbPrifix,awbNumber.replaceAll(" ", ""),int.parse(nopController.text), double.parse(weightController.text),
        widget.offPoint, SHCCodes,
        (differenceNop > 0) ? "Y" : "N", SHCCodes.contains("DGR") ? "Y" : "N",
        widget.uldType,
        widget.dgType, widget.dgSeqNo, widget.dgReference,
        _user!.userProfile!.userIdentity!,
        _splashDefaultData!.companyCode!,
        widget.menuId);
  }

}

