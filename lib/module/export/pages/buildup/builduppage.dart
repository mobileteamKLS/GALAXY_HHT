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
import 'package:galaxy/module/export/services/buildup/builduplogic/buildupcubit.dart';
import 'package:galaxy/module/import/services/flightcheck/flightchecklogic/flightcheckcubit.dart';
import 'package:galaxy/utils/sizeutils.dart';
import 'package:galaxy/widget/customebuttons/roundbuttonblue.dart';
import 'package:galaxy/widget/custometext.dart';
import 'package:galaxy/widget/groupidcustomtextfield.dart';
import 'package:galaxy/widget/uldnumberwidget.dart';
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
import '../../../../widget/customdivider.dart';
import '../../../../widget/customebuttons/roundbuttongreen.dart';
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
import '../../model/buildup/flightsearchmodel.dart';
import '../../services/buildup/builduplogic/buildupstate.dart';


class BuildUpPage extends StatefulWidget {
  String mainMenuName;
  String title;
  String refrelCode;
  LableModel? lableModel;
  int menuId;
  List<SubMenuName> importSubMenuList = [];
  List<SubMenuName> exportSubMenuList = [];

  BuildUpPage(
      {super.key,
      required this.importSubMenuList,
      required this.exportSubMenuList,
      required this.title,
      required this.refrelCode,
      this.lableModel,
      required this.menuId,
      required this.mainMenuName});

  @override
  State<BuildUpPage> createState() => _BuildUpPageState();
}

