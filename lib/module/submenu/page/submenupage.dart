import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:galaxy/language/appLocalizations.dart';
import 'package:galaxy/language/model/lableModel.dart';
import 'package:galaxy/language/model/subMenuModel.dart';
import 'package:galaxy/module/profile/page/profilepagescreen.dart';
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
import '../../../widget/customedrawer/customedrawer.dart';
import '../../../widget/customeuiwidgets/footer.dart';
import '../../../widget/design/index.dart';
import '../../../widget/design/prostebeziercurve.dart';
import '../../../widget/header/mainheadingwidget.dart';
import '../../dashboard/model/menumodel.dart';
import '../../import/pages/binning/binning.dart';
import '../../import/pages/flightcheck/flightcheck.dart';
import '../../import/pages/shipmentdamage/shipmentdamagepages.dart';
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
  List<SubMenuName> importSubMenuList = [];
  List<SubMenuName> exportSubMenuList = [];

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
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

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
                importSubMenuList: importSubMenuList,
                exportSubMenuList: exportSubMenuList,
                user: _user!,
                splashDefaultData: _splashDefaultData!,
                onDrawerCloseIcon: () {
                  _scaffoldKey.currentState?.closeDrawer();
                },) : null, // Add custom drawer widget here
              body: Stack(
                children: [
                  MainHeadingWidget(mainMenuName: "${subMenuModelLang!.submenu}",
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
                              child: HeaderWidget(
                                titleTextColor: MyColor.colorBlack,
                                title: widget.menuName,
                                onBack: () {
                                  Navigator.pop(context, 'Done');

                                },
                                clearText: "",
                                //add clear text to clear all feild
                                onClear: () {

                                },
                              ),
                            ),

                            Expanded(child: Container(
                              padding: EdgeInsets.symmetric(horizontal: SizeConfig.blockSizeHorizontal * SizeUtils.MAINPADDINGVERTICAL),
                              child: BlocConsumer<SubMenuCubit, SubMenuState>(
                                listener: (context, state) {
                                  if(state is SubMenuStateLoading){
                                    DialogUtils.showLoadingDialog(context, message: subMenuModelLang!.loading);
                                  }else if(state is SubMenuStateSuccess){
                                    if(widget.menuId == "1001"){
                                      importSubMenuList =  state.subMenuModel.subMenuName!;
                                    }else if(widget.menuId == "1002"){
                                      exportSubMenuList =  state.subMenuModel.subMenuName!;
                                    }

                                    setState(() {

                                    });
                                    DialogUtils.hideLoadingDialog(context);
                                  }else if(state is SubMenuStateFailure){
                                    DialogUtils.hideLoadingDialog(context);
                                    SnackbarUtil.showSnackbar(context, state.error, MyColor.colorRed);
                                  }
                                },
                                builder: (context, state) {
                                  if(state is SubMenuStateSuccess){
                                    // getting responce to submenu api call


                                  //  state.subMenuModel.subMenuName!.add(SubMenuName(menuId: "1281", menuName: "Shipment Damage", sNo: 3325, imageIcon: "damage", refMenuCode: "§§HHT007§§", IsEnable: "Y"));

                                    return (state.subMenuModel.subMenuName!.isNotEmpty)
                                        ? GridView.builder(
                                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 2, crossAxisSpacing: 5, mainAxisSpacing: 5, childAspectRatio: 1.1),
                                      itemCount: state.subMenuModel.subMenuName!.where((menu) => menu.menuName != "Shipment Creation").length,
                                      physics:  const NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      itemBuilder: (BuildContext context, int index) {

                                        List<SubMenuName> filteredSubMenuList = state.subMenuModel.subMenuName!
                                            .where((menu) => menu.menuName != "Shipment Creation")
                                            .toList();

                                        SubMenuName subMenuName = filteredSubMenuList[index];

                                        String subMenuTitle = (localizations.locale.languageCode == "en") ? subMenuName.menuName! : "${subMenuModelLang!.getValueFromKey(CommonUtils.removeExtraIcons(subMenuName.refMenuCode!))}";

                                        return SubMenuWidget(title: subMenuTitle,
                                          imageUrl: (subMenuName.imageIcon!.isNotEmpty) ? CommonUtils.getSVGImagePath(subMenuName.imageIcon!) : "",
                                          bgColor: MyColor.subMenuColorList[index % MyColor.subMenuColorList.length],
                                          onClick: () {
                                            String refrelCode = CommonUtils.removeExtraIcons("${subMenuName.refMenuCode}");
                                            int menuId = int.parse(subMenuName.menuId!);
                                            String isEnable = subMenuName.IsEnable!;
                                            if(menuId == SubMenuCodeUtils.ULDAcceptance){
                                              // navigate to next page using submenu refrelcode

                                              NextScreen(UldAcceptancePage(
                                                importSubMenuList: importSubMenuList,
                                                exportSubMenuList: exportSubMenuList,
                                                title: subMenuTitle,
                                                refrelCode: refrelCode,
                                                lableModel: lableModel,
                                                menuId: menuId,
                                                mainMenuName: widget.menuName,), isEnable);
                                              // NextScreen(DemoCodePage(title: subMenuTitle, refrelCode: refrelCode, lableModel: lableModel, menuId: menuId, mainMenuName: widget.menuName,), isEnable);
                                            } else if(menuId == SubMenuCodeUtils.FlightCheck){
                                              // navigate to next page using submenu refrelcode

                                              NextScreen(FlightCheck(
                                                  importSubMenuList: importSubMenuList,
                                                  exportSubMenuList: exportSubMenuList,
                                                  title: subMenuTitle,
                                                  refrelCode: refrelCode,
                                                  lableModel: lableModel,
                                                  menuId: menuId,
                                                  mainMenuName: widget.menuName), isEnable);
                                            }else if(menuId == SubMenuCodeUtils.Binning){
                                              NextScreen(Binning(
                                                  importSubMenuList: importSubMenuList,
                                                  exportSubMenuList: exportSubMenuList,
                                                  title: subMenuTitle,
                                                  refrelCode: refrelCode,
                                                  lableModel: lableModel,
                                                  menuId: menuId,
                                                  mainMenuName: widget.menuName), "Y");
                                            }else if(menuId == SubMenuCodeUtils.shipmentCreation){

                                              NextScreen(Container(), isEnable);
                                            }else if(menuId == SubMenuCodeUtils.ShipmentDamage){
                                              NextScreen(ShipmentDamagePages(
                                                  importSubMenuList: importSubMenuList,
                                                  exportSubMenuList: exportSubMenuList,
                                                  title: subMenuTitle,
                                                  refrelCode: refrelCode,
                                                  lableModel: lableModel,
                                                  menuId: menuId,
                                                  mainMenuName: widget.menuName), "Y");
                                            }
                                          },);
                                      },

                                    )
                                        : SizedBox();
                                  }
                                  return SizedBox();
                                },
                              ),
                            ))

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
