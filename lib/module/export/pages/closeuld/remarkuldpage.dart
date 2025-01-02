import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:galaxy/core/mycolor.dart';
import 'package:galaxy/module/export/services/emptyuldtrolley/emptyuldtrolleylogic/emptyuldtrolleycubit.dart';
import 'package:galaxy/module/export/services/emptyuldtrolley/emptyuldtrolleylogic/emptyuldtrolleystate.dart';
import 'package:galaxy/utils/sizeutils.dart';
import 'package:galaxy/utils/snackbarutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vibration/vibration.dart';
import '../../../../../../widget/customeuiwidgets/header.dart';
import '../../../../core/images.dart';
import '../../../../language/appLocalizations.dart';
import '../../../../language/model/lableModel.dart';
import '../../../../manager/timermanager.dart';
import '../../../../prefrence/savedprefrence.dart';
import '../../../../utils/commonutils.dart';
import '../../../../utils/dialogutils.dart';
import '../../../../utils/uldvalidationutil.dart';
import '../../../../widget/customdivider.dart';
import '../../../../widget/customebuttons/roundbuttonblue.dart';
import '../../../../widget/customedrawer/customedrawer.dart';
import '../../../../widget/customeedittext/customeedittextwithborder.dart';
import '../../../../widget/customeedittext/remarkedittextfeild.dart';
import '../../../../widget/custometext.dart';
import '../../../../widget/customtextfield.dart';
import '../../../../widget/groupidcustomtextfield.dart';
import '../../../../widget/header/mainheadingwidget.dart';
import '../../../login/pages/signinscreenmethods.dart';
import '../../../profile/page/profilepagescreen.dart';
import '../../../splash/model/splashdefaultmodel.dart';
import '../../../onboarding/sizeconfig.dart';
import 'dart:ui' as ui;
import '../../../login/model/userlogindatamodel.dart';
import '../../../submenu/model/submenumodel.dart';
import '../../model/closeuld/equipmentmodel.dart';
import '../../model/closeuld/getremarklistmodel.dart';
import '../../services/closeuld/closeuldlogic/closeuldcubit.dart';
import '../../services/closeuld/closeuldlogic/closeuldstate.dart';

class RemarkULDPage extends StatefulWidget {
  String mainMenuName;
  String title;
  String refrelCode;
  LableModel? lableModel;
  int menuId;
  List<SubMenuName> importSubMenuList = [];
  List<SubMenuName> exportSubMenuList = [];
  String uldNo;
  int flightSeqNo;
  int uldSeqNo;
  String uldType;


  RemarkULDPage(
      {super.key,
      required this.importSubMenuList,
      required this.exportSubMenuList,
      required this.title,
      required this.refrelCode,
      this.lableModel,
      required this.menuId,
      required this.mainMenuName,
        required this.uldNo,
        required this.flightSeqNo,
        required this.uldSeqNo,
        required this.uldType});

  @override
  State<RemarkULDPage> createState() => _RemarkULDPageState();
}

class _RemarkULDPageState extends State<RemarkULDPage>{



  TextEditingController remarkController = TextEditingController();
  FocusNode remarkFocus = FocusNode();

  InactivityTimerManager? inactivityTimerManager;
  final SavedPrefrence savedPrefrence = SavedPrefrence();
  UserDataModel? _user;
  SplashDefaultModel? _splashDefaultData;
  final ScrollController scrollController = ScrollController();

  GetRemarkListModel? getRemarkListModel;
  List<ULDRemarksList> uLDRemarksList = [];



  bool isBackPressed = false; // Track if the back button was pressed

  bool isInactivityDialogOpen = false; // Flag to track inactivity dialog state


  int? selectedSwitchIndex;

