import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:galaxy/core/mycolor.dart';
import 'package:galaxy/utils/sizeutils.dart';
import 'package:galaxy/utils/snackbarutil.dart';
import 'package:vibration/vibration.dart';
import '../../../../../../widget/customeuiwidgets/header.dart';
import '../../../../core/images.dart';
import '../../../../language/appLocalizations.dart';
import '../../../../language/model/lableModel.dart';
import '../../../../manager/timermanager.dart';
import '../../../../prefrence/savedprefrence.dart';
import '../../../../utils/awbformatenumberutils.dart';
import '../../../../utils/commonutils.dart';
import '../../../../utils/dialogutils.dart';
import '../../../../widget/customdivider.dart';
import '../../../../widget/customebuttons/roundbuttonblue.dart';
import '../../../../widget/customedrawer/customedrawer.dart';
import '../../../../widget/customeedittext/customeedittextwithborder.dart';
import '../../../../widget/custometext.dart';
import '../../../../widget/customtextfield.dart';
import '../../../../widget/header/mainheadingwidget.dart';
import '../../../../widget/roundbutton.dart';
import '../../../login/pages/signinscreenmethods.dart';
import '../../../profile/page/profilepagescreen.dart';
import '../../../splash/model/splashdefaultmodel.dart';
import '../../../onboarding/sizeconfig.dart';
import 'dart:ui' as ui;

import '../../../login/model/userlogindatamodel.dart';
import '../../../submenu/model/submenumodel.dart';
import '../../model/binning/binningdetaillistmodel.dart';
import '../../services/binning/binninglogic/binningcubit.dart';
import '../../services/binning/binninglogic/binningstate.dart';

class Binning extends StatefulWidget {
  String mainMenuName;
  String title;
  String refrelCode;
  LableModel? lableModel;
  int menuId;
  List<SubMenuName> importSubMenuList = [];
  List<SubMenuName> exportSubMenuList = [];

  Binning(
      {super.key,
      required this.importSubMenuList,
      required this.exportSubMenuList,
      required this.title,
      required this.refrelCode,
      this.lableModel,
      required this.menuId,
      required this.mainMenuName});

  @override
  State<Binning> createState() => _BinningState();
}

class _BinningState extends State<Binning> with SingleTickerProviderStateMixin{
  int groupIDCharSize = 1;

  InactivityTimerManager? inactivityTimerManager;
  final SavedPrefrence savedPrefrence = SavedPrefrence();
  UserDataModel? _user;
  SplashDefaultModel? _splashDefaultData;
  final ScrollController scrollController = ScrollController();

  TextEditingController groupIdController = TextEditingController();
  TextEditingController locationController = TextEditingController();

  FocusNode locationFocusNode = FocusNode();
  FocusNode groupIdFocusNode = FocusNode();

  bool _isvalidateLocation = false;

  bool isBackPressed = false; // Track if the back button was pressed

  BinningDetailListModel? binningDetailListModel;


  int? _selectedIndex;

  int? _isExpandedDetails;


  late AnimationController _blinkController;
  late Animation<Color?> _colorAnimation;

  bool isInactivityDialogOpen = false; // Flag to track inactivity dialog state

  bool _isLocationSearchBtnEnable = false;
  @override
  void initState() {
    super.initState();

    print("CHECK_IMPORTLIST==== ${widget.importSubMenuList.length}");
    print("CHECK_IMPORTLIST==== ${widget.exportSubMenuList.length}");

    _loadUser(); //load user data

    _blinkController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: TickerProviders(), // Manually providing Ticker
    )..repeat(reverse: true); // Loop the animation

    _colorAnimation = ColorTween(
      begin: MyColor.shcColorList[0],
      end: Colors.transparent,
    ).animate(_blinkController);

    locationFocusNode.addListener(() {
      if (!locationFocusNode.hasFocus && !isBackPressed) {
        leaveLocationFocus();
      }
    });


    locationController.addListener(_validateLocationSearchBtn);



