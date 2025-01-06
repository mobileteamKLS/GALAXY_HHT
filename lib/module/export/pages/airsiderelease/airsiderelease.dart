import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:galaxy/core/mycolor.dart';
import 'package:galaxy/module/export/pages/airsiderelease/airsideshipmetlistpage.dart';
import 'package:galaxy/module/export/pages/airsiderelease/esignaturepage.dart';
import 'package:galaxy/module/export/services/airsiderelease/airsidelogic/airsidereleasecubit.dart';
import 'package:galaxy/module/export/services/airsiderelease/airsidelogic/airsidereleasestate.dart';
import 'package:galaxy/utils/sizeutils.dart';
import 'package:galaxy/widget/custometext.dart';
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
import '../../../../utils/snackbarutil.dart';
import '../../../../widget/customebuttons/roundbuttonblue.dart';
import '../../../../widget/customedrawer/customedrawer.dart';
import '../../../../widget/customeedittext/customeedittextwithborder.dart';
import '../../../../widget/customtextfield.dart';
import '../../../../widget/header/mainheadingwidget.dart';
import '../../../../widget/uldnumberwidget.dart';
import '../../../login/pages/signinscreenmethods.dart';
import '../../../profile/page/profilepagescreen.dart';
import '../../../splash/model/splashdefaultmodel.dart';
import '../../../onboarding/sizeconfig.dart';
import 'dart:ui' as ui;

