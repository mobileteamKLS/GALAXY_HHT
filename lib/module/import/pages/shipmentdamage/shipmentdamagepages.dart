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
import 'package:galaxy/module/import/services/shipmentdamage/shipmentdamagelogic/shipmentdamagecubit.dart';
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
import '../../model/shipmentdamage/shipmentdamagelistmodel.dart';
import '../../services/binning/binninglogic/binningcubit.dart';
import '../../services/binning/binninglogic/binningstate.dart';
import '../../services/shipmentdamage/shipmentdamagelogic/shipmentdamagestate.dart';
import '../flightcheck/damageshipment/damageshipment.dart';

class ShipmentDamagePages extends StatefulWidget {
  String mainMenuName;
  String title;
  String refrelCode;
  LableModel? lableModel;
  int menuId;
  List<SubMenuName> importSubMenuList = [];
  List<SubMenuName> exportSubMenuList = [];

  ShipmentDamagePages(
      {super.key,
      required this.importSubMenuList,
      required this.exportSubMenuList,
      required this.title,
      required this.refrelCode,
      this.lableModel,
      required this.menuId,
      required this.mainMenuName});

  @override
  State<ShipmentDamagePages> createState() => _ShipmentDamagePagesState();
}

class _ShipmentDamagePagesState extends State<ShipmentDamagePages> with SingleTickerProviderStateMixin{
  int groupIDCharSize = 1;
  String isGroupIDRequired = "";
  String searchByGroupOrAWB = "G";

  InactivityTimerManager? inactivityTimerManager;
  final SavedPrefrence savedPrefrence = SavedPrefrence();
  UserDataModel? _user;
  SplashDefaultModel? _splashDefaultData;
  final ScrollController scrollController = ScrollController();

  TextEditingController groupIdController = TextEditingController();

  FocusNode groupIdFocusNode = FocusNode();
  FocusNode itemFocusNode = FocusNode();



  bool isBackPressed = false; // Track if the back button was pressed

  ShipmentDamageListModel? shipmentDamageListModel;


  int? _selectedIndex = -1;

  int? _isExpandedDetails;


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