class _BuildUpPageState extends State<BuildUpPage>
    with SingleTickerProviderStateMixin {


  InactivityTimerManager? inactivityTimerManager;
  final SavedPrefrence savedPrefrence = SavedPrefrence();
  UserDataModel? _user;
  SplashDefaultModel? _splashDefaultData;
  final ScrollController scrollController = ScrollController();

  FlightSearchModel? flightSearchModel;

 /* FlightCheckULDListModel? flightCheckULDListModel;
  FlightCheckSummaryModel? flightCheckSummaryModel;

  List<FlightDetailList> originalFlightDetails = [];
  List<FlightDetailList> flightDetailsList = [];

  List<ButtonRight> buttonRightsList = [];*/

  Map<String, String>? validationMessages;


  TextEditingController flightNoEditingController = TextEditingController();
  TextEditingController dateEditingController = TextEditingController();

  FocusNode flightNoFocusNode = FocusNode();
  FocusNode dateFocusNode = FocusNode();
  FocusNode flightBtnFocusNode = FocusNode();


  FocusNode uldListFocusNode = FocusNode();

  DateTime? _selectedDate;




  bool _isDatePickerOpen = false;

  late TabController _tabController;
  int _pageIndex = 0;
  int? _selectedIndex;

  late AnimationController _blinkController;
  late Animation<Color?> _colorAnimation;

  bool _isOpenULDFlagEnable = false;

  final ValueNotifier<double> _valueNotifier = ValueNotifier(0);


  final List<String> _tabs = ['Flight', 'ULD', 'SLA'];

  final List<String> shcCodeList = ["DGR", "VAL", "GEN"];

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


    dateFocusNode.addListener(() {
      if (dateFocusNode.hasFocus) {
        if (dateEditingController.text.isEmpty && !_isDatePickerOpen) {
          _selectDate(context);
        }
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
    flightNoEditingController.dispose();
    flightNoFocusNode.dispose();
    dateEditingController.dispose();
    dateFocusNode.dispose();

  }

  Future<void> _loadUser() async {
    final user = await savedPrefrence.getUserData();
    final splashDefaultData = await savedPrefrence.getSplashDefaultData();
    if (user != null && splashDefaultData != null) {
      setState(() {
        _user = user;
        _splashDefaultData = splashDefaultData;
      });

      WidgetsBinding.instance.addPostFrameCallback((_) {
        FocusScope.of(context).requestFocus(flightNoFocusNode);
      },
      );

    //  context.read<FlightCheckCubit>().getButtonRolesAndRights(widget.menuId, _user!.userProfile!.userIdentity!, _splashDefaultData!.companyCode!);
    //  context.read<FlightCheckCubit>().getPageLoadDefault(widget.menuId, _user!.userProfile!.userIdentity!, _splashDefaultData!.companyCode!);

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
    }else if(_pageIndex == 2){
      _pageIndex = 0;
      _tabController.animateTo(0);
    }else{

      flightNoEditingController.clear();
      dateEditingController.clear();

      _tabController.animateTo(0);
      _pageIndex = 0;

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
                                    flightNoEditingController.clear();
                                    dateEditingController.clear();


                                    _tabController.animateTo(0);
                                    _pageIndex = 0;
                                    WidgetsBinding.instance.addPostFrameCallback((_) {
                                        FocusScope.of(context).requestFocus(flightNoFocusNode);
                                      },
                                    );
                                    _isOpenULDFlagEnable = false;
                                    Navigator.pop(context, "Done");
                                  }

                                },
                                clearText: lableModel!.clear,
                                //add clear text to clear all feild
                                onClear: () {
                                  flightSearchModel = null;
                                  flightNoEditingController.clear();
                                  dateEditingController.clear();
                                  _tabController.animateTo(0);
                                  _pageIndex = 0;
                                  WidgetsBinding.instance.addPostFrameCallback((_) {
                                      FocusScope.of(context).requestFocus(flightNoFocusNode);
                                    },
                                  );
                                  _isOpenULDFlagEnable = false;
                                  setState(() {});
                                },
                              ),
                            ),

                            // start api responc

                            BlocListener<BuildUpCubit, BuildUpState>(
                              listener: (context, state) {
                                if (state is BuildUpInitialState) {
                                }
                                else if (state is BuildUpLoadingState) {
                                  // showing loading dialog in this state
                                  DialogUtils.showLoadingDialog(context, message: lableModel.loading);
                                }
                                else if (state is FlightSearchSuccessState){
                                  DialogUtils.hideLoadingDialog(context);
                                  if(state.flightSearchModel.status == "E"){
                                    Vibration.vibrate(duration: 500);
                                    SnackbarUtil.showSnackbar(context, state.flightSearchModel.statusMessage!, MyColor.colorRed, icon: FontAwesomeIcons.times);
                                  }else{
                                    flightSearchModel = state.flightSearchModel;
                                    setState(() {});
                                  }
                                }
                                else if (state is FlightSearchFailureState){
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
                                                      SizedBox(
                                                        height: SizeConfig.blockSizeVertical,
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
                                                                  flightSearchModel = null;
                                                                  dateEditingController.clear();
                                                                  _isOpenULDFlagEnable = false;
                                                                  _tabController.animateTo(0);
                                                                  _pageIndex = 0;
                                                                  setState(() {});
                                                                },
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
                                                                  onPress: () => !_isDatePickerOpen
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

                                                      RoundedButtonBlue(
                                                        focusNode: flightBtnFocusNode,
                                                        text: "${lableModel.uldSearch}",
                                                        press: () {
                                                          if (flightNoEditingController.text.isNotEmpty) {
                                                            if (dateEditingController.text.isNotEmpty) {
                                                              // CALL API OF Flight Number and Date
                                                              _isOpenULDFlagEnable = false;

                                                            } else {
                                                              openValidationDialog(lableModel.enterFlightDate!, dateFocusNode);
                                                            }
                                                          }
                                                          else {
                                                            openValidationDialog(lableModel.enterFlightNo!, flightNoFocusNode);
                                                          }
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
                                                        Column(
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
                                                            }),),
                                                            SizedBox(height: SizeConfig.blockSizeVertical,),
                                                            isViewEnable(lableModel, _pageIndex, textDirection, localizations),
                                                          ],
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

  Future<void> _selectDate(BuildContext context) async {
    _isDatePickerOpen = true;

    final DateTime now = DateTime.now();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? now,
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );

    if (flightNoEditingController.text.isNotEmpty) {
      if (picked != null) {
        setState(() {
          _selectedDate = picked;
          dateEditingController.text = DateFormat('dd-MMM-yy').format(_selectedDate!).toUpperCase();

          _isOpenULDFlagEnable = false;
          _tabController.animateTo(0);
          _pageIndex = 0;
          setState(() {});

          WidgetsBinding.instance.addPostFrameCallback((_) {
              FocusScope.of(context).requestFocus(flightBtnFocusNode);
            },
          );
        });


        getFlightSearchApi();

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

    // Ensure the flag is reset even if the dialog is dismissed without selection
    _isDatePickerOpen = false;

    // Manually unfocus to close the keyboard and ensure consistent behavior
    dateFocusNode.unfocus();
  }




  Widget isViewEnable(LableModel lableModel, int pageIndex, ui.TextDirection textDirection, AppLocalizations? localizations) {
    if (pageIndex == 0) {

      return Column(
        children: [
          Container(
            decoration: BoxDecoration(
                border: Border.all(color: MyColor.textColorGrey, width: 0.4),
                borderRadius: BorderRadius.circular(SizeUtils.BORDERRADIOUS)
            ),
            padding: const EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SvgPicture.asset(arrival, height: SizeConfig.blockSizeVertical * SizeUtils.ICONSIZE3,),
                      SizedBox(height: SizeConfig.blockSizeVertical,),
                      Container(
                        padding : EdgeInsets.symmetric(horizontal: SizeConfig.blockSizeHorizontal * 2.5, vertical: SizeConfig.blockSizeVertical * 0.1),
                        decoration : BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: MyColor.flightFinalize
                        ),
                        child: CustomeText(
                            text: "Open",
                            fontColor: MyColor.textColorGrey3,
                            fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                            fontWeight: FontWeight.w500,
                            textAlign: TextAlign.start),
                      ),
                    ],
                  ),
                ),
                Expanded(
                    flex: 2,
                    child: Container()),
                Expanded(
                  flex:4,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomeText(
                            text: "ETD : ",
                            fontColor: MyColor.textColorGrey2,
                            fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                            fontWeight: FontWeight.w400,
                            textAlign: TextAlign.start,
                          ),
                          const SizedBox(width: 5),
                          CustomeText(
                            text: "11:55",
                            fontColor: MyColor.colorBlack,
                            fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                            fontWeight: FontWeight.w600,
                            textAlign: TextAlign.start,
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomeText(
                            text: "Remaining : ",
                            fontColor: MyColor.textColorGrey2,
                            fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                            fontWeight: FontWeight.w400,
                            textAlign: TextAlign.start,
                          ),
                          const SizedBox(width: 5),
                          CustomeText(
                            text: "120 min",
                            fontColor: MyColor.colorBlack,
                            fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                            fontWeight: FontWeight.w600,
                            textAlign: TextAlign.start,
                          ),
                        ],
                      ),
                  ],),
                )
              ],
            ),
          ),
          SizedBox(height: SizeConfig.blockSizeVertical * SizeUtils.HEIGHT_1_5,),
          Row(
            children: [
              CustomeText(
                text: "LA vs Manifest : ",
                fontColor: MyColor.textColorGrey3,
                fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_6,
                fontWeight: FontWeight.w600,
                textAlign: TextAlign.start,
              ),
              Expanded(
                child: Column(children: [
                  FAProgressBar(
                    animatedDuration: const Duration(milliseconds: 300),
                    borderRadius: BorderRadius.circular(16),
                    currentValue: 50.0,
                    displayText: '%',
                    progressColor: MyColor.colorGreen,
                    backgroundColor: MyColor.dropdownColor,
                  ),


                ]),
              ),
            ],
          ),
          SizedBox(height: SizeConfig.blockSizeVertical * SizeUtils.HEIGHT_1_5,),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 10,),
                  decoration: BoxDecoration(
                    color: MyColor.colorGrey.withOpacity(0.05), // Background color of the widget
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      CustomeText(text: "UWS", fontColor: MyColor.textColorGrey3, fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_4, fontWeight: FontWeight.w500, textAlign: TextAlign.center),
                      SvgPicture.asset(donesvg, height: SizeConfig.blockSizeVertical * SizeUtils.HEIGHT3, color: MyColor.colorGreen,),
                    ],
                  ),
                ),
              ),
              SizedBox(width: SizeConfig.blockSizeHorizontal,),
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 10,),
                  decoration: BoxDecoration(
                    color: MyColor.colorGrey.withOpacity(0.05), // Background color of the widget
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      CustomeText(text: "NOTOC", fontColor: MyColor.textColorGrey3, fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_4, fontWeight: FontWeight.w500, textAlign: TextAlign.center),
                      SvgPicture.asset(closesvg, height: SizeConfig.blockSizeVertical * SizeUtils.HEIGHT3, color: MyColor.colorRed,),
                    ],
                  ),
                ),
              ),
              SizedBox(width: SizeConfig.blockSizeHorizontal,),
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 10,),
                  decoration: BoxDecoration(
                    color: MyColor.colorGrey.withOpacity(0.05), // Background color of the widget
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      CustomeText(text: "Manifest", fontColor: MyColor.textColorGrey3, fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_4, fontWeight: FontWeight.w500, textAlign: TextAlign.center),
                      SvgPicture.asset(notApplicable, height: SizeConfig.blockSizeVertical * SizeUtils.HEIGHT3,),
                    ],
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: SizeConfig.blockSizeVertical * SizeUtils.HEIGHT_1_5,),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: MyColor.cardBgColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      flex : 4,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding : EdgeInsets.symmetric(horizontal: 5, vertical: SizeConfig.blockSizeVertical * 0.3),
                                decoration : BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: MyColor.subMenuColorList[0]
                                ),
                                child: CustomeText(
                                  text: "ULD - 35",
                                  fontColor: MyColor.textColorGrey3,
                                  fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                  fontWeight: FontWeight.w600,
                                  textAlign: TextAlign.start,
                                ),
                              ),
                              SizedBox(width: SizeConfig.blockSizeHorizontal * SizeUtils.TEXTSIZE_1_5,),
                              Container(
                                padding : EdgeInsets.symmetric(horizontal: 5, vertical: SizeConfig.blockSizeVertical * 0.3),
                                decoration : BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: MyColor.subMenuColorList[1]
                                ),
                                child: CustomeText(
                                  text: "Trolley - 13",
                                  fontColor: MyColor.textColorGrey3,
                                  fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                  fontWeight: FontWeight.w600,
                                  textAlign: TextAlign.start,
                                ),
                              )
                            ],
                          ),
                        ],),
                    ),
                    Expanded(
                      flex :2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CustomeText(
                            text: "Pieces",
                            fontColor: MyColor.textColorGrey3,
                            fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_6,
                            fontWeight: FontWeight.w700,
                            textAlign: TextAlign.end,
                          ),

                        ],),
                    ),
                    Expanded(
                      flex : 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [

                          CustomeText(
                            text: "Weight",
                            fontColor: MyColor.textColorGrey3,
                            fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_6,
                            fontWeight: FontWeight.w700,
                            textAlign: TextAlign.end,
                          ),

                        ],),
                    ),
                  ],
                ),
                SizedBox(height: SizeConfig.blockSizeVertical,),
                CustomDivider(
                  space: 0,
                  color: Colors.black,
                  hascolor: true,
                  thickness: 1,
                ),
                SizedBox(height: SizeConfig.blockSizeVertical,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      flex : 4,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomeText(
                            text: "Cargo",
                            fontColor: MyColor.textColorGrey3.withOpacity(0.7),
                            fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_6,
                            fontWeight: FontWeight.w600,
                            textAlign: TextAlign.start,
                          ),
                        ],),
                    ),
                    Expanded(
                      flex :2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CustomeText(
                            text: "11",
                            fontColor: MyColor.textColorGrey3.withOpacity(0.7),
                            fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                            fontWeight: FontWeight.w500,
                            textAlign: TextAlign.end,
                          ),

                        ],),
                    ),
                    Expanded(
                      flex : 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          CustomeText(
                            text: "110.00 Kg",
                            fontColor: MyColor.textColorGrey3.withOpacity(0.7),
                            fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                            fontWeight: FontWeight.w500,
                            textAlign: TextAlign.start,
                          ),


                        ],),
                    ),
                  ],
                ),
                SizedBox(height: SizeConfig.blockSizeVertical,),
                CustomDivider(
                  space: 0,
                  color: Colors.black,
                  hascolor: true,
                  thickness: 1,
                ),
                SizedBox(height: SizeConfig.blockSizeVertical,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      flex : 4,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomeText(
                            text: "Mail",
                            fontColor: MyColor.textColorGrey3.withOpacity(0.7),
                            fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_6,
                            fontWeight: FontWeight.w600,
                            textAlign: TextAlign.start,
                          ),
                        ],),
                    ),
                    Expanded(
                      flex :2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CustomeText(
                            text: "-",
                            fontColor: MyColor.textColorGrey3.withOpacity(0.7),
                            fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                            fontWeight: FontWeight.w500,
                            textAlign: TextAlign.end,
                          ),

                        ],),
                    ),
                    Expanded(
                      flex : 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          CustomeText(
                            text: "-",
                            fontColor: MyColor.textColorGrey3.withOpacity(0.7),
                            fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                            fontWeight: FontWeight.w500,
                            textAlign: TextAlign.start,
                          ),


                        ],),
                    ),
                  ],
                ),
                SizedBox(height: SizeConfig.blockSizeVertical,),
                CustomDivider(
                  space: 0,
                  color: Colors.black,
                  hascolor: true,
                  thickness: 1,
                ),
                SizedBox(height: SizeConfig.blockSizeVertical,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      flex : 4,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomeText(
                            text: "Courier",
                            fontColor: MyColor.textColorGrey3.withOpacity(0.7),
                            fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_6,
                            fontWeight: FontWeight.w600,
                            textAlign: TextAlign.start,
                          ),
                        ],),
                    ),
                    Expanded(
                      flex :2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CustomeText(
                            text: "100",
                            fontColor: MyColor.textColorGrey3.withOpacity(0.7),
                            fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                            fontWeight: FontWeight.w500,
                            textAlign: TextAlign.end,
                          ),

                        ],),
                    ),
                    Expanded(
                      flex : 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          CustomeText(
                            text: "500.00 Kg",
                            fontColor: MyColor.textColorGrey3.withOpacity(0.7),
                            fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                            fontWeight: FontWeight.w500,
                            textAlign: TextAlign.start,
                          ),


                        ],),
                    ),
                  ],
                ),
                SizedBox(height: SizeConfig.blockSizeVertical,),
                CustomDivider(
                  space: 0,
                  color: Colors.black,
                  hascolor: true,
                  thickness: 1,
                ),
                SizedBox(height: SizeConfig.blockSizeVertical,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      flex : 4,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomeText(
                            text: "Total",
                            fontColor: MyColor.textColorGrey3,
                            fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_6,
                            fontWeight: FontWeight.w600,
                            textAlign: TextAlign.start,
                          ),
                        ],),
                    ),
                    Expanded(
                      flex :2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CustomeText(
                            text: "111",
                            fontColor: MyColor.textColorGrey3,
                            fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                            fontWeight: FontWeight.w600,
                            textAlign: TextAlign.end,
                          ),

                        ],),
                    ),
                    Expanded(
                      flex : 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          CustomeText(
                            text: "610.00 Kg",
                            fontColor: MyColor.textColorGrey3,
                            fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                            fontWeight: FontWeight.w600,
                            textAlign: TextAlign.start,
                          ),


                        ],),
                    ),
                  ],
                ),
              ],
            ),
          )


        ],
      );


    }

    if (pageIndex == 1) {
      return Column(
        children: [
          SizedBox(height: SizeConfig.blockSizeVertical,),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: MyColor.cardBgColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomeText(text: "BULK", fontColor: MyColor.colorBlack, fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_8, fontWeight: FontWeight.w700, textAlign: TextAlign.start),
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
                                text: "P - 10",
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

                          });

                        },
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    InkWell(
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
                          color: Colors.transparent,
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
                                        ULDNumberWidget(uldNo: "TTL 11121", smallFontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5, bigFontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_8, fontColor: MyColor.textColorGrey3, uldType: "T"),
                                        SizedBox(width: SizeConfig.blockSizeHorizontal),
                                        Container(
                                          padding : EdgeInsets.symmetric(horizontal: SizeConfig.blockSizeHorizontal * 2.5, vertical: SizeConfig.blockSizeVertical * 0.1),
                                          decoration : BoxDecoration(
                                              borderRadius: BorderRadius.circular(20),
                                              color:  MyColor.subMenuColorList[4]
                                          ),
                                          child: CustomeText(
                                            text: "In-Progress",
                                            fontColor: MyColor.textColorGrey3,
                                            fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_35,
                                            fontWeight: FontWeight.w400,
                                            textAlign: TextAlign.center,
                                          ),
                                        ),

                                      ],
                                    ),

                                    SizedBox(height: SizeConfig.blockSizeVertical),

                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [

                                        Row(
                                          children: [
                                            CustomeText(
                                              text: "Shipment :",
                                              fontColor: MyColor.textColorGrey2,
                                              fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_6,
                                              fontWeight: FontWeight.w600,
                                              textAlign: TextAlign.start,
                                            ),
                                            const SizedBox(width: 5),
                                            CustomeText(
                                              text: "5",
                                              fontColor: MyColor.colorBlack,
                                              fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_7,
                                              fontWeight: FontWeight.w600,
                                              textAlign: TextAlign.start,
                                            ),
                                          ],
                                        ),

                                        SizedBox(width: SizeConfig.blockSizeHorizontal * SizeUtils.WIDTH5),

                                        InkWell(
                                          onTap: () {
                                            setState(() {
                                            });

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
                          ),
                        ),
                      ),
                    ),
                    InkWell(
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
                          color:  Colors.transparent,
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
                                        ULDNumberWidget(uldNo: "TTL 11122", smallFontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5, bigFontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_8, fontColor: MyColor.textColorGrey3, uldType: "T"),
                                        SizedBox(width: SizeConfig.blockSizeHorizontal),
                                        Container(
                                          padding : EdgeInsets.symmetric(horizontal: SizeConfig.blockSizeHorizontal * 2.5, vertical: SizeConfig.blockSizeVertical * 0.1),
                                          decoration : BoxDecoration(
                                              borderRadius: BorderRadius.circular(20),
                                              color:  MyColor.flightNotArrived
                                          ),
                                          child: CustomeText(
                                            text: "Closed",
                                            fontColor: MyColor.textColorGrey3,
                                            fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_35,
                                            fontWeight: FontWeight.w400,
                                            textAlign: TextAlign.center,
                                          ),
                                        ),

                                      ],
                                    ),
                                    SizedBox(height: SizeConfig.blockSizeVertical),

                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            CustomeText(
                                              text: "Shipment :",
                                              fontColor: MyColor.textColorGrey2,
                                              fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_6,
                                              fontWeight: FontWeight.w600,
                                              textAlign: TextAlign.start,
                                            ),
                                            const SizedBox(width: 5),
                                            CustomeText(
                                              text: "2",
                                              fontColor: MyColor.colorBlack,
                                              fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_7,
                                              fontWeight: FontWeight.w600,
                                              textAlign: TextAlign.start,
                                            ),
                                          ],
                                        ),

                                        SizedBox(width: SizeConfig.blockSizeHorizontal * SizeUtils.WIDTH5),

                                        InkWell(
                                          onTap: () {
                                            setState(() {
                                            });

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
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: SizeConfig.blockSizeVertical,),
          InkWell(
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
                color: shcCodeList.contains("DGR") ? MyColor.colorRedLight : Colors.transparent,
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
                              ULDNumberWidget(uldNo: "AKE 12345 AJ", smallFontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5, bigFontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_9, fontColor: MyColor.textColorGrey3, uldType: "U"),
                              SizedBox(width: SizeConfig.blockSizeHorizontal),
                              Container(
                                padding : EdgeInsets.symmetric(horizontal: SizeConfig.blockSizeHorizontal * 2.5, vertical: SizeConfig.blockSizeVertical * 0.1),
                                decoration : BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color:  MyColor.flightFinalize
                                ),
                                child: CustomeText(
                                  text: "Open",
                                  fontColor: MyColor.textColorGrey3,
                                  fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_35,
                                  fontWeight: FontWeight.w400,
                                  textAlign: TextAlign.center,
                                ),
                              ),

                            ],
                          ),
                          shcCodeList.isNotEmpty ? SizedBox(height: SizeConfig.blockSizeVertical) : SizedBox(height: SizeConfig.blockSizeVertical * SizeUtils.HEIGHT2),
                          shcCodeList.isNotEmpty
                              ? Row(
                            children:shcCodeList.asMap().entries.take(3).map((entry) {
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
                              CustomeText(
                                text: "Contour :",
                                fontColor: MyColor.textColorGrey2,
                                fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_6,
                                fontWeight: FontWeight.w600,
                                textAlign: TextAlign.start,
                              ),
                              const SizedBox(width: 5),
                              CustomeText(
                                text: "Q1 Contour",
                                fontColor: MyColor.colorBlack,
                                fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_7,
                                fontWeight: FontWeight.w600,
                                textAlign: TextAlign.start,
                              ),
                            ],
                          ),
                          SizedBox(height: SizeConfig.blockSizeVertical),
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
                                          text: "P - 10",
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

                                    });
                                    /*openEditPriorityBottomDialog(
                                        context,
                                        flightDetails.uLDNo!,
                                        "${flightDetails.bDPriority}",
                                        index,
                                        flightDetails,
                                        lableModel,
                                        textDirection);*/
                                  },
                                ),
                              ),
                              Row(
                                children: [
                                  Row(
                                    children: [
                                      CustomeText(
                                        text: "Shipment :",
                                        fontColor: MyColor.textColorGrey2,
                                        fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_6,
                                        fontWeight: FontWeight.w600,
                                        textAlign: TextAlign.start,
                                      ),
                                      const SizedBox(width: 5),
                                      CustomeText(
                                        text: "3",
                                        fontColor: MyColor.colorBlack,
                                        fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_7,
                                        fontWeight: FontWeight.w600,
                                        textAlign: TextAlign.start,
                                      ),
                                    ],
                                  ),

                                  SizedBox(width: SizeConfig.blockSizeHorizontal * SizeUtils.WIDTH5),

                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                      });

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
          )
        ],
      );

    }

    else if (pageIndex == 2) {
      return  Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: CustomeText(
              text: "Coming Soon",
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


  // flight check ULD List api call function
  void getFlightSearchApi() {
    context.read<BuildUpCubit>().getFlightSearch(
        flightNoEditingController.text,
        dateEditingController.text,
        _user!.userProfile!.userIdentity!,
        _splashDefaultData!.companyCode!,
        widget.menuId);
  }

  // flight check Summary details api call function
  void callFlightCheckSummaryApi(BuildContext context, int flightSeqNo,
      int userId, int companyCode, int menuId) {
    context
        .read<FlightCheckCubit>()
        .getFlightCheckSummaryDetails(flightSeqNo, userId, companyCode, menuId);
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