    groupIdFocusNode.addListener(() {
      if (!groupIdFocusNode.hasFocus && !isBackPressed) {
        leaveGroupIdFocus();
      }
    });



  }


  Future<void> leaveLocationFocus() async {
    if (locationController.text.isNotEmpty) {
      //call location validation api
      await context.read<BinningCubit>().getValidateLocation(
          locationController.text,
          _user!.userProfile!.userIdentity!,
          _splashDefaultData!.companyCode!,
          widget.menuId,
          "a");
    }
  }

  void _validateLocationSearchBtn() {
    setState(() {
      _isLocationSearchBtnEnable = locationController.text.isNotEmpty;
    });
  }


  Future<void> leaveGroupIdFocus() async {

    // Skip the focus leave logic if inactivity dialog is open
    if (isInactivityDialogOpen) return;

    if (groupIdController.text.isNotEmpty) {

      if (groupIdController.text.length != groupIDCharSize) {
        openValidationDialog(CommonUtils.formatMessage("${widget.lableModel!.groupIdCharSizeMsg}", ["$groupIDCharSize"]), groupIdFocusNode);
        return;
      }

      // call binning details api
      await context.read<BinningCubit>().getBinningDetailListApi(
          groupIdController.text,
          _user!.userProfile!.userIdentity!,
          _splashDefaultData!.companyCode!,
          widget.menuId);
    }else{
      FocusScope.of(context).requestFocus(groupIdFocusNode);
      SnackbarUtil.showSnackbar(context, widget.lableModel!.enterGropIdMsg!, MyColor.colorRed, icon: FontAwesomeIcons.times);
      binningDetailListModel = null;
      setState(() {

      });
    }
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
    groupIdFocusNode.dispose();
    locationController.dispose();
    locationFocusNode.dispose();
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

    context.read<BinningCubit>().getPageLoadDefault(widget.menuId, _user!.userProfile!.userIdentity!, _splashDefaultData!.companyCode!);

    inactivityTimerManager = InactivityTimerManager(
      context: context,
      timeoutMinutes: _splashDefaultData!.activeLoginTime!,
      // Set the desired inactivity time here
      onTimeout: _handleInactivityTimeout, // Define what happens when timeout occurs
    );
    inactivityTimerManager?.startTimer();
  }

  Future<void> _handleInactivityTimeout() async {
    groupIdFocusNode.unfocus();
    isInactivityDialogOpen = true; // Set flag before showing dialog

    bool? activateORNot = await DialogUtils.showingActivateTimerDialog(
        context, _user!.userProfile!.userId!, _splashDefaultData!.companyCode!);

    isInactivityDialogOpen = false; // Reset flag after dialog closes

    if (activateORNot == true) {
      inactivityTimerManager!.resetTimer();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        FocusScope.of(context).requestFocus(groupIdFocusNode);
      },
      );
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
    groupIdFocusNode.unfocus();
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
                      FocusScope.of(context).unfocus();
                      groupIdFocusNode.unfocus();
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
                                  binningDetailListModel = null;
                                  groupIdController.clear();
                                  locationController.clear();
                                  _isvalidateLocation = false;
                                  WidgetsBinding.instance.addPostFrameCallback((_) {
                                    FocusScope.of(context).requestFocus(groupIdFocusNode);
                                  },
                                  );
                                  setState(() {

                                  });
                                },
                              ),
                            ),

                            // start api responcer
                            BlocListener<BinningCubit, BinningState>(
                              listener: (context, state) async {
                                if (state is MainInitialState) {
                                }
                                else if (state is MainLoadingState) {
                                  // showing loading dialog in this state
                                  DialogUtils.showLoadingDialog(context, message: lableModel.loading);
                                }
                                else if (state is BinningValidateLocationSuccessState) {
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
                                    /*WidgetsBinding.instance.addPostFrameCallback((_) {
                                      FocusScope.of(context).requestFocus(igmNoFocusNode);
                                    },
                                    );*/
                                  }
                                }
                                else if (state is BinningValidateLocationFailureState) {
                                  // validate location failure
                                  DialogUtils.hideLoadingDialog(context);
                                  _isvalidateLocation = false;
                                  Vibration.vibrate(duration: 500);
                                  SnackbarUtil.showSnackbar(
                                      context, state.error, MyColor.colorRed, icon: FontAwesomeIcons.times);
                                }

                                else if(state is BinningPageLoadDefaultSuccessState){
                                  DialogUtils.hideLoadingDialog(context);
                                  if(state.binningPageLoadDefaultModel.status == "E"){
                                    _onWillPop();
                                  }else{
                                    groupIDCharSize = state.binningPageLoadDefaultModel.IsGroupBasedAcceptNumber!;
                                    setState(() {

                                    });
                                    WidgetsBinding.instance.addPostFrameCallback((_) {
                                      FocusScope.of(context).requestFocus(groupIdFocusNode);
                                    },
                                    );
                                  }
                                }
                                else if (state is BinningPageLoadDefaultFailureState){
                                  DialogUtils.hideLoadingDialog(context);
                                  _onWillPop();
                                }
                                else if (state is BinningDetailListSuccessState){
                                  DialogUtils.hideLoadingDialog(context);
                                  if(state.binningDetailListModel.status == "E"){
                                    SnackbarUtil.showSnackbar(context, state.binningDetailListModel.statusMessage!, MyColor.colorRed, icon: FontAwesomeIcons.times);
                                    Vibration.vibrate(duration: 500);
                                    binningDetailListModel = null;

                                    WidgetsBinding.instance.addPostFrameCallback((_) {
                                      FocusScope.of(context).requestFocus(groupIdFocusNode);
                                    },
                                    );
                                    setState(() {

                                    });
                                  }else{

                                    binningDetailListModel = state.binningDetailListModel;
                                    locationController.clear();

                                    WidgetsBinding.instance.addPostFrameCallback((_) {
                                      FocusScope.of(context).requestFocus(locationFocusNode);
                                    },
                                    );
                                    setState(() {
                                      _isvalidateLocation = false;
                                    });
                                  }


                                }
                                else if (state is BinningDetailListFailureState){
                                  DialogUtils.hideLoadingDialog(context);
                                  SnackbarUtil.showSnackbar(context, state.error, MyColor.colorRed, icon: FontAwesomeIcons.times);
                                  Vibration.vibrate(duration: 500);
                                  setState(() {

                                  });
                                }
                                else if (state is BinningSaveSuccessState){
                                  DialogUtils.hideLoadingDialog(context);

                                  if(state.binningSaveModel.status == "E"){
                                    Vibration.vibrate(duration: 500);
                                    SnackbarUtil.showSnackbar(
                                        context,
                                        state.binningSaveModel.statusMessage!,
                                        MyColor.colorRed,
                                        icon: FontAwesomeIcons.times);
                                  }else{
                                    SnackbarUtil.showSnackbar(
                                        context,
                                        state.binningSaveModel.statusMessage!,
                                        MyColor.colorGreen,
                                        icon: Icons.done);

                                    await context.read<BinningCubit>().getBinningDetailListApi(
                                        groupIdController.text,
                                        _user!.userProfile!.userIdentity!,
                                        _splashDefaultData!.companyCode!,
                                        widget.menuId);
                                  }

                                }

                              },
                              child: Expanded(
                                child: SingleChildScrollView(
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 10, right: 10, top: 0, bottom: 0),
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
                                                textDirection: textDirection,
                                                child: Row(
                                                  children: [
                                                    SvgPicture.asset(info,
                                                      height: SizeConfig.blockSizeVertical * SizeUtils.ICONSIZE2,
                                                    ),
                                                    SizedBox(
                                                      width: SizeConfig.blockSizeHorizontal,
                                                    ),
                                                    CustomeText(
                                                        text: "${lableModel.scanOrManual}",
                                                        fontColor: MyColor.textColorGrey2,
                                                        fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                                        fontWeight: FontWeight.w500,
                                                        textAlign: TextAlign.start)
                                                  ],
                                                ),
                                              ),
                                              SizedBox(
                                                  height: SizeConfig.blockSizeVertical * SizeUtils.HEIGHT2),
                                              // text manifest and recived in pices text counter
                                              Directionality(
                                                textDirection: textDirection,
                                                child: Row(
                                                  children: [
                                                    Expanded(
                                                      flex :1,
                                                      child: CustomTextField(
                                                        textDirection: textDirection,
                                                        controller: groupIdController,
                                                        focusNode: groupIdFocusNode,
                                                        onPress: () {},
                                                        hasIcon: false,
                                                        hastextcolor: true,
                                                        animatedLabel: true,
                                                        needOutlineBorder: true,
                                                        labelText: "${lableModel.groupId} *",
                                                        readOnly: false,
                                                        maxLength: groupIDCharSize,
                                                        onChanged: (value) {
                                                          binningDetailListModel = null;
                                                          locationController.clear();
                                                          _isvalidateLocation = false;
                                                          setState(() {

                                                          });
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
                                                    ),
                                                    SizedBox(
                                                      width: SizeConfig.blockSizeHorizontal,
                                                    ),
                                                    // click search button to validate location
                                                    InkWell(
                                                      onTap: () {
                                                        scanGroupQR();
                                                      },
                                                      child: Padding(padding: const EdgeInsets.all(8.0),
                                                        child: SvgPicture.asset(search, height: SizeConfig.blockSizeVertical * SizeUtils.ICONSIZE3,),
                                                      ),

                                                    )
                                                  ],
                                                ),
                                              ),
                                              SizedBox(height: SizeConfig.blockSizeVertical * SizeUtils.HEIGHT2),
                                              Directionality(
                                                textDirection: textDirection,
                                                child: IntrinsicHeight(
                                                  child: Row(
                                                    children: [
                                                      Expanded(
                                                        flex:1,
                                                        child: Column(
                                                          children: [
                                                            CustomeEditTextWithBorder(
                                                              lablekey: "LOCATION",
                                                              textDirection: textDirection,
                                                              controller: locationController,
                                                              focusNode: locationFocusNode,
                                                              hasIcon: false,
                                                              hastextcolor: true,
                                                              animatedLabel: true,
                                                              needOutlineBorder: true,
                                                              labelText: "${lableModel.location} *",
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
                                                            SizedBox(height:  SizeConfig.blockSizeVertical,),
                                                            RoundedButtonBlue(
                                                              text: "${lableModel.cancel}",
                                                              press: () async {
                                                                _onWillPop();
                                                              },
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      SizedBox(width: SizeConfig.blockSizeHorizontal * SizeUtils.WIDTH2,),
                                                      Expanded(
                                                        flex:1,
                                                        child: Container(
                                                          height: double.infinity,
                                                          child: RoundedButton(
                                                            color: (_isvalidateLocation) ? MyColor.primaryColorblue : MyColor.colorGrey.withOpacity(0.3),
                                                            text: "${lableModel.move}",
                                                            press: () async {


                                                              if(_isvalidateLocation){

                                                                if(binningDetailListModel != null) {
                                                                  if (groupIdController.text.isEmpty) {
                                                                    openValidationDialog("${lableModel.enterGropIdMsg}", groupIdFocusNode);
                                                                    return;
                                                                  }

                                                                  if (groupIdController.text.length != groupIDCharSize) {
                                                                    openValidationDialog(
                                                                        CommonUtils.formatMessage("${lableModel.groupIdCharSizeMsg}", ["$groupIDCharSize"]),
                                                                        groupIdFocusNode);
                                                                    return;
                                                                  }

                                                                  if (locationController.text.isEmpty) {
                                                                    openValidationDialog("${lableModel.enterLocationMsg}", locationFocusNode);
                                                                    return;
                                                                  }



                                                                  context.read<BinningCubit>().getBinningSaveApi(groupIdController.text,
                                                                      binningDetailListModel!.binningDetailList![0].aWBNo!.replaceAll(" ", ""),
                                                                      binningDetailListModel!.binningDetailList![0].hAWBNo!,
                                                                      binningDetailListModel!.binningDetailList![0].flightSeqNo!,
                                                                      binningDetailListModel!.binningDetailList![0].iGMNo!,
                                                                      locationController.text,
                                                                      binningDetailListModel!.binningSummary!.currentLocationId!,
                                                                      binningDetailListModel!.binningDetailList![0].nOP!,
                                                                      _user!.userProfile!.userIdentity!,
                                                                      _splashDefaultData!.companyCode!,
                                                                      widget.menuId);



                                                                }
                                                              }else{


                                                              }

                                                            },
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(height: SizeConfig.blockSizeVertical),
                                        Directionality(
                                          textDirection: textDirection,
                                          child: Container(
                                            width: double.infinity,
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
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              children: [

                                                Row(
                                                  children: [
                                                    Expanded(
                                                      flex :1,
                                                      child: CustomeText(
                                                          text: "Currunt Location : ",
                                                          fontColor: MyColor.textColorGrey2,
                                                          fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                                          fontWeight: FontWeight.w400,
                                                          textAlign: TextAlign.start),
                                                    ),
                                                    Expanded(
                                                      flex:1,
                                                      child: Row(
                                                        children: [
                                                          SvgPicture.asset(map, height: SizeConfig.blockSizeVertical * SizeUtils.ICONSIZE2,),
                                                          SizedBox(width: SizeConfig.blockSizeHorizontal,),
                                                          CustomeText(
                                                            text: (binningDetailListModel != null) ? binningDetailListModel!.binningSummary!.currentLocationCode! : "",
                                                            fontColor: MyColor.textColorGrey3,
                                                            fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
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
                                                  children: [
                                                    Expanded(
                                                      flex: 1,
                                                      child: CustomeText(
                                                          text: "Suggestion : ",
                                                          fontColor: MyColor.textColorGrey2,
                                                          fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                                          fontWeight: FontWeight.w400,
                                                          textAlign: TextAlign.start),
                                                    ),
                                                    Expanded(
                                                      flex: 1,
                                                      child: CustomeText(
                                                          text: (binningDetailListModel != null) ? (binningDetailListModel!.binningSummary!.suggestion!.isNotEmpty) ? binningDetailListModel!.binningSummary!.suggestion! : "-" : "-",
                                                          fontColor: MyColor.textColorGrey3,
                                                          fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                                          fontWeight: FontWeight.w500,
                                                          textAlign: TextAlign.start),
                                                    )
                                                  ],
                                                )

                                              ],
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: SizeConfig.blockSizeVertical),
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
                                                child: (binningDetailListModel != null)
                                                    ? (binningDetailListModel!.binningDetailList!.isNotEmpty) ? Column(
                                                  children: [

                                                    ListView.builder(
                                                      itemCount: (binningDetailListModel != null)
                                                          ? binningDetailListModel!.binningDetailList!.length
                                                          : 0,
                                                      physics: NeverScrollableScrollPhysics(),
                                                      shrinkWrap: true,
                                                      controller: scrollController,
                                                      itemBuilder: (context, index) {
                                                        BinningDetailList binningDetail = binningDetailListModel!.binningDetailList![index];
                                                        bool isSelected = _selectedIndex == index;
                                                        bool isExpand = _isExpandedDetails == index;
                                                        List<String> shcCodes = binningDetail.sHCCode!.split(',');

                                                        return InkWell(
                                                            onTap: () {
                                                              FocusScope.of(context).unfocus();
                                                              setState(() {
                                                                _selectedIndex = index; // Update the selected index
                                                              });
                                                            },
                                                            onDoubleTap: () async {

                                                              setState(() {
                                                                _selectedIndex = index; // Update the selected index
                                                              });

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
                                                                child: DottedBorder(
                                                                  dashPattern: [7, 7, 7, 7],
                                                                  strokeWidth: 1,
                                                                  borderType: BorderType.RRect,
                                                                  color: binningDetail.sHCCode!.contains("DGR") ? MyColor.colorRedLight : Colors.transparent,
                                                                  radius: Radius.circular(8),
                                                                  child: Container(
                                                                    /*    margin: aWBItem.sHCCode!.contains("DGR") ? EdgeInsets.all(3) : EdgeInsets.all(0),*/
                                                                    padding: EdgeInsets.all(8),
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
                                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                              children: [
                                                                                Row(
                                                                                  children: [
                                                                                    CustomeText(
                                                                                      text: "${binningDetail.flightNo!}",
                                                                                      fontColor: MyColor.colorBlack,
                                                                                      fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                                                                      fontWeight: FontWeight.w600,
                                                                                      textAlign: TextAlign.start,
                                                                                    ),
                                                                                    SizedBox(width: 5),
                                                                                    CustomeText(
                                                                                      text: " ${binningDetail.flightDate!.replaceAll(" ", "-")}",
                                                                                      fontColor: MyColor.textColorGrey2,
                                                                                      fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                                                                      fontWeight: FontWeight.w600,
                                                                                      textAlign: TextAlign.start,
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                                CustomeText(
                                                                                  text: (binningDetail.hAWBNo!.isNotEmpty) ? "House" : "",
                                                                                  fontColor: MyColor.colorBlack,
                                                                                  fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                                                                  fontWeight: FontWeight.w600,
                                                                                  textAlign: TextAlign.start,
                                                                                ),
                                                                              ],
                                                                            ),
                                                                            SizedBox(height: SizeConfig.blockSizeVertical * 0.5,),
                                                                            Row(
                                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                              children: [
                                                                                CustomeText(text: AwbFormateNumberUtils.formatAWBNumber(binningDetail.aWBNo!), fontColor: MyColor.colorBlack, fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_6, fontWeight: FontWeight.w700, textAlign: TextAlign.start),
                                                                                CustomeText(text: (binningDetail.hAWBNo!.isNotEmpty) ? binningDetail.hAWBNo! : "", fontColor: MyColor.colorBlack, fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_6, fontWeight: FontWeight.w700, textAlign: TextAlign.start),

                                                                              ],
                                                                            ),
                                                                            binningDetail.sHCCode!.isNotEmpty ? SizedBox(height: SizeConfig.blockSizeVertical * 0.8,) : SizedBox(),
                                                                            Row(
                                                                              children: [
                                                                                binningDetail.sHCCode!.isNotEmpty
                                                                                    ? Row(
                                                                                  children:shcCodes.asMap().entries.take(3).map((entry) {
                                                                                    int index = entry.key; // Get the index for colorList assignment
                                                                                    String code = entry.value.trim(); // Get the code value and trim it

                                                                                    return Padding(
                                                                                      padding: EdgeInsets.only(right: 5.0),
                                                                                      child: AnimatedBuilder(
                                                                                        animation: _colorAnimation,
                                                                                        builder: (context, child) {
                                                                                          return Container(
                                                                                            padding : EdgeInsets.symmetric(horizontal: SizeConfig.blockSizeHorizontal * 1.2, vertical: 1),
                                                                                            decoration : BoxDecoration(
                                                                                              borderRadius: BorderRadius.circular(5),
                                                                                              color: (code.trim() == "DGR") ? _colorAnimation.value! : MyColor.shcColorList[index % MyColor.shcColorList.length],),
                                                                                            child: CustomeText(
                                                                                              text: code.trim(),
                                                                                              fontColor: MyColor.textColorGrey3,
                                                                                              fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_3,
                                                                                              fontWeight: FontWeight.w500,
                                                                                              textAlign: TextAlign.center,
                                                                                            ),
                                                                                          );
                                                                                        },
                                                                                      ),
                                                                                    );
                                                                                  }).toList(),
                                                                                )
                                                                                    : SizedBox(),
                                                                              ],
                                                                            ),
                                                                            binningDetail.sHCCode!.isNotEmpty ? SizedBox(height: SizeConfig.blockSizeVertical) : SizedBox(height: SizeConfig.blockSizeVertical * 0.8,),
                                                                            Row(
                                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                              children: [
                                                                                Row(
                                                                                  children: [
                                                                                    CustomeText(
                                                                                      text: "NOP :",
                                                                                      fontColor: MyColor.textColorGrey2,
                                                                                      fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                                                                      fontWeight: FontWeight.w400,
                                                                                      textAlign: TextAlign.start,
                                                                                    ),
                                                                                    SizedBox(width: 5),
                                                                                    CustomeText(
                                                                                      text: "${binningDetail.nOP}",
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
                                                                                      text: "${lableModel.weight} :",
                                                                                      fontColor: MyColor.textColorGrey2,
                                                                                      fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                                                                      fontWeight: FontWeight.w400,
                                                                                      textAlign: TextAlign.start,
                                                                                    ),
                                                                                    SizedBox(width: 5),
                                                                                    CustomeText(
                                                                                      text: CommonUtils.formateToTwoDecimalPlacesValue(binningDetail.weight!),
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
                                                                                      text: "${lableModel.volume} :",
                                                                                      fontColor: MyColor.textColorGrey2,
                                                                                      fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                                                                      fontWeight: FontWeight.w400,
                                                                                      textAlign: TextAlign.start,
                                                                                    ),
                                                                                    SizedBox(width: 5),
                                                                                    CustomeText(
                                                                                      text: CommonUtils.formateToTwoDecimalPlacesValue(binningDetail.volume!),
                                                                                      fontColor: MyColor.colorBlack,
                                                                                      fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                                                                      fontWeight: FontWeight.w600,
                                                                                      textAlign: TextAlign.start,
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                              ],
                                                                            ),

                                                                            (isExpand)
                                                                                ? Column(
                                                                              children: [
                                                                                SizedBox(height: SizeConfig.blockSizeVertical * 0.8,),
                                                                                Row(
                                                                                  children: [
                                                                                    CustomeText(
                                                                                      text: "NOG :",
                                                                                      fontColor: MyColor.textColorGrey2,
                                                                                      fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                                                                      fontWeight: FontWeight.w400,
                                                                                      textAlign: TextAlign.start,
                                                                                    ),
                                                                                    SizedBox(width: 5),
                                                                                    CustomeText(
                                                                                      text: binningDetail.nOG!,
                                                                                      fontColor: MyColor.colorBlack,
                                                                                      fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                                                                      fontWeight: FontWeight.w600,
                                                                                      textAlign: TextAlign.start,
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                                SizedBox(height: SizeConfig.blockSizeVertical * 0.8,),
                                                                                Row(
                                                                                  children: [
                                                                                    CustomeText(
                                                                                      text: "Commodity :",
                                                                                      fontColor: MyColor.textColorGrey2,
                                                                                      fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                                                                      fontWeight: FontWeight.w400,
                                                                                      textAlign: TextAlign.start,
                                                                                    ),
                                                                                    SizedBox(width: 5),
                                                                                    CustomeText(
                                                                                      text: "${binningDetail.commodity}",
                                                                                      fontColor: MyColor.colorBlack,
                                                                                      fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                                                                      fontWeight: FontWeight.w500,
                                                                                      textAlign: TextAlign.start,
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                                SizedBox(height: SizeConfig.blockSizeVertical * 0.8,),
                                                                                Row(
                                                                                  children: [
                                                                                    CustomeText(
                                                                                      text: "Remark :",
                                                                                      fontColor: MyColor.textColorGrey2,
                                                                                      fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                                                                      fontWeight: FontWeight.w400,
                                                                                      textAlign: TextAlign.start,
                                                                                    ),
                                                                                    SizedBox(width: 5),
                                                                                    CustomeText(
                                                                                      text: "${binningDetail.remark}",
                                                                                      fontColor: MyColor.colorBlack,
                                                                                      fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                                                                      fontWeight: FontWeight.w500,
                                                                                      textAlign: TextAlign.start,
                                                                                    ),
                                                                                  ],
                                                                                ),

                                                                              ],
                                                                            )
                                                                                : SizedBox(),


                                                                            SizedBox(height: SizeConfig.blockSizeVertical,),
                                                                            CustomDivider(
                                                                              space: 0,
                                                                              color: MyColor.textColorGrey,
                                                                              hascolor: true,
                                                                              thickness: 1,
                                                                            ),
                                                                            SizedBox(height: SizeConfig.blockSizeVertical,),
                                                                            Row(
                                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                              children: [
                                                                                InkWell(
                                                                                    onTap: () async {

                                                                                      setState(() {
                                                                                        _selectedIndex = index;
                                                                                        // Toggle the expansion state of the item
                                                                                        if (_isExpandedDetails == index) {
                                                                                          _isExpandedDetails = null; // Collapse if already expanded
                                                                                        } else {
                                                                                          _isExpandedDetails = index; // Expand this item
                                                                                        }
                                                                                      });


                                                                                    },
                                                                                    child: CustomeText(text: isExpand ? "${lableModel.showLessDetails}" : "${lableModel.showMoreDetails}", fontColor: MyColor.primaryColorblue, fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_7, fontWeight: FontWeight.w500, textAlign: TextAlign.start)),
                                                                                InkWell(
                                                                                  onTap: () async {

                                                                                    setState(() {
                                                                                      _selectedIndex = index; // Update the selected index
                                                                                    });


                                                                                  },
                                                                                  child: Container(
                                                                                    padding: EdgeInsets.symmetric(vertical: 5, horizontal: 8),
                                                                                    decoration: BoxDecoration(
                                                                                        color: MyColor.dropdownColor,
                                                                                        borderRadius: BorderRadius.circular(SizeConfig.blockSizeHorizontal * SizeUtils.WIDTH3)
                                                                                    ),
                                                                                    child: Icon(Icons.navigate_next_rounded, color: MyColor.primaryColorblue, size: SizeConfig.blockSizeVertical * SizeUtils.ICONSIZE_2_5,),
                                                                                  ),
                                                                                )
                                                                              ],)
                                                                          ],
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),)
                                                            )
                                                        );
                                                      },
                                                    ),
                                                  ],
                                                )
                                                    : Padding(
                                                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                                                  child: Center(
                                                    child: CustomeText(text: "${lableModel.recordNotFound}", fontColor:
                                                    MyColor.textColorGrey,
                                                        fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_2_0,
                                                        fontWeight: FontWeight.w500,
                                                        textAlign: TextAlign.center),),
                                                )
                                                    : Padding(
                                                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                                                  child: Center(
                                                    child: CustomeText(text: "${lableModel.recordNotFound}",
                                                        fontColor: MyColor.textColorGrey,
                                                        fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_2_0,
                                                        fontWeight: FontWeight.w500,
                                                        textAlign: TextAlign.center),),
                                                ),

                                              ),
                                            )),


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

  Future<void> scanGroupQR() async{
    String groupcodeScanResult =  await FlutterBarcodeScanner.scanBarcode(
      '#ff6666', // Color for the scanner overlay
      'Cancel', // Text for the cancel button
      true, // Enable flash option
      ScanMode.DEFAULT, // Scan mode
    );

    if(groupcodeScanResult == "-1"){

    }else{
      bool specialCharAllow = CommonUtils.containsSpecialCharacters(groupcodeScanResult);

      if(specialCharAllow == true){
        SnackbarUtil.showSnackbar(context, "${widget.lableModel!.onlyAlphaNumericValueMsg}", MyColor.colorRed, icon: FontAwesomeIcons.times);
        Vibration.vibrate(duration: 500);
        groupIdController.clear();
        WidgetsBinding.instance.addPostFrameCallback((_) {
          FocusScope.of(context).requestFocus(groupIdFocusNode);
        });
      }else{

        String result = groupcodeScanResult.replaceAll(" ", "");

        String truncatedResult = result.length > 15
            ? result.substring(0, 15)
            : result;

        groupIdController.text = truncatedResult;
        // Call searchLocation api to validate or not
        // call binning details api

        if (groupIdController.text.length != groupIDCharSize) {
          openValidationDialog(
              CommonUtils.formatMessage("${widget.lableModel!.groupIdCharSizeMsg}", ["$groupIDCharSize"]),
              groupIdFocusNode);

        }else{
          await context.read<BinningCubit>().getBinningDetailListApi(
              groupIdController.text,
              _user!.userProfile!.userIdentity!,
              _splashDefaultData!.companyCode!,
              widget.menuId);
        }


      }

    }


  }

}

class TickerProviders extends TickerProvider {
  @override
  Ticker createTicker(onTick) => Ticker(onTick);
}

