import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:galaxy/module/import/services/flightcheck/flightchecklogic/flightcheckcubit.dart';
import 'package:galaxy/module/import/services/flightcheck/flightchecklogic/flightcheckstate.dart';
import 'package:galaxy/utils/snackbarutil.dart';
import 'package:vibration/vibration.dart';

import '../../../../core/mycolor.dart';
import '../../../../language/appLocalizations.dart';
import '../../../../language/model/lableModel.dart';
import '../../../../manager/timermanager.dart';
import '../../../../prefrence/savedprefrence.dart';
import '../../../../utils/commonutils.dart';
import '../../../../utils/dialogutils.dart';
import '../../../../utils/sizeutils.dart';
import '../../../../widget/custometext.dart';
import '../../../../widget/customeuiwidgets/header.dart';
import '../../../../widget/header/mainheadingwidget.dart';
import '../../../login/model/userlogindatamodel.dart';
import '../../../login/pages/signinscreenmethods.dart';
import '../../../onboarding/sizeconfig.dart';
import 'dart:ui' as ui;

import '../../../splash/model/splashdefaultmodel.dart';
import '../../model/flightcheck/awblistmodel.dart';

class AWBListPage extends StatefulWidget {
  String mainMenuName;
  int flightSeqNo;
  int uldSeqNo;
  int menuId;

  AWBListPage({super.key, required this.mainMenuName, required this.flightSeqNo, required this.uldSeqNo, required this.menuId});

  @override
  State<AWBListPage> createState() => _AWBListPageState();
}

class _AWBListPageState extends State<AWBListPage> {
  InactivityTimerManager? inactivityTimerManager;
  final SavedPrefrence savedPrefrence = SavedPrefrence();
  UserDataModel? _user;
  SplashDefaultModel? _splashDefaultData;
  List<AWBItem>? awbItemList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadUser(); //load user data
  }


  Future<void> _loadUser() async {
    final user = await savedPrefrence.getUserData();
    final splashDefaultData = await savedPrefrence.getSplashDefaultData();
    if (user != null && splashDefaultData != null) {
      setState(() {
        _user = user;
        _splashDefaultData = splashDefaultData;
      });


      context.read<FlightCheckCubit>().getAWBList(widget.flightSeqNo, widget.uldSeqNo, _user!.userProfile!.userIdentity!, _splashDefaultData!.companyCode!, widget.menuId);

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

    return Directionality(
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
                      Padding(
                        padding: const EdgeInsets.only(left: 10, right: 15, top: 12, bottom: 12),
                        child: HeaderWidget(
                          title: "${lableModel!.information}",
                          titleTextColor: MyColor.colorBlack,
                          onBack: () {
                            Navigator.pop(context);
                          },
                          clearText: "",
                        ),
                      ),

                      BlocConsumer(
                          listener: (context, state) {
                            if (state is MainInitialState) {
                            }
                            else if(state is MainLoadingState){
                              DialogUtils.showLoadingDialog(context, message: lableModel.loading);
                            }
                            else if(state is AWBListSuccessState){
                              DialogUtils.hideLoadingDialog(context);
                              if(state.aWBModel.status == "E"){
                                SnackbarUtil.showSnackbar(context, state.aWBModel.statusMessage!, MyColor.colorRed, icon: FontAwesomeIcons.times);
                                Vibration.vibrate(duration: 500);
                              }else{
                                awbItemList = state.aWBModel.awbItemList;
                              }

                            }else if(state is AWBListFailureState){
                              DialogUtils.hideLoadingDialog(context);
                              SnackbarUtil.showSnackbar(context, state.error, MyColor.colorRed, icon: FontAwesomeIcons.times);
                              Vibration.vibrate(duration: 500);
                            }
                          },
                          builder: (context, state) {
                            return Expanded(
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
                                      child: (awbItemList!.isNotEmpty)
                                          ? ListView.builder(
                                        itemCount: awbItemList!.length,
                                        itemBuilder: (context, index) {
                                          return Container();

                                        },)
                                          : Center(child: CustomeText(text: "${lableModel.infonotfound}", fontColor: MyColor.textColor,
                                          fontSize: SizeConfig.textMultiplier * 2.1,
                                          fontWeight: FontWeight.w500,
                                          textAlign: TextAlign.center),)
                                  ),
                                ),
                              ),
                            );
                          },)







                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
