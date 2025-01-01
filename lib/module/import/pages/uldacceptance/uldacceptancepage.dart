import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:galaxy/core/images.dart';
import 'package:galaxy/language/model/lableModel.dart';
import 'package:galaxy/module/import/model/uldacceptance/flightfromuldmodel.dart';
import 'package:galaxy/module/import/pages/uldacceptance/ulddamagedpage.dart';
import 'package:galaxy/module/import/services/uldacceptance/uldacceptancelogic/uldacceptancecubit.dart';
import 'package:galaxy/module/import/services/uldacceptance/uldacceptancelogic/uldacceptancestate.dart';
import 'package:galaxy/utils/dialogutils.dart';
import 'package:galaxy/utils/snackbarutil.dart';
import 'package:galaxy/widget/customedrawer/customedrawer.dart';
import 'package:galaxy/widget/custometext.dart';
import 'package:galaxy/widget/customeuiwidgets/searchwidget.dart';
import 'package:galaxy/widget/header/mainheadingwidget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:vibration/vibration.dart';
import '../../../../core/mycolor.dart';
import '../../../../language/appLocalizations.dart';
import '../../../../manager/timermanager.dart';
import '../../../../prefrence/savedprefrence.dart';
import '../../../../utils/commonutils.dart';
import '../../../../utils/sizeutils.dart';
import '../../../../utils/uldvalidationutil.dart';
import '../../../../utils/validationmsgcodeutils.dart';
import '../../../../widget/customdivider.dart';
import '../../../../widget/customebuttons/roundbuttonblue.dart';
import '../../../../widget/customeedittext/customeedittextwithborder.dart';
import '../../../../widget/customeuiwidgets/header.dart';
import '../../../../widget/customtextfield.dart';
import '../../../../widget/groupidcustomtextfield.dart';
import '../../../login/pages/signinscreenmethods.dart';
import '../../../profile/page/profilepagescreen.dart';
import '../../../splash/model/splashdefaultmodel.dart';
import '../../../onboarding/sizeconfig.dart';
import 'dart:ui' as ui;

import '../../../login/model/userlogindatamodel.dart';
import '../../../submenu/model/submenumodel.dart';
import '../../model/uldacceptance/buttonrolesrightsmodel.dart';
import '../../model/uldacceptance/uldacceptancedetailmodel.dart';


class UldAcceptancePage extends StatefulWidget {
  String mainMenuName;
  String title;
  String refrelCode;
  LableModel? lableModel;
  int menuId;
  List<SubMenuName> importSubMenuList = [];
  List<SubMenuName> exportSubMenuList = [];


  UldAcceptancePage({
    super.key,
    required this.importSubMenuList,
    required this.exportSubMenuList,
    required this.title,
    required this.refrelCode,
    this.lableModel,
    required this.mainMenuName,
    required this.menuId
  });

  @override
  State<UldAcceptancePage> createState() => _UldAcceptancePageState();
}

class _UldAcceptancePageState extends State<UldAcceptancePage> with SingleTickerProviderStateMixin {

  InactivityTimerManager? inactivityTimerManager;

  int btCount = 0;
  int btCountTrolly = 0;
  int _pageIndex = 0;
  String _uldTrollyAcceptance = "";
  String _isGroupIdIsMandatory = "";

  Map<String, String>? validationMessages;

  bool _isScrollable = false;
  bool _isAtTop = true;
  bool _isAtBottom  = false;

  final GlobalKey _contentKey = GlobalKey();
  double contentHeight = 0.0;
  double screenHeight = 0.0;
  final ScrollController _scrollController = ScrollController();


  final SavedPrefrence savedPrefrence = SavedPrefrence();
  UserDataModel? _user;
  SplashDefaultModel? _splashDefaultData;
  FlightFromULDModel? flightFromULDModel;

  List<ULDDetails> uldList = [];
  List<TrollyDetails> trollyList = [];
  List<ULDDetails> filteredUldModelList = [];
  List<ButtonRight> buttonRightsList = [];

  String selectedActionSorting = '';
  String selectedFilterSorting = '';

  TextEditingController locationController = TextEditingController();
  TextEditingController uldNoController = TextEditingController();

  TextEditingController groupIdController = TextEditingController();
  TextEditingController scanFlightController = TextEditingController();
  TextEditingController flightNoEditingController = TextEditingController();
  TextEditingController dateEditingController = TextEditingController();

  TextEditingController trollyTypeController = TextEditingController();
  TextEditingController trollyNumberController = TextEditingController();
  TextEditingController trollyGroupIdController = TextEditingController();

  DateTime? _selectedDate;

  bool _isGetButtonEnabled = true;
  bool _isLocationSearchBtnEnable = false;
  bool _isAcceptBtnEnable = true;
  bool _isfirstBtLastBtEnable = true;
  bool isvalidateLocation = false;
  bool _isSearchWidgetEnable = true;
  bool _isvalidateFlightNo = false;
  bool _isvalidULDNo = false;
  bool _uldNotExit = false;
  bool _suffixIconUld = false;
  bool _isDatePickerOpen = false;

  String _isdamageOrNot = "";

  FocusNode locationFocusNode = FocusNode();
  FocusNode uldNoFocusNode = FocusNode();
  FocusNode groupIdFocusNode = FocusNode();
  FocusNode trollyGroupIdFocusNode = FocusNode();

  FocusNode scanFlightFocusNode = FocusNode();
  FocusNode scanBtnFocusNode = FocusNode();
  FocusNode flightNoFocusNode = FocusNode();
  FocusNode dateFocusNode = FocusNode();
  FocusNode flightBtnFocusNode = FocusNode();


  FocusNode filtersearchFocusNode = FocusNode();
  FocusNode trollyTypeFocusNode = FocusNode();
  FocusNode trollyNumberFocusNode = FocusNode();


  FlightDetail? flightDetail;
  late TabController _tabController;
  ULDDetails? bulkTrollyDetail;

  final List<String> _tabs = ['ULD', 'Trolley'];


  @override
  void initState() {
    super.initState();


    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkScrollable();
    });