    groupIdFocusNode.addListener(() {
      if (!groupIdFocusNode.hasFocus && !isBackPressed) {
        leaveGroupIdFocus();
      }
    });



  }



  Future<void> leaveGroupIdFocus() async {

    // Skip the focus leave logic if inactivity dialog is open
    if (isInactivityDialogOpen) return;

    if (groupIdController.text.isNotEmpty) {

      if(searchByGroupOrAWB == "G"){
        if (groupIdController.text.length != groupIDCharSize) {
          openValidationDialog(CommonUtils.formatMessage("${widget.lableModel!.groupIdCharSizeMsg}", ["$groupIDCharSize"]), groupIdFocusNode);
          return;
        }
      }else{
        if (groupIdController.text.length != 11) {
          openValidationDialog(CommonUtils.formatMessage(widget.lableModel!.awbCharSizeMsg!, ["11"]), groupIdFocusNode);
          return;
        }
      }


      // call shipment damage details api
      await context.read<ShipmentDamageCubit>().getShipmentDamageDetailListApi(
          groupIdController.text,
          searchByGroupOrAWB,
          _user!.userProfile!.userIdentity!,
          _splashDefaultData!.companyCode!,
          widget.menuId);
    }else{
      FocusScope.of(context).requestFocus(groupIdFocusNode);
      SnackbarUtil.showSnackbar(context, (searchByGroupOrAWB == "G") ? widget.lableModel!.enterGropIdMsg! : "${widget.lableModel!.enterAWBMsg}", MyColor.colorRed, icon: FontAwesomeIcons.times);
      shipmentDamageListModel = null;
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
    itemFocusNode.unfocus();
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
                      itemFocusNode.unfocus();
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
                                  shipmentDamageListModel = null;
                                  groupIdController.clear();
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
                                if (state is MainInitialState) {}
                                else if (state is MainLoadingState) {
                                  // showing loading dialog in this state
                                  DialogUtils.showLoadingDialog(context, message: lableModel.loading);
                                }
                                else if(state is BinningPageLoadDefaultSuccessState){
                                  DialogUtils.hideLoadingDialog(context);
                                  if(state.binningPageLoadDefaultModel.status == "E"){
                                    _onWillPop();
                                  }else{
                                    groupIDCharSize = state.binningPageLoadDefaultModel.IsGroupBasedAcceptNumber!;
                                    isGroupIDRequired = state.binningPageLoadDefaultModel.IsGroupBasedAcceptChar!;
                                    setState(() {

                                    });
                                    WidgetsBinding.instance.addPostFrameCallback((_) {
                                      FocusScope.of(context).requestFocus(groupIdFocusNode);
                                    },
                                    );
                                  }
                                }
                              },
                              child : BlocListener<ShipmentDamageCubit, ShipmentDamageState>(
                                listener: (context, state) async {
                                  if(state is ShipmentDamageInitialState){

                                  }else if(state is ShipmentDamageLoadingState){
                                    DialogUtils.showLoadingDialog(context, message: lableModel.loading);
                                  }
                                  else if(state is ShipmentDamageListSuccessState){
                                    DialogUtils.hideLoadingDialog(context);

                                    if(state.shipmentDamageListModel.status == "E"){
                                      shipmentDamageListModel = null;
                                      WidgetsBinding.instance.addPostFrameCallback((_) {
                                        FocusScope.of(context).requestFocus(groupIdFocusNode);
                                      },
                                      );
                                      setState(() {

                                      });
                                      SnackbarUtil.showSnackbar(context, state.shipmentDamageListModel.statusMessage!, MyColor.colorRed, icon: FontAwesomeIcons.times);
                                      Vibration.vibrate(duration: 500);
                                    }
                                    else{

                                      if(state.shipmentDamageListModel.damageDetailList == null){
                                        shipmentDamageListModel = null;
                                        WidgetsBinding.instance.addPostFrameCallback((_) {
                                          FocusScope.of(context).requestFocus(groupIdFocusNode);
                                        },
                                        );
                                        SnackbarUtil.showSnackbar(context, "${widget.lableModel!.recordNotFound}", MyColor.colorRed, icon: FontAwesomeIcons.times);
                                        Vibration.vibrate(duration: 500);
                                      }else{
                                        shipmentDamageListModel = state.shipmentDamageListModel;
                                        _resumeTimerOnInteraction();
                                        WidgetsBinding.instance.addPostFrameCallback((_) {
                                          FocusScope.of(context).requestFocus(itemFocusNode);
                                        },
                                        );
                                        setState(() {

                                        });
                                      }


                                    }

                                  }
                                  else if(state is ShipmentDamageListFailureState){
                                    DialogUtils.hideLoadingDialog(context);
                                    SnackbarUtil.showSnackbar(context, state.error, MyColor.colorRed, icon: FontAwesomeIcons.times);
                                    Vibration.vibrate(duration: 500);
                                  }
                                  else if(state is RevokeDamageSuccessState){
                                    DialogUtils.hideLoadingDialog(context);
                                    if(state.revokeDamageModel.status == "E"){
                                      SnackbarUtil.showSnackbar(context, state.revokeDamageModel.statusMessage!, MyColor.colorRed, icon: FontAwesomeIcons.times);
                                      Vibration.vibrate(duration: 500);
                                    }else{
                                      SnackbarUtil.showSnackbar(context, state.revokeDamageModel.statusMessage!, MyColor.colorGreen, icon: Icons.done);
                                      await context.read<ShipmentDamageCubit>().getShipmentDamageDetailListApi(
                                          groupIdController.text,
                                          searchByGroupOrAWB,
                                          _user!.userProfile!.userIdentity!,
                                          _splashDefaultData!.companyCode!,
                                          widget.menuId);
                                    }
                                  }
                                  else if(state is RevokeDamageFailureState){
                                    DialogUtils.hideLoadingDialog(context);
                                    SnackbarUtil.showSnackbar(context, state.error, MyColor.colorRed, icon: FontAwesomeIcons.times);
                                    Vibration.vibrate(duration: 500);
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
                                                SizedBox(height: SizeConfig.blockSizeVertical),
                                                Directionality(
                                                  textDirection: uiDirection,
                                                  child: IntrinsicHeight(
                                                    child: Row(
                                                      children: [
                                                        // Yes Option
                                                        Expanded(
                                                          flex: 1,
                                                          child: InkWell(
                                                            onTap: () {

                                                              setState(() {
                                                                searchByGroupOrAWB = "G";
                                                                shipmentDamageListModel = null;
                                                                groupIdController.clear();
                                                              });

                                                            },
                                                            child: Container(
                                                              decoration: BoxDecoration(
                                                                color: searchByGroupOrAWB == "G" ? MyColor.primaryColorblue : MyColor.colorWhite, // Selected blue, unselected white
                                                                borderRadius: BorderRadius.only(
                                                                  topLeft: Radius.circular(10),
                                                                  bottomLeft: Radius.circular(10),
                                                                ),
                                                                border: Border.all(color: MyColor.primaryColorblue), // Border color
                                                              ),
                                                              padding: EdgeInsets.symmetric(vertical:12, horizontal: 10),
                                                              child: Center(
                                                                  child: CustomeText(text: "${lableModel.groupId}", fontColor: searchByGroupOrAWB == "G" ? MyColor.colorWhite : MyColor.textColorGrey3, fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5, fontWeight: FontWeight.w600, textAlign: TextAlign.center)

                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        // No Option
                                                        Expanded(
                                                          flex: 1,
                                                          child: InkWell(
                                                            onTap: () {
                                                              setState(() {
                                                                searchByGroupOrAWB = "A";
                                                                shipmentDamageListModel = null;
                                                                groupIdController.clear();
                                                              });

                                                            },
                                                            child: Container(
                                                              decoration: BoxDecoration(
                                                                color: searchByGroupOrAWB == "A" ? MyColor.primaryColorblue : MyColor.colorWhite, // Selected blue, unselected white
                                                                borderRadius: BorderRadius.only(
                                                                  topRight: Radius.circular(10),
                                                                  bottomRight: Radius.circular(10),
                                                                ),
                                                                border: Border.all(color:MyColor.primaryColorblue), // Border color
                                                              ),
                                                              padding: EdgeInsets.symmetric(vertical:12, horizontal: 10),
                                                              child: Center(
                                                                  child: CustomeText(text: "${lableModel.awb}", fontColor: searchByGroupOrAWB == "A" ? MyColor.colorWhite : MyColor.textColorGrey3, fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5, fontWeight: FontWeight.w600, textAlign: TextAlign.center)
                                                              ),
                                                            ),
                                                          ),
                                                        ),


                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(height: SizeConfig.blockSizeVertical * SizeUtils.TEXTSIZE_2_3),
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
                                                          labelText: (searchByGroupOrAWB == "G") ? (isGroupIDRequired == "Y") ? "${lableModel.groupId} *" : "${lableModel.groupId}" : "${lableModel.awb} *",
                                                          readOnly: false,
                                                          maxLength: searchByGroupOrAWB == "G" ? (groupIDCharSize == 0) ? 1 : groupIDCharSize : 11,
                                                          onChanged: (value) {
                                                            shipmentDamageListModel = null;

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
                                                          (searchByGroupOrAWB == "G") ? scanGroupQR() : scanAWBQR(lableModel);
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
                                                child: Padding(
                                                  padding: const EdgeInsets.only(left: 12, right: 12, top: 12, bottom: 12),
                                                  child: (shipmentDamageListModel != null)
                                                      ? (shipmentDamageListModel!.damageDetailList!.isNotEmpty) ? Column(
                                                    children: [

                                                      ListView.builder(
                                                        itemCount: (shipmentDamageListModel != null)
                                                            ? shipmentDamageListModel!.damageDetailList!.length
                                                            : 0,
                                                        physics: NeverScrollableScrollPhysics(),
                                                        shrinkWrap: true,

                                                        controller: scrollController,
                                                        itemBuilder: (context, index) {
                                                          DamageDetailList damageDetailList = shipmentDamageListModel!.damageDetailList![index];
                                                          bool isSelected = _selectedIndex == index;
                                                          bool isExpand = _isExpandedDetails == index;
                                                          List<String> shcCodes = damageDetailList.sHCCode!.split(',');

                                                          return InkWell(
                                                              focusNode: itemFocusNode,
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

                                                                CommonUtils.SELECTEDWHETHER = "";
                                                                CommonUtils.SELECTEDDAMAGEIMAGELIST.clear();
                                                                CommonUtils.shipTotalPcs = 0;
                                                                CommonUtils.ShipTotalWt = "0.00";
                                                                CommonUtils.shipDamagePcs = 0;
                                                                CommonUtils.ShipDamageWt = "0.00";
                                                                CommonUtils.shipDifferencePcs = 0;
                                                                CommonUtils.shipDifferenceWt = "0.00";
                                                                CommonUtils.individualWTPerDoc = "0.00";
                                                                CommonUtils.individualWTActChk = "0.00";
                                                                CommonUtils.individualWTDifference = "0.00";
                                                                CommonUtils.SELECTEDMATERIAL = "";
                                                                CommonUtils.SELECTEDTYPE = "";
                                                                CommonUtils.SELECTEDMARKANDLABLE = "";
                                                                CommonUtils.SELECTEDOUTRERPACKING = "";
                                                                CommonUtils.SELECTEDINNERPACKING = "";
                                                                CommonUtils.SELECTEDDAMAGEDISCOVER = "";
                                                                CommonUtils.SELECTEDDAMAGEAPPARENTLY = "";
                                                                CommonUtils.SELECTEDSALVAGEACTION = "";
                                                                CommonUtils.SELECTEDDISPOSITION = "";
                                                                CommonUtils.MISSINGITEM = "Y";
                                                                CommonUtils.VERIFIEDINVOICE = "Y";
                                                                CommonUtils.SUFFICIENT = "Y";
                                                                CommonUtils.EVIDENCE = "Y";
                                                                CommonUtils.REMARKS = "";
                                                                CommonUtils.SELECTEDCONTENT = "";
                                                                CommonUtils.SELECTEDCONTAINER = "";


                                                                var value = await Navigator.push(context, CupertinoPageRoute(
                                                                  builder: (context) => DamageShimentPage(
                                                                    importSubMenuList: widget.importSubMenuList,
                                                                    exportSubMenuList: widget.exportSubMenuList,
                                                                    lableModel: lableModel,
                                                                    pageView: 0,
                                                                    enterDamageNop: damageDetailList.damageNOP!,
                                                                    enterDamageWt: damageDetailList.damageWeight!,
                                                                    damageNop: 0,
                                                                    damageWt: 0.00,
                                                                    buttonRightsList: const [],
                                                                    iMPAWBRowId: damageDetailList.iMPAWBRowId!,
                                                                    iMPShipRowId: damageDetailList.iMPShipRowId!,
                                                                    flightSeqNo: damageDetailList.flightSeqNo!,
                                                                    flightStatus: "",
                                                                    mainMenuName: widget.mainMenuName,
                                                                    userId: _user!.userProfile!.userIdentity!,
                                                                    companyCode: _splashDefaultData!.companyCode!,
                                                                    menuId: widget.menuId,
                                                                    groupId: damageDetailList.groupId!,
                                                                    problemSeqId: damageDetailList.problemSeqId!,
                                                                    moduleType: "I",
                                                                  ),));

                                                                if(value == "Done"){
                                                                  _resumeTimerOnInteraction();
                                                                  await context.read<ShipmentDamageCubit>().getShipmentDamageDetailListApi(
                                                                      groupIdController.text,
                                                                      searchByGroupOrAWB,
                                                                      _user!.userProfile!.userIdentity!,
                                                                      _splashDefaultData!.companyCode!,
                                                                      widget.menuId);
                                                                  // Navigator.pop(context, "true");
                                                                }
                                                                else if(value == "true"){
                                                                  _resumeTimerOnInteraction();
                                                                  // call shipment damage details api
                                                                  await context.read<ShipmentDamageCubit>().getShipmentDamageDetailListApi(
                                                                      groupIdController.text,
                                                                      searchByGroupOrAWB,
                                                                      _user!.userProfile!.userIdentity!,
                                                                      _splashDefaultData!.companyCode!,
                                                                      widget.menuId);
                                                                  //Navigator.pop(context, "true");
                                                                }



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
                                                                    color: damageDetailList.sHCCode!.contains("DGR") ? MyColor.colorRedLight : Colors.transparent,
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
                                                                                        text: "${damageDetailList.flightNo}",
                                                                                        fontColor: MyColor.colorBlack,
                                                                                        fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                                                                        fontWeight: FontWeight.w600,
                                                                                        textAlign: TextAlign.start,
                                                                                      ),
                                                                                      const SizedBox(width: 5),
                                                                                      CustomeText(
                                                                                        text: " ${damageDetailList.flightDate!.replaceAll(" ", "-")}",
                                                                                        fontColor: MyColor.textColorGrey2,
                                                                                        fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                                                                        fontWeight: FontWeight.w600,
                                                                                        textAlign: TextAlign.start,
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                  (damageDetailList.damageNOP != 0)
                                                                                      ? Padding(
                                                                                    padding: const EdgeInsets.symmetric(horizontal: 5),
                                                                                    child: Row(
                                                                                      children: [
                                                                                        SvgPicture.asset(
                                                                                          damageIcon,
                                                                                          height: SizeConfig.blockSizeVertical * SizeUtils.ICONSIZE2,
                                                                                        ),
                                                                                        SizedBox(width: SizeConfig.blockSizeHorizontal),
                                                                                        CustomeText(
                                                                                          text: "DMG",
                                                                                          fontColor: MyColor.colorRed,
                                                                                          fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                                                                          fontWeight: FontWeight.w400,
                                                                                          textAlign: TextAlign.start,
                                                                                        ),
                                                                                      ],
                                                                                    ),
                                                                                  ) : SizedBox(),
                                                                                ],
                                                                              ),
                                                                              SizedBox(height: SizeConfig.blockSizeVertical * 0.8),
                                                                              Row(
                                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                children: [
                                                                                  Row(
                                                                                    children: [
                                                                                      CustomeText(text: (searchByGroupOrAWB == "G") ? AwbFormateNumberUtils.formatAWBNumber(damageDetailList.aWBNo!) : damageDetailList.groupId!, fontColor: MyColor.colorBlack, fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5, fontWeight: FontWeight.w600, textAlign: TextAlign.start),
                                                                                    ],
                                                                                  ),
                                                                                //  CustomeText(text: (damageDetailList.houseNo!.isNotEmpty) ? /*damageDetailList.houseNo!*/"House" : "", fontColor: MyColor.textColorGrey, fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_6, fontWeight: FontWeight.w400, textAlign: TextAlign.start),
                                                                                  (damageDetailList.houseNo!.isNotEmpty) ? CustomeText(text: damageDetailList.houseNo!, fontColor: MyColor.colorBlack, fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_4, fontWeight: FontWeight.w500, textAlign: TextAlign.start) : SizedBox(),

                                                                                ],
                                                                              ),
                                                                              damageDetailList.sHCCode!.isNotEmpty ? SizedBox(height: SizeConfig.blockSizeVertical * 0.8,) : SizedBox(),
                                                                              Row(
                                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                children: [
                                                                                  damageDetailList.sHCCode!.isNotEmpty
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

                                                                                //  (damageDetailList.houseNo!.isNotEmpty) ? CustomeText(text: damageDetailList.houseNo!, fontColor: MyColor.colorBlack, fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_6, fontWeight: FontWeight.w700, textAlign: TextAlign.start) : SizedBox(),


                                                                                ],
                                                                              ),
                                                                              damageDetailList.sHCCode!.isNotEmpty ? SizedBox(height: SizeConfig.blockSizeVertical) : SizedBox(height: SizeConfig.blockSizeVertical * 0.8,),

                                                                              Row(
                                                                                children: [
                                                                                  Expanded(
                                                                                    flex: 1,
                                                                                    child: Row(
                                                                                      children: [
                                                                                        CustomeText(
                                                                                          text: "NPR :",
                                                                                          fontColor: MyColor.textColorGrey2,
                                                                                          fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                                                                          fontWeight: FontWeight.w400,
                                                                                          textAlign: TextAlign.start,
                                                                                        ),
                                                                                        SizedBox(width: 5),
                                                                                        CustomeText(
                                                                                          text: "${damageDetailList.nOP}",
                                                                                          fontColor: MyColor.colorBlack,
                                                                                          fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
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
                                                                                          text: "Weight :",
                                                                                          fontColor: MyColor.textColorGrey2,
                                                                                          fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                                                                          fontWeight: FontWeight.w400,
                                                                                          textAlign: TextAlign.start,
                                                                                        ),
                                                                                        SizedBox(width: 5),
                                                                                        CustomeText(
                                                                                          text: "${CommonUtils.formateToTwoDecimalPlacesValue(damageDetailList.weight!)}",
                                                                                          fontColor: MyColor.colorBlack,
                                                                                          fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                                                                          fontWeight: FontWeight.w600,
                                                                                          textAlign: TextAlign.start,
                                                                                        ),
                                                                                      ],
                                                                                    ),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                              SizedBox(height: SizeConfig.blockSizeVertical * 0.8,),
                                                                              Row(
                                                                                children: [
                                                                                  Expanded(
                                                                                    flex: 1,
                                                                                    child: Row(
                                                                                      children: [
                                                                                        CustomeText(
                                                                                          text: "NPX :",
                                                                                          fontColor: MyColor.textColorGrey2,
                                                                                          fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                                                                          fontWeight: FontWeight.w400,
                                                                                          textAlign: TextAlign.start,
                                                                                        ),
                                                                                        SizedBox(width: 5),
                                                                                        CustomeText(
                                                                                          text: "${damageDetailList.nPX!}",
                                                                                          fontColor: MyColor.colorBlack,
                                                                                          fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
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
                                                                                          text: "Wt. EX. :",
                                                                                          fontColor: MyColor.textColorGrey2,
                                                                                          fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                                                                          fontWeight: FontWeight.w400,
                                                                                          textAlign: TextAlign.start,
                                                                                        ),
                                                                                        SizedBox(width: 5),
                                                                                        CustomeText(
                                                                                          text: "${CommonUtils.formateToTwoDecimalPlacesValue(damageDetailList.weightExp!)}",
                                                                                          fontColor: MyColor.colorBlack,
                                                                                          fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                                                                          fontWeight: FontWeight.w600,
                                                                                          textAlign: TextAlign.start,
                                                                                        ),
                                                                                      ],
                                                                                    ),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                              SizedBox(height: SizeConfig.blockSizeVertical * 0.8,),
                                                                              Row(
                                                                                children: [
                                                                                  Expanded(
                                                                                    flex: 1,
                                                                                    child: Row(
                                                                                      children: [
                                                                                        CustomeText(
                                                                                          text: "Dmg. Pcs. :",
                                                                                          fontColor: MyColor.textColorGrey2,
                                                                                          fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                                                                          fontWeight: FontWeight.w400,
                                                                                          textAlign: TextAlign.start,
                                                                                        ),
                                                                                        SizedBox(width: 5),
                                                                                        CustomeText(
                                                                                          text: "${damageDetailList.damageNOP}",
                                                                                          fontColor: MyColor.colorBlack,
                                                                                          fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
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
                                                                                          text: "Dmg. Wt. :",
                                                                                          fontColor: MyColor.textColorGrey2,
                                                                                          fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                                                                          fontWeight: FontWeight.w400,
                                                                                          textAlign: TextAlign.start,
                                                                                        ),
                                                                                        SizedBox(width: 5),
                                                                                        CustomeText(
                                                                                          text: "${CommonUtils.formateToTwoDecimalPlacesValue(damageDetailList.damageWeight!)}",
                                                                                          fontColor: MyColor.colorBlack,
                                                                                          fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                                                                          fontWeight: FontWeight.w600,
                                                                                          textAlign: TextAlign.start,
                                                                                        ),
                                                                                      ],
                                                                                    ),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                              /*Row(
                                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                children: [
                                                                                  Row(
                                                                                    children: [
                                                                                      CustomeText(
                                                                                        text: "NPX :",
                                                                                        fontColor: MyColor.textColorGrey2,
                                                                                        fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                                                                        fontWeight: FontWeight.w400,
                                                                                        textAlign: TextAlign.start,
                                                                                      ),
                                                                                      SizedBox(width: 5),
                                                                                      CustomeText(
                                                                                        text: "${damageDetailList.nPX}",
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
                                                                                        text: "NPR :",
                                                                                        fontColor: MyColor.textColorGrey2,
                                                                                        fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                                                                        fontWeight: FontWeight.w400,
                                                                                        textAlign: TextAlign.start,
                                                                                      ),
                                                                                      SizedBox(width: 5),
                                                                                      CustomeText(
                                                                                        text: "${damageDetailList.nPR}",
                                                                                        fontColor: MyColor.colorBlack,
                                                                                        fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                                                                        fontWeight: FontWeight.w600,
                                                                                        textAlign: TextAlign.start,
                                                                                      ),
                                                                                    ],
                                                                                  ),

                                                                                ],
                                                                              ),*/
                                                                             /* Row(
                                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                children: [

                                                                                  Row(
                                                                                    children: [
                                                                                      CustomeText(
                                                                                        text: "Wt. Exp.:",
                                                                                        fontColor: MyColor.textColorGrey2,
                                                                                        fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                                                                        fontWeight: FontWeight.w400,
                                                                                        textAlign: TextAlign.start,
                                                                                      ),
                                                                                      SizedBox(width: 5),
                                                                                      CustomeText(
                                                                                        text: CommonUtils.formateToTwoDecimalPlacesValue(damageDetailList.weightExp!),
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
                                                                                        text: "Wt. Rec.:",
                                                                                        fontColor: MyColor.textColorGrey2,
                                                                                        fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                                                                        fontWeight: FontWeight.w400,
                                                                                        textAlign: TextAlign.start,
                                                                                      ),
                                                                                      SizedBox(width: 5),
                                                                                      CustomeText(
                                                                                        text: CommonUtils.formateToTwoDecimalPlacesValue(damageDetailList.weightRec!),
                                                                                        fontColor: MyColor.colorBlack,
                                                                                        fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                                                                        fontWeight: FontWeight.w600,
                                                                                        textAlign: TextAlign.start,
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                ],
                                                                              ),*/

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
                                                                                        text: damageDetailList.nOG!,
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
                                                                                        text: "${damageDetailList.commodity}",
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
                                                                                  Expanded(
                                                                                    flex:1,
                                                                                    child: Row(
                                                                                      mainAxisAlignment: MainAxisAlignment.start,
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
                                                                                        (damageDetailList.damageNOP != 0) ? const SizedBox(width: 10,) : const SizedBox(),
                                                                                        (damageDetailList.damageNOP != 0) ? RoundedButton(
                                                                                          color: MyColor.primaryColorblue,
                                                                                          horizontalPadding: 10,
                                                                                          verticalPadding: 3,
                                                                                          text: "${lableModel.revoke}", press: () async {

                                                                                          bool? exitConfirmed = await DialogUtils.showRevokeDialog(context, lableModel);

                                                                                          if(exitConfirmed == true) {
                                                                                            await context.read<ShipmentDamageCubit>().revokeDamageApi(
                                                                                                damageDetailList.iMPAWBRowId!,
                                                                                                damageDetailList.iMPShipRowId!,
                                                                                                damageDetailList.problemSeqId!,
                                                                                                damageDetailList.flightSeqNo!,
                                                                                                _user!.userProfile!.userIdentity!,
                                                                                                _splashDefaultData!.companyCode!,
                                                                                                widget.menuId);
                                                                                          }else{
                                                                                            _resumeTimerOnInteraction();
                                                                                          }




                                                                                        },) : SizedBox(),
                                                                                      ],
                                                                                    ),
                                                                                  ),

                                                                                  InkWell(
                                                                                    onTap: () async {

                                                                                      setState(() {
                                                                                        _selectedIndex = index; // Update the selected index
                                                                                      });

                                                                                      CommonUtils.SELECTEDWHETHER = "";
                                                                                      CommonUtils.SELECTEDDAMAGEIMAGELIST.clear();
                                                                                      CommonUtils.shipTotalPcs = 0;
                                                                                      CommonUtils.ShipTotalWt = "0.00";
                                                                                      CommonUtils.shipDamagePcs = 0;
                                                                                      CommonUtils.ShipDamageWt = "0.00";
                                                                                      CommonUtils.shipDifferencePcs = 0;
                                                                                      CommonUtils.shipDifferenceWt = "0.00";
                                                                                      CommonUtils.individualWTPerDoc = "0.00";
                                                                                      CommonUtils.individualWTActChk = "0.00";
                                                                                      CommonUtils.individualWTDifference = "0.00";
                                                                                      CommonUtils.SELECTEDMATERIAL = "";
                                                                                      CommonUtils.SELECTEDTYPE = "";
                                                                                      CommonUtils.SELECTEDMARKANDLABLE = "";
                                                                                      CommonUtils.SELECTEDOUTRERPACKING = "";
                                                                                      CommonUtils.SELECTEDINNERPACKING = "";
                                                                                      CommonUtils.SELECTEDDAMAGEDISCOVER = "";
                                                                                      CommonUtils.SELECTEDDAMAGEAPPARENTLY = "";
                                                                                      CommonUtils.SELECTEDSALVAGEACTION = "";
                                                                                      CommonUtils.SELECTEDDISPOSITION = "";
                                                                                      CommonUtils.MISSINGITEM = "Y";
                                                                                      CommonUtils.VERIFIEDINVOICE = "Y";
                                                                                      CommonUtils.SUFFICIENT = "Y";
                                                                                      CommonUtils.EVIDENCE = "Y";
                                                                                      CommonUtils.REMARKS = "";
                                                                                      CommonUtils.SELECTEDCONTENT = "";
                                                                                      CommonUtils.SELECTEDCONTAINER = "";


                                                                                      var value = await Navigator.push(context, CupertinoPageRoute(
                                                                                        builder: (context) => DamageShimentPage(
                                                                                        importSubMenuList: widget.importSubMenuList,
                                                                                        exportSubMenuList: widget.exportSubMenuList,
                                                                                        lableModel: lableModel,
                                                                                        pageView: 0,
                                                                                        enterDamageNop: damageDetailList.damageNOP!,
                                                                                        enterDamageWt: damageDetailList.damageWeight!,
                                                                                        damageNop: 0,
                                                                                        damageWt: 0.00,
                                                                                        buttonRightsList: const [],
                                                                                        iMPAWBRowId: damageDetailList.iMPAWBRowId!,
                                                                                        iMPShipRowId: damageDetailList.iMPShipRowId!,
                                                                                        flightSeqNo: damageDetailList.flightSeqNo!,
                                                                                        flightStatus: "",
                                                                                        mainMenuName: widget.mainMenuName,
                                                                                        userId: _user!.userProfile!.userIdentity!,
                                                                                        companyCode: _splashDefaultData!.companyCode!,
                                                                                        menuId: widget.menuId,
                                                                                        groupId: damageDetailList.groupId!,
                                                                                        problemSeqId: damageDetailList.problemSeqId!,
                                                                                        moduleType: "I",
                                                                                        ),));

                                                                                      if(value == "Done"){
                                                                                        _resumeTimerOnInteraction();
                                                                                        await context.read<ShipmentDamageCubit>().getShipmentDamageDetailListApi(
                                                                                            groupIdController.text,
                                                                                            searchByGroupOrAWB,
                                                                                            _user!.userProfile!.userIdentity!,
                                                                                            _splashDefaultData!.companyCode!,
                                                                                            widget.menuId);
                                                                                       // Navigator.pop(context, "true");
                                                                                      }
                                                                                      else if(value == "true"){
                                                                                        _resumeTimerOnInteraction();
                                                                                        // call shipment damage details api
                                                                                        await context.read<ShipmentDamageCubit>().getShipmentDamageDetailListApi(
                                                                                            groupIdController.text,
                                                                                            searchByGroupOrAWB,
                                                                                            _user!.userProfile!.userIdentity!,
                                                                                            _splashDefaultData!.companyCode!,
                                                                                            widget.menuId);
                                                                                        //Navigator.pop(context, "true");
                                                                                      }



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

      setState(() {

      });

      bool specialCharAllow = CommonUtils.containsSpecialCharacters(groupcodeScanResult);

      if(specialCharAllow == true){
        SnackbarUtil.showSnackbar(context, "${widget.lableModel!.onlyAlphaNumericValueMsg}", MyColor.colorRed, icon: FontAwesomeIcons.times);
        Vibration.vibrate(duration: 500);
        groupIdController.clear();
        WidgetsBinding.instance.addPostFrameCallback((_) {
          FocusScope.of(context).requestFocus(groupIdFocusNode);
        });

        shipmentDamageListModel = null;


      }else {
        shipmentDamageListModel = null;

        String result = groupcodeScanResult.replaceAll(" ", "");

        String truncatedResult = result.length > groupIDCharSize
            ? result.substring(0, groupIDCharSize)
            : result;

        groupIdController.text = truncatedResult;
        if (groupIdController.text.length != groupIDCharSize) {
          openValidationDialog(
              CommonUtils.formatMessage("${widget.lableModel!.groupIdCharSizeMsg}", ["$groupIDCharSize"]),
              groupIdFocusNode);

        }else{
          await context.read<ShipmentDamageCubit>().getShipmentDamageDetailListApi(
              groupIdController.text,
              searchByGroupOrAWB,
              _user!.userProfile!.userIdentity!,
              _splashDefaultData!.companyCode!,
              widget.menuId);
        }


      }

    }


  }

  Future<void> scanAWBQR(LableModel lableModel) async {



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
        groupIdController.clear();
        shipmentDamageListModel = null;
        setState(() {

        });
        SnackbarUtil.showSnackbar(context, "${lableModel.invalidAWBNo}", MyColor.colorRed, icon: FontAwesomeIcons.times);
        Vibration.vibrate(duration: 500);
        WidgetsBinding.instance.addPostFrameCallback((_) {
          FocusScope.of(context).requestFocus(groupIdFocusNode);
        });
      }else{

        if (RegExp(r'[a-zA-Z]').hasMatch(barcodeScanResult)) {
          groupIdController.clear();
          shipmentDamageListModel = null;
          setState(() {

          });
          // Show invalid message if alphabet characters are present
          SnackbarUtil.showSnackbar(context, "${lableModel.invalidAWBNo}", MyColor.colorRed, icon: FontAwesomeIcons.times);
          Vibration.vibrate(duration: 500);

          WidgetsBinding.instance.addPostFrameCallback((_) {
            FocusScope.of(context).requestFocus(groupIdFocusNode);
          });
        } else {
          String result = barcodeScanResult.replaceAll(" ", "");
          String truncatedResult = result.length > 11
              ? result.substring(0, 11)
              : result;

          groupIdController.text = truncatedResult.toString();
          if (groupIdController.text.length != 11) {
            openValidationDialog(CommonUtils.formatMessage("${lableModel.awbCharSizeMsg}", ["11"]), groupIdFocusNode);
            WidgetsBinding.instance.addPostFrameCallback((_) {
              FocusScope.of(context).requestFocus(groupIdFocusNode);
            });
          }
          else{
            await context.read<ShipmentDamageCubit>().getShipmentDamageDetailListApi(
                groupIdController.text,
                searchByGroupOrAWB,
                _user!.userProfile!.userIdentity!,
                _splashDefaultData!.companyCode!,
                widget.menuId);
          }
        }




      }


    }

    /*    String barcodeScanResult =  await FlutterBarcodeScanner.scanBarcode(
      '#ff6666', // Color for the scanner overlay
      'Cancel', // Text for the cancel button
      true, // Enable flash option
      ScanMode.DEFAULT, // Scan mode
    );

    if(barcodeScanResult == "-1"){
    }
    else{
      if(RegExp(r'^[0-9]+$').hasMatch(barcodeScanResult)){
        String result = barcodeScanResult.replaceAll(" ", "");
        String truncatedResult = result.length > 11
            ? result.substring(0, 11)
            : result;
        shipmentDamageListModel = null;
        setState(() {

        });
        groupIdController.text = truncatedResult.toString();

        if (groupIdController.text.length != 11) {
          openValidationDialog(CommonUtils.formatMessage("${lableModel.awbCharSizeMsg}", ["11"]), groupIdFocusNode);

        }
        else{
          await context.read<ShipmentDamageCubit>().getShipmentDamageDetailListApi(
              groupIdController.text,
              searchByGroupOrAWB,
              _user!.userProfile!.userIdentity!,
              _splashDefaultData!.companyCode!,
              widget.menuId);
        }
      }
      else{
        groupIdController.clear();
        // Show invalid message if alphabet characters are present
        SnackbarUtil.showSnackbar(context, "${lableModel.invalidAWBNo}", MyColor.colorRed, icon: FontAwesomeIcons.times);
        Vibration.vibrate(duration: 500);
        shipmentDamageListModel = null;
        setState(() {

        });
        WidgetsBinding.instance.addPostFrameCallback((_) {
          FocusScope.of(context).requestFocus(groupIdFocusNode);
        });
      }
    }*/
  }


}

class TickerProviders extends TickerProvider {
  @override
  Ticker createTicker(onTick) => Ticker(onTick);
}

