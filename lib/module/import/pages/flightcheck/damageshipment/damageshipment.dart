import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:galaxy/module/import/pages/flightcheck/damageshipment/damageui/damageawbdetailpage.dart';
import 'package:galaxy/module/import/pages/flightcheck/damageshipment/damageui/markandlable.dart';
import 'package:galaxy/module/import/pages/flightcheck/damageshipment/damageui/pointlistingpage.dart';
import 'package:galaxy/module/import/services/flightcheck/flightchecklogic/flightcheckcubit.dart';
import 'package:galaxy/module/import/services/flightcheck/flightchecklogic/flightcheckstate.dart';
import 'package:galaxy/utils/awbformatenumberutils.dart';
import 'package:galaxy/utils/sizeutils.dart';
import 'package:galaxy/utils/snackbarutil.dart';
import 'package:galaxy/widget/customebuttons/roundbuttonblue.dart';
import 'package:galaxy/widget/custometext.dart';
import 'package:vibration/vibration.dart';


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
import '../../../model/flightcheck/damagedetailmodel.dart';
import '../../../model/flightcheck/flightcheckuldlistmodel.dart';
import 'damageui/packingdetailspage.dart';
import 'damageui/outerpackingpage.dart';
import 'damageui/innerpackingpage.dart';
import 'damageui/detailsofdamagepage13a.dart';
import 'damageui/detailsofdamagepage13b.dart';
import 'damageui/missingitemandremarks.dart';
import 'damageui/damagediscoverpage.dart';
import 'damageui/actiontakenpage.dart';
import 'damageui/damageapparentlypage.dart';
import 'damageui/imagescreenpage.dart';


class DamageShimentPage extends StatefulWidget {

  FlightCheckInAWBBDList aWBItem;
  String mainMenuName;
  FlightDetailSummary flightDetailSummary;
  int menuId;

  DamageShimentPage({super.key, required this.aWBItem, required this.flightDetailSummary, required this.mainMenuName, required this.menuId});

  @override
  State<DamageShimentPage> createState() => _DamageShimentPageState();
}

class _DamageShimentPageState extends State<DamageShimentPage>{

  late PageController _pageController;
  int _currentPage = 0;

  InactivityTimerManager? inactivityTimerManager;

  final SavedPrefrence savedPrefrence = SavedPrefrence();
  UserDataModel? _user;
  SplashDefaultModel? _splashDefaultData;
  DamageDetailsModel? damageDetailsModel;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadUser();

