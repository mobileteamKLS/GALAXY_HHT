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
import 'package:galaxy/module/export/services/unloaduld/unloaduldlogic/unloaduldcubit.dart';
import 'package:galaxy/module/export/services/unloaduld/unloaduldlogic/unloaduldstate.dart';
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
import '../../model/uldtould/sourceuldmodel.dart';
import '../../model/unloaduld/unloadpageloadmodel.dart';

class UnloadULDPage extends StatefulWidget {
  String mainMenuName;
  String title;
  String refrelCode;
  LableModel? lableModel;
  int menuId;
  List<SubMenuName> importSubMenuList = [];
  List<SubMenuName> exportSubMenuList = [];

  UnloadULDPage(
      {super.key,
      required this.importSubMenuList,
      required this.exportSubMenuList,
      required this.title,
      required this.refrelCode,
      this.lableModel,
      required this.menuId,
      required this.mainMenuName});

  @override
  State<UnloadULDPage> createState() => _UnloadULDPageState();
}

class _UnloadULDPageState extends State<UnloadULDPage> with SingleTickerProviderStateMixin{

  UnloadUldPageLoadModel? unloadUldPageLoadModel;

  String groupIdRequired = "";
  int groupIdCharSize = 1;


  InactivityTimerManager? inactivityTimerManager;
  final SavedPrefrence savedPrefrence = SavedPrefrence();
  UserDataModel? _user;
  SplashDefaultModel? _splashDefaultData;
  final ScrollController scrollController = ScrollController();

  TextEditingController scanController = TextEditingController();
  FocusNode scanFocusNode = FocusNode();



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


