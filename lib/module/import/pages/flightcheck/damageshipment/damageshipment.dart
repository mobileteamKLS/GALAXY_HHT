import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:galaxy/utils/awbformatenumberutils.dart';
import 'package:galaxy/utils/sizeutils.dart';
import 'package:galaxy/utils/snackbarutil.dart';
import 'package:galaxy/widget/customebuttons/roundbuttonblue.dart';
import 'package:galaxy/widget/custometext.dart';


import '../../../../../core/images.dart';
import '../../../../../core/mycolor.dart';
import '../../../../../language/appLocalizations.dart';
import '../../../../../language/model/lableModel.dart';
import '../../../../../manager/timermanager.dart';
import '../../../../../prefrence/savedprefrence.dart';
import '../../../../../utils/commonutils.dart';
import '../../../../../utils/dialogutils.dart';
import '../../../../../widget/customeuiwidgets/header.dart';
import '../../../../../widget/header/mainheadingwidget.dart';

import 'dart:ui' as ui;

import '../../../../login/model/userlogindatamodel.dart';
import '../../../../login/pages/signinscreenmethods.dart';

import '../../../../onboarding/sizeconfig.dart';

import '../../../../splash/model/splashdefaultmodel.dart';
import '../../../model/flightcheck/awblistmodel.dart';


class DamageShimentPage extends StatefulWidget {

  FlightCheckInAWBBDList aWBItem;
  String mainMenuName;
  DamageShimentPage({super.key, required this.aWBItem, required this.mainMenuName});

  @override
  State<DamageShimentPage> createState() => _DamageShimentPageState();
}

class _DamageShimentPageState extends State<DamageShimentPage>{

  InactivityTimerManager? inactivityTimerManager;

  final SavedPrefrence savedPrefrence = SavedPrefrence();
  UserDataModel? _user;
  SplashDefaultModel? _splashDefaultData;





  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadUser();


  }

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
      inactivityTimerManager?.startTimer();
    }
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


  @override
  Widget build(BuildContext context) {
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
      child: Directionality(
        textDirection: uiDirection,
        child: SafeArea(
            child: Scaffold(
          backgroundColor: MyColor.colorWhite,
          body: Stack(
            children: [

              MainHeadingWidget(mainMenuName: "${widget.mainMenuName}"),
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
                                    child: Directionality(
                    textDirection: textDirection,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 10, right: 15, top: 12, bottom: 12),
                          child: HeaderWidget(
                            titleTextColor: MyColor.colorBlack,
                            title: "Damage & Save",
                            onBack: () {
                              _onWillPop();
                            },
                            clearText: "",
                            onClear: () {

                            },
                          ),
                        ),

                        Expanded(
                            child: SingleChildScrollView(
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 10,
                                    right: 10,
                                    top: 0,
                                    bottom: 0),
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
                                            textDirection: uiDirection,
                                            child: Row(
                                              children: [
                                                SvgPicture.asset(info, height: SizeConfig.blockSizeVertical * SizeUtils.ICONSIZE2,),
                                                SizedBox(width: SizeConfig.blockSizeHorizontal,),
                                                CustomeText(
                                                    text: "${lableModel!.detailsForAWBNo} ${AwbFormateNumberUtils.formatAWBNumber(widget.aWBItem.aWBNo!)}",
                                                    fontColor: MyColor.textColorGrey2,
                                                    fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                                    fontWeight: FontWeight.w500,
                                                    textAlign: TextAlign.start)
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),


                                    Container(
                                      padding: EdgeInsets.all(10),
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
                                        children: [
                                          Expanded(
                                            flex: 1,
                                            child: RoundedButtonBlue(
                                              text: "Previous",
                                              press: () async {

                                              },
                                            ),
                                          ),
                                          SizedBox(
                                            width: SizeConfig.blockSizeHorizontal * SizeUtils.WIDTH4,
                                          ),
                                          Expanded(
                                            flex: 1,
                                            child: RoundedButtonBlue(
                                              text: "Next",
                                              press: () async {

                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    )


                                  ],
                                ),
                              ),
                            )),


                      ],
                    ),),),
                  )),

            ],
          ),
        )),
      ),
    );
  }

}