  /*final List<String> remarkList = [
    "Testing is underway to ensure functionality and reliability. Please verify all inputs and outputs for accuracy. Your feedback is valuable!",
    "{boy count} boys are enjoying a sunny day flying kites in the open field. Each one has their own unique kite soaring high in the sky.",
    "There are {boy count} boys and {girl count} girls in the classroom, creating a lively and balanced environment for learning and collaboration.",
    "Testing is underway to ensure functionality and reliability. Please verify all inputs and outputs for accuracy. Your feedback is valuable!",
    "{boy count} boys are enjoying a sunny day flying kites in the open field. Each one has their own unique kite soaring high in the sky.",
    "There are {boy count} boys and {girl count} girls in the classroom, creating a lively and balanced environment for learning and collaboration.",
    "Testing is underway to ensure functionality and reliability. Please verify all inputs and outputs for accuracy. Your feedback is valuable!",
    "{boy count} boys are enjoying a sunny day flying kites in the open field. Each one has their own unique kite soaring high in the sky.",
    "There are {boy count} boys and {girl count} girls in the classroom, creating a lively and balanced environment for learning and collaboration."
  ];
*/


  @override
  void initState() {
    super.initState();

    _loadUser(); //load user data

  }




  Future<void> openValidationDialog(String message, FocusNode focuseNode) async {
    bool? empty = await DialogUtils.showDataNotFoundDialogbot(
        context, message, widget.lableModel!);

    if (empty == true) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        FocusScope.of(context).requestFocus(focuseNode);
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    inactivityTimerManager?.stopTimer(); // Stop the timer when the screen is disposed
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
    getRemarkList();

    inactivityTimerManager = InactivityTimerManager(
      context: context,
      timeoutMinutes: _splashDefaultData!.activeLoginTime!,
      // Set the desired inactivity time here
      onTimeout: _handleInactivityTimeout, // Define what happens when timeout occurs
    );
    inactivityTimerManager?.startTimer();
  }

  Future<void> _handleInactivityTimeout() async {
    isInactivityDialogOpen = true; // Set flag before showing dialog

    bool? activateORNot = await DialogUtils.showingActivateTimerDialog(
        context, _user!.userProfile!.userId!, _splashDefaultData!.companyCode!);

    isInactivityDialogOpen = false; // Reset flag after dialog closes

    if (activateORNot == true) {
      inactivityTimerManager!.resetTimer();
    } else {
      _logoutUser();
    }
  }

  Future<void> _logoutUser() async {
    await savedPrefrence.logout();
    Navigator.pushAndRemoveUntil(
      context,
      CupertinoPageRoute(
        builder: (context) => const SignInScreenMethod(),
      ),
      (route) => false,
    );
  }

  void _resumeTimerOnInteraction() {
    inactivityTimerManager?.resetTimer();
    print('Activity detected, timer reset');
  }

