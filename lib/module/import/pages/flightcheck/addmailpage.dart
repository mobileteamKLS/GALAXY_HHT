import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:galaxy/utils/awbformatenumberutils.dart';
import 'package:galaxy/utils/sizeutils.dart';
import 'package:galaxy/widget/customebuttons/roundbuttonblue.dart';
import 'package:galaxy/widget/custometext.dart';
import 'package:vibration/vibration.dart';

import '../../../../core/images.dart';
import '../../../../core/mycolor.dart';
import '../../../../language/appLocalizations.dart';
import '../../../../language/model/lableModel.dart';
import 'dart:ui' as ui;

import '../../../../manager/timermanager.dart';
import '../../../../prefrence/savedprefrence.dart';
import '../../../../utils/commonutils.dart';
import '../../../../utils/dialogutils.dart';
import '../../../../utils/snackbarutil.dart';
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
import '../../model/flightcheck/maildetailmodel.dart';
import '../../services/flightcheck/flightchecklogic/flightcheckcubit.dart';
import '../../services/flightcheck/flightchecklogic/flightcheckstate.dart';

class AddMailPage extends StatefulWidget {

  LableModel? lableModel;
  int uldSeqNo;
  int flightSeqNo;
  String mainMenuName;
  int menuId;
  String uldNo;
  AddMailPage({super.key, required this.uldNo, required this.mainMenuName, required this.uldSeqNo, required this.flightSeqNo, required this.menuId, required this.lableModel});

  @override
  State<AddMailPage> createState() => _AddMailPageState();
}

class _AddMailPageState extends State<AddMailPage> {

  InactivityTimerManager? inactivityTimerManager;

  final SavedPrefrence savedPrefrence = SavedPrefrence();
  UserDataModel? _user;
  SplashDefaultModel? _splashDefaultData;


  List<AddMailDetailsList>? addMailDetailsList = [];
  List<String> jobTypeModelList = [ "A", "B", "C", "D"];
  String? selectedJobType;



  TextEditingController av7NoController = TextEditingController();
  TextEditingController originController = TextEditingController();
  TextEditingController destinationController = TextEditingController();

  TextEditingController nopController = TextEditingController();
  TextEditingController weightController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();


  FocusNode av7NoFocusNode = FocusNode();
  FocusNode originFocusNode = FocusNode();
  FocusNode destinationFocusNode = FocusNode();