import '../../../login/model/userlogindatamodel.dart';
import '../../../submenu/model/submenumodel.dart';
import '../../model/airsiderelease/airsidereleasepageloadmodel.dart';
import '../../model/airsiderelease/airsidereleasesearchmodel.dart';

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

  final List<String> flightList = [
    "BA 321",
    "Aj 1993",
    "BA 199",
    "EK 0532",
  ];

  final List<String> uldList = [
    "AKE",
    "BAY",
    "PIH",
    "PAX",
  ];




  final List<String> _tabs = ['Detail', 'Flight', 'ULD'];
  int _pageIndex = 0;



  List<DesignationWiseSignatureSettingList> signatureList = [];

  String signatureRequired = "";

  final Set<int> _selectedIndices = {}; // Store selected indices
  final List<AirsideReleaseDetailList> _selectedItems = [];


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
  FocusNode tempFocusNode = FocusNode();
  FocusNode releaseAllFocusNode = FocusNode();




  bool _isLocationSearchBtnEnable = false;
  bool _isvalidateLocation = false;



  late AnimationController _blinkController;
  late Animation<Color?> _colorAnimation;

  bool _isOpenULDFlagEnable = false;

  AirSideReleaseSearchModel? airSideReleaseSearchModel;
  List<AirsideReleaseDetailList> airsideReleaseDetailList = [];
  List<AirsideReleaseDetailList> filteredAirsideReleaseDetailList = [];

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
              if(airsideReleaseDetailList.isEmpty){
                getAirsideReleaseDetail(context, locationController.text, igmNoEditingController.text, _user!.userProfile!.userIdentity!, _splashDefaultData!.companyCode!, widget.menuId);
              }else{

              }

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

     context.read<AirSideReleaseCubit>().getPageLoad(_user!.userProfile!.userIdentity!, _splashDefaultData!.companyCode!, widget.menuId,);

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

  void _filterList() {
    setState(() {
      filteredAirsideReleaseDetailList = airsideReleaseDetailList
          .where((item) => _isOpenULDFlagEnable ? (item.isReleased == "Y" || item.isReleased == "N") : item.isReleased == "N").toList();

      filteredAirsideReleaseDetailList.sort((a, b) => a.priority!.compareTo(b.priority!));
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
                            Padding(
                              padding: const EdgeInsets.only(left: 10, right: 15, top: 12, bottom: 12),
                              child: HeaderWidget(
                                titleTextColor: MyColor.colorBlack,
                                title: widget.title,
                                onBack: _onWillPop,
                                clearText: lableModel!.clear,
                                onClear: () {
                                  _pageIndex = 0;
                                  _selectedItems.clear();
                                  _isvalidateLocation = false;
                                  locationController.clear();
                                  igmNoEditingController.clear();
                                  airSideReleaseSearchModel = null;
                                  airsideReleaseDetailList.clear();
                                  filteredAirsideReleaseDetailList.clear();
                                  WidgetsBinding.instance.addPostFrameCallback((_) {
                                    FocusScope.of(context).requestFocus(locationFocusNode);
                                  },
                                  );
                                  setState(() {

                                  });
                                },
                              ),
                            ),
                            BlocListener<AirSideReleaseCubit, AirSideReleaseState>(
                              listener: (context, state) {

                                if (state is AirSideMainInitialState) {
                                }
                                else if (state is AirSideMainLoadingState) {
                                  // showing loading dialog in this state
                                  DialogUtils.showLoadingDialog(context, message: lableModel.loading);
                                }
                                else if (state is AirsideReleasePageLoadSuccessState){
                                  DialogUtils.hideLoadingDialog(context);
                                  if(state.airsidePageLoadModel.status == "E"){
                                    Vibration.vibrate(duration: 500);
                                    SnackbarUtil.showSnackbar(
                                        context,
                                        state.airsidePageLoadModel.statusMessage!,
                                        MyColor.colorRed,
                                        icon: FontAwesomeIcons.times);
                                  }else{
                                    signatureRequired = state.airsidePageLoadModel.isAirsideReleaseSignRequired!;

                                    signatureList = state.airsidePageLoadModel.designationWiseSignatureSettingList!;

                                    WidgetsBinding.instance.addPostFrameCallback((_) {
                                      FocusScope.of(context).requestFocus(locationFocusNode);
                                    });

                                    setState(() {

                                    });

                                  }
                                }
                                else if (state is AirsideReleasePageLoadFailureState){
                                  DialogUtils.hideLoadingDialog(context);
                                  Vibration.vibrate(duration: 500);
                                  SnackbarUtil.showSnackbar(
                                      context, state.error, MyColor.colorRed, icon: FontAwesomeIcons.times);
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
                                    _isvalidateLocation = true;
                                    setState(() {});
                                    WidgetsBinding.instance.addPostFrameCallback((_) {
                                      FocusScope.of(context).requestFocus(igmNoFocusNode);
                                    },
                                    );
                                  }
                                }
                                else if (state is ValidateLocationFailureState) {
                                  DialogUtils.hideLoadingDialog(context);
                                  _isvalidateLocation = false;
                                  Vibration.vibrate(duration: 500);
                                  SnackbarUtil.showSnackbar(
                                      context, state.error, MyColor.colorRed, icon: FontAwesomeIcons.times);
                                }
                                else if (state is AirsideReleaseSuccessState){
                                  DialogUtils.hideLoadingDialog(context);
                                  if(state.airSideReleaseSearchModel.status == "E"){
                                    airSideReleaseSearchModel = null;
                                    airsideReleaseDetailList.clear();
                                    _selectedItems.clear();
                                    Vibration.vibrate(duration: 500);
                                    SnackbarUtil.showSnackbar(
                                        context,
                                        state.airSideReleaseSearchModel.statusMessage!,
                                        MyColor.colorRed,
                                        icon: FontAwesomeIcons.times);
                                    WidgetsBinding.instance.addPostFrameCallback((_) {
                                      FocusScope.of(context).requestFocus(igmNoFocusNode);
                                    },
                                    );
                                  }
                                  else{
                                    _selectedItems.clear();
                                    _isOpenULDFlagEnable = false;
                                    airSideReleaseSearchModel = state.airSideReleaseSearchModel;
                                    airsideReleaseDetailList = state.airSideReleaseSearchModel.airsideReleaseDetailList!;
                                    filteredAirsideReleaseDetailList = airsideReleaseDetailList
                                        .where((item) => item.isReleased == "N")
                                        .toList();
                                    filteredAirsideReleaseDetailList.sort((a, b) => a.priority!.compareTo(b.priority!));
                                    _pageIndex = 0;
                                    setState(() {

                                    });
                                  }

                                }
                                else if (state is AirsideReleaseFailureState){
                                  DialogUtils.hideLoadingDialog(context);
                                  airSideReleaseSearchModel = null;
                                  airsideReleaseDetailList.clear();
                                  Vibration.vibrate(duration: 500);
                                  SnackbarUtil.showSnackbar(
                                      context,
                                      state.error,
                                      MyColor.colorRed,
                                      icon: FontAwesomeIcons.times);
                                }
                                else if (state is AirsideReleaseDataSuccessState){

                                  if(state.airsideReleaseDataModel.status == "E"){
                                    DialogUtils.hideLoadingDialog(context);
                                    Vibration.vibrate(duration: 500);
                                    SnackbarUtil.showSnackbar(
                                        context,
                                        state.airsideReleaseDataModel.statusMessage!,
                                        MyColor.colorRed,
                                        icon: FontAwesomeIcons.times);
                                  }else{
                                    if(_selectedItems.isEmpty){
                                      DialogUtils.hideLoadingDialog(context);
                                      getAirsideReleaseDetail(context, locationController.text, igmNoEditingController.text, _user!.userProfile!.userIdentity!, _splashDefaultData!.companyCode!, widget.menuId);
                                      SnackbarUtil.showSnackbar(
                                          context,
                                          state.airsideReleaseDataModel.statusMessage!,
                                          MyColor.colorGreen,
                                          icon: Icons.done);
                                    }else{

                                    }
                                  }
                                }
                                else if (state is AirsideReleaseDataFailureState){
                                  DialogUtils.hideLoadingDialog(context);
                                  Vibration.vibrate(duration: 500);
                                  SnackbarUtil.showSnackbar(
                                      context,
                                      state.error,
                                      MyColor.colorRed,
                                      icon: FontAwesomeIcons.times);
                                }
                                else if (state is AirsideReleasePriorityUpdateSuccessState){
                                  DialogUtils.hideLoadingDialog(context);
                                  if(state.airsideReleasePriorityUpdateModel.status == "E"){
                                    Vibration.vibrate(duration: 500);
                                    SnackbarUtil.showSnackbar(
                                        context,
                                        state.airsideReleasePriorityUpdateModel.statusMessage!,
                                        MyColor.colorRed,
                                        icon: FontAwesomeIcons.times);
                                  }else{
                                    getAirsideReleaseDetail(context, locationController.text, igmNoEditingController.text, _user!.userProfile!.userIdentity!, _splashDefaultData!.companyCode!, widget.menuId);
                                  }
                                }
                                else if (state is AirsideReleasePriorityUpdateFailureState){
                                  DialogUtils.hideLoadingDialog(context);
                                  Vibration.vibrate(duration: 500);
                                  SnackbarUtil.showSnackbar(
                                      context,
                                      state.error,
                                      MyColor.colorRed,
                                      icon: FontAwesomeIcons.times);
                                }
                                else if (state is AirsideReleaseBatteryUpdateSuccessState){
                                  DialogUtils.hideLoadingDialog(context);
                                  if(state.airsideReleaseBatteryUpdateModel.status == "E"){
                                    Vibration.vibrate(duration: 500);
                                    SnackbarUtil.showSnackbar(
                                        context,
                                        state.airsideReleaseBatteryUpdateModel.statusMessage!,
                                        MyColor.colorRed,
                                        icon: FontAwesomeIcons.times);
                                  }else{
                                    getAirsideReleaseDetail(context, locationController.text, igmNoEditingController.text, _user!.userProfile!.userIdentity!, _splashDefaultData!.companyCode!, widget.menuId);
                                  }
                                }
                                else if (state is AirsideReleaseBatteryUpdateFailureState){
                                  DialogUtils.hideLoadingDialog(context);
                                  Vibration.vibrate(duration: 500);
                                  SnackbarUtil.showSnackbar(
                                      context,
                                      state.error,
                                      MyColor.colorRed,
                                      icon: FontAwesomeIcons.times);
                                }
                                else if (state is AirsideReleaseTempUpdateSuccessState){
                                  DialogUtils.hideLoadingDialog(context);
                                  if(state.airsideReleaseTempUpdateModel.status == "E"){
                                    Vibration.vibrate(duration: 500);
                                    SnackbarUtil.showSnackbar(
                                        context,
                                        state.airsideReleaseTempUpdateModel.statusMessage!,
                                        MyColor.colorRed,
                                        icon: FontAwesomeIcons.times);
                                  }else{
                                    getAirsideReleaseDetail(context, locationController.text, igmNoEditingController.text, _user!.userProfile!.userIdentity!, _splashDefaultData!.companyCode!, widget.menuId);
                                  }
                                }
                                else if (state is AirsideReleaseTempUpdateFailureState){
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
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
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
                                                  SizedBox(
                                                    height: SizeConfig.blockSizeVertical,
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
                                                            labelText: "${lableModel.door} *",
                                                            readOnly: false,
                                                            maxLength: 15,
                                                            isShowSuffixIcon: _isvalidateLocation,
                                                            onChanged: (value, validate) {

                                                              igmNoEditingController.clear();
                                                              airsideReleaseDetailList.clear();
                                                              filteredAirsideReleaseDetailList.clear();
                                                              airSideReleaseSearchModel = null;

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
                                                          labelText: "${lableModel.scan}",
                                                          readOnly: locationController.text.isNotEmpty ? false : true,
                                                          controller: igmNoEditingController,
                                                          focusNode: igmNoFocusNode,
                                                          maxLength: 30,
                                                          onChanged: (value) {
                                                            _selectedItems.clear();
                                                            _isOpenULDFlagEnable = false;
                                                            airSideReleaseSearchModel = null;
                                                            airsideReleaseDetailList.clear();
                                                            setState(() {});
                                                          },
                                                          fillColor: Colors.grey.shade100,
                                                          textInputType: TextInputType.text,
                                                          inputAction: TextInputAction.next,
                                                          hintTextcolor: Colors.black,
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
                                                      InkWell(
                                                        onTap: () {

                                                          if(locationController.text.isNotEmpty){
                                                            if(_isvalidateLocation){
                                                              if(airSideReleaseSearchModel != null){
                                                                scanQR();
                                                              }else{
                                                                igmNoEditingController.clear();
                                                                airsideReleaseDetailList.clear();
                                                                filteredAirsideReleaseDetailList.clear();
                                                                airSideReleaseSearchModel = null;
                                                                scanQR();
                                                              }

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

                                     // comment for old side detail
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
                                         child:  Column(
                                           children: [
                                             Row(children: List.generate(_tabs.length, (index) {
                                               return InkWell(
                                                 onTap: () {
                                                   if (index == 0) {
                                                     setState(() {
                                                       _pageIndex = index;

                                                     });
                                                   }
                                                   else if (index == 1) {
                                                     setState(() {
                                                       _pageIndex = index;
                                                     });
                                                   }
                                                   else if (index == 2) {
                                                     setState(() {
                                                       _pageIndex = index;
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

  Widget isViewEnable(LableModel lableModel, int pageIndex, ui.TextDirection textDirection, AppLocalizations? localizations) {
    if (pageIndex == 0) {
      return (airSideReleaseSearchModel != null)
          ? (airSideReleaseSearchModel!.airsideReleaseFlightDetail!.flightNo != null)
          ? Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  CustomeText(
                    text: "${airSideReleaseSearchModel!.airsideReleaseFlightDetail!.flightNo}",
                    fontColor: MyColor.colorBlack,
                    fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_7,
                    fontWeight: FontWeight.w800,
                    textAlign: TextAlign.start,
                  ),
                  const SizedBox(width: 5),
                  CustomeText(
                    text: " ${airSideReleaseSearchModel!.airsideReleaseFlightDetail!.flightDate!.replaceAll(" ", "-")}",
                    fontColor: MyColor.textColorGrey2,
                    fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_7,
                    fontWeight: FontWeight.w800,
                    textAlign: TextAlign.start,
                  ),
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
                            text: "${airSideReleaseSearchModel!.airsideReleaseFlightDetail!.containerCount}",
                            fontColor: MyColor.colorBlack,
                            fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_6,
                            fontWeight: FontWeight.w600,
                            textAlign: TextAlign.center),

                        CustomeText(
                            text: "${lableModel.containers}",
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
                            text: "${airSideReleaseSearchModel!.airsideReleaseFlightDetail!.palletCount}",
                            fontColor: MyColor.colorBlack,
                            fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_6,
                            fontWeight: FontWeight.w600,
                            textAlign: TextAlign.center),

                        CustomeText(
                            text: "${lableModel.pallet}",
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
                            text: "${airSideReleaseSearchModel!.airsideReleaseFlightDetail!.bulkCount}",
                            fontColor: MyColor.colorBlack,
                            fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_6,
                            fontWeight: FontWeight.w600,
                            textAlign: TextAlign.center),

                        CustomeText(
                            text: "${lableModel.bULK} / ${lableModel.trolley}",
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

          (_selectedItems.isNotEmpty) ? RoundedButtonBlue(
            focusNode: releaseAllFocusNode,
            text: "${lableModel.release}",
            press: () async {
              if (_selectedItems.isNotEmpty) {
                if(signatureRequired == "Y"){
                  var value = await Navigator.push(context, CupertinoPageRoute(
                    builder: (context) => ESignaturePage(
                      importSubMenuList: widget.importSubMenuList,
                      exportSubMenuList: widget.exportSubMenuList,
                      title: "${lableModel.esignRelease}",
                      selectedItems: _selectedItems,
                      locationCode: locationController.text,
                      flightSeqNo: airSideReleaseSearchModel!.airsideReleaseFlightDetail!.flightSeqNo!,
                      refrelCode: widget.refrelCode,
                      menuId: widget.menuId,
                      mainMenuName: widget.mainMenuName,
                      signatureList: signatureList,
                    ),));

                  if(value == "true"){
                    getAirsideReleaseDetail(context, locationController.text, igmNoEditingController.text, _user!.userProfile!.userIdentity!, _splashDefaultData!.companyCode!, widget.menuId);
                    setState(() {
                      _selectedItems.clear();
                    });
                    _resumeTimerOnInteraction();
                  }else{
                    _resumeTimerOnInteraction();
                  }
                }
                else{
                  for (var item in _selectedItems) {
                    await releaseAirsideDetail(item);
                  }

                  setState(() {
                    _selectedItems.clear();
                  });
                }
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("${lableModel.noitemselected}"),
                  ),
                );
              }
            },
          ) : SizedBox(),
          SizedBox(height: SizeConfig.blockSizeVertical,),
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
                      text: "${lableModel.showreleasepending}",
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
                    _filterList();
                  });
                },
              )
            ],
          ),
          SizedBox(height: SizeConfig.blockSizeVertical,),
          (airSideReleaseSearchModel != null)
              ? (airSideReleaseSearchModel!.airsideReleaseDetailList!.isNotEmpty)
              ? (filteredAirsideReleaseDetailList.isNotEmpty)
              ? ListView.builder(
            itemCount: (airSideReleaseSearchModel != null)
                ? filteredAirsideReleaseDetailList.length
                : 0,
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            controller: scrollController,
            itemBuilder: (context, index) {
              AirsideReleaseDetailList airSideReleaseDetail = filteredAirsideReleaseDetailList[index];

              List<String> shcCodes = airSideReleaseDetail.sHCCode!.split(',');
              final isSelected = _selectedItems.contains(airSideReleaseDetail);
              return Directionality(
                textDirection: textDirection,
                child: InkWell(
                  onTap: () {


                  },
                  onDoubleTap: () async {

                    if(airSideReleaseDetail.shipmentCount != 0){
                      var value = await Navigator.push(
                          context,
                          CupertinoPageRoute(
                              builder: (context) => AirsideShipmentListPage(
                                importSubMenuList: widget.importSubMenuList,
                                exportSubMenuList: widget.exportSubMenuList,
                                buttonRightsList: const [],
                                mainMenuName: widget.mainMenuName,
                                uldNo: airSideReleaseDetail.uLDNo!,
                                uldType: airSideReleaseDetail.uLDType!,
                                flightSeqNo: airSideReleaseSearchModel!.airsideReleaseFlightDetail!.flightSeqNo!,
                                uldSeqNo: airSideReleaseDetail.uLDSeqNo!,
                                menuId: widget.menuId,
                                location: locationController.text,
                                lableModel: lableModel,
                              )));
                      if(value == "true"){
                        _resumeTimerOnInteraction();
                        getAirsideReleaseDetail(context, locationController.text, igmNoEditingController.text, _user!.userProfile!.userIdentity!, _splashDefaultData!.companyCode!, widget.menuId);
                      }
                      else if(value == "Done"){
                        _resumeTimerOnInteraction();
                        getAirsideReleaseDetail(context, locationController.text, igmNoEditingController.text, _user!.userProfile!.userIdentity!, _splashDefaultData!.companyCode!, widget.menuId);
                      }
                    }else{
                      SnackbarUtil.showSnackbar(context, "${lableModel.noShipmentFound}", MyColor.colorRed, icon: FontAwesomeIcons.times);
                      Vibration.vibrate(duration: 500);
                    }


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
                          offset: const Offset(0, 3), // changes position of shadow
                        ),
                      ],
                    ),
                    child: DottedBorder(
                      dashPattern: const [7, 7, 7, 7],
                      strokeWidth: 1,
                      borderType: BorderType.RRect,
                      color: airSideReleaseDetail.sHCCode!.contains("DGR") ? MyColor.colorRedLight : Colors.transparent,
                      radius: const Radius.circular(8),
                      child: Container(
                        // margin: flightDetails.sHCCode!.contains("DGR") ? EdgeInsets.all(3) : EdgeInsets.all(0),
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: isSelected ? MyColor.dropdownColor : MyColor.colorWhite,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Stack(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Expanded(
                                        flex:4,
                                        child: Row(
                                          children: [
                                            SvgPicture.asset((airSideReleaseDetail.uLDType == "T") ? trolleySvg : (airSideReleaseDetail.uLDType == "P") ? palletsSvg : uldSvg, height: SizeConfig.blockSizeVertical * SizeUtils.TEXTSIZE_2_5,),
                                            SizedBox(width: 8,),
                                            ULDNumberWidget(
                                              uldNo: "${airSideReleaseDetail.uLDNo}",
                                              smallFontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                              bigFontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_8,
                                              fontColor: MyColor.textColorGrey3,
                                              uldType: airSideReleaseDetail.uLDType!,
                                            )
                                          ],
                                        )),
                                    (airSideReleaseDetail.isReleased == "N") ? Expanded(
                                      flex: 2,
                                      child: RoundedButtonBlue(text: isSelected ? "${lableModel.unselect}" : "${lableModel.select}",
                                        textSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                        verticalPadding: SizeConfig.blockSizeVertical * SizeUtils.BUTTONVERTICALSIZE /SizeUtils.HEIGHT2,
                                        press: () {

                                          setState(() {
                                            if (isSelected) {
                                              _selectedItems.remove(airSideReleaseDetail); // Deselect
                                            } else {
                                              _selectedItems.add(airSideReleaseDetail); // Select the current object
                                            }
                                          });
                                        },),
                                    ) : const SizedBox()
                                  ],
                                ),
                                airSideReleaseDetail.sHCCode!.isNotEmpty ? SizedBox(height: SizeConfig.blockSizeVertical * 0.8,) : SizedBox(),
                                Row(
                                  children: [
                                    airSideReleaseDetail.sHCCode!.isNotEmpty
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
                                airSideReleaseDetail.sHCCode!.isNotEmpty ? SizedBox(height: SizeConfig.blockSizeVertical) : SizedBox(height: SizeConfig.blockSizeVertical * 0.8,),
                                Row(
                                  children: [
                                    CustomeText(
                                      text: "${lableModel.shipment} : ",
                                      fontColor: MyColor.textColorGrey2,
                                      fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                      fontWeight: FontWeight.w400,
                                      textAlign: TextAlign.start,
                                    ),
                                    const SizedBox(width: 5),
                                    CustomeText(
                                      text: "${airSideReleaseDetail.shipmentCount}",
                                      fontColor: MyColor.colorBlack,
                                      fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                      fontWeight: FontWeight.w600,
                                      textAlign: TextAlign.start,
                                    ),
                                  ],
                                ),
                                SizedBox(height: SizeConfig.blockSizeVertical * 0.8),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    (airSideReleaseDetail.uLDType == "T") ? SizedBox() : Row(
                                      children: [
                                        CustomeText(
                                          text: "${lableModel.temp}. : ",
                                          fontColor: MyColor.textColorGrey2,
                                          fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                          fontWeight: FontWeight.w400,
                                          textAlign: TextAlign.start,
                                        ),
                                        const SizedBox(width: 5),
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                                          decoration: BoxDecoration(
                                              color: MyColor.dropdownColor,
                                              borderRadius: BorderRadius.circular(SizeConfig.blockSizeHorizontal * SizeUtils.WIDTH2)
                                          ),
                                          child: InkWell(
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                CustomeText(
                                                    text: (airSideReleaseDetail.rTemp!.isNotEmpty) ? "${airSideReleaseDetail.rTemp}\u00B0 ${airSideReleaseDetail.rTempUnit}" : "- ${airSideReleaseDetail.rTempUnit}",
                                                    fontColor: MyColor.textColorGrey3,
                                                    fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                                    fontWeight: FontWeight.w700,
                                                    textAlign: TextAlign.center),
                                                SizedBox(width: SizeConfig.blockSizeHorizontal,),
                                                SvgPicture.asset(pen, height: SizeConfig.blockSizeVertical * SizeUtils.HEIGHT_1_5,)
                                              ],
                                            ),
                                            onTap: () {
                                              openEditTempBottomDialog(
                                                  context,
                                                  airSideReleaseDetail.uLDNo!,
                                                  airSideReleaseDetail.rTemp!,
                                                  airSideReleaseDetail.rTempUnit!,
                                                  index,
                                                  airSideReleaseDetail.uLDSeqNo!,
                                                  lableModel,
                                                  textDirection);
                                            },
                                          ),
                                        ),


                                      ],
                                    ),
                                    (airSideReleaseDetail.uLDType == "T") ? SizedBox() : Row(
                                      children: [
                                        CustomeText(
                                          text: "${lableModel.battery} : ",
                                          fontColor: MyColor.textColorGrey2,
                                          fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                          fontWeight: FontWeight.w400,
                                          textAlign: TextAlign.start,
                                        ),
                                        const SizedBox(width: 5),
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                                          decoration: BoxDecoration(
                                              color: MyColor.dropdownColor,
                                              borderRadius: BorderRadius.circular(SizeConfig.blockSizeHorizontal * SizeUtils.WIDTH2)
                                          ),
                                          child: InkWell(
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                CustomeText(
                                                    text: (airSideReleaseDetail.battery != -1) ? "${airSideReleaseDetail.battery}%" : "-",
                                                    fontColor: MyColor.textColorGrey3,
                                                    fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                                    fontWeight: FontWeight.w700,
                                                    textAlign: TextAlign.center),
                                                SizedBox(width: SizeConfig.blockSizeHorizontal,),
                                                SvgPicture.asset(pen, height: SizeConfig.blockSizeVertical * SizeUtils.HEIGHT_1_5,)
                                              ],
                                            ),
                                            onTap: () {
                                              openEditBatteryBottomDialog(
                                                  context,
                                                  airSideReleaseDetail.uLDNo!,
                                                  "${airSideReleaseDetail.battery}",
                                                  index,
                                                  airSideReleaseDetail.uLDSeqNo!,
                                                  lableModel,
                                                  textDirection);
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),



                                (airSideReleaseDetail.uLDType == "T") ? const SizedBox() : SizedBox(height: SizeConfig.blockSizeVertical,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                                      decoration: BoxDecoration(
                                          color: MyColor.dropdownColor,
                                          borderRadius: BorderRadius.circular(SizeConfig.blockSizeHorizontal * SizeUtils.WIDTH2)
                                      ),
                                      child: InkWell(
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            CustomeText(
                                                text: "P - ${airSideReleaseDetail.priority}",
                                                fontColor: MyColor.textColorGrey3,
                                                fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                                fontWeight: FontWeight.w700,
                                                textAlign: TextAlign.center),
                                            SizedBox(width: SizeConfig.blockSizeHorizontal,),
                                            SvgPicture.asset(pen, height: SizeConfig.blockSizeVertical * SizeUtils.HEIGHT_1_5,)
                                          ],
                                        ),
                                        onTap: () {
                                          openEditPriorityBottomDialog(
                                              context,
                                              airSideReleaseDetail.uLDNo!,
                                              "${airSideReleaseDetail.priority}",
                                              index,
                                              airSideReleaseDetail.uLDSeqNo!,
                                              lableModel,
                                              textDirection,
                                              airSideReleaseDetail.uLDType!);
                                        },
                                      ),
                                    ),
                                    Row(
                                      children: [

                                        Container(
                                          padding : EdgeInsets.symmetric(horizontal: SizeConfig.blockSizeHorizontal * 2.5, vertical: SizeConfig.blockSizeVertical * 0.1),
                                          decoration : BoxDecoration(
                                              borderRadius: BorderRadius.circular(20),
                                              color: airSideReleaseDetail.isReleased == "Y" ? MyColor.flightFinalize : MyColor.flightNotArrived
                                          ),
                                          child: CustomeText(
                                            text: airSideReleaseDetail.isReleased == "Y" ? "${lableModel.released}" : "${lableModel.pendingrelease}",
                                            fontColor: MyColor.textColorGrey3,
                                            fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_35,
                                            fontWeight: FontWeight.w400,
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                        SizedBox(width: SizeConfig.blockSizeHorizontal * SizeUtils.WIDTH2,),

                                        InkWell(
                                          onTap: () async {

                                            if(airSideReleaseDetail.shipmentCount != 0){
                                              var value = await Navigator.push(
                                                  context,
                                                  CupertinoPageRoute(
                                                      builder: (context) => AirsideShipmentListPage(
                                                        importSubMenuList: widget.importSubMenuList,
                                                        exportSubMenuList: widget.exportSubMenuList,
                                                        buttonRightsList: const [],
                                                        mainMenuName: widget.mainMenuName,
                                                        uldNo: airSideReleaseDetail.uLDNo!,
                                                        uldType: airSideReleaseDetail.uLDType!,
                                                        flightSeqNo: airSideReleaseSearchModel!.airsideReleaseFlightDetail!.flightSeqNo!,
                                                        uldSeqNo: airSideReleaseDetail.uLDSeqNo!,
                                                        menuId: widget.menuId,
                                                        location: locationController.text,
                                                        lableModel: lableModel,
                                                      )));
                                              if(value == "true"){
                                                _resumeTimerOnInteraction();
                                                getAirsideReleaseDetail(context, locationController.text, igmNoEditingController.text, _user!.userProfile!.userIdentity!, _splashDefaultData!.companyCode!, widget.menuId);
                                              }
                                              else if(value == "Done"){
                                                _resumeTimerOnInteraction();
                                                getAirsideReleaseDetail(context, locationController.text, igmNoEditingController.text, _user!.userProfile!.userIdentity!, _splashDefaultData!.companyCode!, widget.menuId);
                                              }
                                            }else{
                                              SnackbarUtil.showSnackbar(context, "${lableModel.noShipmentFound}", MyColor.colorRed, icon: FontAwesomeIcons.times);
                                              Vibration.vibrate(duration: 500);
                                            }

                                          },
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
                                            decoration: BoxDecoration(
                                                color: MyColor.dropdownColor,
                                                borderRadius: BorderRadius.circular(SizeConfig.blockSizeHorizontal * SizeUtils.WIDTH3)
                                            ),
                                            child: Icon(Icons.navigate_next_rounded, color: MyColor.primaryColorblue, size: SizeConfig.blockSizeVertical * SizeUtils.ICONSIZE_2_5,),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                )

                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          )
              : Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: CustomeText(
                  text: (_isOpenULDFlagEnable == false) ? "${lableModel.alluldtrolleyarerelease}" : "${lableModel.recordNotFound}",
                  fontColor: MyColor.textColorGrey,
                  fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_2_0,
                  fontWeight: FontWeight.w500,
                  textAlign: TextAlign.center),
            ),
          )
              : Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: CustomeText(
                  text: "${lableModel.recordNotFound}",
                  fontColor: MyColor.textColorGrey,
                  fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_2_0,
                  fontWeight: FontWeight.w500,
                  textAlign: TextAlign.center),
            ),
          )
              : Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: CustomeText(
                  text: "${lableModel.recordNotFound}",
                  fontColor: MyColor.textColorGrey,
                  fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_2_0,
                  fontWeight: FontWeight.w500,
                  textAlign: TextAlign.center),
            ),
          )


        ],
      )
          : Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: CustomeText(
              text: "${lableModel.recordNotFound}",
              fontColor: MyColor.textColorGrey,
              fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_2_0,
              fontWeight: FontWeight.w500,
              textAlign: TextAlign.center),
        ),
      )
          : Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: CustomeText(
              text: "${lableModel.recordNotFound}",
              fontColor: MyColor.textColorGrey,
              fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_2_0,
              fontWeight: FontWeight.w500,
              textAlign: TextAlign.center),
        ),
      );
    }
    if(pageIndex == 1){
      return Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
                decoration: BoxDecoration(
                    color: MyColor.dropdownColor,
                    borderRadius: BorderRadius.circular(SizeConfig.blockSizeHorizontal * SizeUtils.WIDTH3)
                ),
                child: Icon(Icons.navigate_before_rounded, color: MyColor.primaryColorblue, size: SizeConfig.blockSizeVertical * SizeUtils.ICONSIZE3,),
              ),
              CustomeText(
                  text: "06-Jan-2025",
                  // if record not found
                  fontColor: MyColor.primaryColorblue,
                  fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_7,
                  fontWeight: FontWeight.w600,
                  textAlign: TextAlign.center),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
                decoration: BoxDecoration(
                    color: MyColor.dropdownColor,
                    borderRadius: BorderRadius.circular(SizeConfig.blockSizeHorizontal * SizeUtils.WIDTH3)
                ),
                child: Icon(Icons.navigate_next_rounded, color: MyColor.primaryColorblue, size: SizeConfig.blockSizeVertical * SizeUtils.ICONSIZE3,),
              )
            ],
          ),
          SizedBox(height: SizeConfig.blockSizeVertical),

          (flightList.isNotEmpty)
              ? GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // Number of columns
              crossAxisSpacing: 12, // Horizontal spacing between columns
              mainAxisSpacing: 2, // Vertical spacing between rows
              childAspectRatio: 3, // Aspect ratio of each grid item
            ),
            itemCount: flightList.length,
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            controller: scrollController,
            itemBuilder: (context, index) {
              String flight = flightList![index];

              return Directionality(
                textDirection: textDirection,
                child: InkWell(
                  // focusNode: uldListFocusNode,
                  onTap: () async {

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
                          offset: const Offset(0, 3), // changes position of shadow
                        ),
                      ],
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: MyColor.colorWhite,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomeText(text: flight, fontColor: MyColor.colorBlack, fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_6_5, fontWeight: FontWeight.w600, textAlign: TextAlign.start),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          )
              : Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: CustomeText(
                  text: "${lableModel.recordNotFound}",
                  // if record not found
                  fontColor: MyColor.textColorGrey,
                  fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_2_0,
                  fontWeight: FontWeight.w500,
                  textAlign: TextAlign.center),
            ),
          ),
        ],
      );
    }
    if(pageIndex == 2){
      return (uldList.isNotEmpty)
          ? GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // Number of columns
          crossAxisSpacing: 12, // Horizontal spacing between columns
          mainAxisSpacing: 2, // Vertical spacing between rows
          childAspectRatio: 3, // Aspect ratio of each grid item
        ),
        itemCount: uldList.length,
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        controller: scrollController,
        itemBuilder: (context, index) {
          String uld = uldList![index];

          return Directionality(
            textDirection: textDirection,
            child: InkWell(
              // focusNode: uldListFocusNode,
              onTap: () async {

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
                      offset: const Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: MyColor.colorWhite,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomeText(text: uld, fontColor: MyColor.colorBlack, fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_6_5, fontWeight: FontWeight.w600, textAlign: TextAlign.start),
                      CustomeText(text: "3", fontColor: MyColor.colorBlack, fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_6_5, fontWeight: FontWeight.w600, textAlign: TextAlign.start),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      )
          : Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: CustomeText(
              text: "${lableModel.recordNotFound}",
              // if record not found
              fontColor: MyColor.textColorGrey,
              fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_2_0,
              fontWeight: FontWeight.w500,
              textAlign: TextAlign.center),
        ),
      );
    }



    return const SizedBox();
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
        igmNoEditingController.clear();
        airsideReleaseDetailList.clear();
        filteredAirsideReleaseDetailList.clear();
        airSideReleaseSearchModel = null;

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

      bool specialCharAllow = CommonUtils.containsSpecialCharacters(barcodeScanResult);




      if(specialCharAllow == true){
        SnackbarUtil.showSnackbar(context, "${widget.lableModel!.onlyNumericValueMsg}", MyColor.colorRed, icon: FontAwesomeIcons.times);
        Vibration.vibrate(duration: 500);
        airsideReleaseDetailList.clear();
        filteredAirsideReleaseDetailList.clear();
        airSideReleaseSearchModel = null;
        igmNoEditingController.clear();
        _selectedItems.clear();
        WidgetsBinding.instance.addPostFrameCallback((_) {
          FocusScope.of(context).requestFocus(igmNoFocusNode);
        });
      }else{

        _selectedItems.clear();

        String result = barcodeScanResult.replaceAll(" ", "");

       /* String truncatedResult = result.length > 15
            ? result.substring(0, 15)
            : result;*/


        WidgetsBinding.instance.addPostFrameCallback((_) {
          FocusScope.of(context).requestFocus(scanBtnFocusNode);
        },
        );

        igmNoEditingController.text = result;
        getAirsideReleaseDetail(context, locationController.text, igmNoEditingController.text, _user!.userProfile!.userIdentity!, _splashDefaultData!.companyCode!, widget.menuId);
      }
    }
  }

  //
  void getAirsideReleaseDetail(
      BuildContext context,
      String locationCode,
      String scan,
      int userId,
      int companyCode,
      int menuId) {
    context.read<AirSideReleaseCubit>().getAirsideRelease(
        locationCode,
        scan,
        userId,
        companyCode,
        menuId);
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

  Future<void> openEditPriorityBottomDialog(BuildContext context, String uldNo, String priority, int index, int uldSeqNo, LableModel lableModel, ui.TextDirection textDirection, String uldType) async {
    FocusScope.of(context).unfocus();
    String? updatedPriority = await DialogUtils.showPriorityChangeBottomULDDialog(context, uldNo, priority, lableModel, textDirection);
    if (updatedPriority != null) {
      int newPriority = int.parse(updatedPriority);

      if (newPriority != 0) {
        // Call your API to update the priority in the backend
        await callPriorityApi(
            context,
            uldSeqNo,
            newPriority,
            (uldType == "T") ? "T" : "U",
            _user!.userProfile!.userIdentity!,
            _splashDefaultData!.companyCode!,
            widget.menuId);

        setState(() {
          // Update the BDPriority for the selected item
          filteredAirsideReleaseDetailList[index].priority = newPriority;

          // Sort the list based on BDPriority
          filteredAirsideReleaseDetailList.sort((a, b) => a.priority!.compareTo(b.priority!));
        });
      } else {
        Vibration.vibrate(duration: 500);
        SnackbarUtil.showSnackbar(context, "${lableModel.prioritymsg}", MyColor.colorRed, icon: FontAwesomeIcons.times);
      }
    } else {

    }
  }

  Future<void> openEditBatteryBottomDialog(BuildContext context, String uldNo, String battery, int index, int uldSeqNo, LableModel lableModel, ui.TextDirection textDirection) async {
    FocusScope.of(context).unfocus();
    String? updatedBattery = await DialogUtils.showBatteryChangeBottomULDDialog(context, uldNo, battery, lableModel, textDirection);
    if (updatedBattery != null) {
      if(updatedBattery.isNotEmpty){
        int newBattery = int.parse(updatedBattery);

        await callBatteryApi(
            context,
            uldSeqNo,
            newBattery,
            _user!.userProfile!.userIdentity!,
            _splashDefaultData!.companyCode!,
            widget.menuId);

        setState(() {
          // Update the BDPriority for the selected item
          airsideReleaseDetailList[index].battery = newBattery;
        });
      }else{
        Vibration.vibrate(duration: 500);
        SnackbarUtil.showSnackbar(context, "${lableModel.prioritymsg}", MyColor.colorRed, icon: FontAwesomeIcons.times);
      }

    } else {

    }
  }

  Future<void> openEditTempBottomDialog(BuildContext context, String uldNo, String temp, String tempUnit, int index, int uldSeqNo, LableModel lableModel, ui.TextDirection textDirection) async {
    FocusScope.of(context).unfocus();
    var result = await DialogUtils.showTempretureChangeBottomULDDialog(context, uldNo, temp, tempUnit, lableModel, textDirection);
    if (result != null) {

      if (result.containsKey('temp')) {
        String? updatedTemp = result['temp'];
        String? updatedtUnit = result['tUnit'];

        await callTempApi(
            context,
            uldSeqNo,
            updatedTemp!,
            updatedtUnit!,
            _user!.userProfile!.userIdentity!,
            _splashDefaultData!.companyCode!,
            widget.menuId);


        // Call your API to update the priority in the backend
        /* await callbdPriorityApi(
            context,
            flightCheckULDListModel!.flightDetailSummary!.flightSeqNo!,
            flightDetails.uLDId!,
            newPriority,
            _user!.userProfile!.userIdentity!,
            _splashDefaultData!.companyCode!,
            widget.menuId);*/


        setState(() {
          // Update the BDPriority for the selected item
          airsideReleaseDetailList[index].rTemp = updatedTemp;
          airsideReleaseDetailList[index].rTempUnit = updatedtUnit;
        });
      }





    } else {

    }
  }



  Future<void> releaseAirsideDetail(AirsideReleaseDetailList item) async {
    await context.read<AirSideReleaseCubit>().releaseULDorTrolley(locationController.text, item.gpNo!, 0, item.uLDSeqNo!, (item.uLDType == "T") ? "T" : "U", _user!.userProfile!.userIdentity!, _splashDefaultData!.companyCode!, widget.menuId);
  }

  // priority chnage api call function
  Future<void> callPriorityApi(
      BuildContext context,
      int seqNo,
      int priority,
      String mode,
      int userId,
      int companyCode,
      int menuId) async {
    await context.read<AirSideReleaseCubit>().airsideReleasePriorityUpdate(
        seqNo, priority, mode, userId, companyCode, menuId);
  }


  // priority chnage api call function
  Future<void> callBatteryApi(
      BuildContext context,
      int seqNo,
      int batteryStrength,
      int userId,
      int companyCode,
      int menuId) async {
    await context.read<AirSideReleaseCubit>().airsideReleaseBatteryUpdate(
        seqNo, batteryStrength, userId, companyCode, menuId);
  }

  Future<void> callTempApi(
      BuildContext context,
      int seqNo,
      String temp,
      String tempUnit,
      int userId,
      int companyCode,
      int menuId) async {
    await context.read<AirSideReleaseCubit>().airsideReleaseTempUpdate(
        seqNo, int.parse(temp), tempUnit, userId, companyCode, menuId);
  }



}




// ticker animation for DGR code blink animation
class TickerProviders extends TickerProvider {
  @override
  Ticker createTicker(onTick) => Ticker(onTick);
}
