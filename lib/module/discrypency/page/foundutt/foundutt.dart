import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:galaxy/core/mycolor.dart';
import 'package:galaxy/module/discrypency/model/foundutt/getfounduttsearchmodel.dart';
import 'package:galaxy/module/discrypency/services/foundutt/founduttlogic/founduttcubit.dart';
import 'package:galaxy/module/discrypency/services/foundutt/founduttlogic/founduttstate.dart';
import 'package:galaxy/utils/sizeutils.dart';
import 'package:galaxy/utils/snackbarutil.dart';
import 'package:galaxy/widget/uldnumberwidget.dart';
import 'package:vibration/vibration.dart';
import '../../../../../../../widget/customeuiwidgets/header.dart';
import '../../../../../core/images.dart';
import '../../../../../language/appLocalizations.dart';
import '../../../../../language/model/lableModel.dart';
import '../../../../../manager/timermanager.dart';
import '../../../../../prefrence/savedprefrence.dart';
import '../../../../../utils/awbformatenumberutils.dart';
import '../../../../../utils/commonutils.dart';
import '../../../../../utils/dialogutils.dart';
import '../../../../../widget/customebuttons/roundbuttonblue.dart';
import '../../../../../widget/customedrawer/customedrawer.dart';
import '../../../../../widget/custometext.dart';
import '../../../../../widget/customtextfield.dart';
import '../../../../../widget/header/mainheadingwidget.dart';
import 'dart:ui' as ui;
import '../../../login/model/userlogindatamodel.dart';
import '../../../login/pages/signinscreenmethods.dart';
import '../../../onboarding/sizeconfig.dart';
import '../../../profile/page/profilepagescreen.dart';
import '../../../splash/model/splashdefaultmodel.dart';
import '../../../submenu/model/submenumodel.dart';
import 'founduttrecordpage.dart';


class FoundUTTPage extends StatefulWidget {
  String mainMenuName;
  String title;
  String refrelCode;
  LableModel? lableModel;
  int menuId;
  List<SubMenuName> importSubMenuList = [];
  List<SubMenuName> exportSubMenuList = [];

  FoundUTTPage(
      {super.key,
      required this.importSubMenuList,
      required this.exportSubMenuList,
      required this.title,
      required this.refrelCode,
      this.lableModel,
      required this.menuId,
      required this.mainMenuName});

  @override
  State<FoundUTTPage> createState() => _FoundUTTPageState();
}

class _FoundUTTPageState extends State<FoundUTTPage> with SingleTickerProviderStateMixin{


  InactivityTimerManager? inactivityTimerManager;
  final SavedPrefrence savedPrefrence = SavedPrefrence();
  UserDataModel? _user;
  SplashDefaultModel? _splashDefaultData;
  final ScrollController scrollController = ScrollController();


  FocusNode nextBtnFocusNode = FocusNode();
  FocusNode nextULDBtnFocusNode = FocusNode();



  bool isBackPressed = false; // Track if the back button was pressed





  GetFoundUTTSearchModel? getFoundUTTSearchModel;


  List<dynamic> combinedList = [];
  List<AWBDetailsList>? offloadAWBDetailsList = [];
  List<ULDDetailsList>? offloadULDDetailsList = [];


  late AnimationController _blinkController;
  late Animation<Color?> _colorAnimation;




  bool isInactivityDialogOpen = false; // Flag to track inactivity dialog state



  @override
  void initState() {
    super.initState();
  //  switchStates = List<bool>.filled(listValue.length, false);

    _loadUser(); //load user data

    _blinkController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: TickerProviders(), // Manually providing Ticker
    )..repeat(reverse: true); // Loop the animation

