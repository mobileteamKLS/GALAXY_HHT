import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:galaxy/language/appLocalizations.dart';
import 'package:galaxy/language/model/lableModel.dart';
import 'package:galaxy/language/model/subMenuModel.dart';
import 'package:galaxy/module/submenu/service/subMenuLogic/submenucubit.dart';
import 'package:galaxy/module/submenu/service/subMenuLogic/submenustate.dart';
import 'package:galaxy/utils/commonutils.dart';
import 'package:galaxy/utils/submenucodeutils.dart';
import 'package:galaxy/utils/validationmsgcodeutils.dart';
import 'package:galaxy/widget/customeuiwidgets/header.dart';
import 'package:galaxy/widget/customeuiwidgets/submenuwidget.dart';
import 'package:vibration/vibration.dart';
import '../../../core/mycolor.dart';
import '../../../manager/timermanager.dart';
import '../../../prefrence/savedprefrence.dart';
import '../../../utils/dialogutils.dart';
import '../../../utils/sizeutils.dart';
import '../../../utils/snackbarutil.dart';
import '../../../widget/customdivider.dart';
import '../../../widget/customeuiwidgets/footer.dart';
import '../../../widget/design/index.dart';
import '../../../widget/design/prostebeziercurve.dart';
import '../../import/pages/flightcheck/flightcheck.dart';
import '../../import/pages/uldacceptance/uldacceptancepage.dart';
import '../../login/pages/signinscreenmethods.dart';
import '../../onboarding/sizeconfig.dart';
import '../../login/model/userlogindatamodel.dart';
import '../../splash/model/splashdefaultmodel.dart';
import '../model/submenumodel.dart';
import 'dart:ui' as ui;

class SubMenuPage extends StatefulWidget {

  String menuId;
  String menuName;

  SubMenuPage({super.key, required this.menuId, required this.menuName});

  @override
  State<SubMenuPage> createState() => _SubMenuPageState();
}

class _SubMenuPageState extends State<SubMenuPage> {

  final SavedPrefrence savedPrefrence = SavedPrefrence();
  UserDataModel? _user;
  SplashDefaultModel? _splashDefaultData;
  InactivityTimerManager? inactivityTimerManager;


  @override
  void initState() {
    super.initState();
    _loadUser(); // load user data
  }

  Future<void> _loadUser() async {
    final userName = await savedPrefrence.getUserData();
    final splashDefaultData = await savedPrefrence.getSplashDefaultData();
    if (userName != null) {
      setState(() {
        _user = userName;
        _splashDefaultData = splashDefaultData!;
      });
      _loadSubMenuList();

      inactivityTimerManager = InactivityTimerManager(
        context: context,
        timeoutMinutes: _splashDefaultData!.activeLoginTime!,  // Set the desired inactivity time here
        onTimeout: _handleInactivityTimeout,  // Define what happens when timeout occurs
      );
      inactivityTimerManager?.startTimer();  // Start the inactivity timer

    }
  }

