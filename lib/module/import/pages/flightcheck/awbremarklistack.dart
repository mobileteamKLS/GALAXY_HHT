
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:galaxy/module/import/services/flightcheck/flightchecklogic/flightcheckcubit.dart';
import 'package:galaxy/module/import/services/flightcheck/flightchecklogic/flightcheckstate.dart';
import 'package:galaxy/widget/customedrawer/customedrawer.dart';
import 'package:vibration/vibration.dart';
import '../../../../core/images.dart';
import '../../../../core/mycolor.dart';
import '../../../../language/appLocalizations.dart';
import '../../../../language/model/lableModel.dart';
import '../../../../manager/timermanager.dart';
import '../../../../prefrence/savedprefrence.dart';
import '../../../../utils/awbformatenumberutils.dart';
import '../../../../utils/commonutils.dart';
import '../../../../utils/dialogutils.dart';
import '../../../../utils/sizeutils.dart';
import '../../../../utils/snackbarutil.dart';
import '../../../../utils/validationmsgcodeutils.dart';
import '../../../../widget/customebuttons/roundbuttonblue.dart';
import '../../../../widget/custometext.dart';
import '../../../../widget/customeuiwidgets/header.dart';
import '../../../../widget/header/mainheadingwidget.dart';
import '../../../login/model/userlogindatamodel.dart';
import '../../../login/pages/signinscreenmethods.dart';
import '../../../onboarding/sizeconfig.dart';
import 'dart:ui' as ui;

import '../../../profile/page/profilepagescreen.dart';
import '../../../splash/model/splashdefaultmodel.dart';
import '../../../submenu/model/submenumodel.dart';
import '../../model/flightcheck/awblistmodel.dart';
import '../../model/uldacceptance/buttonrolesrightsmodel.dart';


class AWBRemarkListAckPage extends StatefulWidget {


  List<ButtonRight> buttonRightsList;

  String mainMenuName;
  List<AWBRemarksList>? aWBRemarkList = [];
  FlightCheckInAWBBDList aWBItem;
  int menuId;
  List<SubMenuName> importSubMenuList = [];
  List<SubMenuName> exportSubMenuList = [];

  AWBRemarkListAckPage({super.key,
    required this.importSubMenuList,
    required this.exportSubMenuList,
    required this.buttonRightsList,
    required this.mainMenuName, required this.aWBRemarkList, required this.aWBItem, required this.menuId});

  @override
  State<AWBRemarkListAckPage> createState() => _AWBRemarkListAckPageState();
}

class _AWBRemarkListAckPageState extends State<AWBRemarkListAckPage> with SingleTickerProviderStateMixin{
  InactivityTimerManager? inactivityTimerManager;
  final SavedPrefrence savedPrefrence = SavedPrefrence();
  UserDataModel? _user;
  SplashDefaultModel? _splashDefaultData;

  List<bool> isExpandedList = [];

  late AnimationController _blinkController;
  late Animation<Color?> _colorAnimation;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadUser(); //load user data

    widget.aWBRemarkList?.sort((a, b) {
      if (b.isHighPriority == true && a.isHighPriority != true) {
        return 1;
      } else if (b.isHighPriority != true && a.isHighPriority == true) {
        return -1;
      } else {
        return 0;
      }
    });

    isExpandedList = List.filled(widget.aWBRemarkList!.length, false);

