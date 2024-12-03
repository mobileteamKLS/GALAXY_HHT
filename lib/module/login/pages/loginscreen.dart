import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:galaxy/core/images.dart';
import 'package:galaxy/core/mycolor.dart';
import 'package:galaxy/language/appLocalizations.dart';
import 'package:galaxy/language/model/loginModel.dart';
import 'package:galaxy/language/validationmessageservice/validationmessagelogic/validationmsgcubit.dart';
import 'package:galaxy/language/validationmessageservice/validationmessagelogic/validationmsgstate.dart';
import 'package:galaxy/main.dart';
import 'package:galaxy/module/splash/model/splashdefaultmodel.dart';
import 'package:galaxy/module/dashboard/page/dashboardscreen.dart';
import 'package:galaxy/module/onboarding/sizeconfig.dart';
import 'package:galaxy/module/login/services/loginlogic/logincubit.dart';
import 'package:galaxy/module/login/services/loginlogic/loginstate.dart';
import 'package:galaxy/utils/commonutils.dart';
import 'package:galaxy/utils/dialogutils.dart';
import 'package:galaxy/utils/snackbarutil.dart';
import 'package:galaxy/widget/customebuttons/roundbuttonblue.dart';
import 'package:galaxy/widget/custometext.dart';
import 'package:galaxy/widget/custometextwoborder.dart';
import 'package:galaxy/widget/customeuiwidgets/companynameversion.dart';
import 'package:galaxy/widget/customunderlinetext.dart';
import 'package:galaxy/widget/design/useridcustometextwoborder.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vibration/vibration.dart';
import '../../../../widget/roundbutton.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:ui' as ui;

import '../../../Ipad/screen/IpadDashBoard.dart';
import '../../../Ipad/screen/warehouseoperations.dart';
import '../../../prefrence/savedprefrence.dart';
import '../../../utils/sizeutils.dart';
import '../../../utils/validationmsgcodeutils.dart';
import '../../../widget/customebuttons/roundbuttonbluegradient.dart';
import '../../../widget/customeedittext/useridcustomeedittext.dart';

class LogInScreen extends StatefulWidget {

  final bool isMPinEnable;
  final String authFlag;

  const LogInScreen({super.key, required this.isMPinEnable, required this.authFlag});

  @override
  State<LogInScreen> createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  final formKey = GlobalKey<FormState>();
  TextEditingController userIdController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  String authFlg = 'P';
  final SavedPrefrence savedPrefrence = SavedPrefrence();
  String? _userIdError;
  String? _passwordMpinError;
  SplashDefaultModel? _splashDefaultData;
  FocusNode userIdFocusNode = FocusNode();
  FocusNode passwordFocusNode = FocusNode();
  bool isMobile=false;

