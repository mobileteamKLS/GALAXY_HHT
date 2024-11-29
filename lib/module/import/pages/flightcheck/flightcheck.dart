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
import 'package:galaxy/module/import/pages/flightcheck/addmailpage.dart';
import 'package:galaxy/module/import/pages/flightcheck/awblistpage.dart';
import 'package:galaxy/module/import/pages/flightcheck/awbremarklistpage.dart';
import 'package:galaxy/module/import/services/flightcheck/flightchecklogic/flightcheckcubit.dart';
import 'package:galaxy/module/import/services/flightcheck/flightchecklogic/flightcheckstate.dart';
import 'package:galaxy/utils/sizeutils.dart';
import 'package:galaxy/widget/customebuttons/roundbuttonblue.dart';
import 'package:galaxy/widget/custometext.dart';
import 'package:galaxy/widget/groupidcustomtextfield.dart';
import 'package:google_fonts/google_fonts.dart';
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
import '../../../../utils/validationmsgcodeutils.dart';
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
import '../../model/flightcheck/flightchecksummarymodel.dart';
import '../../model/flightcheck/flightcheckuldlistmodel.dart';
import '../../model/uldacceptance/buttonrolesrightsmodel.dart';
import '../uldacceptance/ulddamagedpage.dart';

class FlightCheck extends StatefulWidget {
  String mainMenuName;
  String title;
  String refrelCode;
  LableModel? lableModel;
  int menuId;
  List<SubMenuName> importSubMenuList = [];
  List<SubMenuName> exportSubMenuList = [];

  FlightCheck(
      {super.key,
      required this.importSubMenuList,
      required this.exportSubMenuList,
      required this.title,
      required this.refrelCode,
      this.lableModel,
      required this.menuId,
      required this.mainMenuName});

  @override
  State<FlightCheck> createState() => _FlightCheckState();
}

