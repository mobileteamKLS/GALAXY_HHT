import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:galaxy/core/mycolor.dart';
import 'package:galaxy/utils/sizeutils.dart';
import '../../../../../../widget/customeuiwidgets/header.dart';
import '../../../../core/images.dart';
import '../../../../language/appLocalizations.dart';
import '../../../../language/model/lableModel.dart';
import '../../../../manager/timermanager.dart';
import '../../../../prefrence/savedprefrence.dart';
import '../../../../utils/commonutils.dart';
import '../../../../utils/dialogutils.dart';
import '../../../../widget/customebuttons/roundbuttonblue.dart';
import '../../../../widget/customeedittext/customeedittextwithborder.dart';
import '../../../../widget/custometext.dart';
import '../../../../widget/customtextfield.dart';
import '../../../../widget/header/mainheadingwidget.dart';
import '../../../login/pages/signinscreenmethods.dart';
import '../../../splash/model/splashdefaultmodel.dart';
import '../../../onboarding/sizeconfig.dart';
import 'dart:ui' as ui;

import '../../../login/model/userlogindatamodel.dart';
import '../../services/binning/binninglogic/binningcubit.dart';
import '../../services/binning/binninglogic/binningstate.dart';

class Binning extends StatefulWidget {
  String mainMenuName;
  String title;
  String refrelCode;
  LableModel? lableModel;
  int menuId;

  Binning(
      {super.key,
      required this.title,
      required this.refrelCode,
      this.lableModel,
      required this.menuId,
      required this.mainMenuName});

  @override
  State<Binning> createState() => _BinningState();
}

class _BinningState extends State<Binning> {
  int groupIDCharSize = 14;

  InactivityTimerManager? inactivityTimerManager;
  final SavedPrefrence savedPrefrence = SavedPrefrence();
  UserDataModel? _user;
  SplashDefaultModel? _splashDefaultData;
  final ScrollController scrollController = ScrollController();

  TextEditingController groupIdController = TextEditingController();
  TextEditingController locationController = TextEditingController();

  FocusNode locationFocusNode = FocusNode();
  FocusNode groupIdFocusNode = FocusNode();

  bool _isvalidateLocation = false;

  @override
  void initState() {
    super.initState();
    _loadUser(); //load user data
  }