    _blinkController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: TickerProviders(), // Manually providing Ticker
    )..repeat(reverse: true); // Loop the animation

    _colorAnimation = ColorTween(
      begin: MyColor.shcColorList[0],
      end: Colors.transparent,
    ).animate(_blinkController); // color animation

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

    inactivityTimerManager = InactivityTimerManager(
      context: context,
      timeoutMinutes: _splashDefaultData!.activeLoginTime!,  // Set the desired inactivity time here
      onTimeout: _handleInactivityTimeout,  // Define what happens when timeout occurs
    );
    inactivityTimerManager?.startTimer();

  }

  Future<void> _handleInactivityTimeout() async {

    bool? activateORNot = await DialogUtils.showingActivateTimerDialog(context, _user!.userProfile!.userId!, _splashDefaultData!.companyCode!);
    print("CHECK_ACTIVATE_OR_NOT FLIGHT_CHECK====== ${activateORNot}");
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
    print('Activity detected, timer reset');
  }

  Future<bool> _onWillPop() async {
    FocusScope.of(context).unfocus();
    Navigator.pop(context, "Done");
    return false; // Prevents the default back button action
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    inactivityTimerManager!.stopTimer();
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

    List<String> shcCodes = widget.aWBItem.sHCCode!.split(',');

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
                      child: BlocListener<FlightCheckCubit, FlightCheckState>(
                        listener: (context, state) {
                          if(state is MainLoadingState){
                            DialogUtils.showLoadingDialog(context, message: lableModel.loading);
                          }
                          else if(state is AWBAcknoledgeSuccessState){

                            DialogUtils.hideLoadingDialog(context);
                            if(state.awbRemarkAcknoledgeModel.status == "E"){
                              Vibration.vibrate(duration: 500);
                              SnackbarUtil.showSnackbar(context, state.awbRemarkAcknoledgeModel.statusMessage!, MyColor.colorRed, icon: FontAwesomeIcons.times);
                            }else{
                              Navigator.pop(context, "true");
                            }

                          }else if(state is AWBAcknoledgeFailureState){
                            Vibration.vibrate(duration: 500);
                            SnackbarUtil.showSnackbar(context, state.error, MyColor.colorRed, icon: FontAwesomeIcons.times);
                          }
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
                                title: lableModel!.remarkList!,
                                onBack: () {
                                  Navigator.pop(context, "Done");
                                },
                                clearText: "",
                                //add clear text to clear all feild
                                onClear: () {

                                },
                              ),
                            ),

                            Expanded(
                              child: Padding(
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
                                        borderRadius:
                                        BorderRadius.circular(8),
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
                                            padding: const EdgeInsets.all(10),
                                            child: Directionality(
                                              textDirection: uiDirection,
                                              child: Row(
                                                children: [
                                                  SvgPicture.asset(info, height: SizeConfig.blockSizeVertical * SizeUtils.ICONSIZE2,),
                                                  SizedBox(width: SizeConfig.blockSizeHorizontal,),
                                                  CustomeText(
                                                      text: "${lableModel.remarkfor} AWB No. ${AwbFormateNumberUtils.formatAWBNumber(widget.aWBRemarkList![0].aWBNo!)}",
                                                      fontColor: MyColor.textColorGrey2,
                                                      fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                                      fontWeight: FontWeight.w500,
                                                      textAlign: TextAlign.start)
                                                ],
                                              ),
                                            ),
                                          ),
                                          (widget.aWBRemarkList!.isNotEmpty)
                                              ? Expanded(
                                            child: ListView.builder(
                                              itemCount: widget.aWBRemarkList!.length,
                                              itemBuilder: (context, index) {

                                                bool isTextMoreThanTwoLines = _isTextMoreThanTwoLines(
                                                  widget.aWBRemarkList![index].remark!,
                                                  SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                                );

                                                return Column(
                                                  children: [

                                                    Padding(
                                                      padding: const EdgeInsets.only(left: 8, right: 8, top: 4, bottom: 4),
                                                      child: Row(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Padding(
                                                            padding: const EdgeInsets.only(top: 2),
                                                            child: CircleAvatar(
                                                              radius: 10,
                                                              backgroundColor: (widget.aWBRemarkList![index].isHighPriority == true)
                                                                  ? MyColor.colorRed
                                                                  : Colors.transparent,
                                                              child: CustomeText(
                                                                text: (widget.aWBRemarkList![index].isHighPriority == true) ? "P" : "",
                                                                fontColor: MyColor.colorWhite,
                                                                fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                                                fontWeight: FontWeight.w500,
                                                                textAlign: TextAlign.center,
                                                              ),
                                                            ),
                                                          ),
                                                          SizedBox(width: SizeConfig.blockSizeHorizontal * SizeUtils.WIDTH2,),
                                                          Expanded(
                                                            child: Text(widget.aWBRemarkList![index].remark!,
                                                              style: TextStyle(
                                                                  fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                                                  color: MyColor.textColorGrey2,
                                                                  fontWeight: FontWeight.w400),
                                                              textAlign: TextAlign.start,
                                                              maxLines: isExpandedList[index] ? null : 2,
                                                              overflow: isExpandedList[index] ? TextOverflow.visible : TextOverflow.ellipsis,
                                                            ),
                                                          ),
                                                          isTextMoreThanTwoLines ? InkWell(
                                                            onTap: () {
                                                              setState(() {
                                                                isExpandedList[index] = !isExpandedList[index];
                                                              });

                                                            },
                                                            child: Container(
                                                              padding: EdgeInsets.symmetric(vertical: 5, horizontal: 8),
                                                              decoration: BoxDecoration(
                                                                  color: MyColor.dropdownColor,
                                                                  borderRadius: BorderRadius.circular(SizeConfig.blockSizeHorizontal * SizeUtils.WIDTH3)
                                                              ),
                                                              child: Icon( isExpandedList[index] ? Icons.keyboard_arrow_up_rounded : Icons.navigate_next_rounded, color: MyColor.primaryColorblue, size: SizeConfig.blockSizeVertical * SizeUtils.ICONSIZE_2_6,),
                                                            ),
                                                          ) : SizedBox()
                                                        ],
                                                      ),
                                                    ),

                                                    const Divider(color: MyColor.textColorGrey, thickness: 0.3,)
                                                  ],
                                                );


                                              },),
                                          )
                                              : Center(child: CustomeText(text: "${lableModel!.infonotfound}", fontColor: MyColor.textColor,
                                              fontSize: SizeConfig.textMultiplier * 2.1,
                                              fontWeight: FontWeight.w500,
                                              textAlign: TextAlign.center),),
                                        ],
                                      )
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.all(10),
                              margin: const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 0),
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
                                    children: [
                                      widget.aWBItem.sHCCode!.isNotEmpty
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
                                  (shcCodes.isNotEmpty) ? SizedBox(height: SizeConfig.blockSizeVertical,) : SizedBox(),
                                  Row(
                                    children: [
                                      Expanded(
                                        flex: 2,
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
                                              text: "${widget.aWBItem.nPX}",
                                              fontColor: MyColor.colorBlack,
                                              fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                              fontWeight: FontWeight.w600,
                                              textAlign: TextAlign.start,
                                            ),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        flex: 2,
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
                                              text: "${widget.aWBItem.nPR}",
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
                                          child: Container())
                                    ],
                                  ),
                                  SizedBox(height: SizeConfig.blockSizeVertical,),
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
                                        text: "${widget.aWBItem.commodity}",
                                        fontColor: MyColor.colorBlack,
                                        fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                        fontWeight: FontWeight.w500,
                                        textAlign: TextAlign.start,
                                      ),
                                    ],
                                  ),

                                ],
                              ),
                            ),

                            Padding(
                              padding: const EdgeInsets.only(left: 10, right: 15, top: 12, bottom: 12),
                              child: Container(
                                padding: const EdgeInsets.only(left: 8, right: 8, top: 12, bottom: 12),
                                decoration: BoxDecoration(
                                  color: MyColor.colorWhite,
                                  borderRadius:
                                  BorderRadius.circular(8),
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

                                    Expanded(
                                      flex: 1,
                                      child: RoundedButtonBlue(
                                        text: "${lableModel.back}",
                                        isborderButton: true,
                                        color:  MyColor.primaryColorblue,
                                        press: () async {
                                          Navigator.pop(context, "Done");
                                        },
                                      ),
                                    ),
                                    SizedBox(
                                      width: SizeConfig.blockSizeHorizontal * SizeUtils.WIDTH4,
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: RoundedButtonBlue(
                                        text: "${lableModel.acknowledge}",
                                        color: MyColor.primaryColorblue,
                                        press: () async {

                                          if(isButtonEnabled("acknowledge", widget.buttonRightsList)){
                                            context.read<FlightCheckCubit>().aWBRemarkUpdateAcknoledge(
                                                widget.aWBItem.iMPAWBRowId!,
                                                widget.aWBItem.iMPShipRowId!,
                                                _user!.userProfile!.userIdentity!,
                                                _splashDefaultData!.companyCode!,
                                                widget.menuId);
                                          }else{
                                            SnackbarUtil.showSnackbar(context, ValidationMessageCodeUtils.AuthorisedRolesAndRightsMsg, MyColor.colorRed, icon: FontAwesomeIcons.times);
                                            Vibration.vibrate(duration: 500);
                                          }



                                        },
                                      ),
                                    ),

                                  ],
                                ),
                              ),
                            )

                          ],
                        ),
                      ),
                      )
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
  bool _isTextMoreThanTwoLines(String text, double fontSize) {
    final TextPainter textPainter = TextPainter(
      text: TextSpan(text: text, style: TextStyle(fontSize: fontSize)),
      maxLines: 2,
      textDirection: TextDirection.ltr,
    )..layout(maxWidth: MediaQuery.of(context).size.width * 0.7); // Adjust maxWidth as needed

    return textPainter.didExceedMaxLines;
  }

  bool isButtonEnabled(String buttonId, List<ButtonRight> buttonList) {
    ButtonRight? button = buttonList.firstWhere(
          (button) => button.buttonId == buttonId,
    );
    return button.isEnable == 'Y';
  }

}
// ticker animation for DGR code blink animation
class TickerProviders extends TickerProvider {
  @override
  Ticker createTicker(onTick) => Ticker(onTick);
}


