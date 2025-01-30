import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:galaxy/core/mycolor.dart';
import 'package:galaxy/module/export/model/buildup/getuldtrolleysearchmodel.dart';
import 'package:galaxy/module/export/pages/offload/offloadawbpage.dart';
import 'package:galaxy/module/export/services/move/movelogic/movecubit.dart';
import 'package:galaxy/module/export/services/move/movelogic/movestate.dart';
import 'package:galaxy/module/export/services/offload/offloadlogic/offloadcubit.dart';
import 'package:galaxy/module/export/services/offload/offloadlogic/offloadstate.dart';
import 'package:galaxy/utils/sizeutils.dart';
import 'package:galaxy/utils/snackbarutil.dart';
import 'package:galaxy/widget/uldnumberwidget.dart';
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
import '../../model/move/getmovesearch.dart';
import '../../model/offload/getoffloadsearchmodel.dart';
import '../../model/offload/offloadgetpageload.dart';
import 'offloaduldpage.dart';

class OffloadPage extends StatefulWidget {
  String mainMenuName;
  String title;
  String refrelCode;
  LableModel? lableModel;
  int menuId;
  List<SubMenuName> importSubMenuList = [];
  List<SubMenuName> exportSubMenuList = [];

  OffloadPage(
      {super.key,
      required this.importSubMenuList,
      required this.exportSubMenuList,
      required this.title,
      required this.refrelCode,
      this.lableModel,
      required this.menuId,
      required this.mainMenuName});

  @override
  State<OffloadPage> createState() => _OffloadPageState();
}

class _OffloadPageState extends State<OffloadPage> with SingleTickerProviderStateMixin{


  InactivityTimerManager? inactivityTimerManager;
  final SavedPrefrence savedPrefrence = SavedPrefrence();
  UserDataModel? _user;
  SplashDefaultModel? _splashDefaultData;
  final ScrollController scrollController = ScrollController();

  TextEditingController groupIdController = TextEditingController();


  TextEditingController locationController = TextEditingController();
  FocusNode locationFocusNode = FocusNode();
  FocusNode locationBtnFocusNode = FocusNode();

  bool _isLocationSearchBtnEnable = false;
  bool _isvalidateLocation = false;

  FocusNode groupIdFocusNode = FocusNode();
  FocusNode scanBtnFocusNode = FocusNode();
  FocusNode nextBtnFocusNode = FocusNode();
  FocusNode nextULDBtnFocusNode = FocusNode();



  int isGroupIdLength = 1;
  String isRequiredGroupForAWB = "Y";
  String isRequiredGroupForULD = "Y";
  String defaultLableTab = "BULK";
  List<OffloadReasonList> offloadReasonList = [];


  bool isBackPressed = false; // Track if the back button was pressed





  GetSearchOffloadModel? getSearchOffloadModel;
  List<OffloadAWBDetailsList>? offloadAWBDetailsList = [];
  List<OffloadULDDetailsList>? offloadULDDetailsList = [];


