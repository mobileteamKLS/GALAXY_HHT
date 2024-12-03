import 'package:dashed_circular_progress_bar/dashed_circular_progress_bar.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:galaxy/core/mycolor.dart';
import 'package:galaxy/module/export/services/airsiderelease/airsidelogic/airsidereleasecubit.dart';
import 'package:galaxy/module/export/services/airsiderelease/airsidelogic/airsidereleasestate.dart';
import 'package:galaxy/utils/sizeutils.dart';
import 'package:galaxy/widget/custometext.dart';
import 'package:galaxy/widget/groupidcustomtextfield.dart';
import 'package:intl/intl.dart';
import 'package:vibration/vibration.dart';
import '../../../../../../widget/customeuiwidgets/header.dart';
import '../../../../core/images.dart';
import '../../../../language/appLocalizations.dart';
import '../../../../language/model/lableModel.dart';
import '../../../../manager/timermanager.dart';
import '../../../../prefrence/savedprefrence.dart';
import '../../../../utils/commonutils.dart';
import '../../../../utils/dialogutils.dart';
import '../../../../utils/snackbarutil.dart';
import '../../../../widget/customebuttons/roundbuttonblue.dart';
import '../../../../widget/customedrawer/customedrawer.dart';
import '../../../../widget/customeedittext/customeedittextwithborder.dart';
import '../../../../widget/customtextfield.dart';
import '../../../../widget/header/mainheadingwidget.dart';
import '../../../login/pages/signinscreenmethods.dart';
import '../../../profile/page/profilepagescreen.dart';
import '../../../splash/model/splashdefaultmodel.dart';
import '../../../onboarding/sizeconfig.dart';
import 'dart:ui' as ui;

import '../../../login/model/userlogindatamodel.dart';
import '../../../submenu/model/submenumodel.dart';

class AirSideRelease extends StatefulWidget {
  String mainMenuName;
  String title;
  String refrelCode;
  LableModel? lableModel;
  int menuId;
  List<SubMenuName> importSubMenuList = [];
  List<SubMenuName> exportSubMenuList = [];

  AirSideRelease(
      {super.key,
      required this.importSubMenuList,
      required this.exportSubMenuList,
      required this.title,
      required this.refrelCode,
      this.lableModel,
      required this.menuId,
      required this.mainMenuName});

  @override
  State<AirSideRelease> createState() => _AirSideReleaseState();
}