    _pageController = PageController(initialPage: 0);

  }

  Future<void> _loadUser() async {
    final user = await savedPrefrence.getUserData();
    final splashDefaultData = await savedPrefrence.getSplashDefaultData();
    if (user != null && splashDefaultData != null) {
      setState(() {
        _user = user;
        _splashDefaultData = splashDefaultData;
      });

      context.read<FlightCheckCubit>().getDamageDetails(widget.flightDetailSummary.flightSeqNo!, "${widget.aWBItem.iMPAWBRowId!}", "${widget.aWBItem.iMPShipRowId!}", _user!.userProfile!.userIdentity!, _splashDefaultData!.companyCode!, widget.menuId);


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
    _pageController.dispose();
  }


  List<Widget> _listViews() {
    return [

      (damageDetailsModel != null) ? DamageAwbDetailPage(
        damageDetailsModel: damageDetailsModel!,
        preclickCallback: () {
          _resumeTimerOnInteraction(); // Reset the timer on scroll event
          _currentPage > 0 ? _onPreviousPressed() : null;
      },
      nextclickCallback: () {
        _resumeTimerOnInteraction(); // Reset the timer on scroll event
        _currentPage < _listViews().length - 1
            ? _onNextPressed()
            : null;
        },
      ) : Container(),

      PointListingPage(
        preclickCallback: () {
        _resumeTimerOnInteraction(); // Reset the timer on scroll event
        _currentPage > 0 ? _onPreviousPressed() : null;
      },
        nextclickCallback: () {
        _resumeTimerOnInteraction(); // Reset the timer on scroll event
        _currentPage < _listViews().length - 1
            ? _onNextPressed()
            : null;
      },
      curruentCallback: (curruentPage) {
        _pageController.animateToPage(curruentPage,
            duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
      },
      ),

      (damageDetailsModel != null) ? PackingDetailsPage(
        damageDetailsModel: damageDetailsModel!,
        preclickCallback: () {
          _currentPage > 0 ? _onPreviousPressed() : null;

        },
        nextclickCallback: () {
          _currentPage < _listViews().length - 1
              ? _onNextPressed()
              : null;

        },
      ) : Container(),

      (damageDetailsModel != null) ? MarkAndLablePage(
        damageDetailsModel: damageDetailsModel!,
        preclickCallback: () {
          _currentPage > 0 ? _onPreviousPressed() : null;

        },
        nextclickCallback: () {
          _currentPage < _listViews().length - 1
              ? _onNextPressed()
              : null;

        },
      ) : Container(),

      (damageDetailsModel != null) ? OuterPackingPage(
        damageDetailsModel: damageDetailsModel,
        preclickCallback: () {
          _resumeTimerOnInteraction(); // Reset the timer on scroll event
          _currentPage > 0 ? _onPreviousPressed() : null;

        },
        nextclickCallback: () {
          _resumeTimerOnInteraction(); // Reset the timer on scroll event
          _currentPage < _listViews().length - 1
              ? _onNextPressed()
              : null;

        },
      ) : Container(),

      (damageDetailsModel != null) ? InnerPackingPage(
        damageDetailsModel: damageDetailsModel,
        preclickCallback: () {
          _resumeTimerOnInteraction(); // Reset the timer on scroll event
          _currentPage > 0 ? _onPreviousPressed() : null;

        },
        nextclickCallback: () {
          _resumeTimerOnInteraction(); // Reset the timer on scroll event
          _currentPage < _listViews().length - 1
              ? _onNextPressed()
              : null;
        },
      ) : Container(),

      (damageDetailsModel != null) ? DetailsOfDamage13aPage(
        damageDetailsModel: damageDetailsModel,
        preclickCallback: () {
          _resumeTimerOnInteraction(); // Reset the timer on scroll event
          _currentPage > 0 ? _onPreviousPressed() : null;
        },
        nextclickCallback: () {
          _resumeTimerOnInteraction(); // Reset the timer on scroll event
          _currentPage < _listViews().length - 1
              ? _onNextPressed()
              : null;
        },
      ) : Container(),

      (damageDetailsModel != null) ? DetailsOfDamagePage13b(
        damageDetailsModel: damageDetailsModel,
        preclickCallback: () {
          _resumeTimerOnInteraction(); // Reset the timer on scroll event
          _currentPage > 0 ? _onPreviousPressed() : null;
        },
        nextclickCallback: () {
          _resumeTimerOnInteraction(); // Reset the timer on scroll event
          _currentPage < _listViews().length - 1
              ? _onNextPressed()
              : null;
        },
      ) : Container(),

      (damageDetailsModel != null) ? DamageDiscoveredPage(
        damageDetailsModel: damageDetailsModel,
        preclickCallback: () {
          _resumeTimerOnInteraction(); // Reset the timer on scroll event
          _currentPage > 0 ? _onPreviousPressed() : null;
        },

        nextclickCallback: () {
          _resumeTimerOnInteraction(); // Reset the timer on scroll event
          _currentPage < _listViews().length - 1
              ? _onNextPressed()
              : null;
        },
      ) : Container(),

      MissingItemAndRemarksPage(
        preclickCallback: () {
          _resumeTimerOnInteraction(); // Reset the timer on scroll event
          _currentPage > 0 ? _onPreviousPressed() : null;
        },
        nextclickCallback: () {
          _resumeTimerOnInteraction(); // Reset the timer on scroll event
          _currentPage < _listViews().length - 1
              ? _onNextPressed()
              : null;
        },
      ),

      (damageDetailsModel != null) ? DamageApparentlyPage(
        damageDetailsModel: damageDetailsModel,
        preclickCallback: () {
          _resumeTimerOnInteraction(); // Reset the timer on scroll event
          _currentPage > 0 ? _onPreviousPressed() : null;
        },
        nextclickCallback: () {
          _resumeTimerOnInteraction(); // Reset the timer on scroll event
          _currentPage < _listViews().length - 1
              ? _onNextPressed()
              : null;
        },
      ) : Container(),

      (damageDetailsModel != null) ? ActionTakenPage(
        damageDetailsModel: damageDetailsModel,
        preclickCallback: () {
          _resumeTimerOnInteraction(); // Reset the timer on scroll event
          _currentPage > 0 ? _onPreviousPressed() : null;
        },
        nextclickCallback: () {
          _resumeTimerOnInteraction(); // Reset the timer on scroll event
          _currentPage < _listViews().length - 1
              ? _onNextPressed()
              : null;
        },
      ) : Container(),

      (damageDetailsModel != null) ? ImageScreenPage(
        damageDetailsModel: damageDetailsModel,
        preclickCallback: () {
          _resumeTimerOnInteraction(); // Reset the timer on scroll event
          _currentPage > 0 ? _onPreviousPressed() : null;
        },
        nextclickCallback: () {
          _resumeTimerOnInteraction(); // Reset the timer on scroll event
          _currentPage < _listViews().length - 1
              ? _onNextPressed()
              : null;
        },
      ) : Container(),
    ];
  }


  void _onNextPressed() {
    if (_currentPage < _listViews().length - 1) {
      setState(() {
        _currentPage++;
        _pageController.animateToPage(_currentPage,
            duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
      });
    }
  }

  void _onPreviousPressed() {
    if (_currentPage > 0) {
      setState(() {
        _currentPage--;
        _pageController.animateToPage(_currentPage,
            duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
      });
    }
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

                  BlocConsumer<FlightCheckCubit, FlightCheckState>(
                    listener: (context, state) {
                      if(state is MainLoadingState){
                        DialogUtils.showLoadingDialog(context, message: lableModel!.loading);
                      }
                      else if(state is GetDamageDetailSuccessState){
                        DialogUtils.hideLoadingDialog(context);
                        if(state.damageDetailsModel.status == "E"){
                          Vibration.vibrate(duration: 500);
                          SnackbarUtil.showSnackbar(context, state.damageDetailsModel.statusMessage!, MyColor.textColor, icon: FontAwesomeIcons.times);
                        }else{
                          damageDetailsModel = state.damageDetailsModel;
                          setState(() {

                          });
                        }

                      }else if(state is GetDamageDetailFailureState){

                      }
                    },
                    builder: (context, state) {
                      if(state is GetDamageDetailSuccessState){
                        return Positioned(
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
                                      Expanded(
                                        child: Container(
                                          padding: const EdgeInsets.only(left: 10, right: 10, top: 12, bottom: 12),
                                          child: PageView(
                                            physics: NeverScrollableScrollPhysics(),
                                            controller: _pageController,
                                            children: _listViews(),
                                            onPageChanged: (int page) {
                                              setState(() {
                                                _currentPage = page;
                                              });
                                            },
                                          ),
                                        ),
                                      ),

                                    ],
                                  ),),),
                            ));
                      }

                      return Container();
                    },
                  )





                  ,

                ],
              ),
            )),
      ),
    );
  }

}