  @override
  void initState() {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: MyColor.bggradientfirst, // Set the color you want here.
      statusBarIconBrightness:
          Brightness.light, // Use Brightness.dark for dark icons.
    ));



    _loadCompanyData(); // load company data saved in shared pref.


    userIdController.addListener(() {
      setState(() {
        _userIdError = null;
      });
    });

    passwordController.addListener(() {
      setState(() {
        _passwordMpinError = null;
      });
    });


  }



  // load company data
  Future<void> _loadCompanyData() async {
    final splashDefaultData = await savedPrefrence.getSplashDefaultData();
    setState(() {
      _splashDefaultData = splashDefaultData!;
    });
    WidgetsBinding.instance.addPostFrameCallback(
          (_) {
        FocusScope.of(context).requestFocus(userIdFocusNode);
      },
    );
  }
  void getDeviceType() {
    final data = MediaQueryData.fromView(WidgetsBinding.instance!.window);
    if (data.size.shortestSide < 600) {
      setState(() {
        isMobile = true;
      });
    }

    // return data.size.shortestSide < 600 ? DeviceType.Phone : DeviceType.Tablet;
  }




  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    //culture wise data load from assets file
    AppLocalizations? localizations = AppLocalizations.of(context);
    LoginModel? loginModel = localizations!.loginModel;

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
          resizeToAvoidBottomInset: false,
          body: Stack(
            children: [
              Column(
                children: [
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [
                            MyColor.bggradientfirst, // #0060E5 color
                            MyColor.bggradientsecond, // #1D86FF color
                          ],
                          stops: [
                            0.0,
                            1.0
                          ], // Specifies the start and end of the gradient
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: SizeConfig.blockSizeHorizontal * SizeUtils.MAINPADDINGHORIZONTAL,
                          vertical: 20
                        ),
                        child: Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: "${loginModel!.headingMessage1} \n",
                                style: GoogleFonts.roboto(
                                  textStyle: TextStyle(
                                    letterSpacing: 1.1,
                                    fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_2_5,
                                    color: MyColor.colorWhite,
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                              ),
                              TextSpan(
                                text: "${loginModel.headingMessage2}",
                                style: GoogleFonts.roboto(
                                  textStyle: TextStyle(
                                    letterSpacing: 1.1,
                                    fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_2_5,
                                    color: MyColor.colorWhite,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          textAlign: TextAlign.start,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Positioned(
                bottom: 10,
                right: 10,
                left: 10,
                child: SingleChildScrollView(
                  child: Card(
                    color: MyColor.colorWhite,
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(SizeConfig.blockSizeHorizontal * SizeUtils.BORDERRADIOUS_6), // Set the corner radius
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 25),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              // InkWell(
                              //   onTap: () {
                              //     Navigator.pop(context);
                              //   },
                              //   child: SvgPicture.asset(back, height: SizeConfig.blockSizeVertical * SizeUtils.ICONSIZE3)
                              // ),
                              SizedBox(width: SizeConfig.blockSizeHorizontal * SizeUtils.WIDTH3,),
                              CustomeText(
                                  text: "${loginModel.login}",
                                  fontColor: MyColor.colorBlack,
                                  fontSize: 24,
                                  fontWeight: FontWeight.w600,
                                  textAlign: TextAlign.start),
                            ],
                          ),
                          BlocConsumer<LoginCubit, LoginState>(
                            listener: (context, state) async {
                              if (state is LoginSuccess) {
                                // navigate to next screen when login success


                  
                              } else if (state is LoginFailure) {
                                Vibration.vibrate(duration: 500);
                                SnackbarUtil.showSnackbar(context, state.error, MyColor.colorRed, icon: Icons.cancel);
                              }
                            },
                            builder: (context, state) {
                              return Form(
                                  key: formKey,
                                  child: Column(
                                    children: [
                                      SizedBox(height: SizeConfig.blockSizeVertical),
                                      Directionality(
                                        textDirection: textDirection,
                                        child: UserIdCustomeEditText(
                                          textDirection: textDirection,
                                          cursorColor: MyColor.colorBlack,
                                          fontColor: MyColor.colorBlack,
                                          controller: userIdController,
                                          onChanged: (value) {},
                                          focusNode: userIdFocusNode,
                                          nextFocus: passwordFocusNode,
                                          hintText: "${loginModel.userId}",
                                          maxLength: 20,
                                          isShowSuffixIcon: true,
                                          isPassword: false,
                                          hasIcon: true,
                                          isIcon: true,
                                          prefixicon: user,
                                          textInputType: TextInputType.text,
                                          inputAction: TextInputAction.next,
                                          fillColor: MyColor.colorWhite,
                                          verticalPadding: SizeConfig.blockSizeVertical,
                                          fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_2_0,
                                          iconSize: SizeConfig.blockSizeVertical * SizeUtils.ICONSIZE3,
                                          errorText: _userIdError,
                                        ),
                                      ),
                                      SizedBox(height: SizeConfig.blockSizeVertical),
                                      Directionality(
                                        textDirection: textDirection,
                                        child: CustomeTextWOBorder(
                                          textDirection: textDirection,
                                          cursorColor: MyColor.colorBlack,
                                          fontColor: MyColor.colorBlack,
                                          controller: passwordController,
                                          focusNode: passwordFocusNode,
                                          onChanged: (value) {},
                                          hintText: widget.isMPinEnable
                                              ? "${loginModel.mPin}"
                                              : "${loginModel.password}",
                                          isShowSuffixIcon: true,
                                          isPassword: true,
                                          // Show as password if MPIN is not enabled
                                          hasIcon: true,
                                          prefixicon: Icons.lock_outline_rounded,
                                          textInputType: widget.isMPinEnable ? TextInputType.number : TextInputType.text,
                                          // Change keyboard type dynamically
                                          inputAction: TextInputAction.next,
                                          fillColor: MyColor.colorWhite,
                                          verticalPadding: SizeConfig.blockSizeVertical,
                                          fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_2_0,
                                          iconSize: SizeConfig.blockSizeVertical * SizeUtils.ICONSIZE3,
                                          maxLength: widget.isMPinEnable ? 10 : 24,
                                          prefixIconcolor: MyColor.colorGrey,
                                          hintTextcolor: MyColor.colorGrey,
                                          errorText: _passwordMpinError,
                                          digitsOnly: widget.isMPinEnable ? true : false,
                                        ),
                                      ),
                                      SizedBox(height: SizeConfig.blockSizeVertical),
                                      // Directionality(
                                      //   textDirection: textDirection,
                                      //   child: Row(
                                      //     mainAxisAlignment: MainAxisAlignment.end,
                                      //     children: [
                                      //       CustomeText(text: "${loginModel.recoverForgotPassword}", fontColor: MyColor.bggradientfirst, fontSize: SizeConfig.textMultiplier * SizeUtils.MEDIUMTEXTSIZE, fontWeight: FontWeight.w400, textAlign: TextAlign.right),
                                      //     ],
                                      //   ),
                                      // ),
                                      SizedBox(height: SizeConfig.blockSizeVertical * SizeUtils.HEIGHT2),
                                      RoundedButtonBlueGradient(text: (state is LoginLoading)
                                          ? '${loginModel.loading}'
                                          : loginModel.login!.toUpperCase(), isborderButton: false, textDirection: textDirection ,press: () {

                                        bool isValid = true;

                                        if (userIdController.text.trim().isEmpty) {
                                          setState(() {
                                            _userIdError = ValidationMessageCodeUtils.validatorUserId;
                                          });
                                          isValid = false;
                                        }


                                        if (passwordController.text.isEmpty || (widget.isMPinEnable && (passwordController.text.length < 6 || passwordController.text.length > 10))) {
                                          setState(() {
                                            if (passwordController.text.isEmpty) {_passwordMpinError = widget.isMPinEnable
                                                  ? ValidationMessageCodeUtils.validatorMpin
                                                  : ValidationMessageCodeUtils.validatorPassword;
                                            } else if (widget.isMPinEnable && (passwordController.text.length < 6 || passwordController.text.length > 10)) {
                                              _passwordMpinError = loginModel.validationBoundry;
                                            }
                                          });
                                          isValid = false;
                                        }

                                        if (isValid) {
                                          // call login api pass parameter
                                          // context.read<LoginCubit>().login(
                                          //     userIdController.text.trim(),
                                          //     passwordController.text,
                                          //     widget.authFlag,
                                          //     3);
                                          Navigator.pushAndRemoveUntil(
                                            context,
                                            CupertinoPageRoute(
                                              builder: (context) =>isMobile?DashboardScreen(): WarehouseOperations(),
                                            ),
                                                (route) => false,
                                          );
                                        } else {}

                                      },),

                                      SizedBox(height: SizeConfig.blockSizeVertical * SizeUtils.HEIGHT3),
                                      Directionality(
                                        textDirection: textDirection,
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Text.rich(
                                              TextSpan(
                                                children: [
                                                  TextSpan(
                                                    text: "${loginModel.readThe} ",
                                                    // Example for first part of text (e.g., "BAY")
                                                    style: GoogleFonts.roboto(
                                                      textStyle: TextStyle(
                                                        letterSpacing: 0.5,
                                                        fontSize: SizeConfig.textMultiplier * SizeUtils.MEDIUMTEXTSIZE,
                                                        // Smaller size for "BAY"
                                                        color: MyColor.textColorGrey2,
                                                        fontWeight: FontWeight.w400,
                                                      ),
                                                    ),
                                                  ),
                                                  TextSpan(
                                                    text: "${loginModel.privacyPolicy} ",
                                                    // Example for last part of text (e.g., "AJ")
                                                    style: GoogleFonts.roboto(
                                                      textStyle: TextStyle(
                                                        letterSpacing: 0.5,
                                                        fontSize: SizeConfig.textMultiplier * SizeUtils.MEDIUMTEXTSIZE,
                                                        // Smaller size for "AJ"
                                                        color: MyColor.bggradientfirst,
                                                        fontWeight: FontWeight.w500,
                                                      ),
                                                    ),
                                                  ),
                                                  TextSpan(
                                                    text: "${loginModel.and} ",
                                                    // Example for last part of text (e.g., "AJ")
                                                    style: GoogleFonts.roboto(
                                                      textStyle: TextStyle(
                                                        letterSpacing: 0.5,
                                                        fontSize: SizeConfig.textMultiplier * SizeUtils.MEDIUMTEXTSIZE,
                                                        // Smaller size for "AJ"
                                                        color: MyColor.textColorGrey2,
                                                        fontWeight: FontWeight.w400,
                                                      ),
                                                    ),
                                                  ),
                                                  TextSpan(
                                                    text: "${loginModel.termsOfUse}",
                                                    // Example for last part of text (e.g., "AJ")
                                                    style: GoogleFonts.roboto(
                                                      textStyle: TextStyle(
                                                        letterSpacing: 0.5,
                                                        fontSize: SizeConfig.textMultiplier * SizeUtils.MEDIUMTEXTSIZE,
                                                        // Smaller size for "AJ"
                                                        color: MyColor.bggradientfirst,
                                                        fontWeight: FontWeight.w500,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              textAlign: TextAlign.start,
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(height: SizeConfig.blockSizeVertical * SizeUtils.HEIGHT3),
                                      Image.asset(kaleLogisticsLogo, height: SizeConfig.blockSizeVertical * 12,),
                                      SizedBox(height: SizeConfig.blockSizeVertical * SizeUtils.HEIGHT3),
                                      CustomeText(text: "App Version ${_splashDefaultData!.appVersion}", fontColor: MyColor.textColorGrey2, fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_3, fontWeight: FontWeight.w400, textAlign: TextAlign.right),
                                    ],
                                  ));
                            },
                          )
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
    );
  }
}
