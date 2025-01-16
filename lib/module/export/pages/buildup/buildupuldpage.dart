import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animation_progress_bar/flutter_animation_progress_bar.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:galaxy/core/mycolor.dart';
import 'package:galaxy/module/export/model/buildup/getuldtrolleysearchmodel.dart';
import 'package:galaxy/module/export/pages/buildup/buildupaddmailpage.dart';
import 'package:galaxy/module/export/pages/buildup/buildupadduldpage.dart';
import 'package:galaxy/module/export/pages/closetrolley/closetrolleypage.dart';
import 'package:galaxy/module/export/services/buildup/builduplogic/buildupcubit.dart';
import 'package:galaxy/utils/sizeutils.dart';
import 'package:galaxy/widget/customebuttons/roundbuttonblue.dart';
import 'package:galaxy/widget/customebuttons/roundbuttongreen.dart';
import 'package:galaxy/widget/custometext.dart';
import 'package:galaxy/widget/roundbutton.dart';
import 'package:galaxy/widget/uldnumberwidget.dart';
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
import '../../../../widget/customedrawer/customedrawer.dart';
import '../../../../widget/customeedittext/customeedittextwithborder.dart';
import '../../../../widget/customtextfield.dart';
import '../../../../widget/header/mainheadingwidget.dart';
import '../../../import/pages/uldacceptance/ulddamagedpage.dart';
import '../../../login/pages/signinscreenmethods.dart';
import '../../../profile/page/profilepagescreen.dart';
import '../../../splash/model/splashdefaultmodel.dart';
import '../../../onboarding/sizeconfig.dart';
import 'dart:ui' as ui;
import '../../../login/model/userlogindatamodel.dart';
import '../../../submenu/model/submenumodel.dart';
import '../../services/buildup/builduplogic/buildupstate.dart';
import '../closetrolley/scaletrolleypage.dart';
import '../closeuld/closeuldequipmentpage.dart';
import '../closeuld/closeuldpage.dart';
import '../closeuld/contouruldpage.dart';
import '../closeuld/scaleuldpage.dart';
import 'buildupaddtrolleypage.dart';
import 'buildupawbpage.dart';


class BuildUpULDPage extends StatefulWidget {
  String mainMenuName;
  String title;
  String refrelCode;
  LableModel? lableModel;
  int menuId;
  List<SubMenuName> importSubMenuList = [];
  List<SubMenuName> exportSubMenuList = [];
  int flightSeqNo;
  String flightNo;
  String flightDate;
  String offPoint;

  BuildUpULDPage(
      {super.key,
      required this.importSubMenuList,
      required this.exportSubMenuList,
      required this.title,
      required this.refrelCode,
      this.lableModel,
      required this.menuId,
      required this.mainMenuName,
      required this.flightSeqNo,
      required this.flightNo,
      required this.flightDate,
      required this.offPoint});

  @override
  State<BuildUpULDPage> createState() => _BuildUpULDPageState();
}