/*    _scrollController.addListener(() {
      setState(() {
        // Check if the user is at the top of the list
        _isAtTop = _scrollController.position.pixels == 0;

        // Check if user is at the bottom of the list
        _isAtBottom = _scrollController.position.pixels >= _scrollController.position.maxScrollExtent;
      });
    });*/

    CommonUtils.tempActionSorting = "";
    CommonUtils.tempFilterSorting = "";
    CommonUtils.ULDSEQUENCENUMBER = -1;
    CommonUtils.FLIGHTSEQUENCENUMBER = -1;
    CommonUtils.ULDBT = 2;
    CommonUtils.TABCONTROLLERINDEX = 0;
    CommonUtils.ULDNUMBERCEHCK = "";
    CommonUtils.ULDNUMBER = "";

    //user load data & default load data
    _loadUser();
    _tabController = TabController(length: 2, vsync: this);

    uldNoController.addListener(() {
        if (uldNoController.text.isNotEmpty) {
          _isAcceptBtnEnable = true;
        }
      });

    _scrollController.addListener(() {
      setState(() {
        _isAtTop = _scrollController.position.pixels == 0;
      });
    });

    locationFocusNode.addListener(() {
      if (!locationFocusNode.hasFocus) {
        leaveLocationFocus();
      }
    });
    
    uldNoFocusNode.addListener(() {
      if(!uldNoFocusNode.hasFocus){

        if(uldNoController.text.isNotEmpty){
          if (locationController.text.isNotEmpty) {
            if (isvalidateLocation) {
              _leaveUldNoFocus();
            }else{
              DialogUtils.showDataNotFoundDialogbot(context, "${widget.lableModel!.validateGate}", widget.lableModel!);

            }
          }
          else{
            openValidationDialog(widget.lableModel!.enterGateMsg!, locationFocusNode);
          }
        }
      }else{
        groupIdController.clear();
      }
    },);



    locationController.addListener(_validateLocationSearchBtn);

    // Listener to handle focus and open date picker only once
    dateFocusNode.addListener(() {
      if (isvalidateLocation) {
        if (dateFocusNode.hasFocus) {
          if (dateEditingController.text.isEmpty && !_isDatePickerOpen) {
            _selectDate(context);
          }
        }
      } else {
        FocusScope.of(context).requestFocus(locationFocusNode);
      }
    });


    scanFlightFocusNode.addListener(() {
      if(!scanFlightFocusNode.hasFocus){
        if(locationController.text.isNotEmpty){
          if(isvalidateLocation){
            if(scanFlightController.text.isNotEmpty){
              context.read<UldAcceptanceCubit>().getUldAcceptanceList(
                  _user!.userProfile!.userIdentity!,
                  _splashDefaultData!.companyCode!,
                  "",
                  "1990-01-01",
                  scanFlightController.text,
                  widget.menuId);
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


  }



  @override
  void dispose() {
    // Dispose of the controllers when the widget is disposed
    inactivityTimerManager?.stopTimer(); // Stop the timer when the screen is disposed
    locationController.dispose();
    uldNoController.dispose();
    groupIdController.dispose();
    scanFlightController.dispose();
    flightNoEditingController.dispose();
    dateEditingController.dispose();
    trollyTypeController.dispose();
    trollyNumberController.dispose();
    trollyGroupIdController.dispose();

    locationFocusNode.dispose();
    uldNoFocusNode.dispose();
    groupIdFocusNode.dispose();
    scanFlightFocusNode.dispose();
    flightNoFocusNode.dispose();
    dateFocusNode.dispose();
    flightBtnFocusNode.dispose();
    trollyTypeFocusNode.dispose();
    trollyNumberFocusNode.dispose();
    trollyGroupIdFocusNode.dispose();

    _scrollController.dispose();

    super.dispose();
  }
  
  Future<bool> _onWillPop() async {
    FocusScope.of(context).unfocus();
    if(_pageIndex == 1){
      setState(() {
        _pageIndex = 0;
        _tabController.animateTo(0);
      });
    }else{
      _isvalidULDNo = false;
      Navigator.pop(context, "Done");

      // clear all textfeild and list.
      WidgetsBinding.instance.addPostFrameCallback((_) {
        FocusScope.of(context).requestFocus(locationFocusNode);
        _checkScrollable();
      },
      );

      _isvalidULDNo = false;
      _suffixIconUld = false;
      locationController.clear();
      uldNoController.clear();

      scanFlightController.clear();
      flightNoEditingController.clear();
      dateEditingController.clear();
      filteredUldModelList.clear();
      trollyList.clear();
      groupIdController.clear();
      trollyTypeController.clear();
      trollyNumberController.clear();
      trollyGroupIdController.clear();
      uldList.clear();
      isvalidateLocation = false;
      _isAcceptBtnEnable = true;
      _isGetButtonEnabled = true;
      _isSearchWidgetEnable = true;
      flightDetail = null;
      bulkTrollyDetail = null;
      flightFromULDModel = null;
      _pageIndex = 0;
      _tabController.animateTo(0);
      btCount = 0;
      btCountTrolly = 0;
      CommonUtils.ULDBT = 2;
      CommonUtils.ULDSEQUENCENUMBER = -1;
      CommonUtils.FLIGHTSEQUENCENUMBER = -1;
      CommonUtils.ULDNUMBER = "";
      CommonUtils.ULDNUMBERCEHCK = "";
      CommonUtils.FLIGHTNUMBERCHECK = "";
      CommonUtils.TROLLYBT = 0;
      _isdamageOrNot = "";


    }

    return false; // Prevents the default back button action
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();


  @override
  Widget build(BuildContext context) {


    //culture wise data load from assets file
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
              resizeToAvoidBottomInset: true,
              body: NotificationListener<ScrollNotification>(
                onNotification: (ScrollNotification scroll) {
                  _resumeTimerOnInteraction(); // Reset the timer on scroll event
                  return true;
                },
                child: Stack(
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
                        child: Container(
                          decoration: BoxDecoration(
                            color: MyColor.bgColorGrey,
                            borderRadius: BorderRadius.only(topRight: Radius.circular(SizeConfig.blockSizeVertical * SizeUtils.WIDTH2), topLeft: Radius.circular(SizeConfig.blockSizeVertical * SizeUtils.WIDTH2))
                          ),

                          child: Directionality(
                            textDirection: uiDirection,
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 10, right: 15, top: 12, bottom: 12),
                                  child: HeaderWidget(
                                    title: widget.title,
                                    titleTextColor: MyColor.colorBlack,
                                    onBack: () {
                                      FocusScope.of(context).unfocus();
                                      if(_pageIndex == 1){
                                        setState(() {
                                          _pageIndex = 0;
                                          _tabController.animateTo(0);
                                        });
                                      }else{

                                        _isvalidULDNo = false;
                                        Navigator.pop(context, "Done");

                                        // clear all textfeild and list.
                                        WidgetsBinding.instance.addPostFrameCallback((_) {
                                          FocusScope.of(context).requestFocus(locationFocusNode);
                                        },
                                        );

                                        _isvalidULDNo = false;
                                        _suffixIconUld = false;
                                        locationController.clear();
                                        uldNoController.clear();
                                        scanFlightController.clear();
                                        flightNoEditingController.clear();
                                        dateEditingController.clear();
                                        filteredUldModelList.clear();
                                        trollyList.clear();
                                        groupIdController.clear();
                                        trollyTypeController.clear();
                                        trollyNumberController.clear();
                                        trollyGroupIdController.clear();
                                        uldList.clear();
                                        isvalidateLocation = false;
                                        _isAcceptBtnEnable = true;
                                        _isGetButtonEnabled = true;
                                        _isSearchWidgetEnable = true;
                                        flightDetail = null;
                                        bulkTrollyDetail = null;
                                        flightFromULDModel = null;
                                        _pageIndex = 0;
                                        _tabController.animateTo(0);
                                        btCount = 0;
                                        btCountTrolly = 0;
                                        CommonUtils.ULDBT = 2;
                                        CommonUtils.ULDSEQUENCENUMBER = -1;
                                        CommonUtils.FLIGHTSEQUENCENUMBER = -1;
                                        CommonUtils.ULDNUMBER = "";
                                        CommonUtils.ULDNUMBERCEHCK = "";
                                        CommonUtils.FLIGHTNUMBERCHECK = "";
                                        CommonUtils.TROLLYBT = 0;
                                        _isdamageOrNot = "";


                                      }

                                    },
                                    clearText: lableModel!.clear,
                                    onClear: () {
                                      FocusScope.of(context).unfocus();
                                      // clear all textfeild and list.
                                      WidgetsBinding.instance.addPostFrameCallback((_) {
                                        FocusScope.of(context).requestFocus(locationFocusNode);
                                        _checkScrollable();
                                      },
                                      );

                                      _scrollController.animateTo(
                                        0,
                                        duration: Duration(milliseconds: 100),
                                        curve: Curves.easeOut,
                                      );

                                      setState(() {
                                        CommonUtils.tempActionSorting = "";
                                        CommonUtils.tempFilterSorting = "";
                                        selectedActionSorting = "";
                                        selectedFilterSorting = "";
                                        _isvalidULDNo = false;
                                        _suffixIconUld = false;
                                        locationController.clear();
                                        uldNoController.clear();
                                        scanFlightController.clear();
                                        flightNoEditingController.clear();
                                        dateEditingController.clear();
                                        filteredUldModelList.clear();
                                        trollyList.clear();
                                        groupIdController.clear();
                                        trollyTypeController.clear();
                                        trollyNumberController.clear();
                                        trollyGroupIdController.clear();
                                        uldList.clear();
                                        isvalidateLocation = false;
                                        _isAcceptBtnEnable = true;
                                        _isGetButtonEnabled = true;
                                        _isSearchWidgetEnable = true;
                                        flightDetail = null;
                                        bulkTrollyDetail = null;
                                        flightFromULDModel = null;
                                        _pageIndex = 0;
                                        _tabController.animateTo(0);
                                        btCount = 0;
                                        btCountTrolly = 0;
                                        CommonUtils.ULDBT = 2;
                                        CommonUtils.ULDSEQUENCENUMBER = -1;
                                        CommonUtils.FLIGHTSEQUENCENUMBER = -1;
                                        CommonUtils.ULDNUMBER = "";
                                        CommonUtils.ULDNUMBERCEHCK = "";
                                        CommonUtils.FLIGHTNUMBERCHECK = "";
                                        CommonUtils.TROLLYBT = 0;
                                        _isdamageOrNot = "";
                                      });
                                    },
                                  ),
                                ),
                                BlocListener<UldAcceptanceCubit, UldAcceptanceState>(
                                  listener: (context, state) async {
                                    if (state is MainInitialState) {

                                    }
                                    else if (state is MainLoadingState) {
                                      // showing loading dialog in this state
                                      DialogUtils.showLoadingDialog(context, message: lableModel.loading);

                                    }else if(state is ButtonRolesAndRightsSuccessState){
                                      DialogUtils.hideLoadingDialog(context);
                                      if (state.buttonRolesRightsModel.status == "E") {
                                        Vibration.vibrate(duration: 500);
                                        SnackbarUtil.showSnackbar(context, state.buttonRolesRightsModel.statusMessage!, MyColor.colorRed, icon: FontAwesomeIcons.times);
                                      } else {

                                        buttonRightsList = state.buttonRolesRightsModel.buttonRight!;

                                        print("ListOfButton===== ${buttonRightsList.length}");

                                        //call default ULD acceptance api
                                        context.read<UldAcceptanceCubit>().getDefaultUldAcceptance(
                                            widget.refrelCode,
                                            _user!.userProfile!.userIdentity!,
                                            _splashDefaultData!.companyCode!,
                                            widget.menuId);
                                      }

                                    }else if(state is ButtonRolesAndRightsFailureState){
                                      DialogUtils.hideLoadingDialog(context);
                                      Vibration.vibrate(duration: 500);
                                      SnackbarUtil.showSnackbar(context, state.error, MyColor.colorRed, icon: FontAwesomeIcons.times);
                                    }
                                    else if (state is DefaultUldAcceptanceSuccessState) {

                                      //responce Default ULD Acceptance Success State
                                      WidgetsBinding.instance.addPostFrameCallback((_) {
                                        FocusScope.of(context).requestFocus(locationFocusNode);
                                      });

                                      DialogUtils.hideLoadingDialog(context);

                                      _isGroupIdIsMandatory = state.defaultUldAcceptanceModel.uLDGroupIdIsMandatory!;
                                      _uldTrollyAcceptance = state.defaultUldAcceptanceModel.uLDTrollyAcceptance!;


                                      if (state.defaultUldAcceptanceModel.status == "E") {
                                        Vibration.vibrate(duration: 500);
                                        SnackbarUtil.showSnackbar(context, state.defaultUldAcceptanceModel.statusMessage!, MyColor.colorRed, icon: FontAwesomeIcons.times);
                                      } else {
                                      }
                                    }
                                    else if (state is DefaultUldAcceptanceFailureState) {
                                      DialogUtils.hideLoadingDialog(context);
                                      Vibration.vibrate(duration: 500);
                                      SnackbarUtil.showSnackbar(context, state.error, MyColor.colorRed, icon: FontAwesomeIcons.times);

                                    }

                                    else if (state is ValidateLocationSuccessState) {
                                      if (state.validateLocationModel.status == "E") {
                                        setState(() {
                                          isvalidateLocation = false;
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
                                       /* isvalidateLocation = true;
                                        setState(() {});
                                        WidgetsBinding.instance.addPostFrameCallback((_) {
                                          FocusScope.of(context).requestFocus(uldNoFocusNode);
                                        },
                                        );*/

                                        isvalidateLocation = true;
                                        setState(() {});

                                        WidgetsBinding.instance.addPostFrameCallback((_) {

                                          print("CHECK_LOCATION==== ${locationController.text} == ${isvalidateLocation}");


                                          if (_pageIndex == 0) {
                                            FocusScope.of(context).requestFocus(uldNoFocusNode);
                                          } else if (_pageIndex == 1) {
                                            FocusScope.of(context).requestFocus(trollyTypeFocusNode);
                                          }
                                        },
                                        );
                                      }

                                    }
                                    else if (state is ValidateLocationFailureState) {
                                      DialogUtils.hideLoadingDialog(context);
                                      isvalidateLocation = false;
                                      Vibration.vibrate(duration: 500);
                                      SnackbarUtil.showSnackbar(context, state.error, MyColor.colorRed, icon: FontAwesomeIcons.times);

                                    }

                                    else if (state is UldacceptanceListSuccessState) {

                                      DialogUtils.hideLoadingDialog(context);

                                      if (state.uldacceptanceSuccessState.status == "E") {
                                        Vibration.vibrate(duration: 500);
                                        SnackbarUtil.showSnackbar(context, state.uldacceptanceSuccessState.statusMessage!, MyColor.colorRed, icon: FontAwesomeIcons.times);
                                        CommonUtils.tempActionSorting = "";
                                        CommonUtils.tempFilterSorting = "";
                                        selectedActionSorting = "";
                                        selectedFilterSorting = "";
                                        _isvalidULDNo = false;
                                        _suffixIconUld = false;

                                        uldNoController.clear();
                                        uldList.clear();
                                        filteredUldModelList.clear();
                                        scanFlightController.clear();
                                        trollyList.clear();
                                        flightDetail = null;
                                        btCount = 0;
                                        btCountTrolly = 0;
                                        bulkTrollyDetail = null;
                                        _isvalidateFlightNo = false;
                                        flightNoEditingController.clear();
                                        dateEditingController.clear();
                                        _isAcceptBtnEnable = true;
                                        setState(() {});
                                        WidgetsBinding.instance.addPostFrameCallback((_) {
                                          FocusScope.of(context).requestFocus(flightNoFocusNode);
                                        },
                                        );
                                      }
                                      else {
                                        CommonUtils.tempActionSorting = "";
                                        CommonUtils.tempFilterSorting = "";
                                        selectedActionSorting = "";
                                        selectedFilterSorting = "";


                                        flightDetail = state.uldacceptanceSuccessState.flightDetail!;
                                        uldList = state.uldacceptanceSuccessState.uLDDetails!;
                                        trollyList = state.uldacceptanceSuccessState.trollyDetails!;
                                        _isvalidateFlightNo = true;
                                        flightNoEditingController.text = flightDetail!.flightNo!;
                                        dateEditingController.text = flightDetail!.flightDate!.replaceAll(" ", "-");

                                        // check if ULDTrollyAcceptance = "Y" or "N"
                                        if (_uldTrollyAcceptance == "N") {
                                          uldList;
                                          btCount = 0;
                                        } else {
                                          bulkTrollyDetail = uldList.firstWhere((uld) => uld.uLDNo == "BULK");
                                          ULDDetails.removeBulkUld(uldList);
                                          if (bulkTrollyDetail!.buttonStatus!.replaceAll(" ", "") == "A") {
                                            // btCountTrolly = 0;
                                            btCountTrolly = state.uldacceptanceSuccessState.trollyDetails!.length;
                                          } else {
                                            // btCountTrolly = int.parse(bulkTrollyDetail!.buttonStatus!.replaceAll(" ", ""));
                                            btCountTrolly = state.uldacceptanceSuccessState.trollyDetails!.length;
                                          }
                                        }

                                        setState(() {
                                          _isSearchWidgetEnable = true;
                                          filteredUldModelList = uldList;
                                        });

                                        FocusScope.of(context).unfocus();
                                        WidgetsBinding.instance.addPostFrameCallback((_) {
                                          FocusScope.of(context).requestFocus(filtersearchFocusNode);
                                        },
                                        );
                                      }

                                    }
                                    else if (state is UldacceptanceListFailureState) {
                                      DialogUtils.hideLoadingDialog(context);
                                      Vibration.vibrate(duration: 500);
                                      SnackbarUtil.showSnackbar(context, state.error, MyColor.colorRed, icon: FontAwesomeIcons.times);

                                    }

                                    else if (state is UldAcceptSuccessState) {

                                      DialogUtils.hideLoadingDialog(context);

                                      if (state.uldAcceptModel.status == "E") {
                                        Vibration.vibrate(duration: 500);
                                        SnackbarUtil.showSnackbar(context, state.uldAcceptModel.statusMessage!, MyColor.colorRed, icon: FontAwesomeIcons.times);

                                      } else {

                                        SnackbarUtil.showSnackbar(context, state.uldAcceptModel.statusMessage!, MyColor.colorGreen, icon: Icons.done);

                                        if (CommonUtils.ULDSEQUENCENUMBER == -1) {

                                        } else {
                                          if (CommonUtils.ULDBT == 2) {
                                            WidgetsBinding.instance.addPostFrameCallback((_) {
                                              FocusScope.of(context).requestFocus(uldNoFocusNode);
                                            },
                                            );
                                            _updateButtonStatus(CommonUtils.ULDSEQUENCENUMBER, "D");
                                          }
                                        }
                                        _isvalidULDNo = false;
                                        _suffixIconUld = false;
                                        uldNoController.clear();
                                        groupIdController.clear();
                                        _isAcceptBtnEnable = true;
                                      }

                                    }
                                    else if (state is UldAcceptFailureState) {
                                      DialogUtils.hideLoadingDialog(context);
                                      Vibration.vibrate(duration: 500);
                                      SnackbarUtil.showSnackbar(context, state.error, MyColor.colorRed, icon: FontAwesomeIcons.times);

                                    }

                                    else if (state is TrollyAcceptSuccessState) {

                                      if(state.uldAcceptModel.status == "E"){
                                        DialogUtils.hideLoadingDialog(context);
                                        Vibration.vibrate(duration: 500);
                                        SnackbarUtil.showSnackbar(context,state.uldAcceptModel.statusMessage!, MyColor.colorRed, icon: FontAwesomeIcons.times);
                                      }else{
                                        DialogUtils.hideLoadingDialog(context);
                                        SnackbarUtil.showSnackbar(context, state.uldAcceptModel.statusMessage!, MyColor.colorGreen, icon: Icons.done);

                                        String flightNo = flightNoEditingController.text;
                                        String flightDate = dateEditingController.text;

                                        context.read<UldAcceptanceCubit>().getUldAcceptanceList(
                                            _user!.userProfile!.userIdentity!,
                                            _splashDefaultData!.companyCode!,
                                            flightNo.replaceAll(' ', ''),
                                            flightDate,"",
                                            widget.menuId);


                                        if(CommonUtils.TROLLYBT == 0){
                                          btCountTrolly = btCountTrolly + 1;
                                          trollyTypeController.clear();
                                          trollyNumberController.clear();
                                          trollyGroupIdController.clear();
                                          WidgetsBinding.instance.addPostFrameCallback((_) {
                                            FocusScope.of(context).requestFocus(trollyTypeFocusNode);
                                          },);

                                        }else if(CommonUtils.TROLLYBT == 1){
                                          btCountTrolly = btCountTrolly + 1;
                                          trollyTypeController.clear();
                                          trollyNumberController.clear();
                                          trollyGroupIdController.clear();
                                          WidgetsBinding.instance.addPostFrameCallback((_) {
                                            FocusScope.of(context).requestFocus(trollyTypeFocusNode);
                                          },);
                                        }
                                      }

                                    }
                                    else if (state is TrollyAcceptFailureState) {
                                      DialogUtils.hideLoadingDialog(context);
                                      Vibration.vibrate(duration: 500);
                                      SnackbarUtil.showSnackbar(context, state.error, MyColor.colorRed, icon: FontAwesomeIcons.times);

                                    }

                                    else if (state is FlightFromULDSuccessState){

                                      DialogUtils.hideLoadingDialog(context);

                                      if(state.flightFromULDModel.status == "E"){

                                        _uldNotExit = true;
                                        SnackbarUtil.showSnackbar(context, state.flightFromULDModel.statusMessage!, MyColor.colorRed, icon: FontAwesomeIcons.times);
                                        Vibration.vibrate(duration: 500);
                                        WidgetsBinding.instance.addPostFrameCallback((_) {
                                          FocusScope.of(context).requestFocus(uldNoFocusNode);
                                        },);

                                       /* if(_uldNotExit == true || uldNoController.text.isNotEmpty || _isvalidULDNo == true){
                                          bool? checkUCR = await DialogUtils.showULDNotExit(context, lableModel, state.flightFromULDModel.statusMessage!);

                                          if(checkUCR == true){
                                            openUCRBottomDialog(context, uldNoController.text, lableModel, textDirection, _isGroupIdIsMandatory, buttonRightsList);
                                            WidgetsBinding.instance.addPostFrameCallback((_) {
                                              FocusScope.of(context).requestFocus(groupIdFocusNode);
                                            },);
                                          }
                                          else if(checkUCR == false){
                                            uldNoController.clear();
                                            WidgetsBinding.instance.addPostFrameCallback((_) {
                                              FocusScope.of(context).requestFocus(uldNoFocusNode);
                                            },);
                                          }
                                        }
                */



                                        flightNoEditingController.clear();
                                        scanFlightController.clear();
                                        dateEditingController.clear();
                                        uldList.clear();
                                        filteredUldModelList.clear();
                                        trollyList.clear();

                                        flightDetail = null;
                                        flightFromULDModel = null;
                                        CommonUtils.FLIGHTSEQUENCENUMBER = -1;
                                        CommonUtils.ULDSEQUENCENUMBER = -1;
                                        setState(() {

                                        });

                                      }
                                      else if(state.flightFromULDModel.status == "D") {
                                        _uldNotExit = true;

                                        if(_uldNotExit == true || uldNoController.text.isNotEmpty || _isvalidULDNo == true){
                                          bool? checkUCR = await DialogUtils.showULDNotExit(context, lableModel, state.flightFromULDModel.statusMessage!);

                                          if(checkUCR == true){

                                            openUCRBottomDialog(context, uldNoController.text, lableModel, textDirection, _isGroupIdIsMandatory, buttonRightsList);
                                            WidgetsBinding.instance.addPostFrameCallback((_) {
                                              FocusScope.of(context).requestFocus(uldNoFocusNode);
                                            },);
                                            uldNoController.clear();
                                          }
                                          else if(checkUCR == false){

                                            WidgetsBinding.instance.addPostFrameCallback((_) {
                                              FocusScope.of(context).requestFocus(uldNoFocusNode);
                                            },);
                                          }
                                        }




                                        flightNoEditingController.clear();
                                        scanFlightController.clear();
                                        dateEditingController.clear();
                                        uldList.clear();
                                        filteredUldModelList.clear();
                                        trollyList.clear();

                                        flightDetail = null;
                                        flightFromULDModel = null;
                                        CommonUtils.FLIGHTSEQUENCENUMBER = -1;
                                        CommonUtils.ULDSEQUENCENUMBER = -1;
                                        setState(() {

                                        });

                                      }
                                      else{
                                        DialogUtils.hideLoadingDialog(context);
                                        _isvalidateFlightNo = true;
                                        _uldNotExit = false;
                                        flightFromULDModel = state.flightFromULDModel;
                                        WidgetsBinding.instance.addPostFrameCallback((_) {
                                          FocusScope.of(context).requestFocus(groupIdFocusNode);
                                        },);

                                        String flightNo = "${state.flightFromULDModel.flightAirline} ${state.flightFromULDModel.flightNo}";
                                        CommonUtils.FLIGHTSEQUENCENUMBER = state.flightFromULDModel.flightSeqNo!;
                                        CommonUtils.ULDSEQUENCENUMBER = state.flightFromULDModel.uLDSeqNo!;
                                        if(flightNoEditingController.text == flightNo || dateEditingController.text ==  state.flightFromULDModel.flightDate!.replaceAll(" ", "-")){
                                          flightNoEditingController.text = flightNo;
                                          dateEditingController.text = state.flightFromULDModel.flightDate!.replaceAll(" ", "-");
                                        }else{
                                          flightNoEditingController.text = flightNo;
                                          dateEditingController.text = state.flightFromULDModel.flightDate!.replaceAll(" ", "-");
                                          uldList.clear();
                                          filteredUldModelList.clear();
                                          trollyList.clear();
                                          scanFlightController.clear();
                                          flightDetail = null;
                                        }

                                        setState(() {

                                        });

                                      }

                                    }
                                    else if (state is FlightFromULDFailureState){
                                      DialogUtils.hideLoadingDialog(context);
                                      Vibration.vibrate(duration: 500);
                                      SnackbarUtil.showSnackbar(context, state.error, MyColor.colorRed, icon: FontAwesomeIcons.times);
                                    }

                                    else if (state is UldDamageAcceptSuccessState){

                                      if(state.uldAcceptModel.status == "E"){
                                        DialogUtils.hideLoadingDialog(context);
                                        Vibration.vibrate(duration: 500);
                                        SnackbarUtil.showSnackbar(context, state.uldAcceptModel.statusMessage!, MyColor.colorRed, icon: FontAwesomeIcons.times);
                                      }else{
                                        DialogUtils.hideLoadingDialog(context);
                                        _updateButtonStatus(CommonUtils.ULDSEQUENCENUMBER, _isdamageOrNot);
                                        uldNoController.clear();
                                        _isvalidULDNo = false;
                                        _suffixIconUld = false;
                                        groupIdController.clear();
                                        CommonUtils.ULDSEQUENCENUMBER = -1;
                                        WidgetsBinding.instance.addPostFrameCallback((_) {
                                          FocusScope.of(context).requestFocus(uldNoFocusNode);
                                        },);
                                      }

                                    }
                                    else if (state is UldDamageAcceptFailureState){
                                      DialogUtils.hideLoadingDialog(context);
                                      Vibration.vibrate(duration: 500);
                                      SnackbarUtil.showSnackbar(context, state.error, MyColor.colorRed, icon: FontAwesomeIcons.times);

                                    }

                                    else if (state is UldUCRSuccessState){
                                      DialogUtils.hideLoadingDialog(context);
                                      if(state.uldUCRModel.status == "E"){
                                        Navigator.pop(context);
                                        Vibration.vibrate(duration: 500);
                                        WidgetsBinding.instance.addPostFrameCallback((_) {
                                          FocusScope.of(context).requestFocus(uldNoFocusNode);
                                        },);
                                        SnackbarUtil.showSnackbar(context, state.uldUCRModel.statusMessage!, MyColor.colorRed, icon: FontAwesomeIcons.times);
                                      }else{

                                        if(CommonUtils.UCRBTSTATUS == "A"){
                                          Navigator.pop(context);
                                          print("CHECK_UL_SUCCESSFULLL---------------------------------- ");
                                          uldNoController.clear();
                                          _isvalidULDNo = false;
                                          _suffixIconUld = false;
                                          WidgetsBinding.instance.addPostFrameCallback((_) {
                                            FocusScope.of(context).requestFocus(uldNoFocusNode);
                                          },);
                                          SnackbarUtil.showSnackbar(context, state.uldUCRModel.statusMessage!, MyColor.colorGreen, icon: Icons.done);
                                        }else {

                                          print("CHECK_UL_SUCCESSFULLL----------------------------------11111111 ");
                                          Navigator.pop(context);
                                          inactivityTimerManager!.stopTimer();
                                          String damageOrNot = await Navigator.push(
                                              context,
                                              CupertinoPageRoute(
                                                builder: (context) => UldDamagedPage(
                                                  importSubMenuList: widget.importSubMenuList,
                                                  exportSubMenuList: widget.exportSubMenuList,
                                                  locationCode: locationController.text,
                                                  menuId: widget.menuId,
                                                  ULDNo:  CommonUtils.ULDUCRNO,
                                                  ULDSeqNo: state.uldUCRModel.uldSeqNo!,
                                                  flightSeqNo: 0,
                                                  groupId: CommonUtils.UCRGROUPID,
                                                  menuCode: widget.refrelCode,
                                                  isRecordView: 0,
                                                  mainMenuName: widget.mainMenuName,
                                                  buttonRightsList: buttonRightsList,
                                                ),
                                              ));


                                          print("DMAGE_DIALOG_PAGE-----------33333 ${damageOrNot}");

                                          if(damageOrNot == "U"){
                                            uldNoController.clear();
                                            _isvalidULDNo = false;
                                            _suffixIconUld = false;
                                            WidgetsBinding.instance.addPostFrameCallback((_) {
                                              FocusScope.of(context).requestFocus(uldNoFocusNode);
                                            },);
                                            _resumeTimerOnInteraction();
                                          }
                                          else if(damageOrNot == "S"){
                                            uldNoController.clear();
                                            _isvalidULDNo = false;
                                            _suffixIconUld = false;
                                            WidgetsBinding.instance.addPostFrameCallback((_) {
                                              FocusScope.of(context).requestFocus(uldNoFocusNode);
                                            },);
                                            _resumeTimerOnInteraction();
                                          }
                                          else{
                                            _resumeTimerOnInteraction();
                                            WidgetsBinding.instance.addPostFrameCallback((_) {
                                              FocusScope.of(context).requestFocus(uldNoFocusNode);
                                            },);
                                          }

                                        }

                                      }
                                    }
                                    else if (state is UldUCRFailureState){
                                      DialogUtils.hideLoadingDialog(context);
                                      Navigator.pop(context);
                                      Vibration.vibrate(duration: 500);
                                      SnackbarUtil.showSnackbar(context, state.error, MyColor.colorRed, icon: FontAwesomeIcons.times);
                                    }

                                    else if (state is UldUCRDamageSuccessState){
                                      DialogUtils.hideLoadingDialog(context);
                                      if(state.uldAcceptModel.status == "E"){
                                        Navigator.pop(context);
                                        Vibration.vibrate(duration: 500);
                                        SnackbarUtil.showSnackbar(context, state.uldAcceptModel.statusMessage!, MyColor.colorRed, icon: FontAwesomeIcons.times);
                                      }else{
                                        Navigator.pop(context);
                                        print("CHECK_UL_SUCCESSFULLL----------------------------------111 ");
                                        SnackbarUtil.showSnackbar(context, state.uldAcceptModel.statusMessage!, MyColor.colorGreen, icon: Icons.done);
                                      }
                                    }
                                    else if (state is UldUCRDamageFailureState){
                                      DialogUtils.hideLoadingDialog(context);
                                      Navigator.pop(context);
                                      Vibration.vibrate(duration: 500);
                                      SnackbarUtil.showSnackbar(context, state.error, MyColor.colorRed, icon: FontAwesomeIcons.times);
                                    }
                                  },
                                  child: Expanded(
                                    child: SingleChildScrollView(
                                      controller: _scrollController,
                                      child: ConstrainedBox(
                                        key: _contentKey,
                                        constraints: BoxConstraints(
                                            minHeight: MediaQuery.of(context).size.height
                                        ),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(left: 10, right: 10, top: 0, bottom: 0),
                                              child: Directionality(
                                                textDirection: textDirection,
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
                                                    child: Column(
                                                      children: [
                                                        Row(
                                                          children: [
                                                            SvgPicture.asset(info, height: SizeConfig.blockSizeVertical * SizeUtils.ICONSIZE2,),
                                                            SizedBox(width: SizeConfig.blockSizeHorizontal,),
                                                            CustomeText(text: "${lableModel.scanOrManual}", fontColor: MyColor.textColorGrey2, fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5, fontWeight: FontWeight.w500, textAlign: TextAlign.start)
                                                          ],
                                                        ),
                                                        SizedBox(height: SizeConfig.blockSizeVertical * SizeUtils.HEIGHT_1_5,),
                                                        Row(
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
                                                                labelText: "${lableModel.gate} *",
                                                                readOnly: false,
                                                                maxLength: 15,
                                                                isShowSuffixIcon: isvalidateLocation,
                                                                onChanged: (value, validate) {

                                                                  print("CHECK_VALIDATEEEEE======= ${validate}");

                                                                  setState(() {
                                                                    isvalidateLocation = false;
                                                                  });
                                                                  if (value.toString().isEmpty) {
                                                                    isvalidateLocation = false;
                                                                    uldNoController.clear();
                                                                    _isvalidULDNo = false;
                                                                    _suffixIconUld = false;
                                                                    scanFlightController.clear();
                                                                    flightNoEditingController.clear();
                                                                    dateEditingController.clear();
                                                                    groupIdController.clear();
                                                                    filteredUldModelList.clear();
                                                                    trollyList.clear();
                                                                    uldList.clear();
                                                                    _isAcceptBtnEnable = true;
                                                                    _isGetButtonEnabled = true;
                                                                    _isSearchWidgetEnable = true;


                                                                    CommonUtils.tempActionSorting = "";
                                                                    CommonUtils.tempFilterSorting = "";
                                                                    selectedActionSorting = "";
                                                                    selectedFilterSorting = "";
                                                                    trollyTypeController.clear();
                                                                    trollyNumberController.clear();
                                                                    trollyGroupIdController.clear();
                                                                    flightDetail = null;
                                                                    bulkTrollyDetail = null;
                                                                    flightFromULDModel = null;
                                                                    _pageIndex = 0;
                                                                    _tabController.animateTo(0);
                                                                    btCount = 0;
                                                                    btCountTrolly = 0;
                                                                    CommonUtils.ULDBT = 2;
                                                                    CommonUtils.ULDSEQUENCENUMBER = -1;
                                                                    CommonUtils.FLIGHTSEQUENCENUMBER = -1;
                                                                    CommonUtils.ULDNUMBER = "";
                                                                    CommonUtils.ULDNUMBERCEHCK = "";
                                                                    CommonUtils.FLIGHTNUMBERCHECK = "";
                                                                    CommonUtils.TROLLYBT = 0;
                                                                    _isdamageOrNot = "";
                                                                    WidgetsBinding.instance.addPostFrameCallback((_) {
                                                                      _checkScrollable();
                                                                    });



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
                                                              onTap: () {
                                                                scanLocationQR();
                                                              },

                                                              child: Padding(
                                                                padding: const EdgeInsets.all(8.0),
                                                                child: SvgPicture.asset(search, height: SizeConfig.blockSizeVertical * SizeUtils.ICONSIZE3),
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
                                              padding: const EdgeInsets.only(left: 10, right: 10, top: 0, bottom: 0),
                                              child: Directionality(
                                                textDirection: textDirection,
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
                                                    padding: const EdgeInsets.only(top: 12, bottom: 12),
                                                    child: Column(
                                                      children: [
                                                        Padding(
                                                          padding: const EdgeInsets.only(left: 12, right: 12,),
                                                          child: (_uldTrollyAcceptance == "Y")
                                                              ? Row(children: List.generate(_tabs.length, (index) {
                                                            return InkWell(
                                                              onTap: () {
                                                                setState(() {
                                                                  _pageIndex = index;
                                                                  _checkScrollable();
                                                                });
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
                                                          }),)
                                                              : Container(),
                                                        ),

                                                        Padding(
                                                          padding: const EdgeInsets.only(left: 12, right: 12,),
                                                          child: _checkWidget(_pageIndex, textDirection, lableModel),
                                                        ),

                                                        SizedBox(height: SizeConfig.blockSizeVertical,),

                                                        CustomDivider(
                                                          space: 0,
                                                          color: MyColor.textColorGrey2,
                                                          thickness: 1.5,
                                                          hascolor: true,
                                                        ),

                                                        SizedBox(height: SizeConfig.blockSizeVertical * SizeUtils.HEIGHT2,),

                                                        Padding(
                                                          padding: const EdgeInsets.only(left: 12, right: 12,),
                                                          child: Directionality(
                                                            textDirection: textDirection,
                                                            child: Row(
                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                              children: [
                                                                /* CustomeText(text: "${lableModel.searchByFlight}", fontColor: MyColor.colorBlack, fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5, fontWeight: FontWeight.w600, textAlign: TextAlign.start),*/

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
                                                                    controller: scanFlightController,
                                                                    focusNode: scanFlightFocusNode,
                                                                    maxLength: 15,
                                                                    onChanged: (value) {
                                                                      _isvalidateFlightNo = false;
                                                                      flightDetail = null;
                                                                      btCountTrolly = 0;
                                                                      bulkTrollyDetail = null;
                                                                      flightNoEditingController.clear();
                                                                      dateEditingController.clear();
                                                                      _checkScrollable();
                                                                      if(uldList.isNotEmpty && filteredUldModelList.isNotEmpty){
                                                                        uldList.clear();
                                                                        filteredUldModelList.clear();

                                                                        trollyList.clear();
                                                                      }
                                                                      _isAcceptBtnEnable = true;
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
                                                                      if(isvalidateLocation){
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
                                                                // click search button to validate location
                                                                /*InkWell(
                                                                        onTap: () async {
                                                                          FocusScope.of(context).unfocus();
                                                                          if(CommonUtils.ULDSEQUENCENUMBER == 0 || _isvalidULDNo == false){

                                                                          }else{
                                                                            if (locationController.text.isNotEmpty) {
                                                                              if (isvalidateLocation) {
                                                                                if (uldNoController.text.isNotEmpty) {

                                                                                  //call flight no. and date using ULDNo api
                                                                                  await context.read<UldAcceptanceCubit>().getFlightFromULD(
                                                                                      uldNoController.text.replaceAll(" ", ""),
                                                                                      _user!.userProfile!.userIdentity!,
                                                                                      _splashDefaultData!.companyCode!,
                                                                                      widget.menuId
                                                                                  );

                                                                                } else {
                                                                                  openValidationDialog("${lableModel.enteruldNoMsg}", uldNoFocusNode);
                                                                                }
                                                                              } else {
                                                                                DialogUtils.showDataNotFoundDialogbot(context, "${lableModel.validateGate}", lableModel);
                                                                              }
                                                                            }
                                                                            else {
                                                                              openValidationDialog(lableModel.enterGateMsg!, locationFocusNode);
                                                                            }
                                                                          }
                                                                        },

                                                                        child: Padding(
                                                                          padding: const EdgeInsets.all(8.0),
                                                                          child: SvgPicture.asset((CommonUtils.ULDSEQUENCENUMBER == 0 || _isvalidULDNo == false) ? searchd : search, height: SizeConfig.blockSizeVertical * SizeUtils.ICONSIZE3,),
                                                                        ),

                                                                      ),*/
                                                              ],
                                                            ),
                                                          ),
                                                        ),

                                                        SizedBox(height: SizeConfig.blockSizeVertical * SizeUtils.HEIGHT3,),

                                                        Padding(
                                                          padding: const EdgeInsets.only(left: 12, right: 12,),
                                                          child: Directionality(
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

                                                                      _isvalidateFlightNo = false;
                                                                      flightDetail = null;
                                                                      btCountTrolly = 0;
                                                                      bulkTrollyDetail = null;
                                                                      dateEditingController.clear();
                                                                      scanFlightController.clear();
                                                                      _checkScrollable();
                                                                      if(uldList.isNotEmpty && filteredUldModelList.isNotEmpty){
                                                                        CommonUtils.tempActionSorting = "";
                                                                        CommonUtils.tempFilterSorting = "";
                                                                        selectedActionSorting = "";
                                                                        selectedFilterSorting = "";
                                                                        uldList.clear();
                                                                        filteredUldModelList.clear();
                                                                        trollyList.clear();
                                                                      }
                                                                      _isAcceptBtnEnable = true;
                                                                      setState(() {});
                                                                    },

                                                                    readOnly: locationController.text.isNotEmpty ? false : true,
                                                                    fillColor: locationController.text.isNotEmpty ? Colors.grey.shade100 : Colors.grey.shade300,
                                                                    textInputType:
                                                                    TextInputType.text,
                                                                    inputAction:
                                                                    TextInputAction.next,
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
                                                                      onPress: () => locationController.text.isNotEmpty && !_isDatePickerOpen ? _selectDate(context) : null,
                                                                      hastextcolor: true,
                                                                      animatedLabel: true,
                                                                      needOutlineBorder: true,
                                                                      labelText: "${lableModel.flightDate} *",
                                                                      readOnly: true,
                                                                      onChanged: (value) {
                                                                        setState(() {
                                                                          _isAcceptBtnEnable = true;
                                                                        });
                                                                      },
                                                                      fillColor: locationController.text.isNotEmpty ? Colors.grey.shade100 : Colors.grey.shade300,
                                                                      textInputType: TextInputType.text,
                                                                      inputAction: TextInputAction.next,
                                                                      hintTextcolor:MyColor.colorGrey,
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
                                                        ),
                                                        SizedBox(height: SizeConfig.blockSizeVertical * SizeUtils.HEIGHT2,),

                                                        Padding(
                                                          padding: const EdgeInsets.only(left: 12, right: 12,),
                                                          child: RoundedButtonBlue(
                                                            focusNode: flightBtnFocusNode,
                                                            text: "${lableModel.uldSearch}", isborderButton: false, textDirection: textDirection, press: () {
                                                            FocusScope.of(context).unfocus();
                                                            if (_isGetButtonEnabled) {
                                                             // if(isButtonEnabled("uldSearch", buttonRightsList)){
                                                                if (locationController.text.isNotEmpty) {
                                                                  if (isvalidateLocation) {
                                                                    if (flightNoEditingController.text.isNotEmpty) {
                                                                      if (dateEditingController.text.isNotEmpty) {
                                                                        String flightNo = flightNoEditingController.text;
                                                                        String flightDate = dateEditingController.text;

                                                                        context.read<UldAcceptanceCubit>().getUldAcceptanceList(
                                                                            _user!.userProfile!.userIdentity!,
                                                                            _splashDefaultData!.companyCode!,
                                                                            flightNo.replaceAll(' ', ''),
                                                                            flightDate,"",
                                                                            widget.menuId);
                                                                      } else {
                                                                        openValidationDialog(lableModel.enterFlightDate!, dateFocusNode);
                                                                      }
                                                                    } else {
                                                                      openValidationDialog(lableModel.enterFlightNo!, flightNoFocusNode);
                                                                    }
                                                                  }
                                                                  else {
                                                                    DialogUtils.showDataNotFoundDialogbot(context, "${lableModel.validateGate}", lableModel);
                                                                  }
                                                                }
                                                                else {
                                                                  openValidationDialog(lableModel.enterGateMsg!, locationFocusNode);
                                                                }
                                                             /* }else{
                                                                SnackbarUtil.showSnackbar(context, ValidationMessageCodeUtils.AuthorisedRolesAndRightsMsg, MyColor.colorRed, icon: FontAwesomeIcons.times);
                                                                Vibration.vibrate(duration: 500);
                                                              }*/


                                                            } else {}
                                                          },),
                                                        ),

                                                        SizedBox(height: SizeConfig.blockSizeVertical,),

                                                        CustomDivider(
                                                          space: 0,
                                                          color: MyColor.textColorGrey2,
                                                          thickness: 1.5,
                                                          hascolor: true,
                                                        ),
                                                        //check flight search and date with search uld list _isSearchWidgetEnable = true
                                                        SizedBox(height: SizeConfig.blockSizeVertical,),
                                                        if(_pageIndex == 0)
                                                          _isSearchWidgetEnable ? Directionality(
                                                            textDirection: textDirection,
                                                            child: Column(
                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                              children: [
                                                                Padding(
                                                                  padding: const EdgeInsets.only(left: 12, right: 12,),
                                                                  child: Row(
                                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                    children: [
                                                                      CustomeText(text: "${lableModel.uldListTotal} (${filteredUldModelList.length})", fontColor: MyColor.colorBlack, fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5, fontWeight: FontWeight.w500, textAlign: TextAlign.start),
                                                                      (flightDetail != null) ? Container(
                                                                        padding : EdgeInsets.symmetric(horizontal: SizeConfig.blockSizeHorizontal * 2.5, vertical: SizeConfig.blockSizeVertical * 0.1),
                                                                        decoration : BoxDecoration(
                                                                          borderRadius: BorderRadius.circular(20),
                                                                          color: (flightDetail != null)
                                                                              ? (flightDetail!.flightStatus == "Arrived")
                                                                              ? MyColor.flightArrived
                                                                              : (flightDetail!.flightStatus == "Finalized")
                                                                              ? MyColor.flightFinalize
                                                                              : (flightDetail!.flightStatus == "Not Arrived")
                                                                              ? MyColor.flightNotArrived
                                                                              : null
                                                                              : null,
                                                                        ),
                                                                        child: CustomeText(
                                                                            text: (flightDetail != null)
                                                                                ? (flightDetail!.flightStatus == "Arrived")
                                                                                ? lableModel.arrived!
                                                                                : (flightDetail!.flightStatus == "Finalized")
                                                                                ? lableModel.finalized!
                                                                                : (flightDetail!.flightStatus == "Not Arrived")
                                                                                ? lableModel.notArrived!
                                                                                : ""
                                                                                : "",
                                                                            fontColor: MyColor.textColorGrey3,
                                                                            fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                                                            fontWeight: FontWeight.w500,
                                                                            textAlign: TextAlign.start),
                                                                      ) : SizedBox(),
                                                                    ],
                                                                  ),
                                                                ),

                                                                // if filterUldlist length = 0
                                                                Column(
                                                                  children: [

                                                                    SizedBox(height: SizeConfig.blockSizeVertical,),

                                                                    Padding(
                                                                      padding: const EdgeInsets.only(left: 12, right: 12,),
                                                                      child: Searchwidget(
                                                                        filtersearchFocusNode: filtersearchFocusNode,
                                                                        searchingString: (searchString) {
                                                                          _updateSearchList(searchString);
                                                                        },
                                                                        updateSortingOptions: (actionSorting, filterSorting) {
                                                                          /* filteredUldModelList = uldModelList;*/
                                                                          _updateSortingOptions(actionSorting, filterSorting);
                                                                        },
                                                                      ),
                                                                    ),
                                                                    SizedBox(height: SizeConfig.blockSizeVertical,),

                                                                    (filteredUldModelList.isNotEmpty)
                                                                        ? ListView.builder(
                                                                     /* controller: _scrollController,*/
                                                                      physics: NeverScrollableScrollPhysics(),
                                                                      shrinkWrap: true,
                                                                      itemCount: filteredUldModelList.length,
                                                                      itemBuilder: (context, index) {
                                                                        ULDDetails uldModel = filteredUldModelList[index];

                                                                        WidgetsBinding.instance.addPostFrameCallback((_) {
                                                                          _checkScrollable();
                                                                        });


                                                                        return Padding(
                                                                          padding: const EdgeInsets.only(left: 12, right: 12, top: 4, bottom: 4),
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
                                                                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                                                              child: Row(
                                                                                children: [
                                                                                  Expanded(
                                                                                    flex:3,
                                                                                    child: Column(
                                                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                                      children: [
                                                                                        Row(
                                                                                          children: [
                                                                                            Container(
                                                                                              padding : EdgeInsets.symmetric(horizontal: SizeConfig.blockSizeHorizontal * 2.5, vertical: SizeConfig.blockSizeVertical * 0.1),
                                                                                              decoration : BoxDecoration(
                                                                                                  borderRadius: BorderRadius.circular(20),
                                                                                                 /* color: (uldModel.buttonStatus!.replaceAll(" ", "") == "D" || uldModel.buttonStatus!.replaceAll(" ", "") == "U" || uldModel.buttonStatus!.replaceAll(" ", "") == "S" || uldModel.buttonStatus!.replaceAll(" ", "") == "0" || uldModel.buttonStatus!.replaceAll(" ", "") == "2")
                                                                                                      ? MyColor.acceptedColor
                                                                                                      : MyColor.pendingColor*/
                                                                                                  color: (uldModel.buttonStatus!.replaceAll(" ", "") != "A") ? MyColor.acceptedColor : MyColor.pendingColor

                                                                                              ),
                                                                                              child: CustomeText(
                                                                                                 /* text: (uldModel.buttonStatus!.replaceAll(" ", "") == "D" || uldModel.buttonStatus!.replaceAll(" ", "") == "U" || uldModel.buttonStatus!.replaceAll(" ", "") == "S")
                                                                                                      ? lableModel.accepted!.toUpperCase()
                                                                                                      : lableModel.pending!.toUpperCase(),*/
                                                                                                  text : (uldModel.buttonStatus!.replaceAll(" ", "") != "A") ? lableModel.accepted!.toUpperCase() : lableModel.pending!.toUpperCase(),
                                                                                                  fontColor: MyColor.colorBlack,
                                                                                                  fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_2,
                                                                                                  fontWeight: FontWeight.w400,
                                                                                                  textAlign: TextAlign.start),
                                                                                            ),
                                                                                            SizedBox(width: SizeConfig.blockSizeHorizontal * SizeUtils.WIDTH2,),
                                                                                            (uldModel.buttonStatus == "U" || uldModel.buttonStatus!.replaceAll(" ", "") == "U" || uldModel.buttonStatus == "S" || uldModel.buttonStatus!.replaceAll(" ", "") == "S") ? SvgPicture.asset(damageIcon, height: SizeConfig.blockSizeVertical * SizeUtils.ICONSIZE_2_5,) : SizedBox(),
                                                                                            SizedBox(width: SizeConfig.blockSizeHorizontal * SizeUtils.WIDTH2,),
                                                                                            (uldModel.buttonStatus == "U" || uldModel.buttonStatus!.replaceAll(" ", "") == "U" || uldModel.buttonStatus == "S" || uldModel.buttonStatus!.replaceAll(" ", "") == "S") ? CustomeText(text: "DMG", fontColor: MyColor.colorRed, fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5, fontWeight: FontWeight.w400, textAlign: TextAlign.start) : SizedBox()
                                                                                          ],
                                                                                        ),
                                                                                        SizedBox(height: SizeConfig.blockSizeVertical,),
                                                                                        CustomeText(
                                                                                            text: uldModel.uLDNo!,
                                                                                            fontColor: MyColor.colorBlack,
                                                                                            fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                                                                            fontWeight: FontWeight.w600,
                                                                                            textAlign: TextAlign.start)
                                                                                      ],
                                                                                    ),
                                                                                  ),
                                                                                  Expanded(
                                                                                    flex:2,
                                                                                    child: _getWidgetBtn(
                                                                                        uldModel.buttonStatus,
                                                                                        uldModel,
                                                                                        lableModel,
                                                                                        textDirection),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        );


                                                                      },
                                                                    )
                                                                        : Center(
                                                                      child: Padding(
                                                                        padding:
                                                                        const EdgeInsets.symmetric(vertical: 20),
                                                                        child: CustomeText(
                                                                            text: "${lableModel.recordNotFound}",
                                                                            fontColor: MyColor.textColorGrey,
                                                                            fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_2_0,
                                                                            fontWeight: FontWeight.w500,
                                                                            textAlign: TextAlign.center),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ],
                                                            ),
                                                          ) : SizedBox(),

                                                        if(_pageIndex == 1)
                                                          Directionality(
                                                            textDirection: textDirection,
                                                            child: Column(
                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                              children: [
                                                                Padding(
                                                                  padding: const EdgeInsets.only(left: 12, right: 12,),
                                                                  child: Row(
                                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                    children: [
                                                                      CustomeText(text: "${lableModel.trolleyListTotal} (${trollyList.length})", fontColor: MyColor.colorBlack, fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5, fontWeight: FontWeight.w500, textAlign: TextAlign.start),
                                                                      (flightDetail != null) ? Container(
                                                                        padding : EdgeInsets.symmetric(horizontal: SizeConfig.blockSizeHorizontal * 2.5, vertical: SizeConfig.blockSizeVertical * 0.1),
                                                                        decoration : BoxDecoration(
                                                                          borderRadius: BorderRadius.circular(20),
                                                                          color: (flightDetail != null)
                                                                              ? (flightDetail!.flightStatus == "Arrived")
                                                                              ? MyColor.flightArrived
                                                                              : (flightDetail!.flightStatus == "Finalized")
                                                                              ? MyColor.flightFinalize
                                                                              : (flightDetail!.flightStatus == "Not Arrived")
                                                                              ? MyColor.flightNotArrived
                                                                              : null
                                                                              : null,
                                                                        ),
                                                                        child: CustomeText(
                                                                            text: (flightDetail != null)
                                                                                ? (flightDetail!.flightStatus == "Arrived")
                                                                                ? lableModel.arrived!
                                                                                : (flightDetail!.flightStatus == "Finalized")
                                                                                ? lableModel.finalized!
                                                                                : (flightDetail!.flightStatus == "Not Arrived")
                                                                                ? lableModel.notArrived!
                                                                                : ""
                                                                                : "",
                                                                            fontColor: MyColor.colorBlack,
                                                                            fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                                                            fontWeight: FontWeight.w500,
                                                                            textAlign: TextAlign.start),
                                                                      ) : SizedBox(),
                                                                    ],
                                                                  ),
                                                                ),
                                                                (trollyList.isNotEmpty)
                                                                    ? ListView.builder(
                                                                  physics: NeverScrollableScrollPhysics(),
                                                                  shrinkWrap: true,
                                                                  itemCount: trollyList.length,
                                                                  itemBuilder: (context, index) {
                                                                    TrollyDetails trollyDetail = trollyList[index];

                                                                /*    WidgetsBinding.instance.addPostFrameCallback((_) {
                                                                      _checkScrollable();
                                                                    });
*/
                                                                    return Padding(
                                                                      padding: const EdgeInsets.only(left: 12, right: 12, top: 4, bottom: 4),
                                                                      child: Container(
                                                                        padding: const EdgeInsets.all(12),
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
                                                                        child: Row(
                                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                          children: [
                                                                            CustomeText(
                                                                                text: "${trollyDetail.trollyNo}",
                                                                                fontColor: MyColor.colorBlack,
                                                                                fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                                                                fontWeight: FontWeight.w600,
                                                                                textAlign: TextAlign.start),
                                                                            CustomeText(
                                                                                text: "${trollyDetail.trollyReceiveTime}",
                                                                                fontColor: MyColor.textColorGrey2,
                                                                                fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                                                                fontWeight: FontWeight.w400,
                                                                                textAlign: TextAlign.start),

                                                                          ],
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
                                                                        fontColor: MyColor.textColorGrey,
                                                                        fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_2_0,
                                                                        fontWeight: FontWeight.w500,
                                                                        textAlign: TextAlign.center),
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
                                            ),

                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),

                                /*BlocListener<ValidationMsgCubit, ValidationMsgState>(
                                  listener: (context, state) {
                                    if (state is ValidationMsgLoading) {
                                      DialogUtils.showLoadingDialog(context, message: lableModel.loading);

                                    }
                                    else if (state is ValidationMsgSuccess) {

                                      //responce validation message

                                      DialogUtils.hideLoadingDialog(context);
                                      validationMessages = state.validationMessages;
                                      ValidationMessageCodeUtils.someErrorOccurred = validationMessages![ValidationMessageCodeUtils.H000015]!;

                                      //call default ULD acceptance api
                                      context.read<UldAcceptanceCubit>().getDefaultUldAcceptance(
                                          widget.refrelCode,
                                          _user!.userProfile!.userIdentity!,
                                          _splashDefaultData!.companyCode!,
                                          widget.menuId);

                                    }
                                    else if (state is ValidationMsgFailure) {
                                      DialogUtils.hideLoadingDialog(context);
                                      Vibration.vibrate(duration: 500);
                                      SnackbarUtil.showSnackbar(context, state.error, MyColor.colorRed, icon: FontAwesomeIcons.times);
                                    }
                                  },
                                  // main bloc logic of uld acceptance for validate location, uld number accept, & search flight to get uld number detail
                                  child:
                                ),*/
                              ],
                            ),
                          ),

                    )),
                    (_isScrollable) ? Positioned(
                      bottom: 30,
                      right: 5,
                      child: InkWell(
                        onTap: () {
                          if (_isAtTop) {
                            // Scroll to the bottom of the list
                            _scrollController.animateTo(
                              _scrollController.position.maxScrollExtent,
                              duration: Duration(milliseconds: 500), // Increased duration
                              curve: Curves.easeOut,
                            );
                          } else if (_isAtBottom) {
                            // Scroll to the top of the list
                            _scrollController.animateTo(
                              _scrollController.position.minScrollExtent,
                              duration: Duration(milliseconds: 500), // Increased duration
                              curve: Curves.easeOut,
                            );
                          } else {
                            // Scroll in the respective direction
                            if (_scrollController.offset < (_scrollController.position.maxScrollExtent / 2)) {
                              _scrollController.animateTo(
                                _scrollController.position.maxScrollExtent,
                                duration: Duration(milliseconds: 500),
                                curve: Curves.easeOut,
                              );
                            } else {
                              _scrollController.animateTo(
                                _scrollController.position.minScrollExtent,
                                duration: Duration(milliseconds: 500),
                                curve: Curves.easeOut,
                              );
                            }
                          }
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle, // Ensures the container is circular like CircleAvatar
                            gradient: LinearGradient(
                              colors: [
                                MyColor.bggradientfirst,  // Starting color
                                MyColor.bggradientsecond,    // Ending color (you can replace this with your desired color)
                              ],
                              begin: Alignment.topLeft,    // Direction of the gradient
                              end: Alignment.bottomRight,
                            ),
                          ),
                          child: CircleAvatar(
                            radius: SizeConfig.blockSizeVertical * SizeUtils.ICONSIZE_2_5,
                            backgroundColor: Colors.transparent,  // Set to transparent so the gradient shows
                            child: (_isAtTop) ?  SvgPicture.asset(arrowDown, height: SizeConfig.blockSizeVertical * SizeUtils.ICONSIZE3 ,) : SvgPicture.asset(arrowUp, height: SizeConfig.blockSizeVertical * SizeUtils.ICONSIZE3),
                             /*child: Icon(
                        (_isAtTop) ? FontAwesomeIcons.longArrowDown : FontAwesomeIcons.longArrowUp,
                        color: MyColor.colorWhite,
                      ),*/
                          ),
                        ),
                      ),
                    ) : SizedBox()
                  ],
                ),
              ),
             /* floatingActionButton: (_isScrollable)
                  ? InkWell(
                onTap: () {
                  if (_isAtTop) {
                    // Scroll to the bottom of the list
                    _scrollController.animateTo(
                      _scrollController.position.maxScrollExtent,
                      duration: Duration(milliseconds: 500), // Increased duration
                      curve: Curves.easeOut,
                    );
                  } else if (_isAtBottom) {
                    // Scroll to the top of the list
                    _scrollController.animateTo(
                      _scrollController.position.minScrollExtent,
                      duration: Duration(milliseconds: 500), // Increased duration
                      curve: Curves.easeOut,
                    );
                  } else {
                    // Scroll in the respective direction
                    if (_scrollController.offset < (_scrollController.position.maxScrollExtent / 2)) {
                      _scrollController.animateTo(
                        _scrollController.position.maxScrollExtent,
                        duration: Duration(milliseconds: 500),
                        curve: Curves.easeOut,
                      );
                    } else {
                      _scrollController.animateTo(
                        _scrollController.position.minScrollExtent,
                        duration: Duration(milliseconds: 500),
                        curve: Curves.easeOut,
                      );
                    }
                  }
                },
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle, // Ensures the container is circular like CircleAvatar
                    gradient: LinearGradient(
                      colors: [
                        MyColor.bggradientfirst,  // Starting color
                        MyColor.bggradientsecond,    // Ending color (you can replace this with your desired color)
                      ],
                      begin: Alignment.topLeft,    // Direction of the gradient
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: CircleAvatar(
                    radius: SizeConfig.blockSizeVertical * SizeUtils.ICONSIZE_2_5,
                    backgroundColor: Colors.transparent,  // Set to transparent so the gradient shows
                    child: (_isAtTop) ?  SvgPicture.asset(arrowDown, height: SizeConfig.blockSizeVertical * SizeUtils.ICONSIZE3 ,) : SvgPicture.asset(arrowUp, height: SizeConfig.blockSizeVertical * SizeUtils.ICONSIZE3),

                  ),
                ),
              )
                  : null,*/

            ),
          ),
        ),
      ),
    );


  }

  // check scrollable or not
  void _checkScrollable() {
    final RenderBox renderBox = _contentKey.currentContext?.findRenderObject() as RenderBox;
    contentHeight = renderBox.size.height;
    screenHeight = MediaQuery.of(context).size.height;

    setState(() {
      _isScrollable = contentHeight > screenHeight;
    });
  }

  // leave location focus
  Future<void> leaveLocationFocus() async {
    if (locationController.text.isNotEmpty) {
      //call location validation api
      await context.read<UldAcceptanceCubit>().getValidateLocation(
        locationController.text,
        _user!.userProfile!.userIdentity!,
        _splashDefaultData!.companyCode!,
        widget.menuId,
        "a"
      );
    }else{

    }
  }

  //leave uld no focus
  Future<void> _leaveUldNoFocus() async {
    if (uldNoController.text.isNotEmpty) {
      //call flight no. and date using ULDNo api
      if(_isvalidULDNo == true){

        await context.read<UldAcceptanceCubit>().getFlightFromULD(
            uldNoController.text.replaceAll(" ", ""),
            _user!.userProfile!.userIdentity!,
            _splashDefaultData!.companyCode!,
            widget.menuId
        );
      }

    }
  }
  //user load data & default load data
  Future<void> _loadUser() async {
    final user = await savedPrefrence.getUserData();
    final splashDefaultData = await savedPrefrence.getSplashDefaultData();
    if (user != null && splashDefaultData != null) {
      setState(() {
        _user = user;
        _splashDefaultData = splashDefaultData;
      });

      inactivityTimerManager = InactivityTimerManager(
        context: context,
        timeoutMinutes: _splashDefaultData!.activeLoginTime!,  // Set the desired inactivity time here
        onTimeout: _handleInactivityTimeout,  // Define what happens when timeout occurs
      );
      inactivityTimerManager?.startTimer();  // Start the inactivity timer

      // call validation message api
  //    context.read<ValidationMsgCubit>().validationMessage(widget.refrelCode, CommonUtils.defaultLanguageCode, _splashDefaultData!.companyCode!);
      context.read<UldAcceptanceCubit>().getButtonRolesAndRights(widget.menuId, _user!.userProfile!.userIdentity!, _splashDefaultData!.companyCode!);

//      context.read<UldAcceptanceCubit>().getDefaultUldAcceptance(widget.refrelCode, _user!.userProfile!.userIdentity!, _company!.companyCode!);
    }
  }

  Future<void> _handleInactivityTimeout() async {

    bool? activateORNot = await DialogUtils.showingActivateTimerDialog(context, _user!.userProfile!.userId!, _splashDefaultData!.companyCode!);
    print("CHECK_ACTIVATE_OR_NOT====== ${activateORNot}");
    if(activateORNot == true){
      inactivityTimerManager!.resetTimer();
    }else{
      _logoutUser();
    }

  }

  void _resumeTimerOnInteraction() {
    inactivityTimerManager?.resetTimer();
    print('Activity detected, timer reset');
  }


  Future<void> _logoutUser() async {
    await savedPrefrence.logout();
    Navigator.pushAndRemoveUntil(
      context, CupertinoPageRoute(builder: (context) => const SignInScreenMethod(),), (route) => false,
    );
  }

  //validate location search btn
  void _validateLocationSearchBtn() {
    setState(() {
      _isLocationSearchBtnEnable = locationController.text.isNotEmpty;
    });
  }
  
  //update accept button status code change ui in list of uld number
  void _updateButtonStatus(int uldSeqNo, String newStatus) {

    setState(() {
      for (var uld in filteredUldModelList) {
        if (uld.fltULDSeqNo!.contains(uldSeqNo.toString())) {
          uld.buttonStatus = newStatus;
          break;
        }
      }
    });
  }

  //update search
  void _updateSearchList(String searchString) {
    setState(() {
      filteredUldModelList = _applyFiltersAndSorting(
        uldList,
        searchString,
        selectedActionSorting,
        selectedFilterSorting,
      );
    });
  }

  //update sorting option
  void _updateSortingOptions(String actionSorting, String filterSorting) {
    setState(() {
      selectedActionSorting = actionSorting;
      selectedFilterSorting = filterSorting;
      filteredUldModelList = _applyFiltersAndSorting(
        uldList,
        '', // Search string can be empty here if not used
        selectedActionSorting,
        selectedFilterSorting,
      );
    });
  }

  //appliying filter for sorting
  List<ULDDetails> _applyFiltersAndSorting(List<ULDDetails> list, String searchString, String actionSorting, String filterSorting,) {
    // Filter by search string
    List<ULDDetails> filteredList = list.where((item) {
      return item.uLDNo!.toLowerCase().contains(searchString.toLowerCase());
    }).toList();

    // Filter by action if necessary
    if (actionSorting.isNotEmpty) {
      filteredList = filteredList.where((item) {
        return actionSorting == "Accepted"
            ? (item.buttonStatus!.replaceAll(" ", "") == "D" || item.buttonStatus!.replaceAll(" ", "") == "U" || item.buttonStatus!.replaceAll(" ", "") == "S")
            : item.buttonStatus!.replaceAll(" ", "") == "A";
      }).toList();
    }

    // Apply sorting
    if (filterSorting.isNotEmpty) {
      filteredList.sort((a, b) {
        if (filterSorting == 'A - Z') {
          return a.uLDNo!.compareTo(b.uLDNo!);
        } else {
          return b.uLDNo!.compareTo(a.uLDNo!);
        }
      });
    }

    return filteredList;
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

    if (_isGetButtonEnabled) {
      if (locationController.text.isNotEmpty) {
        if (isvalidateLocation) {
          if (flightNoEditingController.text.isNotEmpty) {

            if (picked != null) {

              if(_selectedDate == picked){

                setState(() {
                  _selectedDate = picked;
                  dateEditingController.text = DateFormat('dd-MMM-yy').format(_selectedDate!).toUpperCase();
                });



              }
              else{
                setState(() {
                  _selectedDate = picked;
                  dateEditingController.text = DateFormat('dd-MMM-yy').format(_selectedDate!).toUpperCase();
                  _isvalidateFlightNo = false;
                  flightDetail = null;
                  if(uldList.isNotEmpty && filteredUldModelList.isNotEmpty){
                    uldList.clear();
                    filteredUldModelList.clear();
                    trollyList.clear();
                    btCountTrolly = 0;
                    bulkTrollyDetail = null;
                  }
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    FocusScope.of(context).requestFocus(flightBtnFocusNode);
                  },
                  );
                });
              }

              String flightNo = flightNoEditingController.text;
              String flightDate = dateEditingController.text;

              context.read<UldAcceptanceCubit>().getUldAcceptanceList(
                  _user!.userProfile!.userIdentity!,
                  _splashDefaultData!.companyCode!,
                  flightNo.replaceAll(' ', ''),
                  flightDate,"",
                  widget.menuId);

            }
            else{
              WidgetsBinding.instance.addPostFrameCallback((_) {
                FocusScope.of(context).requestFocus(flightNoFocusNode);
                _checkScrollable();
              },
              );
            }


          } else {
            openValidationDialog(widget.lableModel!.enterFlightNo!, flightNoFocusNode);
          }
        } else {
          DialogUtils.showDataNotFoundDialogbot(context, "${widget.lableModel!.validateLocation}", widget.lableModel!);
        }
      } else {
        openValidationDialog(widget.lableModel!.enterLocationMsg!, locationFocusNode);
      }
    } else {}

    // Ensure the flag is reset even if the dialog is dismissed without selection
    _isDatePickerOpen = false;

    // Manually unfocus to close the keyboard and ensure consistent behavior
    dateFocusNode.unfocus();
  }

  Widget _checkWidget(int tabcontrollerindex, ui.TextDirection textDirection, LableModel lableModel) {
    if (tabcontrollerindex == 0) {
      return Column(
        children: [
          // add uld in text with check validation for uld number
          SizedBox(
            height: SizeConfig.blockSizeVertical * SizeUtils.HEIGHT2,
          ),
          Directionality(
            textDirection: textDirection,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 1,
                  child: CustomeEditTextWithBorder(
                    lablekey: "ULD",
                    textDirection: textDirection,
                    controller: uldNoController,
                    nextFocus: groupIdFocusNode,
                    hasIcon: false,
                    hastextcolor: true,
                    isShowSuffixIcon: uldNoController.text.isEmpty ? false : (_suffixIconUld) ? true : false,
                    animatedLabel: true,
                    needOutlineBorder: true,
                    labelText: "${lableModel.uldNo} *",
                    focusNode: uldNoFocusNode,
                    readOnly: locationController.text.isNotEmpty ? false : true,
                    maxLength: 11,

                    onChanged: (value, validate) async {

                      _suffixIconUld = true;
                      _uldNotExit = false;
                      setState(() {
                        if (validate) {
                          _isvalidULDNo = true;
                          CommonUtils.ULDSEQUENCENUMBER = -1;
                          CommonUtils.ULDSEQUENCENUMBER = -1;

                        } else {
                          _isvalidULDNo = false;
                          flightFromULDModel = null;
                          uldList.clear();
                          filteredUldModelList.clear();
                          scanFlightController.clear();
                          flightNoEditingController.clear();
                          dateEditingController.clear();
                          CommonUtils.ULDSEQUENCENUMBER = -1;
                          CommonUtils.ULDSEQUENCENUMBER = -1;
                          flightDetail = null;
                          btCountTrolly = 0;
                          bulkTrollyDetail = null;
                          trollyList.clear();
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            FocusScope.of(context).requestFocus(uldNoFocusNode);
                          });
                        }

                      });

                    },
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
                  onTap: () async {
                    FocusScope.of(context).unfocus();
                    uldNoController.clear();
                    if (locationController.text.isNotEmpty) {
                      if (isvalidateLocation) {

                        //call flight no. and date using ULDNo api
                        ULDScanQR();

                      } else {
                        DialogUtils.showDataNotFoundDialogbot(context, "${lableModel.validateGate}", lableModel);
                      }
                    }
                    else {
                      openValidationDialog(lableModel.enterGateMsg!, locationFocusNode);
                    }
                  },

                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SvgPicture.asset(search, height: SizeConfig.blockSizeVertical * SizeUtils.ICONSIZE3),
                  ),

                ),

                /*InkWell(
                    onTap: () async {
                      FocusScope.of(context).unfocus();
                      if(CommonUtils.ULDSEQUENCENUMBER == 0 || _isvalidULDNo == false){

                      }else{
                        if (locationController.text.isNotEmpty) {
                          if (isvalidateLocation) {
                            if (uldNoController.text.isNotEmpty) {
                              //call flight no. and date using ULDNo api
                              await context.read<UldAcceptanceCubit>().getFlightFromULD(
                                  uldNoController.text.replaceAll(" ", ""),
                                  _user!.userProfile!.userIdentity!,
                                  _splashDefaultData!.companyCode!,
                                  widget.menuId
                              );

                            }
                            else {
                              openValidationDialog("${lableModel.enteruldNoMsg}", uldNoFocusNode);
                            }
                          } else {
                            DialogUtils.showDataNotFoundDialogbot(context, "${lableModel.validateGate}", lableModel);
                          }
                        }
                        else {
                          openValidationDialog(lableModel.enterGateMsg!, locationFocusNode);
                        }
                      }
                    },

                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SvgPicture.asset((CommonUtils.ULDSEQUENCENUMBER == 0 || _isvalidULDNo == false) ? searchd : search, height: SizeConfig.blockSizeVertical * SizeUtils.ICONSIZE3),
                  ),

                ),*/
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
                Expanded(
                  flex:1,
                  child: GroupIdCustomTextField(
                    textDirection: textDirection,
                    controller: groupIdController,
                    hasIcon: false,
                    hastextcolor: true,
                    animatedLabel: true,
                    needOutlineBorder: true,
                    focusNode: groupIdFocusNode,
                    labelText: (_isGroupIdIsMandatory == "Y")
                        ? "${lableModel.groupId} *"
                        : "${lableModel.groupId}",
                    onChanged: (value) {},
                    readOnly: locationController.text.isNotEmpty ? false : true,
                    textInputType: TextInputType.text,
                    inputAction: TextInputAction.next,
                    hintTextcolor: MyColor.colorGrey,
                    verticalPadding: 0,
                    maxLength: 15,
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
                SizedBox(
                  width: SizeConfig.blockSizeVertical * SizeUtils.ICONSIZE5,
                ),
              ],
            ),
          ),
          SizedBox(
            height: SizeConfig.blockSizeVertical,
          ),
          (_uldNotExit == true) ? SizedBox() : Directionality(
            textDirection: textDirection,
            child: Row(
              children: [
                (uldNoController.text.isNotEmpty) ? (_isvalidULDNo == true) ? Expanded(
                  child: RoundedButtonBlue(
                    text: "${lableModel.uldDamageAccept}", isborderButton: false, textDirection: textDirection,
                    press: () async {

                      FocusScope.of(context).unfocus();
                      
                      if(isButtonEnabled("uldDamageAccept", buttonRightsList)){
                        if(CommonUtils.ULDSEQUENCENUMBER == 0){
                        }
                        else{
                          if (_isAcceptBtnEnable) {
                            if (locationController.text.isNotEmpty) {
                              if (isvalidateLocation) {
                                if (uldNoController.text.isNotEmpty) {
                                  if (_isGroupIdIsMandatory == "Y") {
                                    if (groupIdController.text.isNotEmpty) {
                                      if(_isvalidULDNo){
                                        inactivityTimerManager!.stopTimer();
                                        String damageOrNot = await Navigator.push(
                                            context,
                                            CupertinoPageRoute(
                                              builder: (context) => UldDamagedPage(
                                                importSubMenuList: widget.importSubMenuList,
                                                exportSubMenuList: widget.exportSubMenuList,
                                                locationCode: locationController.text,
                                                menuId: widget.menuId,
                                                ULDNo: uldNoController.text,
                                                ULDSeqNo: CommonUtils.ULDSEQUENCENUMBER,
                                                flightSeqNo: CommonUtils.FLIGHTSEQUENCENUMBER,
                                                groupId: groupIdController.text,
                                                menuCode: widget.refrelCode,
                                                isRecordView:  2,
                                                mainMenuName: widget.mainMenuName,
                                                buttonRightsList: buttonRightsList,
                                              ),
                                            ));
                                        if(damageOrNot == "U"){
                                          _isdamageOrNot = "U";
                                          await context.read<UldAcceptanceCubit>().uldDamageAccept(CommonUtils.FLIGHTSEQUENCENUMBER, CommonUtils.ULDSEQUENCENUMBER, uldNoController.text.replaceAll(" ", ""), locationController.text, groupIdController.text, _user!.userProfile!.userIdentity!, _splashDefaultData!.companyCode!, widget.menuId);
                                          _resumeTimerOnInteraction();
                                        }
                                        else if(damageOrNot == "S"){
                                          _isdamageOrNot = "S";
                                          await context.read<UldAcceptanceCubit>().uldDamageAccept(CommonUtils.FLIGHTSEQUENCENUMBER, CommonUtils.ULDSEQUENCENUMBER, uldNoController.text.replaceAll(" ", ""), locationController.text, groupIdController.text, _user!.userProfile!.userIdentity!, _splashDefaultData!.companyCode!, widget.menuId);
                                          _resumeTimerOnInteraction();
                                        }
                                        else{
                                          _resumeTimerOnInteraction();
                                          _isdamageOrNot = "";
                                        }
                                      }
                                      else{
                                        openValidationDialog(lableModel.enteruldNoMsg!, uldNoFocusNode);
                                      }
                                    }
                                    else {
                                      openValidationDialog(lableModel.enterGropIdMsg!, groupIdFocusNode);
                                    }
                                  }
                                  else {
                                    inactivityTimerManager!.stopTimer();
                                    String damageOrNot = await Navigator.push(
                                        context,
                                        CupertinoPageRoute(
                                          builder: (context) => UldDamagedPage(
                                            importSubMenuList: widget.importSubMenuList,
                                            exportSubMenuList: widget.exportSubMenuList,
                                            locationCode: locationController.text,
                                            menuId: widget.menuId,
                                            ULDNo: uldNoController.text,
                                            ULDSeqNo: CommonUtils.ULDSEQUENCENUMBER,
                                            flightSeqNo: CommonUtils.FLIGHTSEQUENCENUMBER,
                                            groupId: groupIdController.text,
                                            menuCode: widget.refrelCode,
                                            isRecordView: 2,
                                            mainMenuName: widget.mainMenuName,
                                            buttonRightsList: buttonRightsList,
                                          ),
                                        ));
                                    if(damageOrNot == "U"){
                                      _isdamageOrNot = "U";
                                      await context.read<UldAcceptanceCubit>().uldDamageAccept(CommonUtils.FLIGHTSEQUENCENUMBER, CommonUtils.ULDSEQUENCENUMBER, uldNoController.text.replaceAll(" ", ""), locationController.text, groupIdController.text, _user!.userProfile!.userIdentity!, _splashDefaultData!.companyCode!, widget.menuId);
                                      _resumeTimerOnInteraction();
                                    }else if(damageOrNot == "S"){
                                      _isdamageOrNot = "S";
                                      await context.read<UldAcceptanceCubit>().uldDamageAccept(CommonUtils.FLIGHTSEQUENCENUMBER, CommonUtils.ULDSEQUENCENUMBER, uldNoController.text.replaceAll(" ", ""), locationController.text, groupIdController.text, _user!.userProfile!.userIdentity!, _splashDefaultData!.companyCode!, widget.menuId);
                                      _resumeTimerOnInteraction();
                                    }else{
                                      _isdamageOrNot = "";
                                      _resumeTimerOnInteraction();
                                    }
                                  }
                                }
                                else {
                                  openValidationDialog(lableModel.enteruldNoMsg!, uldNoFocusNode);
                                }
                              } else {
                                DialogUtils.showDataNotFoundDialogbot(context, "${lableModel.validateGate}", lableModel);
                              }
                            }
                            else {
                              openValidationDialog(lableModel.enterGateMsg!, locationFocusNode);
                            }
                          } else if (uldNoController.text.isEmpty) {
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              FocusScope.of(context).requestFocus(uldNoFocusNode);
                            },
                            );
                          }
                        }
                      }else{
                        SnackbarUtil.showSnackbar(context, ValidationMessageCodeUtils.AuthorisedRolesAndRightsMsg, MyColor.colorRed, icon: FontAwesomeIcons.times);
                        Vibration.vibrate(duration: 500);
                      }
                      
                      


                    },),
                ) : SizedBox() : SizedBox(),
                SizedBox(width: SizeConfig.blockSizeHorizontal * SizeUtils.WIDTH3,),
                (uldNoController.text.isNotEmpty) ? (_isvalidULDNo == true) ? Expanded(
                  child: RoundedButtonBlue(
                    text: "${lableModel.accept}",
                    press: () async {
                      FocusScope.of(context).unfocus();
                      if (_isAcceptBtnEnable) {

                        if(isButtonEnabled("accept", buttonRightsList)){
                          if (locationController.text.isNotEmpty) {
                            if (isvalidateLocation) {
                              if (uldNoController.text.isNotEmpty) {
                                if (_isGroupIdIsMandatory == "Y") {
                                  if (groupIdController.text.isNotEmpty) {
                                    uldAcceptPassData(
                                        CommonUtils.FLIGHTSEQUENCENUMBER,
                                        CommonUtils.ULDSEQUENCENUMBER,
                                        uldNoController.text.replaceAll(' ', ''),
                                        locationController.text,
                                        groupIdController.text,
                                        _user!.userProfile!.userIdentity!,
                                        _splashDefaultData!.companyCode!);

                                    CommonUtils.ULDSEQUENCENUMBER = CommonUtils.ULDSEQUENCENUMBER;
                                    CommonUtils.ULDBT = 2;
                                  } else {
                                    openValidationDialog(lableModel.enterGropIdMsg!, groupIdFocusNode);
                                  }
                                } else {
                                  if (!isvalidateLocation) {
                                    await leaveLocationFocus();
                                    uldAcceptPassData(
                                        CommonUtils.FLIGHTSEQUENCENUMBER,
                                        CommonUtils.ULDSEQUENCENUMBER,
                                        uldNoController.text.replaceAll(' ', ''),
                                        locationController.text,
                                        groupIdController.text,
                                        _user!.userProfile!.userIdentity!,
                                        _splashDefaultData!.companyCode!);

                                    CommonUtils.ULDSEQUENCENUMBER = CommonUtils.ULDSEQUENCENUMBER;
                                    CommonUtils.ULDBT = 2;
                                  } else {
                                    uldAcceptPassData(
                                        CommonUtils.FLIGHTSEQUENCENUMBER,
                                        CommonUtils.ULDSEQUENCENUMBER,
                                        uldNoController.text.replaceAll(' ', ''),
                                        locationController.text,
                                        groupIdController.text,
                                        _user!.userProfile!.userIdentity!,
                                        _splashDefaultData!.companyCode!);

                                    CommonUtils.ULDSEQUENCENUMBER = CommonUtils.ULDSEQUENCENUMBER;
                                    CommonUtils.ULDBT = 2;
                                  }
                                }
                              } else {
                                openValidationDialog(lableModel.enteruldNoMsg!, uldNoFocusNode);
                              }
                            } else {
                              DialogUtils.showDataNotFoundDialogbot(context, "${lableModel.validateGate}", lableModel);
                            }
                          }
                          else {
                            openValidationDialog(lableModel.enterGateMsg!, locationFocusNode);
                          }
                        }else{
                          SnackbarUtil.showSnackbar(context, ValidationMessageCodeUtils.AuthorisedRolesAndRightsMsg, MyColor.colorRed, icon: FontAwesomeIcons.times);
                          Vibration.vibrate(duration: 500);
                        }

                      }
                      else if (uldNoController.text.isEmpty) {
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          FocusScope.of(context).requestFocus(uldNoFocusNode);
                        },
                        );
                      }


                    },
                  ),
                ) : SizedBox() : SizedBox()
              ],
            ),
          ),
         /* (_uldNotExit == true) ? (uldNoController.text.isNotEmpty) ? (_isvalidULDNo == true) ? Directionality(textDirection: textDirection, child:
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding : EdgeInsets.symmetric(horizontal: SizeConfig.blockSizeHorizontal * 2.5, vertical: SizeConfig.blockSizeVertical * 0.1),
                decoration : BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: MyColor.notAcceptedColor
                ),
                child: CustomeText(
                    text: "${lableModel.uLDNotExit}",
                    fontColor: MyColor.colorBlack,
                    fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                    fontWeight: FontWeight.w500,
                    textAlign: TextAlign.start),
              ),
              SizedBox(height: SizeConfig.blockSizeVertical,),
              RoundedButtonBlue(text: "${lableModel.processedForULD}",
                press: () {
                if(isButtonEnabled("processedForULD", buttonRightsList)){
                  openUCRBottomDialog(context, uldNoController.text, lableModel, textDirection, _isGroupIdIsMandatory, buttonRightsList);
                }else{
                  SnackbarUtil.showSnackbar(context, ValidationMessageCodeUtils.AuthorisedRolesAndRightsMsg, MyColor.colorRed, icon: FontAwesomeIcons.times);
                  Vibration.vibrate(duration: 500);
                }

              },)
            ],
          )) : SizedBox() : SizedBox() : SizedBox()*/
        ],
      );
    }
    else {
      return Column(
        children: [
          SizedBox(
            height: SizeConfig.blockSizeVertical * SizeUtils.HEIGHT2,
          ),
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
                    readOnly: locationController.text.isNotEmpty ? false : true,
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
                    nextFocus: trollyGroupIdFocusNode,
                    onChanged: (value) {},
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
              ),
            ],
          ),
          SizedBox(
            height: SizeConfig.blockSizeVertical * SizeUtils.HEIGHT2,
          ),
          Directionality(
            textDirection: textDirection,
            child: GroupIdCustomTextField(
              textDirection: textDirection,
              controller: trollyGroupIdController,
              hasIcon: false,
              hastextcolor: true,
              animatedLabel: true,
              needOutlineBorder: true,
              focusNode: trollyGroupIdFocusNode,
              labelText: (_isGroupIdIsMandatory == "Y")
                  ? "${lableModel.groupId} *"
                  : "${lableModel.groupId}",
              onChanged: (value) {},
              readOnly: locationController.text.isNotEmpty ? false : true,
              fillColor: locationController.text.isNotEmpty
                  ? Colors.grey.shade100
                  : Colors.grey.shade300,
              textInputType: TextInputType.text,
              inputAction: TextInputAction.next,
              hintTextcolor: MyColor.colorGrey,
              verticalPadding: 0,
              maxLength: 15,
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
            height: SizeConfig.blockSizeVertical,
          ),
          Row(
            children: [
              CustomeText(text: "${lableModel.bTCount}", fontColor: MyColor.textColorGrey2, fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_6, fontWeight: FontWeight.w400, textAlign: TextAlign.start),
              SizedBox(width: SizeConfig.blockSizeHorizontal,),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 1),
                decoration: BoxDecoration(
                  color: MyColor.btCountColor,
                  borderRadius: BorderRadius.circular(SizeConfig.blockSizeHorizontal * SizeUtils.BORDERRADIOUS_6)
                ),
                child: CustomeText(
                    text: (bulkTrollyDetail == null) ? "${btCountTrolly}" : "${btCountTrolly}",
                    fontColor: MyColor.textColorGrey2,
                    fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                    fontWeight: FontWeight.w500,
                    textAlign: TextAlign.center),
              )
            ],
          ),
          SizedBox(
            height: SizeConfig.blockSizeVertical,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [

              Expanded(
                flex: 1,
                child: RoundedButtonBlue(
                  text: "${lableModel.trollyFBT}",
                  color:  MyColor.primaryColorblue,
                  press: () async {
                    if(isButtonEnabled("trollyFBT", buttonRightsList)){
                      if (locationController.text.isNotEmpty) {
                        if (isvalidateLocation) {
                          if (trollyTypeController.text.isNotEmpty) {
                            if (trollyNumberController.text.isNotEmpty) {
                              if (_isGroupIdIsMandatory == "Y") {
                                if (trollyGroupIdController.text.isNotEmpty) {
                                  if (flightNoEditingController.text.isNotEmpty) {
                                    if (dateEditingController.text.isNotEmpty) {
                                      // print("FLIGHT_SEQ_NUMBER---- ${flightDetail!.fltSeqNo!}");
                                      if (_isvalidateFlightNo) {

                                        String flightNo = flightNoEditingController.text;
                                        String flightDate = dateEditingController.text;
                                        DateTime currentDateTime = DateTime.now();
                                        String formattedDate = DateFormat('dd-MMM-yy kk:mm').format(currentDateTime).toUpperCase();
                                        print("CHECK_CURRUNT_DATE TIME === ${formattedDate}");
                                        CommonUtils.TROLLYTYPENUMBER = "${trollyTypeController.text} ${trollyNumberController.text}";
                                        CommonUtils.TROLLYDATETIME = formattedDate;

                                        trollyAcceptPassData(
                                            (flightDetail == null) ? -1 : flightDetail!.fltSeqNo!,
                                            flightNo.replaceAll(" ", ""),
                                            flightDate,
                                            locationController.text,
                                            trollyGroupIdController.text,
                                            trollyTypeController.text,
                                            trollyNumberController.text,
                                            0,
                                            _user!.userProfile!.userIdentity!,
                                            _splashDefaultData!.companyCode!);


                                        CommonUtils.TROLLYBT = 0;
                                      } else {
                                        openValidationDialog(lableModel.validateFlightMsg!, flightBtnFocusNode);
                                      }
                                    }
                                    else {
                                      openValidationDialog(lableModel.enterFlightDate!, dateFocusNode);
                                    }
                                  }
                                  else {
                                    openValidationDialog(lableModel.enterFlightNo!, flightNoFocusNode);
                                  }
                                } else {
                                  openValidationDialog(lableModel.enterGropIdMsg!, trollyGroupIdFocusNode);
                                }
                              } else {
                                if (flightNoEditingController.text.isNotEmpty) {
                                  if (dateEditingController.text.isNotEmpty) {
                                    if (_isvalidateFlightNo) {
                                      String flightNo = flightNoEditingController.text;
                                      String flightDate = dateEditingController.text;

                                      trollyAcceptPassData(
                                          (flightDetail == null) ? -1 : flightDetail!.fltSeqNo!,
                                          flightNo.replaceAll(" ", ""),
                                          flightDate,
                                          locationController.text,
                                          trollyGroupIdController.text,
                                          trollyTypeController.text,
                                          trollyNumberController.text,
                                          0,
                                          _user!.userProfile!.userIdentity!,
                                          _splashDefaultData!.companyCode!);

                                      CommonUtils.TROLLYBT = 0;
                                    } else {
                                      openValidationDialog(lableModel.validateFlightMsg!, flightBtnFocusNode);
                                    }
                                  } else {
                                    openValidationDialog(lableModel.enterFlightDate!, dateFocusNode);
                                  }
                                } else {
                                  openValidationDialog(lableModel.enterFlightNo!, flightNoFocusNode);
                                }
                              }
                            } else {
                              openValidationDialog(lableModel.entertrollyNumberMsg!, trollyNumberFocusNode);
                            }
                          } else {
                            openValidationDialog(lableModel.entertrollyTypeMsg!, trollyTypeFocusNode);
                          }
                        } else {
                          DialogUtils.showDataNotFoundDialogbot(context, "${lableModel.validateGate}", lableModel);
                        }
                      }
                      else {
                        openValidationDialog(lableModel.enterGateMsg!, locationFocusNode);
                      }
                    }else{
                      SnackbarUtil.showSnackbar(context, ValidationMessageCodeUtils.AuthorisedRolesAndRightsMsg, MyColor.colorRed, icon: FontAwesomeIcons.times);
                      Vibration.vibrate(duration: 500);
                    }

                  },
                ),
              ),
              SizedBox(
                width: SizeConfig.blockSizeHorizontal * SizeUtils.WIDTH4,
              ),
              Expanded(
                flex: 1,
                child: RoundedButtonBlue(
                  text: "${lableModel.trollyLBT}",
                  color: MyColor.primaryColorblue,
                  press: () async {
                    if(isButtonEnabled("trollyLBT", buttonRightsList)){
                      if (_isfirstBtLastBtEnable) {
                        if (locationController.text.isNotEmpty) {
                          if (isvalidateLocation) {
                            if (trollyTypeController.text.isNotEmpty) {
                              if (trollyNumberController.text.isNotEmpty) {
                                if (_isGroupIdIsMandatory == "Y") {
                                  if (trollyGroupIdController.text.isNotEmpty) {
                                    if (flightNoEditingController.text.isNotEmpty) {
                                      if (dateEditingController.text.isNotEmpty) {
                                        if (_isvalidateFlightNo) {
                                          bool? confirm = await DialogUtils.confirmationDialog(context, lableModel);
                                          if (confirm!) {
                                            String flightNo = flightNoEditingController.text;
                                            String flightDate = dateEditingController.text;

                                            trollyAcceptPassData(
                                                (flightDetail == null) ? -1 : flightDetail!.fltSeqNo!,
                                                flightNo.replaceAll(" ", ""),
                                                flightDate,
                                                locationController.text,
                                                trollyGroupIdController.text,
                                                trollyTypeController.text,
                                                trollyNumberController.text,
                                                1,
                                                _user!.userProfile!.userIdentity!,
                                                _splashDefaultData!.companyCode!);

                                            CommonUtils.TROLLYBT = 0;
                                          }
                                        } else {
                                          openValidationDialog(lableModel.validateFlightMsg!, flightBtnFocusNode);
                                        }
                                      } else {
                                        openValidationDialog(lableModel.enterFlightDate!, dateFocusNode);
                                      }
                                    } else {
                                      openValidationDialog(lableModel.enterFlightNo!, flightNoFocusNode);
                                    }
                                  } else {
                                    openValidationDialog(lableModel.enterGropIdMsg!, trollyGroupIdFocusNode);
                                  }
                                } else {
                                  if (flightNoEditingController.text.isNotEmpty) {
                                    if (dateEditingController.text.isNotEmpty) {
                                      if (_isvalidateFlightNo) {
                                        bool? confirm = await DialogUtils.confirmationDialog(context, lableModel);
                                        if (confirm!) {
                                          String flightNo = flightNoEditingController.text;
                                          String flightDate = dateEditingController.text;

                                          trollyAcceptPassData(
                                              (flightDetail == null) ? -1 : flightDetail!.fltSeqNo!,
                                              flightNo.replaceAll(" ", ""),
                                              flightDate,
                                              locationController.text,
                                              trollyGroupIdController.text,
                                              trollyTypeController.text,
                                              trollyNumberController.text,
                                              1,
                                              _user!.userProfile!.userIdentity!,
                                              _splashDefaultData!.companyCode!);
                                          CommonUtils.TROLLYBT = 0;
                                        }
                                      } else {
                                        openValidationDialog(lableModel.validateFlightMsg!, flightBtnFocusNode);
                                      }
                                    } else {
                                      openValidationDialog(lableModel.enterFlightDate!, dateFocusNode);
                                    }
                                  } else {
                                    openValidationDialog(lableModel.enterFlightNo!, flightNoFocusNode);
                                  }
                                }
                              } else {
                                openValidationDialog(lableModel.entertrollyNumberMsg!, trollyNumberFocusNode);
                              }
                            } else {
                              openValidationDialog(lableModel.entertrollyTypeMsg!, trollyTypeFocusNode);
                            }
                          } else {
                            DialogUtils.showDataNotFoundDialogbot(context, "${lableModel.validateGate}", lableModel);
                          }
                        } else {
                          openValidationDialog(lableModel.enterGateMsg!, locationFocusNode);
                        }
                      }
                      else {}
                    }else{
                      SnackbarUtil.showSnackbar(context, ValidationMessageCodeUtils.AuthorisedRolesAndRightsMsg, MyColor.colorRed, icon: FontAwesomeIcons.times);
                      Vibration.vibrate(duration: 500);
                    }




                  },
                ),
              ),

            ],
          )
        ],
      );
    }
  }


  Widget _getWidgetBtn(String? buttonStatus, ULDDetails uldModel, LableModel lableModel, ui.TextDirection textDirection) {
    List<String> fltUldSqNo = uldModel.fltULDSeqNo!.split('~');

    int fltsqNo = int.parse(fltUldSqNo[0]);
    int uldSqNo = int.parse(fltUldSqNo[1]);


    if (buttonStatus!.replaceAll(" ", "") == "A") {
      if (uldModel.uLDNo == "BULK" || uldModel.uLDNo == "Bulk") {
        return RoundedButtonBlue(
          verticalPadding: SizeConfig.blockSizeVertical * SizeUtils.BUTTONVERTICALSIZE / 1.2,
          text: "${lableModel.acceptBulk}",
          textSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
          press: () async {
            if(isButtonEnabled("acceptBulk", buttonRightsList)){
              setState(() {
                _isvalidULDNo = false;
                _suffixIconUld = false;
                _pageIndex = 0;
                _tabController.animateTo(0);
                // uldNoController.text = uldModel.uLDNo!;
                CommonUtils.ULDBT = 2;
                CommonUtils.ULDSEQUENCENUMBER = uldSqNo;
                CommonUtils.FLIGHTSEQUENCENUMBER = fltsqNo;
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  FocusScope.of(context).requestFocus(groupIdFocusNode);
                },
                );

               // _isAcceptBtnEnable = true;

                openULDAcceptanceDialog(context, uldModel.uLDNo!, lableModel, textDirection, _isGroupIdIsMandatory, buttonRightsList);


              });
            }else{
              SnackbarUtil.showSnackbar(context, ValidationMessageCodeUtils.AuthorisedRolesAndRightsMsg, MyColor.colorRed, icon: FontAwesomeIcons.times);
              Vibration.vibrate(duration: 500);
            }

          },
        );
      }
      else {
        return RoundedButtonBlue(
          text: "${lableModel.acceptULD}",
          textSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
          verticalPadding: SizeConfig.blockSizeVertical * SizeUtils.BUTTONVERTICALSIZE / 1.2,
          color: MyColor.primaryColorblue,
          press: () async {

            if(isButtonEnabled("acceptULD", buttonRightsList)){
              setState(() {
                _isvalidULDNo = true;
                _suffixIconUld = false;
                _pageIndex = 0;
                _tabController.animateTo(0);
                CommonUtils.ULDBT = 2;
                CommonUtils.ULDSEQUENCENUMBER = uldSqNo;
                CommonUtils.FLIGHTSEQUENCENUMBER = fltsqNo;


                openULDAcceptanceDialog(context, uldModel.uLDNo!, lableModel, textDirection, _isGroupIdIsMandatory, buttonRightsList);

              });
            }else{
              SnackbarUtil.showSnackbar(context, ValidationMessageCodeUtils.AuthorisedRolesAndRightsMsg, MyColor.colorRed, icon: FontAwesomeIcons.times);
              Vibration.vibrate(duration: 500);
            }


          },
        );
      }
    }
    else if(buttonStatus.replaceAll(" ", "") == "U"){
      return Stack(
        children: [
          Align(
              alignment: Alignment.centerRight,
              child: InkWell(
                onTap: () async {
                  inactivityTimerManager!.stopTimer();
                  bool damageOrNot = await Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder: (context) => UldDamagedPage(
                          importSubMenuList: widget.importSubMenuList,
                          exportSubMenuList: widget.exportSubMenuList,
                          locationCode: locationController.text,
                          menuId: widget.menuId,
                          ULDNo: uldModel.uLDNo!,
                          ULDSeqNo: uldSqNo,
                          flightSeqNo: fltsqNo,
                          groupId: groupIdController.text,
                          menuCode: widget.refrelCode,
                          isRecordView: 2,
                          mainMenuName: widget.mainMenuName,
                          buttonRightsList: buttonRightsList,
                        ),
                      ));

                  print("CHECK____NUMBER ==== ${damageOrNot}");

                },
                child: Container(
                    margin: EdgeInsets.only(right: SizeConfig.blockSizeHorizontal * SizeUtils.WIDTH3),
                    padding: EdgeInsets.symmetric(vertical: SizeConfig.blockSizeVertical, horizontal: SizeConfig.blockSizeHorizontal * SizeUtils.WIDTH3),
                    decoration: BoxDecoration(
                      color: MyColor.dropdownColor,
                      borderRadius: BorderRadius.circular(10)
                    ),
                    child: SvgPicture.asset(right, height: SizeConfig.blockSizeVertical * SizeUtils.ICONSIZE_2_5,)),
              ))
        ],
      );
    }
    else if(buttonStatus.replaceAll(" ", "") == "S"){
      return Stack(
        children: [
          Align(
              alignment: Alignment.centerRight,
              child: InkWell(
                onTap: () async {
                  inactivityTimerManager!.stopTimer();
                  bool damageOrNot = await Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder: (context) => UldDamagedPage(
                          importSubMenuList: widget.importSubMenuList,
                          exportSubMenuList: widget.exportSubMenuList,
                          locationCode: locationController.text,
                          menuId: widget.menuId,
                          ULDNo: uldModel.uLDNo!,
                          ULDSeqNo: uldSqNo,
                          flightSeqNo: fltsqNo,
                          groupId: groupIdController.text,
                          menuCode: widget.refrelCode,
                          isRecordView: 2,
                          mainMenuName: widget.mainMenuName,
                          buttonRightsList: buttonRightsList,
                        ),
                      ));

                  print("CHECK____NUMBER 1==== ${damageOrNot}");
                },
                child: Container(
                    margin: EdgeInsets.only(right: SizeConfig.blockSizeHorizontal * SizeUtils.WIDTH3),
                    padding: EdgeInsets.symmetric(vertical: SizeConfig.blockSizeVertical, horizontal: SizeConfig.blockSizeHorizontal * SizeUtils.WIDTH3),
                    decoration: BoxDecoration(
                        color: MyColor.dropdownColor,
                        borderRadius: BorderRadius.circular(10)
                    ),
                    child: SvgPicture.asset(right, height: SizeConfig.blockSizeVertical * SizeUtils.ICONSIZE_2_5,)),
              ))
          /*Align(
              alignment: Alignment.centerRight,
              child: Container(
                  decoration: BoxDecoration(
                      color: MyColor.dropdownColor,
                      borderRadius: BorderRadius.circular(10)
                  ),
                  margin: EdgeInsets.only(right: 5),
                  child: InkWell(
                      onTap: () async {
                        bool damageOrNot = await Navigator.push(
                            context,
                            CupertinoPageRoute(
                              builder: (context) => UldDamagedPage(
                                locationCode: locationController.text,
                                menuId: widget.menuId,
                                ULDNo: uldModel.uLDNo!,
                                ULDSeqNo: uldSqNo,
                                flightSeqNo: fltsqNo,
                                groupId: groupIdController.text,
                                menuCode: widget.refrelCode,
                                isRecordView: 2,
                                mainMenuName: widget.mainMenuName,
                                buttonRightsList: buttonRightsList,
                              ),
                            ));
                      },
                      child: Icon(Icons.navigate_next_rounded, color: MyColor.primaryColorblue, size: 30,))))*/
        ],
      );
    }
    return SizedBox();
  }


  Future<void> openValidationDialog(String message, FocusNode focuseNode) async {
    bool? empty = await DialogUtils.showDataNotFoundDialogbot(context, "${message}", widget.lableModel!);

    if(empty == true){
      WidgetsBinding.instance.addPostFrameCallback((_) {
        FocusScope.of(context).requestFocus(focuseNode);
      });
    }
  }


  Future<void> openULDAcceptanceDialog(BuildContext context, String uldNo, LableModel lableModel,  ui.TextDirection textDirection, String isGroupIdIsMandatory, List<ButtonRight> buttonRightsList) async {
    var result = await DialogUtils.showULDAcceptanceDialog(context, uldNo, lableModel, textDirection, isGroupIdIsMandatory, locationController.text, _user!.userProfile!.userIdentity!, _splashDefaultData!.companyCode!, widget.menuId, widget.refrelCode, widget.title, buttonRightsList);
    print("CHECK_RESULT====== $result");


    if (result != null) {
      // The dialog returned a result, handle it here
      print("Dialog Result: $result");

      // Example of extracting data
      if (result.containsKey('status')) {
        print("Value for 'status': ${result['status']}");
        String? status = result['status'];
        if(status == "Y"){
          uldAcceptPassData(
              CommonUtils.FLIGHTSEQUENCENUMBER,
              CommonUtils.ULDSEQUENCENUMBER,
              uldNo,
              locationController.text,
              result['groupId']!,
              _user!.userProfile!.userIdentity!,
              _splashDefaultData!.companyCode!);
        }else if(status == "N"){
          inactivityTimerManager!.stopTimer();
          String damageOrNot = await Navigator.push(
              context,
              CupertinoPageRoute(
                builder: (context) => UldDamagedPage(
                  importSubMenuList: widget.importSubMenuList,
                  exportSubMenuList: widget.exportSubMenuList,
                  locationCode: locationController.text,
                  menuId: widget.menuId,
                  ULDNo: uldNo,
                  ULDSeqNo: CommonUtils.ULDSEQUENCENUMBER,
                  flightSeqNo: CommonUtils.FLIGHTSEQUENCENUMBER,
                  groupId: groupIdController.text,
                  menuCode: widget.refrelCode,
                  isRecordView:  0,
                  mainMenuName: widget.mainMenuName,
                  buttonRightsList: buttonRightsList,
                ),
              ));

          print("DMAGE_DIALOG_PAGE----------- ${damageOrNot}");


          if(damageOrNot == "U"){
            _isdamageOrNot = "U";
            await context.read<UldAcceptanceCubit>().uldDamageAccept(CommonUtils.FLIGHTSEQUENCENUMBER, CommonUtils.ULDSEQUENCENUMBER, uldNo.replaceAll(" ", ""), locationController.text, groupIdController.text, _user!.userProfile!.userIdentity!, _splashDefaultData!.companyCode!, widget.menuId);
            _resumeTimerOnInteraction();
          }
          else if(damageOrNot == "S"){
            _isdamageOrNot = "S";
            await context.read<UldAcceptanceCubit>().uldDamageAccept(CommonUtils.FLIGHTSEQUENCENUMBER, CommonUtils.ULDSEQUENCENUMBER, uldNo.replaceAll(" ", ""), locationController.text, groupIdController.text, _user!.userProfile!.userIdentity!,  _splashDefaultData!.companyCode!, widget.menuId);
            _resumeTimerOnInteraction();
          }
          else{
            _isdamageOrNot = "";
            _resumeTimerOnInteraction();
          }


         /* _updateButtonStatus(CommonUtils.ULDSEQUENCENUMBER, result['damageCode']!);*/
        }

      }
    } else {
      // The dialog was canceled, or no result was returned
      print("Dialog was canceled or returned no result");
    }



    /*if(result == null){

    }else if(result.containsKey('status')){
      uldAcceptPassData(
          CommonUtils.FLIGHTSEQUENCENUMBER,
          CommonUtils.ULDSEQUENCENUMBER,
          uldNo,
          locationController.text,
          CommonUtils.ULDGROUPID,
          _user!.userProfile!.userIdentity!,
          _splashDefaultData!.companyCode!);

    }*/
  }


  Future<void> openUCRBottomDialog(BuildContext context, String uldNo, LableModel lableModel,  ui.TextDirection textDirection, String isGroupIdIsMandatory, List<ButtonRight> buttonRightsList) async {
    FocusScope.of(context).unfocus();
    CommonUtils.ULDUCRNO = uldNo;

    var result = await DialogUtils.showUCRBottomULDDialog(context, CommonUtils.ULDUCRNO, lableModel, textDirection, isGroupIdIsMandatory, locationController.text, _user!.userProfile!.userIdentity!, _splashDefaultData!.companyCode!, widget.menuId, widget.title, buttonRightsList);
    if (result != null) {
      if (result.containsKey('status')) {
        String? status = result['status'];
        if(status == "N"){
          WidgetsBinding.instance.addPostFrameCallback((_) {
            FocusScope.of(context).requestFocus(uldNoFocusNode);
          });
        }
      }else{

      }
    }else{

    }


    /* if(result == null){
      WidgetsBinding.instance.addPostFrameCallback((_) {
        FocusScope.of(context).requestFocus(uldNoFocusNode);
      });
    }else{
      uldNoController.clear();
    }*/
  }

  void uldAcceptPassData(int flightSeqNo, int ULDSeqNo, String ULDNo, String locationCode, String groupId, int userId, int companyCode) {
    context.read<UldAcceptanceCubit>().uldAccept(
        flightSeqNo,
        ULDSeqNo,
        ULDNo,
        locationCode,
        groupId,
        userId,
        companyCode,
        widget.menuId);
  }

  void trollyAcceptPassData(int flightSeqNo, String flightNo, String flightDate, String locationCode, String groupId, String trollyType, String trollyNo, int btnFlag, int userId, int companyCode) {

    context.read<UldAcceptanceCubit>().trollyAccept(
        flightSeqNo,
        flightNo,
        flightDate,
        locationCode,
        groupId,
        trollyType,
        trollyNo,
        btnFlag,
        userId,
        companyCode,
        widget.menuId);
  }

  Future<void> ULDScanQR() async{

    String uldScanResult =  await FlutterBarcodeScanner.scanBarcode(
      '#ff6666', // Color for the scanner overlay
      'Cancel', // Text for the cancel button
      true, // Enable flash option
      ScanMode.DEFAULT, // Scan mode
    );



    if(uldScanResult == "-1"){

    }else{

      bool specialCharAllow = CommonUtils.containsSpecialCharacters(uldScanResult);

      print("SPECIALCHAR_ALLOW ===== ${specialCharAllow}");

      if(specialCharAllow == true){
        SnackbarUtil.showSnackbar(context, "${widget.lableModel!.onlyAlphaNumericValueMsg}", MyColor.colorRed, icon: FontAwesomeIcons.times);
        Vibration.vibrate(duration: 500);
        uldNoController.clear();


        WidgetsBinding.instance.addPostFrameCallback((_) {
          FocusScope.of(context).requestFocus(uldNoFocusNode);
        });
      }else{

        uldNoController.text = uldScanResult.replaceAll(" ", "");

        String uldNumber = UldValidationUtil.validateUldNumberwithSpace1(uldScanResult.toUpperCase());

        print("uldNumcer CHECK====== ${uldNumber}");

        if(uldNumber == "Valid"){
          setState(() {});
          _suffixIconUld = false;
          _isvalidULDNo = true;

          uldNoController.text = CommonUtils.ULDNUMBERCEHCK;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            FocusScope.of(context).requestFocus(groupIdFocusNode);
          });

          await context.read<UldAcceptanceCubit>().getFlightFromULD(
              uldScanResult.replaceAll(" ", ""),
              _user!.userProfile!.userIdentity!,
              _splashDefaultData!.companyCode!,
              widget.menuId
          );
        }
        else{

          SnackbarUtil.showSnackbar(context, "${widget.lableModel!.entervalidULDNo}", MyColor.colorRed, icon: FontAwesomeIcons.times);
          Vibration.vibrate(duration: 500);
          WidgetsBinding.instance.addPostFrameCallback((_) {
            FocusScope.of(context).requestFocus(uldNoFocusNode);
          });

          uldNoController.clear();

          setState(() {
            _suffixIconUld = false;
            _isvalidULDNo = false;
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

    }else{
      bool specialCharAllow = CommonUtils.containsSpecialCharacters(locationcodeScanResult);

      print("SPECIALCHAR_ALLOW ===== ${specialCharAllow}");


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

        leaveLocationFocus();
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
        SnackbarUtil.showSnackbar(context, "Only numeric characters are accepted.", MyColor.colorRed, icon: FontAwesomeIcons.times);
        Vibration.vibrate(duration: 500);
        scanFlightController.clear();

        WidgetsBinding.instance.addPostFrameCallback((_) {
          FocusScope.of(context).requestFocus(scanFlightFocusNode);
        });
      }else{

        String result = barcodeScanResult.replaceAll(" ", "");

        String truncatedResult = result.length > 15
            ? result.substring(0, 15)
            : result;


        scanFlightController.text = truncatedResult;

        context.read<UldAcceptanceCubit>().getUldAcceptanceList(
            _user!.userProfile!.userIdentity!,
            _splashDefaultData!.companyCode!,
            "",
            "1990-01-01",
            truncatedResult,
            widget.menuId);
      }



    }

  }



  bool containsSpecialCharactersA(String input) {
    // Define a regular expression pattern for special characters
    final specialCharactersRegex = RegExp(r'[!@#\$%^&*(),.?":{}|<>]');

    // Returns true if the input contains any special characters
    return specialCharactersRegex.hasMatch(input);
  }


  bool isButtonEnabled(String buttonId, List<ButtonRight> buttonList) {
    ButtonRight? button = buttonList.firstWhere(
          (button) => button.buttonId == buttonId,
    );
    return button.isEnable == 'Y';
  }


}
