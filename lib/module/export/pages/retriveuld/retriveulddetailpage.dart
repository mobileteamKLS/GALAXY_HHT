import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:galaxy/core/mycolor.dart';
import 'package:galaxy/module/export/services/retriveuld/retriveuldlogic/retriveuldstate.dart';
import 'package:galaxy/utils/sizeutils.dart';
import 'package:galaxy/widget/custometext.dart';
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
import '../../../../widget/customedrawer/customedrawer.dart';
import '../../../../widget/header/mainheadingwidget.dart';
import '../../../login/pages/signinscreenmethods.dart';
import '../../../profile/page/profilepagescreen.dart';
import '../../../splash/model/splashdefaultmodel.dart';
import '../../../onboarding/sizeconfig.dart';
import 'dart:ui' as ui;

import '../../../login/model/userlogindatamodel.dart';
import '../../../submenu/model/submenumodel.dart';
import '../../model/retriveuld/retriveulddetailmodel.dart';
import '../../services/retriveuld/retriveuldlogic/retriveuldcubit.dart';

class RetriveULDDetailPage extends StatefulWidget {
  String mainMenuName;
  String title;
  String refrelCode;
  LableModel? lableModel;
  int menuId;
  List<SubMenuName> importSubMenuList = [];
  List<SubMenuName> exportSubMenuList = [];
  String uldType;


  RetriveULDDetailPage(
      {super.key,
      required this.importSubMenuList,
      required this.exportSubMenuList,
      required this.title,
      required this.refrelCode,
      this.lableModel,
      required this.menuId,
      required this.mainMenuName,
      required this.uldType});

  @override
  State<RetriveULDDetailPage> createState() => _RetriveULDDetailPagetate();
}