class _AirSideReleaseState extends State<AirSideRelease>
    with SingleTickerProviderStateMixin {



  InactivityTimerManager? inactivityTimerManager;
  final SavedPrefrence savedPrefrence = SavedPrefrence();
  UserDataModel? _user;
  SplashDefaultModel? _splashDefaultData;
  final ScrollController scrollController = ScrollController();



  TextEditingController locationController = TextEditingController();
  TextEditingController igmNoEditingController = TextEditingController();




  FocusNode locationFocusNode = FocusNode();
  FocusNode locationBtnFocusNode = FocusNode();
  FocusNode igmNoFocusNode = FocusNode();
  FocusNode scanBtnFocusNode = FocusNode();


  DateTime? _selectedDate;


  bool _isLocationSearchBtnEnable = false;
  bool _isvalidateLocation = false;
  bool _isDatePickerOpen = false;



  late AnimationController _blinkController;
  late Animation<Color?> _colorAnimation;

  bool _isOpenULDFlagEnable = false;

  final ValueNotifier<double> _valueNotifier = ValueNotifier(0);


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
    ).animate(_blinkController); // color animation

    // add tabs length




    locationFocusNode.addListener(() {
      if (!locationFocusNode.hasFocus) {
        leaveLocationFocus();
      }
    });


    locationController.addListener(_validateLocationSearchBtn);


    igmNoFocusNode.addListener(() {
      if(!igmNoFocusNode.hasFocus){
        if(locationController.text.isNotEmpty){
          if(_isvalidateLocation){
            if(igmNoEditingController.text.isNotEmpty){

            //  callFlightCheckULDListApi(context, locationController.text, igmNoEditingController.text, "", "1900-01-01", _user!.userProfile!.userIdentity!, _splashDefaultData!.companyCode!, widget.menuId, (_isOpenULDFlagEnable == true) ? 1 : 0);
            }
          }else{
            //focus on location feild
            WidgetsBinding.instance.addPostFrameCallback((_) {
              FocusScope.of(context).requestFocus(locationFocusNode);
            },
            );
          }
        }else{
          //focus on location feild
          WidgetsBinding.instance.addPostFrameCallback((_) {
            FocusScope.of(context).requestFocus(locationFocusNode);
          },
          );

        }
      }

    },);

  }

  @override
  void dispose() {
    super.dispose();
    //all controller and focus node dispose
    inactivityTimerManager?.stopTimer(); // Stop the timer when the screen is disposed
    _blinkController.dispose();
    scrollController.dispose();
    locationController.dispose();
    locationFocusNode.dispose();
    igmNoEditingController.dispose();
    igmNoFocusNode.dispose();
    scanBtnFocusNode.dispose();

  }

  Future<void> _loadUser() async {
    final user = await savedPrefrence.getUserData();
    final splashDefaultData = await savedPrefrence.getSplashDefaultData();
    if (user != null && splashDefaultData != null) {
      setState(() {
        _user = user;
        _splashDefaultData = splashDefaultData;
      });
    //  context.read<AirSideReleaseCubit>().getPageLoadDefault(widget.menuId, _user!.userProfile!.userIdentity!, _splashDefaultData!.companyCode!);

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
  }

  Future<void> leaveLocationFocus() async {
    if (locationController.text.isNotEmpty) {
      //call location validation api
      await context.read<AirSideReleaseCubit>().getValidateLocation(
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

  Future<bool> _onWillPop() async {
    FocusScope.of(context).unfocus();
    locationController.clear();
    igmNoEditingController.clear();
    _isvalidateLocation = false;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(locationFocusNode);
    },
    );
    _isOpenULDFlagEnable = false;
    Navigator.pop(context, "Done");

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
        onTap: _resumeTimerOnInteraction,  // Resuming on any tap
        onPanDown: (details) => _resumeTimerOnInteraction(), // Resuming on any gesture
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
                  _scaffoldKey.currentState?.closeDrawer();
                },
              ) : null,
              body: Stack(
                children: [
                  MainHeadingWidget(mainMenuName: widget.mainMenuName,
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
                    child: NotificationListener<ScrollNotification>(
                      onNotification: (ScrollNotification scroll) {
                        _resumeTimerOnInteraction(); // Reset the timer on scroll event
                        return true;
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            color: MyColor.bgColorGrey,
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(
                                    SizeConfig.blockSizeVertical * SizeUtils.WIDTH2),
                                topLeft: Radius.circular(
                                    SizeConfig.blockSizeVertical *
                                        SizeUtils.WIDTH2))),
                        child: Column(
                          children: [
                            // header of title and clear function
                            Padding(
                              padding: const EdgeInsets.only(left: 10, right: 15, top: 12, bottom: 12),
                              child: HeaderWidget(
                                titleTextColor: MyColor.colorBlack,
                                title: widget.title,
                                onBack: _onWillPop,
                                clearText: lableModel!.clear,
                                //add clear text to clear all feild
                                onClear: () {

                                },
                              ),
                            ),

                            // start api responcer
                            BlocListener<AirSideReleaseCubit, AirSideReleaseState>(
                              listener: (context, state) {

                                if (state is AirSideMainInitialState) {
                                }
                                else if (state is AirSideMainLoadingState) {
                                  // showing loading dialog in this state
                                  DialogUtils.showLoadingDialog(context, message: lableModel.loading);
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
                                      FocusScope.of(context).requestFocus(igmNoFocusNode);
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
                                  child: Column(
                                    children: [
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          // location textfield
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 10,
                                                right: 10,
                                                top: 0,
                                                bottom: 0),
                                            child: Directionality(
                                              textDirection: textDirection,
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: MyColor.colorWhite,
                                                  borderRadius:BorderRadius.circular(8),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: MyColor.colorBlack.withOpacity(0.09),
                                                      spreadRadius: 2,
                                                      blurRadius: 15,
                                                      offset: const Offset(0, 3), // changes position of shadow
                                                    ),
                                                  ],
                                                ),
                                                child: Padding(
                                                  padding: const EdgeInsets.only(
                                                      left: 12,
                                                      right: 12,
                                                      top: 12,
                                                      bottom: 12),
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          SvgPicture.asset(info, height: SizeConfig.blockSizeVertical * SizeUtils.ICONSIZE2,),
                                                          SizedBox(width: SizeConfig.blockSizeHorizontal,),
                                                          CustomeText(
                                                              text: "${lableModel.scanOrManual}",
                                                              fontColor: MyColor.textColorGrey2,
                                                              fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                                              fontWeight: FontWeight.w500,
                                                              textAlign: TextAlign.start)
                                                        ],
                                                      ),
                                                      SizedBox(
                                                        height: SizeConfig.blockSizeVertical * SizeUtils.HEIGHT2,
                                                      ),
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
                                                                labelText: "Door *",
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
                                                        height: SizeConfig.blockSizeVertical * SizeUtils.HEIGHT_1_5,
                                                      ),
                                                      Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        children: [
                                                          Expanded(
                                                            flex: 1,
                                                            child: CustomTextField(
                                                              textDirection: textDirection,
                                                              hasIcon: false,
                                                              hastextcolor: true,
                                                              animatedLabel: true,
                                                              needOutlineBorder: true,
                                                              labelText: "Scan",
                                                              readOnly: locationController.text.isNotEmpty ? false : true,
                                                              controller: igmNoEditingController,
                                                              focusNode: igmNoFocusNode,
                                                              maxLength: 15,
                                                              onChanged: (value) {
                                                                _isOpenULDFlagEnable = false;

                                                                setState(() {});
                                                              },
                                                              fillColor: Colors.grey.shade100,
                                                              textInputType: TextInputType.number,
                                                              inputAction: TextInputAction.next,
                                                              hintTextcolor: Colors.black,
                                                              verticalPadding: 0,
                                                              fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_8,
                                                              circularCorner: SizeConfig.blockSizeHorizontal * SizeUtils.CIRCULARCORNER,
                                                              boxHeight: SizeConfig.blockSizeVertical * SizeUtils.BOXHEIGHT,
                                                              digitsOnly: true,
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
                                                          InkWell(
                                                            onTap: () {
                                                              FocusScope.of(context).unfocus();
                                                              if(locationController.text.isNotEmpty){
                                                                if(_isvalidateLocation){
                                                                  scanQR();
                                                                }else{
                                                                  FocusScope.of(context).requestFocus(locationFocusNode);
                                                                }
                                                              }else{
                                                                openValidationDialog(lableModel.enterLocationMsg!, locationFocusNode);
                                                              }

                                                            },
                                                            child: Padding(padding: const EdgeInsets.all(8.0),
                                                              child: SvgPicture.asset(search, height: SizeConfig.blockSizeVertical * SizeUtils.ICONSIZE3,),
                                                            ),
                                                          ),
                                                        ],
                                                      ),

                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: SizeConfig.blockSizeVertical,),

                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 10,
                                                right: 10,
                                                top: 0,
                                                bottom: 0),
                                            child: Container(
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

                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          CustomeText(
                                                            text: "BA 199",
                                                            fontColor: MyColor.colorBlack,
                                                            fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                                            fontWeight: FontWeight.w600,
                                                            textAlign: TextAlign.start,
                                                          ),
                                                          const SizedBox(width: 5),
                                                          CustomeText(
                                                          /*  text: " ${widget.flightDetailSummary.flightDate!.replaceAll(" ", "-")}",*/
                                                            text: "03-DEC-24",
                                                            fontColor: MyColor.textColorGrey2,
                                                            fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                                            fontWeight: FontWeight.w600,
                                                            textAlign: TextAlign.start,
                                                          ),
                                                        ],
                                                      ),
                                                      Row(
                                                        children: [
                                                          CustomeText(
                                                              text:  "BLR",
                                                              fontColor: MyColor.textColorGrey3,
                                                              fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_4,
                                                              fontWeight: FontWeight.w800,
                                                              textAlign: TextAlign.start),
                                                          SizedBox(width: SizeConfig.blockSizeHorizontal,),
                                                          SvgPicture.asset(arrival, height: SizeConfig.blockSizeVertical * SizeUtils.ICONSIZE2,),
                                                          SizedBox(width: SizeConfig.blockSizeHorizontal,),
                                                          CustomeText(
                                                              text:  "DXB",
                                                              fontColor: MyColor.textColorGrey3,
                                                              fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_4,
                                                              fontWeight: FontWeight.w800,
                                                              textAlign: TextAlign.start),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(height: SizeConfig.blockSizeVertical,),
                                                  Container(
                                                    padding: const EdgeInsets.all(8),
                                                    decoration: BoxDecoration(
                                                      color: MyColor.cardBgColor,
                                                      borderRadius: BorderRadius.circular(8),
                                                    ),
                                                    child: Row(
                                                      children: [
                                                        Expanded(
                                                            flex: 1,
                                                            child: Column(
                                                              children: [
                                                                CustomeText(
                                                                    text: "5",
                                                                    fontColor: MyColor.colorBlack,
                                                                    fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_6,
                                                                    fontWeight: FontWeight.w600,
                                                                    textAlign: TextAlign.center),

                                                                CustomeText(
                                                                    text: "Containers",
                                                                    fontColor: MyColor.textColorGrey2,
                                                                    fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_3,
                                                                    fontWeight: FontWeight.w400,
                                                                    textAlign: TextAlign.center)



                                                              ],
                                                            )),

                                                        Expanded(
                                                            flex: 1,
                                                            child: Column(
                                                              children: [
                                                                CustomeText(
                                                                    text: "0",
                                                                    fontColor: MyColor.colorBlack,
                                                                    fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_6,
                                                                    fontWeight: FontWeight.w600,
                                                                    textAlign: TextAlign.center),

                                                                CustomeText(
                                                                    text: "Pallets",
                                                                    fontColor: MyColor.textColorGrey2,
                                                                    fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_3,
                                                                    fontWeight: FontWeight.w400,
                                                                    textAlign: TextAlign.center)
                                                              ],
                                                            )),

                                                        Expanded(
                                                            flex: 1,
                                                            child: Column(
                                                              children: [
                                                                CustomeText(
                                                                    text: "0",
                                                                    fontColor: MyColor.colorBlack,
                                                                    fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_6,
                                                                    fontWeight: FontWeight.w600,
                                                                    textAlign: TextAlign.center),

                                                                CustomeText(
                                                                    text: "BULK / Trolley",
                                                                    fontColor: MyColor.textColorGrey2,
                                                                    fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_3,
                                                                    fontWeight: FontWeight.w400,
                                                                    textAlign: TextAlign.center)
                                                              ],
                                                            )),
                                                      ],
                                                    ),
                                                  ),
                                                  SizedBox(height: SizeConfig.blockSizeVertical,),

                                                /*  RoundedButtonBlue(
                                                    text: "Release All",
                                                    press: () async {


                                                    },
                                                  ),*/

                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          SvgPicture.asset(info, height: SizeConfig.blockSizeVertical * SizeUtils.ICONSIZE2,),
                                                          SizedBox(
                                                            width: SizeConfig.blockSizeHorizontal,
                                                          ),
                                                          CustomeText(
                                                              text: "Show release & offload only",
                                                              fontColor: MyColor.textColorGrey2,
                                                              fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                                              fontWeight: FontWeight.w500,
                                                              textAlign: TextAlign.start)
                                                        ],
                                                      ),
                                                      Switch(
                                                        value: _isOpenULDFlagEnable,
                                                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                                        activeColor: MyColor.primaryColorblue,
                                                        inactiveThumbColor: MyColor.thumbColor,
                                                        inactiveTrackColor: MyColor.textColorGrey2,
                                                        trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
                                                        onChanged: (value) {
                                                          setState(() {
                                                            _isOpenULDFlagEnable = value;
                                                          });
                                                          //call api //
                                                        },
                                                      )
                                                    ],
                                                  ),



                                                ],
                                              ),
                                            ),
                                          ),



                                        ],
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
        context.read<AirSideReleaseCubit>().getValidateLocation(
            truncatedResult,
            _user!.userProfile!.userIdentity!,
            _splashDefaultData!.companyCode!,
            widget.menuId, "a");
      }

    }


  }


  Future<void> scanQR() async {
    String barcodeScanResult =  await FlutterBarcodeScanner.scanBarcode(
      '#ff6666', // Color for the scanner overlay
      'Cancel', // Text for the cancel button
      true, // Enable flash option
      ScanMode.DEFAULT, // Scan mode
    );

    if(barcodeScanResult == "-1"){

    }else{

      bool specialCharAllow = CommonUtils.containsSpecialCharactersAndAlpha(barcodeScanResult);




      if(specialCharAllow == true){
        SnackbarUtil.showSnackbar(context, "${widget.lableModel!.onlyNumericValueMsg}", MyColor.colorRed, icon: FontAwesomeIcons.times);
        Vibration.vibrate(duration: 500);
        igmNoEditingController.clear();
        WidgetsBinding.instance.addPostFrameCallback((_) {
          FocusScope.of(context).requestFocus(igmNoFocusNode);
        });
      }else{
        String result = barcodeScanResult.replaceAll(" ", "");

        String truncatedResult = result.length > 15
            ? result.substring(0, 15)
            : result;

        igmNoEditingController.text = truncatedResult;
      //  callFlightCheckULDListApi(context, locationController.text, truncatedResult, "", "1900-01-01", _user!.userProfile!.userIdentity!, _splashDefaultData!.companyCode!, widget.menuId, (_isOpenULDFlagEnable == true) ? 1 : 0);
      }
    }
  }

  // flight check ULD List api call function
  void callFlightCheckULDListApi(
      BuildContext context,
      String locationCode,
      String scan,
      String flightNo,
      String flightDate,
      int userId,
      int companyCode,
      int menuId,
      int ULDListFlag) {
/*    context.read<FlightCheckCubit>().getFlightCheckULDList(
        locationCode,
        scan,
        flightNo.replaceAll(" ", ""),
        flightDate,
        userId,
        companyCode,
        menuId,
        ULDListFlag);*/
  }





  // validation dialog
  Future<void> openValidationDialog(String message, FocusNode focuseNode) async {
    bool? empty = await DialogUtils.showDataNotFoundDialogbot(
        context, message, widget.lableModel!);

    if (empty == true) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        FocusScope.of(context).requestFocus(focuseNode);
      });
    }
  }
}




// ticker animation for DGR code blink animation
class TickerProviders extends TickerProvider {
  @override
  Ticker createTicker(onTick) => Ticker(onTick);
}