class _BuildUpULDPageState extends State<BuildUpULDPage>
    with SingleTickerProviderStateMixin {


  InactivityTimerManager? inactivityTimerManager;
  final SavedPrefrence savedPrefrence = SavedPrefrence();
  UserDataModel? _user;
  SplashDefaultModel? _splashDefaultData;
  final ScrollController scrollController = ScrollController();
  String isRequiredLocation = "Y";
  String isBulkLoad = "Y";


  bool _isOpenULDFlagEnable = false;



  Map<String, String>? validationMessages;


  FocusNode uldListFocusNode = FocusNode();

  late TabController _tabController;
  int _pageIndex = 0;


  late AnimationController _blinkController;
  late Animation<Color?> _colorAnimation;


  final ValueNotifier<double> _valueNotifier = ValueNotifier(0);


  final List<String> _tabs = ['ULD', 'Trolley'];

 // final List<String> shcCodeList = ["VAL", "DGR", "GEN"];

  TextEditingController locationController = TextEditingController();
  FocusNode locationFocusNode = FocusNode();
  FocusNode locationBtnFocusNode = FocusNode();

  TextEditingController carrierCodeController = TextEditingController();
  FocusNode carrierCodeFocusNode = FocusNode();



  bool _isLocationSearchBtnEnable = false;
  bool _isvalidateLocation = false;

  bool isBackPressed = false;

  GetULDTrolleySearchModel? uldTrolleyDetailModel;

  List<ULDTrolleyDetailList> uLDTrolleyDetailList = []; // Track if the back button was pressed
  List<ULDTrolleyDetailList> filteruLDTrolleyDetailList = []; // Track if the back button was pressed

  ULDTrolleyDetailList? uldTrolleyItemCheck;

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

    carrierCodeController.text = "${widget.flightNo.split(" ").first}";


    // add tabs length
    _tabController = TabController(length: 3, vsync: this);
    _tabController.animateTo(_pageIndex);

    locationFocusNode.addListener(() {
      if (!locationFocusNode.hasFocus && !isBackPressed) {
        leaveLocationFocus();
      }
    });

    locationController.addListener(_validateLocationSearchBtn);

    carrierCodeFocusNode.addListener(() {
      if (!carrierCodeFocusNode.hasFocus && !isBackPressed) {
        leaveCarrierFocus();
      }
    });

  }

  Future<void> leaveCarrierFocus() async {
    if (carrierCodeController.text.isNotEmpty) {
      if(widget.flightSeqNo == -1){
        getULDTrolleySearchList();
      }
    }else{
    }
  }


  Future<void> leaveLocationFocus() async {
    if (locationController.text.isNotEmpty) {
      if(_isvalidateLocation == false){
        //call location validation api
        await context.read<BuildUpCubit>().getValidateLocation(
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


  @override
  void dispose() {
    super.dispose();
    //all controller and focus node dispose
    inactivityTimerManager?.stopTimer(); // Stop the timer when the screen is disposed
    _blinkController.dispose();
    scrollController.dispose();


  }

  Future<void> _loadUser() async {
    final user = await savedPrefrence.getUserData();
    final splashDefaultData = await savedPrefrence.getSplashDefaultData();
    if (user != null && splashDefaultData != null) {
      setState(() {
        _user = user;
        _splashDefaultData = splashDefaultData;
      });


      getPageLoad();


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




  Future<bool> _onWillPop() async {
    FocusScope.of(context).unfocus();
    if(_pageIndex == 1){
      setState(() {
        _pageIndex = 0;
        _tabController.animateTo(0);
      });
    }else{
      isBackPressed = true;
      locationController.clear();
      _isvalidateLocation = false;
      _tabController.animateTo(0);
      _pageIndex = 0;
      Navigator.pop(context, "true");
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
                                onBack: () {
                                  FocusScope.of(context).unfocus();
                                  _onWillPop();

                                },
                                clearText: lableModel!.clear,
                                //add clear text to clear all feild
                                onClear: () {
                                  locationController.clear();
                                  _isvalidateLocation = false;
                                  _tabController.animateTo(0);
                                  _pageIndex = 0;

                                  WidgetsBinding.instance.addPostFrameCallback((_) {
                                      FocusScope.of(context).requestFocus(locationFocusNode);
                                    },
                                  );
                                  if(widget.flightSeqNo != -1){
                                    getULDTrolleySearchList();
                                  }else{
                                    carrierCodeController.clear();
                                    uldTrolleyDetailModel = null;
                                  }

                                  setState(() {});
                                },
                              ),
                            ),

                            // start api responc

                            BlocListener<BuildUpCubit, BuildUpState>(
                              listener: (context, state) async {
                                if (state is BuildUpInitialState) {
                                }
                                else if (state is BuildUpLoadingState) {
                                  // showing loading dialog in this state
                                  DialogUtils.showLoadingDialog(context, message: lableModel.loading);
                                }
                                else if (state is BuildUpDefaultPageLoadSuccessState){
                                  DialogUtils.hideLoadingDialog(context);

                                  if(state.buildUpDefaultPageLoadModel.status == "E"){
                                    Vibration.vibrate(duration: 500);
                                    SnackbarUtil.showSnackbar(context, state.buildUpDefaultPageLoadModel.statusMessage!, MyColor.colorRed, icon: FontAwesomeIcons.times);
                                  }else{
                                    isBulkLoad = state.buildUpDefaultPageLoadModel.IsBulkLoad!;
                                   //isBulkLoad = "N";

                                    if(widget.flightSeqNo != -1){
                                      getULDTrolleySearchList();
                                    }else{
                                      WidgetsBinding.instance.addPostFrameCallback((_) {
                                        FocusScope.of(context).requestFocus(carrierCodeFocusNode);
                                      },
                                      );
                                    }
                                    setState(() {

                                    });
                                  }


                                }
                                else if (state is BuildUpDefaultPageLoadFailureState){
                                  DialogUtils.hideLoadingDialog(context);
                                  Vibration.vibrate(duration: 500);
                                  SnackbarUtil.showSnackbar(context, state.error, MyColor.colorRed, icon: FontAwesomeIcons.times);
                                }
                                else if (state is GetULDTrolleySearchSuccessState){
                                  DialogUtils.hideLoadingDialog(context);
                                  if(state.getULDTrolleySearchModel.status == "E"){
                                    Vibration.vibrate(duration: 500);
                                    SnackbarUtil.showSnackbar(
                                        context,
                                        state.getULDTrolleySearchModel.statusMessage!,
                                        MyColor.colorRed,
                                        icon: FontAwesomeIcons.times);
                                  }else{

                                    uldTrolleyDetailModel = state.getULDTrolleySearchModel;
                                    uLDTrolleyDetailList = List.from(uldTrolleyDetailModel!.uLDTrolleyDetailList != null ? uldTrolleyDetailModel!.uLDTrolleyDetailList! : []);

                                    WidgetsBinding.instance.addPostFrameCallback((_) {
                                      FocusScope.of(context).requestFocus(locationFocusNode);
                                    },
                                    );

                                    _pageIndex = 0;
                                    _filterList();

                                    setState(() {

                                    });
                                  }
                                }
                                else if (state is GetULDTrolleySearchFailureState){
                                  DialogUtils.hideLoadingDialog(context);
                                  _isvalidateLocation = false;
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
                                    // DialogUtils.hideLoadingDialog(context);
                                    _isvalidateLocation = true;
                                    setState(() {});

                                    WidgetsBinding.instance.addPostFrameCallback((_) {
                                      FocusScope.of(context).requestFocus(locationBtnFocusNode);
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
                                else if (state is ULDTrolleyPrioritySuccessState){
                                  DialogUtils.hideLoadingDialog(context);
                                  _resumeTimerOnInteraction();
                                  if(state.uldTrolleyPriorityUpdateModel.status == "E"){
                                    SnackbarUtil.showSnackbar(context, state.uldTrolleyPriorityUpdateModel.statusMessage!, MyColor.colorRed, icon: FontAwesomeIcons.times);
                                    Vibration.vibrate(duration: 500);
                                  }else{
                                    SnackbarUtil.showSnackbar(context, state.uldTrolleyPriorityUpdateModel.statusMessage!, MyColor.colorGreen, icon: Icons.done);
                                    getULDTrolleySearchList();
                                  }
                                }
                                else if (state is ULDTrolleyPriorityFailureState){
                                  DialogUtils.hideLoadingDialog(context);
                                  Vibration.vibrate(duration: 500);
                                  SnackbarUtil.showSnackbar(context, state.error, MyColor.colorRed, icon: FontAwesomeIcons.times);
                                }
                                else if (state is ULDDamageConditionCodeSuccessState){
                                  DialogUtils.hideLoadingDialog(context);
                                  if(state.uldDamageModel.status == "E"){
                                    bool? damageULDCondition = await DialogUtils.damageULDExportDialog(context, "Damage ULD", state.uldDamageModel.statusMessage! , lableModel);
                                    if(damageULDCondition == true){
                                      String damageOrNot = await Navigator.push(
                                          context,
                                          CupertinoPageRoute(
                                            builder: (context) => UldDamagedPage(
                                              importSubMenuList: widget.importSubMenuList,
                                              exportSubMenuList: widget.exportSubMenuList,
                                              locationCode: locationController.text,
                                              menuId: widget.menuId,
                                              ULDNo: "${uldTrolleyItemCheck!.uLDTrolleyType} ${uldTrolleyItemCheck!.uLDTrolleyNo} ${uldTrolleyItemCheck!.uLDOwner}",
                                              ULDSeqNo: uldTrolleyItemCheck!.uLDSeqNo!,
                                              flightSeqNo: widget.flightSeqNo,
                                              groupId: "",
                                              menuCode: widget.refrelCode,
                                              isRecordView: 2,
                                              mainMenuName: widget.mainMenuName,
                                              buttonRightsList: const [],
                                            ),
                                          ));


                                      if(damageOrNot == "BUS"){
                                        getULDTrolleySearchList();
                                        _resumeTimerOnInteraction();
                                      }
                                      else if(damageOrNot == "SER"){
                                        getULDTrolleySearchList();
                                        _resumeTimerOnInteraction();
                                      }
                                      else{
                                        getULDTrolleySearchList();
                                        _resumeTimerOnInteraction();
                                      }

                                    }
                                    else{

                                    }
                                  }
                                  else{
                                    var value = await Navigator.push(context, CupertinoPageRoute(
                                        builder: (context) => BuildUpAWBListPage(
                                          importSubMenuList: widget.importSubMenuList,
                                          exportSubMenuList: widget.exportSubMenuList,
                                          title: "AWB List",
                                          refrelCode: widget.refrelCode,
                                          menuId: widget.menuId,
                                          mainMenuName: widget.mainMenuName,
                                          lableModel: lableModel,
                                          carrierCode: carrierCodeController.text,
                                          flightSeqNo: widget.flightSeqNo,
                                          uldNo: "${uldTrolleyItemCheck!.uLDTrolleyType} ${uldTrolleyItemCheck!.uLDTrolleyNo} ${uldTrolleyItemCheck!.uLDOwner}",
                                          uldSeqNo: uldTrolleyItemCheck!.uLDSeqNo!,
                                          uldType: uldTrolleyItemCheck!.type!,
                                          offPoint: widget.offPoint,
                                          dgType: uldTrolleyItemCheck!.dgType!,
                                          dgSeqNo: uldTrolleyItemCheck!.dgSeqNo!,
                                          dgReference: uldTrolleyItemCheck!.dgReference!,

                                        )));
                                    if(value == "true"){
                                      _resumeTimerOnInteraction();
                                      getULDTrolleySearchList();
                                    }
                                    else{
                                      _resumeTimerOnInteraction();
                                    }
                                  }
                                }
                                else if (state is ULDDamageConditionCodeFailureState){
                                  DialogUtils.hideLoadingDialog(context);
                                  Vibration.vibrate(duration: 500);
                                  SnackbarUtil.showSnackbar(context, state.error, MyColor.colorRed, icon: FontAwesomeIcons.times);
                                }


                            },
                              child:  Expanded(
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
                                                      (widget.flightSeqNo != -1) ? CustomeText(
                                                        text: "${widget.flightNo} / ${widget.flightDate.replaceAll(" ", "-")}",
                                                        fontColor: MyColor.textColorGrey2,
                                                        fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_6,
                                                        fontWeight: FontWeight.w600,
                                                        textAlign: TextAlign.start,
                                                      ) : SizedBox(),
                                                      (widget.flightSeqNo != -1) ? SizedBox(
                                                        height: SizeConfig.blockSizeVertical * SizeUtils.HEIGHT2,
                                                      ) : SizedBox( height: SizeConfig.blockSizeVertical ),
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
                                                                labelText: (isRequiredLocation == "Y") ? "${lableModel.scanLocation} *" : "${lableModel.scanLocation}",
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
                                                      CustomTextField(
                                                        textDirection: textDirection,
                                                        controller: carrierCodeController,
                                                        focusNode: carrierCodeFocusNode,
                                                        onPress: () {},
                                                        hasIcon: false,
                                                        hastextcolor: true,
                                                        animatedLabel: true,
                                                        needOutlineBorder: true,
                                                        labelText: "Carrier code *",
                                                        readOnly: (widget.flightSeqNo != -1) ? true : false,
                                                        maxLength: 3,
                                                        onChanged: (value) {
                                                          uldTrolleyDetailModel = null;
                                                          uLDTrolleyDetailList.clear();
                                                          filteruLDTrolleyDetailList.clear();
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
                                                      SizedBox(
                                                        height: SizeConfig.blockSizeVertical
                                                      ),
                                                      Row(
                                                        children: [
                                                          Expanded(
                                                            flex: 1,
                                                            child: RoundedButtonBlue(
                                                              text: "Build ULD",
                                                              press: () async {
                                                                _resumeTimerOnInteraction();

                                                                if(isRequiredLocation == "Y"){
                                                                  if(locationController.text.isNotEmpty){
                                                                    if(_isvalidateLocation == true){
                                                                      if(carrierCodeController.text.isNotEmpty){
                                                                        if(uldTrolleyDetailModel != null){

                                                                          var value = await Navigator.push(context, CupertinoPageRoute(
                                                                            builder: (context) => BuildUpAddULDPage(
                                                                              importSubMenuList: widget.importSubMenuList,
                                                                              exportSubMenuList: widget.exportSubMenuList,
                                                                              title: "Build ULD", refrelCode: widget.refrelCode,
                                                                              menuId: widget.menuId,
                                                                              mainMenuName: widget.mainMenuName,
                                                                              flightSeqNo: widget.flightSeqNo,
                                                                              lableModel: lableModel,
                                                                              offPoint: widget.offPoint,
                                                                            ),));
                                                                          if(value == "Done"){
                                                                            getULDTrolleySearchList();
                                                                          }else{
                                                                            _resumeTimerOnInteraction();
                                                                          }

                                                                        }
                                                                        else{
                                                                          getULDTrolleySearchList();
                                                                        }
                                                                      }
                                                                      else{
                                                                        WidgetsBinding.instance.addPostFrameCallback((_) {
                                                                          FocusScope.of(context).requestFocus(carrierCodeFocusNode);
                                                                        },
                                                                        );
                                                                        Vibration.vibrate(duration: 500);
                                                                        SnackbarUtil.showSnackbar(context, "Please enter carrier code", MyColor.colorRed, icon: FontAwesomeIcons.times);
                                                                      }
                                                                    }else{
                                                                      openValidationDialog(lableModel.validateLocation!, locationFocusNode);
                                                                    }
                                                                  }else{
                                                                    openValidationDialog(lableModel.enterLocationMsg!, locationFocusNode);
                                                                  }
                                                                }
                                                                else{
                                                                  if(carrierCodeController.text.isNotEmpty){
                                                                    if(uldTrolleyDetailModel != null){

                                                                      var value = await Navigator.push(context, CupertinoPageRoute(
                                                                        builder: (context) => BuildUpAddULDPage(
                                                                          importSubMenuList: widget.importSubMenuList,
                                                                          exportSubMenuList: widget.exportSubMenuList,
                                                                          title: "Build ULD", refrelCode: widget.refrelCode,
                                                                          menuId: widget.menuId,
                                                                          mainMenuName: widget.mainMenuName,
                                                                          flightSeqNo: widget.flightSeqNo,
                                                                          lableModel: lableModel,
                                                                          offPoint: widget.offPoint,
                                                                        ),));
                                                                      if(value == "Done"){
                                                                        getULDTrolleySearchList();
                                                                      }else{
                                                                        _resumeTimerOnInteraction();
                                                                      }

                                                                    }
                                                                    else{
                                                                      getULDTrolleySearchList();
                                                                    }
                                                                  }
                                                                  else{
                                                                    WidgetsBinding.instance.addPostFrameCallback((_) {
                                                                      FocusScope.of(context).requestFocus(carrierCodeFocusNode);
                                                                    },
                                                                    );
                                                                    Vibration.vibrate(duration: 500);
                                                                    SnackbarUtil.showSnackbar(context, "Please enter carrier code", MyColor.colorRed, icon: FontAwesomeIcons.times);
                                                                  }
                                                                }

                                                              },
                                                            ),
                                                          ),
                                                          SizedBox(width: SizeConfig.blockSizeHorizontal * SizeUtils.HEIGHT7,),
                                                          Expanded(
                                                            flex: 1,
                                                            child: RoundedButtonGreen(
                                                              color: (widget.flightSeqNo != -1) ? (isBulkLoad == "N") ? MyColor.primaryColorblue : MyColor.textColorGrey.withOpacity(0.3) : MyColor.textColorGrey.withOpacity(0.3),
                                                              text: "Build Trolley",
                                                              press: () async {
                                                                _resumeTimerOnInteraction();

                                                                if(widget.flightSeqNo != -1){

                                                                  if(isBulkLoad == "N"){
                                                                    if(isRequiredLocation == "Y"){
                                                                      if(locationController.text.isNotEmpty){
                                                                        if(_isvalidateLocation == true){
                                                                          var value =  await Navigator.push(context, CupertinoPageRoute(
                                                                            builder: (context) => BuildUpAddTrolleyPage(
                                                                              importSubMenuList: widget.importSubMenuList,
                                                                              exportSubMenuList: widget.exportSubMenuList,
                                                                              title: "Build Trolley",
                                                                              refrelCode: widget.refrelCode,
                                                                              menuId: widget.menuId,
                                                                              mainMenuName: widget.mainMenuName,
                                                                              flightSeqNo: widget.flightSeqNo,
                                                                              offPoint: widget.offPoint,
                                                                              lableModel: lableModel,
                                                                            ),));
                                                                          if(value == "Done"){
                                                                            getULDTrolleySearchList();
                                                                          }else{
                                                                            _resumeTimerOnInteraction();
                                                                          }
                                                                        }else{
                                                                          openValidationDialog(lableModel.validateLocation!, locationFocusNode);
                                                                        }
                                                                      }else{
                                                                        openValidationDialog(lableModel.enterLocationMsg!, locationFocusNode);
                                                                      }
                                                                    }
                                                                    else{
                                                                      var value =  await Navigator.push(context, CupertinoPageRoute(
                                                                        builder: (context) => BuildUpAddTrolleyPage(
                                                                          importSubMenuList: widget.importSubMenuList,
                                                                          exportSubMenuList: widget.exportSubMenuList,
                                                                          title: "Build Trolley",
                                                                          refrelCode: widget.refrelCode,
                                                                          menuId: widget.menuId,
                                                                          mainMenuName: widget.mainMenuName,
                                                                          flightSeqNo: widget.flightSeqNo,
                                                                          offPoint: widget.offPoint,
                                                                          lableModel: lableModel,
                                                                        ),));
                                                                      if(value == "Done"){
                                                                        getULDTrolleySearchList();
                                                                      }else{
                                                                        _resumeTimerOnInteraction();
                                                                      }
                                                                    }
                                                                  }else{
                                                                    Vibration.vibrate(duration: 500);
                                                                    SnackbarUtil.showSnackbar(context, "Trolley not allow", MyColor.colorRed, icon: FontAwesomeIcons.times);
                                                                  }



                                                                }else{
                                                                  Vibration.vibrate(duration: 500);
                                                                  SnackbarUtil.showSnackbar(context, "Trolley can't build without flight.", MyColor.colorRed, icon: FontAwesomeIcons.times);
                                                                }



                                                              },
                                                            ),
                                                          ),
                                                        ],
                                                      )

                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: SizeConfig.blockSizeVertical,),
                                          Padding(
                                            padding: const EdgeInsets.only(left: 10, right: 10, top: 0, bottom: 10),
                                            child: Directionality(textDirection: textDirection,
                                                child: Container(
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
                                                  child: Padding(
                                                    padding: const EdgeInsets.only(left: 12, right: 12, top: 12, bottom: 12),
                                                    child: Column(
                                                      children: [
                                                        Column(
                                                          children: [
                                                            Row(
                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                              children: [
                                                                Expanded(
                                                                  flex: 1,
                                                                  child:  Row(children: List.generate(_tabs.length, (index) {
                                                                    return InkWell(
                                                                      onTap: () {
                                                                        if (index == 0) {
                                                                          setState(() {
                                                                            _pageIndex = index;
                                                                          });
                                                                        }
                                                                        else if (index == 1) {
                                                                          if(isBulkLoad == "Y"){
                                                                            Vibration.vibrate(duration: 500);
                                                                            SnackbarUtil.showSnackbar(context, "Trolley not allow", MyColor.colorRed, icon: FontAwesomeIcons.times);
                                                                          }else{
                                                                            setState(() {
                                                                              _pageIndex = index;
                                                                            });
                                                                          }

                                                                        }

                                                                      },
                                                                      child: Container(
                                                                        padding: const EdgeInsets.only(bottom: 8),
                                                                        margin: const EdgeInsets.only(right: 35),
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
                                                                  }),),),
                                                                Expanded(
                                                                  flex: 1,
                                                                    child:  Row(
                                                                      mainAxisAlignment: MainAxisAlignment.end,
                                                                      children: [
                                                                        CustomeText(
                                                                            text: "Show All",
                                                                            fontColor: MyColor.textColorGrey2,
                                                                            fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                                                            fontWeight: FontWeight.w500,
                                                                            textAlign: TextAlign.start),
                                                                        SizedBox(width: SizeConfig.blockSizeHorizontal,),
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

                                                                            //call api //
                                                                          },
                                                                        ),
                                                                      ],
                                                                    ),)
                                                              ],
                                                            ),
                                                            SizedBox(height: SizeConfig.blockSizeVertical,),
                                                            isViewEnable(lableModel, _pageIndex, textDirection, localizations),
                                                          ],
                                                        ),

                                                      ],
                                                    ),
                                                  ),
                                                )),

                                          ),


                                        ],
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
      return Column(
        children: [

          (uldTrolleyDetailModel != null)
              ? (filteruLDTrolleyDetailList.isNotEmpty)
              ? Column(
            children: [
              ListView.builder(
                itemCount: (uldTrolleyDetailModel != null)
                    ? filteruLDTrolleyDetailList.where((item) => item.type == "U").length
                    : 0,
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                controller: scrollController,
                itemBuilder: (context, index) {

                  List<ULDTrolleyDetailList> uldList = filteruLDTrolleyDetailList.where((menu) => menu.type == "U").toList();


                  ULDTrolleyDetailList uldTrolleyItem = uldList[index];
                  List<String> shcCodes = uldTrolleyItem.sHCCode!.split(',');

                  return  InkWell(
                    focusNode: uldListFocusNode,
                    onTap: () {
                      FocusScope.of(context).unfocus();
                      setState(() {

                      });
                    },
                    onDoubleTap: () {

                      setState(() {

                      });

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
                        color: uldTrolleyItem.sHCCode!.contains("DGR") ? MyColor.colorRedLight : Colors.transparent,
                        radius: const Radius.circular(8),
                        child: Container(
                          padding: const EdgeInsets.all(8),
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
                                      ULDNumberWidget(uldNo: (uldTrolleyItem.uLDSeqNo == 0) ? "BULK" : "${uldTrolleyItem.uLDTrolleyType} ${uldTrolleyItem.uLDTrolleyNo} ${uldTrolleyItem.uLDOwner}", smallFontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5, bigFontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_9, fontColor: MyColor.textColorGrey3, uldType: (uldTrolleyItem.uLDSeqNo == 0) ? "" : "${uldTrolleyItem.type}"),
                                      SizedBox(width: SizeConfig.blockSizeHorizontal),
                                      Row(
                                        children: [
                                          Row(
                                            children: [
                                              CustomeText(
                                                text: "${lableModel.status} : ",
                                                fontColor: MyColor.textColorGrey2,
                                                fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                                fontWeight: FontWeight.w400,
                                                textAlign: TextAlign.start,
                                              ),
                                              SizedBox(width: SizeConfig.blockSizeHorizontal),
                                              Container(
                                                padding : EdgeInsets.symmetric(horizontal: SizeConfig.blockSizeHorizontal * 2.5, vertical: SizeConfig.blockSizeVertical * 0.1),
                                                decoration : BoxDecoration(
                                                    borderRadius: BorderRadius.circular(20),
                                                    color: (uldTrolleyItem.status == "O" || uldTrolleyItem.status == "R") ? MyColor.flightFinalize :MyColor.flightNotArrived
                                                ),
                                                child: CustomeText(
                                                  text: (uldTrolleyItem.status == "O" || uldTrolleyItem.status == "R") ? "Open" : "Closed",
                                                  fontColor: MyColor.textColorGrey3,
                                                  fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_35,
                                                  fontWeight: FontWeight.w400,
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),

                                    ],
                                  ),
                                  uldTrolleyItem.sHCCode!.isNotEmpty ? SizedBox(height: SizeConfig.blockSizeVertical) : SizedBox(),
                                  uldTrolleyItem.sHCCode!.isNotEmpty
                                      ? Row(
                                    children:shcCodes.asMap().entries.take(3).map((entry) {
                                      int index = entry.key; // Get the index for colorList assignment
                                      String code = entry.value.trim(); // Get the code value and trim it

                                      return Padding(
                                        padding: const EdgeInsets.only(right: 5.0),
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
                                      : const SizedBox(),
                                  SizedBox(height: SizeConfig.blockSizeVertical),
                                  Row(
                                    mainAxisAlignment: (uldTrolleyItem.uLDSeqNo != 0) ? MainAxisAlignment.spaceBetween : MainAxisAlignment.start,
                                    children: [
                                      (uldTrolleyItem.uLDSeqNo != 0)
                                          ? Row(
                                        children: [
                                          CustomeText(
                                            text: "Contour :",
                                            fontColor: MyColor.textColorGrey2,
                                            fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                            fontWeight: FontWeight.w500,
                                            textAlign: TextAlign.start,
                                          ),
                                          const SizedBox(width: 5),
                                          CustomeText(
                                            text: "${uldTrolleyItem.contourCode}",
                                            fontColor: MyColor.colorBlack,
                                            fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_6,
                                            fontWeight: FontWeight.w600,
                                            textAlign: TextAlign.start,
                                          ),
                                        ],
                                      ) : SizedBox(),
                                      Row(
                                        children: [
                                          CustomeText(
                                            text: "Scale Wt. :",
                                            fontColor: MyColor.textColorGrey2,
                                            fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                            fontWeight: FontWeight.w500,
                                            textAlign: TextAlign.start,
                                          ),
                                          const SizedBox(width: 5),
                                          CustomeText(
                                            text: "${CommonUtils.formateToTwoDecimalPlacesValue(uldTrolleyItem.scaleWt!)} Kg",
                                            fontColor: MyColor.colorBlack,
                                            fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_6,
                                            fontWeight: FontWeight.w600,
                                            textAlign: TextAlign.start,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: SizeConfig.blockSizeVertical),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                                    decoration: BoxDecoration(
                                        color: MyColor.dropdownColor,
                                        borderRadius: BorderRadius.circular(SizeConfig.blockSizeHorizontal * SizeUtils.WIDTH2)
                                    ),
                                    child: InkWell(
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          CustomeText(
                                              text: "P - ${uldTrolleyItem.priority}",
                                              fontColor: MyColor.textColorGrey3,
                                              fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                              fontWeight: FontWeight.w700,
                                              textAlign: TextAlign.center),
                                          SizedBox(width: SizeConfig.blockSizeHorizontal,),
                                          SvgPicture.asset(pen, height: SizeConfig.blockSizeVertical * SizeUtils.HEIGHT_1_5,)
                                        ],
                                      ),
                                      onTap: () {
                                        openEditPriorityBottomDialog(context, "${uldTrolleyItem.uLDTrolleyType} ${uldTrolleyItem.uLDTrolleyNo} ${uldTrolleyItem.uLDOwner}", "${uldTrolleyItem.priority!}", index, uldTrolleyItem.uLDSeqNo!, uldTrolleyItem.type!, lableModel, textDirection);
                                      },
                                    ),
                                  ),

                                  /*Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      CustomeText(
                                        text: "Remark :",
                                        fontColor: MyColor.textColorGrey2,
                                        fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                        fontWeight: FontWeight.w500,
                                        textAlign: TextAlign.start,
                                      ),
                                      const SizedBox(width: 5),
                                      Flexible(
                                        child: CustomeText(
                                          text: "${uldTrolleyItem.remark}",
                                          fontColor: MyColor.colorBlack,
                                          fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                          fontWeight: FontWeight.w600,
                                          textAlign: TextAlign.start,
                                        ),
                                      ),
                                    ],
                                  ),*/
                                  SizedBox(height: SizeConfig.blockSizeVertical),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [

                                      RoundedButton(text: "More",
                                        horizontalPadding: SizeConfig.blockSizeHorizontal * SizeUtils.HEIGHT7,
                                        verticalPadding: SizeConfig.blockSizeVertical * SizeUtils.HEIGHT_1_5,
                                        color: MyColor.primaryColorblue,
                                        press: () async {
                                          inactivityTimerManager?.stopTimer();

                                          if(isRequiredLocation == "Y"){
                                            if(locationController.text.isNotEmpty){
                                              if(_isvalidateLocation == true){
                                                if(carrierCodeController.text.isNotEmpty){

                                                  if(uldTrolleyItem.uLDSeqNo != 0){
                                                    int? optionNo = await DialogUtils.showULDMoreOptionDialog(
                                                        context, "More Option for ULD", lableModel);
                                                    if(optionNo == null){
                                                      _resumeTimerOnInteraction();
                                                    }
                                                    else if(optionNo == 1){
                                                      var value = await Navigator.push(context, CupertinoPageRoute(
                                                        builder: (context) => CloseULDEquipmentPage(
                                                          importSubMenuList: widget.importSubMenuList,
                                                          exportSubMenuList: widget.exportSubMenuList,
                                                          title: "Equipment",
                                                          refrelCode: widget.refrelCode,
                                                          menuId: widget.menuId,
                                                          mainMenuName: widget.mainMenuName,
                                                          uldNo: "${uldTrolleyItem.uLDTrolleyType} ${uldTrolleyItem.uLDTrolleyNo} ${uldTrolleyItem.uLDOwner}",
                                                          uldType: "U",
                                                          uldSeqNo: uldTrolleyItem.uLDSeqNo!,
                                                          flightSeqNo : widget.flightSeqNo,
                                                        ),));

                                                      if(value == "true"){
                                                        _resumeTimerOnInteraction();
                                                        getULDTrolleySearchList();
                                                      }else{
                                                        _resumeTimerOnInteraction();
                                                      }
                                                    }
                                                    else if(optionNo == 2){

                                                      var value = await Navigator.push(context, CupertinoPageRoute(
                                                        builder: (context) => ContourULDPage(
                                                          importSubMenuList: widget.importSubMenuList,
                                                          exportSubMenuList: widget.exportSubMenuList,
                                                          title: "Contour",
                                                          refrelCode: widget.refrelCode,
                                                          menuId: widget.menuId,
                                                          mainMenuName: widget.mainMenuName,
                                                          uldNo: "${uldTrolleyItem.uLDTrolleyType} ${uldTrolleyItem.uLDTrolleyNo} ${uldTrolleyItem.uLDOwner}",
                                                          flightSeqNo: widget.flightSeqNo,
                                                          uldSeqNo: uldTrolleyItem.uLDSeqNo!,
                                                        ),));

                                                      if(value == "true"){
                                                        _resumeTimerOnInteraction();
                                                        getULDTrolleySearchList();
                                                      }else{
                                                        _resumeTimerOnInteraction();
                                                      }

                                                    }
                                                    else if(optionNo == 3){
                                                      var value = await Navigator.push(context, CupertinoPageRoute(
                                                        builder: (context) => ScaleULDPage(
                                                          importSubMenuList: widget.importSubMenuList,
                                                          exportSubMenuList: widget.exportSubMenuList,
                                                          title: "Scale",
                                                          refrelCode: widget.refrelCode,
                                                          menuId: widget.menuId,
                                                          mainMenuName: widget.mainMenuName,
                                                          uldNo: "${uldTrolleyItem.uLDTrolleyType} ${uldTrolleyItem.uLDTrolleyNo} ${uldTrolleyItem.uLDOwner}",
                                                          flightSeqNo: widget.flightSeqNo,
                                                          uldSeqNo: uldTrolleyItem.uLDSeqNo!,
                                                        ),));

                                                      if(value == "true"){
                                                        _resumeTimerOnInteraction();
                                                        getULDTrolleySearchList();
                                                      }else{
                                                        _resumeTimerOnInteraction();
                                                      }
                                                    }
                                                    else if(optionNo == 4){
                                                      var value = await Navigator.push(
                                                          context, CupertinoPageRoute(
                                                        builder: (context) => BuildUpAddMailPage(
                                                          importSubMenuList: widget.importSubMenuList,
                                                          exportSubMenuList: widget.exportSubMenuList,
                                                          title: "Add Mail",
                                                          refrelCode: widget.refrelCode,
                                                          menuId: widget.menuId,
                                                          mainMenuName: widget.mainMenuName,
                                                          lableModel: lableModel,
                                                          flightSeqNo: widget.flightSeqNo,
                                                          uldNo: "${uldTrolleyItem.uLDTrolleyType} ${uldTrolleyItem.uLDTrolleyNo} ${uldTrolleyItem.uLDOwner}",
                                                          uldSeqNo: uldTrolleyItem.uLDSeqNo!,
                                                        ),));

                                                      if(value == "true"){
                                                        _resumeTimerOnInteraction();
                                                        getULDTrolleySearchList();
                                                      }else{
                                                        _resumeTimerOnInteraction();
                                                      }


                                                    }
                                                    else if(optionNo == 5){
                                                      var value = await Navigator.push(
                                                          context, CupertinoPageRoute(
                                                        builder: (context) => CloseULDPage(
                                                          importSubMenuList: widget.importSubMenuList,
                                                          exportSubMenuList: widget.exportSubMenuList,
                                                          title: "Close ULD",
                                                          refrelCode: widget.refrelCode,
                                                          menuId: widget.menuId,
                                                          mainMenuName: widget.mainMenuName,
                                                          uldNo: "${uldTrolleyItem.uLDTrolleyType}${uldTrolleyItem.uLDTrolleyNo}${uldTrolleyItem.uLDOwner}",
                                                        ),));

                                                      if(value == "true"){
                                                        _resumeTimerOnInteraction();
                                                        getULDTrolleySearchList();
                                                      }else{
                                                        _resumeTimerOnInteraction();
                                                      }

                                                    }
                                                    else{
                                                      _resumeTimerOnInteraction();
                                                    }
                                                  }
                                                  else{
                                                    int? optionNo = await DialogUtils.showBulkMoreOptionDialog(
                                                        context, "More Option for BULK", lableModel);
                                                    if(optionNo == null){
                                                      _resumeTimerOnInteraction();
                                                    }
                                                    else if(optionNo == 1){
                                                      var value = await Navigator.push(context, CupertinoPageRoute(
                                                        builder: (context) => ScaleULDPage(
                                                          importSubMenuList: widget.importSubMenuList,
                                                          exportSubMenuList: widget.exportSubMenuList,
                                                          title: "Scale",
                                                          refrelCode: widget.refrelCode,
                                                          menuId: widget.menuId,
                                                          mainMenuName: widget.mainMenuName,
                                                          uldNo: "${uldTrolleyItem.uLDTrolleyType} ${uldTrolleyItem.uLDTrolleyNo} ${uldTrolleyItem.uLDOwner}",
                                                          flightSeqNo: widget.flightSeqNo,
                                                          uldSeqNo: uldTrolleyItem.uLDSeqNo!,
                                                        ),));

                                                      if(value == "true"){
                                                        _resumeTimerOnInteraction();
                                                        getULDTrolleySearchList();
                                                      }else{
                                                        _resumeTimerOnInteraction();
                                                      }
                                                    }
                                                    else{
                                                      _resumeTimerOnInteraction();
                                                    }
                                                  }


                                                }
                                                else{
                                                  WidgetsBinding.instance.addPostFrameCallback((_) {
                                                    FocusScope.of(context).requestFocus(carrierCodeFocusNode);
                                                  },
                                                  );
                                                  Vibration.vibrate(duration: 500);
                                                  SnackbarUtil.showSnackbar(context, "Please enter carrier code", MyColor.colorRed, icon: FontAwesomeIcons.times);
                                                }
                                              }else{
                                                openValidationDialog(lableModel.validateLocation!, locationFocusNode);
                                              }
                                            }else{
                                              openValidationDialog(lableModel.enterLocationMsg!, locationFocusNode);
                                            }
                                          }
                                          else{
                                            if(carrierCodeController.text.isNotEmpty){
                                              if(uldTrolleyItem.uLDSeqNo != 0){
                                                int? optionNo = await DialogUtils.showULDMoreOptionDialog(
                                                    context, "More Option for ULD", lableModel);
                                                if(optionNo == null){
                                                  _resumeTimerOnInteraction();
                                                }
                                                else if(optionNo == 1){
                                                  var value = await Navigator.push(context, CupertinoPageRoute(
                                                    builder: (context) => CloseULDEquipmentPage(
                                                      importSubMenuList: widget.importSubMenuList,
                                                      exportSubMenuList: widget.exportSubMenuList,
                                                      title: "Equipment",
                                                      refrelCode: widget.refrelCode,
                                                      menuId: widget.menuId,
                                                      mainMenuName: widget.mainMenuName,
                                                      uldNo: "${uldTrolleyItem.uLDTrolleyType} ${uldTrolleyItem.uLDTrolleyNo} ${uldTrolleyItem.uLDOwner}",
                                                      uldType: "U",
                                                      uldSeqNo: uldTrolleyItem.uLDSeqNo!,
                                                      flightSeqNo : widget.flightSeqNo,
                                                    ),));

                                                  if(value == "true"){
                                                    _resumeTimerOnInteraction();
                                                    getULDTrolleySearchList();
                                                  }else{
                                                    _resumeTimerOnInteraction();
                                                  }
                                                }
                                                else if(optionNo == 2){

                                                  var value = await Navigator.push(context, CupertinoPageRoute(
                                                    builder: (context) => ContourULDPage(
                                                      importSubMenuList: widget.importSubMenuList,
                                                      exportSubMenuList: widget.exportSubMenuList,
                                                      title: "Contour",
                                                      refrelCode: widget.refrelCode,
                                                      menuId: widget.menuId,
                                                      mainMenuName: widget.mainMenuName,
                                                      uldNo: "${uldTrolleyItem.uLDTrolleyType} ${uldTrolleyItem.uLDTrolleyNo} ${uldTrolleyItem.uLDOwner}",
                                                      flightSeqNo: widget.flightSeqNo,
                                                      uldSeqNo: uldTrolleyItem.uLDSeqNo!,
                                                    ),));

                                                  if(value == "true"){
                                                    _resumeTimerOnInteraction();
                                                    getULDTrolleySearchList();
                                                  }else{
                                                    _resumeTimerOnInteraction();
                                                  }

                                                }
                                                else if(optionNo == 3){
                                                  var value = await Navigator.push(context, CupertinoPageRoute(
                                                    builder: (context) => ScaleULDPage(
                                                      importSubMenuList: widget.importSubMenuList,
                                                      exportSubMenuList: widget.exportSubMenuList,
                                                      title: "Scale",
                                                      refrelCode: widget.refrelCode,
                                                      menuId: widget.menuId,
                                                      mainMenuName: widget.mainMenuName,
                                                      uldNo: "${uldTrolleyItem.uLDTrolleyType} ${uldTrolleyItem.uLDTrolleyNo} ${uldTrolleyItem.uLDOwner}",
                                                      flightSeqNo: widget.flightSeqNo,
                                                      uldSeqNo: uldTrolleyItem.uLDSeqNo!,
                                                    ),));

                                                  if(value == "true"){
                                                    _resumeTimerOnInteraction();
                                                    getULDTrolleySearchList();
                                                  }else{
                                                    _resumeTimerOnInteraction();
                                                  }
                                                }
                                                else if(optionNo == 4){
                                                  var value = await Navigator.push(
                                                      context, CupertinoPageRoute(
                                                    builder: (context) => BuildUpAddMailPage(
                                                      importSubMenuList: widget.importSubMenuList,
                                                      exportSubMenuList: widget.exportSubMenuList,
                                                      title: "Add Mail",
                                                      refrelCode: widget.refrelCode,
                                                      menuId: widget.menuId,
                                                      mainMenuName: widget.mainMenuName,
                                                      lableModel: lableModel,
                                                      flightSeqNo: widget.flightSeqNo,
                                                      uldNo: "${uldTrolleyItem.uLDTrolleyType} ${uldTrolleyItem.uLDTrolleyNo} ${uldTrolleyItem.uLDOwner}",
                                                      uldSeqNo: uldTrolleyItem.uLDSeqNo!,
                                                    ),));

                                                  if(value == "true"){
                                                    _resumeTimerOnInteraction();
                                                    getULDTrolleySearchList();
                                                  }else{
                                                    _resumeTimerOnInteraction();
                                                  }


                                                }
                                                else if(optionNo == 5){
                                                  var value = await Navigator.push(
                                                      context, CupertinoPageRoute(
                                                    builder: (context) => CloseULDPage(
                                                      importSubMenuList: widget.importSubMenuList,
                                                      exportSubMenuList: widget.exportSubMenuList,
                                                      title: "Close ULD",
                                                      refrelCode: widget.refrelCode,
                                                      menuId: widget.menuId,
                                                      mainMenuName: widget.mainMenuName,
                                                      uldNo: "${uldTrolleyItem.uLDTrolleyType}${uldTrolleyItem.uLDTrolleyNo}${uldTrolleyItem.uLDOwner}",
                                                    ),));

                                                  if(value == "true"){
                                                    _resumeTimerOnInteraction();
                                                    getULDTrolleySearchList();
                                                  }else{
                                                    _resumeTimerOnInteraction();
                                                  }

                                                }
                                                else{
                                                  _resumeTimerOnInteraction();
                                                }
                                              }
                                              else{
                                                int? optionNo = await DialogUtils.showBulkMoreOptionDialog(
                                                    context, "More Option for BULK", lableModel);
                                                if(optionNo == null){
                                                  _resumeTimerOnInteraction();
                                                }
                                                else if(optionNo == 1){
                                                  var value = await Navigator.push(context, CupertinoPageRoute(
                                                    builder: (context) => ScaleULDPage(
                                                      importSubMenuList: widget.importSubMenuList,
                                                      exportSubMenuList: widget.exportSubMenuList,
                                                      title: "Scale",
                                                      refrelCode: widget.refrelCode,
                                                      menuId: widget.menuId,
                                                      mainMenuName: widget.mainMenuName,
                                                      uldNo: "${uldTrolleyItem.uLDTrolleyType} ${uldTrolleyItem.uLDTrolleyNo} ${uldTrolleyItem.uLDOwner}",
                                                      flightSeqNo: widget.flightSeqNo,
                                                      uldSeqNo: uldTrolleyItem.uLDSeqNo!,
                                                    ),));

                                                  if(value == "true"){
                                                    _resumeTimerOnInteraction();
                                                    getULDTrolleySearchList();
                                                  }else{
                                                    _resumeTimerOnInteraction();
                                                  }
                                                }
                                                else{
                                                  _resumeTimerOnInteraction();
                                                }
                                              }

                                            }
                                            else{
                                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                                FocusScope.of(context).requestFocus(carrierCodeFocusNode);
                                              },
                                              );
                                              Vibration.vibrate(duration: 500);
                                              SnackbarUtil.showSnackbar(context, "Please enter carrier code", MyColor.colorRed, icon: FontAwesomeIcons.times);
                                            }
                                          }






                                        },),
                                      RoundedButton(text: "Next",
                                        horizontalPadding: SizeConfig.blockSizeHorizontal * SizeUtils.HEIGHT7,
                                        verticalPadding: SizeConfig.blockSizeVertical * SizeUtils.HEIGHT_1_5,
                                        color: MyColor.primaryColorblue,
                                        press: () async {
                                          inactivityTimerManager?.stopTimer();

                                          uldTrolleyItemCheck = uldTrolleyItem;

                                          print("CHECK_DGTYPE === ${uldTrolleyItem.uLDTrolleyNo} == ${uldTrolleyItem.uLDTrolleyType} ${uldTrolleyItem.dgType}");

                                          if(isRequiredLocation == "Y"){
                                            if(locationController.text.isNotEmpty){
                                              if(_isvalidateLocation == true){
                                                if(carrierCodeController.text.isNotEmpty){

                                                  // call damage code api
                                                  callULDDamageConditionCode(uldTrolleyItem.uLDSeqNo!);

                                                }
                                                else{
                                                  WidgetsBinding.instance.addPostFrameCallback((_) {
                                                    FocusScope.of(context).requestFocus(carrierCodeFocusNode);
                                                  },
                                                  );
                                                  Vibration.vibrate(duration: 500);
                                                  SnackbarUtil.showSnackbar(context, "Please enter carrier code", MyColor.colorRed, icon: FontAwesomeIcons.times);
                                                }
                                              }else{
                                                openValidationDialog(lableModel.validateLocation!, locationFocusNode);
                                              }
                                            }else{
                                              openValidationDialog(lableModel.enterLocationMsg!, locationFocusNode);
                                            }
                                          }
                                          else{
                                            if(carrierCodeController.text.isNotEmpty){

                                              // call damage code api
                                              callULDDamageConditionCode(uldTrolleyItem.uLDSeqNo!);
                                              /*var value = await Navigator.push(context, CupertinoPageRoute(
                                                  builder: (context) => BuildUpAWBListPage(
                                                    importSubMenuList: widget.importSubMenuList,
                                                    exportSubMenuList: widget.exportSubMenuList,
                                                    title: "AWB List",
                                                    refrelCode: widget.refrelCode,
                                                    menuId: widget.menuId,
                                                    mainMenuName: widget.mainMenuName,
                                                    lableModel: lableModel,
                                                    carrierCode: carrierCodeController.text,
                                                    flightSeqNo: widget.flightSeqNo,
                                                    uldNo: "${uldTrolleyItem.uLDTrolleyType} ${uldTrolleyItem.uLDTrolleyNo} ${uldTrolleyItem.uLDOwner}",
                                                    uldSeqNo: uldTrolleyItem.uLDSeqNo!,
                                                    uldType: uldTrolleyItem.type!,
                                                    offPoint: widget.offPoint,
                                                    dgType: uldTrolleyItem.dgType!,
                                                    dgSeqNo: uldTrolleyItem.dgSeqNo!,
                                                    dgReference: uldTrolleyItem.dgReference!,

                                                  )));
                                              if(value == "true"){
                                                _resumeTimerOnInteraction();
                                                getULDTrolleySearchList();
                                              } else{
                                                _resumeTimerOnInteraction();
                                              }*/
                                            }
                                            else{
                                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                                FocusScope.of(context).requestFocus(carrierCodeFocusNode);
                                              },
                                              );
                                              Vibration.vibrate(duration: 500);
                                              SnackbarUtil.showSnackbar(context, "Please enter carrier code", MyColor.colorRed, icon: FontAwesomeIcons.times);
                                            }
                                          }





                                        },)

                                    ],
                                  ),


                                ],
                              ),

                            ],
                          ),
                        ),
                      ),
                    ),
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
          )
              : Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: Center(
                  child: CustomeText(text: "${lableModel.recordNotFound}",
                      fontColor: MyColor.textColorGrey,
                      fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_2_0,
                      fontWeight: FontWeight.w500,
                      textAlign: TextAlign.center),),
              ),

            ],
          )




        ],
      );

    }

    else if (pageIndex == 1) {
      return Column(
        children: [

          (uldTrolleyDetailModel != null)
              ? (filteruLDTrolleyDetailList.isNotEmpty)
              ? filteruLDTrolleyDetailList.where((item) => item.type == "T").isNotEmpty
              ? Column(
            children: [
              ListView.builder(
                itemCount: (uldTrolleyDetailModel != null)
                    ? filteruLDTrolleyDetailList.where((item) => item.type == "T").length
                    : 0,
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                controller: scrollController,
                itemBuilder: (context, index) {


                  List<ULDTrolleyDetailList> trolleyList = filteruLDTrolleyDetailList.where((menu) => menu.type == "T").toList();


                  ULDTrolleyDetailList uldTrolleyItem = trolleyList[index];
                  List<String> shcCodes = uldTrolleyItem.sHCCode!.split(',');

                  return  InkWell(
                    focusNode: uldListFocusNode,
                    onTap: () {
                      FocusScope.of(context).unfocus();
                      setState(() {

                      });
                    },
                    onDoubleTap: () {

                      setState(() {

                      });

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
                        color: uldTrolleyItem.sHCCode!.contains("DGR") ? MyColor.colorRedLight : Colors.transparent,
                        radius: const Radius.circular(8),
                        child: Container(
                          padding: const EdgeInsets.all(8),
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
                                      ULDNumberWidget(uldNo: "${uldTrolleyItem.uLDTrolleyType} ${uldTrolleyItem.uLDTrolleyNo} ${uldTrolleyItem.uLDOwner}", smallFontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5, bigFontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_9, fontColor: MyColor.textColorGrey3, uldType: "${uldTrolleyItem.type}"),
                                      SizedBox(width: SizeConfig.blockSizeHorizontal),
                                      Row(
                                        children: [
                                          Row(
                                            children: [
                                              CustomeText(
                                                text: "${lableModel.status} : ",
                                                fontColor: MyColor.textColorGrey2,
                                                fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                                fontWeight: FontWeight.w400,
                                                textAlign: TextAlign.start,
                                              ),
                                              SizedBox(width: SizeConfig.blockSizeHorizontal),
                                              Container(
                                                padding : EdgeInsets.symmetric(horizontal: SizeConfig.blockSizeHorizontal * 2.5, vertical: SizeConfig.blockSizeVertical * 0.1),
                                                decoration : BoxDecoration(
                                                    borderRadius: BorderRadius.circular(20),
                                                    color: (uldTrolleyItem.status == "O" || uldTrolleyItem.status == "R") ? MyColor.flightFinalize :MyColor.flightNotArrived
                                                ),
                                                child: CustomeText(
                                                  text: (uldTrolleyItem.status == "O" || uldTrolleyItem.status == "R") ? "Open" : "Closed",
                                                  fontColor: MyColor.textColorGrey3,
                                                  fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_35,
                                                  fontWeight: FontWeight.w400,
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(width: SizeConfig.blockSizeHorizontal * SizeUtils.WIDTH2),

                                          InkWell(
                                            onTap: () async {


                                            },
                                            child: Container(
                                              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
                                              decoration: BoxDecoration(
                                                  color: MyColor.dropdownColor,
                                                  borderRadius: BorderRadius.circular(SizeConfig.blockSizeHorizontal * SizeUtils.WIDTH3)
                                              ),
                                              child: Icon(Icons.navigate_next_rounded, color: MyColor.primaryColorblue, size: SizeConfig.blockSizeVertical * SizeUtils.ICONSIZE_2_5,),
                                            ),
                                          )



                                        ],
                                      ),

                                    ],
                                  ),
                                  uldTrolleyItem.sHCCode!.isNotEmpty ? SizedBox(height: SizeConfig.blockSizeVertical) : SizedBox(),
                                  uldTrolleyItem.sHCCode!.isNotEmpty
                                      ? Row(
                                    children:shcCodes.asMap().entries.take(3).map((entry) {
                                      int index = entry.key; // Get the index for colorList assignment
                                      String code = entry.value.trim(); // Get the code value and trim it

                                      return Padding(
                                        padding: const EdgeInsets.only(right: 5.0),
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
                                      : const SizedBox(),
                                  SizedBox(height: SizeConfig.blockSizeVertical),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          CustomeText(
                                            text: "Scale Wt. :",
                                            fontColor: MyColor.textColorGrey2,
                                            fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                            fontWeight: FontWeight.w500,
                                            textAlign: TextAlign.start,
                                          ),
                                          const SizedBox(width: 5),
                                          CustomeText(
                                            text: "${CommonUtils.formateToTwoDecimalPlacesValue(uldTrolleyItem.scaleWt!)} Kg",
                                            fontColor: MyColor.colorBlack,
                                            fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_6,
                                            fontWeight: FontWeight.w600,
                                            textAlign: TextAlign.start,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: SizeConfig.blockSizeVertical),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                                    decoration: BoxDecoration(
                                        color: MyColor.dropdownColor,
                                        borderRadius: BorderRadius.circular(SizeConfig.blockSizeHorizontal * SizeUtils.WIDTH2)
                                    ),
                                    child: InkWell(
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          CustomeText(
                                              text: "P - ${uldTrolleyItem.priority}",
                                              fontColor: MyColor.textColorGrey3,
                                              fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                              fontWeight: FontWeight.w700,
                                              textAlign: TextAlign.center),
                                          SizedBox(width: SizeConfig.blockSizeHorizontal,),
                                          SvgPicture.asset(pen, height: SizeConfig.blockSizeVertical * SizeUtils.HEIGHT_1_5,)
                                        ],
                                      ),
                                      onTap: () {
                                        openEditPriorityBottomDialog(context, "${uldTrolleyItem.uLDTrolleyType} ${uldTrolleyItem.uLDTrolleyNo} ${uldTrolleyItem.uLDOwner}", "${uldTrolleyItem.priority!}", index, uldTrolleyItem.uLDSeqNo!, uldTrolleyItem.type!, lableModel, textDirection);
                                      },
                                    ),
                                  ),
                                  /* Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      CustomeText(
                                        text: "Remark :",
                                        fontColor: MyColor.textColorGrey2,
                                        fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                        fontWeight: FontWeight.w500,
                                        textAlign: TextAlign.start,
                                      ),
                                      const SizedBox(width: 5),
                                      Flexible(
                                        child: CustomeText(
                                          text: "${uldTrolleyItem.remark}",
                                          fontColor: MyColor.colorBlack,
                                          fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                          fontWeight: FontWeight.w600,
                                          textAlign: TextAlign.start,
                                        ),
                                      ),
                                    ],
                                  ),*/
                                  SizedBox(height: SizeConfig.blockSizeVertical),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      RoundedButton(text: "More",
                                        horizontalPadding: SizeConfig.blockSizeHorizontal * SizeUtils.HEIGHT7,
                                        verticalPadding: SizeConfig.blockSizeVertical * SizeUtils.HEIGHT_1_5,
                                        color: MyColor.primaryColorblue,
                                        press: () async {
                                          inactivityTimerManager?.stopTimer();

                                          if(isRequiredLocation == "Y"){
                                            if(locationController.text.isNotEmpty){
                                              if(_isvalidateLocation == true){
                                                if(carrierCodeController.text.isNotEmpty){
                                                  int? optionNo = await DialogUtils.showTrolleyMoreOptionDialog(
                                                      context, "More Option for Trolley", lableModel, "O");

                                                  print("OptionNo === ${optionNo}");
                                                  if(optionNo == null){
                                                    _resumeTimerOnInteraction();
                                                  }
                                                  else if(optionNo == 1){
                                                    var value = await Navigator.push(context, CupertinoPageRoute(
                                                      builder: (context) => CloseULDEquipmentPage(
                                                        importSubMenuList: widget.importSubMenuList,
                                                        exportSubMenuList: widget.exportSubMenuList,
                                                        title: "Equipment",
                                                        refrelCode: widget.refrelCode,
                                                        menuId: widget.menuId,
                                                        mainMenuName: widget.mainMenuName,
                                                        uldNo: "${uldTrolleyItem.uLDTrolleyType} ${uldTrolleyItem.uLDTrolleyNo}",
                                                        uldType: "T",
                                                        uldSeqNo: uldTrolleyItem.uLDSeqNo!,
                                                        flightSeqNo : widget.flightSeqNo,
                                                      ),));

                                                    if(value == "true"){
                                                      _resumeTimerOnInteraction();
                                                      getULDTrolleySearchList();
                                                    }else{
                                                      _resumeTimerOnInteraction();
                                                    }
                                                  }
                                                  else if(optionNo == 2){
                                                    var value = await Navigator.push(context, CupertinoPageRoute(
                                                      builder: (context) => ScaleTrolleyPage(
                                                        importSubMenuList: widget.importSubMenuList,
                                                        exportSubMenuList: widget.exportSubMenuList,
                                                        title: "Scale",
                                                        refrelCode: widget.refrelCode,
                                                        menuId: widget.menuId,
                                                        mainMenuName: widget.mainMenuName,
                                                        uldNo: "${uldTrolleyItem.uLDTrolleyType} ${uldTrolleyItem.uLDTrolleyNo}",
                                                        flightSeqNo: widget.flightSeqNo,
                                                        uldSeqNo: uldTrolleyItem.uLDSeqNo!,
                                                      ),));
                                                    if(value == "true"){
                                                      _resumeTimerOnInteraction();
                                                      getULDTrolleySearchList();
                                                    }
                                                    else{
                                                      _resumeTimerOnInteraction();
                                                    }
                                                  }
                                                  else if(optionNo == 3){
                                                    var value = await Navigator.push(context, CupertinoPageRoute(
                                                      builder: (context) => CloseTrolleyPage(
                                                        importSubMenuList: widget.importSubMenuList,
                                                        exportSubMenuList: widget.exportSubMenuList,
                                                        title: "Close Trolley",
                                                        refrelCode: widget.refrelCode,
                                                        menuId: widget.menuId,
                                                        mainMenuName: widget.mainMenuName,
                                                        trolleyNo: "${uldTrolleyItem.uLDTrolleyType}${uldTrolleyItem.uLDTrolleyNo}",
                                                      ),));

                                                    if(value == "true"){
                                                      _resumeTimerOnInteraction();
                                                      getULDTrolleySearchList();
                                                    }else{
                                                      _resumeTimerOnInteraction();
                                                    }

                                                  }
                                                  else{
                                                    _resumeTimerOnInteraction();
                                                  }
                                                }
                                                else{
                                                  WidgetsBinding.instance.addPostFrameCallback((_) {
                                                    FocusScope.of(context).requestFocus(carrierCodeFocusNode);
                                                  },
                                                  );
                                                  Vibration.vibrate(duration: 500);
                                                  SnackbarUtil.showSnackbar(context, "Please enter carrier code", MyColor.colorRed, icon: FontAwesomeIcons.times);
                                                }
                                              }else{
                                                openValidationDialog(lableModel.validateLocation!, locationFocusNode);
                                              }
                                            }else{
                                              openValidationDialog(lableModel.enterLocationMsg!, locationFocusNode);
                                            }
                                          }
                                          else{
                                            if(carrierCodeController.text.isNotEmpty){
                                              int? optionNo = await DialogUtils.showTrolleyMoreOptionDialog(
                                                  context, "More Option for Trolley", lableModel, "O");

                                              print("OptionNo === ${optionNo}");
                                              if(optionNo == null){
                                                _resumeTimerOnInteraction();
                                              }
                                              else if(optionNo == 1){
                                                var value = await Navigator.push(context, CupertinoPageRoute(
                                                  builder: (context) => CloseULDEquipmentPage(
                                                    importSubMenuList: widget.importSubMenuList,
                                                    exportSubMenuList: widget.exportSubMenuList,
                                                    title: "Equipment",
                                                    refrelCode: widget.refrelCode,
                                                    menuId: widget.menuId,
                                                    mainMenuName: widget.mainMenuName,
                                                    uldNo: "${uldTrolleyItem.uLDTrolleyType} ${uldTrolleyItem.uLDTrolleyNo}",
                                                    uldType: "T",
                                                    uldSeqNo: uldTrolleyItem.uLDSeqNo!,
                                                    flightSeqNo : widget.flightSeqNo,
                                                  ),));

                                                if(value == "true"){
                                                  _resumeTimerOnInteraction();
                                                  getULDTrolleySearchList();
                                                }else{
                                                  _resumeTimerOnInteraction();
                                                }
                                              }
                                              else if(optionNo == 2){
                                                var value = await Navigator.push(context, CupertinoPageRoute(
                                                  builder: (context) => ScaleTrolleyPage(
                                                    importSubMenuList: widget.importSubMenuList,
                                                    exportSubMenuList: widget.exportSubMenuList,
                                                    title: "Scale",
                                                    refrelCode: widget.refrelCode,
                                                    menuId: widget.menuId,
                                                    mainMenuName: widget.mainMenuName,
                                                    uldNo: "${uldTrolleyItem.uLDTrolleyType} ${uldTrolleyItem.uLDTrolleyNo}",
                                                    flightSeqNo: widget.flightSeqNo,
                                                    uldSeqNo: uldTrolleyItem.uLDSeqNo!,
                                                  ),));
                                                if(value == "true"){
                                                  _resumeTimerOnInteraction();
                                                  getULDTrolleySearchList();
                                                }
                                                else{
                                                  _resumeTimerOnInteraction();
                                                }
                                              }
                                              else if(optionNo == 3){
                                                var value = await Navigator.push(context, CupertinoPageRoute(
                                                  builder: (context) => CloseTrolleyPage(
                                                    importSubMenuList: widget.importSubMenuList,
                                                    exportSubMenuList: widget.exportSubMenuList,
                                                    title: "Close Trolley",
                                                    refrelCode: widget.refrelCode,
                                                    menuId: widget.menuId,
                                                    mainMenuName: widget.mainMenuName,
                                                    trolleyNo: "${uldTrolleyItem.uLDTrolleyType}${uldTrolleyItem.uLDTrolleyNo}",
                                                  ),));

                                                if(value == "true"){
                                                  _resumeTimerOnInteraction();
                                                  getULDTrolleySearchList();
                                                }else{
                                                  _resumeTimerOnInteraction();
                                                }

                                              }
                                              else{
                                                _resumeTimerOnInteraction();
                                              }
                                            }
                                            else{
                                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                                FocusScope.of(context).requestFocus(carrierCodeFocusNode);
                                              },
                                              );
                                              Vibration.vibrate(duration: 500);
                                              SnackbarUtil.showSnackbar(context, "Please enter carrier code", MyColor.colorRed, icon: FontAwesomeIcons.times);
                                            }
                                          }

                                        },
                                      ),
                                      RoundedButton(text: "Next",
                                        horizontalPadding: SizeConfig.blockSizeHorizontal * SizeUtils.HEIGHT7,
                                        verticalPadding: SizeConfig.blockSizeVertical * SizeUtils.HEIGHT_1_5,
                                        color: MyColor.primaryColorblue,
                                        press: () async {
                                          inactivityTimerManager?.stopTimer();

                                          if(isRequiredLocation == "Y"){
                                            if(locationController.text.isNotEmpty){
                                              if(_isvalidateLocation == true){
                                                if(carrierCodeController.text.isNotEmpty){


                                                   var value = await Navigator.push(context, CupertinoPageRoute(
                                                      builder: (context) => BuildUpAWBListPage(
                                                        importSubMenuList: widget.importSubMenuList,
                                                        exportSubMenuList: widget.exportSubMenuList,
                                                        title: "AWB List",
                                                        refrelCode: widget.refrelCode,
                                                        menuId: widget.menuId,
                                                        mainMenuName: widget.mainMenuName,
                                                        lableModel: lableModel,
                                                        carrierCode: carrierCodeController.text,
                                                        flightSeqNo: widget.flightSeqNo,
                                                        uldNo: "${uldTrolleyItem.uLDTrolleyType} ${uldTrolleyItem.uLDTrolleyNo} ${uldTrolleyItem.uLDOwner}",
                                                        uldSeqNo: uldTrolleyItem.uLDSeqNo!,
                                                        uldType: uldTrolleyItem.type!,
                                                        offPoint: widget.offPoint,
                                                        dgType: uldTrolleyItem.dgType!,
                                                        dgSeqNo: uldTrolleyItem.dgSeqNo!,
                                                        dgReference:uldTrolleyItem.dgReference!,
                                                      )));

                                                  if(value == "true"){
                                                    _resumeTimerOnInteraction();
                                                    getULDTrolleySearchList();
                                                  }else{
                                                    _resumeTimerOnInteraction();
                                                  }


                                                }
                                                else{
                                                  WidgetsBinding.instance.addPostFrameCallback((_) {
                                                    FocusScope.of(context).requestFocus(carrierCodeFocusNode);
                                                  },
                                                  );
                                                  Vibration.vibrate(duration: 500);
                                                  SnackbarUtil.showSnackbar(context, "Please enter carrier code", MyColor.colorRed, icon: FontAwesomeIcons.times);
                                                }
                                              }else{
                                                openValidationDialog(lableModel.validateLocation!, locationFocusNode);
                                              }
                                            }else{
                                              openValidationDialog(lableModel.enterLocationMsg!, locationFocusNode);
                                            }
                                          }
                                          else{
                                            if(carrierCodeController.text.isNotEmpty){
                                              var value = await Navigator.push(context, CupertinoPageRoute(
                                                  builder: (context) => BuildUpAWBListPage(
                                                    importSubMenuList: widget.importSubMenuList,
                                                    exportSubMenuList: widget.exportSubMenuList,
                                                    title: "AWB List",
                                                    refrelCode: widget.refrelCode,
                                                    menuId: widget.menuId,
                                                    mainMenuName: widget.mainMenuName,
                                                    lableModel: lableModel,
                                                    carrierCode: carrierCodeController.text,
                                                    flightSeqNo: widget.flightSeqNo,
                                                    uldNo: "${uldTrolleyItem.uLDTrolleyType} ${uldTrolleyItem.uLDTrolleyNo} ${uldTrolleyItem.uLDOwner}",
                                                    uldSeqNo: uldTrolleyItem.uLDSeqNo!,
                                                    uldType: uldTrolleyItem.type!,
                                                    offPoint: widget.offPoint,
                                                    dgType: uldTrolleyItem.dgType!,
                                                    dgSeqNo: uldTrolleyItem.dgSeqNo!,
                                                    dgReference:uldTrolleyItem.dgReference!,
                                                  )));
                                              if(value == "true"){
                                                _resumeTimerOnInteraction();
                                                getULDTrolleySearchList();
                                              }else{
                                                _resumeTimerOnInteraction();
                                              }
                                            }
                                            else{
                                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                                FocusScope.of(context).requestFocus(carrierCodeFocusNode);
                                              },
                                              );
                                              Vibration.vibrate(duration: 500);
                                              SnackbarUtil.showSnackbar(context, "Please enter carrier code", MyColor.colorRed, icon: FontAwesomeIcons.times);
                                            }
                                          }
                                        },
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
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
          )
              : Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: Center(
              child: CustomeText(text: "${lableModel.recordNotFound}",
                  fontColor: MyColor.textColorGrey,
                  fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_2_0,
                  fontWeight: FontWeight.w500,
                  textAlign: TextAlign.center),),
          )
              : Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: Center(
                  child: CustomeText(text: "${lableModel.recordNotFound}",
                      fontColor: MyColor.textColorGrey,
                      fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_2_0,
                      fontWeight: FontWeight.w500,
                      textAlign: TextAlign.center),),
              ),

            ],
          )




        ],
      );

    }

    return const SizedBox();
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
        await context.read<BuildUpCubit>().getValidateLocation(
            locationController.text,
            _user!.userProfile!.userIdentity!,
            _splashDefaultData!.companyCode!,
            widget.menuId,
            "a");
      }

    }
  }


  // open dialog for chnage bdpriority
  Future<void> openEditPriorityBottomDialog(
      BuildContext context,
      String uldNo,
      String priority,
      int index,
      int uldSeqNo,
      String uldType,
      LableModel lableModel,
      ui.TextDirection textDirection)
  async {
    FocusScope.of(context).unfocus();
    String? updatedPriority = await DialogUtils.showPriorityChangeBottomULDDialog(context, uldNo, priority, lableModel, textDirection);
    if (updatedPriority != null) {
      int newPriority = int.parse(updatedPriority);

      if (newPriority != 0) {
        // Call your API to update the priority in the backend
        await callbdPriorityApi(
            context,
            uldSeqNo,
            newPriority,
            uldType,
            _user!.userProfile!.userIdentity!,
            _splashDefaultData!.companyCode!,
            widget.menuId);

      } else {
        Vibration.vibrate(duration: 500);
        SnackbarUtil.showSnackbar(context, "${lableModel.prioritymsg}", MyColor.colorRed, icon: FontAwesomeIcons.times);
      }
    } else {

    }
  }


  Future<void> callbdPriorityApi(
      BuildContext context,
      int uldSeqNo,
      int bdPriority,
      String uldType,
      int userId,
      int companyCode,
      int menuId) async {
    await context.read<BuildUpCubit>().getULDTrolleyPriorityUpdate(
        uldSeqNo, bdPriority, uldType, userId, companyCode, menuId);
  }

  Future<void> getPageLoad() async {
    context.read<BuildUpCubit>().getDefaultPageLoad(_user!.userProfile!.userIdentity!, _splashDefaultData!.companyCode!, widget.menuId,);
  }


  Future<void> callULDDamageConditionCode(int uldSeqNo) async {
    await context.read<BuildUpCubit>().uldDamage(
        uldSeqNo,
        _user!.userProfile!.userIdentity!,
        _splashDefaultData!.companyCode!,
        widget.menuId);
  }


  Future<void> getULDTrolleySearchList() async {
    await context.read<BuildUpCubit>().getULDTrolleySearchList(
        widget.flightSeqNo,
        carrierCodeController.text,
        _user!.userProfile!.userIdentity!,
        _splashDefaultData!.companyCode!,
        widget.menuId);
  }

  void _filterList() {

    setState(() {
      // Filter and sort the list based on the switch state
      if (!_isOpenULDFlagEnable) {
        // Filter the list to show only items where requestUser is "" or "KALE"

        filteruLDTrolleyDetailList = List.from(uLDTrolleyDetailList.where((item) => (item.status == "O" || item.status == "R")));
        filteruLDTrolleyDetailList.sort((a, b) => a.priority!.compareTo(b.priority!));


      }
      else {
        // When switch is ON, restore the full list
        filteruLDTrolleyDetailList = List.from(uLDTrolleyDetailList);
        filteruLDTrolleyDetailList.sort((a, b) => a.priority!.compareTo(b.priority!));
      }

    });
  }


}




// ticker animation for DGR code blink animation
class TickerProviders extends TickerProvider {
  @override
  Ticker createTicker(onTick) => Ticker(onTick);
}