  @override
  void dispose() {
    super.dispose();
    //all controller and focus node dispose
    inactivityTimerManager
        ?.stopTimer(); // Stop the timer when the screen is disposed
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
      timeoutMinutes: _splashDefaultData!.activeLoginTime!,
      // Set the desired inactivity time here
      onTimeout:
          _handleInactivityTimeout, // Define what happens when timeout occurs
    );
    inactivityTimerManager?.startTimer();
  }

  Future<void> _handleInactivityTimeout() async {
    bool? activateORNot = await DialogUtils.showingActivateTimerDialog(
        context, _user!.userProfile!.userId!, _splashDefaultData!.companyCode!);
    if (activateORNot == true) {
      inactivityTimerManager!.resetTimer();
    } else {
      _logoutUser();
    }
  }

  Future<void> _logoutUser() async {
    await savedPrefrence.logout();
    Navigator.pushAndRemoveUntil(
      context,
      CupertinoPageRoute(
        builder: (context) => const SignInScreenMethod(),
      ),
      (route) => false,
    );
  }

  void _resumeTimerOnInteraction() {
    inactivityTimerManager?.resetTimer();
    print('Activity detected, timer reset');
  }

  Future<bool> _onWillPop() async {
    FocusScope.of(context).unfocus();
    Navigator.pop(context);
    inactivityTimerManager?.stopTimer();
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
        onTap: _resumeTimerOnInteraction,
        // Resuming on any tap
        onPanDown: (details) => _resumeTimerOnInteraction(),
        // Resuming on any gesture
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
                                    SizeConfig.blockSizeVertical *
                                        SizeUtils.WIDTH2),
                                topLeft: Radius.circular(
                                    SizeConfig.blockSizeVertical *
                                        SizeUtils.WIDTH2))),
                        child: Column(
                          children: [
                            // header of title and clear function
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 10, right: 15, top: 12, bottom: 12),
                              child: HeaderWidget(
                                titleTextColor: MyColor.colorBlack,
                                title: widget.title,
                                onBack: () {
                                  _onWillPop();
                                },
                                clearText: lableModel!.clear,
                                //add clear text to clear all feild
                                onClear: () {},
                              ),
                            ),

                            // start api responcer
                            BlocListener<BinningCubit, BinningState>(
                              listener: (context, state) {
                                if (state is MainInitialState) {
                                } else if (state is MainLoadingState) {
                                  // showing loading dialog in this state
                                  DialogUtils.showLoadingDialog(context,
                                      message: lableModel.loading);
                                }
                              },
                              child: Expanded(
                                child: SingleChildScrollView(
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 10, right: 10, top: 0, bottom: 0),
                                    child: Column(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                            color: MyColor.colorWhite,
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            boxShadow: [
                                              BoxShadow(
                                                color: MyColor.colorBlack
                                                    .withOpacity(0.09),
                                                spreadRadius: 2,
                                                blurRadius: 15,
                                                offset: Offset(0,
                                                    3), // changes position of shadow
                                              ),
                                            ],
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Directionality(
                                                textDirection: uiDirection,
                                                child: Row(
                                                  children: [
                                                    SvgPicture.asset(
                                                      info,
                                                      height: SizeConfig
                                                              .blockSizeVertical *
                                                          SizeUtils.ICONSIZE2,
                                                    ),
                                                    SizedBox(
                                                      width: SizeConfig
                                                          .blockSizeHorizontal,
                                                    ),
                                                    CustomeText(
                                                        text:
                                                            "Details for binning",
                                                        fontColor: MyColor
                                                            .textColorGrey2,
                                                        fontSize: SizeConfig
                                                                .textMultiplier *
                                                            SizeUtils
                                                                .TEXTSIZE_1_5,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        textAlign:
                                                            TextAlign.start)
                                                  ],
                                                ),
                                              ),
                                              SizedBox(
                                                  height: SizeConfig.blockSizeVertical * SizeUtils.HEIGHT2),
                                              // text manifest and recived in pices text counter
                                              Directionality(
                                                textDirection: uiDirection,
                                                child: CustomTextField(
                                                  controller: groupIdController,
                                                  focusNode: groupIdFocusNode,
                                                  onPress: () {},
                                                  hasIcon: false,
                                                  hastextcolor: true,
                                                  animatedLabel: true,
                                                  needOutlineBorder: true,
                                                  labelText: "${lableModel.groupId} *",
                                                  readOnly: false,
                                                  maxLength: 14,
                                                  onChanged: (value) {},
                                                  fillColor: Colors.grey.shade100,
                                                  textInputType: TextInputType.text,
                                                  inputAction: TextInputAction.next,
                                                  hintTextcolor: Colors.black45,
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
                                              SizedBox(height: SizeConfig.blockSizeVertical * SizeUtils.HEIGHT2),
                                              IntrinsicHeight(
                                                child: Row(
                                                  children: [
                                                    Expanded(
                                                      flex:1,
                                                      child: Column(
                                                        children: [
                                                          CustomeEditTextWithBorder(
                                                            lablekey: "LOCATION",
                                                            textDirection: textDirection,
                                                            controller: locationController,
                                                            focusNode: locationFocusNode,
                                                            hasIcon: false,
                                                            hastextcolor: true,
                                                            animatedLabel: true,
                                                            needOutlineBorder: true,
                                                            labelText: "${lableModel.location} *",
                                                            readOnly: false,
                                                            maxLength: 15,
                                                            isShowSuffixIcon: _isvalidateLocation,
                                                            onChanged: (value, validate) {
                                                              setState(() {
                                                                _isvalidateLocation = value.isEmpty;
                                                              });
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
                                                          SizedBox(height:  SizeConfig.blockSizeVertical,),
                                                          RoundedButtonBlue(
                                                            text: "${lableModel.cancel}",
                                                            press: () async {
                                                              // Add your cancel action here
                                                            },
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    SizedBox(width: SizeConfig.blockSizeHorizontal * SizeUtils.WIDTH2,),
                                                    Expanded(
                                                      flex:1,
                                                      child: Container(
                                                        height: double.infinity,
                                                        child: RoundedButtonBlue(
                                                          text: "Move",
                                                          press: () async {
                                                            // Add your cancel action here
                                                          },
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),



                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
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
}