    scanFocusNode.addListener(() {
      if (!scanFocusNode.hasFocus && !isBackPressed) {
        leaveSourceScanFocus();
      }
    });


  }


  Future<void> leaveSourceScanFocus() async {

    // Skip the focus leave logic if inactivity dialog is open
    if (isInactivityDialogOpen) return;

    if (scanController.text.isNotEmpty) {
      /*if(sourceULDModel == null){
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

    await context.read<UnloadULDCubit>().unloadULDPageLoad(
            _user!.userProfile!.userIdentity!,
            _splashDefaultData!.companyCode!,
            widget.menuId);

    /* WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(scanFocusNode);
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
                                 // sourceULDModel = null;
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
                            BlocListener<UnloadULDCubit, UnloadULDState>(
                              listener: (context, state) async {
                                if (state is UnloadULDInitialState) {
                                }
                                else if (state is UnloadULDLoadingState) {
                                  // showing loading dialog in this state
                                  DialogUtils.showLoadingDialog(context, message: lableModel.loading);
                                }
                                else if (state is UnloadULDPageLoadSuccessState) {
                                  DialogUtils.hideLoadingDialog(context);
                                  if (state.unloadUldPageLoadModel.status == "E") {
                                    Vibration.vibrate(duration: 500);
                                    SnackbarUtil.showSnackbar(
                                        context,
                                        state.unloadUldPageLoadModel.statusMessage!,
                                        MyColor.colorRed,
                                        icon: FontAwesomeIcons.times);

                                    WidgetsBinding.instance.addPostFrameCallback((_) {
                                      FocusScope.of(context).requestFocus(scanFocusNode);
                                    },
                                    );

                                  } else {

                                    groupIdRequired = state.unloadUldPageLoadModel.isGroupBasedAcceptChar!;
                                    groupIdCharSize = state.unloadUldPageLoadModel.isGroupBasedAcceptNumber!;

                                    WidgetsBinding.instance.addPostFrameCallback((_) {
                                      FocusScope.of(context).requestFocus(scanFocusNode);
                                    },
                                    );
                                    setState(() {});

                                  }
                                }
                                else if (state is UnloadULDPageLoadFailureState) {
                                  // validate location failure

                                  DialogUtils.hideLoadingDialog(context);
                                  Vibration.vibrate(duration: 500);
                                  SnackbarUtil.showSnackbar(
                                      context, state.error, MyColor.colorRed, icon: FontAwesomeIcons.times);
                                }
                                else if (state is UnloadULDListSuccessState){
                                  DialogUtils.hideLoadingDialog(context);
                                  if(state.unloadUldListModel.status == "E"){

                                  }else{

                                  }
                                }
                                else if (state is UnloadULDListFailureState){

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
                                                        labelText: "${lableModel.sourcescan}",
                                                        readOnly: false,
                                                        maxLength: 50,
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
                                                    SizedBox(
                                                      width: SizeConfig.blockSizeHorizontal,
                                                    ),
                                                    // click search button to validate location
                                                    InkWell(
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
                                              /*child: Padding(
                                                padding: const EdgeInsets.only(left: 12, right: 12, top: 12, bottom: 12),
                                                child: (sourceULDModel != null)
                                                    ? (sourceULDModel!.sourceULDAWBDetailList!.isNotEmpty) ? Column(
                                                  children: [

                                                    ListView.builder(
                                                      itemCount: (sourceULDModel != null)
                                                          ? sourceULDModel!.sourceULDAWBDetailList!.length
                                                          : 0,
                                                      physics: NeverScrollableScrollPhysics(),
                                                      shrinkWrap: true,
                                                      controller: scrollController,
                                                      itemBuilder: (context, index) {
                                                        SourceULDAWBDetailList sourceULDAWBDetailList =  sourceULDModel!.sourceULDAWBDetailList![index];
                                                        List<String> shcCodes = sourceULDAWBDetailList.sHCCode!.split(',');

                                                        return InkWell(
                                                            onTap: () {

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
                                                                child: DottedBorder(
                                                                  dashPattern: [7, 7, 7, 7],
                                                                  strokeWidth: 1,
                                                                  borderType: BorderType.RRect,
                                                                  color: sourceULDAWBDetailList.sHCCode!.contains("DGR") ? MyColor.colorRedLight : Colors.transparent,
                                                                  radius: Radius.circular(8),
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
                                                                                CustomeText(text: AwbFormateNumberUtils.formatAWBNumber(sourceULDAWBDetailList.aWBNo!), fontColor: MyColor.colorBlack, fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_6, fontWeight: FontWeight.w700, textAlign: TextAlign.start),
                                                                              ],
                                                                            ),
                                                                            sourceULDAWBDetailList.sHCCode!.isNotEmpty ? SizedBox(height: SizeConfig.blockSizeVertical * 0.8,) : SizedBox(),
                                                                            Row(
                                                                              children: [
                                                                                sourceULDAWBDetailList.sHCCode!.isNotEmpty
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
                                                                            sourceULDAWBDetailList.sHCCode!.isNotEmpty ? SizedBox(height: SizeConfig.blockSizeVertical) : SizedBox(height: SizeConfig.blockSizeVertical * 0.8,),
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
                                                                                      text: "${sourceULDAWBDetailList.nOP}",
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
                                                                                      text: CommonUtils.formateToTwoDecimalPlacesValue(sourceULDAWBDetailList.weightKg!),
                                                                                      fontColor: MyColor.colorBlack,
                                                                                      fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                                                                      fontWeight: FontWeight.w600,
                                                                                      textAlign: TextAlign.start,
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                              ],
                                                                            )
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

                                              ),*/
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
       // sourceULDModel = null;
        SnackbarUtil.showSnackbar(context, "${widget.lableModel!.onlyAlphaNumericValueMsg}", MyColor.colorRed, icon: FontAwesomeIcons.times);
        Vibration.vibrate(duration: 500);
        scanController.clear();
        WidgetsBinding.instance.addPostFrameCallback((_) {
          FocusScope.of(context).requestFocus(scanFocusNode);
        });
      }else{
       // sourceULDModel = null;
        String result = groupcodeScanResult.replaceAll(" ", "");


        scanController.text = result;
        // Call searchLocation api to validate or not
        // call binning details api

       /* await context.read<ULDToULDCubit>().sourceULD(
            scanController.text,
            _user!.userProfile!.userIdentity!,
            _splashDefaultData!.companyCode!,
            widget.menuId);*/
      }
    }
  }



}

class TickerProviders extends TickerProvider {
  @override
  Ticker createTicker(onTick) => Ticker(onTick);
}

