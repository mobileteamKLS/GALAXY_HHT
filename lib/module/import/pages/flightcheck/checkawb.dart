import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:galaxy/utils/sizeutils.dart';
import 'package:galaxy/widget/customebuttons/roundbuttonblue.dart';
import 'package:galaxy/widget/custometext.dart';

import '../../../../core/mycolor.dart';
import '../../../../language/appLocalizations.dart';
import '../../../../language/model/lableModel.dart';
import 'dart:ui' as ui;

import '../../../../manager/timermanager.dart';
import '../../../../prefrence/savedprefrence.dart';
import '../../../../utils/commonutils.dart';
import '../../../../utils/dialogutils.dart';
import '../../../../widget/customdivider.dart';
import '../../../../widget/customeuiwidgets/footer.dart';
import '../../../../widget/customeuiwidgets/header.dart';
import '../../../../widget/customtextfield.dart';
import '../../../../widget/dropdowntextfield.dart';
import '../../../../widget/header/mainheadingwidget.dart';
import '../../../../widget/roundbutton.dart';
import '../../../login/model/userlogindatamodel.dart';
import '../../../login/pages/signinscreenmethods.dart';
import '../../../onboarding/sizeconfig.dart';
import '../../../splash/model/splashdefaultmodel.dart';
import '../../model/flightcheck/awblistmodel.dart';

class CheckAWBPage extends StatefulWidget {

  FlightCheckInAWBBDList aWBItem;
  String mainMenuName;
  CheckAWBPage({super.key, required this.aWBItem, required this.mainMenuName});

  @override
  State<CheckAWBPage> createState() => _CheckAWBPageState();
}

class _CheckAWBPageState extends State<CheckAWBPage> {

  InactivityTimerManager? inactivityTimerManager;

  final SavedPrefrence savedPrefrence = SavedPrefrence();
  UserDataModel? _user;
  SplashDefaultModel? _splashDefaultData;

  static List<String> listOfULDNo() {
    return ["Select", "BULK", "AKE 14066 BA", "AJO 12433 BA"];
  }

  static List<String> listOfmawbNo() {
    return ["Select", "MAWB1", "MAWB2", "MAWB3", "MAWB4"];
  }

  static List<String> listOfhawbNo() {
    return ["Select", "HAWB1", "HAWB2", "HAWB3", "HAWB4"];
  }



  String? selecteduldNo;
  String? selectedMawbItem;
  String? selectedHawbItem;

  bool _isFoundCargoChecked = false;

  TextEditingController flightNoEditingController = TextEditingController();
  TextEditingController dateEditingController = TextEditingController();
  TextEditingController scanULDNoController = TextEditingController();
  TextEditingController scanMAWBNoController = TextEditingController();
  TextEditingController scanHAWBNoController = TextEditingController();
  TextEditingController mAWBNoController = TextEditingController();
  TextEditingController hAWBNoController = TextEditingController();

  TextEditingController manifestedNopController = TextEditingController();
  TextEditingController receivedNopController = TextEditingController();
  TextEditingController remainingNopController = TextEditingController();
  TextEditingController groupIdController = TextEditingController();
  TextEditingController arrivedNoPController = TextEditingController();
  TextEditingController damageNoPController = TextEditingController();
  TextEditingController damageNoP1Controller = TextEditingController();
  TextEditingController damageWeightController = TextEditingController();
  TextEditingController damageWeight1Controller = TextEditingController();