class _RetriveULDDetailPagetate extends State<RetriveULDDetailPage>
    with SingleTickerProviderStateMixin {





  InactivityTimerManager? inactivityTimerManager;
  final SavedPrefrence savedPrefrence = SavedPrefrence();
  UserDataModel? _user;
  SplashDefaultModel? _splashDefaultData;
  final ScrollController scrollController = ScrollController();

  late AnimationController _blinkController;
  late Animation<Color?> _colorAnimation;



  RetriveULDDetailLoadModel? retriveULDDetailLoadModel;

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


  }

  @override
  void dispose() {
    super.dispose();
    //all controller and focus node dispose
    inactivityTimerManager?.stopTimer(); // Stop the timer when the screen is disposed
    _blinkController.dispose();
    scrollController.dispose();

  }

  Future<void> _loadUser() async {
    final user = await savedPrefrence.getUserData();
    final splashDefaultData = await savedPrefrence.getSplashDefaultData();
    if (user != null && splashDefaultData != null) {
      setState(() {
        _user = user;
        _splashDefaultData = splashDefaultData;
      });

      //call api for list of uld from uldType
      getULDDetail(widget.uldType);

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
                                clearText: "",
                                //add clear text to clear all feild
                                onClear: () {

                                },
                              ),
                            ),

                            // start api responcer
                            BlocListener<RetriveULDCubit, RetriveULDState>(
                              listener: (context, state) {

                                if (state is RetriveULDInitialState) {
                                }
                                else if (state is RetriveULDLoadingState) {
                                  // showing loading dialog in this state
                                  DialogUtils.showLoadingDialog(context, message: lableModel!.loading);
                                }
                                else if (state is RetriveULDDetailSuccessState){
                                  DialogUtils.hideLoadingDialog(context);
                                  if(state.retriveULDDetailLoadModel.status == "E"){
                                    Vibration.vibrate(duration: 500);
                                    SnackbarUtil.showSnackbar(context, state.retriveULDDetailLoadModel.statusMessage!, MyColor.colorRed, icon: FontAwesomeIcons.times);
                                  }else{
                                    retriveULDDetailLoadModel = state.retriveULDDetailLoadModel;
                                    setState(() {});
                                  }
                                }
                                else if (state is RetriveULDDetailFailureState){
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
                                        /* child: Column(
                                           crossAxisAlignment: CrossAxisAlignment.start,
                                           children: [

                                             ListView.builder(
                                               itemCount: 5,
                                               physics: const NeverScrollableScrollPhysics(),
                                               shrinkWrap: true,
                                               controller: scrollController,
                                               itemBuilder: (context, index) {
                                                // AirsideReleaseDetailList airSideReleaseDetail = airsideReleaseDetailList[index];

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
                                                                   mainAxisAlignment: MainAxisAlignment.start,
                                                                   children: [
                                                                     Expanded(
                                                                         flex:4,
                                                                         child: CustomeText(text: "AKE 12345 AJ", fontColor: MyColor.colorBlack, fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_6, fontWeight: FontWeight.w600, textAlign: TextAlign.start)),
                                                                     Expanded(
                                                                       flex: 2,
                                                                       child: RoundedButtonBlue(text: "ADD",
                                                                         textSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                                                         verticalPadding: SizeConfig.blockSizeVertical * SizeUtils.BUTTONVERTICALSIZE /SizeUtils.HEIGHT2,
                                                                         press: () {
                                                                           _addItem("AKE 12345 AJ");
                                                                         },),
                                                                     )
                                                                   ],
                                                                 ),
                                                                 SizedBox(height: SizeConfig.blockSizeVertical * 0.8),
                                                                 Row(
                                                                   children: [
                                                                     CustomeText(
                                                                       text: "${lableModel.stacksize} : ",
                                                                       fontColor: MyColor.textColorGrey2,
                                                                       fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                                                       fontWeight: FontWeight.w400,
                                                                       textAlign: TextAlign.start,
                                                                     ),
                                                                     const SizedBox(width: 5),
                                                                     CustomeText(
                                                                       text: "5",
                                                                       fontColor: MyColor.colorBlack,
                                                                       fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                                                       fontWeight: FontWeight.w600,
                                                                       textAlign: TextAlign.start,
                                                                     ),
                                                                   ],
                                                                 ),
                                                                 SizedBox(height: SizeConfig.blockSizeVertical * 0.8),
                                                                 Row(
                                                                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                   children: [
                                                                     Row(
                                                                       children: [
                                                                         SvgPicture.asset(map, height: SizeConfig.blockSizeVertical * SizeUtils.ICONSIZE2,),
                                                                         SizedBox(width: SizeConfig.blockSizeHorizontal,),
                                                                         CustomeText(
                                                                           text: "E001",
                                                                           fontColor: MyColor.colorBlack,
                                                                           fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_6,
                                                                           fontWeight: FontWeight.w600,
                                                                           textAlign: TextAlign.start,
                                                                         ),
                                                                       ],
                                                                     ),
                                                                     Container(
                                                                       padding : EdgeInsets.symmetric(horizontal: SizeConfig.blockSizeHorizontal * 2.0, vertical: SizeConfig.blockSizeVertical * 0.2),
                                                                       decoration : BoxDecoration(
                                                                           borderRadius: BorderRadius.circular(20),
                                                                           color:  MyColor.flightFinalize
                                                                       ),
                                                                       child: CustomeText(
                                                                         text: "${lableModel.open}",
                                                                         fontColor: MyColor.textColorGrey3,
                                                                         fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_6,
                                                                         fontWeight: FontWeight.bold,
                                                                         textAlign: TextAlign.center,
                                                                       ),
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


                                           ],
                                         ),*/
                                           child: Column(
                                             crossAxisAlignment: CrossAxisAlignment.start,
                                             children: [

                                               (retriveULDDetailLoadModel != null)
                                                   ? (retriveULDDetailLoadModel!.uLDDetailList!.isNotEmpty)
                                                   ? ListView.builder(
                                                 itemCount: retriveULDDetailLoadModel!.uLDDetailList!.length,
                                                 physics: const NeverScrollableScrollPhysics(),
                                                 shrinkWrap: true,
                                                 controller: scrollController,
                                                 itemBuilder: (context, index) {
                                                    ULDDetailList uldDetails = retriveULDDetailLoadModel!.uLDDetailList![index];

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
                                                                     mainAxisAlignment: MainAxisAlignment.start,
                                                                     children: [
                                                                       Expanded(
                                                                           flex:4,
                                                                           child: Row(
                                                                             children: [
                                                                               CustomeText(text: "${uldDetails.uLDNo}", fontColor: MyColor.colorBlack, fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_6, fontWeight: FontWeight.w600, textAlign: TextAlign.start),
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
                                                                           )),
                                                                       Expanded(
                                                                         flex: 2,
                                                                         child: RoundedButtonBlue(text: "ADD",
                                                                           textSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                                                           verticalPadding: SizeConfig.blockSizeVertical * SizeUtils.BUTTONVERTICALSIZE /SizeUtils.HEIGHT2,
                                                                           press: () {
                                                                             _addItem(uldDetails);
                                                                           },),
                                                                       )
                                                                     ],
                                                                   ),
                                                                   SizedBox(height: SizeConfig.blockSizeVertical * 0.8),
                                                                   Row(
                                                                     children: [
                                                                       CustomeText(
                                                                         text: "${lableModel!.stacksize} : ",
                                                                         fontColor: MyColor.textColorGrey2,
                                                                         fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                                                         fontWeight: FontWeight.w400,
                                                                         textAlign: TextAlign.start,
                                                                       ),
                                                                       const SizedBox(width: 5),
                                                                       CustomeText(
                                                                         text: "${uldDetails.stackSize}",
                                                                         fontColor: MyColor.colorBlack,
                                                                         fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                                                         fontWeight: FontWeight.w600,
                                                                         textAlign: TextAlign.start,
                                                                       ),
                                                                     ],
                                                                   ),
                                                                   SizedBox(height: SizeConfig.blockSizeVertical * 0.8),
                                                                   Row(
                                                                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                     children: [
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
                                                                       ),
                                                                       Container(
                                                                         padding : EdgeInsets.symmetric(horizontal: SizeConfig.blockSizeHorizontal * 2.0, vertical: SizeConfig.blockSizeVertical * 0.2),
                                                                         decoration : BoxDecoration(
                                                                             borderRadius: BorderRadius.circular(20),
                                                                             color: (uldDetails.uLDStatus == "O") ? MyColor.flightFinalize : MyColor.flightNotArrived
                                                                         ),
                                                                         child: CustomeText(
                                                                           text:  (uldDetails.uLDStatus == "O") ? "${lableModel.open}" : "${lableModel.closed}",
                                                                           fontColor: MyColor.textColorGrey3,
                                                                           fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_6,
                                                                           fontWeight: FontWeight.bold,
                                                                           textAlign: TextAlign.center,
                                                                         ),
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
                                                       text: "${lableModel!.recordNotFound}",
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
                                                       text: "${lableModel!.recordNotFound}",
                                                       // if record not found
                                                       fontColor: MyColor.textColorGrey,
                                                       fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_2_0,
                                                       fontWeight: FontWeight.w500,
                                                       textAlign: TextAlign.center),
                                                 ),
                                               )


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

  void _addItem(ULDDetailList item) {
    // Check if any item in the list has the same ULDNo
    bool isAlreadyAdded = CommonUtils.SELECTEDULDFORRETRIVE.any((selectedItem) => selectedItem.uLDNo == item.uLDNo);

    if (isAlreadyAdded) {
      // Show warning message if the item is already in the list
      SnackbarUtil.showSnackbar(
        context,
        "ULDNo ${item.uLDNo} is already added.",
        MyColor.colorRed,
        icon: FontAwesomeIcons.times,
      );
      Vibration.vibrate(duration: 500); // Vibrate for warning
    } else {
      // Add item to the list
      setState(() {
        CommonUtils.SELECTEDULDFORRETRIVE.add(item);
      });

      SnackbarUtil.showSnackbar(
        context,
        "ULDNo ${item.uLDNo} added successfully.",
        MyColor.colorGreen,
        icon: Icons.done,
      );
    }
  }


  void getULDDetail(String uldType) {
    context.read<RetriveULDCubit>().getULDDetailLoad(uldType, _user!.userProfile!.userIdentity!, _splashDefaultData!.companyCode!, widget.menuId,);
  }

}




// ticker animation for DGR code blink animation
class TickerProviders extends TickerProvider {
  @override
  Ticker createTicker(onTick) => Ticker(onTick);
}