    _colorAnimation = ColorTween(
      begin: MyColor.shcColorList[0],
      end: Colors.transparent,
    ).animate(_blinkController);


  }



  Future<void> leaveGroupIdFocus() async {

    // Skip the focus leave logic if inactivity dialog is open
    if (isInactivityDialogOpen) return;

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
    //all controller and focus node dispose
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


    getFoundUTTPageLoad();



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
    Navigator.pop(context);
    inactivityTimerManager?.stopTimer();
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
                                clearText: "",
                                //add clear text to clear all feild
                                onClear: () {

                                },
                              ),
                            ),

                            // start api responcer
                            BlocListener<FoundUTTCubit, FoundUTTState>(
                              listener: (context, state) async {
                                if (state is FoundUTTInitialState) {
                                }
                                else if (state is FoundUTTLoadingState) {
                                  // showing loading dialog in this state
                                  DialogUtils.showLoadingDialog(context, message: lableModel!.loading);
                                }
                                else if (state is GetFoundUTTPageLoadSuccessState){
                                  DialogUtils.hideLoadingDialog(context);
                                  if(state.getFoundUTTPageLoadModel.status == "E"){
                                    Vibration.vibrate(duration: 500);
                                    SnackbarUtil.showSnackbar(context, state.getFoundUTTPageLoadModel.statusMessage!, MyColor.colorRed, icon: FontAwesomeIcons.times);
                                  }else{
                                    getFoundUTTSearch();
                                  }
                                }
                                else if(state is GetFoundUTTPageLoadFailureState){
                                  DialogUtils.hideLoadingDialog(context);
                                  Vibration.vibrate(duration: 500);
                                  SnackbarUtil.showSnackbar(context, state.error, MyColor.colorRed, icon: FontAwesomeIcons.times);
                                }
                                else if (state is GetFoundUTTSearchSuccessState){
                                  DialogUtils.hideLoadingDialog(context);
                                  if(state.getFoundUTTSearchModel.status == "E"){
                                    combinedList.clear();
                                    offloadAWBDetailsList!.clear();
                                    offloadULDDetailsList!.clear();

                                    Vibration.vibrate(duration: 500);
                                    SnackbarUtil.showSnackbar(context, state.getFoundUTTSearchModel.statusMessage!, MyColor.colorRed, icon: FontAwesomeIcons.times);
                                    setState(() {

                                    });

                                  }else if(state.getFoundUTTSearchModel.status == "V"){
                                    Vibration.vibrate(duration: 500);
                                    SnackbarUtil.showSnackbar(context, state.getFoundUTTSearchModel.statusMessage!, MyColor.colorRed, icon: FontAwesomeIcons.times);

                                  }else{
                                    // data will be display

                                    combinedList.clear();
                                    getFoundUTTSearchModel = state.getFoundUTTSearchModel;
                                    offloadAWBDetailsList = state.getFoundUTTSearchModel.aWBDetailsList;
                                    offloadULDDetailsList = state.getFoundUTTSearchModel.uLDDetailsList;

                                    if (offloadAWBDetailsList != null) {
                                      combinedList.addAll(offloadAWBDetailsList!);
                                    }
                                    if (offloadULDDetailsList != null) {
                                      combinedList.addAll(offloadULDDetailsList!);
                                    }


                                    setState(() {

                                    });
                                  }
                                }
                                else if (state is GetFoundUTTSearchFailureState){
                                  Vibration.vibrate(duration: 500);
                                  SnackbarUtil.showSnackbar(context, state.error, MyColor.colorRed, icon: FontAwesomeIcons.times);
                                }

                              },
                              child: Expanded(
                                child: SingleChildScrollView(
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 10, right: 10, top: 0, bottom: 0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [

                                        Directionality(textDirection: textDirection,
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
                                                child: (combinedList.isNotEmpty)
                                                    ? Column(
                                                  children: [

                                                    ListView.builder(
                                                      itemCount: (combinedList.isNotEmpty) ?  combinedList.length : 0,
                                                      physics: const NeverScrollableScrollPhysics(),
                                                      shrinkWrap: true,
                                                      controller: scrollController,
                                                      itemBuilder: (context, index) {
                                                        var item = combinedList[index];

                                                        if (item is AWBDetailsList) {
                                                          // Display AWB details
                                                          return buildAWBItem(item, lableModel!);
                                                        } else if (item is ULDDetailsList) {
                                                          // Display ULD details
                                                          return buildULDItem(item, lableModel!);
                                                        }
                                                        return SizedBox.shrink();

                                                      },
                                                    ),
                                                  ],
                                                )
                                                    : Padding(
                                                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                                                  child: Center(
                                                    child: CustomeText(text: "${lableModel!.recordNotFound}",
                                                        fontColor: MyColor.textColorGrey,
                                                        fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_2_0,
                                                        fontWeight: FontWeight.w500,
                                                        textAlign: TextAlign.center),),
                                                ),

                                              )
                                            )),
                                        SizedBox(height: SizeConfig.blockSizeVertical),


                                      ],
                                    ),
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


  Widget buildAWBItem(AWBDetailsList item, LableModel lableModel) {
    return InkWell(
        onTap: () {
          FocusScope.of(context).unfocus();

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
                  offset: Offset(0, 3), // changes position of shadow
                ),
              ],

            ),
            child: Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: MyColor.subMenuColorList[6].withOpacity(0.4),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: CustomeText(
                              text: AwbFormateNumberUtils.formatAWBNumber("${item.aWBNo}"),
                              fontColor: MyColor.textColorGrey3,
                              fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_7,
                              fontWeight: FontWeight.w600,
                              textAlign: TextAlign.start,
                            ),
                          ),
                          const SizedBox(width: 5),
                          Expanded(
                            child: Row(
                              children: [
                                CustomeText(
                                  text: "House :",
                                  fontColor: MyColor.textColorGrey2,
                                  fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                  fontWeight: FontWeight.w500,
                                  textAlign: TextAlign.start,
                                ),
                                const SizedBox(width: 5),
                                CustomeText(
                                  text: (item.houseNo!.isNotEmpty) ? "${item.houseNo}" : "-",
                                  fontColor: MyColor.colorBlack,
                                  fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_6,
                                  fontWeight: FontWeight.w600,
                                  textAlign: TextAlign.start,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: SizeConfig.blockSizeVertical),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            flex: 1,
                            child: Row(
                              children: [
                                CustomeText(
                                  text: "${lableModel.pieces} :",
                                  fontColor: MyColor.textColorGrey2,
                                  fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                  fontWeight: FontWeight.w500,
                                  textAlign: TextAlign.start,
                                ),
                                const SizedBox(width: 5),
                                CustomeText(
                                  text: "${item.nOP}",
                                  fontColor: MyColor.colorBlack,
                                  fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_6,
                                  fontWeight: FontWeight.w600,
                                  textAlign: TextAlign.start,
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Row(
                              children: [
                                CustomeText(
                                  text: "${lableModel.weight} :",
                                  fontColor: MyColor.textColorGrey2,
                                  fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                  fontWeight: FontWeight.w500,
                                  textAlign: TextAlign.start,
                                ),
                                const SizedBox(width: 5),
                                CustomeText(
                                  text: "${CommonUtils.formateToTwoDecimalPlacesValue(item.weightKg!)} Kg",
                                  fontColor: MyColor.colorBlack,
                                  fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_6,
                                  fontWeight: FontWeight.w600,
                                  textAlign: TextAlign.start,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: SizeConfig.blockSizeVertical),
                      IntrinsicHeight(
                        child: Row(
                          children: [
                            Expanded(
                              flex: 8,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Row(
                                    children: [
                                      CustomeText(
                                        text: "${lableModel.location} :",
                                        fontColor: MyColor.textColorGrey2,
                                        fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                        fontWeight: FontWeight.w500,
                                        textAlign: TextAlign.start,
                                      ),
                                      const SizedBox(width: 5),
                                      CustomeText(
                                        text: "${item.location}",
                                        fontColor: MyColor.colorBlack,
                                        fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_6,
                                        fontWeight: FontWeight.w600,
                                        textAlign: TextAlign.start,
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: SizeConfig.blockSizeVertical,),
                                  Row(
                                    children: [
                                      CustomeText(
                                        text: "${lableModel.group} :",
                                        fontColor: Colors.pink.shade500,
                                        fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                        fontWeight: FontWeight.bold,
                                        textAlign: TextAlign.start,
                                      ),
                                      const SizedBox(width: 5),
                                      CustomeText(
                                        text: (item.groupId!.isNotEmpty) ? "${item.groupId}" : "-",
                                        fontColor: Colors.pink.shade500,
                                        fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_6,
                                        fontWeight: FontWeight.bold,
                                        textAlign: TextAlign.start,
                                      ),
                                    ],
                                  ),

                                ],
                              ),
                            ),
                            SizedBox(width: SizeConfig.blockSizeHorizontal * SizeUtils.WIDTH3,),
                            Expanded(
                              flex: 3,
                              child: RoundedButtonBlue(text: "${lableModel.next}",
                                focusNode: nextBtnFocusNode,
                                press: () async {
                                  FocusScope.of(context).requestFocus(nextBtnFocusNode);
                                  _resumeTimerOnInteraction();

                                  String value = await Navigator.push(context, CupertinoPageRoute(
                                      builder: (context) => FoundUTTRecordPage(
                                          importSubMenuList: widget.importSubMenuList,
                                          exportSubMenuList: widget.exportSubMenuList,
                                          mainMenuName: widget.mainMenuName,
                                          menuId: widget.menuId,
                                          lableModel: lableModel,
                                          title: widget.title,
                                          refrelCode: widget.refrelCode,
                                          type: "A",
                                          awbDetailsList: item
                                      )));

                                  if(value == "true"){
                                    getFoundUTTSearch();
                                  }else{
                                    _resumeTimerOnInteraction();
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ),

                    ],
                  ),
                ],
              ),
            )
        )
    );



  }

  Widget buildULDItem(ULDDetailsList item, LableModel lableModel) {
    return InkWell(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        onDoubleTap: () async {

        },
        child: Container(
            margin: EdgeInsets.symmetric(vertical: 4),
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
            child: Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: MyColor.subMenuColorList[3].withOpacity(0.3),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                              child: Row(
                                children: [
                                  ULDNumberWidget(uldNo: "${item.uLDNo}", smallFontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5, bigFontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_8, fontColor: MyColor.textColorGrey3, uldType: "U"),
                                ],
                              )),
                          const SizedBox(width: 5),
                          Expanded(
                            child: Row(
                              children: [
                                CustomeText(
                                  text: "Owner :",
                                  fontColor: MyColor.textColorGrey2,
                                  fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                  fontWeight: FontWeight.w500,
                                  textAlign: TextAlign.start,
                                ),
                                const SizedBox(width: 5),
                                CustomeText(
                                  text: (item.uLDOwner!.isNotEmpty) ? "${item.uLDOwner}" : "-",
                                  fontColor: MyColor.colorBlack,
                                  fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_6,
                                  fontWeight: FontWeight.w600,
                                  textAlign: TextAlign.start,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: SizeConfig.blockSizeVertical,),
                      IntrinsicHeight(
                        child: Row(
                          children: [
                            Expanded(
                              flex: 8,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Row(
                                    children: [
                                      CustomeText(
                                        text: "${lableModel.location} :",
                                        fontColor: MyColor.textColorGrey2,
                                        fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                        fontWeight: FontWeight.w500,
                                        textAlign: TextAlign.start,
                                      ),
                                      const SizedBox(width: 5),
                                      CustomeText(
                                        text: "${item.location}",
                                        fontColor: MyColor.colorBlack,
                                        fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_6,
                                        fontWeight: FontWeight.w600,
                                        textAlign: TextAlign.start,
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: SizeConfig.blockSizeVertical,),
                                  Row(
                                    children: [
                                      CustomeText(
                                        text: "${lableModel.group} :",
                                        fontColor: Colors.pink.shade500,
                                        fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                        fontWeight: FontWeight.bold,
                                        textAlign: TextAlign.start,
                                      ),
                                      const SizedBox(width: 5),
                                      CustomeText(
                                        text: (item.groupId!.isNotEmpty) ? "${item.groupId}" : "-",
                                        fontColor: Colors.pink.shade500,
                                        fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_6,
                                        fontWeight: FontWeight.bold,
                                        textAlign: TextAlign.start,
                                      ),
                                    ],
                                  ),


                                ],
                              ),
                            ),
                            SizedBox(width: SizeConfig.blockSizeHorizontal * SizeUtils.WIDTH2,),
                            Expanded(
                              flex: 3,
                              child: RoundedButtonBlue(text: "${lableModel.next}",
                                focusNode: nextULDBtnFocusNode,
                                press: () async {
                                  FocusScope.of(context).requestFocus(nextULDBtnFocusNode);

                                  _resumeTimerOnInteraction();


                                  String value = await Navigator.push(context, CupertinoPageRoute(
                                      builder: (context) => FoundUTTRecordPage(
                                          importSubMenuList: widget.importSubMenuList,
                                          exportSubMenuList: widget.exportSubMenuList,
                                          mainMenuName: widget.mainMenuName,
                                          menuId: widget.menuId,
                                          lableModel: lableModel,
                                          title: widget.title,
                                          refrelCode: widget.refrelCode,
                                          type: "U",
                                          uldDetailsList: item
                                      )));

                                  if(value == "true"){
                                    getFoundUTTSearch();
                                  }else{
                                    _resumeTimerOnInteraction();
                                  }
                                },),
                            ),
                          ],
                        ),
                      ),

                    ],
                  ),
                ],
              ),
            )
        )
    );
  }



  Future<void> getFoundUTTPageLoad() async {

    await context.read<FoundUTTCubit>().getFoundUTTPageLoad(
        _user!.userProfile!.userIdentity!,
        _splashDefaultData!.companyCode!,
        widget.menuId);
  }


  Future<void> getFoundUTTSearch() async {

    await context.read<FoundUTTCubit>().getFoundUTTSearchRecord(
        "",
        _user!.userProfile!.userIdentity!,
        _splashDefaultData!.companyCode!,
        widget.menuId);
  }

}

class TickerProviders extends TickerProvider {
  @override
  Ticker createTicker(onTick) => Ticker(onTick);
}