  FocusNode flightNoFocusNode = FocusNode();
  FocusNode dateFocusNode = FocusNode();
  FocusNode scanULDNoFocusNode = FocusNode();
  FocusNode scanMAWBNoFocusNode = FocusNode();
  FocusNode mAWBNoFocusNode = FocusNode();
  FocusNode hAWBNoFocusNode = FocusNode();
  FocusNode scanHAWBNoFocusNode = FocusNode();
  FocusNode manifestedNopFocusNode = FocusNode();
  FocusNode receivedNopFocusNode = FocusNode();
  FocusNode remainingNopFocusNode = FocusNode();
  FocusNode groupIdFocusNode = FocusNode();
  FocusNode arrivedNoPFocusNode = FocusNode();
  FocusNode damageNoPFocusNode = FocusNode();
  FocusNode damage1NoPFocusNode = FocusNode();
  FocusNode damageWeightFocusNode = FocusNode();
  FocusNode damageWeight1FocusNode = FocusNode();


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadUser();
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
    Navigator.pop(context, "Done");
    return false; // Prevents the default back button action
  }


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

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Directionality(
        textDirection: uiDirection,
        child: SafeArea(
            child: Scaffold(
          backgroundColor: MyColor.colorWhite,
          body: Stack(
            children: [

              MainHeadingWidget(mainMenuName: widget.mainMenuName!),
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
                          child: HeaderWidget(
                            title: "Check AWB",
                            onBack: () {
                              Navigator.pop(context, "Done");
                            },
                            clearText: lableModel!.clear,
                            onClear: () {},
                          ),
                        ),

                        Expanded(
                            child: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [

                                  Container(
                                    padding : EdgeInsets.all(10),
                                    margin: const EdgeInsets.only(left: 10, right: 10, top: 0, bottom: 0),
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
                                          textDirection: uiDirection,
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: [
                                              CustomeText(text: "AWB No.", fontColor: MyColor.colorBlack, fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_2_0, fontWeight: FontWeight.w600, textAlign: TextAlign.start),
                                              SizedBox(width: SizeConfig.blockSizeHorizontal * SizeUtils.BUTTONHORIZONTALSIZE,),
                                              CustomeText(text: widget.aWBItem.aWBNo!, fontColor: MyColor.colorBlack, fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_2_0, fontWeight: FontWeight.w600, textAlign: TextAlign.start),
                                            ],
                                          ),
                                        ),
                                      /*  SizedBox(height: SizeConfig.blockSizeVertical * SizeUtils.HEIGHT_1_5,),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Expanded(
                                              flex : 1,
                                              child: Row(
                                                children: [
                                                  Checkbox(
                                                    side: BorderSide(width: 1, color: MyColor.primaryColorblue),
                                                    value: _isFoundCargoChecked,
                                                    onChanged: (value) {
                                                      setState(() {
                                                        _isFoundCargoChecked = value!;
                                                      });
                                                    },
                                                    checkColor: Colors.white,
                                                    activeColor: MyColor.primaryColorblue,
                                                  ),
                                                  CustomeText(text: "Found Cargo", fontColor: MyColor.colorBlack, fontSize: SizeConfig.textMultiplier * SizeUtils.MEDIUMTEXTSIZE, fontWeight: FontWeight.w500, textAlign: TextAlign.start),
                                                ],
                                              ),
                                            ),
                                            Expanded(
                                              flex: 1,
                                              child: RoundedButtonBlue(
                                                text: "BULK/ULD Complete",
                                                press: () {

                                                },),
                                            ),
                                          ],
                                        ),
                                        _isFoundCargoChecked ? Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            CustomeText(text: "* MLM for master label missing", fontColor: MyColor.colorRed, fontSize: SizeConfig.textMultiplier * 1.2, fontWeight: FontWeight.w500, textAlign: TextAlign.start),
                                            SizedBox(height: 5,),
                                            CustomeText(text: "* MLH for house label missing", fontColor: MyColor.colorRed, fontSize: SizeConfig.textMultiplier * 1.2, fontWeight: FontWeight.w500, textAlign: TextAlign.start),
                                          ],
                                        ) : Container()*/
                                      ],
                                    ),
                                  ),

                                 /* !_isFoundCargoChecked ? Column(
                                    children: [
                                      Container(
                                        padding : EdgeInsets.all(10),
                                        margin: const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 0),
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
                                            Directionality(
                                              textDirection: uiDirection,
                                              child: CustomTextField(
                                                controller: scanMAWBNoController,
                                                focusNode: scanMAWBNoFocusNode,
                                                onPress: () {},
                                                hasIcon: false,
                                                hastextcolor: true,
                                                animatedLabel: true,
                                                needOutlineBorder: true,
                                                labelText: "Scan MAWB No.",
                                                readOnly: false,
                                                onChanged: (value) {},
                                                fillColor:  Colors.grey.shade100,
                                                textInputType:
                                                TextInputType.text,
                                                inputAction:
                                                TextInputAction.next,
                                                hintTextcolor:
                                                Colors.black45,
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
                                            SizedBox(height: SizeConfig.blockSizeVertical * 0.8,),
                                            Directionality(
                                              textDirection: uiDirection,
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  CustomeText(text: "MAWB No.", fontColor: MyColor.colorBlack, fontSize: SizeConfig.textMultiplier * SizeUtils.MEDIUMTEXTSIZE, fontWeight: FontWeight.w500, textAlign: TextAlign.start),
                                                  SizedBox(width: SizeConfig.blockSizeHorizontal * SizeUtils.BUTTONHORIZONTALSIZE,),
                                                  Expanded(
                                                    flex : 2,
                                                    child: Container(
                                                      height: SizeConfig.blockSizeVertical * SizeUtils.BOXHEIGHT,
                                                      padding: EdgeInsets.symmetric(vertical: SizeConfig.blockSizeVertical * 0.2, horizontal: SizeConfig.blockSizeHorizontal * SizeUtils.WIDTH2),
                                                      decoration: BoxDecoration(
                                                        color: MyColor.colorWhite,
                                                        borderRadius: BorderRadius.circular(8),
                                                        border: Border.all(color: MyColor.colorBlack, width: 0.1),
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color: MyColor.colorBlack.withOpacity(0.09),
                                                            spreadRadius: 2,
                                                            blurRadius: 15,
                                                            offset: Offset(0, 3), // changes position of shadow
                                                          ),
                                                        ],
                                                      ),
                                                      child: DropdownButton<String>(
                                                        value: selectedMawbItem,
                                                        hint:  CustomeText(text: "Select", fontColor: MyColor.colorBlack, fontSize: SizeConfig.textMultiplier * SizeUtils.MEDIUMTEXTSIZE, fontWeight: FontWeight.w500, textAlign: TextAlign.start),
                                                        items: listOfmawbNo().map((String item) {
                                                          return DropdownMenuItem<String>(
                                                            value: item,
                                                            child:  CustomeText(text: item, fontColor: MyColor.colorBlack, fontSize: SizeConfig.textMultiplier * SizeUtils.MEDIUMTEXTSIZE, fontWeight: FontWeight.w500, textAlign: TextAlign.start),
                                                          );
                                                        }).toList(),
                                                        onChanged: (String? value) {
                                                          setState(() {
                                                            selectedMawbItem = value;
                                                          });
                                                        },
                                                        underline: SizedBox(), // Removes the default underline
                                                        isExpanded: true,
                                                        dropdownColor: Colors.white,
                                                        icon: Icon(Icons.arrow_drop_down, color: Colors.black45),
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        padding : EdgeInsets.all(10),
                                        margin: const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 0),
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
                                            Directionality(
                                              textDirection: uiDirection,
                                              child: CustomTextField(
                                                controller: scanHAWBNoController,
                                                focusNode: scanHAWBNoFocusNode,
                                                onPress: () {},
                                                hasIcon: false,
                                                hastextcolor: true,
                                                animatedLabel: true,
                                                needOutlineBorder: true,
                                                labelText: "Scan HAWB No.",
                                                readOnly: false,
                                                onChanged: (value) {},
                                                fillColor:  Colors.grey.shade100,
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
                                            SizedBox(height: SizeConfig.blockSizeVertical * 0.8,),
                                            Directionality(
                                              textDirection: uiDirection,
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  CustomeText(text: "HAWB No.", fontColor: MyColor.colorBlack, fontSize: SizeConfig.textMultiplier * SizeUtils.MEDIUMTEXTSIZE, fontWeight: FontWeight.w500, textAlign: TextAlign.start),
                                                  SizedBox(width: SizeConfig.blockSizeHorizontal * SizeUtils.BUTTONHORIZONTALSIZE,),
                                                  Expanded(
                                                    flex : 2,
                                                    child: Container(
                                                      height: SizeConfig.blockSizeVertical * SizeUtils.BOXHEIGHT,
                                                      padding: EdgeInsets.symmetric(vertical: SizeConfig.blockSizeVertical * 0.2, horizontal: SizeConfig.blockSizeHorizontal * SizeUtils.WIDTH2),
                                                      decoration: BoxDecoration(
                                                        color: MyColor.colorWhite,
                                                        borderRadius: BorderRadius.circular(8),
                                                        border: Border.all(color: MyColor.colorBlack, width: 0.1),
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color: MyColor.colorBlack.withOpacity(0.09),
                                                            spreadRadius: 2,
                                                            blurRadius: 15,
                                                            offset: Offset(0, 3), // changes position of shadow
                                                          ),
                                                        ],
                                                      ),
                                                      child: DropdownButton<String>(
                                                        value: selectedHawbItem,
                                                        hint:  CustomeText(text: "Select", fontColor: MyColor.colorBlack, fontSize: SizeConfig.textMultiplier * SizeUtils.MEDIUMTEXTSIZE, fontWeight: FontWeight.w500, textAlign: TextAlign.start),
                                                        items: listOfhawbNo().map((String item) {
                                                          return DropdownMenuItem<String>(
                                                            value: item,
                                                            child:  CustomeText(text: item, fontColor: MyColor.colorBlack, fontSize: SizeConfig.textMultiplier * SizeUtils.MEDIUMTEXTSIZE, fontWeight: FontWeight.w500, textAlign: TextAlign.start),
                                                          );
                                                        }).toList(),
                                                        onChanged: (String? value) {
                                                          setState(() {
                                                            selectedHawbItem = value;
                                                          });
                                                        },
                                                        underline: SizedBox(), // Removes the default underline
                                                        isExpanded: true,
                                                        dropdownColor: Colors.white,
                                                        icon: Icon(Icons.arrow_drop_down, color: Colors.black45),
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ) : SizedBox(),*/

                                /*  _isFoundCargoChecked ? Container(
                                    padding : EdgeInsets.all(10),
                                    margin: const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 0),
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
                                        Directionality(
                                          textDirection: uiDirection,
                                          child: CustomTextField(
                                            controller: mAWBNoController,
                                            focusNode: mAWBNoFocusNode,
                                            onPress: () {},
                                            hasIcon: false,
                                            hastextcolor: true,
                                            animatedLabel: true,
                                            needOutlineBorder: true,
                                            labelText: "MAWB No.",

                                            readOnly: false,
                                            onChanged: (value) {},
                                            fillColor:  Colors.grey.shade100,
                                            textInputType:
                                            TextInputType.text,
                                            inputAction:
                                            TextInputAction.next,
                                            hintTextcolor:
                                            Colors.black45,
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
                                        SizedBox(height: SizeConfig.blockSizeVertical * SizeUtils.HEIGHT_1_5,),
                                        Directionality(
                                          textDirection: uiDirection,
                                          child: CustomTextField(
                                            controller: hAWBNoController,
                                            focusNode: hAWBNoFocusNode,
                                            onPress: () {},
                                            hasIcon: false,
                                            hastextcolor: true,
                                            animatedLabel: true,
                                            needOutlineBorder: true,
                                            labelText: "HAWB No.",
                                            readOnly: false,
                                            onChanged: (value) {},
                                            fillColor:  Colors.grey.shade100,
                                            textInputType:
                                            TextInputType.text,
                                            inputAction:
                                            TextInputAction.next,
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
                                  ) : SizedBox(),*/

                                  Container(
                                    padding: const EdgeInsets.all(10),
                                    margin: const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 0),
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
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        CustomeText(
                                            text: "${lableModel.pieces}",
                                            fontColor: MyColor.colorBlack,
                                            fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_2_0,
                                            fontWeight: FontWeight.w600,
                                            textAlign: TextAlign.start),

                                        SizedBox(height: SizeConfig.blockSizeVertical * SizeUtils.HEIGHT_1_5,),
                                        // text manifest and recived in pices text counter
                                        Row(
                                          children: [
                                            Expanded(
                                              flex: 1,
                                              child: Directionality(
                                                textDirection: uiDirection,
                                                child: CustomTextField(
                                                  controller: manifestedNopController,
                                                  focusNode: manifestedNopFocusNode,
                                                  onPress: () {},
                                                  hasIcon: false,
                                                  hastextcolor: true,
                                                  animatedLabel: true,
                                                  needOutlineBorder: true,
                                                  labelText: "Manifested",
                                                  readOnly: false,
                                                  onChanged: (value) {},
                                                  fillColor:  Colors.grey.shade100,
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
                                              ),),
                                            SizedBox(width: SizeConfig.blockSizeHorizontal * SizeUtils.WIDTH2,),
                                            Expanded(
                                              flex: 1,
                                              child: Directionality(
                                                textDirection: uiDirection,
                                                child: CustomTextField(
                                                  controller: receivedNopController,
                                                  focusNode: receivedNopFocusNode,
                                                  onPress: () {},
                                                  hasIcon: false,
                                                  hastextcolor: true,
                                                  animatedLabel: true,
                                                  needOutlineBorder: true,
                                                  labelText: "Received",
                                                  readOnly: false,
                                                  onChanged: (value) {},
                                                  fillColor:  Colors.grey.shade100,
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
                                              ),),
                                            SizedBox(width: SizeConfig.blockSizeHorizontal * SizeUtils.WIDTH2,),
                                            Expanded(
                                              flex: 1,
                                              child: Directionality(
                                                textDirection: uiDirection,
                                                child: CustomTextField(
                                                  controller: remainingNopController,
                                                  focusNode: remainingNopFocusNode,
                                                  onPress: () {},
                                                  hasIcon: false,
                                                  hastextcolor: true,
                                                  animatedLabel: true,
                                                  needOutlineBorder: true,
                                                  labelText: "Remaining",
                                                  readOnly: false,
                                                  onChanged: (value) {},
                                                  fillColor:  Colors.grey.shade100,
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
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),


                                  Container(
                                    padding: EdgeInsets.all(10),
                                    margin: const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 0),
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
                                        Row(
                                          children: [
                                            Expanded(
                                              flex:1,
                                              child: Directionality(
                                                textDirection: uiDirection,
                                                child: CustomTextField(
                                                  controller: groupIdController,
                                                  focusNode: groupIdFocusNode,
                                                  onPress: () {},
                                                  hasIcon: false,
                                                  hastextcolor: true,
                                                  animatedLabel: true,
                                                  needOutlineBorder: true,
                                                  labelText: "Group Id",
                                                  readOnly: false,
                                                  onChanged: (value) {},
                                                  fillColor: Colors.grey.shade100,
                                                  textInputType:
                                                  TextInputType.text,
                                                  inputAction:
                                                  TextInputAction.next,
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
                                            SizedBox(width: SizeConfig.blockSizeHorizontal * 1.5,),
                                            Expanded(
                                              flex: 1,
                                              child: Directionality(
                                                textDirection: uiDirection,
                                                child: CustomTextField(
                                                  controller: arrivedNoPController,
                                                  focusNode: arrivedNoPFocusNode,
                                                  onPress: () {},
                                                  hasIcon: false,
                                                  hastextcolor: true,
                                                  animatedLabel: true,
                                                  needOutlineBorder: true,
                                                  labelText: "Arrived NoP",
                                                  readOnly: false,
                                                  onChanged: (value) {},
                                                  fillColor:  Colors.grey.shade100,
                                                  textInputType:
                                                  TextInputType.text,
                                                  inputAction:
                                                  TextInputAction.next,
                                                  hintTextcolor:
                                                  Colors.black45,
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
                                        SizedBox(height: SizeConfig.blockSizeVertical * SizeUtils.HEIGHT_1_5,),
                                        Row(
                                          children: [
                                            Expanded(
                                                flex:2,
                                                child: CustomeText(text: "Damage NoP", fontColor: MyColor.colorBlack, fontSize: SizeConfig.textMultiplier * SizeUtils.MEDIUMTEXTSIZE, fontWeight: FontWeight.w500, textAlign: TextAlign.start)),
                                            Expanded(
                                              flex: 1,
                                              child: Directionality(
                                                textDirection: uiDirection,
                                                child: CustomTextField(
                                                  controller: damageNoPController,
                                                  focusNode: damageNoPFocusNode,
                                                  onPress: () {},
                                                  hasIcon: false,
                                                  hastextcolor: true,
                                                  animatedLabel: false,
                                                  needOutlineBorder: true,
                                                  readOnly: false,
                                                  onChanged: (value) {},
                                                  fillColor:  Colors.grey.shade100,
                                                  textInputType:
                                                  TextInputType.text,
                                                  inputAction:
                                                  TextInputAction.next,
                                                  hintTextcolor:
                                                  Colors.black45,
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
                                            SizedBox(width: SizeConfig.blockSizeHorizontal * 1.5,),
                                            Expanded(
                                              flex: 1,
                                              child: Directionality(
                                                textDirection: uiDirection,
                                                child: CustomTextField(
                                                  controller: damageNoP1Controller,
                                                  focusNode: damage1NoPFocusNode,
                                                  onPress: () {},
                                                  hasIcon: false,
                                                  hastextcolor: true,
                                                  animatedLabel: false,
                                                  needOutlineBorder: true,
                                                  readOnly: true,
                                                  onChanged: (value) {},
                                                  fillColor:  Colors.grey.shade300,
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
                                            ),

                                          ],
                                        ),
                                        SizedBox(height: SizeConfig.blockSizeVertical * SizeUtils.HEIGHT_1_5,),
                                        Row(
                                          children: [
                                            Expanded(
                                                flex:2,
                                                child: CustomeText(text: "Damage Weight", fontColor: MyColor.colorBlack, fontSize: SizeConfig.textMultiplier * SizeUtils.MEDIUMTEXTSIZE, fontWeight: FontWeight.w500, textAlign: TextAlign.start)),
                                            Expanded(
                                              flex: 1,
                                              child: Directionality(
                                                textDirection: uiDirection,
                                                child: CustomTextField(
                                                  controller: damageWeightController,
                                                  focusNode: damageWeightFocusNode,
                                                  onPress: () {},
                                                  hasIcon: false,
                                                  hastextcolor: true,
                                                  animatedLabel: false,
                                                  needOutlineBorder: true,
                                                  readOnly: false,
                                                  onChanged: (value) {},
                                                  fillColor:  Colors.grey.shade100,
                                                  textInputType:
                                                  TextInputType.text,
                                                  inputAction:
                                                  TextInputAction.next,
                                                  hintTextcolor:
                                                  Colors.black45,
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
                                            SizedBox(width: SizeConfig.blockSizeHorizontal * 1.5,),
                                            Expanded(
                                              flex: 1,
                                              child: Directionality(
                                                textDirection: uiDirection,
                                                child: CustomTextField(
                                                  controller: damageWeight1Controller,
                                                  focusNode: damageWeight1FocusNode,
                                                  onPress: () {},
                                                  hasIcon: false,
                                                  hastextcolor: true,
                                                  animatedLabel: false,
                                                  needOutlineBorder: true,
                                                  readOnly: true,
                                                  onChanged: (value) {},
                                                  fillColor:  Colors.grey.shade300,
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
                                            ),

                                          ],
                                        ),
                                        SizedBox(height: SizeConfig.blockSizeVertical * SizeUtils.HEIGHT_1_5,),
                                        Directionality(
                                          textDirection: uiDirection,
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              CustomeText(text: "Damage Type", fontColor: MyColor.colorBlack, fontSize: SizeConfig.textMultiplier * SizeUtils.MEDIUMTEXTSIZE, fontWeight: FontWeight.w500, textAlign: TextAlign.start),
                                              SizedBox(width: SizeConfig.blockSizeHorizontal * SizeUtils.BUTTONHORIZONTALSIZE,),
                                              Expanded(
                                                flex : 1,
                                                child: Container(
                                                  height: SizeConfig.blockSizeVertical * SizeUtils.BOXHEIGHT,
                                                  padding: EdgeInsets.symmetric(vertical: SizeConfig.blockSizeVertical * 0.2, horizontal: SizeConfig.blockSizeHorizontal *2),
                                                  decoration: BoxDecoration(
                                                    color: MyColor.colorWhite,
                                                    borderRadius: BorderRadius.circular(8),
                                                    border: Border.all(color: MyColor.colorBlack, width: 0.1),
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: MyColor.colorBlack.withOpacity(0.09),
                                                        spreadRadius: 2,
                                                        blurRadius: 15,
                                                        offset: Offset(0, 3), // changes position of shadow
                                                      ),
                                                    ],
                                                  ),
                                                  child: DropdownButton<String>(
                                                    value: selectedHawbItem,
                                                    hint:  CustomeText(text: "Select", fontColor: MyColor.colorBlack, fontSize: SizeConfig.textMultiplier * SizeUtils.MEDIUMTEXTSIZE, fontWeight: FontWeight.w500, textAlign: TextAlign.start),
                                                    items: listOfhawbNo().map((String item) {
                                                      return DropdownMenuItem<String>(
                                                        value: item,
                                                        child:  CustomeText(text: item, fontColor: MyColor.colorBlack, fontSize: SizeConfig.textMultiplier * SizeUtils.MEDIUMTEXTSIZE, fontWeight: FontWeight.w500, textAlign: TextAlign.start),
                                                      );
                                                    }).toList(),
                                                    onChanged: (String? value) {
                                                      setState(() {
                                                        selectedHawbItem = value;
                                                      });
                                                    },
                                                    underline: SizedBox(), // Removes the default underline
                                                    isExpanded: true,
                                                    dropdownColor: Colors.white,
                                                    icon: Icon(Icons.arrow_drop_down, color: Colors.black45),
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        SizedBox(height: SizeConfig.blockSizeVertical * SizeUtils.HEIGHT_1_5,),
                                        RoundedButtonBlue(
                                          text: "Submit",verticalPadding : SizeConfig.blockSizeVertical * SizeUtils.BUTTONVERTICALSIZE ,
                                          press: () {

                                          },)
                                      ],
                                    ),
                                  )


                                ],
                              ),
                            ))
                      ],
                    ),
                                    ),
                                  ),
                  )),

            ],
          ),
        )),
      ),
    );
  }
}
