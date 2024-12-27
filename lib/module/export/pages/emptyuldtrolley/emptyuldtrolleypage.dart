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
import 'package:vibration/vibration.dart';
import '../../../../../../widget/customeuiwidgets/header.dart';
import '../../../../core/images.dart';
import '../../../../language/appLocalizations.dart';
import '../../../../language/model/lableModel.dart';
import '../../../../manager/timermanager.dart';
import '../../../../prefrence/savedprefrence.dart';
import '../../../../utils/commonutils.dart';
import '../../../../utils/dialogutils.dart';
import '../../../../widget/customedrawer/customedrawer.dart';
import '../../../../widget/customeedittext/customeedittextwithborder.dart';
import '../../../../widget/custometext.dart';
import '../../../../widget/customtextfield.dart';
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




  String groupIdRequired = "";
  int groupIdCharSize = 1;

  TextEditingController locationController = TextEditingController();
  FocusNode locationFocusNode = FocusNode();
  FocusNode locationBtnFocusNode = FocusNode();

  bool _isLocationSearchBtnEnable = false;
  bool _isvalidateLocation = false;

  InactivityTimerManager? inactivityTimerManager;
  final SavedPrefrence savedPrefrence = SavedPrefrence();
  UserDataModel? _user;
  SplashDefaultModel? _splashDefaultData;
  final ScrollController scrollController = ScrollController();

  TextEditingController scanController = TextEditingController();
  FocusNode scanFocusNode = FocusNode();
  FocusNode scanBtnFocusNode = FocusNode();



  bool isBackPressed = false; // Track if the back button was pressed




  late AnimationController _blinkController;
  late Animation<Color?> _colorAnimation;

  bool isInactivityDialogOpen = false; // Flag to track inactivity dialog state

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


    locationFocusNode.addListener(() {
      if (!locationFocusNode.hasFocus) {
        leaveLocationFocus();
      }
    });

    locationController.addListener(_validateLocationSearchBtn);



    scanFocusNode.addListener(() {
      if (!scanFocusNode.hasFocus && !isBackPressed) {
        leaveSourceScanFocus();
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
  void _validateLocationSearchBtn() {
    setState(() {
      _isLocationSearchBtnEnable = locationController.text.isNotEmpty;
    });
  }


  Future<void> leaveSourceScanFocus() async {

    // Skip the focus leave logic if inactivity dialog is open
    if (isInactivityDialogOpen) return;

    if (scanController.text.isNotEmpty) {
      /*if(unloadUldListModel == null){
        await context.read<UnloadULDCubit>().unloadULDlistLoad(
            scanController.text,
            _user!.userProfile!.userIdentity!,
            _splashDefaultData!.companyCode!,
            widget.menuId);
      }else{

      }*/
      // call source uld api details api

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
    scanFocusNode.dispose();
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
    scanFocusNode.unfocus();
    isInactivityDialogOpen = true; // Set flag before showing dialog

    bool? activateORNot = await DialogUtils.showingActivateTimerDialog(
        context, _user!.userProfile!.userId!, _splashDefaultData!.companyCode!);

    isInactivityDialogOpen = false; // Reset flag after dialog closes

    if (activateORNot == true) {
      inactivityTimerManager!.resetTimer();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        FocusScope.of(context).requestFocus(scanFocusNode);
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
    scanFocusNode.unfocus();
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
                      scanFocusNode.unfocus();
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
                                  scanController.clear();
                                  WidgetsBinding.instance.addPostFrameCallback((_) {
                                    FocusScope.of(context).requestFocus(scanFocusNode);
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
                                    WidgetsBinding.instance.addPostFrameCallback((_) {
                                      FocusScope.of(context).requestFocus(scanFocusNode);
                                    },
                                    );
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
                                                        labelText: "Scan Location *",
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

                                              Directionality(
                                                textDirection: textDirection,
                                                child: Row(
                                                  children: [

                                                    Expanded(
                                                      flex:1,
                                                      child: CustomTextField(
                                                        textDirection: textDirection,
                                                        controller: scanController,
                                                        focusNode: scanFocusNode,
                                                        onPress: () {},
                                                        hasIcon: false,
                                                        hastextcolor: true,
                                                        animatedLabel: true,
                                                        needOutlineBorder: true,
                                                        labelText: "${lableModel.scan}",
                                                        readOnly: false,
                                                        maxLength: 50,
                                                        onChanged: (value) {
                                                        //  unloadUldListModel = null;
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
                                                        scanSourceScanQR();
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

  Future<void> scanSourceScanQR() async{
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
        scanController.clear();
        WidgetsBinding.instance.addPostFrameCallback((_) {
          FocusScope.of(context).requestFocus(scanFocusNode);
        });
      }else{
       // unloadUldListModel = null;
        String result = groupcodeScanResult.replaceAll(" ", "");


        scanController.text = result;
        // Call searchLocation api to validate or not
        // call binning details api

       /* await context.read<UnloadULDCubit>().unloadULDlistLoad(
            scanController.text,
            _user!.userProfile!.userIdentity!,
            _splashDefaultData!.companyCode!,
            widget.menuId);*/
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

    }else{
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


}

class TickerProviders extends TickerProvider {
  @override
  Ticker createTicker(onTick) => Ticker(onTick);
}

