import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:galaxy/utils/sizeutils.dart';
import 'package:galaxy/utils/validationmsgcodeutils.dart';
import 'package:galaxy/widget/customebuttons/roundbuttonblue.dart';
import 'package:galaxy/widget/customedrawer/customedrawer.dart';
import 'package:galaxy/widget/header/mainheadingwidget.dart';
import 'package:image/image.dart' as img; // Import the image package

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:galaxy/module/import/services/uldacceptance/uldacceptancelogic/uldacceptancestate.dart';
import 'package:galaxy/widget/custometext.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
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
import '../../../../widget/customeedittext/remarkedittextfeild.dart';
import '../../../../widget/customeuiwidgets/enlargedbinaryimagescreen.dart';
import '../../../../widget/customeuiwidgets/header.dart';
import '../../../login/pages/signinscreenmethods.dart';
import '../../../profile/page/profilepagescreen.dart';
import '../../../splash/model/splashdefaultmodel.dart';
import '../../../onboarding/sizeconfig.dart';
import '../../../login/model/userlogindatamodel.dart';
import '../../../submenu/model/submenumodel.dart';
import '../../model/uldacceptance/buttonrolesrightsmodel.dart';
import '../../model/uldacceptance/ulddamagelistmodel.dart';
import '../../model/uldacceptance/ulddamgeupdatemodel.dart';
import '../../services/uldacceptance/uldacceptancelogic/uldacceptancecubit.dart';

class UldDamagedPage extends StatefulWidget {
  // isRecordView == 0 - new record damage, 1 - view record damage, 2 - update record damage

  String? mainMenuName;
  int menuId;
  String locationCode;
  String ULDNo;
  int ULDSeqNo;
  int flightSeqNo;
  String groupId;
  String menuCode;
  int isRecordView;
  List<ButtonRight>? buttonRightsList = [];
  List<SubMenuName> importSubMenuList = [];
  List<SubMenuName> exportSubMenuList = [];

  UldDamagedPage(
      {super.key,
      required this.importSubMenuList,
      required this.exportSubMenuList,
      required this.locationCode,
      required this.menuId,
      required this.ULDNo,
      required this.ULDSeqNo,
      required this.flightSeqNo,
      required this.groupId,
      required this.menuCode,
      required this.isRecordView,
      this.mainMenuName,
      this.buttonRightsList});

  @override
  State<UldDamagedPage> createState() => _UldDamagedPageState();
}

class _UldDamagedPageState extends State<UldDamagedPage> {

  InactivityTimerManager? inactivityTimerManager;

  TextEditingController remarkController = TextEditingController();
  FocusNode remarkFocus = FocusNode();


  List<String> selectedDamageServices = [];
  List<String> selectImageBase64List = [];
  List<ULDDamage> damageList = [];

  bool _isUnserviceableEnable = false;
  String unServiceableCode = "";

  final SavedPrefrence savedPrefrence = SavedPrefrence();
  UserDataModel? _user;
  SplashDefaultModel? _splashDefaultData;

  final ScrollController _scrollController = ScrollController();
  String images = "";
  String imageCount = "0";


  Future<bool> _onWillPop() async {
    Navigator.pop(context, unServiceableCode);
    return false; // Prevents the default back button action
  }

  @override
  void initState() {
    super.initState();
    _loadUser(); //load user data
  }

  @override
  void dispose() {
    // Dispose all focus nodes
    inactivityTimerManager?.stopTimer(); // Stop the timer when the screen is disposed
    super.dispose();
  }

