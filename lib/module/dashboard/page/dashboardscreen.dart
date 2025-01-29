import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:galaxy/language/model/dashboardModel.dart';
import 'package:galaxy/module/dashboard/model/menumodel.dart';
import 'package:galaxy/module/dashboard/service/menuLogic/menucubit.dart';
import 'package:galaxy/module/dashboard/service/menuLogic/menustate.dart';
import 'package:galaxy/module/login/pages/signinscreenmethods.dart';
import 'package:galaxy/module/login/services/loginlogic/logincubit.dart';
import 'package:galaxy/module/login/services/loginlogic/loginstate.dart';
import 'package:galaxy/module/onboarding/sizeconfig.dart';
import 'package:galaxy/module/submenu/page/submenupage.dart';
import 'package:galaxy/module/login/pages/loginscreen.dart';
import 'package:galaxy/utils/commonutils.dart';
import 'package:galaxy/utils/sizeutils.dart';
import 'package:galaxy/utils/validationmsgcodeutils.dart';
import 'package:vibration/vibration.dart';
import '../../../core/images.dart';
import '../../../core/mycolor.dart';
import '../../../language/appLocalizations.dart';
import '../../../manager/lifecycleWatcher.dart';
import '../../../manager/timermanager.dart';
import '../../../prefrence/savedprefrence.dart';
import '../../../utils/dialogutils.dart';
import '../../../utils/snackbarutil.dart';
import '../../../widget/customebuttons/roundbuttonblue.dart';
import '../../../widget/customedrawer/customedrawer.dart';
import '../../../widget/custometext.dart';
import '../../../widget/customeuiwidgets/dashbordwidget.dart';
import '../../../widget/customeuiwidgets/footer.dart';
import '../../../widget/customeuiwidgets/header.dart';
import '../../../widget/customtextfield.dart';
import '../../../widget/design/index.dart';
import '../../../widget/design/prostebeziercurve.dart';
import '../../../widget/header/mainheadingwidget.dart';
import '../../../widget/roundbutton.dart';
import '../../profile/page/profilepagescreen.dart';
import '../../login/model/userlogindatamodel.dart';
import 'dart:ui' as ui;

