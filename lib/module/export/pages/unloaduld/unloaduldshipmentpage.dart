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
import '../../../../utils/awbformatenumberutils.dart';
import '../../../../utils/commonutils.dart';
import '../../../../utils/dialogutils.dart';
import '../../../../widget/customebuttons/roundbuttongreen.dart';
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
import '../../model/unloaduld/unloaduldawblistmodel.dart';
import '../../model/unloaduld/unloaduldlistmodel.dart';

class UnloadULDShipmentPage extends StatefulWidget {
  String mainMenuName;
  String title;
  String refrelCode;
  LableModel? lableModel;
  int menuId;
  List<SubMenuName> importSubMenuList = [];
  List<SubMenuName> exportSubMenuList = [];
  int uldSeqNo;
  String uldType;
  int groupIdChar;
  String groupIdRequire;
  String uldNo;
  int flightSeqNo;

  UnloadULDShipmentPage(
      {super.key,
      required this.importSubMenuList,
      required this.exportSubMenuList,
      required this.title,
      required this.refrelCode,
      this.lableModel,
      required this.menuId,
      required this.mainMenuName,
      required this.uldSeqNo,
      required this.uldType,
      required this.groupIdChar,
      required this.groupIdRequire,
      required this.uldNo,
      required this.flightSeqNo});

  @override
  State<UnloadULDShipmentPage> createState() => _UnloadULDShipmentPageState();
}

class _UnloadULDShipmentPageState extends State<UnloadULDShipmentPage> with SingleTickerProviderStateMixin{

  String clickBtn = "";

  UnloadUldAWBListModel? unloadUldAWBListModel;

  InactivityTimerManager? inactivityTimerManager;
  final SavedPrefrence savedPrefrence = SavedPrefrence();
  UserDataModel? _user;
  SplashDefaultModel? _splashDefaultData;
  final ScrollController scrollController = ScrollController();

  bool isBackPressed = false; // Track if the back button was pressed

  String awbNo = "";
  int awbShipRowId = 0;
  int EMISeqNo = 0;
  int nop = 0;
  double weight = 0;



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