  FocusNode nopFocusNode = FocusNode();
  FocusNode weightFocusNode = FocusNode();
  FocusNode descriptionFocusNode = FocusNode();



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadUser();



  }


  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    inactivityTimerManager!.stopTimer();
  }


  Future<void> _loadUser() async {
    final user = await savedPrefrence.getUserData();
    final splashDefaultData = await savedPrefrence.getSplashDefaultData();
    if (user != null && splashDefaultData != null) {
      setState(() {
        _user = user;
        _splashDefaultData = splashDefaultData;
      });

      context.read<FlightCheckCubit>().getMailDetail(widget.flightSeqNo, widget.uldSeqNo, _user!.userProfile!.userIdentity!, _splashDefaultData!.companyCode!, widget.menuId);



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
                    child: Container(decoration: BoxDecoration(
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
                            titleTextColor: MyColor.colorBlack,
                            title: "Add Mail",
                            onBack: () {
                              Navigator.pop(context, "Done");
                            },
                            clearText: lableModel!.clear,
                            onClear: () {
                              setState(() {

                              });
                              av7NoController.clear();
                              selectedJobType = null;
                              originController.clear();
                              descriptionController.clear();
                              nopController.clear();
                              weightController.clear();
                              descriptionController.clear();

                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                FocusScope.of(context).requestFocus(av7NoFocusNode);
                              },
                              );
                            },
                          ),
                        ),

                        BlocListener<FlightCheckCubit, FlightCheckState>(listener: (context, state) {
                          if (state is MainInitialState) {
                          }
                          else if (state is MainLoadingState) {
                            // showing loading dialog in this state
                            DialogUtils.showLoadingDialog(context, message: lableModel.loading);
                          }
                          else if (state is GetMailDetailSuccessState){

                            if(state.mailDetailModel.status == "E"){
                              DialogUtils.hideLoadingDialog(context);
                              Vibration.vibrate(duration: 500);
                              SnackbarUtil.showSnackbar(context, state.mailDetailModel.statusMessage!, MyColor.colorRed, icon: FontAwesomeIcons.times);
                            }else{
                              DialogUtils.hideLoadingDialog(context);
                              addMailDetailsList = List.from(state.mailDetailModel.addMailDetailsList!);

                              av7NoController.clear();
                              selectedJobType = null;
                              originController.clear();
                              descriptionController.clear();
                              nopController.clear();
                              weightController.clear();
                              descriptionController.clear();

                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                FocusScope.of(context).requestFocus(av7NoFocusNode);
                              },
                              );
                              setState(() {});
                            }
                          }
                          else if (state is GetMailDetailFailureState){
                            DialogUtils.hideLoadingDialog(context);
                            Vibration.vibrate(duration: 500);
                            SnackbarUtil.showSnackbar(context, state.error, MyColor.colorRed, icon: FontAwesomeIcons.times);
                          }
                          else if (state is AddMailSuccessState){
                            DialogUtils.hideLoadingDialog(context);
                            if(state.addMailModel.status == "E"){
                              Vibration.vibrate(duration: 500);
                              SnackbarUtil.showSnackbar(context, state.addMailModel.statusMessage!, MyColor.colorRed, icon: FontAwesomeIcons.times);
                            }else{
                              Vibration.vibrate(duration: 500);
                              SnackbarUtil.showSnackbar(context, state.addMailModel.statusMessage!, MyColor.colorGreen, icon: Icons.done);

                              context.read<FlightCheckCubit>().getMailDetail(widget.flightSeqNo, widget.uldSeqNo, _user!.userProfile!.userIdentity!, _splashDefaultData!.companyCode!, widget.menuId);


                            }
                          }else if(state is AddMAilFailureState){
                            DialogUtils.hideLoadingDialog(context);
                            Vibration.vibrate(duration: 500);
                            SnackbarUtil.showSnackbar(context, state.error, MyColor.colorRed, icon: FontAwesomeIcons.times);
                          }
                        },
                        child: Expanded(
                            child: SingleChildScrollView(
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 10,
                                    right: 10,
                                    top: 0,
                                    bottom: 0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [

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
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Directionality(
                                            textDirection: uiDirection,
                                            child: Row(
                                              children: [
                                                SvgPicture.asset(info, height: SizeConfig.blockSizeVertical * SizeUtils.ICONSIZE2,),
                                                SizedBox(width: SizeConfig.blockSizeHorizontal,),
                                                CustomeText(
                                                    text: "Add Mail for this ${widget.uldNo}",
                                                    fontColor: MyColor.textColorGrey2,
                                                    fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                                    fontWeight: FontWeight.w500,
                                                    textAlign: TextAlign.start)
                                              ],
                                            ),
                                          ),


                                          SizedBox(height: SizeConfig.blockSizeVertical * SizeUtils.HEIGHT2),
                                          // text manifest and recived in pices text counter

                                          Directionality(
                                            textDirection: uiDirection,
                                            child: CustomTextField(
                                              controller: av7NoController,
                                              focusNode: av7NoFocusNode,
                                              onPress: () {},
                                              hasIcon: false,
                                              hastextcolor: true,
                                              animatedLabel: true,
                                              needOutlineBorder: true,
                                              labelText: "AV7 No *",
                                              readOnly: false,
                                              onChanged: (value) {},
                                              fillColor:  Colors.grey.shade100,
                                              textInputType: TextInputType.number,
                                              inputAction: TextInputAction.next,
                                              hintTextcolor: Colors.black45,
                                              verticalPadding: 0,
                                              maxLength: 12,
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

                                          SizedBox(height: SizeConfig.blockSizeVertical,),

                                          Directionality(
                                            textDirection: uiDirection,
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                CustomeText(text: "Mail Type", fontColor: MyColor.colorBlack, fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5, fontWeight: FontWeight.w500, textAlign: TextAlign.start),
                                                SizedBox(width: SizeConfig.blockSizeHorizontal * SizeUtils.BUTTONHORIZONTALSIZE,),
                                                Expanded(
                                                  flex : 2,
                                                  child: Container(
                                                    padding: EdgeInsets.symmetric(
                                                      vertical: SizeConfig.blockSizeVertical * 0.1,
                                                      horizontal: SizeConfig.blockSizeHorizontal * SizeUtils.WIDTH2,
                                                    ),
                                                    decoration: BoxDecoration(
                                                      color: MyColor.colorWhite,
                                                      border: Border.all(color: Colors.black, width: 0.1),
                                                      borderRadius: BorderRadius.circular(
                                                        SizeConfig.blockSizeHorizontal * SizeUtils.ICONSIZE2,
                                                      ),
                                                    ),
                                                    child: DropdownButton<String>(
                                                      value: selectedJobType,
                                                      hint: CustomeText(
                                                        text: "Select",
                                                        fontColor: MyColor.colorBlack,
                                                        fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                                        fontWeight: FontWeight.w500,
                                                        textAlign: TextAlign.start,
                                                      ),
                                                      items: jobTypeModelList.map((String item) {
                                                        return DropdownMenuItem<String>(
                                                          value: item,
                                                          child: CustomeText(
                                                            text: item,
                                                            fontColor: MyColor.colorBlack,
                                                            fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                                            fontWeight: FontWeight.w500,
                                                            textAlign: TextAlign.start,
                                                          ),
                                                        );
                                                      }).toList(),
                                                      onChanged: (String? value) {
                                                        setState(() {
                                                          selectedJobType = value!;
                                                        });
                                                      },
                                                      underline: SizedBox(),
                                                      isExpanded: true,
                                                      dropdownColor: Colors.white,
                                                      icon: Icon(Icons.arrow_drop_down, color: Colors.black45),
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),

                                          SizedBox(height: SizeConfig.blockSizeVertical * SizeUtils.HEIGHT2,),

                                          Row(
                                            children: [
                                              Expanded(
                                                flex:1,
                                                child: Directionality(
                                                  textDirection: uiDirection,
                                                  child: CustomTextField(
                                                    controller: originController,
                                                    focusNode: originFocusNode,
                                                    onPress: () {},
                                                    hasIcon: false,
                                                    hastextcolor: true,
                                                    animatedLabel: true,
                                                    needOutlineBorder: true,
                                                    labelText: "Origin *",
                                                    readOnly: false,
                                                    onChanged: (value) {},
                                                    fillColor:  Colors.grey.shade100,
                                                    textInputType: TextInputType.text,
                                                    inputAction: TextInputAction.next,
                                                    hintTextcolor: Colors.black45,
                                                    verticalPadding: 0,
                                                    maxLength: 3,
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
                                              ),
                                              SizedBox(width: SizeConfig.blockSizeHorizontal * SizeUtils.WIDTH2,),
                                              Expanded(
                                                flex: 1,
                                                child: Directionality(
                                                  textDirection: uiDirection,
                                                  child: CustomTextField(
                                                    controller: destinationController,
                                                    focusNode: destinationFocusNode,
                                                    onPress: () {},
                                                    hasIcon: false,
                                                    hastextcolor: true,
                                                    animatedLabel: true,
                                                    needOutlineBorder: true,
                                                    labelText: "Destination *",
                                                    readOnly: false,
                                                    onChanged: (value) {},
                                                    fillColor:  Colors.grey.shade100,
                                                    textInputType: TextInputType.text,
                                                    inputAction: TextInputAction.next,
                                                    hintTextcolor: Colors.black45,
                                                    verticalPadding: 0,
                                                    maxLength: 3,
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
                                              ),
                                            ],
                                          ),

                                          SizedBox(height: SizeConfig.blockSizeVertical * SizeUtils.HEIGHT2,),
                                          Row(
                                            children: [
                                              Expanded(
                                                flex:1,
                                                child: Directionality(
                                                  textDirection: uiDirection,
                                                  child: CustomTextField(
                                                    controller: nopController,
                                                    focusNode: nopFocusNode,
                                                    onPress: () {},
                                                    hasIcon: false,
                                                    hastextcolor: true,
                                                    animatedLabel: true,
                                                    needOutlineBorder: true,
                                                    labelText: "NoP *",
                                                    readOnly: false,
                                                    onChanged: (value) {},
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
                                              ),
                                              SizedBox(width: SizeConfig.blockSizeHorizontal * SizeUtils.WIDTH2,),
                                              Expanded(
                                                flex: 1,
                                                child: Directionality(
                                                  textDirection: uiDirection,
                                                  child: CustomTextField(
                                                    controller: weightController,
                                                    focusNode: weightFocusNode,
                                                    onPress: () {},
                                                    hasIcon: false,
                                                    hastextcolor: true,
                                                    animatedLabel: true,
                                                    needOutlineBorder: true,
                                                    labelText: "Weight *",
                                                    readOnly: false,
                                                    onChanged: (value) {},
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
                                              ),
                                            ],
                                          ),

                                          SizedBox(height: SizeConfig.blockSizeVertical * SizeUtils.HEIGHT2,),
                                          Directionality(
                                            textDirection: uiDirection,
                                            child: CustomTextField(
                                              controller: descriptionController,
                                              focusNode: descriptionFocusNode,
                                              onPress: () {},
                                              hasIcon: false,
                                              hastextcolor: true,
                                              animatedLabel: true,
                                              needOutlineBorder: true,
                                              labelText: "Description",
                                              readOnly: false,
                                              onChanged: (value) {},
                                              fillColor:  Colors.grey.shade100,
                                              textInputType: TextInputType.text,
                                              inputAction: TextInputAction.next,
                                              hintTextcolor: Colors.black45,
                                              maxLines: 2,
                                              verticalPadding: SizeConfig.blockSizeVertical * SizeUtils.HEIGHT2,
                                              fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_8,
                                              circularCorner: SizeConfig.blockSizeHorizontal * SizeUtils.CIRCULARCORNER,
                                              boxHeight: SizeConfig.blockSizeVertical * SizeUtils.HEIGHT8,
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
                                    SizedBox(
                                      height: SizeConfig.blockSizeVertical,
                                    ),
                                    Container(
                                      padding: EdgeInsets.all(10),
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
                                              text: "${lableModel.back}",
                                              press: () async {
                                                _onWillPop();
                                              },
                                            ),
                                          ),
                                          SizedBox(
                                            width: SizeConfig.blockSizeHorizontal * SizeUtils.WIDTH4,
                                          ),
                                          Expanded(
                                            flex: 1,
                                            child: RoundedButtonBlue(
                                              text: "${lableModel.save}",

                                              press: () async {

                                                print("MAILTYPE === ${selectedJobType}");

                                               /* if(av7NoController.text.isNotEmpty){
                                                  if(originController.text.isNotEmpty){
                                                    if(destinationController.text.isNotEmpty){
                                                      if(originController.text.contains(destinationController.text)){
                                                        if(nopController.text.isNotEmpty){
                                                          if(weightController.text.isNotEmpty){

                                                            if(selectedJobType == null){
                                                              SnackbarUtil.showSnackbar(context, "Please select mil type", MyColor.colorRed, icon: FontAwesomeIcons.times);
                                                            }else{

                                                            }
                                                          }else{
                                                            openValidationDialog("Please enter weight", weightFocusNode);
                                                          }
                                                        }
                                                        else{
                                                          openValidationDialog("Please enter NoP", nopFocusNode);
                                                        }
                                                      }else{
                                                        openValidationDialog("Origin & Destination are same", destinationFocusNode);
                                                      }
                                                    }else{
                                                      openValidationDialog("Please enter destination", destinationFocusNode);
                                                    }
                                                  }else{
                                                    openValidationDialog("Please enter origin.", originFocusNode);
                                                  }
                                                }else{
                                                  openValidationDialog("Please enter Av7 No.", av7NoFocusNode);
                                                }*/


                                                if (av7NoController.text.isEmpty) {
                                                  openValidationDialog("Please enter Av7 No.", av7NoFocusNode);
                                                  return;
                                                }

                                                if (originController.text.isEmpty) {
                                                  openValidationDialog("Please enter origin.", originFocusNode);
                                                  return;
                                                }

                                                if (destinationController.text.isEmpty) {
                                                  openValidationDialog("Please enter destination", destinationFocusNode);
                                                  return;
                                                }

                                                if (originController.text == destinationController.text) {
                                                  openValidationDialog("Origin & Destination are the same", destinationFocusNode);
                                                  return;
                                                }

                                                if (nopController.text.isEmpty) {
                                                  openValidationDialog("Please enter NoP", nopFocusNode);
                                                  return;
                                                }

                                                if (weightController.text.isEmpty) {
                                                  openValidationDialog("Please enter weight", weightFocusNode);
                                                  return;
                                                }

                                                if (selectedJobType == null) {
                                                  SnackbarUtil.showSnackbar(
                                                    context,
                                                    "Please select mail type",
                                                    MyColor.colorRed,
                                                    icon: FontAwesomeIcons.times,
                                                  );
                                                  return;
                                                }

                                                // If all validations pass, proceed with further actions here
                                                // Your further logic goes here...

                                                context.read<FlightCheckCubit>().addMail(widget.flightSeqNo, widget.uldSeqNo, av7NoController.text, selectedJobType!, originController.text, destinationController.text, int.parse(nopController.text), double.parse(weightController.text), descriptionController.text,_user!.userProfile!.userIdentity!, _splashDefaultData!.companyCode!, widget.menuId);


                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                    SizedBox(
                                      height: SizeConfig.blockSizeVertical,
                                    ),
                                    Directionality(
                                      textDirection: textDirection,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(left: 12, right: 12,),
                                            child: CustomeText(text: "Mail Total List (${addMailDetailsList!.length})", fontColor: MyColor.colorBlack, fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5, fontWeight: FontWeight.w500, textAlign: TextAlign.start),
                                          ),
                                          (addMailDetailsList!.isNotEmpty)
                                              ? ListView.builder(
                                            physics: NeverScrollableScrollPhysics(),
                                            shrinkWrap: true,
                                            itemCount: addMailDetailsList!.length,
                                            itemBuilder: (context, index) {
                                              AddMailDetailsList addMailDetails = addMailDetailsList![index];


                                              return Padding(
                                                padding: const EdgeInsets.only(left: 12, right: 12, top: 4, bottom: 4),
                                                child: Container(
                                                  padding: const EdgeInsets.all(12),
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
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        children: [
                                                          CustomeText(
                                                              text: "${addMailDetails.aV7No}",
                                                              fontColor: MyColor.colorBlack,
                                                              fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                                              fontWeight: FontWeight.w600,
                                                              textAlign: TextAlign.start),


                                                          Row(
                                                            children: [
                                                              CustomeText(
                                                                  text: "${addMailDetails.origin}",
                                                                  fontColor: MyColor.textColorGrey2,
                                                                  fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                                                  fontWeight: FontWeight.w400,
                                                                  textAlign: TextAlign.start),
                                                              SizedBox(width: SizeConfig.blockSizeHorizontal,),
                                                              SvgPicture.asset(arrival, height: SizeConfig.blockSizeVertical * SizeUtils.ICONSIZE2,),
                                                              SizedBox(width: SizeConfig.blockSizeHorizontal,),
                                                              CustomeText(
                                                                  text: "${addMailDetails.destination}",
                                                                  fontColor: MyColor.textColorGrey2,
                                                                  fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                                                  fontWeight: FontWeight.w400,
                                                                  textAlign: TextAlign.start),
                                                            ],
                                                          )



                                                        ],
                                                      ),
                                                      SizedBox(
                                                        height: SizeConfig.blockSizeVertical,
                                                      ),
                                                      Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        children: [
                                                          Row(
                                                            children: [
                                                              CustomeText(
                                                                text: "NoP",
                                                                fontColor: MyColor.textColorGrey2,
                                                                fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                                                fontWeight: FontWeight.w400,
                                                                textAlign: TextAlign.start,
                                                              ),
                                                              SizedBox(width: 5),
                                                              CustomeText(
                                                                text: "${addMailDetails.nOP}",
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
                                                                text: "Weight",
                                                                fontColor: MyColor.textColorGrey2,
                                                                fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                                                fontWeight: FontWeight.w400,
                                                                textAlign: TextAlign.start,
                                                              ),
                                                              SizedBox(width: 5),
                                                              CustomeText(
                                                                text: "${addMailDetails.weightKg}",
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
                                                                text: "Type",
                                                                fontColor: MyColor.textColorGrey2,
                                                                fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                                                fontWeight: FontWeight.w400,
                                                                textAlign: TextAlign.start,
                                                              ),
                                                              SizedBox(width: 5),
                                                              CustomeText(
                                                                text: "${addMailDetails.mailType}",
                                                                fontColor: MyColor.colorBlack,
                                                                fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                                                fontWeight: FontWeight.w600,
                                                                textAlign: TextAlign.start,
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              );
                                            },
                                          )
                                              : Center(
                                            child: Padding(
                                              padding:
                                              const EdgeInsets.symmetric(vertical: 20),
                                              child: CustomeText(
                                                  text: "${lableModel.recordNotFound}",
                                                  fontColor: MyColor.textColor,
                                                  fontSize: SizeConfig.textMultiplier * 2.1,
                                                  fontWeight: FontWeight.w500,
                                                  textAlign: TextAlign.center),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),


                                  ],
                                ),
                              ),
                            )),
                        )


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


  // validation dialog
  Future<void> openValidationDialog(String message, FocusNode focuseNode) async {
    bool? empty = await DialogUtils.showDataNotFoundDialogbot(
        context, "${message}", widget.lableModel!);

    if (empty == true) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        FocusScope.of(context).requestFocus(focuseNode);
      });
    }
  }

}