  Future<void> _loadUser() async {
    final user = await savedPrefrence.getUserData(); // get user data
    final splashDefaultData = await savedPrefrence.getSplashDefaultData(); // get company data
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
      inactivityTimerManager?.startTimer();  // Start the inactivity timer

      //call uldDamageServiceList api
      context.read<UldAcceptanceCubit>().uldDamageServiceList(
          _user!.userProfile!.userIdentity!,
          _splashDefaultData!.companyCode!,
          widget.menuId);
    }
  }

  bool _showFullList = false; // State to toggle between showing limited or full list



  Future<void> _handleInactivityTimeout() async {

    bool? activateORNot = await DialogUtils.showingActivateTimerDialog(context, _user!.userProfile!.userId!, _splashDefaultData!.companyCode!);
    print("CHECK_ACTIVATE_OR_NOT======DAMAGE ${activateORNot}");
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

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();



  @override
  Widget build(BuildContext context) {
    // get lablemodel for multilanguage
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
          child: GestureDetector(
            onTap: _resumeTimerOnInteraction,  // Resuming on any tap
            onPanDown: (details) => _resumeTimerOnInteraction(), // Resuming on any gesture
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
                    resizeToAvoidBottomInset: true,
                    body: NotificationListener<ScrollNotification>(
                      onNotification: (ScrollNotification scroll) {
                        _resumeTimerOnInteraction(); // Reset the timer on scroll event
                        return true;
                      },
                      child: Stack(
                        children: [
                          MainHeadingWidget(mainMenuName: widget.mainMenuName!,
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
                            child: Container(
                              decoration: BoxDecoration(
                                  color: MyColor.bgColorGrey,
                                  borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(SizeConfig.blockSizeVertical * SizeUtils.WIDTH2),
                                      topLeft: Radius.circular(SizeConfig.blockSizeVertical * SizeUtils.WIDTH2))),
                              child: Directionality(
                                textDirection: uiDirection,
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(left: 10, right: 15, top: 12, bottom: 12),
                                      child: HeaderWidget(
                                        title: lableModel!.damagedULD!,
                                        titleTextColor: MyColor.colorBlack,
                                        onBack: () {
                                          Navigator.pop(context, unServiceableCode);
                                        },
                                        clearText: (widget.isRecordView == 0 || widget.isRecordView == 2)
                                            ? lableModel.clear
                                            : "",
                                        onClear: () {
                                          _scrollController.animateTo(
                                            0,
                                            duration: const Duration(milliseconds: 100),
                                            curve: Curves.easeOut,
                                          );
                                          setState(() {
                                            selectedDamageServices.clear();
                                            _isUnserviceableEnable = false;
                                            remarkController.clear();
                                            //  selectImageList.clear();
                                            selectImageBase64List.clear();
                                            CommonUtils.SELECTEDIMAGELIST.clear();
                                            imageCount = "0";
                                            images = generateImageXMLData(selectImageBase64List);
                                          });
                                        },
                                      ),
                                    ),
                                    BlocConsumer<UldAcceptanceCubit, UldAcceptanceState>(
                                      listener: (context, state) async {
                                        if (state is MainLoadingState) {
                                          DialogUtils.showLoadingDialog(context, message: lableModel.loading);
                                        } else if (state is UldDamageListSuccessState) {
                                          DialogUtils.hideLoadingDialog(context);
                                          if (state.uldDamageListModel.status == "E") {
                                            Vibration.vibrate(duration: 500);
                                            SnackbarUtil.showSnackbar(
                                                context,
                                                state.uldDamageListModel.statusMessage!,
                                                MyColor.colorRed,
                                                icon: FontAwesomeIcons.times);
                                          } else {
                                            damageList = state.uldDamageListModel.uLDDamage!;
                                            if (widget.isRecordView == 1 || widget.isRecordView == 2) {
                                              //call update api
                                              context
                                                  .read<UldAcceptanceCubit>()
                                                  .uldDamageUpdate(widget.ULDSeqNo,
                                                      _user!.userProfile!.userIdentity!,
                                                      _splashDefaultData!.companyCode!,
                                                      widget.menuId);
                                            } else {}
                                          }
                                        } else if (state is UldDamageListFailureState) {
                                          DialogUtils.hideLoadingDialog(context);
                                          Vibration.vibrate(duration: 500);
                                          SnackbarUtil.showSnackbar(context, state.error, MyColor.colorRed, icon: FontAwesomeIcons.times);
                                        } else if (state is UldDamageSuccessState) {
                                          if (state.uldAcceptModel.status == "E") {
                                            DialogUtils.hideLoadingDialog(context);
                                            Vibration.vibrate(duration: 500);
                                            SnackbarUtil.showSnackbar(
                                                context,
                                                state.uldAcceptModel.statusMessage!,
                                                MyColor.colorRed, icon: FontAwesomeIcons.times);
                                          } else {
                                            print("widget.isRecordView === ${widget.isRecordView}");
                                            DialogUtils.hideLoadingDialog(context);
                                            if (_isUnserviceableEnable) {
                                              unServiceableCode = "BUS";
                                            } else {
                                              unServiceableCode = "SER";
                                            }

                                            showDialog(
                                              context: context,
                                              barrierDismissible: false,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  backgroundColor: MyColor.colorWhite,
                                                  shape: const RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.all(Radius.circular(20)),
                                                  ),
                                                  content: Column(
                                                    mainAxisSize: MainAxisSize.min,
                                                    children: [
                                                      Icon(Icons.done,
                                                          color: MyColor.colorGreen,
                                                          size: SizeConfig.blockSizeVertical * 10),
                                                      SizedBox(height: SizeConfig.blockSizeVertical * 2),
                                                      CustomeText(
                                                        text: state.uldAcceptModel.statusMessage!,
                                                        fontColor: MyColor.colorBlack,
                                                        fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_7,
                                                        fontWeight: FontWeight.w400,
                                                        textAlign: TextAlign.start,
                                                      ),
                                                      SizedBox(height: SizeConfig.blockSizeVertical * 2),
                                                      RoundedButtonBlue(
                                                        text: lableModel.ok!,
                                                        press: () {
                                                          Navigator.pop(context, true); // Return true when Ok is pressed
                                                        },
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              },
                                            ).then((result) {
                                              if (result == true) {
                                                // Pop the previous screen when result is true
                                                if (_isUnserviceableEnable) {
                                                  unServiceableCode = "BUS";
                                                } else {
                                                  unServiceableCode = "SER";
                                                }
                                                Navigator.pop(context, unServiceableCode);
                                              }
                                            });

                                            /*if(widget.isRecordView == 0){
                                              context.read<UldAcceptanceCubit>().uldDamageAccept(widget.flightSeqNo, widget.ULDSeqNo, widget.ULDNo.replaceAll(" ", ""), widget.locationCode, widget.groupId, _user!.userProfile!.userIdentity!, _company!.companyCode!);
                                            }
                                            else if(widget.isRecordView == 2){
                                              DialogUtils.hideLoadingDialog(context);
                                              showDialog(context: context, barrierDismissible: false, builder: (BuildContext context) {
                                                  return AlertDialog(
                                                    backgroundColor: MyColor.colorWhite,
                                                    shape: const RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.all(Radius.circular(20)),
                                                    ),
                                                    content: Column(
                                                      mainAxisSize: MainAxisSize.min,
                                                      children: [
                                                        Icon(Icons.done, color: MyColor.colorGreen, size: SizeConfig.blockSizeVertical * 10),
                                                        SizedBox(height: SizeConfig.blockSizeVertical * 2),
                                                        CustomeText(
                                                          text: widget.validationMessages!["H000019"]!,
                                                          fontColor: MyColor.colorBlack,
                                                          fontSize: SizeConfig.textMultiplier * SizeUtils.HEADINGTEXTSIZE,
                                                          fontWeight: FontWeight.w400,
                                                          textAlign: TextAlign.center,
                                                        ),
                                                        SizedBox(height: SizeConfig.blockSizeVertical * 2),
                                                        RoundedButton(
                                                          text: lableModel.ok!,
                                                          textSize: SizeConfig.textMultiplier * SizeUtils.MEDIUMTEXTSIZE,
                                                          verticalPadding: SizeConfig.blockSizeVertical * SizeUtils.BUTTONVERTICALSIZE,
                                                          cornerRadius: SizeConfig.blockSizeHorizontal * SizeUtils.CIRCULARCORNER,
                                                          color: MyColor.primaryColorblue,
                                                          press: () {
                                                            Navigator.pop(context, true); // Return true when Ok is pressed
                                                          },
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                },
                                              ).then((result) {

                                                print("RESULT_IS CHECK====== ${result}");
                                                if (result == true) {
                                                  // Pop the previous screen when result is true
                                                  if(_isUnserviceableEnable){
                                                    unServiceableCode = "BUS";
                                                  }else{
                                                    unServiceableCode = "SER";
                                                  }
                                                  Navigator.pop(context, unServiceableCode);
                                                }
                                              });
                                            }*/
                                          }
                                        } else if (state is UldDamageFailureState) {
                                          DialogUtils.hideLoadingDialog(context);
                                          Vibration.vibrate(duration: 500);
                                          SnackbarUtil.showSnackbar(context,
                                              state.error, MyColor.colorRed, icon: FontAwesomeIcons.times);
                                        }

                                        /*  else if(state is UldDamageAcceptSuccessState){

                                          if(state.uldAcceptModel.status == "E"){
                                            DialogUtils.hideLoadingDialog(context);
                                            SnackbarUtil.showSnackbar(context, state.uldAcceptModel.statusMessage!, MyColor.colorRed);
                                          }else{
                                            DialogUtils.hideLoadingDialog(context);
                                            showDialog(context: context, barrierDismissible: false, builder: (BuildContext context) {
                                                return AlertDialog(
                                                  backgroundColor: MyColor.colorWhite,
                                                  shape: const RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.all(Radius.circular(20)),
                                                  ),
                                                  content: Column(
                                                    mainAxisSize: MainAxisSize.min,
                                                    children: [
                                                      Icon(Icons.done, color: MyColor.colorGreen, size: SizeConfig.blockSizeVertical * 10),
                                                      SizedBox(height: SizeConfig.blockSizeVertical * 2),
                                                      CustomeText(
                                                        text: widget.validationMessages!["H000019"]!,
                                                        fontColor: MyColor.colorBlack,
                                                        fontSize: SizeConfig.textMultiplier * SizeUtils.HEADINGTEXTSIZE,
                                                        fontWeight: FontWeight.w400,
                                                        textAlign: TextAlign.center,
                                                      ),
                                                      SizedBox(height: SizeConfig.blockSizeVertical * 2),
                                                      RoundedButton(
                                                        text: lableModel.ok!,
                                                        textSize: SizeConfig.textMultiplier * SizeUtils.MEDIUMTEXTSIZE,
                                                        verticalPadding: SizeConfig.blockSizeVertical * SizeUtils.BUTTONVERTICALSIZE,
                                                        cornerRadius: SizeConfig.blockSizeHorizontal * SizeUtils.CIRCULARCORNER,
                                                        color: MyColor.primaryColorblue,
                                                        press: () {
                                                          Navigator.pop(context);
                                                          if(_isUnserviceableEnable){
                                                            unServiceableCode = "BUS";
                                                          }else{
                                                            unServiceableCode = "SER";
                                                          }
                                                          Navigator.pop(context, unServiceableCode);
                                                        },
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              },);
                                          }

                                        }
                                        else if(state is UldDamageAcceptFailureState){
                                          DialogUtils.hideLoadingDialog(context);
                                          SnackbarUtil.showSnackbar(context, ValidationMessageCodeUtils.someErrorOccurred, MyColor.colorRed);

                                        }*/

                                        else if (state is UldDamageUpdateSuccessState) {
                                          UldDamageUpdatetModel
                                          uldDamageUpdatetModel = state.uldDamageUpdateModel;
                                          if (uldDamageUpdatetModel.status == "E") {
                                            DialogUtils.hideLoadingDialog(context);
                                            Vibration.vibrate(duration: 500);
                                            SnackbarUtil.showSnackbar(context, state.uldDamageUpdateModel.statusMessage!, MyColor.colorRed, icon: FontAwesomeIcons.times);
                                          } else {
                                            DialogUtils.hideLoadingDialog(context);

                                            if (uldDamageUpdatetModel.uLDProblem!.uLDConditionCode != null) {
                                              // update Responce
                                              String unserviceableUld = uldDamageUpdatetModel.uLDProblem!.uLDConditionCode!;
                                              if (unserviceableUld == "BUS") {
                                                _isUnserviceableEnable = true;
                                              } else if (unserviceableUld == "SER") {
                                                _isUnserviceableEnable = false;
                                              }

                                              List<String> parsedDamageCodes = uldDamageUpdatetModel.uLDProblem!.damageCode!.split("~");
                                              for (var item in damageList) {
                                                if (parsedDamageCodes.contains(item.referenceDataIdentifier)) {
                                                  selectedDamageServices.add("${item.referenceDataIdentifier}~");
                                                }
                                              }

                                              remarkController.text = uldDamageUpdatetModel.uLDProblem!.remarks!;

                                              uldDamageUpdatetModel.edocketMaster!.map((e) {
                                                  selectImageBase64List.add(e.binaryFile!);
                                                },
                                              ).toList();

                                              images = generateImageXMLData(selectImageBase64List);
                                              imageCount = "${selectImageBase64List.length}";

                                              print("SELECTED DAMAGE LIST == ${selectImageBase64List.length}");
                                            }
                                          }
                                        } else if (state is UldDamageUpdateFailureState) {
                                          DialogUtils.hideLoadingDialog(context);
                                          Vibration.vibrate(duration: 500);
                                          SnackbarUtil.showSnackbar(context, state.error, MyColor.colorRed, icon: FontAwesomeIcons.times);
                                        }
                                      },
                                      builder: (context, state) {
                                        return Expanded(
                                          child: SingleChildScrollView(
                                            child: Column(
                                              children: [
                                                Directionality(
                                                  textDirection: textDirection,
                                                  child: Padding(
                                                    padding: const EdgeInsets.only(left: 10, right: 10, top: 0, bottom: 0),
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
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Padding(padding: const EdgeInsets.only(left: 12, right: 12, top: 12),
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: [
                                                                Column(
                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                  children: [
                                                                    CustomeText(
                                                                        text: "${lableModel.unserviceableULD!} (${widget.ULDNo})",
                                                                        fontColor: MyColor.textColorGrey3,
                                                                        fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                                                        fontWeight: FontWeight.w600,
                                                                        textAlign: TextAlign.start),
                                                                    CustomeText(
                                                                        text: "${lableModel.uldComponentLimit}",
                                                                        fontColor: MyColor.textColorGrey2,
                                                                        fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_3,
                                                                        fontWeight: FontWeight.w500,
                                                                        textAlign: TextAlign.start),
                                                                  ],
                                                                ),
                                                                Switch(
                                                                  value: _isUnserviceableEnable,
                                                                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                                                  activeColor: MyColor.primaryColorblue,
                                                                  inactiveThumbColor: MyColor.thumbColor,
                                                                  inactiveTrackColor: MyColor.textColorGrey2,
                                                                  trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
                                                                  onChanged: (value) {
                                                                    if (widget.isRecordView == 0 || widget.isRecordView == 2) {
                                                                      setState(() {_isUnserviceableEnable = value;});
                                                                    }
                                                                  },
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            height: SizeConfig
                                                                .blockSizeVertical,
                                                          ),
                                                          CustomDivider(
                                                            space: 0,
                                                            color: Colors.black,
                                                            hascolor: true,
                                                          ),
                                                          SizedBox(
                                                            height: SizeConfig
                                                                .blockSizeVertical,
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .only(
                                                                    left: 12,
                                                                    right: 12,
                                                                    bottom: 12),
                                                            child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                CustomeText(
                                                                    text: lableModel.typeOfDamaged!,
                                                                    fontColor: MyColor.colorBlack,
                                                                    fontSize: SizeConfig.textMultiplier *
                                                                        SizeUtils.TEXTSIZE_1_5,
                                                                    fontWeight: FontWeight.w600,
                                                                    textAlign: TextAlign.start),
                                                                SizedBox(
                                                                  height: SizeConfig.blockSizeVertical,
                                                                ),
                                                                CustomDivider(
                                                                  space: 0,
                                                                  color:
                                                                      Colors.black,
                                                                  hascolor: true,
                                                                ),
                                                                SizedBox(
                                                                  height: SizeConfig.blockSizeVertical,
                                                                ),
                                                                ListView.builder(
                                                                  itemCount: _showFullList ? damageList.length : (damageList.length > 4 ? 4 : damageList.length),
                                                                  shrinkWrap: true,
                                                                  physics: const NeverScrollableScrollPhysics(),
                                                                  itemBuilder: (context, index) {
                                                                    ULDDamage item = damageList[index];
                                                                    String title = "${lableModel.getValueFromKey("${item.rowId}")}";
                                                                    Color backgroundColor = MyColor.colorList[index % MyColor.colorList.length];

                                                                    String damagetext = (title != 'null') ? title : item.referenceDescription!;

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
                                                                                      child: CustomeText(text: "${damagetext}".substring(0, 2).toUpperCase(), fontColor: MyColor.colorBlack, fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_8, fontWeight: FontWeight.w500, textAlign: TextAlign.center),
                                                                                    ),
                                                                                    SizedBox(
                                                                                      width: 15,
                                                                                    ),
                                                                                    Flexible(child: CustomeText(text: (title != 'null') ? title : item.referenceDescription!, fontColor: MyColor.colorBlack, fontSize: SizeConfig.textMultiplier * 1.5, fontWeight: FontWeight.w400, textAlign: TextAlign.start)),
                                                                                  ],
                                                                                ),
                                                                              ),
                                                                              SizedBox(
                                                                                width:
                                                                                    2,
                                                                              ),
                                                                              Switch(
                                                                                value: selectedDamageServices.contains("${item.referenceDataIdentifier}~"),
                                                                                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                                                                activeColor: MyColor.primaryColorblue,
                                                                                inactiveThumbColor: MyColor.thumbColor,
                                                                                inactiveTrackColor: MyColor.textColorGrey2,
                                                                                trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
                                                                                onChanged: (value) {
                                                                                  setState(() {
                                                                                    if (widget.isRecordView == 0 || widget.isRecordView == 2) {
                                                                                      if (value) {
                                                                                        selectedDamageServices.add("${item.referenceDataIdentifier!}~");
                                                                                      } else {
                                                                                        selectedDamageServices.remove("${item.referenceDataIdentifier!}~");
                                                                                      }
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
                                                                // Show More/Show Less Button
                                                                if (damageList.length > 4) // Only show the button if the list has more than 4 items
                                                                  InkWell(
                                                                    onTap: () {
                                                                      setState(() {
                                                                        _showFullList = !_showFullList; // Toggle between showing full list and limited list
                                                                      });
                                                                    },
                                                                    child: Padding(
                                                                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                                                                      child: Row(
                                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                                        children: [
                                                                          CustomeText(
                                                                            text: _showFullList ? "${lableModel.showLess}" : "${lableModel.showMore}", // Change text based on state
                                                                            fontColor: MyColor.primaryColorblue,
                                                                            fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                                                            fontWeight: FontWeight.w500, textAlign: TextAlign.center,
                                                                          ),
                                                                        ],
                                                                      ),
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
                                                SizedBox(
                                                  height:
                                                      SizeConfig.blockSizeVertical,
                                                ),
                                                Directionality(
                                                    textDirection: textDirection,
                                                    child: Padding(
                                                      padding: const EdgeInsets.only(left: 10, right: 10, top: 0, bottom: 0),
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
                                                          padding: const EdgeInsets.only(left: 12, right: 12, top: 12),
                                                          child: Column(
                                                            children: [

                                                              RemarkCustomTextField(
                                                                textDirection: textDirection,
                                                                controller: remarkController,
                                                                focusNode: remarkFocus,
                                                                hasIcon: false,
                                                                hastextcolor: true,
                                                                animatedLabel: true,
                                                                needOutlineBorder: true,
                                                                labelText: lableModel.remarks,
                                                                onChanged: (value, validate) {},
                                                                readOnly: widget.isRecordView == 1 ? true : false,
                                                                fillColor: Colors.grey.shade100,
                                                                textInputType: TextInputType.text,
                                                                inputAction: TextInputAction.next,
                                                                hintTextcolor: Colors.black45,
                                                                maxLines: 2,
                                                                maxLength: 500,
                                                                digitsOnly: false,
                                                                doubleDigitOnly: false,
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
                                                              SizedBox(
                                                                height: SizeConfig.blockSizeVertical * SizeUtils.HEIGHT2,
                                                              ),

                                                              Row(
                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                children: [
                                                                  InkWell(
                                                                    onTap: () async {
                                                                      var result = await showImageDialog(context, lableModel, widget.isRecordView, selectImageBase64List, widget.buttonRightsList!);
                                                                      if(result != null){
                                                                        images = result['images']!;
                                                                        imageCount = result['imageCount']!;
                                                                        selectImageBase64List = CommonUtils.SELECTEDIMAGELIST;
                                                                        setState(() {

                                                                        });

                                                                      }

                                                                    },
                                                                    child: Row(children: [
                                                                      SvgPicture.asset(camera, height: SizeConfig.blockSizeVertical * SizeUtils.HEIGHT3,),
                                                                      SizedBox(width: SizeConfig.blockSizeHorizontal,),
                                                                      CustomeText(text: "${lableModel.takeViewPhoto}", fontColor: MyColor.primaryColorblue, fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5, fontWeight: FontWeight.w500, textAlign: TextAlign.start)
                                                                    ],),
                                                                  ),
                                                                  Row(

                                                                    children: [
                                                                      CustomeText(text: "${lableModel.photoCount}", fontColor: MyColor.textColorGrey2, fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5, fontWeight: FontWeight.w400, textAlign: TextAlign.start),
                                                                      SizedBox(width: SizeConfig.blockSizeHorizontal,),
                                                                      Container(
                                                                        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 1),
                                                                        decoration: BoxDecoration(
                                                                            color: MyColor.btCountColor,
                                                                            borderRadius: BorderRadius.circular(SizeConfig.blockSizeHorizontal * SizeUtils.BORDERRADIOUS_6)
                                                                        ),
                                                                        child: CustomeText(
                                                                            text: "${imageCount}",
                                                                            fontColor: MyColor.textColorGrey2,
                                                                            fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                                                            fontWeight: FontWeight.w500,
                                                                            textAlign: TextAlign.center),
                                                                      )
                                                                    ],
                                                                  ),
                                                                ],
                                                              ),

                                                              SizedBox(
                                                                height: SizeConfig.blockSizeVertical * SizeUtils.HEIGHT2,
                                                              ),



                                                              if (widget.isRecordView == 0 || widget.isRecordView == 2)
                                                                Row(
                                                                  children: [
                                                                    Expanded(
                                                                      flex:1,
                                                                      child: RoundedButtonBlue(
                                                                        text: lableModel.cancel!,
                                                                        isborderButton: true,
                                                                        color: MyColor.primaryColorblue,
                                                                        press: () async {
                                                                          Navigator.pop(context, unServiceableCode);
                                                                        },
                                                                      ),
                                                                    ),
                                                                    SizedBox(width: SizeConfig.blockSizeHorizontal * SizeUtils.WIDTH3,),
                                                                    // click button for accept uld with location
                                                                    Expanded(
                                                                      flex:1,
                                                                      child: RoundedButtonBlue(
                                                                        text: lableModel.save!,
                                                                        color: MyColor.primaryColorblue,
                                                                        isborderButton: false,
                                                                        press: () async {

                                                                          String typesOfDamage = selectedDamageServices.join('').toString();

                                                                          if (selectedDamageServices.isNotEmpty) {
                                                                            context.read<UldAcceptanceCubit>().uldDamage(
                                                                                widget.ULDNo.replaceAll(" ", ""),
                                                                                widget.ULDSeqNo,
                                                                                widget.flightSeqNo,
                                                                                widget.groupId,
                                                                                _isUnserviceableEnable ? "BUS" : "SER",
                                                                                typesOfDamage,
                                                                                selectImageBase64List.isNotEmpty ? images : "",
                                                                                remarkController.text,
                                                                                _user!.userProfile!.userIdentity!,
                                                                                _splashDefaultData!.companyCode!,
                                                                                widget.menuCode,
                                                                                widget.menuId);
                                                                          }
                                                                          else {
                                                                            Vibration.vibrate(duration: 500);
                                                                            SnackbarUtil.showSnackbar(
                                                                                context,
                                                                                lableModel.validatTypesOfDamage!,
                                                                                MyColor.colorRed, icon: FontAwesomeIcons.times);
                                                                          }

                                                                          /*if(isButtonEnabled("save", widget.buttonRightsList!)){
                                                                            String typesOfDamage = selectedDamageServices.join('').toString();

                                                                            if (selectedDamageServices.isNotEmpty) {
                                                                              context.read<UldAcceptanceCubit>().uldDamage(
                                                                                  widget.ULDNo.replaceAll(" ", ""),
                                                                                  widget.ULDSeqNo,
                                                                                  widget.flightSeqNo,
                                                                                  widget.groupId,
                                                                                  _isUnserviceableEnable ? "BUS" : "SER",
                                                                                  typesOfDamage,
                                                                                  selectImageBase64List.isNotEmpty ? images : "",
                                                                                  remarkController.text,
                                                                                  _user!.userProfile!.userIdentity!,
                                                                                  _splashDefaultData!.companyCode!,
                                                                                  widget.menuCode,
                                                                                  widget.menuId);
                                                                            }
                                                                            else {
                                                                              Vibration.vibrate(duration: 500);
                                                                              SnackbarUtil.showSnackbar(
                                                                                  context,
                                                                                  lableModel.validatTypesOfDamage!,
                                                                                  MyColor.colorRed, icon: FontAwesomeIcons.times);
                                                                            }
                                                                          }else{
                                                                            SnackbarUtil.showSnackbar(context, ValidationMessageCodeUtils.AuthorisedRolesAndRightsMsg, MyColor.colorRed, icon: FontAwesomeIcons.times);
                                                                            Vibration.vibrate(duration: 500);
                                                                          }*/


                                                                        },
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),


                                                              SizedBox(
                                                                height: SizeConfig.blockSizeVertical * 0.9,
                                                              ),


                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ))
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ))),
          )),
    );
  }





  static Future<Map<String, String>?> showImageDialog(BuildContext context, LableModel lableModel, int recordView, List<String> selectImageList,List<ButtonRight> buttonRightsList) {

    print("IMAGELIST COUNT S ==== ${selectImageList.length}");

    List<String> imageList = (selectImageList.isNotEmpty) ? List.from(selectImageList) : [];

    print("IMAGELIST COUNT ==== ${imageList.length}");


    FocusNode imageFocus = FocusNode();
    FocusNode removeIconFocus = FocusNode();


    final ImagePicker _picker = ImagePicker();


    Future<File?> _resizeImage(File imageFile) async {
      try {
        Uint8List imageBytes = await imageFile.readAsBytes();
        img.Image? decodedImage = img.decodeImage(imageBytes);

        if (decodedImage != null) {
          img.Image resizedImage = img.copyResize(decodedImage, width: 500, height: 500);
          // Save the resized image to a file
          File resizedImageFile = await imageFile.writeAsBytes(img.encodeJpg(resizedImage));
          return resizedImageFile;
        }
      } catch (e) {
        print('Error resizing image: $e');
      }
      return null;
    }

    String generateImageXMLData(List<String> selectImageList) {
      StringBuffer xmlBuffer = StringBuffer();
      xmlBuffer.write('<BinaryImageLists>');
      for (String base64Image in selectImageList) {
        xmlBuffer.write('<BinaryImageList>');
        xmlBuffer.write('<BinaryImage>$base64Image</BinaryImage>');
        xmlBuffer.write('</BinaryImageList>');
      }
      xmlBuffer.write('</BinaryImageLists>');
      return xmlBuffer.toString();
    }


    Future<void> _takePicture(StateSetter setState, LableModel lableModel) async {
      var status = await Permission.camera.status;
      if (!status.isGranted) {
        await Permission.camera.request();
      }

      if (await Permission.camera.isGranted) {
        final pickedFile = await _picker.pickImage(source: ImageSource.camera);

        if (pickedFile != null) {
          DialogUtils.showLoadingDialog(context, message: lableModel.loading);
          try {
            // Resize the image
            File? resizedImageFile = await _resizeImage(File(pickedFile.path));

            if (resizedImageFile != null) {
              String base64Image = base64Encode(await resizedImageFile.readAsBytes());
              setState(() {
                imageList.insert(0, base64Image);
              });
            } else {
              print('Failed to resize image.');
            }
          } finally {
            DialogUtils.hideLoadingDialog(context);
          }
        } else {
          print('No image selected.');
        }
      } else {
        print('Camera permission not granted.');
      }
    }

    Future<void> _attachPhotoFromGallery(StateSetter setState, LableModel lableModel) async {
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        DialogUtils.showLoadingDialog(context, message: lableModel.loading);
        try {
          // Resize the image if needed
          File? resizedImageFile = await _resizeImage(File(pickedFile.path));

          if (resizedImageFile != null) {
            String base64Image = base64Encode(await resizedImageFile.readAsBytes());
            setState(() {
              imageList.insert(0, base64Image); // Add the image to the beginning of the list
            });
          } else {
            print('Failed to resize image.');
          }
        } finally {
          DialogUtils.hideLoadingDialog(context);
        }
      } else {
        print('No image selected.');
      }
    }



    return showModalBottomSheet<Map<String, String>>(
      backgroundColor: MyColor.colorWhite,
      context: context,
      isScrollControlled: true,
      builder: (BuildContext newContext) {
        return StatefulBuilder(
            builder:(BuildContext context, StateSetter setState) {
              return FractionallySizedBox(
                widthFactor: 1,  // Adjust the width to 90% of the screen width
                child: Container(
                  height: SizeConfig.blockSizeVertical * 70,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 15, top: 15, left: 15, bottom: 15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CustomeText(text: "${lableModel.addPhotos}", fontColor:  MyColor.colorBlack, fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_2_0, fontWeight: FontWeight.w500, textAlign: TextAlign.start),
                              InkWell(
                                  onTap: () {
                                    Navigator.pop(context, null);
                                  },
                                  child: SvgPicture.asset(cancel, height: SizeConfig.blockSizeVertical * SizeUtils.HEIGHT3,))
                            ],
                          ),
                        ),
                        CustomDivider(
                          space: 0,
                          color: Colors.black,
                          hascolor: true,
                          thickness: 1,
                        ),
                        SizedBox(height: SizeConfig.blockSizeVertical),
                        Padding(
                          padding: const EdgeInsets.only(right: 15, top: 15, left: 15),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 1,
                                child: InkWell(
                                  onTap: () {
                                    _takePicture(setState, lableModel);
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                    SvgPicture.asset(camera, height: SizeConfig.blockSizeVertical * SizeUtils.HEIGHT3,),
                                    SizedBox(width: SizeConfig.blockSizeHorizontal * SizeUtils.WIDTH2,),
                                    CustomeText(text: "${lableModel.takePhoto}", fontColor: MyColor.primaryColorblue, fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5, fontWeight: FontWeight.w500, textAlign: TextAlign.start)
                                  ],),
                                ),
                              ),

                              Expanded(
                                flex: 1,
                                child: InkWell(
                                  onTap: () {
                                    _attachPhotoFromGallery(setState, lableModel);
                                  },
                                  child: Row(children: [
                                    SvgPicture.asset(link, height: SizeConfig.blockSizeVertical * SizeUtils.HEIGHT3,),
                                    SizedBox(width: SizeConfig.blockSizeHorizontal * SizeUtils.WIDTH2,),
                                    CustomeText(text: "${lableModel.attachPhotos}", fontColor: MyColor.primaryColorblue, fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5, fontWeight: FontWeight.w500, textAlign: TextAlign.start)
                                  ],),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: SizeConfig.blockSizeVertical),
                        Padding(
                          padding: const EdgeInsets.all(12),
                          child: CustomeText(text: "${lableModel.damagePhotos}", fontColor:  MyColor.colorBlack, fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5, fontWeight: FontWeight.w500, textAlign: TextAlign.start),
                        ),
                        SizedBox(height: SizeConfig.blockSizeVertical),

                        if (recordView == 0 || recordView == 2)
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: GridView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  // Number of columns
                                  crossAxisSpacing: 5,
                                  // Spacing between columns
                                  mainAxisSpacing: 7),
                              // Spacing between rows),
                              shrinkWrap: true,
                              itemCount: imageList.length,
                              // Limit to 3 items max
                              itemBuilder: (context, index) {
                                String base64Image = imageList[index];

                                return Stack(
                                  children: [
                                    // Image displayed in the grid
                                    InkWell(
                                      onTap: () {
                                        // Navigate to Enlarge image screen
                                        Navigator.push(
                                          context,
                                          CupertinoPageRoute(
                                              builder: (context) =>
                                                  EnlargedBinaryImageScreen(
                                                    binaryFile: base64Image,
                                                    imageList: imageList,
                                                    index: index,
                                                  ),
                                              fullscreenDialog:
                                              true),
                                        );
                                      },
                                      focusNode: imageFocus,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(12.0),
                                        child: Image.memory(base64Decode(base64Image),
                                          fit: BoxFit.cover,
                                          width: double.infinity,
                                          // Ensure the image takes up the full space
                                          height: double.infinity, // Ensure the image takes up the full space
                                        ),
                                      ),
                                    ),

                                    // Positioned remove icon on top right of the image
                                    Positioned(
                                      top: 5,
                                      right: 5,
                                      child: InkWell(
                                        onTap: () {
                                          setState(() {
                                            imageList.removeAt(index); // Remove the selected image
                                          });
                                        },
                                        focusNode: removeIconFocus,
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                          decoration: const BoxDecoration(
                                            borderRadius: BorderRadius.all(Radius.circular(10)),
                                            color: MyColor.colorWhite
                                          ),

                                          child: SvgPicture.asset(trashcan, height: SizeConfig.blockSizeVertical * SizeUtils.HEIGHT2,),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),

                        if (recordView == 1)
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: GridView.builder(
                              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  // Number of columns
                                  crossAxisSpacing: 5,
                                  // Spacing between columns
                                  mainAxisSpacing: 5),
                              // Spacing between rows),
                              shrinkWrap: true,
                              itemCount: imageList.length,
                              // Limit to 3 items max
                              itemBuilder:
                                  (context,
                                  index) {
                                String
                                base64Image = imageList[index];
                                return Stack(
                                  children: [
                                    // Image displayed in the grid
                                    InkWell(
                                      onTap: () {
                                        // Navigate to Enlarge image screen
                                        Navigator
                                            .push(
                                          context,
                                          CupertinoPageRoute(
                                              builder: (context) =>
                                                  EnlargedBinaryImageScreen(
                                                    binaryFile: base64Image,
                                                    imageList: imageList!,
                                                    index: index,
                                                  ),
                                              fullscreenDialog:
                                              true),
                                        );
                                      },
                                      focusNode: imageFocus,
                                      child:
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(15.0),
                                        child: Image.memory(base64Decode(base64Image),
                                          fit: BoxFit.cover,
                                          width: double.infinity,
                                          // Ensure the image takes up the full space
                                          height: double.infinity, // Ensure the image takes up the full space
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),

                        SizedBox(height: SizeConfig.blockSizeVertical),
                        CustomDivider(
                          space: 0,
                          color: Colors.black,
                          hascolor: true,
                          thickness: 1,
                        ),
                        SizedBox(height: SizeConfig.blockSizeVertical),
                        Padding(
                          padding: const EdgeInsets.all(12),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child: RoundedButtonBlue(
                                  text: "${lableModel.cancel}",
                                  isborderButton: true,
                                  press: () {
                                    Navigator.pop(context, null);
                                  },
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                flex: 1,
                                child: RoundedButtonBlue(
                                  text: "${lableModel.save}",
                                  press: () {

                                    if(isButtonEnabled("save", buttonRightsList)){
                                      CommonUtils.SELECTEDIMAGELIST = imageList;
                                      String images = "${generateImageXMLData(imageList)}";
                                      String count = imageList.length.toString();
                                      Navigator.pop(context, {
                                        "images" : images,
                                        "imageCount" : count
                                      });
                                    }else{
                                      SnackbarUtil.showSnackbar(context, ValidationMessageCodeUtils.AuthorisedRolesAndRightsMsg, MyColor.colorRed, icon: FontAwesomeIcons.times);
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
              );
            }
        );
      },
    );
  }

  String generateImageXMLData(List<String> selectImageList) {
    StringBuffer xmlBuffer = StringBuffer();
    xmlBuffer.write('<BinaryImageLists>');
    for (String base64Image in selectImageList) {
      xmlBuffer.write('<BinaryImageList>');
      xmlBuffer.write('<BinaryImage>$base64Image</BinaryImage>');
      xmlBuffer.write('</BinaryImageList>');
    }
    xmlBuffer.write('</BinaryImageLists>');
    return xmlBuffer.toString();
  }

  static bool isButtonEnabled(String buttonId, List<ButtonRight> buttonList) {
    ButtonRight? button = buttonList.firstWhere(
          (button) => button.buttonId == buttonId,
    );
    return button.isEnable == 'Y';
  }



}