    getAWBDetails();



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
    Navigator.pop(context, "Done");
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
                            BlocListener<UnloadULDCubit, UnloadULDState>(
                              listener: (context, state) async {
                                if (state is UnloadULDInitialState) {
                                }
                                else if (state is UnloadULDLoadingState) {
                                  // showing loading dialog in this state
                                  DialogUtils.showLoadingDialog(context, message: lableModel!.loading);
                                }
                                else if (state is UnloadULDAWBListSuccessState){
                                  DialogUtils.hideLoadingDialog(context);
                                  if(state.unloadUldAWBListModel.status == "E"){
                                    Vibration.vibrate(duration: 500);
                                    SnackbarUtil.showSnackbar(context, state.unloadUldAWBListModel.statusMessage!, MyColor.colorRed, icon: FontAwesomeIcons.times);
                                  } else{
                                    unloadUldAWBListModel = state.unloadUldAWBListModel;
                                    setState(() {

                                    });
                                  }
                                }
                                else if (state is UnloadULDAWBListFailureState){
                                  DialogUtils.hideLoadingDialog(context);
                                  Vibration.vibrate(duration: 500);
                                  SnackbarUtil.showSnackbar(context, state.error, MyColor.colorRed, icon: FontAwesomeIcons.times);
                                }
                                else if (state is UnloadRemoveAWBSuccessState){
                                  DialogUtils.hideLoadingDialog(context);
                                  if(state.unloadRemoveAWBModel.status == "E"){
                                    Vibration.vibrate(duration: 500);
                                    SnackbarUtil.showSnackbar(context, state.unloadRemoveAWBModel.statusMessage!, MyColor.colorRed, icon: FontAwesomeIcons.times);
                                  }else if(state.unloadRemoveAWBModel.status == "C"){
                                    bool? closeULD = await DialogUtils.closeUnloadULDDialog(context, widget.uldNo, (widget.uldType == "U") ? "Closed ULD" : "Closed Trolley", (widget.uldType == "U") ? "ULD is closed. Do you want to open ?" : "Trolley is closed. Do you want to open ?" , lableModel!);

                                    if(closeULD == true){
                                      // call close to open api
                                      await context.read<UnloadULDCubit>().unloadOpenULDLoadA(
                                          widget.uldSeqNo,
                                          widget.uldType,
                                          _user!.userProfile!.userIdentity!,
                                          _splashDefaultData!.companyCode!,
                                          widget.menuId);

                                    }else{
                                      _resumeTimerOnInteraction();
                                    }

                                  } else{
                                    getAWBDetails();
                                  }
                                }
                                else if (state is UnloadRemoveAWBFailureState){
                                  DialogUtils.hideLoadingDialog(context);
                                  Vibration.vibrate(duration: 500);
                                  SnackbarUtil.showSnackbar(context, state.error, MyColor.colorRed, icon: FontAwesomeIcons.times);
                                }
                                else if (state is UnloadOpenULDSuccessStateA){
                                  DialogUtils.hideLoadingDialog(context);
                                  if(state.unloadUldCloseModel.status == "E"){

                                  }
                                  else{
                                    if(clickBtn == "B"){
                                      if(widget.groupIdRequire == "Y"){
                                        var result = await DialogUtils.showRemoveShipmentDialog(
                                            context,
                                            widget.flightSeqNo,
                                            widget.uldType,
                                            widget.uldSeqNo,
                                            EMISeqNo,
                                            awbShipRowId,
                                            nop,
                                            weight,
                                            widget.groupIdChar,
                                            widget.groupIdRequire,
                                            lableModel!,
                                            textDirection,
                                            _user!.userProfile!.userIdentity!,
                                            _splashDefaultData!.companyCode!,
                                            widget.menuId,
                                            "${lableModel.removeShipment}",
                                            "${lableModel.removeforthisawbmsg} ${AwbFormateNumberUtils.formatAWBNumber(awbNo)}",
                                            "B");
                                        if (result != null) {
                                          if (result.containsKey('status')) {
                                            String? status = result['status'];
                                            if(status == "N"){
                                              _resumeTimerOnInteraction();
                                            }else if(status == "D"){
                                              _resumeTimerOnInteraction();
                                              getAWBDetails();
                                            }else if (status == "C"){
                                              bool? closeULD = await DialogUtils.closeUnloadULDDialog(context, widget.uldNo, (widget.uldType == "U") ? "Closed ULD" : "Closed Trolley", (widget.uldType == "U") ? "ULD is closed. Do you want to open ?" : "Trolley is closed. Do you want to open ?" , lableModel);
                                              if(closeULD == true){
                                                // call close to open api
                                                await context.read<UnloadULDCubit>().unloadOpenULDLoadA(
                                                    widget.uldSeqNo,
                                                    widget.uldType,
                                                    _user!.userProfile!.userIdentity!,
                                                    _splashDefaultData!.companyCode!,
                                                    widget.menuId);

                                              }else{
                                                _resumeTimerOnInteraction();
                                              }
                                            }else{
                                              _resumeTimerOnInteraction();
                                            }
                                          }else{
                                            _resumeTimerOnInteraction();
                                          }
                                        }
                                        else{
                                          _resumeTimerOnInteraction();
                                        }
                                      }
                                      else{
                                        bool? removeShipment = await DialogUtils.unlodeRemoveShipmentDialog(
                                            context,
                                            "${widget.lableModel!.removeShipment}",
                                            "${lableModel!.removeforthisawbmsg} ${AwbFormateNumberUtils.formatAWBNumber(awbNo)}"
                                            ,lableModel);
                                        if(removeShipment == true){
                                          context.read<UnloadULDCubit>().unloadRemoveAWBLoad(
                                              widget.flightSeqNo,
                                              "${widget.uldType}_${widget.uldSeqNo}_${EMISeqNo}_${awbShipRowId}",
                                              nop,
                                              weight, "", "" , _user!.userProfile!.userIdentity!, _splashDefaultData!.companyCode!,  widget.menuId);
                                        }else{
                                          _resumeTimerOnInteraction();
                                        }
                                      }
                                    }
                                    else if(clickBtn == "A"){
                                      var result = await DialogUtils.showRemoveShipmentDialog(
                                          context,
                                          widget.flightSeqNo,
                                          widget.uldType,
                                          widget.uldSeqNo,
                                          EMISeqNo,
                                          awbShipRowId,
                                          nop,
                                          weight,
                                          widget.groupIdChar,
                                          widget.groupIdRequire,
                                          lableModel!,
                                          textDirection,
                                          _user!.userProfile!.userIdentity!,
                                          _splashDefaultData!.companyCode!,
                                          widget.menuId,
                                          "${lableModel.removeShipment}",
                                          "${lableModel.removeforthisawbmsg} ${AwbFormateNumberUtils.formatAWBNumber(awbNo)}",
                                          "A");
                                      if (result != null) {
                                        if (result.containsKey('status')) {
                                          String? status = result['status'];
                                          if(status == "N"){
                                            _resumeTimerOnInteraction();
                                          }else if(status == "D"){
                                            _resumeTimerOnInteraction();
                                            getAWBDetails();
                                          }else if(status == "C"){
                                            bool? closeULD = await DialogUtils.closeUnloadULDDialog(context, widget.uldNo, (widget.uldType == "U") ? "Closed ULD" : "Closed Trolley", (widget.uldType == "U") ? "ULD is closed. Do you want to open ?" : "Trolley is closed. Do you want to open ?" , lableModel);
                                            if(closeULD == true){
                                              // call close to open api
                                              await context.read<UnloadULDCubit>().unloadOpenULDLoadA(
                                                  widget.uldSeqNo,
                                                  widget.uldType,
                                                  _user!.userProfile!.userIdentity!,
                                                  _splashDefaultData!.companyCode!,
                                                  widget.menuId);

                                            }else{
                                              _resumeTimerOnInteraction();
                                            }
                                          }else{
                                            _resumeTimerOnInteraction();
                                          }
                                        }else{
                                          _resumeTimerOnInteraction();
                                        }
                                      }
                                      else{
                                        _resumeTimerOnInteraction();
                                      }
                                    }
                                  }

                                }
                                else if (state is UnloadOpenULDFailureStateA){
                                  DialogUtils.hideLoadingDialog(context);
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
                                                child: (unloadUldAWBListModel != null)
                                                    ? (unloadUldAWBListModel!.unloadAWBDetail!.isNotEmpty) ? Column(
                                                  children: [

                                                    ListView.builder(
                                                      itemCount: (unloadUldAWBListModel != null)
                                                          ? unloadUldAWBListModel!.unloadAWBDetail!.length
                                                          : 0,
                                                      physics: NeverScrollableScrollPhysics(),
                                                      shrinkWrap: true,
                                                      controller: scrollController,
                                                      itemBuilder: (context, index) {
                                                        UnloadAWBDetail unloadAWBDetail =  unloadUldAWBListModel!.unloadAWBDetail![index];
                                                        List<String> shcCodes = unloadAWBDetail.sHCCode!.split(',');

                                                        return InkWell(
                                                            onTap: () {

                                                            },
                                                            onDoubleTap: () async {

                                                            },
                                                            child: DottedBorder(
                                                              dashPattern: const [7, 7, 7, 7],
                                                              strokeWidth: 1,
                                                              borderType: BorderType.RRect,
                                                              color: unloadAWBDetail.sHCCode!.contains("DGR") ? MyColor.colorRedLight : Colors.transparent,
                                                              radius: const Radius.circular(8),
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
                                                                              crossAxisAlignment: CrossAxisAlignment.center,
                                                                              children: [
                                                                                Expanded(
                                                                                    flex : 4,
                                                                                    child: CustomeText(text: AwbFormateNumberUtils.formatAWBNumber(unloadAWBDetail.aWBNo!), fontColor: MyColor.colorBlack, fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_8, fontWeight: FontWeight.bold, textAlign: TextAlign.start)),
                                                                                Expanded(
                                                                                  flex : 2,
                                                                                  child: RoundedButtonGreen(
                                                                                    verticalPadding: SizeConfig.blockSizeVertical * SizeUtils.TEXTSIZE_1_2,
                                                                                    color: MyColor.colorRed,
                                                                                    textSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_7,
                                                                                    text: "${lableModel!.remove}",
                                                                                    press: () async {

                                                                                      clickBtn = "B";
                                                                                      awbNo = unloadAWBDetail.aWBNo!;
                                                                                      awbShipRowId = unloadAWBDetail.expShipRowId!;
                                                                                      EMISeqNo = unloadAWBDetail.EMISeqNo!;
                                                                                      nop = unloadAWBDetail.nOP!;
                                                                                      weight = unloadAWBDetail.weightKg!;


                                                                                      if(widget.groupIdRequire == "Y"){
                                                                                        var result = await DialogUtils.showRemoveShipmentDialog(
                                                                                            context,
                                                                                            widget.flightSeqNo,
                                                                                            widget.uldType,
                                                                                            widget.uldSeqNo,
                                                                                            unloadAWBDetail.EMISeqNo!,
                                                                                            unloadAWBDetail.expShipRowId!,
                                                                                          unloadAWBDetail.nOP!,
                                                                                          unloadAWBDetail.weightKg!,
                                                                                          widget.groupIdChar,
                                                                                          widget.groupIdRequire,
                                                                                          lableModel!,
                                                                                          textDirection,
                                                                                          _user!.userProfile!.userIdentity!,
                                                                                          _splashDefaultData!.companyCode!,
                                                                                          widget.menuId,
                                                                                          "${lableModel.removeShipment}",
                                                                                          "${lableModel.removeforthisawbmsg} ${AwbFormateNumberUtils.formatAWBNumber(unloadAWBDetail.aWBNo!)}",
                                                                                          "B");
                                                                                        if (result != null) {
                                                                                          if (result.containsKey('status')) {
                                                                                            String? status = result['status'];
                                                                                            if(status == "N"){
                                                                                              _resumeTimerOnInteraction();
                                                                                            }else if(status == "D"){
                                                                                              _resumeTimerOnInteraction();
                                                                                              getAWBDetails();
                                                                                            }else if (status == "C"){
                                                                                              bool? closeULD = await DialogUtils.closeUnloadULDDialog(context, widget.uldNo, (widget.uldType == "U") ? "Closed ULD" : "Closed Trolley", (widget.uldType == "U") ? "ULD is closed. Do you want to open ?" : "Trolley is closed. Do you want to open ?" , lableModel);
                                                                                              if(closeULD == true){
                                                                                                // call close to open api
                                                                                                await context.read<UnloadULDCubit>().unloadOpenULDLoadA(
                                                                                                    widget.uldSeqNo,
                                                                                                    widget.uldType,
                                                                                                    _user!.userProfile!.userIdentity!,
                                                                                                    _splashDefaultData!.companyCode!,
                                                                                                    widget.menuId);

                                                                                              }else{
                                                                                                _resumeTimerOnInteraction();
                                                                                              }
                                                                                            }else{
                                                                                              _resumeTimerOnInteraction();
                                                                                            }
                                                                                          }else{
                                                                                            _resumeTimerOnInteraction();
                                                                                          }
                                                                                        }
                                                                                        else{
                                                                                          _resumeTimerOnInteraction();
                                                                                        }
                                                                                      }
                                                                                      else{
                                                                                        bool? removeShipment = await DialogUtils.unlodeRemoveShipmentDialog(context,
                                                                                            "${lableModel.removeShipment}",
                                                                                            "${lableModel.removeforthisawbmsg} ${AwbFormateNumberUtils.formatAWBNumber(unloadAWBDetail.aWBNo!)}",
                                                                                            lableModel);
                                                                                        if(removeShipment == true){
                                                                                          context.read<UnloadULDCubit>().unloadRemoveAWBLoad(widget.flightSeqNo,
                                                                                              "${widget.uldType}_${widget.uldSeqNo}_${EMISeqNo}_${awbShipRowId}", unloadAWBDetail.nOP!, unloadAWBDetail.weightKg!, "", "" , _user!.userProfile!.userIdentity!, _splashDefaultData!.companyCode!,  widget.menuId);
                                                                                        }else{
                                                                                          _resumeTimerOnInteraction();
                                                                                        }
                                                                                      }

                                                                                    },
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                            unloadAWBDetail.sHCCode!.isNotEmpty ? SizedBox(height: SizeConfig.blockSizeVertical) : SizedBox(height: SizeConfig.blockSizeVertical * SizeUtils.HEIGHT2),
                                                                            unloadAWBDetail.sHCCode!.isNotEmpty
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

                                                                            SizedBox(height: SizeConfig.blockSizeVertical * 0.8),
                                                                            Row(
                                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                              children: [
                                                                                Row(
                                                                                  children: [
                                                                                    CustomeText(
                                                                                      text: "${lableModel.nop} : ",
                                                                                      fontColor: MyColor.textColorGrey2,
                                                                                      fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_6,
                                                                                      fontWeight: FontWeight.w400,
                                                                                      textAlign: TextAlign.start,
                                                                                    ),
                                                                                    const SizedBox(width: 5),
                                                                                    CustomeText(
                                                                                      text: "${unloadAWBDetail.nOP}",
                                                                                      fontColor: MyColor.colorBlack,
                                                                                      fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_7,
                                                                                      fontWeight: FontWeight.w600,
                                                                                      textAlign: TextAlign.start,
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                                Row(
                                                                                  children: [
                                                                                    CustomeText(
                                                                                      text: "${lableModel.weight} : ",
                                                                                      fontColor: MyColor.textColorGrey2,
                                                                                      fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_6,
                                                                                      fontWeight: FontWeight.w400,
                                                                                      textAlign: TextAlign.start,
                                                                                    ),
                                                                                    const SizedBox(width: 5),
                                                                                    CustomeText(
                                                                                      text: "${unloadAWBDetail.weightKg}",
                                                                                      fontColor: MyColor.colorBlack,
                                                                                      fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_7,
                                                                                      fontWeight: FontWeight.w600,
                                                                                      textAlign: TextAlign.start,
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                                InkWell(
                                                                                  onTap: () async {

                                                                                    clickBtn = "A";

                                                                                    awbNo = unloadAWBDetail.aWBNo!;
                                                                                    awbShipRowId = unloadAWBDetail.expShipRowId!;
                                                                                    EMISeqNo = unloadAWBDetail.EMISeqNo!;
                                                                                    nop = unloadAWBDetail.nOP!;
                                                                                    weight = unloadAWBDetail.weightKg!;

                                                                                    var result = await DialogUtils.showRemoveShipmentDialog(
                                                                                        context,
                                                                                        widget.flightSeqNo,
                                                                                        widget.uldType,
                                                                                        widget.uldSeqNo,
                                                                                        unloadAWBDetail.EMISeqNo!,
                                                                                        unloadAWBDetail.expShipRowId!,
                                                                                        unloadAWBDetail.nOP!,
                                                                                        unloadAWBDetail.weightKg!,
                                                                                        widget.groupIdChar,
                                                                                        widget.groupIdRequire,
                                                                                        lableModel,
                                                                                        textDirection,
                                                                                        _user!.userProfile!.userIdentity!,
                                                                                        _splashDefaultData!.companyCode!,
                                                                                        widget.menuId,
                                                                                        "${lableModel.removeShipment}",
                                                                                        "${lableModel.removeforthisawbmsg} ${AwbFormateNumberUtils.formatAWBNumber(unloadAWBDetail.aWBNo!)}",
                                                                                        "A");
                                                                                    if (result != null) {
                                                                                      if (result.containsKey('status')) {
                                                                                        String? status = result['status'];
                                                                                        if(status == "N"){
                                                                                          _resumeTimerOnInteraction();
                                                                                        }else if(status == "D"){
                                                                                          _resumeTimerOnInteraction();
                                                                                          getAWBDetails();
                                                                                        }else if(status == "C"){
                                                                                          bool? closeULD = await DialogUtils.closeUnloadULDDialog(context, widget.uldNo, (widget.uldType == "U") ? "Closed ULD" : "Closed Trolley", (widget.uldType == "U") ? "ULD is closed. Do you want to open ?" : "Trolley is closed. Do you want to open ?" , lableModel);
                                                                                          if(closeULD == true){
                                                                                            // call close to open api
                                                                                            await context.read<UnloadULDCubit>().unloadOpenULDLoadA(
                                                                                                widget.uldSeqNo,
                                                                                                widget.uldType,
                                                                                                _user!.userProfile!.userIdentity!,
                                                                                                _splashDefaultData!.companyCode!,
                                                                                                widget.menuId);

                                                                                          }else{
                                                                                            _resumeTimerOnInteraction();
                                                                                          }
                                                                                        }else{
                                                                                          _resumeTimerOnInteraction();
                                                                                        }
                                                                                      }else{
                                                                                        _resumeTimerOnInteraction();
                                                                                      }
                                                                                    }
                                                                                    else{
                                                                                      _resumeTimerOnInteraction();
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
                                                                            )
                                                                          ],
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  )
                                                              ),
                                                            )
                                                        );
                                                      },
                                                    ),
                                                  ],
                                                )
                                                    : Padding(
                                                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                                                  child: Center(
                                                    child: CustomeText(text: "${lableModel!.recordNotFound}", fontColor:
                                                    MyColor.textColorGrey,
                                                        fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_2_0,
                                                        fontWeight: FontWeight.w500,
                                                        textAlign: TextAlign.center),),
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

  Future<void> getAWBDetails() async {
    await context.read<UnloadULDCubit>().unloadULDAWBlistLoad(
        widget.uldSeqNo,
        widget.uldType,
        _user!.userProfile!.userIdentity!,
        _splashDefaultData!.companyCode!,
        widget.menuId);
  }

}

class TickerProviders extends TickerProvider {
  @override
  Ticker createTicker(onTick) => Ticker(onTick);
}

