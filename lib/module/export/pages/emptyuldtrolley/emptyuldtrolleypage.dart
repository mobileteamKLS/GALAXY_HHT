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
import '../../../../widget/customebuttons/roundbuttonblue.dart';
import '../../../../widget/customedrawer/customedrawer.dart';
import '../../../../widget/customeedittext/customeedittextwithborder.dart';
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

class EmptyULDTrolleyPage extends StatefulWidget {
  String mainMenuName;
  String title;
  String refrelCode;
  LableModel? lableModel;
  int menuId;
  List<SubMenuName> importSubMenuList = [];
  List<SubMenuName> exportSubMenuList = [];

  EmptyULDTrolleyPage(
      {super.key,
      required this.importSubMenuList,
      required this.exportSubMenuList,
      required this.title,
      required this.refrelCode,
      this.lableModel,
      required this.menuId,
      required this.mainMenuName});

  @override
  State<EmptyULDTrolleyPage> createState() => _EmptyULDTrolleyPageState();
}

class _EmptyULDTrolleyPageState extends State<EmptyULDTrolleyPage> with SingleTickerProviderStateMixin{


  String selectedSourceType = "U";

  String groupIdRequired = "";
  int groupIdCharSize = 1;

  TextEditingController locationController = TextEditingController();
  FocusNode locationFocusNode = FocusNode();
  FocusNode locationBtnFocusNode = FocusNode();


  TextEditingController scanULDController = TextEditingController();
  FocusNode scanULDFocusNode = FocusNode();
  FocusNode scanULDBtnFocusNode = FocusNode();

  TextEditingController scanTrolleyController = TextEditingController();
  FocusNode scanTrolleyFocusNode = FocusNode();
  FocusNode scanTrolleyBtnFocusNode = FocusNode();

  TextEditingController trollyTypeController = TextEditingController();
  TextEditingController trollyNumberController = TextEditingController();
  FocusNode trollyTypeFocusNode = FocusNode();
  FocusNode trollyNumberFocusNode = FocusNode();

  TextEditingController currentULDOwnerController = TextEditingController();
  FocusNode currentULDOwnerFocusNode = FocusNode();

  TextEditingController groupIdController = TextEditingController();
  FocusNode groupIdFocusNode = FocusNode();
  FocusNode createBtnFocusNode = FocusNode();


  bool _isLocationSearchBtnEnable = false;
  bool _isvalidateLocation = false;

  InactivityTimerManager? inactivityTimerManager;
  final SavedPrefrence savedPrefrence = SavedPrefrence();
  UserDataModel? _user;
  SplashDefaultModel? _splashDefaultData;
  final ScrollController scrollController = ScrollController();

  final List<String> _tabs = ['ULD', 'Trolley'];
  int _pageIndex = 0;



  bool isBackPressed = false; // Track if the back button was pressed




  late AnimationController _blinkController;
  late Animation<Color?> _colorAnimation;

  bool isInactivityDialogOpen = false; // Flag to track inactivity dialog state

  late TabController _tabController;

  @override
  void initState() {
    super.initState();

    _loadUser(); //load user data

    _blinkController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: TickerProviders(), // Manually providing Ticker
    )..repeat(reverse: true); // Loop the animation

    _colorAnimation = ColorTween(
      begin: MyColor.shcColorList[0],
      end: Colors.transparent,
    ).animate(_blinkController);

    _tabController = TabController(length: 2, vsync: this);
    _tabController.animateTo(_pageIndex);

    locationFocusNode.addListener(() {
      if (!locationFocusNode.hasFocus && !isBackPressed) {
        leaveLocationFocus();
      }
    });

    locationController.addListener(_validateLocationSearchBtn);



    scanULDFocusNode.addListener(() {
      if (!scanULDFocusNode.hasFocus && !isBackPressed) {
        leaveULDFocusNode();
      }
    });

