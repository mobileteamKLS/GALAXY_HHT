import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:galaxy/core/mycolor.dart';
import 'package:galaxy/module/export/model/retriveuld/retriveulddetailmodel.dart';
import 'package:galaxy/module/export/pages/retriveuld/retriveulddetailpage.dart';
import 'package:galaxy/module/export/services/retriveuld/retriveuldlogic/retriveuldstate.dart';
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
import '../../model/retriveuld/retriveuldlistmodel.dart';
import '../../model/retriveuld/retriveuldloadmodel.dart';
import '../../services/retriveuld/retriveuldlogic/retriveuldcubit.dart';

class RetriveULDPage extends StatefulWidget {
  String mainMenuName;
  String title;
  String refrelCode;
  LableModel? lableModel;
  int menuId;
  List<SubMenuName> importSubMenuList = [];
  List<SubMenuName> exportSubMenuList = [];


  RetriveULDPage(
      {super.key,
      required this.importSubMenuList,
      required this.exportSubMenuList,
      required this.title,
      required this.refrelCode,
      this.lableModel,
      required this.menuId,
      required this.mainMenuName});

  @override
  State<RetriveULDPage> createState() => _RetriveULDPageState();
}

class _RetriveULDPageState extends State<RetriveULDPage>
    with SingleTickerProviderStateMixin {

  RetriveULDDetailLoadModel? retriveULDListModel;

  TextEditingController locationController = TextEditingController();
  FocusNode locationFocusNode = FocusNode();
  FocusNode locationBtnFocusNode = FocusNode();
  FocusNode retriveBtnFocusNode = FocusNode();

  bool _isLocationSearchBtnEnable = false;
  bool _isvalidateLocation = false;

  RetriveULDPageLoadModel? retriveULDPageLoadModel;

  InactivityTimerManager? inactivityTimerManager;
  final SavedPrefrence savedPrefrence = SavedPrefrence();
  UserDataModel? _user;
  SplashDefaultModel? _splashDefaultData;
  final ScrollController scrollController = ScrollController();
  String requiredLocation = "Y";
  int uldSeqNo = 0;
  String uldNo = "";
  int _pageIndex = 0;
  late TabController _tabController;

  final List<String> _tabs = ['ULD Type List', 'ULD List'];

  @override
  void initState() {
    super.initState();
    _loadUser(); //load user data

    _tabController = TabController(length: 3, vsync: this);
    _tabController.animateTo(_pageIndex);

    locationFocusNode.addListener(() {
      if (!locationFocusNode.hasFocus) {
        leaveLocationFocus();
      }
    });

    locationController.addListener(_validateLocationSearchBtn);


  }

  @override
  void dispose() {
    super.dispose();
    //all controller and focus node dispose
    inactivityTimerManager?.stopTimer(); // Stop the timer when the screen is disposed

    scrollController.dispose();

  }

  Future<void> leaveLocationFocus() async {
    if (locationController.text.isNotEmpty) {
      //call location validation api
      await context.read<RetriveULDCubit>().getValidateLocation(
          locationController.text,
          _user!.userProfile!.userIdentity!,
          _splashDefaultData!.companyCode!,
          widget.menuId,
          "a");
    }else{
      //focus on location feild
      WidgetsBinding.instance.addPostFrameCallback((_) {
        FocusScope.of(context).requestFocus(retriveBtnFocusNode);
      },
      );
    }
  }


  void _validateLocationSearchBtn() {
    setState(() {
      _isLocationSearchBtnEnable = locationController.text.isNotEmpty;
    });
  }



  Future<void> _loadUser() async {
    final user = await savedPrefrence.getUserData();
    final splashDefaultData = await savedPrefrence.getSplashDefaultData();
    if (user != null && splashDefaultData != null) {
      setState(() {
        _user = user;
        _splashDefaultData = splashDefaultData;
      });

      getDefaultPageLoadDetail();

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
                                  locationController.clear();
                                  _isvalidateLocation = false;
                                  CommonUtils.SELECTEDULDFORRETRIVE.clear();
                                  setState(() {

                                  });
                                },
                              ),
                            ),

                            // start api responcer
                            BlocListener<RetriveULDCubit, RetriveULDState>(
                              listener: (context, state) async {

                                if (state is RetriveULDInitialState) {
                                }
                                else if (state is RetriveULDLoadingState) {
                                  // showing loading dialog in this state
                                  DialogUtils.showLoadingDialog(context, message: lableModel!.loading);
                                }
                                else if(state is RetriveULDPageLoadSuccessState){
                                  DialogUtils.hideLoadingDialog(context);
                                  if(state.retriveULDPageLoadModel.status == "E"){
                                    Vibration.vibrate(duration: 500);
                                    SnackbarUtil.showSnackbar(context, state.retriveULDPageLoadModel.statusMessage!, MyColor.colorRed, icon: FontAwesomeIcons.times);
                                  }else{
                                    retriveULDPageLoadModel = state.retriveULDPageLoadModel;
                                    setState(() {

                                    });
                                  }
                                }
                                else if (state is RetriveULDPageLoadFailureState){
                                  DialogUtils.hideLoadingDialog(context);
                                  Vibration.vibrate(duration: 500);
                                  SnackbarUtil.showSnackbar(context, state.error.toString(), MyColor.colorRed, icon: FontAwesomeIcons.times);
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
                                      FocusScope.of(context).requestFocus(retriveBtnFocusNode);
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
                                else if (state is RetriveULDListSuccessState) {
                                  DialogUtils.hideLoadingDialog(context);
                                  if(state.retriveULDListModel.status == "E"){
                                    Vibration.vibrate(duration: 500);
                                    SnackbarUtil.showSnackbar(context, state.retriveULDListModel.statusMessage!, MyColor.colorRed, icon: FontAwesomeIcons.times);
                                  } else{
                                    retriveULDListModel = state.retriveULDListModel;
                                    setState(() {});
                                  }
                                }
                                else if (state is RetriveULDListFailureState){
                                  DialogUtils.hideLoadingDialog(context);
                                  Vibration.vibrate(duration: 500);
                                  SnackbarUtil.showSnackbar(context, state.error, MyColor.colorRed, icon: FontAwesomeIcons.times);
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
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(left: 0, right: 0, top: 0, bottom: 0),
                                                child: Column(
                                                  children: [
                                                    Row(children: List.generate(_tabs.length, (index) {
                                                      return InkWell(
                                                        onTap: () {
                                                          if (index == 0) {
                                                            setState(() {
                                                              _pageIndex = index;
                                                            });
                                                            /*if (flightCheckULDListModel != null) {
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
                                                            }*/
                                                          }
                                                          else if (index == 1) {
                                                            setState(() {
                                                              getULDList();
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



                                            ],
                                          )



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
      return (retriveULDPageLoadModel != null)
          ? (retriveULDPageLoadModel!.uLDTypeList == null) ? Center(
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
      )  : (retriveULDPageLoadModel!.uLDTypeList!.isNotEmpty)
          ? GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // Number of columns
          crossAxisSpacing: 12, // Horizontal spacing between columns
          mainAxisSpacing: 2, // Vertical spacing between rows
          childAspectRatio: 3, // Aspect ratio of each grid item
        ),
        itemCount: retriveULDPageLoadModel!.uLDTypeList!.length,
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        controller: scrollController,
        itemBuilder: (context, index) {
          ULDTypeList uldTypeList = retriveULDPageLoadModel!.uLDTypeList![index];

          return Directionality(
            textDirection: textDirection,
            child: InkWell(
              // focusNode: uldListFocusNode,
              onTap: () async {
              var result = await Navigator.push(context, CupertinoPageRoute(builder: (context) => RetriveULDDetailPage(uldType : uldTypeList.uLDType!, importSubMenuList: widget.importSubMenuList, exportSubMenuList: widget.exportSubMenuList, title: "Retrieve ULD List", refrelCode: widget.refrelCode, menuId: widget.menuId, mainMenuName: widget.mainMenuName),));
              if (result != null) {
                if (result.containsKey('status')) {
                  String? status = result['status'];

                  if(status == "R"){
                    setState(() {
                      getULDList();
                      _pageIndex = index;
                    });
                  }
                }else{
                  _resumeTimerOnInteraction();
                }
              }
              else{
                _resumeTimerOnInteraction();
              }

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
                      CustomeText(text: "${uldTypeList.uLDType}", fontColor: MyColor.colorBlack, fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_6_5, fontWeight: FontWeight.w600, textAlign: TextAlign.start),
                      CustomeText(text: "${uldTypeList.uLDCount}", fontColor: MyColor.colorBlack, fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_6_5, fontWeight: FontWeight.w600, textAlign: TextAlign.start),
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

    if (pageIndex == 1) {
      // design of a summary
      return Column(
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
                    labelText: (requiredLocation == "Y") ? "Requested ${lableModel.location} * ": "Requested ${lableModel.location}",
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
          RoundedButtonBlue(
            focusNode: retriveBtnFocusNode,
            text: "Retrieve ULD",
            press: () async {
              if(locationController.text.isNotEmpty){
                if(_isvalidateLocation){
                  if(CommonUtils.SELECTEDULDFORRETRIVE.isNotEmpty){
                    String uldSeqNoString = CommonUtils.SELECTEDULDFORRETRIVE
                        .map((item) => item.uLDSeqNo.toString())
                        .join('~');

                    // Print the formatted string
                    print("ULD Seq Numbers: $uldSeqNoString");

                  }else{
                    SnackbarUtil.showSnackbar(context, "Please at lease one ULD select from ULD list.",  MyColor.colorRed, icon: FontAwesomeIcons.times);
                    Vibration.vibrate(duration: 500);
                  }
                }else{
                  openValidationDialog("${lableModel.validateLocation}", locationFocusNode);
                }
              }else{
                openValidationDialog("${lableModel.enterLocationMsg}", locationFocusNode);
              }


            },
          ),
          SizedBox(height: SizeConfig.blockSizeVertical * SizeUtils.HEIGHT2,),
           (retriveULDListModel != null)
              ? ListView.builder(
             itemCount: retriveULDListModel!.uLDDetailList!.length,
             physics: const NeverScrollableScrollPhysics(),
             shrinkWrap: true,
             controller: scrollController,
             itemBuilder: (context, index) {
               ULDDetailList uldDetails = retriveULDListModel!.uLDDetailList![index];

               //  final isSelected = _selectedItems.contains(airSideReleaseDetail);


               return Directionality(
                 textDirection: textDirection,
                 child: InkWell(
                   // focusNode: uldListFocusNode,
                   onTap: () {


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
                       // margin: flightDetails.sHCCode!.contains("DGR") ? EdgeInsets.all(3) : EdgeInsets.all(0),
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
                                   Row(
                                     children: [
                                       CustomeText(text: "${uldDetails.uLDNo}", fontColor: MyColor.colorBlack, fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_7, fontWeight: FontWeight.w700, textAlign: TextAlign.start),
                                       SizedBox(width: SizeConfig.blockSizeHorizontal * SizeUtils.WIDTH2,),
                                       (uldDetails.intact! == "Y")
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
                                     ],
                                   ),
                                   Row(
                                     children: [
                                       CustomeText(
                                         text: "Status : ",
                                         fontColor: MyColor.textColorGrey2,
                                         fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                         fontWeight: FontWeight.w400,
                                         textAlign: TextAlign.start,
                                       ),
                                       const SizedBox(width: 5),
                                       Container(
                                         padding : EdgeInsets.symmetric(horizontal: SizeConfig.blockSizeHorizontal * 2.0, vertical: SizeConfig.blockSizeVertical * 0.2),
                                         decoration : BoxDecoration(
                                             borderRadius: BorderRadius.circular(20),
                                             color: (uldDetails.uLDStatus == "O") ? MyColor.flightFinalize : MyColor.flightNotArrived
                                         ),
                                         child: CustomeText(
                                           text:  (uldDetails.uLDStatus == "O") ? "${lableModel!.open}" : "${lableModel!.closed}",
                                           fontColor: MyColor.textColorGrey3,
                                           fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                           fontWeight: FontWeight.w500,
                                           textAlign: TextAlign.center,
                                         ),
                                       ),
                                     ],
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
                                         text: "${lableModel.stacksize} : ",
                                         fontColor: MyColor.textColorGrey2,
                                         fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_6,
                                         fontWeight: FontWeight.w400,
                                         textAlign: TextAlign.start,
                                       ),
                                       const SizedBox(width: 5),
                                       CustomeText(
                                         text: "${uldDetails.stackSize}",
                                         fontColor: MyColor.colorBlack,
                                         fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_7,
                                         fontWeight: FontWeight.w600,
                                         textAlign: TextAlign.start,
                                       ),
                                     ],
                                   ),
                                   Row(
                                     children: [
                                       SvgPicture.asset(map, height: SizeConfig.blockSizeVertical * SizeUtils.ICONSIZE2,),
                                       SizedBox(width: SizeConfig.blockSizeHorizontal,),
                                       CustomeText(
                                         text: "${uldDetails.uLDLocation}",
                                         fontColor: MyColor.colorBlack,
                                         fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_6,
                                         fontWeight: FontWeight.w600,
                                         textAlign: TextAlign.start,
                                       ),
                                     ],
                                   )



                                 ],
                               ),


                               SizedBox(height: SizeConfig.blockSizeVertical),
                               Row(
                                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                 children: [
                                   Expanded(
                                     flex: 1,
                                     child: RoundedButtonGreen(
                                       text: "Cancel Request",
                                       color: MyColor.colorRed,
                                       isborderButton: true,
                                       textSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_7,
                                       verticalPadding: SizeConfig.blockSizeVertical * SizeUtils.TEXTSIZE_1_2,
                                       press: () {

                                       },),
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
           )
              : Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: CustomeText(
                  text: lableModel.recordNotFound!,
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

    return const SizedBox();
  }

  void getDefaultPageLoadDetail() {
    context.read<RetriveULDCubit>().getDefaultPageLoad(_user!.userProfile!.userIdentity!, _splashDefaultData!.companyCode!, widget.menuId,);
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
        context.read<RetriveULDCubit>().getValidateLocation(
            truncatedResult,
            _user!.userProfile!.userIdentity!,
            _splashDefaultData!.companyCode!,
            widget.menuId, "a");
      }

    }


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


  void getULDList(){
    context.read<RetriveULDCubit>().getULDList(_user!.userProfile!.userIdentity!, _splashDefaultData!.companyCode!, widget.menuId,);
  }

}