class _FlightCheckState extends State<FlightCheck>
    with SingleTickerProviderStateMixin {

  String awbRemarkRequires = "Y";
  String groupIDRequires = "Y";
  int groupIDCharSize = 14;

  InactivityTimerManager? inactivityTimerManager;
  final SavedPrefrence savedPrefrence = SavedPrefrence();
  UserDataModel? _user;
  SplashDefaultModel? _splashDefaultData;
  final ScrollController scrollController = ScrollController();

  FlightCheckULDListModel? flightCheckULDListModel;
  FlightCheckSummaryModel? flightCheckSummaryModel;

  List<FlightDetailList> originalFlightDetails = [];
  List<FlightDetailList> flightDetailsList = [];

  List<ButtonRight> buttonRightsList = [];

  Map<String, String>? validationMessages;

  TextEditingController locationController = TextEditingController();
  TextEditingController igmNoEditingController = TextEditingController();

  TextEditingController flightNoEditingController = TextEditingController();
  TextEditingController dateEditingController = TextEditingController();
  TextEditingController ataDateEditingController = TextEditingController();
  TextEditingController ataTimeEditingController = TextEditingController();

  FocusNode locationFocusNode = FocusNode();
  FocusNode locationBtnFocusNode = FocusNode();
  FocusNode igmNoFocusNode = FocusNode();
  FocusNode scanBtnFocusNode = FocusNode();
  FocusNode flightNoFocusNode = FocusNode();
  FocusNode dateFocusNode = FocusNode();
  FocusNode flightBtnFocusNode = FocusNode();
  FocusNode ataDateFocusNode = FocusNode();
  FocusNode ataTimeFocusNode = FocusNode();

  FocusNode uldListFocusNode = FocusNode();

  DateTime? _selectedDate;
  DateTime? _selectedATADate;

  bool _isLocationSearchBtnEnable = false;
  bool _isvalidateLocation = false;
  bool _isDatePickerOpen = false;
  bool _isATADatePickerOpen = false;
  bool _isTimePickerOpen = false;

  late TabController _tabController;
  int _pageIndex = 0;
  int? _selectedIndex;

  late AnimationController _blinkController;
  late Animation<Color?> _colorAnimation;

  bool _isOpenULDFlagEnable = false;

  final ValueNotifier<double> _valueNotifier = ValueNotifier(0);


  final List<String> _tabs = ['ULD List', 'Summary', 'SLA'];

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
    _tabController = TabController(length: 3, vsync: this);
    _tabController.animateTo(_pageIndex);



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
              callFlightCheckULDListApi(context, locationController.text, igmNoEditingController.text, "", "1900-01-01", _user!.userProfile!.userIdentity!, _splashDefaultData!.companyCode!, widget.menuId, (_isOpenULDFlagEnable == true) ? 1 : 0);
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
         // openValidationDialog(widget.lableModel!.enterLocationMsg!, locationFocusNode);
        }
      }

    },);



    // Listener to handle focus and open date picker only once
    dateFocusNode.addListener(() {
      if (_isvalidateLocation) {
        if (dateFocusNode.hasFocus) {
          if (dateEditingController.text.isEmpty && !_isDatePickerOpen) {
            _selectDate(context);
          }
        }
      } else {
        FocusScope.of(context).requestFocus(locationFocusNode);
      }
    });

    ataDateFocusNode.addListener(() {
      if (_isvalidateLocation) {
        if (ataDateFocusNode.hasFocus) {
          if (ataDateEditingController.text.isEmpty && !_isATADatePickerOpen) {
            _selectATADate(context);
          }
        }
      } else {
        FocusScope.of(context).requestFocus(locationFocusNode);
      }
    });

    ataTimeFocusNode.addListener(() {
      if (_isvalidateLocation) {
        if (ataTimeFocusNode.hasFocus) {
          if (ataTimeEditingController.text.isEmpty && !_isTimePickerOpen) {
            _selectTime(context, widget.lableModel!);
          }
        }
      } else {
        FocusScope.of(context).requestFocus(locationFocusNode);
      }
    });
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
    flightNoEditingController.dispose();
    flightNoFocusNode.dispose();
    dateEditingController.dispose();
    dateFocusNode.dispose();
    ataDateEditingController.dispose();
    ataDateFocusNode.dispose();
    ataTimeEditingController.dispose();
    ataTimeFocusNode.dispose();
    scanBtnFocusNode.dispose();
    ataTimeFocusNode.dispose();
  }

  Future<void> _loadUser() async {
    final user = await savedPrefrence.getUserData();
    final splashDefaultData = await savedPrefrence.getSplashDefaultData();
    if (user != null && splashDefaultData != null) {
      setState(() {
        _user = user;
        _splashDefaultData = splashDefaultData;
      });

    //  context.read<FlightCheckCubit>().getButtonRolesAndRights(widget.menuId, _user!.userProfile!.userIdentity!, _splashDefaultData!.companyCode!);
      context.read<FlightCheckCubit>().getPageLoadDefault(widget.menuId, _user!.userProfile!.userIdentity!, _splashDefaultData!.companyCode!);

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
      await context.read<FlightCheckCubit>().getValidateLocation(
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
    if(_pageIndex == 1){
      setState(() {
        _pageIndex = 0;
        _tabController.animateTo(0);
      });
    }else if(_pageIndex == 2){
      _pageIndex = 0;
      _tabController.animateTo(0);
    }else{
      locationController.clear();
      igmNoEditingController.clear();
      flightNoEditingController.clear();
      dateEditingController.clear();
      ataDateEditingController.clear();
      ataTimeEditingController.clear();
      _isvalidateLocation = false;
      flightCheckULDListModel = null;
      flightCheckSummaryModel = null;
      originalFlightDetails.clear();
      flightDetailsList.clear();

      _tabController.animateTo(0);
      _pageIndex = 0;
      WidgetsBinding.instance.addPostFrameCallback((_) {
          FocusScope.of(context).requestFocus(locationFocusNode);
        },
      );
      _isOpenULDFlagEnable = false;
      Navigator.pop(context, "Done");
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
                                  if(_pageIndex == 1){
                                    setState(() {
                                      _pageIndex = 0;
                                      _tabController.animateTo(0);
                                    });
                                  }else if(_pageIndex == 2){
                                    _pageIndex = 0;
                                    _tabController.animateTo(0);
                                  }else{
                                    locationController.clear();
                                    igmNoEditingController.clear();
                                    flightNoEditingController.clear();
                                    dateEditingController.clear();
                                    ataDateEditingController.clear();
                                    ataTimeEditingController.clear();
                                    _isvalidateLocation = false;
                                    flightCheckULDListModel = null;
                                    flightCheckSummaryModel = null;
                                    originalFlightDetails.clear();
                                    flightDetailsList.clear();

                                    _tabController.animateTo(0);
                                    _pageIndex = 0;
                                    WidgetsBinding.instance.addPostFrameCallback((_) {
                                        FocusScope.of(context).requestFocus(locationFocusNode);
                                      },
                                    );
                                    _isOpenULDFlagEnable = false;
                                    Navigator.pop(context, "Done");
                                  }

                                },
                                clearText: lableModel!.clear,
                                //add clear text to clear all feild
                                onClear: () {
                                  locationController.clear();
                                  igmNoEditingController.clear();
                                  flightNoEditingController.clear();
                                  dateEditingController.clear();
                                  ataDateEditingController.clear();
                                  ataTimeEditingController.clear();
                                  _isvalidateLocation = false;
                                  flightCheckULDListModel = null;
                                  flightCheckSummaryModel = null;
                                  originalFlightDetails.clear();
                                  flightDetailsList.clear();

                                  _tabController.animateTo(0);
                                  _pageIndex = 0;
                                  WidgetsBinding.instance.addPostFrameCallback((_) {
                                      FocusScope.of(context).requestFocus(locationFocusNode);
                                    },
                                  );
                                  _isOpenULDFlagEnable = false;
                                  setState(() {});
                                },
                              ),
                            ),

                            // start api responcer
                            BlocListener<FlightCheckCubit, FlightCheckState>(
                              listener: (context, state) {

                                if (state is MainInitialState) {
                                }
                                else if (state is MainLoadingState) {
                                  // showing loading dialog in this state
                                  DialogUtils.showLoadingDialog(context, message: lableModel.loading);
                                }else if(state is PageLoadDefaultSuccessState){

                                  DialogUtils.hideLoadingDialog(context);
                                  if(state.pageLoadDefaultModel.status == "E"){
                                    Vibration.vibrate(duration: 500);
                                    SnackbarUtil.showSnackbar(context, state.pageLoadDefaultModel.statusMessage!, MyColor.colorRed, icon: FontAwesomeIcons.times);
                                  }else{
                                    awbRemarkRequires = state.pageLoadDefaultModel.IsAWBRemarksAcknowledge!;
                                    groupIDRequires = state.pageLoadDefaultModel.IsGroupBasedAcceptChar!;
                                    groupIDCharSize = state.pageLoadDefaultModel.IsGroupBasedAcceptNumber!;
                                    context.read<FlightCheckCubit>().getButtonRolesAndRights(widget.menuId, _user!.userProfile!.userIdentity!, _splashDefaultData!.companyCode!);
                                    setState(() {

                                    });
                                  }

                                }else if(state is PageLoadDefaultFailureState){
                                  Vibration.vibrate(duration: 500);
                                  SnackbarUtil.showSnackbar(context, state.error, MyColor.colorRed, icon: FontAwesomeIcons.times);
                                }
                                else if(state is ButtonRolesAndRightsSuccessState){
                                  DialogUtils.hideLoadingDialog(context);
                                  if (state.buttonRolesRightsModel.status == "E") {
                                    Vibration.vibrate(duration: 500);
                                    SnackbarUtil.showSnackbar(context, state.buttonRolesRightsModel.statusMessage!, MyColor.colorRed, icon: FontAwesomeIcons.times);
                                  } else {

                                    buttonRightsList = state.buttonRolesRightsModel.buttonRight!;
                                    //focus on location feild
                                    WidgetsBinding.instance.addPostFrameCallback((_) {
                                      FocusScope.of(context).requestFocus(locationFocusNode);
                                    },
                                    );
                                  }
                                }
                                else if(state is ButtonRolesAndRightsFailureState){
                                  DialogUtils.hideLoadingDialog(context);
                                  Vibration.vibrate(duration: 500);
                                  SnackbarUtil.showSnackbar(context, state.error, MyColor.colorRed, icon: FontAwesomeIcons.times);
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
                                else if (state is FlightGetDetailsSuccessState) {
                                  // getting responce for flight details
                                  DialogUtils.hideLoadingDialog(context);
                                  setState(() {
                                    _pageIndex = 0;
                                    _tabController.animateTo(_pageIndex);
                                  });
                                  if (state.flightCheckULDListModel.status == "E") {
                                    Vibration.vibrate(duration: 500);
                                    SnackbarUtil.showSnackbar(
                                        context,
                                        state.flightCheckULDListModel.statusMessage!,
                                        MyColor.colorRed, icon: FontAwesomeIcons.times);

                                    flightNoEditingController.clear();
                                    dateEditingController.clear();
                                    ataDateEditingController.clear();
                                    ataTimeEditingController.clear();
                                    igmNoEditingController.clear();
                                    flightCheckULDListModel = null;
                                    flightCheckSummaryModel = null;
                                    _isOpenULDFlagEnable = false;
                                    originalFlightDetails.clear();
                                    flightDetailsList.clear();
                                    _tabController.animateTo(0);
                                    _pageIndex = 0;
                                    setState(() {});
                                    WidgetsBinding.instance.addPostFrameCallback((_) {
                                        FocusScope.of(context).requestFocus(flightNoFocusNode);
                                      },
                                    );


                                  } else {
                                    WidgetsBinding.instance.addPostFrameCallback((_) {
                                        FocusScope.of(context).requestFocus(flightBtnFocusNode);
                                      },
                                    );

                                    flightCheckULDListModel = state.flightCheckULDListModel;
                                    _selectedIndex = -1;
                                    if (flightCheckULDListModel!.flightDetailSummary != null) {
                                      originalFlightDetails = List.from(flightCheckULDListModel!.flightDetailList!);
                                      flightDetailsList = List.from(originalFlightDetails);
                                      flightDetailsList.sort((a, b) => b.bDPriority!.compareTo(a.bDPriority!));



                                      flightNoEditingController.text = flightCheckULDListModel!.flightDetailSummary!.flightNo!;
                                      dateEditingController.text = flightCheckULDListModel!.flightDetailSummary!.flightDate!.replaceAll(" ", "-");
                                      ataDateEditingController.text = flightCheckULDListModel!.flightDetailSummary!.aTA!.replaceAll(" ", "-");
                                      ataTimeEditingController.text = flightCheckULDListModel!.flightDetailSummary!.aTAT!;
                                      setState(() {});
                                    } else {
                                      flightCheckULDListModel = null;
                                      flightCheckSummaryModel = null;
                                      originalFlightDetails.clear();
                                      flightDetailsList.clear();
                                      ataDateEditingController.clear();
                                      ataTimeEditingController.clear();
                                    }
                                  }
                                }
                                else if (state is FlightGetDetailsFailureState) {
                                  // flight failure responce state
                                  flightCheckULDListModel = null;
                                  flightCheckSummaryModel = null;

                                  originalFlightDetails.clear();
                                  flightDetailsList.clear();

                                  /*flightNoEditingController.clear();
                                    dateEditingController.clear();*/
                                  ataDateEditingController.clear();
                                  ataTimeEditingController.clear();
                                  setState(() {});
                                  DialogUtils.hideLoadingDialog(context);
                                  Vibration.vibrate(duration: 500);
                                  SnackbarUtil.showSnackbar(
                                      context, state.error, MyColor.colorRed, icon: FontAwesomeIcons.times);
                                }
                                else if (state is GetFlightDetailsSummarySuccessState) {
                                  DialogUtils.hideLoadingDialog(context);
                                  setState(() {
                                    _pageIndex = 1;
                                  });

                                  if (state.flightCheckSummaryModel.status == "E") {
                                    Vibration.vibrate(duration: 500);
                                    SnackbarUtil.showSnackbar(
                                        context,
                                        state.flightCheckSummaryModel.statusMessage!,
                                        MyColor.colorRed, icon: FontAwesomeIcons.times);
                                  } else {
                                    flightCheckSummaryModel =
                                        state.flightCheckSummaryModel;
                                    setState(() {});
                                  }
                                }
                                else if (state is GetFlightDetailsSummaryFailureState) {}
                                else if (state is BDPrioritySuccessState) {
                                  // responce bdpriority success

                                  DialogUtils.hideLoadingDialog(context);
                                  if (state.bdPriorityModel.status == "E") {
                                    Vibration.vibrate(duration: 500);
                                    SnackbarUtil.showSnackbar(
                                        context,
                                        state.bdPriorityModel.statusMessage!,
                                        MyColor.colorRed, icon: FontAwesomeIcons.times);
                                  } else {
                                    SnackbarUtil.showSnackbar(
                                        context,
                                        state.bdPriorityModel.statusMessage!,
                                        MyColor.colorGreen, icon: Icons.done);
                                    setState(() {});
                                    //callFlightCheckApi(context, locationController.text, igmNoEditingController.text, flightNoEditingController.text, dateEditingController.text, _user!.userProfile!.userIdentity!, _company!.companyCode!);
                                  }
                                }
                                else if (state is BDPriorityFailureState) {
                                  // bd priority fail responce
                                  DialogUtils.hideLoadingDialog(context);
                                  Vibration.vibrate(duration: 500);
                                  SnackbarUtil.showSnackbar(context, state.error, MyColor.colorRed, icon: FontAwesomeIcons.times);
                                }
                                else if (state is RecordATASuccessState) {
                                  // record ata responce success

                                  DialogUtils.hideLoadingDialog(context);
                                  if (state.recordATAModel.status == "E") {
                                    Vibration.vibrate(duration: 500);
                                    SnackbarUtil.showSnackbar(
                                        context,
                                        state.recordATAModel.statusMessage!,
                                        MyColor.colorRed, icon: FontAwesomeIcons.times);

                                    ataDateEditingController.clear();
                                    ataTimeEditingController.clear();
                                    WidgetsBinding.instance.addPostFrameCallback((_) {
                                      FocusScope.of(context).requestFocus(flightBtnFocusNode);
                                    },
                                    );

                                  } else {
                                    // When Record ATA CALL GET FlightCheck ULD List
                                    callFlightCheckULDListApi(
                                        context,
                                        locationController.text,
                                        "",
                                        flightNoEditingController.text,
                                        dateEditingController.text,
                                        _user!.userProfile!.userIdentity!,
                                        _splashDefaultData!.companyCode!,
                                        widget.menuId,
                                        (_isOpenULDFlagEnable == true) ? 1 : 0);
                                    SnackbarUtil.showSnackbar(
                                        context,
                                        state.recordATAModel.statusMessage!,
                                        MyColor.colorGreen, icon: Icons.done);
                                  }
                                }
                                else if (state is RecordATAFailureState) {
                                  // record ata responce failure

                                  DialogUtils.hideLoadingDialog(context);
                                  Vibration.vibrate(duration: 500);
                                  SnackbarUtil.showSnackbar(context, state.error, MyColor.colorRed, icon: FontAwesomeIcons.times);
                                }
                                else if (state is FinalizeFlightSuccessState) {
                                  // finalize flight responce success

                                  DialogUtils.hideLoadingDialog(context);
                                  if (state.finalizeFlightModel.status == "E") {
                                    Vibration.vibrate(duration: 500);
                                    SnackbarUtil.showSnackbar(
                                        context,
                                        state.finalizeFlightModel.statusMessage!,
                                        MyColor.colorRed, icon: FontAwesomeIcons.times);
                                  } else {
                                    // When Finalize Flight CALL GET FlightCheck ULD List
                                    callFlightCheckULDListApi(
                                        context,
                                        locationController.text,
                                        "",
                                        flightNoEditingController.text,
                                        dateEditingController.text,
                                        _user!.userProfile!.userIdentity!,
                                        _splashDefaultData!.companyCode!,
                                        widget.menuId,
                                        (_isOpenULDFlagEnable == true) ? 1 : 0);

                                    SnackbarUtil.showSnackbar(
                                        context,
                                        state.finalizeFlightModel.statusMessage!,
                                        MyColor.colorGreen, icon: Icons.done);
                                  }
                                }
                                else if (state is FinalizeFlightFailureState) {
                                  // finalize flight responce failure

                                  DialogUtils.hideLoadingDialog(context);
                                  Vibration.vibrate(duration: 500);
                                  SnackbarUtil.showSnackbar(context, state.error, MyColor.colorRed, icon: FontAwesomeIcons.times);
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
                                                            ),
                                                            SizedBox(
                                                              width: SizeConfig.blockSizeHorizontal,
                                                            ),
                                                            // click search button to validate location
                                                            InkWell(
                                                              focusNode: locationBtnFocusNode,
                                                              onTap: () {
                                                                scanLocationQR();
                                                                /*if (_isLocationSearchBtnEnable) {



                                                                } else {
                                                                  openValidationDialog(lableModel.enterLocationMsg!, locationFocusNode);
                                                                }*/
                                                              },
                                                              child: Padding(padding: const EdgeInsets.all(8.0),
                                                                child: SvgPicture.asset(search, height: SizeConfig.blockSizeVertical * SizeUtils.ICONSIZE3,),
                                                              ),

                                                              /*child: Container(
                                                                    padding: EdgeInsets.all(3),
                                                                    decoration: BoxDecoration(
                                                                      color: _isLocationSearchBtnEnable ? MyColor.primaryColorblue : MyColor.colorGrey.withOpacity(0.3),
                                                                      borderRadius: BorderRadius.circular(SizeConfig.blockSizeVertical * SizeUtils.CIRCULARBORDER)
                                                                    ),
                                                                      child: Icon(Icons.search_sharp, color: MyColor.colorWhite, size: SizeConfig.blockSizeVertical * 4,)
                                                                  )*/
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
                                                              labelText: "${lableModel.scanFlight}",
                                                              readOnly: locationController.text.isNotEmpty ? false : true,
                                                              controller: igmNoEditingController,
                                                              focusNode: igmNoFocusNode,
                                                              maxLength: 15,
                                                              onChanged: (value) {


                                                                flightNoEditingController.clear();
                                                                dateEditingController.clear();
                                                                ataDateEditingController.clear();
                                                                ataTimeEditingController.clear();
                                                                flightCheckULDListModel = null;
                                                                flightCheckSummaryModel = null;
                                                                _isOpenULDFlagEnable = false;
                                                                originalFlightDetails.clear();
                                                                flightDetailsList.clear();
                                                                _tabController.animateTo(0);
                                                                _pageIndex = 0;
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
                                                          /*CustomeText(
                                                              text: "${lableModel.scan} / ${lableModel.searchByFlight}",
                                                              fontColor: MyColor.colorBlack,
                                                              fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                                              fontWeight: FontWeight.w600,
                                                              textAlign: TextAlign.start),*/
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
                                                      SizedBox(
                                                        height: SizeConfig.blockSizeVertical * SizeUtils.HEIGHT2,
                                                      ),
                                                      Directionality(
                                                        textDirection: textDirection,
                                                        child: Row(
                                                          children: [
                                                            Expanded(
                                                              flex: 1,
                                                              child: CustomeEditTextWithBorder(
                                                                lablekey: "FLIGHT",
                                                                focusNode: flightNoFocusNode,
                                                                nextFocus: dateFocusNode,
                                                                textDirection: textDirection,
                                                                maxLength: 8,
                                                                controller: flightNoEditingController,
                                                                hasIcon: false,
                                                                hastextcolor: true,
                                                                isShowSuffixIcon: flightNoEditingController.text.isEmpty ? false : true,
                                                                animatedLabel: true,
                                                                needOutlineBorder: true,
                                                                labelText: "${lableModel.flightNo} *",
                                                                onChanged: (value, validate) {
                                                                  dateEditingController.clear();
                                                                  ataDateEditingController.clear();
                                                                  ataTimeEditingController.clear();
                                                                  igmNoEditingController.clear();
                                                                  flightCheckULDListModel = null;
                                                                  flightCheckSummaryModel = null;
                                                                  _isOpenULDFlagEnable = false;
                                                                  originalFlightDetails.clear();
                                                                  flightDetailsList.clear();
                                                                  _tabController.animateTo(0);
                                                                  _pageIndex = 0;
                                                                  setState(() {});
                                                                },
                                                                readOnly: locationController.text.isNotEmpty ? false : true,
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
                                                            SizedBox(
                                                              width: SizeConfig.blockSizeHorizontal * SizeUtils.WIDTH4,
                                                            ),
                                                            // add date in text
                                                            Directionality(
                                                              textDirection: uiDirection,
                                                              child: Expanded(
                                                                flex: 1,
                                                                child: GroupIdCustomTextField(
                                                                  controller: dateEditingController,
                                                                  focusNode: dateFocusNode,
                                                                  onPress: () => locationController.text.isNotEmpty && !_isDatePickerOpen
                                                                      ? _selectDate(context)
                                                                      : null,
                                                                  hastextcolor: true,
                                                                  animatedLabel: true,
                                                                  needOutlineBorder: true,
                                                                  labelText: "${lableModel.flightDate} *",
                                                                  readOnly: true,
                                                                  onChanged: (value) {},
                                                                  textInputType: TextInputType.text,
                                                                  inputAction: TextInputAction.next,
                                                                  hintTextcolor: MyColor.colorGrey,
                                                                  verticalPadding: 0,
                                                                  prefixicon: calender,
                                                                  isShowSuffixIcon: true,
                                                                  isPassword: false,
                                                                  hasIcon: true,
                                                                  isIcon: true,
                                                                  fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_8,
                                                                  circularCorner: SizeConfig.blockSizeHorizontal * SizeUtils.CIRCULARCORNER,
                                                                  boxHeight: SizeConfig.blockSizeVertical * SizeUtils.BOXHEIGHT,
                                                                  iconSize: SizeConfig.blockSizeVertical * SizeUtils.ICONSIZE3,
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
                                                      ),
                                                      SizedBox(
                                                        height: SizeConfig.blockSizeVertical * SizeUtils.HEIGHT2,
                                                      ),
                                                      Directionality(
                                                        textDirection: textDirection,
                                                        child: Row(
                                                          children: [
                                                            Directionality(
                                                              textDirection:
                                                                  uiDirection,
                                                              child: Expanded(
                                                                flex: 1,
                                                                child: GroupIdCustomTextField(
                                                                  controller: ataDateEditingController,
                                                                  focusNode: ataDateFocusNode,
                                                                 /* onPress: () => ataDateEditingController.text.isNotEmpty && !_isATADatePickerOpen
                                                                      ? _selectATADate(context)
                                                                      : null,*/
                                                                  onPress: () {

                                                                    if(locationController.text.isNotEmpty && !_isATADatePickerOpen){

                                                                      if(flightCheckULDListModel!.flightDetailSummary!.flightStatus == "A"){
                                                                        Vibration.vibrate(duration: 500);
                                                                        SnackbarUtil.showSnackbar(context, "${lableModel.flightArrivedDate}", MyColor.colorRed, icon: FontAwesomeIcons.times);
                                                                      }else if(flightCheckULDListModel!.flightDetailSummary!.flightStatus == "F"){
                                                                        Vibration.vibrate(duration: 500);
                                                                        SnackbarUtil.showSnackbar(context, "${lableModel.flightFinalizDate}", MyColor.colorRed, icon: FontAwesomeIcons.times);
                                                                      }else{
                                                                        _selectATADate(context);
                                                                      }
                                                                    }else{

                                                                    }
                                                                  },


                                                                  hastextcolor: true,
                                                                  animatedLabel: true,
                                                                  needOutlineBorder: true,
                                                                  labelText: "${lableModel.ata} ${lableModel.date} *",
                                                                  readOnly: true,
                                                                  onChanged: (value) {},
                                                                  textInputType: TextInputType.text,
                                                                  inputAction: TextInputAction.next,
                                                                  hintTextcolor: MyColor.colorGrey,
                                                                  verticalPadding: 0,
                                                                  prefixicon: calender,
                                                                  isShowSuffixIcon: true,
                                                                  isPassword: false,
                                                                  hasIcon: true,
                                                                  isIcon: true,
                                                                  fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_8,
                                                                  circularCorner: SizeConfig.blockSizeHorizontal * SizeUtils.CIRCULARCORNER,
                                                                  boxHeight: SizeConfig.blockSizeVertical * SizeUtils.BOXHEIGHT,
                                                                  iconSize: SizeConfig.blockSizeVertical * SizeUtils.ICONSIZE3,
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
                                                            Directionality(
                                                              textDirection: uiDirection,
                                                              child: Expanded(
                                                                flex: 1,
                                                                child: GroupIdCustomTextField(
                                                                  controller: ataTimeEditingController,
                                                                  focusNode: ataTimeFocusNode,
                                                                 /* onPress: () => ataTimeEditingController.text.isNotEmpty && !_isTimePickerOpen
                                                                      ? _selectTime(context, lableModel)
                                                                      : null,*/
                                                                  onPress: () {
                                                                    if(locationController.text.isNotEmpty && !_isTimePickerOpen){

                                                                      if(flightCheckULDListModel!.flightDetailSummary!.flightStatus == "A"){
                                                                        Vibration.vibrate(duration: 500);
                                                                        SnackbarUtil.showSnackbar(context, "${lableModel.flightArrivedTime}", MyColor.colorRed, icon: FontAwesomeIcons.times);
                                                                      }else if(flightCheckULDListModel!.flightDetailSummary!.flightStatus == "F"){
                                                                        Vibration.vibrate(duration: 500);
                                                                        SnackbarUtil.showSnackbar(context, "${lableModel.flightFinalizTime}", MyColor.colorRed, icon: FontAwesomeIcons.times);
                                                                      }else{
                                                                        _selectTime(context, lableModel);
                                                                      }
                                                                    }else{

                                                                    }
                                                                  },

                                                                  hastextcolor: true,
                                                                  animatedLabel: true,
                                                                  needOutlineBorder: true,
                                                                  labelText: "${lableModel.ata} ${lableModel.time} *",
                                                                  readOnly: true,
                                                                  onChanged: (value) {},
                                                                  textInputType: TextInputType.text,
                                                                  inputAction: TextInputAction.next,
                                                                  hintTextcolor: MyColor.colorGrey,
                                                                  verticalPadding: 0,
                                                                  prefixicon: clock,
                                                                  isShowSuffixIcon: true,
                                                                  isPassword: false,
                                                                  hasIcon: true,
                                                                  isIcon: true,
                                                                  fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_8,
                                                                  circularCorner: SizeConfig.blockSizeHorizontal * SizeUtils.CIRCULARCORNER,
                                                                  boxHeight: SizeConfig.blockSizeVertical * SizeUtils.BOXHEIGHT,
                                                                  iconSize: SizeConfig.blockSizeVertical * SizeUtils.ICONSIZE3,
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
                                                      ),
                                                      SizedBox(
                                                        height: SizeConfig.blockSizeVertical * SizeUtils.HEIGHT2,
                                                      ),
                                                      RoundedButtonBlue(
                                                        focusNode: flightBtnFocusNode,
                                                        text: "${lableModel.uldSearch}",
                                                        press: () {
                                                         // if(isButtonEnabled("uldSearch", buttonRightsList)){
                                                            if (locationController.text.isNotEmpty) {
                                                              if (flightNoEditingController.text.isNotEmpty) {
                                                                if (dateEditingController.text.isNotEmpty) {
                                                                  // CALL API OF Flight Number and Date
                                                                  _isOpenULDFlagEnable = false;
                                                                  callFlightCheckULDListApi(
                                                                      context,
                                                                      locationController.text,
                                                                      "",
                                                                      flightNoEditingController.text,
                                                                      dateEditingController.text,
                                                                      _user!.userProfile!.userIdentity!,
                                                                      _splashDefaultData!.companyCode!,
                                                                      widget.menuId,
                                                                      (_isOpenULDFlagEnable == true) ? 1 : 0);
                                                                } else {
                                                                  openValidationDialog(lableModel.enterFlightDate!, dateFocusNode);
                                                                }
                                                              } else {
                                                                openValidationDialog(lableModel.enterFlightNo!, flightNoFocusNode);
                                                              }
                                                            } else {
                                                              openValidationDialog(lableModel.enterLocationMsg!, locationFocusNode);
                                                            }
                                                         /* }else{
                                                            SnackbarUtil.showSnackbar(context, "You don't have sufficient rights", MyColor.colorRed, icon: FontAwesomeIcons.times);
                                                            Vibration.vibrate(duration: 500);
                                                          }*/

                                                        },
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
                                                        (flightCheckULDListModel != null)
                                                            ? Container(
                                                          decoration: BoxDecoration(
                                                              border: Border.all(color: MyColor.textColorGrey, width: 0.4),
                                                              borderRadius: BorderRadius.circular(SizeUtils.BORDERRADIOUS)
                                                          ),
                                                          padding: const EdgeInsets.all(10),
                                                          child: Row(

                                                            children: [
                                                              (flightCheckULDListModel != null)
                                                                  ? Column(
                                                                children: [
                                                                  SvgPicture.asset(arrival, height: SizeConfig.blockSizeVertical * SizeUtils.ICONSIZE3,),
                                                                  SizedBox(height: SizeConfig.blockSizeVertical,),
                                                                  Container(
                                                                    padding : EdgeInsets.symmetric(horizontal: SizeConfig.blockSizeHorizontal * 2.5, vertical: SizeConfig.blockSizeVertical * 0.1),
                                                                    decoration : BoxDecoration(
                                                                      borderRadius: BorderRadius.circular(20),
                                                                      color: (flightCheckULDListModel != null)
                                                                          ? (flightCheckULDListModel!.flightDetailSummary!.flightStatus == "A")
                                                                          ? MyColor.flightArrived
                                                                          : (flightCheckULDListModel!.flightDetailSummary!.flightStatus == "F")
                                                                          ? MyColor.flightFinalize
                                                                          : (flightCheckULDListModel!.flightDetailSummary!.flightStatus == "N")
                                                                          ? MyColor.flightNotArrived
                                                                          : null
                                                                          : null,
                                                                    ),
                                                                    child: CustomeText(
                                                                        text: (flightCheckULDListModel != null)
                                                                            ? (flightCheckULDListModel!.flightDetailSummary!.flightStatus == "A")
                                                                            ? lableModel.arrived!
                                                                            : (flightCheckULDListModel!.flightDetailSummary!.flightStatus == "F")
                                                                            ? lableModel.finalized!
                                                                            : (flightCheckULDListModel!.flightDetailSummary!.flightStatus == "N")
                                                                            ? lableModel.notArrived!
                                                                            : ""
                                                                            : "",
                                                                        fontColor: MyColor.textColorGrey3,
                                                                        fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                                                        fontWeight: FontWeight.w500,
                                                                        textAlign: TextAlign.start),
                                                                  ),
                                                                ],
                                                              ) : const SizedBox(),

                                                              Expanded(
                                                                flex:1,
                                                                child: Row(
                                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                                  children: [
                                                                    Container(
                                                                      height : SizeConfig.blockSizeVertical * SizeUtils.HEIGHT7,
                                                                      width : SizeConfig.blockSizeVertical * SizeUtils.HEIGHT7,
                                                                      child: DashedCircularProgressBar.aspectRatio(
                                                                        aspectRatio: 2.5, // width ÷ height
                                                                        valueNotifier: _valueNotifier,
                                                                        progress: (flightCheckULDListModel != null) ? flightCheckULDListModel!.flightDetailSummary!.progress!.toDouble() : 0,
                                                                        maxProgress: 100,
                                                                        corners: StrokeCap.butt,
                                                                        foregroundColor: (flightCheckULDListModel!.flightDetailSummary!.progress!.toDouble() == 100) ? MyColor.colorgreenProgress  : MyColor.colorOrangeProgress,
                                                                        backgroundColor: const Color(0xffF2F4F8),
                                                                        foregroundStrokeWidth: 5,
                                                                        backgroundStrokeWidth: 5,
                                                                        animation: true,
                                                                        child: Center(
                                                                          child: ValueListenableBuilder(
                                                                            valueListenable: _valueNotifier,
                                                                            builder: (_, double value, __) {
                                                                              return CustomeText(text: '${value.toInt()}%', fontColor:  MyColor.colorBlack, fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5, fontWeight: FontWeight.w500, textAlign: TextAlign.center);
                                                                            },
                                                                          ),
                                                                        ),


                                                                      ),
                                                                    ),
                                                                    SizedBox(width: SizeConfig.blockSizeHorizontal,),
                                                                    Column(
                                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                      children: [
                                                                        CustomeText(text: "${lableModel.progress}", fontColor: MyColor.colorBlack, fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_3, fontWeight: FontWeight.w400, textAlign: TextAlign.start),
                                                                        CustomeText(text: "${lableModel.completion}", fontColor: MyColor.colorBlack, fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_3, fontWeight: FontWeight.w400, textAlign: TextAlign.start)
                                                                      ],
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),

                                                              InkWell(
                                                                onTap: () {
                                                                  if (flightCheckULDListModel != null) {
                                                                    Navigator.push(
                                                                      context,
                                                                      CupertinoPageRoute(
                                                                        builder: (
                                                                            context) =>
                                                                            AwbRemarkListpage(
                                                                              importSubMenuList: widget.importSubMenuList,
                                                                              exportSubMenuList: widget.exportSubMenuList,
                                                                              user: _user!,
                                                                              splashDefaultData: _splashDefaultData!,
                                                                              aWBRemarkList: flightCheckULDListModel!
                                                                                  .aWBRemarkList, mainMenuName: widget.mainMenuName,
                                                                            ),
                                                                        fullscreenDialog: true,
                                                                      ),
                                                                    );
                                                                  }
                                                                },
                                                                child: Column(
                                                                  children: [
                                                                (flightCheckULDListModel != null)
                                                                    ? (flightCheckULDListModel!.aWBRemarkList!.isNotEmpty) ? Container(
                                                                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 1),
                                                                  decoration: BoxDecoration(
                                                                      color: MyColor.btCountColor,
                                                                      borderRadius: BorderRadius.circular(SizeConfig.blockSizeHorizontal * SizeUtils.BORDERRADIOUS_6)
                                                                  ),
                                                                  child: CustomeText(
                                                                      text: "${flightCheckULDListModel!.aWBRemarkList!.length}",
                                                                      fontColor: MyColor.textColorGrey2,
                                                                      fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                                                      fontWeight: FontWeight.w500,
                                                                      textAlign: TextAlign.center),
                                                                ) : const SizedBox() : const SizedBox(),
                                                                Row(
                                                                  children: [
                                                                    CustomeText(text: "${lableModel.info}.", fontColor: MyColor.primaryColorblue, fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5, fontWeight: FontWeight.w400, textAlign: TextAlign.end),
                                                                    SizedBox(width: SizeConfig.blockSizeHorizontal,),
                                                                    SvgPicture.asset(right, height: SizeConfig.blockSizeVertical * SizeUtils.ICONSIZE2,),

                                                                  ],
                                                                )

                                                                                                                          ],),
                                                              )
                                                            ],
                                                          ),
                                                        )
                                                            : const SizedBox(),

                                                        Padding(
                                                          padding: const EdgeInsets.only(left: 0, right: 0, top: 12, bottom: 0),
                                                          child: Column(
                                                            children: [
                                                              Row(children: List.generate(_tabs.length, (index) {
                                                                return InkWell(
                                                                  onTap: () {
                                                                    if (index == 0) {
                                                                      if (flightCheckULDListModel != null) {
                                                                        callFlightCheckULDListApi(
                                                                            context,
                                                                            locationController.text,
                                                                            igmNoEditingController.text,
                                                                            flightNoEditingController.text,
                                                                            dateEditingController.text,
                                                                            _user!.userProfile!.userIdentity!,
                                                                            _splashDefaultData!.companyCode!,
                                                                            widget.menuId,
                                                                            (_isOpenULDFlagEnable == true) ? 1 : 0);
                                                                      } else {
                                                                        setState(() {
                                                                          _pageIndex = index;
                                                                        });
                                                                      }
                                                                    }
                                                                    else if (index == 1) {
                                                                      if (flightCheckULDListModel != null) {
                                                                        callFlightCheckSummaryApi(
                                                                            context,
                                                                            flightCheckULDListModel!.flightDetailSummary!.flightSeqNo!,
                                                                            _user!.userProfile!.userIdentity!,
                                                                            _splashDefaultData!.companyCode!,
                                                                            widget.menuId);
                                                                      } else {
                                                                        setState(() {
                                                                          _pageIndex = index;
                                                                        });
                                                                      }
                                                                    }
                                                                    else if (index == 2) {
                                                                      setState(() {
                                                                        _pageIndex = index;
                                                                      });
                                                                    }
                                                                   /* setState(() {
                                                                      _pageIndex = index;
                                                                    });*/
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
                                                      /*  Padding(
                                                          padding: const EdgeInsets.only(left: 12, right: 12,),
                                                          child: _checkWidget(_pageIndex, textDirection, lableModel),
                                                        ),*/
                                                      ],
                                                    ),
                                                  ),
                                            )),

                                          ),


                                          /*  Directionality(
                                              textDirection: textDirection,
                                              child: Row(
                                                children: [
                                                  // add scan flight in text
                                                  Expanded(
                                                    flex: 1,
                                                    child: GroupIdCustomTextField(
                                                      textDirection: textDirection,
                                                      controller: igmNoEditingController,
                                                      focusNode: igmNoFocusNode,
                                                      hasIcon: false,
                                                      hastextcolor: true,
                                                      animatedLabel: true,
                                                      needOutlineBorder: true,
                                                      labelText:
                                                      "${lableModel.scan}",
                                                      readOnly: false,
                                                      maxLength: 15,
                                                      onChanged: (value) {

                                                                                                                    },
                                                                                                                    fillColor:
                                                                                                                    Colors.grey.shade100,
                                                                                                                    textInputType:
                                                                                                                    TextInputType.text,
                                                                                                                    inputAction:
                                                                                                                    TextInputAction.next,
                                                                                                                    hintTextcolor: MyColor.colorBlack,
                                                                                                                    verticalPadding: 0,
                                                                                                                    fontSize: SizeConfig.textMultiplier * SizeUtils.MEDIUMTEXTSIZE,
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
                                                                                                                  width: SizeConfig.blockSizeHorizontal * 1.9,
                                                                                                                ),

                                                                                                                // click search button to validate scan flight
                                                                                                                InkWell(
                                                                                                                    focusNode: scanBtnFocusNode,
                                                                                                                    onTap: () async {
                                                                                                                      if(locationController.text.isNotEmpty){
                                                                                                                        if(igmNoEditingController.text.isNotEmpty){
                                                                                                                          // CALL API OF SCAN NUMBER
                                                                                                                          callFlightCheckULDListApi(context, locationController.text, igmNoEditingController.text, "", "1900-01-01", _user!.userProfile!.userIdentity!, _splashDefaultData!.companyCode!, widget.menuId, (_isOpenULDFlagEnable == true) ? 1 : 0);
                                                                                                                        }else{

                                                                                                                          openValidationDialog(lableModel.enterScanMsg!, igmNoFocusNode);


                                                                                                                        }
                                                                                                                      }else{
                                                                                                                        openValidationDialog(lableModel.enterLocationMsg!, locationFocusNode);

                                                                                                                      }
                                                                                                                    },
                                                                                                                  child: SvgPicture.asset(search, height: SizeConfig.blockSizeVertical * 6,),

                                                                                                                ),
                                                                                                              ],
                                                                                                            ),
                                                                                                          ),*/

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

  Future<void> _selectDate(BuildContext context) async {
    _isDatePickerOpen = true;

    final DateTime now = DateTime.now();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? now,
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );

    if (locationController.text.isNotEmpty) {
      if (flightNoEditingController.text.isNotEmpty) {
        if (picked != null) {
          setState(() {
            _selectedDate = picked;
            dateEditingController.text = DateFormat('dd-MMM-yy').format(_selectedDate!).toUpperCase();

            ataDateEditingController.clear();
            ataTimeEditingController.clear();
            igmNoEditingController.clear();
            flightCheckULDListModel = null;
            flightCheckSummaryModel = null;
            _isOpenULDFlagEnable = false;
            originalFlightDetails.clear();
            flightDetailsList.clear();

            _tabController.animateTo(0);
            _pageIndex = 0;
            setState(() {});

            WidgetsBinding.instance.addPostFrameCallback(
              (_) {
                FocusScope.of(context).requestFocus(flightBtnFocusNode);
              },
            );
          });

          //  When Record ATA CALL GET FlightCheck ULD List
          callFlightCheckULDListApi(
              context,
              locationController.text,
              "",
              flightNoEditingController.text,
              dateEditingController.text,
              _user!.userProfile!.userIdentity!,
              _splashDefaultData!.companyCode!,
              widget.menuId,
              (_isOpenULDFlagEnable == true) ? 1 : 0);
        }
        else {
          WidgetsBinding.instance.addPostFrameCallback((_) {
              FocusScope.of(context).requestFocus(flightNoFocusNode);
            },
          );
        }
      } else {
        openValidationDialog(widget.lableModel!.enterFlightNo!, flightNoFocusNode);
      }
    } else {
      openValidationDialog(widget.lableModel!.enterLocationMsg!, locationFocusNode);
    }

    // Ensure the flag is reset even if the dialog is dismissed without selection
    _isDatePickerOpen = false;

    // Manually unfocus to close the keyboard and ensure consistent behavior
    dateFocusNode.unfocus();
  }

  Future<void> _selectATADate(BuildContext context) async {
    _isATADatePickerOpen = true;



    if (locationController.text.isNotEmpty) {
      if (flightCheckULDListModel != null) {
        final DateTime now = DateTime.now();
        final DateTime? picked = await showDatePicker(
          context: context,
          initialDate: _selectedATADate ?? now,
          firstDate: DateTime(1900),
          lastDate: DateTime(2100),
        );

        if (picked != null) {
          setState(() {
            _selectedATADate = picked;
            ataDateEditingController.text = DateFormat('dd-MMM-yy').format(_selectedATADate!).toUpperCase();
            WidgetsBinding.instance.addPostFrameCallback((_) {
              FocusScope.of(context).requestFocus(ataTimeFocusNode);
            },
            );
          });
        }
        else {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            FocusScope.of(context).requestFocus(flightBtnFocusNode);
          },
          );
        }

      } else {
       // SnackbarUtil.showSnackbar(context, "Please search flight", MyColor.colorRed, icon: FontAwesomeIcons.times);
        WidgetsBinding.instance.addPostFrameCallback((_) {
          FocusScope.of(context).requestFocus(flightNoFocusNode);
        },
        );
       // openValidationDialog(widget.lableModel!.enterFlightNo!, flightNoFocusNode);
      }
    }
    else {
      openValidationDialog(widget.lableModel!.enterLocationMsg!, locationFocusNode);
    }





    // Ensure the flag is reset even if the dialog is dismissed without selection
    _isATADatePickerOpen = false;

    // Manually unfocus to close the keyboard and ensure consistent behavior
    ataDateFocusNode.unfocus();
  }

  Future<void> _selectTime(BuildContext context, LableModel lableModel) async {


    if (locationController.text.isNotEmpty) {
      if (flightCheckULDListModel != null) {
        _isTimePickerOpen = true;
        final TimeOfDay? result = await showTimePicker(
          context: context,
          initialTime: TimeOfDay.now(),
          builder: (context, child) {
            return MediaQuery(
              data: MediaQuery.of(context).copyWith(
                alwaysUse24HourFormat: false, // Set to true for 24-hour format
              ),
              child: child!,
            );
          },
        );

        if (result != null) {
          final now = DateTime.now();
          final DateTime dateTime = DateTime(
            now.year,
            now.month,
            now.day,
            result.hour,
            result.minute,
          );

          // Format to 24-hour format "HH:mm"
          final String formattedTime24Hour = DateFormat('HH:mm').format(dateTime);

          // Format to 12-hour format "hh:mm a"
          final String formattedTime12Hour = DateFormat('hh:mm a').format(dateTime);

          // Show custom dialog with selected time

          if(ataDateEditingController.text.isNotEmpty){
            await _showCustomTimeDialog(context, formattedTime24Hour, formattedTime12Hour, dateTime.hour, dateTime.minute, lableModel);
          }else{
            openValidationDialog("${lableModel.enterrecordatadate}", ataDateFocusNode);
          }

          ataDateFocusNode.unfocus();
        }
        else {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            FocusScope.of(context).requestFocus(flightNoFocusNode);
          },
          );
        }
      } else {
      //  SnackbarUtil.showSnackbar(context, "Please search flight", MyColor.colorRed, icon: FontAwesomeIcons.times);
        WidgetsBinding.instance.addPostFrameCallback((_) {
          FocusScope.of(context).requestFocus(flightNoFocusNode);
        },
        );
      }
    } else {
      openValidationDialog(widget.lableModel!.enterLocationMsg!, locationFocusNode);
    }






    // Ensure the flag is reset even if the dialog is dismissed without selection
    _isTimePickerOpen = false;

    // Manually unfocus to close the keyboard and ensure consistent behavior
    ataTimeFocusNode.unfocus();


  }

  Future<void> _showCustomTimeDialog(
      BuildContext context,
      String formattedTime24Hour,
      String formattedTime12Hour,
      int hours,
      int min,
      LableModel lableModel) async {
    return showDialog<void>(
      barrierColor: MyColor.colorBlack.withOpacity(0.5),
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: MyColor.colorWhite,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          title: CustomeText(
              text: '${lableModel.recordata}',
              fontColor: MyColor.primaryColorblue,
              fontSize: SizeConfig.textMultiplier * 2.5,
              fontWeight: FontWeight.w600,
              textAlign: TextAlign.start),
          content: CustomeText(
              text: '${lableModel.selectedTime} : $formattedTime24Hour',
              fontColor: MyColor.colorBlack,
              fontSize: SizeConfig.textMultiplier * 1.9,
              fontWeight: FontWeight.w500,
              textAlign: TextAlign.start),
          actions: <Widget>[
            TextButton(
              child: CustomeText(
                  text: '${lableModel.cancel}',
                  fontColor: MyColor.primaryColorblue,
                  fontSize: SizeConfig.textMultiplier * 1.5,
                  fontWeight: FontWeight.w500,
                  textAlign: TextAlign.start),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            TextButton(
              child: CustomeText(
                  text: '${lableModel.recordata}',
                  fontColor: MyColor.primaryColorblue,
                  fontSize: SizeConfig.textMultiplier * 1.5,
                  fontWeight: FontWeight.w500,
                  textAlign: TextAlign.start),
              onPressed: () {

                if(isButtonEnabled("recordata", buttonRightsList)){

                  // Perform actions with the selected time
                  Navigator.of(context).pop(); // Close the dialog
                  if (flightNoEditingController.text.isNotEmpty) {
                    if (dateEditingController.text.isNotEmpty) {

                      ataTimeEditingController.text = formattedTime24Hour;
                      if (flightCheckULDListModel != null) {
                        context.read<FlightCheckCubit>().recordATA(
                            hours,
                            min,
                            ataDateEditingController.text,
                            flightCheckULDListModel!
                                .flightDetailSummary!.flightSeqNo!,
                            _user!.userProfile!.userIdentity!,
                            _splashDefaultData!.companyCode!,
                            widget.menuId);
                      }
                      else {
                        openValidationDialog("${lableModel.validateFlightMsg}", flightBtnFocusNode);
                        ataDateEditingController.clear();
                        ataTimeEditingController.clear();
                      }

                      /*if (ataDateEditingController.text.isNotEmpty) {
                        if (ataTimeEditingController.text.isNotEmpty) {

                        } else {
                          openValidationDialog("${lableModel.enterrecordatadate}", ataDateFocusNode);
                        }
                      }
                      else {
                        openValidationDialog("${lableModel.enterrecordatatime}", ataTimeFocusNode);
                      }*/
                    } else {
                      openValidationDialog("${lableModel.enterFlightDate}", dateFocusNode);
                    }
                  }
                  else {
                    openValidationDialog("${lableModel.enterFlightNo}", flightNoFocusNode);
                  }
                }else{
                  SnackbarUtil.showSnackbar(context, ValidationMessageCodeUtils.AuthorisedRolesAndRightsMsg, MyColor.colorRed, icon: FontAwesomeIcons.times);
                  Vibration.vibrate(duration: 500);
                }


              },
            ),
          ],
        );
      },
    );
  }

  Widget isViewEnable(LableModel lableModel, int pageIndex, ui.TextDirection textDirection, AppLocalizations? localizations) {
    // page index = 0 -- List of ULD
    // page index = 1 -- Summary of ULDS
    // page index = 2 -- SLA

    if (pageIndex == 0) {
      return  Column(
        children: [

          (flightCheckULDListModel != null) ? Column(
            children: [
              SizedBox(height: SizeConfig.blockSizeVertical,),
              Directionality(
                textDirection: textDirection,
                child: GroupIdCustomTextField(
                  textDirection: textDirection,
                  hasIcon: true,
                  hastextcolor: true,
                  animatedLabel: false,
                  needOutlineBorder: true,
                  isIcon: true,
                  isSearch: true,
                  prefixIconcolor: MyColor.colorBlack,
                  hintText: "${lableModel.searchULD}",
                  readOnly: false,
                  onChanged: (value) {
                    updateSearchList(value);
                  },
                  fillColor: MyColor.colorWhite,
                  textInputType: TextInputType.text,
                  inputAction: TextInputAction.next,
                  hintTextcolor: MyColor.colorBlack.withOpacity(0.7),
                  verticalPadding: 0,
                  fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_8,
                  circularCorner: SizeConfig.blockSizeHorizontal * SizeUtils.CIRCULARBORDER,
                  boxHeight: SizeConfig.blockSizeVertical * SizeUtils.HEIGHT6,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Please fill out this field";
                    } else {
                      return null;
                    }
                  },
                ),
              ),
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
                          text: "${lableModel.showCompletionMsg}",
                          fontColor: MyColor.textColorGrey2,
                          fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                          fontWeight: FontWeight.w500,
                          textAlign: TextAlign.start)
                    ],
                  ),
                  Switch(
                    value: _isOpenULDFlagEnable,
                    materialTapTargetSize:
                    MaterialTapTargetSize.shrinkWrap,
                    activeColor: MyColor.primaryColorblue,
                    inactiveThumbColor: MyColor.thumbColor,
                    inactiveTrackColor: MyColor.textColorGrey2,
                    trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
                    onChanged: (value) {
                      setState(() {
                        _isOpenULDFlagEnable = value;
                      });

                      callFlightCheckULDListApi(
                          context,
                          locationController.text,
                          "",
                          flightNoEditingController.text,
                          dateEditingController.text,
                          _user!.userProfile!.userIdentity!,
                          _splashDefaultData!.companyCode!,
                          widget.menuId,
                          (value == true) ? 1 : 0);
                    },
                  )
                ],
              ),
            ],
          ) : const SizedBox(),


          SizedBox(height: SizeConfig.blockSizeVertical,),
          (flightCheckULDListModel != null)
              ? (flightCheckULDListModel!.flightDetailList!.isNotEmpty)
              ? ListView.builder(
            itemCount: (flightCheckULDListModel != null)
                ? flightDetailsList.length
                : 0,
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            controller: scrollController,
            itemBuilder: (context, index) {
              FlightDetailList flightDetails = flightDetailsList[index];
              bool isSelected = _selectedIndex == index;

              List<String> shcCodes = flightDetails.sHCCode!.split(',');

              List<String> uldParts = "${flightDetails.uLDNo}".split(' ');

              // Assign the parts to meaningful variables
              String uldType = uldParts[0]; // Third part (ULD owner)
              String uldNo = " ${uldParts[1]} "; // Third part (ULD owner)
              String uldOwner = uldParts[2]; // Third part (ULD owner)

              final ValueNotifier<double> _valueNotifier1 = ValueNotifier(0);
              // Color backgroundColor = MyColor.colorList[index %  MyColor.colorList.length];

              return InkWell(
                focusNode: uldListFocusNode,
                onTap: () {
                  FocusScope.of(context).unfocus();
                  setState(() {
                    _selectedIndex = index; // Update the selected index
                  });
                },
                onDoubleTap: () {

                  setState(() {
                    _selectedIndex = index; // Update the selected index
                  });
                  openBottomDialog(
                      context,
                      flightDetails.uLDNo!,
                      flightDetails.damageNOP!,
                      flightDetails,
                      lableModel,
                      widget.mainMenuName);
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
                    /*image: flightDetails.sHCCode!.contains("DGR")
                                  ? DecorationImage(
                                image: AssetImage(dangerBorder), // your image path
                                fit: BoxFit.cover, // Ensures the image covers the entire container
                              )
                                  : null, // No image if the condition is false*/
                  ),
                  child: DottedBorder(
                    dashPattern: const [7, 7, 7, 7],
                    strokeWidth: 1,
                    borderType: BorderType.RRect,
                    color: flightDetails.sHCCode!.contains("DGR") ? MyColor.colorRedLight : Colors.transparent,
                    radius: const Radius.circular(8),
                    child: Container(
                      // margin: flightDetails.sHCCode!.contains("DGR") ? EdgeInsets.all(3) : EdgeInsets.all(0),
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        /* border: Border.all(
                                      color: isSelected
                                          ? MyColor.primaryColorblue
                                          : MyColor.primaryColorblue
                                          .withOpacity(0.3),
                                      width: isSelected ? 1 : 0),*/
                        color: MyColor.colorWhite,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Stack(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  CustomeText(text: "${flightDetails.uLDNo}", fontColor: MyColor.colorBlack, fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_6, fontWeight: FontWeight.w600, textAlign: TextAlign.start),
                                  SizedBox(width: SizeConfig.blockSizeHorizontal),
                                  /* (flightDetails.sHCCode!.contains("DGR")
                                                ? SvgPicture.asset(dgrIcon, height: SizeConfig.blockSizeVertical * SizeUtils.ICONSIZE2,)
                                                : SizedBox()),*/



                                  (/*flightDetails.damageNOP != 0 ||*/ flightDetails.damageConditionCode!.isNotEmpty)
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
                                  )
                                      : const SizedBox(),

                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      (flightDetails.isIntact!.replaceAll(" ", "").isNotEmpty)
                                          ? (flightDetails.isIntact! == "Y")
                                          ? Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 2),
                                        child:
                                        Container(
                                          width: SizeConfig.blockSizeVertical * SizeUtils.TEXTSIZE_2_2,  // Set width and height for the circle
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            border: Border.all(  // Add border
                                              color: MyColor.primaryColorblue,  // Border color
                                              width: 1.3,  // Border width
                                            ),
                                          ),
                                          child: Center(
                                            child: CustomeText(
                                                text: "I",
                                                fontColor: MyColor.primaryColorblue,
                                                fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_3,
                                                fontWeight: FontWeight.w500,
                                                textAlign: TextAlign.center),
                                          ),
                                        ),
                                      )
                                          : const SizedBox()
                                          : const SizedBox(),
                                      (flightDetails.transit!.isNotEmpty) ? Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 2),
                                        child: Container(
                                          width: SizeConfig.blockSizeVertical * SizeUtils.TEXTSIZE_2_2,  // Set width and height for the circle
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            border: Border.all(  // Add border
                                              color: MyColor.primaryColorblue,  // Border color
                                              width: 1.3,  // Border width
                                            ),
                                          ),
                                          child: CustomeText(
                                              text: "${flightDetails.transit}",
                                              fontColor: MyColor.primaryColorblue,
                                              fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_3,
                                              fontWeight: FontWeight.w500,
                                              textAlign: TextAlign.center),
                                        ),
                                      )
                                          : const SizedBox(),
                                    ],
                                  )


                                ],
                              ),
                              flightDetails.sHCCode!.isNotEmpty ? SizedBox(height: SizeConfig.blockSizeVertical) : SizedBox(height: SizeConfig.blockSizeVertical * SizeUtils.HEIGHT2),
                              flightDetails.sHCCode!.isNotEmpty
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
                                children: [
                                  Row(
                                    children: [
                                      CustomeText(
                                        text: "${lableModel.shipment}",
                                        fontColor: MyColor.textColorGrey2,
                                        fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_3,
                                        fontWeight: FontWeight.w400,
                                        textAlign: TextAlign.start,
                                      ),
                                      const SizedBox(width: 5),
                                      CustomeText(
                                        text: "${flightDetails.shipment}",
                                        fontColor: MyColor.colorBlack,
                                        fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                        fontWeight: FontWeight.w600,
                                        textAlign: TextAlign.start,
                                      ),
                                    ],
                                  ),
                                  SizedBox(width: SizeConfig.blockSizeHorizontal * SizeUtils.WIDTH2,),
                                  Row(
                                    children: [
                                      CustomeText(
                                        text: "${lableModel.scanned}",
                                        fontColor: MyColor.textColorGrey2,
                                        fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_3,
                                        fontWeight: FontWeight.w400,
                                        textAlign: TextAlign.start,
                                      ),
                                      const SizedBox(width: 5),
                                      CustomeText(
                                        text: "${flightDetails.scanned}",
                                        fontColor: MyColor.colorBlack,
                                        fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                        fontWeight: FontWeight.w600,
                                        textAlign: TextAlign.start,
                                      ),
                                    ],
                                  ),
                                  SizedBox(width: SizeConfig.blockSizeHorizontal * SizeUtils.WIDTH2,),
                                  Row(
                                    children: [
                                      CustomeText(
                                        text: "${lableModel.damagedPCS}",
                                        fontColor: MyColor.textColorGrey2,
                                        fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_3,
                                        fontWeight: FontWeight.w400,
                                        textAlign: TextAlign.start,
                                      ),
                                      const SizedBox(width: 5),
                                      CustomeText(
                                        text: "${flightDetails.damageNOP}",
                                        fontColor: MyColor.colorBlack,
                                        fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                        fontWeight: FontWeight.w600,
                                        textAlign: TextAlign.start,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(height: SizeConfig.blockSizeVertical,),
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
                                              text: "P - ${flightDetails.bDPriority}",
                                              fontColor: MyColor.textColorGrey3,
                                              fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                              fontWeight: FontWeight.w700,
                                              textAlign: TextAlign.center),
                                          SizedBox(width: SizeConfig.blockSizeHorizontal,),
                                          SvgPicture.asset(pen, height: SizeConfig.blockSizeVertical * SizeUtils.HEIGHT_1_5,)
                                        ],
                                      ),
                                      onTap: () {
                                        setState(() {
                                          _selectedIndex = index; // Update the selected index
                                        });
                                        openEditPriorityBottomDialog(
                                            context,
                                            flightDetails.uLDNo!,
                                            "${flightDetails.bDPriority}",
                                            index,
                                            flightDetails,
                                            lableModel,
                                            textDirection);
                                      },
                                    ),
                                  ),
                                  Row(
                                    children: [

                                      Container(
                                        padding : EdgeInsets.symmetric(horizontal: SizeConfig.blockSizeHorizontal * 2.5, vertical: SizeConfig.blockSizeVertical * 0.1),
                                        decoration : BoxDecoration(
                                            borderRadius: BorderRadius.circular(20),
                                            color: flightDetails.bDEndStatus == "Y" ? MyColor.flightFinalize : MyColor.transparentColor
                                        ),
                                        child: CustomeText(
                                          text: flightDetails.bDEndStatus == "Y" ? "${lableModel.bdDone}" : "",
                                          fontColor: MyColor.textColorGrey3,
                                          fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_35,
                                          fontWeight: FontWeight.w400,
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                      SizedBox(width: SizeConfig.blockSizeHorizontal * SizeUtils.WIDTH2,),



                                      Container(
                                        padding : EdgeInsets.symmetric(horizontal: SizeConfig.blockSizeHorizontal * 2.5, vertical: SizeConfig.blockSizeVertical * 0.1),
                                        decoration : BoxDecoration(
                                            borderRadius: BorderRadius.circular(20),
                                            color: flightDetails.uldAcceptStatus == "A" ? MyColor.flightNotArrived : MyColor.flightFinalize
                                        ),
                                        child: CustomeText(
                                          text: flightDetails.uldAcceptStatus == "A" ? lableModel.notaccepted!.toUpperCase() : lableModel.accepted!.toUpperCase(),
                                          fontColor: MyColor.textColorGrey3,
                                          fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_35,
                                          fontWeight: FontWeight.w400,
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                      SizedBox(width: SizeConfig.blockSizeHorizontal * SizeUtils.WIDTH2,),

                                      InkWell(
                                        onTap: () {
                                          setState(() {
                                            _selectedIndex = index; // Update the selected index
                                          });
                                          openBottomDialog(
                                              context,
                                              flightDetails.uLDNo!,
                                              flightDetails.damageNOP!,
                                              flightDetails,
                                              lableModel,
                                              widget.mainMenuName);
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

                          (localizations!.locale.languageCode == CommonUtils.ARABICCULTURECODE)
                              ? Positioned(
                            left: 0,
                            top: 0,
                            child: Container(
                              height : SizeConfig.blockSizeVertical * SizeUtils.HEIGHT6,
                              width : SizeConfig.blockSizeVertical * SizeUtils.HEIGHT6,
                              child: DashedCircularProgressBar.aspectRatio(
                                aspectRatio: 2.1, // width ÷ height
                                valueNotifier: _valueNotifier1,
                                progress: flightDetails.progress!.toDouble(),
                                maxProgress: 100,
                                corners: StrokeCap.butt,
                                foregroundColor: (flightDetails.progress!.toDouble() == 100) ? MyColor.colorgreenProgress  : MyColor.colorOrangeProgress,
                                backgroundColor: const Color(0xffF2F4F8),
                                foregroundStrokeWidth: 5,
                                backgroundStrokeWidth: 5,
                                animation: true,
                                child: Center(
                                  child: ValueListenableBuilder(
                                    valueListenable: _valueNotifier1,
                                    builder: (_, double value, __) {
                                      return CustomeText(text: '${value.toInt()}%', fontColor:  MyColor.colorBlack, fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_3, fontWeight: FontWeight.w500, textAlign: TextAlign.center);
                                    },
                                  ),
                                ),


                              ),
                            ),
                          )
                              : Positioned(
                            right: 0,
                            top: 0,
                            child: Container(
                              height : SizeConfig.blockSizeVertical * SizeUtils.HEIGHT6,
                              width : SizeConfig.blockSizeVertical * SizeUtils.HEIGHT6,
                              child: DashedCircularProgressBar.aspectRatio(
                                aspectRatio: 2.1, // width ÷ height
                                valueNotifier: _valueNotifier1,
                                progress: flightDetails.progress!.toDouble(),
                                maxProgress: 100,
                                corners: StrokeCap.butt,
                                foregroundColor: (flightDetails.progress!.toDouble() == 100) ? MyColor.colorgreenProgress  : MyColor.colorOrangeProgress,
                                backgroundColor: const Color(0xffF2F4F8),
                                foregroundStrokeWidth: 5,
                                backgroundStrokeWidth: 5,
                                animation: true,
                                child: Center(
                                  child: ValueListenableBuilder(
                                    valueListenable: _valueNotifier1,
                                    builder: (_, double value, __) {
                                      return CustomeText(text: '${value.toInt()}%', fontColor:  MyColor.colorBlack, fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_3, fontWeight: FontWeight.w500, textAlign: TextAlign.center);
                                    },
                                  ),
                                ),


                              ),
                            ),
                          ),

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
          ) : Center(
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
          )

        ],
      );

    }

    if (pageIndex == 1) {
      // design of a summary
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: SizeConfig.blockSizeVertical,),
          // text pieces of ULD
          Container(
            padding: const EdgeInsets.all(8),
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: CustomeText(
                      text: "PIECES BREAKUP".toUpperCase(),
                      fontColor: MyColor.colorBlack,
                      fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                      fontWeight: FontWeight.w600,
                      textAlign: TextAlign.start),
                ),


                Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: MyColor.cardBgColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          children: [
                            CustomeText(
                                text: "${lableModel.cargo}".toUpperCase(),
                                fontColor: MyColor.colorBlack,
                                fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                fontWeight: FontWeight.w600,
                                textAlign: TextAlign.start),
                            SizedBox(height: SizeConfig.blockSizeVertical,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  children: [
                                    CustomeText(
                                        text: (flightCheckSummaryModel != null)
                                            ? "${flightCheckSummaryModel!.flightSummary!.nPX!}"
                                            : "0",
                                        fontColor: MyColor.colorBlack,
                                        fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_6,
                                        fontWeight: FontWeight.w600,
                                        textAlign: TextAlign.center),

                                    CustomeText(
                                        text: "${lableModel.manifest}",
                                        fontColor: MyColor.textColorGrey2,
                                        fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_3,
                                        fontWeight: FontWeight.w400,
                                        textAlign: TextAlign.center)



                                  ],
                                ),
                                Column(
                                  children: [
                                    CustomeText(
                                        text: (flightCheckSummaryModel != null)
                                            ? "${flightCheckSummaryModel!.flightSummary!.nPR!}"
                                            : "0",
                                        fontColor: MyColor.colorBlack,
                                        fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_6,
                                        fontWeight: FontWeight.w600,
                                        textAlign: TextAlign.center),

                                    CustomeText(
                                        text: "${lableModel.recived}",
                                        fontColor: MyColor.textColorGrey2,
                                        fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_3,
                                        fontWeight: FontWeight.w400,
                                        textAlign: TextAlign.center)
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(width: SizeConfig.blockSizeHorizontal * SizeUtils.WIDTH3,),
                    Expanded(
                      flex: 2,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: MyColor.cardBgColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          children: [
                            CustomeText(
                                text: "${lableModel.mail}".toUpperCase(),
                                fontColor: MyColor.colorBlack,
                                fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                fontWeight: FontWeight.w600,
                                textAlign: TextAlign.start),
                            SizedBox(height: SizeConfig.blockSizeVertical,),
                            Column(
                              children: [
                                CustomeText(
                                    text: (flightCheckSummaryModel != null)
                                        ? "${flightCheckSummaryModel!.flightSummary!.mailNOP!}"
                                        : "0",
                                    fontColor: MyColor.colorBlack,
                                    fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_6,
                                    fontWeight: FontWeight.w600,
                                    textAlign: TextAlign.center),

                                CustomeText(
                                    text: "${lableModel.recived}",
                                    fontColor: MyColor.textColorGrey2,
                                    fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_3,
                                    fontWeight: FontWeight.w400,
                                    textAlign: TextAlign.center)



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
          SizedBox(height: SizeConfig.blockSizeVertical,),
          // text pieces of ULD

          Container(
            padding: const EdgeInsets.all(8),
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: CustomeText(
                      text: "WEIGHT BREAKUP".toUpperCase(),
                      fontColor: MyColor.colorBlack,
                      fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                      fontWeight: FontWeight.w600,
                      textAlign: TextAlign.start),
                ),


                Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: MyColor.cardBgColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          children: [
                            CustomeText(
                                text: "${lableModel.cargo}".toUpperCase(),
                                fontColor: MyColor.colorBlack,
                                fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                fontWeight: FontWeight.w600,
                                textAlign: TextAlign.start),
                            SizedBox(height: SizeConfig.blockSizeVertical,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  children: [
                                    CustomeText(
                                        text: (flightCheckSummaryModel != null)
                                            ? CommonUtils.formateToTwoDecimalPlacesValue(flightCheckSummaryModel!.flightSummary!.weightExp!)
                                            : "0",
                                        fontColor: MyColor.colorBlack,
                                        fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_6,
                                        fontWeight: FontWeight.w600,
                                        textAlign: TextAlign.center),

                                    CustomeText(
                                        text: "${lableModel.manifest}",
                                        fontColor: MyColor.textColorGrey2,
                                        fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_3,
                                        fontWeight: FontWeight.w400,
                                        textAlign: TextAlign.center)



                                  ],
                                ),
                                Column(
                                  children: [
                                    CustomeText(
                                        text: (flightCheckSummaryModel != null)
                                            ? CommonUtils.formateToTwoDecimalPlacesValue(flightCheckSummaryModel!.flightSummary!.weightRec!)
                                            : "0",
                                        fontColor: MyColor.colorBlack,
                                        fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_6,
                                        fontWeight: FontWeight.w600,
                                        textAlign: TextAlign.center),

                                    CustomeText(
                                        text: "${lableModel.recived}",
                                        fontColor: MyColor.textColorGrey2,
                                        fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_3,
                                        fontWeight: FontWeight.w400,
                                        textAlign: TextAlign.center)
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(width: SizeConfig.blockSizeHorizontal * SizeUtils.WIDTH3,),
                    Expanded(
                      flex: 2,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: MyColor.cardBgColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          children: [
                            CustomeText(
                                text: "${lableModel.mail}".toUpperCase(),
                                fontColor: MyColor.colorBlack,
                                fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                fontWeight: FontWeight.w600,
                                textAlign: TextAlign.start),
                            SizedBox(height: SizeConfig.blockSizeVertical,),
                            Column(
                              children: [
                                CustomeText(
                                    text: (flightCheckSummaryModel != null)
                                        ? CommonUtils.formateToTwoDecimalPlacesValue(flightCheckSummaryModel!.flightSummary!.mailWeight!)
                                        : "0",
                                    fontColor: MyColor.colorBlack,
                                    fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_6,
                                    fontWeight: FontWeight.w600,
                                    textAlign: TextAlign.center),

                                CustomeText(
                                    text: "${lableModel.recived}",
                                    fontColor: MyColor.textColorGrey2,
                                    fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_3,
                                    fontWeight: FontWeight.w400,
                                    textAlign: TextAlign.center)



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


          SizedBox(height: SizeConfig.blockSizeVertical,),

          Container(
            padding: const EdgeInsets.all(8),
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: CustomeText(
                      text: "Discrepancy".toUpperCase(),
                      fontColor: MyColor.colorBlack,
                      fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                      fontWeight: FontWeight.w600,
                      textAlign: TextAlign.start),
                ),


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
                                  text: (flightCheckSummaryModel != null)
                                      ? "${flightCheckSummaryModel!.flightSummary!.shortLanded!}"
                                      : "0",
                                  fontColor: MyColor.colorBlack,
                                  fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_6,
                                  fontWeight: FontWeight.w600,
                                  textAlign: TextAlign.center),

                              CustomeText(
                                  text: "${lableModel.short}",
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
                                  text: (flightCheckSummaryModel != null)
                                      ? "${flightCheckSummaryModel!.flightSummary!.excessLanded!}"
                                      : "0",
                                  fontColor: MyColor.colorBlack,
                                  fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_6,
                                  fontWeight: FontWeight.w600,
                                  textAlign: TextAlign.center),

                              CustomeText(
                                  text: "${lableModel.excess}",
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
                                  text: (flightCheckSummaryModel != null)
                                      ? "${flightCheckSummaryModel!.flightSummary!.damagePkgs!}"
                                      : "0",
                                  fontColor: MyColor.colorBlack,
                                  fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_6,
                                  fontWeight: FontWeight.w600,
                                  textAlign: TextAlign.center),

                              CustomeText(
                                  text: "${lableModel.damaged}",
                                  fontColor: MyColor.textColorGrey2,
                                  fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_3,
                                  fontWeight: FontWeight.w400,
                                  textAlign: TextAlign.center)
                            ],
                          )),
                    ],
                  ),
                ),
              ],
            ),
          ),


          SizedBox(height: SizeConfig.blockSizeVertical,),
          // add finalize flight button to click and call api
          RoundedButtonBlue(
            text: "${lableModel.finalizeflight}",
            press: () async {

              if(isButtonEnabled("finalizeflight", buttonRightsList)){
                if (flightNoEditingController.text.isNotEmpty) {
                  if (dateEditingController.text.isNotEmpty) {
                    // call api for flight finalize

                    bool? flightFinalized = await DialogUtils.showFlightFinalizeDialog(context, lableModel);
                    if (flightFinalized == true) {
                      // call api for flight finalize
                      context.read<FlightCheckCubit>().finalizeFlight(flightCheckULDListModel!.flightDetailSummary!.flightSeqNo!, _user!.userProfile!.userIdentity!, _splashDefaultData!.companyCode!, widget.menuId);
                    }

                  } else {
                    openValidationDialog("${lableModel.enterFlightDate}", dateFocusNode);
                  }
                }
                else {
                  openValidationDialog("${lableModel.enterFlightNo}", flightNoFocusNode);
                }
              }else{
                SnackbarUtil.showSnackbar(context, ValidationMessageCodeUtils.AuthorisedRolesAndRightsMsg, MyColor.colorRed, icon: FontAwesomeIcons.times);
                Vibration.vibrate(duration: 500);
              }


            },
          )
        ],
      );
    }

    else if (pageIndex == 2) {
      return  Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: CustomeText(
              text: "Comming Soon",
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

  // open dialog for damage and start button showing
  Future<void> openBottomDialog(
      BuildContext context,
      String uldNo,
      int damageNop,
      FlightDetailList flightDetails,
      LableModel lableModel,
      String mainMenuName) async {

    int? checkNextOrNot = await DialogUtils.showBottomULDDialog(
        context,
        uldNo,
        damageNop,
        flightDetails.damageConditionCode!,
        lableModel,
        flightDetails.uldAcceptStatus!, buttonRightsList);

    if (checkNextOrNot == 2) {
      if (flightDetails.uldAcceptStatus == "D") {
        inactivityTimerManager!.stopTimer();

        if(flightDetails.shipment == 0){
          SnackbarUtil.showSnackbar(context, "${lableModel.noShipmentFound}", MyColor.colorRed, icon: FontAwesomeIcons.times);
        }else{
          var value = await Navigator.push(
              context,
              CupertinoPageRoute(
                  builder: (context) => AWBListPage(
                    importSubMenuList: widget.importSubMenuList,
                    exportSubMenuList: widget.exportSubMenuList,
                    buttonRightsList: buttonRightsList,
                    mainMenuName: mainMenuName,
                    uldNo: uldNo,
                    flightDetailSummary: flightCheckULDListModel!.flightDetailSummary!,
                    uldSeqNo: flightDetails.uLDId!,
                    menuId: widget.menuId,
                    location: locationController.text,
                    awbRemarkRequires: awbRemarkRequires,
                    lableModel: lableModel,
                    groupIDRequires: groupIDRequires,
                    groupIDCharSize: groupIDCharSize,
                    bDEndStatus: flightDetails.bDEndStatus!,
                  )));
          if(value == "true"){
            _resumeTimerOnInteraction();
            callFlightCheckULDListApi(
                context,
                locationController.text,
                igmNoEditingController.text,
                flightNoEditingController.text,
                dateEditingController.text,
                _user!.userProfile!.userIdentity!,
                _splashDefaultData!.companyCode!,
                widget.menuId,
                (_isOpenULDFlagEnable == true) ? 1 : 0);
          }
          else if(value == "Done"){
            _resumeTimerOnInteraction();
            callFlightCheckULDListApi(
                context,
                locationController.text,
                igmNoEditingController.text,
                flightNoEditingController.text,
                dateEditingController.text,
                _user!.userProfile!.userIdentity!,
                _splashDefaultData!.companyCode!,
                widget.menuId,
                (_isOpenULDFlagEnable == true) ? 1 : 0);
          }
        }

     

      } else {}
    }
    else if (checkNextOrNot == 1) {
      if (flightDetails.uldAcceptStatus == "D") {
        inactivityTimerManager!.stopTimer();
        String damageOrNot = await Navigator.push(
            context,
            CupertinoPageRoute(
              builder: (context) => UldDamagedPage(
                importSubMenuList: widget.importSubMenuList,
                exportSubMenuList: widget.exportSubMenuList,
                locationCode: locationController.text,
                menuId: widget.menuId,
                ULDNo: flightDetails.uLDNo!,
                ULDSeqNo: flightDetails.uLDId!,
                flightSeqNo: flightCheckULDListModel!.flightDetailSummary!.flightSeqNo!,
                groupId: flightDetails.groupId!,
                menuCode: widget.refrelCode,
                isRecordView: flightDetails.damageNOP == 0 ? flightDetails.damageConditionCode!.isEmpty ? 0 : 2 : 2,
                mainMenuName: widget.mainMenuName,
                buttonRightsList: buttonRightsList,
              ),
            ));

        // RETURN FROM DAMAGE SCREEN API CALL
        if (damageOrNot == "U") {
          _resumeTimerOnInteraction();
          callFlightCheckULDListApi(
              context,
              locationController.text,
              igmNoEditingController.text,
              flightNoEditingController.text,
              dateEditingController.text,
              _user!.userProfile!.userIdentity!,
              _splashDefaultData!.companyCode!,
              widget.menuId,
              (_isOpenULDFlagEnable == true) ? 1 : 0);
        } else if (damageOrNot == "S") {
          _resumeTimerOnInteraction();
          callFlightCheckULDListApi(
              context,
              locationController.text,
              igmNoEditingController.text,
              flightNoEditingController.text,
              dateEditingController.text,
              _user!.userProfile!.userIdentity!,
              _splashDefaultData!.companyCode!,
              widget.menuId,
              (_isOpenULDFlagEnable == true) ? 1 : 0);
        }else{
          _resumeTimerOnInteraction();
        }
      } else {}
    }
    else if (checkNextOrNot == 3) {
      if (flightDetails.uldAcceptStatus == "D") {
        inactivityTimerManager!.stopTimer();
        var value = await Navigator.push(
            context,
            CupertinoPageRoute(
                builder: (context) => AddMailPage(
                  importSubMenuList: widget.importSubMenuList,
                  exportSubMenuList: widget.exportSubMenuList,
                  buttonRightsList: buttonRightsList,
                  uldNo: flightDetails.uLDNo!,
                  mainMenuName: mainMenuName,
                  uldSeqNo: flightDetails.uLDId!,
                  flightSeqNo: flightCheckULDListModel!.flightDetailSummary!.flightSeqNo!,
                  menuId: widget.menuId,
                  lableModel: lableModel,
                )));
        if(value == "Done"){
          _resumeTimerOnInteraction();
        }

      } else {}
    }
  }

  // open dialog for chnage bdpriority
  Future<void> openEditPriorityBottomDialog(
      BuildContext context,
      String uldNo,
      String priority,
      int index,
      FlightDetailList flightDetails,
      LableModel lableModel,
      ui.TextDirection textDirection) async {
    FocusScope.of(context).unfocus();
    String? updatedPriority = await DialogUtils.showPriorityChangeBottomULDDialog(context, uldNo, priority, lableModel, textDirection);
    if (updatedPriority != null) {
      int newPriority = int.parse(updatedPriority);

      if (newPriority != 0) {
        // Call your API to update the priority in the backend
        await callbdPriorityApi(
            context,
            flightCheckULDListModel!.flightDetailSummary!.flightSeqNo!,
            flightDetails.uLDId!,
            newPriority,
            _user!.userProfile!.userIdentity!,
            _splashDefaultData!.companyCode!,
            widget.menuId);

        setState(() {
          // Update the BDPriority for the selected item
          flightDetailsList[index].bDPriority = newPriority;

          // Sort the list based on BDPriority
          flightDetailsList.sort((a, b) => b.bDPriority!.compareTo(a.bDPriority!));
        });
      } else {
        Vibration.vibrate(duration: 500);
        SnackbarUtil.showSnackbar(context, "${lableModel.prioritymsg}", MyColor.colorRed, icon: FontAwesomeIcons.times);
      }
    } else {

    }
  }

  // update serch list function
  void updateSearchList(String searchText) {
    setState(() {
      _selectedIndex = -1;
      if (searchText.isEmpty) {
        // If search text is cleared, revert to original list
        flightDetailsList = List.from(originalFlightDetails);
        flightDetailsList.sort((a, b) => b.bDPriority!.compareTo(a.bDPriority!));
      } else {
        // Filter and sort the list based on search text
        flightDetailsList = List.from(originalFlightDetails);
        flightDetailsList.sort((a, b) {
          final aContains = a.uLDNo!
              .replaceAll(" ", "")
              .toLowerCase()
              .contains(searchText.toLowerCase());
          final bContains = b.uLDNo!
              .replaceAll(" ", "")
              .toLowerCase()
              .contains(searchText.toLowerCase());
          final aContainsGroup = a.groupId!.toLowerCase().contains(searchText.toLowerCase());
          final bContainsGroup = b.groupId!.toLowerCase().contains(searchText.toLowerCase());

          if (aContains && !bContains || (aContainsGroup && !bContainsGroup)) {
            return -1;
          } else if (!aContains && bContains || (!aContainsGroup && bContainsGroup)) {
            return 1;
          } else {
            return 0;
          }
        });
      }
    });
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
        context.read<FlightCheckCubit>().getValidateLocation(
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
        callFlightCheckULDListApi(context, locationController.text, truncatedResult, "", "1900-01-01", _user!.userProfile!.userIdentity!, _splashDefaultData!.companyCode!, widget.menuId, (_isOpenULDFlagEnable == true) ? 1 : 0);
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
    context.read<FlightCheckCubit>().getFlightCheckULDList(
        locationCode,
        scan,
        flightNo.replaceAll(" ", ""),
        flightDate,
        userId,
        companyCode,
        menuId,
        ULDListFlag);
  }

  // flight check Summary details api call function
  void callFlightCheckSummaryApi(BuildContext context, int flightSeqNo,
      int userId, int companyCode, int menuId) {
    context
        .read<FlightCheckCubit>()
        .getFlightCheckSummaryDetails(flightSeqNo, userId, companyCode, menuId);
  }

  // bd priority chnage api call function
  Future<void> callbdPriorityApi(
      BuildContext context,
      int flightSeqNo,
      int uldSeqNo,
      int bdPriority,
      int userId,
      int companyCode,
      int menuId) async {
    await context.read<FlightCheckCubit>().bdPriority(
        flightSeqNo, uldSeqNo, bdPriority, userId, companyCode, menuId);
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

bool isButtonEnabled(String buttonId, List<ButtonRight> buttonList) {
  ButtonRight? button = buttonList.firstWhere(
        (button) => button.buttonId == buttonId,
  );
  return button.isEnable == 'Y';
}



// ticker animation for DGR code blink animation
class TickerProviders extends TickerProvider {
  @override
  Ticker createTicker(onTick) => Ticker(onTick);
}