  Future<bool> _onWillPop() async {


    isBackPressed = true; // Set to true to avoid showing snackbar on back press
    FocusScope.of(context).unfocus();
    Navigator.pop(context);
    inactivityTimerManager?.stopTimer();


    return false; // Prevents the default back button action
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  String tUnit = "C";



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
        onTap: _resumeTimerOnInteraction,
        // Resuming on any tap
        onPanDown: (details) => _resumeTimerOnInteraction(),
        // Resuming on any gesture
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
                isBackPressed = false; // Set to true to avoid showing snackbar on back press
                _scaffoldKey.currentState?.closeDrawer();
              },) : null, // Add custom drawer widget here
              body: Stack(
                children: [
                  MainHeadingWidget(mainMenuName: widget.mainMenuName,
                  onDrawerIconTap: () {
                    isBackPressed = true; // Set to true to avoid showing snackbar on back press
                    _scaffoldKey.currentState?.openDrawer();
                  },
                    onUserProfileIconTap: () {
                      isBackPressed = true; // Set to true to avoid showing snackbar on back press
                      FocusScope.of(context).unfocus();
                      _scaffoldKey.currentState?.closeDrawer();
                      // navigate to profile picture
                      inactivityTimerManager?.stopTimer(); // Stop the timer when the screen is disposed
                      Navigator.push(context, CupertinoPageRoute(builder: (context) => const Profilepagescreen(),));
                    },

                  /*  onDrawerIconTap: () => _scaffoldKey.currentState?.openDrawer(),*/
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
                                topRight: Radius.circular(SizeConfig.blockSizeVertical * SizeUtils.WIDTH2),
                                topLeft: Radius.circular(SizeConfig.blockSizeVertical * SizeUtils.WIDTH2))),
                        child: Column(
                          children: [
                            // header of title and clear function
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 10, right: 15, top: 12, bottom: 12),
                              child: HeaderWidget(
                                titleTextColor: MyColor.colorBlack,
                                title: widget.title,
                                onBack: () {
                                  _onWillPop();
                                },
                                clearText: lableModel!.clear,
                                //add clear text to clear all feild
                                onClear: () {
                                  remarkController.clear();
                                  setState(() {

                                  });
                                },
                              ),
                            ),

                            // start api responcer

                            Container(
                              padding: const EdgeInsets.only(
                                  left: 10,
                                  right: 10,
                                  top: 10,
                                  bottom: 0),
                              margin: const EdgeInsets.only(
                                  left: 10,
                                  right: 10,
                                  top: 0,
                                  bottom: 0),
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
                                    textDirection: textDirection,
                                    child: Row(
                                      children: [
                                        SvgPicture.asset(info, height: SizeConfig.blockSizeVertical * SizeUtils.ICONSIZE2,),
                                        SizedBox(width: SizeConfig.blockSizeHorizontal,),
                                        CustomeText(
                                            text: widget.uldNo,
                                            fontColor: MyColor.textColorGrey2,
                                            fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_6,
                                            fontWeight: FontWeight.w700,
                                            textAlign: TextAlign.start)
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: SizeConfig.blockSizeVertical * SizeUtils.HEIGHT2),
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
                                    readOnly: false,
                                    fillColor: Colors.grey.shade100,
                                    textInputType: TextInputType.text,
                                    inputAction: TextInputAction.next,
                                    hintTextcolor: Colors.black45,
                                    maxLines: 3,
                                    maxLength: 500,
                                    digitsOnly: false,
                                    doubleDigitOnly: false,
                                    verticalPadding: SizeConfig.blockSizeVertical * SizeUtils.HEIGHT2,
                                    fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
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

                                  SizedBox(height: SizeConfig.blockSizeVertical),
                                ],
                              ),
                            ),
                            SizedBox(height: SizeConfig.blockSizeVertical),

                            BlocListener<CloseULDCubit, CloseULDState>(
                              listener: (context, state) async {
                                if (state is CloseULDInitialState) {}
                                else if (state is CloseULDLoadingState) {
                                  // showing loading dialog in this state
                                  DialogUtils.showLoadingDialog(context, message: lableModel.loading);
                                }
                                else if (state is GetRemarkListSuccessState){
                                  DialogUtils.hideLoadingDialog(context);
                                  if(state.getRemarkListModel.status == "E"){
                                    Vibration.vibrate(duration: 500);
                                    SnackbarUtil.showSnackbar(context, state.getRemarkListModel.statusMessage!, MyColor.colorRed, icon: FontAwesomeIcons.times);
                                  }else{
                                    getRemarkListModel = state.getRemarkListModel;
                                    uLDRemarksList = state.getRemarkListModel.uLDRemarksList!;
                                    remarkController.text = getRemarkListModel!.uLDRemarksDetail!.remarks!;
                                    setState(() {

                                    });
                                    // responce

                                  }
                                }
                                else if (state is GetRemarkListFailureState){
                                  DialogUtils.hideLoadingDialog(context);
                                  Vibration.vibrate(duration: 500);
                                  SnackbarUtil.showSnackbar(context, state.error, MyColor.colorRed, icon: FontAwesomeIcons.times);
                                }
                                else if (state is SaveRemarkSuccessState){
                                  DialogUtils.hideLoadingDialog(context);
                                  if(state.saveRemarkModel.status == "E"){
                                    Vibration.vibrate(duration: 500);
                                    SnackbarUtil.showSnackbar(context, state.saveRemarkModel.statusMessage!, MyColor.colorRed, icon: FontAwesomeIcons.times);
                                  } else if(state.saveRemarkModel.status == "V"){
                                    Vibration.vibrate(duration: 500);
                                    SnackbarUtil.showSnackbar(context, state.saveRemarkModel.statusMessage!, MyColor.colorRed, icon: FontAwesomeIcons.times);
                                  }else{
                                    getRemarkList();
                                  }
                                }
                                else if (state is SaveRemarkFailureState){
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

                                          ListView.builder(
                                            itemCount: uLDRemarksList.length,
                                            shrinkWrap: true,
                                            physics: const NeverScrollableScrollPhysics(),
                                            itemBuilder: (context, index) {

                                              ULDRemarksList content = uLDRemarksList[index];
                                              return InkWell(
                                                onTap: () {
                                                  _handleTap(content, index);
                                                },
                                                child: Row(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    CustomeText(
                                                      text: "${index + 1}",
                                                      fontColor: MyColor.textColorGrey3,
                                                      fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_7,
                                                      fontWeight: FontWeight.w500,
                                                      textAlign: TextAlign.start,
                                                    ),
                                                    SizedBox(width: 8), // Add spacing between index and container
                                                    Expanded( // Ensures RichText can use available space
                                                      child: Container(
                                                        padding: const EdgeInsets.all(10),
                                                        margin: const EdgeInsets.only(bottom: 8),
                                                        decoration: BoxDecoration(
                                                          color: MyColor.subMenuColorList[index % MyColor.subMenuColorList.length],
                                                          borderRadius: BorderRadius.circular(8),
                                                          boxShadow: [
                                                            BoxShadow(
                                                              color: MyColor.colorBlack.withOpacity(0.09),
                                                              spreadRadius: 2,
                                                              blurRadius: 15,
                                                              offset: Offset(0, 3), // Changes position of shadow
                                                            ),
                                                          ],
                                                        ),
                                                        child: RichText(
                                                          text: _buildTextSpan(content.referenceDescription!),
                                                          // Prevents overflow
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            },
                                          ),




                                        ],
                                      ),
                                    ),
                                  )),
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
                                        Navigator.pop(context, null);  // Return null when "Cancel" is pressed
                                      },
                                    ),
                                  ),
                                  SizedBox(width: SizeConfig.blockSizeHorizontal * SizeUtils.HEIGHT7,),
                                  Expanded(
                                    flex: 1,
                                    child: RoundedButtonBlue(
                                      text: "Save",
                                      press: () {

                                        if(remarkController.text.isNotEmpty){
                                          if(remarkController.text.length >= 53){
                                            Vibration.vibrate(duration: 500);
                                            SnackbarUtil.showSnackbar(context, "Remarks should not be more than 53 characters.", MyColor.colorRed, icon: FontAwesomeIcons.times);
                                            WidgetsBinding.instance.addPostFrameCallback((_) {
                                              FocusScope.of(context).requestFocus(remarkFocus);
                                            });
                                          }else{
                                            saveRemark();
                                          }

                                        }else{
                                          Vibration.vibrate(duration: 500);
                                          SnackbarUtil.showSnackbar(context, lableModel.enterRemarkMsg!, MyColor.colorRed, icon: FontAwesomeIcons.times);
                                          WidgetsBinding.instance.addPostFrameCallback((_) {
                                            FocusScope.of(context).requestFocus(remarkFocus);
                                          });
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

  void _handleTap(ULDRemarksList content, int index) async {
    // Check if content contains placeholders
    final regex = RegExp(r"\{(.*?)\}");
    final matches = regex.allMatches(content.referenceDescription!);

    if (matches.isNotEmpty) {
      // Extract placeholders
      Map<String, String> placeholders = {};
      for (var match in matches) {
        String key = match.group(1)!;
        placeholders[key] = "";
      }

      // Open dialog to edit placeholders
      Map<String, String>? updatedValues = await showDialog(
        context: context,
        builder: (context) {
          Map<String, TextEditingController> controllers = {};
          placeholders.forEach((key, value) {
            controllers[key] = TextEditingController(text: value);
          });

          return AlertDialog(
            backgroundColor: MyColor.colorWhite,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16), // Set custom corner radius
            ),
            title:  CustomeText(
                text: "Edit Values",
                fontColor: MyColor.textColorGrey2,
                fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_6,
                fontWeight: FontWeight.w700,
                textAlign: TextAlign.start),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: controllers.keys.map((key) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: RemarkCustomTextField(
                    controller: controllers[key],
                    hasIcon: false,
                    hastextcolor: true,
                    animatedLabel: true,
                    needOutlineBorder: true,
                    labelText: key,
                    onChanged: (value, validate) {},
                    readOnly: false,
                    fillColor: Colors.grey.shade100,
                    textInputType: TextInputType.text,
                    inputAction: TextInputAction.next,
                    hintTextcolor: Colors.black45,
                    maxLines: 1,
                    maxLength: 10,
                    digitsOnly: false,
                    doubleDigitOnly: false,
                    fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
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
                );
              }).toList(),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(null);
                },
                child: Text("Cancel"),
              ),
              TextButton(
                onPressed: () {
                  Map<String, String> result = {};
                  controllers.forEach((key, controller) {
                    result[key] = controller.text;
                  });
                  Navigator.of(context).pop(result);
                },
                child: Text("Save"),
              ),
            ],
          );
        },
      );

      // Update the remarkList if values are provided
      if (updatedValues != null) {
        String updatedContent = content.referenceDescription!;
        updatedValues.forEach((key, value) {
          updatedContent = updatedContent.replaceAll("{$key}", value);
        });

        remarkController.text = updatedContent;
       /* setState(() {

          //remarkList[index] = updatedContent;
        });*/
      }
    } else {
      // Directly set content in the remarkController if no placeholders
      remarkController.text = content.referenceDescription!;
    }
  }


  Future<void> getRemarkList() async {
    await context.read<CloseULDCubit>().getRemarkList(
        widget.uldSeqNo,
        _user!.userProfile!.userIdentity!,
        _splashDefaultData!.companyCode!,
        widget.menuId);
  }

  Future<void> saveRemark() async {
    await context.read<CloseULDCubit>().saveRemark(
        widget.flightSeqNo,
        widget.uldSeqNo,
        remarkController.text,
        _user!.userProfile!.userIdentity!,
        _splashDefaultData!.companyCode!,
        widget.menuId);
  }

  TextSpan _buildTextSpan(String text) {
    final regex = RegExp(r"\{(.*?)\}");
    final matches = regex.allMatches(text);

    List<TextSpan> spans = [];
    int lastMatchEnd = 0;

    for (var match in matches) {
      // Add normal text before the match
      if (match.start > lastMatchEnd) {
        spans.add(TextSpan(
          text: text.substring(lastMatchEnd, match.start),
          style: GoogleFonts.roboto(
              textStyle: TextStyle(
                  fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_2_2,
                  color: MyColor.textColorGrey3,
                  fontWeight: FontWeight.normal,
                  decorationColor: MyColor.textColorGrey3
              )
          ),
        ));
      }

      // Add bold text for the match
      spans.add(TextSpan(
        text: text.substring(match.start, match.end),
        style: GoogleFonts.roboto(
            textStyle: TextStyle(
              fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_2_2,
              color: MyColor.textColorGrey3,
              fontWeight: FontWeight.bold,
              decorationColor: MyColor.textColorGrey3
            )
        ),
      ));

      lastMatchEnd = match.end;
    }

    // Add remaining normal text after the last match
    if (lastMatchEnd < text.length) {
      spans.add(TextSpan(
        text: text.substring(lastMatchEnd),
        style: GoogleFonts.roboto(
            textStyle: TextStyle(
              fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_2_2,
              color: MyColor.textColorGrey3,
              fontWeight: FontWeight.normal,
              decorationColor: MyColor.textColorGrey3
            )
        ),
      ));
    }

    return TextSpan(children: spans);
  }


}

