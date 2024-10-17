import 'package:dashed_circular_progress_bar/dashed_circular_progress_bar.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:galaxy/module/import/services/flightcheck/flightchecklogic/flightcheckcubit.dart';
import 'package:galaxy/module/import/services/flightcheck/flightchecklogic/flightcheckstate.dart';
import 'package:galaxy/utils/snackbarutil.dart';
import 'package:galaxy/widget/customdivider.dart';
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
import '../../../../widget/customebuttons/roundbuttonblue.dart';
import '../../../../widget/custometext.dart';
import '../../../../widget/customeuiwidgets/header.dart';
import '../../../../widget/groupidcustomtextfield.dart';
import '../../../../widget/header/mainheadingwidget.dart';
import '../../../../widget/roundbutton.dart';
import '../../../login/model/userlogindatamodel.dart';
import '../../../login/pages/signinscreenmethods.dart';
import '../../../onboarding/sizeconfig.dart';
import 'dart:ui' as ui;

import '../../../splash/model/splashdefaultmodel.dart';
import '../../model/flightcheck/awblistmodel.dart';
import '../../model/flightcheck/flightcheckuldlistmodel.dart';
import 'checkawb.dart';

class AWBRemarkListAckPage extends StatefulWidget {

  String mainMenuName;
  List<AWBRemarkList>? aWBRemarkList = [];

  AWBRemarkListAckPage({super.key, required this.mainMenuName, required this.aWBRemarkList});

  @override
  State<AWBRemarkListAckPage> createState() => _AWBRemarkListAckPageState();
}

class _AWBRemarkListAckPageState extends State<AWBRemarkListAckPage>{
  InactivityTimerManager? inactivityTimerManager;
  final SavedPrefrence savedPrefrence = SavedPrefrence();
  UserDataModel? _user;
  SplashDefaultModel? _splashDefaultData;

  List<bool> isExpandedList = [];

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
              body: Stack(
                children: [
                  MainHeadingWidget(mainMenuName: widget.mainMenuName),
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
                                title: "Remark List",
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
                                      child: (widget.aWBRemarkList!.isNotEmpty)
                                          ? ListView.builder(
                                        itemCount: widget.aWBRemarkList!.length,
                                        itemBuilder: (context, index) {

                                          bool isTextMoreThanTwoLines = _isTextMoreThanTwoLines(
                                            widget.aWBRemarkList![index].remark!,
                                            SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                          );

                                          return Column(
                                            children: [

                                              Padding(
                                                padding: const EdgeInsets.only(left: 8, right: 8, top: 12, bottom: 4),
                                                child: Row(
                                                  children: [
                                                    Expanded(
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Row(
                                                            children: [
                                                              CustomeText(
                                                                  text: AwbFormateNumberUtils.formatAWBNumber(widget.aWBRemarkList![index].AWBNo!),
                                                                  fontColor: MyColor.textColorGrey3,
                                                                  fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_7,
                                                                  fontWeight: FontWeight.w700,
                                                                  textAlign: TextAlign.start
                                                              ),
                                                              SizedBox(width: SizeConfig.blockSizeHorizontal * SizeUtils.WIDTH2,),
                                                              CircleAvatar(
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
                                                            ],
                                                          ),
                                                          SizedBox(height: SizeConfig.blockSizeVertical,),

                                                          Text(widget.aWBRemarkList![index].remark!,
                                                            style: TextStyle(
                                                                fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                                                color: MyColor.textColorGrey2,
                                                                fontWeight: FontWeight.w400),
                                                            textAlign: TextAlign.start,
                                                            maxLines: isExpandedList[index] ? null : 2,
                                                            overflow: isExpandedList[index] ? TextOverflow.visible : TextOverflow.ellipsis,
                                                          ),
                                                        ],
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


                                        },)
                                          : Center(child: CustomeText(text: "${lableModel!.infonotfound}", fontColor: MyColor.textColor,
                                          fontSize: SizeConfig.textMultiplier * 2.1,
                                          fontWeight: FontWeight.w500,
                                          textAlign: TextAlign.center),)
                                  ),
                                ),
                              ),
                            ),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [

                                Expanded(
                                  flex: 1,
                                  child: RoundedButtonBlue(
                                    text: "Close",
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
                                    text: "Acknowledge",
                                    color: MyColor.primaryColorblue,
                                    press: () async {
                                      Navigator.pop(context, "true");
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

}