import '../../splash/model/splashdefaultmodel.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {

  InactivityTimerManager? inactivityTimerManager;
  //LifecycleWatcher? _lifecycleWatcher;

  final SavedPrefrence savedPrefrence = SavedPrefrence();
  UserDataModel? _user;
  SplashDefaultModel? _splashDefaultData;


  @override
  void initState() {
    super.initState();
    print("DASHBOARD_SCREEN");
    //load user from shared prefrence
    _loadUser();

  }


  Future<void> _loadUser() async {
    final userName = await savedPrefrence.getUserData();
    final splashDefaultData = await savedPrefrence.getSplashDefaultData();
    if (userName != null) {
      setState(() {
        _user = userName;
        _splashDefaultData = splashDefaultData!;
      });
      _loadMenuList(); // load menu list api call

      // Assume user is loaded here
      inactivityTimerManager = InactivityTimerManager(
        context: context,
        timeoutMinutes: _splashDefaultData!.activeLoginTime!,  // Set the desired inactivity time here
        onTimeout: _handleInactivityTimeout,  // Define what happens when timeout occurs
      );
      inactivityTimerManager?.startTimer();  // Start the inactivity timer
    //  _lifecycleWatcher = LifecycleWatcher(timerManager: inactivityTimerManager);
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

  @override
  void dispose() {
    inactivityTimerManager?.stopTimer(); // Stop the timer when the screen is disposed
    //_lifecycleWatcher?.dispose();  // Stop watching the lifecycle
    super.dispose();
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    //culture wise data load from assets file

    print("DASHBOARD_SCREEN");

    AppLocalizations? localizations = AppLocalizations.of(context);
    DashboardModel? dashboardModel = localizations!.dashboardModel;

    //ui direction not change for arabic
    ui.TextDirection uiDirection = localizations.locale.languageCode == CommonUtils.ARABICCULTURECODE
        ? ui.TextDirection.ltr
        : ui.TextDirection.ltr;

    //text direction change for arabic
    ui.TextDirection textDirection = localizations.locale.languageCode == CommonUtils.ARABICCULTURECODE
        ? ui.TextDirection.rtl
        : ui.TextDirection.ltr;


    return WillPopScope(
      onWillPop: () async {
        // show exit dialog
        bool? exitConfirmed = await DialogUtils.showExitAppDialog(context, dashboardModel!);
        if (exitConfirmed == true) {
          return true; // Exit the app
        }
        return false; // Stay in the app (Cancel was clicked)
      },
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
                user: _user!,
                splashDefaultData: _splashDefaultData!,
                importSubMenuList: const [],
                exportSubMenuList: const [],
                onDrawerCloseIcon: () {
                  _scaffoldKey.currentState?.closeDrawer();
                },) : null, // Add custom drawer widget here
              body: Stack(
                children: [
                  MainHeadingWidget(mainMenuName: "${dashboardModel!.dashBoard}",
                    onDrawerIconTap: () {

                      _scaffoldKey.currentState?.openDrawer();
                    },
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
                                topRight: Radius.circular(SizeConfig.blockSizeVertical * SizeUtils.WIDTH2),
                                topLeft: Radius.circular(SizeConfig.blockSizeVertical * SizeUtils.WIDTH2))),
                        child: Column(
                          children: [
                            // header of title and clear function
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 10, right: 15, top: 12, bottom: 12),
                              child: Row(
                                children: [
                                  InkWell(
                                    onTap : () {
                                    },
                                    child: SvgPicture.asset(menu, height: 20,)/* Icon(
                                      Icons.dashboard_rounded,
                                      color: MyColor.colorBlack,
                                      size: SizeConfig.blockSizeVertical * 3,
                                    ),*/
                                  ),
                                  SizedBox(
                                    width: SizeConfig.blockSizeHorizontal * 2,
                                  ),
                                  CustomeText(text: "${dashboardModel.menu}", fontColor:  MyColor.colorBlack, fontSize: SizeConfig.textMultiplier * SizeUtils.HEADINGTEXTSIZE, fontWeight: FontWeight.bold, textAlign: TextAlign.start)
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: SizeConfig.blockSizeHorizontal * SizeUtils.MAINPADDINGVERTICAL,
                              ),
                              child: BlocConsumer<MenuCubit, MenuState>(
                                listener: (context, state) {
                                  if(state is MenuStateLoading){
                                    //show loading dialog
                                    DialogUtils.showLoadingDialog(context, message: dashboardModel.loading);
                                  }
                                  else if(state is MenuStateSuccess){
                                    //hide loading dialog
                                    DialogUtils.hideLoadingDialog(context);
                                  }
                                  else if(state is MenuStateFailure){
                                    //hide loading dialog
                                    DialogUtils.hideLoadingDialog(context);
                                    //show snackbar dialog
                                    SnackbarUtil.showSnackbar(context, state.error, MyColor.colorRed);
                                  }
                                },
                                builder: (context, state) {
                                  if(state is MenuStateSuccess){

                                    //add gridview
                                    return (state.menuModel.menuName!.isNotEmpty) ?
                                    GridView.builder(
                                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 2, crossAxisSpacing: 5, mainAxisSpacing: 5, childAspectRatio: 1.1),
                                      itemCount: state.menuModel.menuName!.length, // Filter the list and update the itemCount
                                      physics: const NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      itemBuilder: (context, index) {

                                        /*final filteredMenu = state.menuModel.menuName!
                                            .where((menu) => menu.menuName != "Courier")
                                            .toList();*/

                                        MenuName menuName = state.menuModel.menuName![index];
                                        String menuTitle = "${dashboardModel.getValueFromKey(CommonUtils.removeExtraIcons(menuName.refMenuCode!))}";

                                        return DashboardCustomeWidget(title: menuTitle,
                                          imageUrl: (menuName.imageIcon!.isNotEmpty) ? CommonUtils.getSVGImagePath(menuName.imageIcon!) : "",
                                          bgColor: MyColor.subMenuColorList[index % MyColor.subMenuColorList.length],
                                          onClick: () async {

                                            // next to submenu page from dashboard page
                                            if(menuName.IsEnable == "Y"){
                                              inactivityTimerManager?.stopTimer(); // Stop the timer when the screen is disposed
                                              var value = await Navigator.push(context, CupertinoPageRoute(builder: (context) => SubMenuPage(menuId: menuName.menuId!, menuName: menuTitle),));
                                              if(value == "Done"){
                                                _resumeTimerOnInteraction();
                                              }

                                            }else{
                                              SnackbarUtil.showSnackbar(context, ValidationMessageCodeUtils.AuthorisedRolesAndRightsMsg, MyColor.colorRed, icon: FontAwesomeIcons.times);
                                              Vibration.vibrate(duration: 500);
                                            }

                                          },);
                                      },) : const SizedBox();

                                  }
                                  return const SizedBox();
                                },
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



    /*return WillPopScope(
      onWillPop: () async {
        // show exit dialog
        bool? exitConfirmed = await DialogUtils.showExitAppDialog(context, dashboardModel!);
        if (exitConfirmed == true) {
          return true; // Exit the app
        }
        return false; // Stay in the app (Cancel was clicked)
      },
      child: GestureDetector(
        onTap: _resumeTimerOnInteraction,  // Resuming on any tap
        onPanDown: (details) => _resumeTimerOnInteraction(), // Resuming on any gesture
        child: Directionality(
          textDirection: uiDirection,
          child: Scaffold(
            backgroundColor: Colors.white,
            body: SafeArea(
                child: Stack(
              children: [
                NotificationListener<ScrollNotification>(
                  onNotification: (ScrollNotification scroll) {
                    _resumeTimerOnInteraction();
                    return true;
                  },
                  child: ListView(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: SizeConfig.blockSizeHorizontal * SizeUtils.MAINPADDINGHORIZONTAL,
                          vertical: SizeConfig.blockSizeVertical * SizeUtils.MAINPADDINGVERTICAL,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (_user != null)
                                      InkWell(
                                        onTap: () {
                                          // navigate to profile picture
                                          inactivityTimerManager?.stopTimer(); // Stop the timer when the screen is disposed
                                          Navigator.push(context, CupertinoPageRoute(builder: (context) => const Profilepagescreen(),));
                                        },

                                        // show first letter name and last letter
                                        child: CircleAvatar(
                                          backgroundColor: MyColor.primaryColorblue,
                                          radius: SizeConfig.blockSizeVertical *  2.2,
                                          child: CustomeText(
                                              text: "${_user?.userProfile?.firstName?[0] ?? ''}${_user?.userProfile?.lastName?[0] ?? ''}",
                                              textAlign: TextAlign.center,
                                              fontWeight: FontWeight.w500,
                                              fontColor:  MyColor.colorWhite,
                                              fontSize: SizeConfig.textMultiplier * SizeUtils.HEADINGTEXTSIZE,),
                                        ),
                                      ),
                                  ],
                                )
                              ],
                            ),
                            CustomeText(
                              text: "${dashboardModel!.dashBoard}",
                              fontSize: SizeConfig.textMultiplier * SizeUtils.HEADINGTEXTSIZE,
                              fontColor: MyColor.primaryColorblue,
                              fontWeight: FontWeight.w500,
                              textAlign: TextAlign.center,
                            ),

                            // logout btn add
                            InkWell(
                                onTap: () async {
                                  bool? logoutConfirmed = await DialogUtils.showLogoutDialog(context, dashboardModel);
                                  if (logoutConfirmed == true) {
                                    await savedPrefrence.logout(); // logout
                                    // navigate to signin screen
                                    Navigator.pushAndRemoveUntil(context, CupertinoPageRoute(builder: (context) => const SignInScreenMethod(),), (route) => false,);
                                  }
                                },
                                child: Icon(
                                  Icons.logout_rounded,
                                  size: SizeConfig.blockSizeVertical * 3.7,
                                ))
                          ],
                        ),
                      ),

                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: SizeConfig.blockSizeHorizontal * SizeUtils.MAINPADDINGHORIZONTAL,
                        ),
                        child: BlocConsumer<MenuCubit, MenuState>(
                          listener: (context, state) {
                            if(state is MenuStateLoading){
                              //show loading dialog
                              DialogUtils.showLoadingDialog(context, message: dashboardModel.loading);
                            }
                            else if(state is MenuStateSuccess){
                              //hide loading dialog
                              DialogUtils.hideLoadingDialog(context);
                            }
                            else if(state is MenuStateFailure){
                              //hide loading dialog
                              DialogUtils.hideLoadingDialog(context);
                              //show snackbar dialog
                              SnackbarUtil.showSnackbar(context, state.error, MyColor.colorRed);
                            }
                          },
                          builder: (context, state) {
                          if(state is MenuStateSuccess){

                            //add gridview
                            return (state.menuModel.menuName!.isNotEmpty) ? GridView.builder(
                                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2, crossAxisSpacing: 5, mainAxisSpacing: 5, childAspectRatio: 1.1),
                                itemCount: state.menuModel.menuName!.length,
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  MenuName menuName = state.menuModel.menuName![index];
                                  String menuTitle = "${dashboardModel.getValueFromKey(CommonUtils.removeExtraIcons(menuName.refMenuCode!))}";

                                  return DashboardCustomeWidget(title: menuTitle,
                                    imageUrl: (menuName.imageIcon!.isNotEmpty) ? CommonUtils.getSVGImagePath(menuName.imageIcon!) : "",
                                    onClick: () async {
                                    print("CHECK AUTORISed === ${state.menuModel.menuName![index].IsEnable}");

                                    // next to submenu page from dashboard page
                                    if(menuName.IsEnable == "Y"){
                                        inactivityTimerManager?.stopTimer(); // Stop the timer when the screen is disposed
                                        var value = await Navigator.push(context, CupertinoPageRoute(builder: (context) => SubMenuPage(menuId: menuName.menuId!, menuName: menuTitle),));
                                        if(value == "Done"){
                                          _resumeTimerOnInteraction();
                                        }

                                    }else{
                                      SnackbarUtil.showSnackbar(context, ValidationMessageCodeUtils.AuthorisedRolesAndRightsMsg, MyColor.colorRed, icon: FontAwesomeIcons.times);
                                      Vibration.vibrate(duration: 500);
                                    }

                                  },);
                                },) : const SizedBox();

                          }
                          return const SizedBox();
                        },
                        ),
                      )
                    ],
                  ),
                ),
              ],
            )),

          ),
        ),
      ),
    );*/
  }

  Future<void> _loadMenuList() async {
    // cam dashboard menu api
    context.read<MenuCubit>().menuModelData(_user!.userProfile!.userIdentity!, _user!.userProfile!.userGroup!, _splashDefaultData!.companyCode!);
  }

}