    scanTrolleyFocusNode.addListener(() {
      if (!scanTrolleyFocusNode.hasFocus && !isBackPressed) {
        leaveTrolleyFocusNode();
      }
    });


  }

  Future<void> leaveLocationFocus() async {
    if (locationController.text.isNotEmpty) {
      if(_isvalidateLocation == false){
        //call location validation api
        await context.read<EmptyULDTrolleyCubit>().getValidateLocation(
            locationController.text,
            _user!.userProfile!.userIdentity!,
            _splashDefaultData!.companyCode!,
            widget.menuId,
            "a");
      }else{

      }

    }else{
      //focus on location feild
      WidgetsBinding.instance.addPostFrameCallback((_) {
        FocusScope.of(context).requestFocus(locationBtnFocusNode);
      },
      );
    }
  }

  Future<void> leaveULDFocusNode() async {
    if (scanULDController.text.isNotEmpty) {

      String uldNumber = UldValidationUtil.validateUldNumberwithSpace1(scanULDController.text.toUpperCase());
      if(uldNumber == "Valid"){

        callSearchApi(selectedSourceType, scanULDController.text);
      }
      else{
        SnackbarUtil.showSnackbar(context, "${widget.lableModel!.entervalidULDNo}", MyColor.colorRed, icon: FontAwesomeIcons.times);
        Vibration.vibrate(duration: 500);
        currentULDOwnerController.clear();
        WidgetsBinding.instance.addPostFrameCallback((_) {
          FocusScope.of(context).requestFocus(scanULDFocusNode);
        });
      }


    }
  }

  Future<void> leaveTrolleyFocusNode() async {
    if (scanTrolleyController.text.isNotEmpty) {
      callSearchApi(selectedSourceType, scanTrolleyController.text);
    }
  }




  void _validateLocationSearchBtn() {
    setState(() {
      _isLocationSearchBtnEnable = locationController.text.isNotEmpty;
    });
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
    scanULDFocusNode.dispose();
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

    await context.read<EmptyULDTrolleyCubit>().emptyULDTrolleyPageLoad(
            _user!.userProfile!.userIdentity!,
            _splashDefaultData!.companyCode!,
            widget.menuId);

    inactivityTimerManager = InactivityTimerManager(
      context: context,
      timeoutMinutes: _splashDefaultData!.activeLoginTime!,
      // Set the desired inactivity time here
      onTimeout: _handleInactivityTimeout, // Define what happens when timeout occurs
    );
    inactivityTimerManager?.startTimer();
  }

  Future<void> _handleInactivityTimeout() async {
    scanULDFocusNode.unfocus();
    isInactivityDialogOpen = true; // Set flag before showing dialog

    bool? activateORNot = await DialogUtils.showingActivateTimerDialog(
        context, _user!.userProfile!.userId!, _splashDefaultData!.companyCode!);

    isInactivityDialogOpen = false; // Reset flag after dialog closes

    if (activateORNot == true) {
      inactivityTimerManager!.resetTimer();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        FocusScope.of(context).requestFocus(scanULDFocusNode);
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


    if(_pageIndex == 1){
      setState(() {
        _pageIndex = 0;
        _tabController.animateTo(0);
      });
    }else{
      isBackPressed = true; // Set to true to avoid showing snackbar on back press
      FocusScope.of(context).unfocus();
      Navigator.pop(context);
      inactivityTimerManager?.stopTimer();
    }


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
                      scanULDFocusNode.unfocus();
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
                                  //unloadUldListModel = null;
                                  scanULDController.clear();
                                  selectedSourceType = "U";
                                  locationController.clear();
                                  _isvalidateLocation = false;
                                  currentULDOwnerController.clear();

                                  trollyTypeController.clear();
                                  trollyNumberController.clear();
                                  scanTrolleyController.clear();

                                  groupIdController.clear();
                                  WidgetsBinding.instance.addPostFrameCallback((_) {
                                    FocusScope.of(context).requestFocus(locationFocusNode);
                                  },
                                  );
                                  setState(() {

                                  });
                                },
                              ),
                            ),

                            // start api responcer
                            BlocListener<EmptyULDTrolleyCubit, EmptyULDTrolleyState>(
                              listener: (context, state) async {
                                if (state is EmptyULDTrolleyInitialState) {
                                }
                                else if (state is EmptyULDTrolleyLoadingState) {
                                  // showing loading dialog in this state
                                  DialogUtils.showLoadingDialog(context, message: lableModel.loading);
                                }
                                else if (state is EmptyULDTrolleyPageLoadSuccessState) {
                                  DialogUtils.hideLoadingDialog(context);
                                  if (state.emptyULDtrolPageLoadModel.status == "E") {
                                    Vibration.vibrate(duration: 500);
                                    SnackbarUtil.showSnackbar(
                                        context,
                                        state.emptyULDtrolPageLoadModel.statusMessage!,
                                        MyColor.colorRed,
                                        icon: FontAwesomeIcons.times);

                                    WidgetsBinding.instance.addPostFrameCallback((_) {
                                      FocusScope.of(context).requestFocus(locationFocusNode);
                                    },
                                    );

                                  } else {

                                    groupIdRequired = state.emptyULDtrolPageLoadModel.isGroupBasedAcceptChar!;
                                    groupIdCharSize = state.emptyULDtrolPageLoadModel.isGroupBasedAcceptNumber!;

                                    WidgetsBinding.instance.addPostFrameCallback((_) {
                                      FocusScope.of(context).requestFocus(locationFocusNode);
                                    },
                                    );
                                    setState(() {});

                                  }
                                }
                                else if (state is ValidateLocationSuccessState) {
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

                                    if(selectedSourceType == "U"){

                                      WidgetsBinding.instance.addPostFrameCallback((_) {
                                        FocusScope.of(context).requestFocus(scanULDFocusNode);
                                      },
                                      );
                                    }else{
                                      WidgetsBinding.instance.addPostFrameCallback((_) {
                                        FocusScope.of(context).requestFocus(scanTrolleyFocusNode);
                                      },
                                      );
                                    }

                                  }
                                }
                                else if (state is ValidateLocationFailureState) {
                                  // validate location failure
                                  DialogUtils.hideLoadingDialog(context);
                                  _isvalidateLocation = false;
                                  Vibration.vibrate(duration: 500);
                                  SnackbarUtil.showSnackbar(
                                      context, state.error, MyColor.colorRed, icon: FontAwesomeIcons.times);
                                }
                                else if (state is SearchULDTrolleySuccessState){
                                  DialogUtils.hideLoadingDialog(context);
                                  if(state.searchULDTrolleyModel.status == "E"){
                                    Vibration.vibrate(duration: 500);
                                    SnackbarUtil.showSnackbar(
                                        context,
                                        state.searchULDTrolleyModel.statusMessage!,
                                        MyColor.colorRed,
                                        icon: FontAwesomeIcons.times);

                                    if(selectedSourceType == "U"){
                                      WidgetsBinding.instance.addPostFrameCallback((_) {
                                        FocusScope.of(context).requestFocus(scanULDFocusNode);
                                      },
                                      );
                                      scanULDController.clear();
                                      currentULDOwnerController.clear();
                                    }else{
                                      WidgetsBinding.instance.addPostFrameCallback((_) {
                                        FocusScope.of(context).requestFocus(scanTrolleyFocusNode);
                                      },
                                      );
                                      scanTrolleyController.clear();
                                    }


                                  }
                                  else{
                                    if(selectedSourceType == "U"){
                                      String uldNumbes = CommonUtils.ULDNUMBERCEHCK;
                                      List<String> parts = uldNumbes.split(' ');
                                      currentULDOwnerController.text = parts[2];

                                      WidgetsBinding.instance.addPostFrameCallback((_) {
                                        FocusScope.of(context).requestFocus(currentULDOwnerFocusNode);
                                      },
                                      );


                                    }else{
                                      WidgetsBinding.instance.addPostFrameCallback((_) {
                                        FocusScope.of(context).requestFocus(trollyTypeFocusNode);
                                      },
                                      );
                                    }

                                  }
                                }
                                else if (state is SearchULDTrolleyFailureState){
                                  DialogUtils.hideLoadingDialog(context);
                                  Vibration.vibrate(duration: 500);
                                  SnackbarUtil.showSnackbar(
                                      context,
                                      state.error,
                                      MyColor.colorRed,
                                      icon: FontAwesomeIcons.times);

                                  WidgetsBinding.instance.addPostFrameCallback((_) {
                                    FocusScope.of(context).requestFocus(scanULDFocusNode);
                                  },
                                  );
                                }
                                else if (state is CreateULDTrolleySuccessState){
                                  DialogUtils.hideLoadingDialog(context);
                                  if(state.createULDTrolleyModel.status == "E"){
                                    Vibration.vibrate(duration: 500);
                                    SnackbarUtil.showSnackbar(
                                        context,
                                        state.createULDTrolleyModel.statusMessage!,
                                        MyColor.colorRed,
                                        icon: FontAwesomeIcons.times);
                                    WidgetsBinding.instance.addPostFrameCallback((_) {
                                      FocusScope.of(context).requestFocus(groupIdFocusNode);
                                    },
                                    );

                                  }else{

                                    SnackbarUtil.showSnackbar(
                                        context,
                                        state.createULDTrolleyModel.statusMessage!,
                                        MyColor.colorGreen,
                                        icon: Icons.done);

                                    if(selectedSourceType == "U"){
                                      scanULDController.clear();
                                      currentULDOwnerController.clear();
                                      groupIdController.clear();
                                      WidgetsBinding.instance.addPostFrameCallback((_) {
                                        FocusScope.of(context).requestFocus(scanULDFocusNode);
                                      },
                                      );
                                    }else{
                                      scanTrolleyController.clear();
                                      trollyTypeController.clear();
                                      trollyNumberController.clear();
                                      groupIdController.clear();
                                      WidgetsBinding.instance.addPostFrameCallback((_) {
                                        FocusScope.of(context).requestFocus(scanTrolleyFocusNode);
                                      },
                                      );
                                    }
                                  }
                                }
                                else if (state is CreateULDTrolleyFailureState){
                                  DialogUtils.hideLoadingDialog(context);
                                  Vibration.vibrate(duration: 500);
                                  SnackbarUtil.showSnackbar(
                                      context,
                                      state.error,
                                      MyColor.colorRed,
                                      icon: FontAwesomeIcons.times);
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
                                              SizedBox(height: SizeConfig.blockSizeVertical * 0.8,),
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
                                                        labelText: "${lableModel.scanLocation} *",
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
                                              SizedBox(height: SizeConfig.blockSizeVertical),
                                              Column(
                                                children: [
                                                  Row(children: List.generate(_tabs.length, (index) {
                                                    return InkWell(
                                                      onTap: () {
                                                        if (index == 0) {
                                                          setState(() {
                                                            selectedSourceType = "U";
                                                            _pageIndex = index;
                                                            trollyTypeController.clear();
                                                            trollyNumberController.clear();
                                                            scanTrolleyController.clear();
                                                            groupIdController.clear();
                                                            WidgetsBinding.instance.addPostFrameCallback((_) {
                                                              if(_isvalidateLocation == true){
                                                                FocusScope.of(context).requestFocus(scanULDFocusNode);
                                                              }else{
                                                                FocusScope.of(context).requestFocus(locationFocusNode);
                                                              }

                                                            },
                                                            );
                                                          });
                                                        }
                                                        else if (index == 1) {
                                                          setState(() {
                                                            selectedSourceType = "T";
                                                            _pageIndex = index;
                                                            scanULDController.clear();
                                                            currentULDOwnerController.clear();
                                                            groupIdController.clear();
                                                            WidgetsBinding.instance.addPostFrameCallback((_) {

                                                              if(_isvalidateLocation == true){
                                                                FocusScope.of(context).requestFocus(scanTrolleyFocusNode);
                                                              }else{
                                                                FocusScope.of(context).requestFocus(locationFocusNode);
                                                              }
                                                              },
                                                            );
                                                          });
                                                        }
                                                      },
                                                      child: Container(
                                                        padding: const EdgeInsets.only(bottom: 8),
                                                        margin: const EdgeInsets.only(right: 20),
                                                        decoration: BoxDecoration(
                                                          border: Border(

                                                            bottom: BorderSide(
                                                              color: _pageIndex == index
                                                                  ? MyColor.bottomBorderColor
                                                                  : Colors.transparent,
                                                              width: 3.0,
                                                            ),
                                                          ),
                                                        ),
                                                        child: Text(
                                                            _tabs[index],
                                                            style: GoogleFonts.roboto(textStyle: TextStyle(
                                                              fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_8,
                                                              fontWeight: _pageIndex == index
                                                                  ? FontWeight.w600
                                                                  : FontWeight.w600,
                                                              color: _pageIndex == index
                                                                  ? MyColor.colorBlack
                                                                  :  MyColor.textColorGrey,
                                                            ),)
                                                        ),
                                                      ),
                                                    );
                                                  }),),
                                                  SizedBox(height: SizeConfig.blockSizeVertical,),
                                                  isViewEnable(lableModel, _pageIndex, textDirection, localizations),
                                                ],
                                              ),



                                              Directionality(
                                                textDirection: textDirection,
                                                child: CustomTextField(
                                                  textDirection: textDirection,
                                                  controller: groupIdController,
                                                  focusNode: groupIdFocusNode,
                                                  nextFocus: createBtnFocusNode,
                                                  onPress: () {},
                                                  hasIcon: false,
                                                  hastextcolor: true,
                                                  animatedLabel: true,
                                                  needOutlineBorder: true,
                                                  labelText: groupIdRequired == "Y" ? "${lableModel.groupId} *" : "${lableModel.groupId}",
                                                  readOnly: false,
                                                  maxLength: (groupIdCharSize == 0) ? 1 : groupIdCharSize,
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
                                              Padding(
                                                padding: const EdgeInsets.only(top: 12, right: 0, left: 0, bottom: 0),
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
                                                    const SizedBox(width: 10),
                                                    Expanded(
                                                      flex: 1,
                                                      child: RoundedButtonBlue(
                                                        focusNode: createBtnFocusNode,
                                                        text: "${lableModel.create}",
                                                        press: () {

                                                          if(locationController.text.isNotEmpty){
                                                            if(_isvalidateLocation == true){
                                                              if(selectedSourceType == "U"){
                                                                if(scanULDController.text.isNotEmpty){
                                                                  String uldNumber = UldValidationUtil.validateUldNumberwithSpace1(scanULDController.text.toUpperCase());
                                                                  if(uldNumber == "Valid"){
                                                                    if(currentULDOwnerController.text.isNotEmpty){
                                                                      if(groupIdRequired == "Y"){
                                                                        if (groupIdController.text.isNotEmpty) {
                                                                          if (groupIdController.text.length == groupIdCharSize) {
                                                                            createULDTrolley(scanULDController.text);
                                                                          }else{
                                                                            openValidationDialog(CommonUtils.formatMessage("${lableModel.groupIdCharSizeMsg}", ["$groupIdCharSize"]), groupIdFocusNode);
                                                                          }
                                                                        }else{
                                                                          openValidationDialog("${lableModel.enterGropIdMsg}", groupIdFocusNode);
                                                                        }
                                                                      }
                                                                      else{
                                                                        String uldNumber = UldValidationUtil.validateUldNumberwithSpace1(scanULDController.text.toUpperCase());
                                                                        if(uldNumber == "Valid"){
                                                                          createULDTrolley(scanULDController.text);
                                                                        }
                                                                        else{
                                                                          scanULDController.clear();
                                                                          SnackbarUtil.showSnackbar(context, "${widget.lableModel!.entervalidULDNo}", MyColor.colorRed, icon: FontAwesomeIcons.times);
                                                                          Vibration.vibrate(duration: 500);
                                                                          currentULDOwnerController.clear();
                                                                          WidgetsBinding.instance.addPostFrameCallback((_) {
                                                                            FocusScope.of(context).requestFocus(scanULDFocusNode);
                                                                          });
                                                                        }
                                                                      }
                                                                    }
                                                                    else{
                                                                      openValidationDialog("${lableModel.currentuldownermsg}", currentULDOwnerFocusNode);
                                                                    }
                                                                  }
                                                                  else{
                                                                    SnackbarUtil.showSnackbar(context, "${widget.lableModel!.entervalidULDNo}", MyColor.colorRed, icon: FontAwesomeIcons.times);
                                                                    Vibration.vibrate(duration: 500);
                                                                    currentULDOwnerController.clear();
                                                                    WidgetsBinding.instance.addPostFrameCallback((_) {
                                                                      FocusScope.of(context).requestFocus(scanULDFocusNode);
                                                                    });
                                                                  }



                                                                }
                                                                else{
                                                                  openValidationDialog("${lableModel.scanuldmsg}", scanULDFocusNode);
                                                                }
                                                              }
                                                              else{
                                                                if(scanTrolleyController.text.isNotEmpty){
                                                                  if(trollyTypeController.text.isNotEmpty){
                                                                    if(trollyNumberController.text.isNotEmpty){
                                                                      if(groupIdRequired == "Y"){
                                                                        if (groupIdController.text.isNotEmpty) {
                                                                          if (groupIdController.text.length == groupIdCharSize) {
                                                                            createULDTrolley("${trollyTypeController.text}~${trollyNumberController.text}");
                                                                          }else{
                                                                            openValidationDialog(CommonUtils.formatMessage("${lableModel.groupIdCharSizeMsg}", ["$groupIdCharSize"]), groupIdFocusNode);
                                                                          }
                                                                        }else{
                                                                          openValidationDialog("${lableModel.enterGropIdMsg}", groupIdFocusNode);
                                                                        }
                                                                      }
                                                                      else{
                                                                        createULDTrolley("${trollyTypeController.text}~${trollyNumberController.text}");
                                                                      }
                                                                    }else{
                                                                      openValidationDialog("${lableModel.entertrollyNumberMsg}", trollyNumberFocusNode);
                                                                    }
                                                                  }
                                                                  else{
                                                                    openValidationDialog("${lableModel.entertrollyTypeMsg}", trollyTypeFocusNode);
                                                                  }
                                                                }else{
                                                                  openValidationDialog("${lableModel.scantrolleymsg}", scanTrolleyFocusNode);
                                                                }
                                                              }
                                                            }
                                                            else{
                                                              openValidationDialog(lableModel.validateLocation!, locationFocusNode);
                                                            }
                                                          }
                                                          else{
                                                            openValidationDialog(lableModel.enterLocationMsg!, locationFocusNode);
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



  Widget isViewEnable(LableModel lableModel, int pageIndex, ui.TextDirection textDirection, AppLocalizations? localizations) {
    if (pageIndex == 0) {
      return  Column(
        children: [
          SizedBox(height: SizeConfig.blockSizeVertical * SizeUtils.HEIGHT2),
          Directionality(
            textDirection: textDirection,
            child: Row(
              children: [
                Expanded(
                  flex:1,
                  child: CustomTextField(
                    textDirection: textDirection,
                    controller: scanULDController,
                    focusNode: scanULDFocusNode,
                    onPress: () {},
                    hasIcon: false,
                    hastextcolor: true,
                    animatedLabel: true,
                    needOutlineBorder: true,
                    labelText: "${lableModel.scanuld} *",
                    readOnly: false,
                    maxLength: 11,
                    onChanged: (value) {
                      if(selectedSourceType == "U"){
                        String uldNumber = UldValidationUtil.validateUldNumberwithSpace1(scanULDController.text.toUpperCase());
                        if(uldNumber == "Valid"){
                          setState(() {
                            String uldNumbes = CommonUtils.ULDNUMBERCEHCK;
                            List<String> parts = uldNumbes.split(' ');
                            currentULDOwnerController.text = parts[2];
                          });
                        }else{
                          setState(() {
                            currentULDOwnerController.clear();
                          });
                        }
                      }else{
                        setState(() {
                          currentULDOwnerController.clear();
                        });
                      }
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
                  focusNode: scanULDBtnFocusNode,
                  onTap: () {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      FocusScope.of(context).requestFocus(scanULDBtnFocusNode);
                    });
                    scanULDScanQR();
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
            child: CustomTextField(
              textDirection: textDirection,
              controller: currentULDOwnerController,
              focusNode: currentULDOwnerFocusNode,
              onPress: () {},
              hasIcon: false,
              hastextcolor: true,
              animatedLabel: true,
              needOutlineBorder: true,
              labelText: "${lableModel.currentuldowner} *",
              readOnly: false,
              maxLength: 3,
              onChanged: (value) {
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
          SizedBox(height: SizeConfig.blockSizeVertical * SizeUtils.HEIGHT2),
        ],
      );

    }

    if (pageIndex == 1) {
      // design of a summary
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: SizeConfig.blockSizeVertical * SizeUtils.HEIGHT2),
          Directionality(
            textDirection: textDirection,
            child: Row(
              children: [
                Expanded(
                  flex:1,
                  child: CustomTextField(
                    textDirection: textDirection,
                    controller: scanTrolleyController,
                    focusNode: scanTrolleyFocusNode,
                    onPress: () {},
                    hasIcon: false,
                    hastextcolor: true,
                    animatedLabel: true,
                    needOutlineBorder: true,
                    labelText: "${lableModel.scantrolley} *",
                    readOnly: false,
                    maxLength: 11,
                    onChanged: (value) {
                      scanTrolleyController.text = value.toString().toUpperCase();
                      trollyTypeController.clear();
                      trollyNumberController.clear();
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
                  focusNode: scanTrolleyBtnFocusNode,
                  onTap: () {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      FocusScope.of(context).requestFocus(scanTrolleyBtnFocusNode);
                    });
                    scanTrolleyScanQR();
                  },
                  child: Padding(padding: const EdgeInsets.all(8.0),
                    child: SvgPicture.asset(search, height: SizeConfig.blockSizeVertical * SizeUtils.ICONSIZE3,),
                  ),

                )
              ],
            ),
          ),
          SizedBox(height: SizeConfig.blockSizeVertical * SizeUtils.HEIGHT2),
          Row(
            children: [
              Expanded(
                flex: 1,
                child: Directionality(
                  textDirection: textDirection,
                  child: GroupIdCustomTextField(
                    textDirection: textDirection,
                    controller: trollyTypeController,
                    hasIcon: false,
                    hastextcolor: true,
                    maxLength: 5,
                    isShowSuffixIcon: false,
                    animatedLabel: true,
                    needOutlineBorder: true,
                    labelText: "${lableModel.trollyType}",
                    focusNode: trollyTypeFocusNode,
                    nextFocus: trollyNumberFocusNode,
                    onChanged: (value) {

                    },
                    readOnly: false,
                    fillColor: locationController.text.isNotEmpty
                        ? Colors.grey.shade100
                        : Colors.grey.shade300,
                    textInputType: TextInputType.text,
                    inputAction: TextInputAction.next,
                    hintTextcolor: MyColor.colorGrey,
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
              SizedBox(
                width: SizeConfig.blockSizeHorizontal * SizeUtils.WIDTH4,
              ),
              Expanded(
                flex: 1,
                child: Directionality(
                  textDirection: textDirection,
                  child: GroupIdCustomTextField(
                    textDirection: textDirection,
                    controller: trollyNumberController,
                    hasIcon: false,
                    hastextcolor: true,
                    isShowSuffixIcon: false,
                    animatedLabel: true,
                    maxLength: 15,
                    needOutlineBorder: true,
                    labelText: "${lableModel.trollyNumber}",
                    focusNode: trollyNumberFocusNode,
                    onChanged: (value) {},
                    readOnly: false,
                    textInputType: TextInputType.text,
                    inputAction: TextInputAction.next,
                    hintTextcolor: MyColor.colorGrey,
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
          SizedBox(height: SizeConfig.blockSizeVertical * SizeUtils.HEIGHT2),
        ],
      );
    }


    return const SizedBox();
  }


  Future<void> scanULDScanQR() async{
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
       // unloadUldListModel = null;
        SnackbarUtil.showSnackbar(context, "${widget.lableModel!.onlyAlphaNumericValueMsg}", MyColor.colorRed, icon: FontAwesomeIcons.times);
        Vibration.vibrate(duration: 500);
        scanULDController.clear();
        currentULDOwnerController.clear();
        WidgetsBinding.instance.addPostFrameCallback((_) {
          FocusScope.of(context).requestFocus(scanULDFocusNode);
        });
      }else{
       // unloadUldListModel = null;
        String result = groupcodeScanResult.replaceAll(" ", "");
        scanULDController.text = result;
          String uldNumber = UldValidationUtil.validateUldNumberwithSpace1(scanULDController.text.toUpperCase());
          if(uldNumber == "Valid"){
            setState(() {
              String uldNumbes = CommonUtils.ULDNUMBERCEHCK;
              List<String> parts = uldNumbes.split(' ');
              currentULDOwnerController.text = parts[2];
              // call search api
              callSearchApi(selectedSourceType, scanULDController.text);

            });
          }
          else{
            scanULDController.clear();
            SnackbarUtil.showSnackbar(context, "${widget.lableModel!.entervalidULDNo}", MyColor.colorRed, icon: FontAwesomeIcons.times);
            Vibration.vibrate(duration: 500);
            currentULDOwnerController.clear();
            WidgetsBinding.instance.addPostFrameCallback((_) {
              FocusScope.of(context).requestFocus(scanULDFocusNode);
            });
          }

      }
    }
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
        context.read<EmptyULDTrolleyCubit>().getValidateLocation(
            truncatedResult,
            _user!.userProfile!.userIdentity!,
            _splashDefaultData!.companyCode!,
            widget.menuId, "a");
      }

    }


  }
  Future<void> scanTrolleyScanQR() async{
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
        // unloadUldListModel = null;
        SnackbarUtil.showSnackbar(context, "${widget.lableModel!.onlyAlphaNumericValueMsg}", MyColor.colorRed, icon: FontAwesomeIcons.times);
        Vibration.vibrate(duration: 500);
        scanTrolleyController.clear();
        WidgetsBinding.instance.addPostFrameCallback((_) {
          FocusScope.of(context).requestFocus(scanTrolleyFocusNode);
        });
      }else{
        // unloadUldListModel = null;
        String result = groupcodeScanResult.replaceAll(" ", "");
        scanTrolleyController.text = result.toUpperCase();
        setState(() {
          callSearchApi(selectedSourceType, scanTrolleyController.text);

        });
      }
    }
  }

  Future<void> callSearchApi(String selectedType, String scanNo) async {
    await context.read<EmptyULDTrolleyCubit>().searchULDTrolley(
        selectedType,
        scanNo,
        _user!.userProfile!.userIdentity!,
        _splashDefaultData!.companyCode!,
        widget.menuId);
  }

  Future<void> createULDTrolley(String uldNo) async {
    await context.read<EmptyULDTrolleyCubit>().createULDTrolley(
        uldNo,
        selectedSourceType,
        currentULDOwnerController.text,
        locationController.text,
        groupIdController.text,
        _user!.userProfile!.userIdentity!,
        _splashDefaultData!.companyCode!,
        widget.menuId);
  }

}

class TickerProviders extends TickerProvider {
  @override
  Ticker createTicker(onTick) => Ticker(onTick);
}