  late AnimationController _blinkController;
  late Animation<Color?> _colorAnimation;
  String selectedType = "A";




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
      if(_isvalidateLocation == false){
        //call location validation api
        await context.read<OffloadCubit>().getValidateLocation(
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



  Future<void> leaveGroupIdFocus() async {

    // Skip the focus leave logic if inactivity dialog is open
    if (isInactivityDialogOpen) return;



    print("CHECK_GROUP_ID==== ${groupIdController.text}");

    if (groupIdController.text.isNotEmpty) {
      getOffloadSearch();
    }else{

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

    getPageLoad();

   /* WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(groupIdFocusNode);
    });*/

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
                                  WidgetsBinding.instance.addPostFrameCallback((_) {
                                    FocusScope.of(context).requestFocus(locationFocusNode);
                                  },
                                  );

                                  locationController.clear();
                                  groupIdController.clear();
                                  offloadAWBDetailsList!.clear();
                                  offloadULDDetailsList!.clear();
                                  _isvalidateLocation = false;

                                  if(defaultLableTab == "BULK"){
                                    selectedType = "A";
                                  }else if(defaultLableTab == "ULD"){
                                    selectedType = "U";
                                  }else{
                                    selectedType = "G";
                                  }
                                  setState(() {

                                  });
                                  // Reset UI
                                  setState(() {});
                                },
                              ),
                            ),

                            // start api responcer
                            BlocListener<OffloadCubit, OffloadState>(
                              listener: (context, state) async {
                                if (state is OffloadInitialState) {
                                }
                                else if (state is OffloadLoadingState) {
                                  // showing loading dialog in this state
                                  DialogUtils.showLoadingDialog(context, message: lableModel.loading);
                                }
                                else if (state is GetOffloadPageLoadSuccessState){
                                  DialogUtils.hideLoadingDialog(context);
                                  if(state.offloadGetPageLoad.status == "E"){
                                    Vibration.vibrate(duration: 500);
                                    SnackbarUtil.showSnackbar(context, state.offloadGetPageLoad.statusMessage!, MyColor.colorRed, icon: FontAwesomeIcons.times);
                                  }else{
                                    isGroupIdLength = state.offloadGetPageLoad.isGroupBasedAcceptNumber!;
                                    isRequiredGroupForAWB = state.offloadGetPageLoad.isGroupBasedAcceptChar!;
                                    isRequiredGroupForULD = state.offloadGetPageLoad.uLDGroupIdIsMandatory!;
                                    defaultLableTab = state.offloadGetPageLoad.defaultScanForExportOffloadText!;
                                    offloadReasonList = state.offloadGetPageLoad.offloadReasonList!;

                                    WidgetsBinding.instance.addPostFrameCallback((_) {
                                      FocusScope.of(context).requestFocus(locationFocusNode);
                                    },
                                    );

                                    if(defaultLableTab == "BULK"){
                                      selectedType = "A";
                                    }else if(defaultLableTab == "ULD"){
                                      selectedType = "U";
                                    }else{
                                      selectedType = "G";
                                    }
                                    setState(() {

                                    });
                                  }
                                }
                                else if (state is GetOffloadPageLoadFailureState){
                                  DialogUtils.hideLoadingDialog(context);
                                  Vibration.vibrate(duration: 500);
                                  SnackbarUtil.showSnackbar(context, state.error, MyColor.colorRed, icon: FontAwesomeIcons.times);
                                }
                                else if (state is OffloadValidateLocationSuccessState){
                                  DialogUtils.hideLoadingDialog(context);
                                  if (state.locationValidationModel.status == "E") {
                                    setState(() {
                                      _isvalidateLocation = false;
                                    });
                                    Vibration.vibrate(duration: 500);
                                    SnackbarUtil.showSnackbar(
                                        context,
                                        state.locationValidationModel.statusMessage!,
                                        MyColor.colorRed,
                                        icon: FontAwesomeIcons.times);

                                    WidgetsBinding.instance.addPostFrameCallback((_) {
                                      FocusScope.of(context).requestFocus(locationFocusNode);
                                    },
                                    );
                                  }
                                  else if (state.locationValidationModel.status == "V") {
                                    setState(() {
                                      _isvalidateLocation = false;
                                    });
                                    Vibration.vibrate(duration: 500);
                                    SnackbarUtil.showSnackbar(
                                        context,
                                        state.locationValidationModel.statusMessage!,
                                        MyColor.colorRed,
                                        icon: FontAwesomeIcons.times);

                                    WidgetsBinding.instance.addPostFrameCallback((_) {
                                      FocusScope.of(context).requestFocus(locationFocusNode);
                                    },
                                    );
                                  }
                                  else {
                                    // DialogUtils.hideLoadingDialog(context);
                                    _isvalidateLocation = true;
                                    setState(() {});

                                    WidgetsBinding.instance.addPostFrameCallback((_) {
                                      FocusScope.of(context).requestFocus(groupIdFocusNode);
                                    },
                                    );

                                  }
                                }
                                else if (state is OffloadValidateLocationFailureState){
                                  DialogUtils.hideLoadingDialog(context);
                                  Vibration.vibrate(duration: 500);
                                  SnackbarUtil.showSnackbar(context, state.error, MyColor.colorRed, icon: FontAwesomeIcons.times);
                                }
                                else if (state is GetOffloadSearchSuccessState){
                                  DialogUtils.hideLoadingDialog(context);
                                  if(state.getSearchOffloadModel.status == "E"){
                                    offloadAWBDetailsList!.clear();
                                    offloadULDDetailsList!.clear();

                                    Vibration.vibrate(duration: 500);
                                    SnackbarUtil.showSnackbar(context, state.getSearchOffloadModel.statusMessage!, MyColor.colorRed, icon: FontAwesomeIcons.times);
                                    WidgetsBinding.instance.addPostFrameCallback((_) {
                                      FocusScope.of(context).requestFocus(groupIdFocusNode);
                                    },
                                    );
                                    setState(() {

                                    });

                                  }else if(state.getSearchOffloadModel.status == "V"){
                                    Vibration.vibrate(duration: 500);
                                    SnackbarUtil.showSnackbar(context, state.getSearchOffloadModel.statusMessage!, MyColor.colorRed, icon: FontAwesomeIcons.times);
                                    WidgetsBinding.instance.addPostFrameCallback((_) {
                                      FocusScope.of(context).requestFocus(groupIdFocusNode);
                                    },
                                    );
                                  }else{
                                    // data will be display
                                    getSearchOffloadModel = state.getSearchOffloadModel;
                                    offloadAWBDetailsList = state.getSearchOffloadModel.offloadAWBDetailsList;
                                    offloadULDDetailsList = state.getSearchOffloadModel.offloadULDDetailsList;
                                    setState(() {

                                    });
                                  }
                                }
                                else if (state is GetOffloadPageLoadFailureState){
                                  Vibration.vibrate(duration: 500);
                                  SnackbarUtil.showSnackbar(context, state.error, MyColor.colorRed, icon: FontAwesomeIcons.times);
                                  WidgetsBinding.instance.addPostFrameCallback((_) {
                                    FocusScope.of(context).requestFocus(groupIdFocusNode);
                                  },
                                  );
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
                                              SizedBox(
                                                  height: SizeConfig.blockSizeVertical),
                                              // text manifest and recived in pices text counter
                                              Directionality(
                                                textDirection: textDirection,
                                                child: Row(
                                                  children: [
                                                    // add location in text
                                                    Expanded(
                                                      flex: 1,
                                                      child: CustomeEditTextWithBorder(
                                                        lablekey: "LOCATION",
                                                        textDirection: textDirection,
                                                        controller: locationController,
                                                        focusNode: locationFocusNode,
                                                        hasIcon: false,
                                                        hastextcolor: true,
                                                        animatedLabel: true,
                                                        needOutlineBorder: true,
                                                        labelText:"Scan Door *",
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
                                                    ),
                                                    SizedBox(
                                                      width: SizeConfig.blockSizeHorizontal,
                                                    ),
                                                    // click search button to validate location
                                                    InkWell(
                                                      focusNode: locationBtnFocusNode,
                                                      onTap: () {
                                                        scanLocationQR();
                                                      },
                                                      child: Padding(padding: const EdgeInsets.all(8.0),
                                                        child: SvgPicture.asset(search, height: SizeConfig.blockSizeVertical * SizeUtils.ICONSIZE3,),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                              SizedBox(
                                                  height: SizeConfig.blockSizeVertical * SizeUtils.HEIGHT2
                                              ),
                                              Directionality(
                                                textDirection: textDirection,
                                                child: Row(
                                                  children: [
                                                    Expanded(
                                                      flex : 1,
                                                      child: CustomTextField(
                                                        textDirection: textDirection,
                                                        controller: groupIdController,
                                                        focusNode: groupIdFocusNode,
                                                        onPress: () {},
                                                        hasIcon: false,
                                                        hastextcolor: true,
                                                        animatedLabel: true,
                                                        needOutlineBorder: true,
                                                        labelText: (selectedType == "A") ? "Scan AWB No." : (selectedType == "U") ? "Scan ULD / ULD Group Id" : "Scan Group Id",
                                                        readOnly: false,
                                                        maxLength: (selectedType == "A") ? 11 : (selectedType == "U") ? 30 : 14,
                                                        onChanged: (value) {
                                                          offloadAWBDetailsList!.clear();
                                                          offloadULDDetailsList!.clear();
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
                                                      focusNode: scanBtnFocusNode,
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


                                            ],
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
                                              child: (selectedType == "U")
                                                  ? Padding(
                                                padding: const EdgeInsets.only(left: 12, right: 12, top: 12, bottom: 12),
                                                child: (offloadULDDetailsList!.isNotEmpty)
                                                    ? Column(
                                                  children: [

                                                    ListView.builder(
                                                      itemCount: (offloadULDDetailsList!.isNotEmpty) ?  offloadULDDetailsList!.length : 0,
                                                      physics: const NeverScrollableScrollPhysics(),
                                                      shrinkWrap: true,
                                                      controller: scrollController,
                                                      itemBuilder: (context, index) {
                                                        OffloadULDDetailsList offloadULDDetail = offloadULDDetailsList![index];

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
                                                                              ULDNumberWidget(uldNo: "${offloadULDDetail.uLDNo}", smallFontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5, bigFontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_8, fontColor: MyColor.textColorGrey3, uldType: "U"),
                                                                              const SizedBox(width: 5),
                                                                              CustomeText(
                                                                                text: "${offloadULDDetail.flightNo} / ${offloadULDDetail.flightDate!.replaceAll(" ", "-")}",
                                                                                fontColor: MyColor.textColorGrey3,
                                                                                fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_7,
                                                                                fontWeight: FontWeight.w600,
                                                                                textAlign: TextAlign.start,
                                                                              ),
                                                                            ],
                                                                          ),
                                                                          SizedBox(height: SizeConfig.blockSizeVertical,),
                                                                          IntrinsicHeight(
                                                                            child: Row(
                                                                              children: [
                                                                                Expanded(
                                                                                  flex: 6,
                                                                                  child: Column(
                                                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                                                    children: [
                                                                                      Row(
                                                                                        children: [
                                                                                          CustomeText(
                                                                                            text: "Destination :",
                                                                                            fontColor: MyColor.textColorGrey2,
                                                                                            fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_6,
                                                                                            fontWeight:  FontWeight.w500,
                                                                                            textAlign: TextAlign.start,
                                                                                          ),
                                                                                          const SizedBox(width: 5),
                                                                                          CustomeText(
                                                                                            text: "${offloadULDDetail.destination}",
                                                                                            fontColor: MyColor.textColorGrey3,
                                                                                            fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_7,
                                                                                            fontWeight:  FontWeight.w600,
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
                                                                                  child: RoundedButtonBlue(text: "Next",
                                                                                    focusNode: nextULDBtnFocusNode,
                                                                                    press: () async {
                                                                                      FocusScope.of(context).requestFocus(nextULDBtnFocusNode);

                                                                                      inactivityTimerManager?.resetTimer();
                                                                                      String value = await Navigator.push(context, CupertinoPageRoute(
                                                                                          builder: (context) => OffloadULDPage(
                                                                                            importSubMenuList: widget.importSubMenuList,
                                                                                            exportSubMenuList: widget.exportSubMenuList,
                                                                                            mainMenuName: widget.mainMenuName,
                                                                                            menuId: widget.menuId,
                                                                                            lableModel: lableModel,
                                                                                            title: "Offload ULD",
                                                                                            refrelCode: widget.refrelCode,
                                                                                            isGroupBasedAcceptChar: isRequiredGroupForULD,
                                                                                            isGroupBasedAcceptNumber: isGroupIdLength,
                                                                                            offloadReasonList: offloadReasonList,
                                                                                            offloadULDDetail: offloadULDDetail,
                                                                                            locationCode: locationController.text,
                                                                                          )));

                                                                                      if(value == "true"){
                                                                                        getOffloadSearch();
                                                                                      }else{
                                                                                        inactivityTimerManager?.resetTimer();
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
                                                      },
                                                    ),
                                                  ],
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

                                              )
                                                  : Padding(
                                                padding: const EdgeInsets.only(left: 12, right: 12, top: 12, bottom: 12),
                                                child: (offloadAWBDetailsList!.isNotEmpty)
                                                    ? Column(
                                                  children: [

                                                    ListView.builder(
                                                      itemCount: (offloadAWBDetailsList!.isNotEmpty) ?  offloadAWBDetailsList!.length : 0,
                                                      physics: NeverScrollableScrollPhysics(),
                                                      shrinkWrap: true,
                                                      controller: scrollController,
                                                      itemBuilder: (context, index) {
                                                        OffloadAWBDetailsList offloadAwbDetail = offloadAWBDetailsList![index];
                                                        List<String> shcCodes = offloadAwbDetail.sHCCode!.split(',');

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
                                                                              CustomeText(
                                                                                text: AwbFormateNumberUtils.formatAWBNumber("${offloadAwbDetail.aWBNo}"),
                                                                                fontColor: MyColor.textColorGrey3,
                                                                                fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_7,
                                                                                fontWeight: FontWeight.w600,
                                                                                textAlign: TextAlign.start,
                                                                              ),
                                                                              const SizedBox(width: 5),
                                                                              CustomeText(
                                                                                text: "${offloadAwbDetail.flightNo} / ${offloadAwbDetail.flightDate!.replaceAll(" ", "-")}",
                                                                                fontColor: MyColor.textColorGrey3,
                                                                                fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_7,
                                                                                fontWeight: FontWeight.w600,
                                                                                textAlign: TextAlign.start,
                                                                              ),
                                                                            ],
                                                                          ),
                                                                          offloadAwbDetail.sHCCode!.isNotEmpty ? SizedBox(height: SizeConfig.blockSizeVertical * 0.8,) : SizedBox(),
                                                                          Row(
                                                                            children: [
                                                                              offloadAwbDetail.sHCCode!.isNotEmpty
                                                                                  ? Row(
                                                                                children: shcCodes.asMap().entries.take(3).map((entry) {
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
                                                                          offloadAwbDetail.sHCCode!.isNotEmpty ? SizedBox(height: SizeConfig.blockSizeVertical) : SizedBox(height: SizeConfig.blockSizeVertical * 0.8,),
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
                                                                                      text: "${offloadAwbDetail.nOP}",
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
                                                                                      text: "${CommonUtils.formateToTwoDecimalPlacesValue(offloadAwbDetail.weightKg!)} Kg",
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
                                                                                  flex: 6,
                                                                                  child: Column(
                                                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                                                    children: [
                                                                                      Row(
                                                                                        children: [
                                                                                          CustomeText(
                                                                                            text: (offloadAwbDetail.uLDTrolleyType == "U") ? "ULD :" : "Trolley :",
                                                                                            fontColor: MyColor.textColorGrey2,
                                                                                            fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                                                                            fontWeight:  FontWeight.w500,
                                                                                            textAlign: TextAlign.start,
                                                                                          ),
                                                                                          const SizedBox(width: 5),
                                                                                          CustomeText(
                                                                                            text: "${offloadAwbDetail.uLDTrolleyNo}",
                                                                                            fontColor: MyColor.textColorGrey3,
                                                                                            fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_6,
                                                                                            fontWeight:  FontWeight.w600,
                                                                                            textAlign: TextAlign.start,
                                                                                          ),
                                                                                        ],
                                                                                      ),
                                                                                      /*SizedBox(height: SizeConfig.blockSizeVertical,),
                                                                                      Row(
                                                                                        children: [
                                                                                          CustomeText(
                                                                                            text: "${lableModel.group} :",
                                                                                            fontColor: Colors.pink.shade500,
                                                                                            fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_7,
                                                                                            fontWeight: FontWeight.bold,
                                                                                            textAlign: TextAlign.start,
                                                                                          ),
                                                                                          const SizedBox(width: 5),
                                                                                          CustomeText(
                                                                                            text: (offloadAwbDetail.groupId!.isNotEmpty) ? "${offloadAwbDetail.groupId}" : "-",
                                                                                            fontColor: Colors.pink.shade500,
                                                                                            fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_7,
                                                                                            fontWeight: FontWeight.bold,
                                                                                            textAlign: TextAlign.start,
                                                                                          ),
                                                                                        ],
                                                                                      ),*/

                                                                                    ],
                                                                                  ),
                                                                                ),
                                                                                SizedBox(width: SizeConfig.blockSizeHorizontal * SizeUtils.WIDTH3,),
                                                                                Expanded(
                                                                                  flex: 3,
                                                                                  child: RoundedButtonBlue(text: "Next",
                                                                                    focusNode: nextBtnFocusNode,
                                                                                    press: () async {
                                                                                      FocusScope.of(context).requestFocus(nextBtnFocusNode);
                                                                                      inactivityTimerManager?.resetTimer();

                                                                                      String value = await Navigator.push(context, CupertinoPageRoute(
                                                                                          builder: (context) => OffloadAWBPage(
                                                                                            importSubMenuList: widget.importSubMenuList,
                                                                                            exportSubMenuList: widget.exportSubMenuList,
                                                                                            mainMenuName: widget.mainMenuName,
                                                                                            menuId: widget.menuId,
                                                                                            lableModel: lableModel,
                                                                                            title: "Offload AWB",
                                                                                            refrelCode: widget.refrelCode,
                                                                                            isGroupBasedAcceptChar: isRequiredGroupForAWB,
                                                                                            isGroupBasedAcceptNumber: isGroupIdLength,
                                                                                            offloadReasonList: offloadReasonList,
                                                                                            offloadAwbDetail: offloadAwbDetail,
                                                                                          )));

                                                                                      if(value == "true"){
                                                                                        getOffloadSearch();
                                                                                      }else{
                                                                                        inactivityTimerManager?.resetTimer();
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
                                                      },
                                                    ),
                                                  ],
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

                                              )
                                            )),
                                        SizedBox(height: SizeConfig.blockSizeVertical),


                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Directionality(
                                textDirection: uiDirection,
                                child: IntrinsicHeight(
                                  child: Row(
                                    children: [
                                      // Yes Option
                                      Expanded(
                                        flex: 1,
                                        child: InkWell(
                                          onTap: () {

                                            /*if(locationController.text.isNotEmpty){
                                              setState(() {
                                                selectedType = "G";
                                              });
                                              offloadAWBDetailsList!.clear();
                                              offloadULDDetailsList!.clear();
                                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                                FocusScope.of(context).requestFocus(groupIdFocusNode);
                                              });
                                              groupIdController.clear();
                                            }else{
                                              Vibration.vibrate(duration: 500);
                                              SnackbarUtil.showSnackbar(context, lableModel.enterLocationMsg!, MyColor.colorRed, icon: FontAwesomeIcons.times);
                                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                                FocusScope.of(context).requestFocus(locationFocusNode);
                                              });
                                            }*/




                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: selectedType == "G" ? MyColor.primaryColorblue : MyColor.colorWhite, // Selected blue, unselected white
                                              borderRadius: const BorderRadius.only(
                                                topLeft: Radius.circular(10),
                                                bottomLeft: Radius.circular(10),
                                              ),
                                              border: const Border.symmetric(horizontal: BorderSide(color: MyColor.primaryColorblue), vertical: BorderSide(color: MyColor.primaryColorblue)), // Border color
                                            ),
                                            padding: const EdgeInsets.symmetric(vertical:16, horizontal: 10),
                                            child: Center(
                                                child: CustomeText(text: "PIECE", fontColor: selectedType == "G" ? MyColor.colorWhite : MyColor.textColorGrey3, fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5, fontWeight: FontWeight.w600, textAlign: TextAlign.center)
                                            ),
                                          ),
                                        ),
                                      ),
                                      // No Option
                                      Expanded(
                                        flex: 1,
                                        child: InkWell(
                                          onTap: () {

                                            if(locationController.text.isNotEmpty){
                                              setState(() {
                                                selectedType = "A";
                                              });
                                              offloadAWBDetailsList!.clear();
                                              offloadULDDetailsList!.clear();
                                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                                FocusScope.of(context).requestFocus(groupIdFocusNode);
                                              });
                                              groupIdController.clear();
                                            }else{
                                              Vibration.vibrate(duration: 500);
                                              SnackbarUtil.showSnackbar(context, lableModel.enterLocationMsg!, MyColor.colorRed, icon: FontAwesomeIcons.times);
                                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                                FocusScope.of(context).requestFocus(locationFocusNode);
                                              });
                                            }



                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: selectedType == "A" ? MyColor.primaryColorblue : MyColor.colorWhite, // Selected blue, unselected white
                                              border: const Border.symmetric(horizontal: BorderSide(color: MyColor.primaryColorblue)), // Border color
                                            ),
                                            padding: const EdgeInsets.symmetric(vertical:16, horizontal: 10),
                                            child: Center(
                                                child: CustomeText(text: "BULK", fontColor: selectedType == "A" ? MyColor.colorWhite : MyColor.textColorGrey3, fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5, fontWeight: FontWeight.w600, textAlign: TextAlign.center)
                                            ),
                                          ),
                                        ),
                                      ),

                                      Expanded(
                                        flex: 1,
                                        child: InkWell(
                                          onTap: () {

                                            if(locationController.text.isNotEmpty){
                                              setState(() {
                                                selectedType = "U";
                                              });
                                              offloadAWBDetailsList!.clear();
                                              offloadULDDetailsList!.clear();
                                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                                FocusScope.of(context).requestFocus(groupIdFocusNode);
                                              });
                                              groupIdController.clear();
                                            }else{
                                              Vibration.vibrate(duration: 500);
                                              SnackbarUtil.showSnackbar(context, lableModel.enterLocationMsg!, MyColor.colorRed, icon: FontAwesomeIcons.times);
                                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                                FocusScope.of(context).requestFocus(locationFocusNode);
                                              });
                                            }

                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: selectedType == "U" ? MyColor.primaryColorblue : MyColor.colorWhite, // Selected blue, unselected white
                                              borderRadius: const BorderRadius.only(
                                                topRight: Radius.circular(10),
                                                bottomRight: Radius.circular(10),
                                              ),
                                              border: const Border.symmetric(horizontal: BorderSide(color: MyColor.primaryColorblue), vertical: BorderSide(color: MyColor.primaryColorblue)), // Border color
                                            ),
                                            padding: const EdgeInsets.symmetric(vertical:16, horizontal: 10),
                                            child: Center(
                                                child: CustomeText(text: "ULD", fontColor: selectedType == "U" ? MyColor.colorWhite : MyColor.textColorGrey3, fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5, fontWeight: FontWeight.w600, textAlign: TextAlign.center)
                                            ),
                                          ),
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
        String truncatedResult = "";
        if(selectedType == "G"){
          truncatedResult = result.length > 11
              ? result.substring(0, 11)
              : result;
        }else if(selectedType == "U"){
          truncatedResult = result.length > 30
              ? result.substring(0, 30)
              : result;
        }else{
          truncatedResult = result.length > 14
              ? result.substring(0, 14)
              : result;
        }

        offloadAWBDetailsList!.clear();
        offloadULDDetailsList!.clear();


        groupIdController.text = truncatedResult;

        getOffloadSearch();



      }

    }


  }

  Future<void> getPageLoad() async {
    await context.read<OffloadCubit>().getPageLoad(
        _user!.userProfile!.userIdentity!,
        _splashDefaultData!.companyCode!,
        widget.menuId);
  }



  Future<void> getOffloadSearch() async {

    await context.read<OffloadCubit>().getSearchOffload(
        groupIdController.text,
        selectedType,
        _user!.userProfile!.userIdentity!,
        _splashDefaultData!.companyCode!,
        widget.menuId);
  }



  Future<void> scanLocationQR() async{
    String locationcodeScanResult =  await FlutterBarcodeScanner.scanBarcode(
      '#ff6666', // Color for the scanner overlay
      'Cancel', // Text for the cancel button
      true, // Enable flash option
      ScanMode.DEFAULT, // Scan mode
    );

    if(locationcodeScanResult == "-1"){

    }
    else{
      bool specialCharAllow = CommonUtils.containsSpecialCharacters(locationcodeScanResult);

      if(specialCharAllow == true){
        SnackbarUtil.showSnackbar(context, widget.lableModel!.onlyAlphaNumericValueMsg!, MyColor.colorRed, icon: FontAwesomeIcons.times);
        Vibration.vibrate(duration: 500);
        locationController.clear();
        _isvalidateLocation = false;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          FocusScope.of(context).requestFocus(locationFocusNode);
        });
      }else{

        String result = locationcodeScanResult.replaceAll(" ", "");

        String truncatedResult = result.length > 15
            ? result.substring(0, 15)
            : result;

        locationController.text = truncatedResult;
        // Call searchLocation api to validate or not
        await context.read<OffloadCubit>().getValidateLocation(
            locationController.text,
            _user!.userProfile!.userIdentity!,
            _splashDefaultData!.companyCode!,
            widget.menuId,
            "a");
      }

    }
  }




}

class TickerProviders extends TickerProvider {
  @override
  Ticker createTicker(onTick) => Ticker(onTick);
}