  Future<void> _handleInactivityTimeout() async {

    bool? activateORNot = await DialogUtils.showingActivateTimerDialog(context, _user!.userProfile!.userId!, _splashDefaultData!.companyCode!);
    print("CHECK_ACTIVATE_OR_NOT SUBMENU====== ${activateORNot}");
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

  @override
  void dispose() {
    inactivityTimerManager?.stopTimer(); // Stop the timer when the screen is disposed
    super.dispose();
  }


  void _resumeTimerOnInteraction() {
    inactivityTimerManager?.resetTimer();
    print('Activity detected, timer reset');
  }



  // load submenu list
  Future<void> _loadSubMenuList() async {
    // call submenu api from menu Id
    context.read<SubMenuCubit>().subMenuModelData(_user!.userProfile!.userIdentity!, _user!.userProfile!.userGroup!, widget.menuId, _splashDefaultData!.companyCode!);
  }


  @override
  Widget build(BuildContext context) {
    //culture wise data load from assets file
    AppLocalizations? localizations = AppLocalizations.of(context);
    SubMenuModelLang? subMenuModelLang = localizations!.submenuModel;
    LableModel? lableModel = localizations.lableModel;

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
        // Return value before popping the screen
        Navigator.pop(context, 'Done');
        return false; // Prevent default pop, as we are manually popping
      },
      child: Directionality(
        textDirection: uiDirection,
        child: GestureDetector(
          onTap: _resumeTimerOnInteraction,  // Resuming on any tap
          onPanDown: (details) => _resumeTimerOnInteraction(), // Resuming on any gesture
          child: Scaffold(
            backgroundColor: MyColor.colorWhite,
            body: SafeArea(child: Stack(
              children: [
                NotificationListener<ScrollNotification>(
                  onNotification: (ScrollNotification scroll) {
                    _resumeTimerOnInteraction(); // Reset the timer on scroll event
                    return true;
                  },
                  child: Column(
                    children: [
                      // header widget with name
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: HeaderWidget(
                          title: widget.menuName,
                          onBack: () {
                            Navigator.pop(context, "Done");
                          },
                          clearText: "",
                        ),
                      ),
                      CustomDivider(
                        space: 0,
                        color: Colors.black,
                        hascolor: true,
                      ),
                      const SizedBox(height: 5,),
                      Expanded(child: Container(
                        padding: EdgeInsets.symmetric(horizontal: SizeConfig.blockSizeHorizontal * SizeUtils.MAINPADDINGHORIZONTAL),
                        child: BlocConsumer<SubMenuCubit, SubMenuState>(
                          listener: (context, state) {
                            if(state is SubMenuStateLoading){
                              DialogUtils.showLoadingDialog(context, message: subMenuModelLang!.loading);
                            }else if(state is SubMenuStateSuccess){
                              DialogUtils.hideLoadingDialog(context);
                            }else if(state is SubMenuStateFailure){
                              DialogUtils.hideLoadingDialog(context);
                              SnackbarUtil.showSnackbar(context, state.error, MyColor.colorRed);
                            }
                          },
                          builder: (context, state) {
                            if(state is SubMenuStateSuccess){
                              // getting responce to submenu api call

                              return (state.subMenuModel.subMenuName!.isNotEmpty) ? GridView.builder(
                                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2, crossAxisSpacing: 5, childAspectRatio: 1.7),
                                itemCount: state.subMenuModel.subMenuName!.length,
                                physics:  const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemBuilder: (BuildContext context, int index) {
                                  SubMenuName subMenuName = state.subMenuModel.subMenuName![index];
                                  String subMenuTitle = "${subMenuModelLang!.getValueFromKey(CommonUtils.removeExtraIcons(subMenuName.refMenuCode!))}";



                                  return SubMenuWidget(title: subMenuTitle, imageUrl: CommonUtils.getImagePath(subMenuName.imageIcon!), onClick: () {
                                    String refrelCode = CommonUtils.removeExtraIcons("${subMenuName.refMenuCode}");
                                    int menuId = int.parse(subMenuName.menuId!);
                                    String isEnable = subMenuName.IsEnable!;
                                    if(menuId == SubMenuCodeUtils.ULDAcceptance){
                                      // navigate to next page using submenu refrelcode

                                      NextScreen(UldAcceptancePage(title: subMenuTitle, refrelCode: refrelCode, lableModel: lableModel, menuId: menuId, mainMenuName: widget.menuName,), isEnable);
                                     // NextScreen(DemoCodePage(title: subMenuTitle, refrelCode: refrelCode, lableModel: lableModel, menuId: menuId, mainMenuName: widget.menuName,), isEnable);
                                    } else if(menuId == SubMenuCodeUtils.FlightCheck){
                                      // navigate to next page using submenu refrelcode

                                      NextScreen(FlightCheck(title: subMenuTitle, refrelCode: refrelCode, lableModel: lableModel, menuId: menuId, mainMenuName: widget.menuName), isEnable);
                                    }else if(menuId == SubMenuCodeUtils.Segration){

                                      NextScreen(Container(), isEnable);
                                    }
                                  },);
                              },

                              ) : SizedBox();
                            }
                            return SizedBox();
                          },
                        ),
                      ))
                    ],
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  left: 0,
                  child: ClipPath(
                    clipper: ProsteThirdOrderBezierCurve(
                      position: ClipPosition.top,
                      list: [
                        ThirdOrderBezierCurveSection(
                          p2: Offset(SizeConfig.screenWidth, 50),
                          p1: Offset(SizeConfig.screenWidth, 100),
                          p3: const Offset(0, 100),
                          p4: const Offset(0, 0),
                        ),
                      ],
                    ),
                    child: Container(
                      decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.topRight,
                            colors: [
                              MyColor.primaryColorblue,
                              Colors.white,
                            ],
                          )),
                      height: 130,
                    ),
                  ),
                ),
              ],
            )),
            bottomNavigationBar: FooterCompanyName(),
          ),
        ),
      ),
    );
  }
  Future<void> NextScreen(Widget nextPageScreen, String isEnable) async {
    if(isEnable == "Y"){
      inactivityTimerManager?.stopTimer();

      var value = await Navigator.push(context, CupertinoPageRoute(builder: (context) => nextPageScreen,));
      if(value == "Done"){
        _resumeTimerOnInteraction();
      }
    }else{
      SnackbarUtil.showSnackbar(context, ValidationMessageCodeUtils.AuthorisedRolesAndRightsMsg, MyColor.colorRed, icon: FontAwesomeIcons.times);
      Vibration.vibrate(duration: 500);
    }

  }
}
