
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:galaxy/core/images.dart';
import 'package:galaxy/core/mycolor.dart';
import 'package:galaxy/language/appLocalizations.dart';
import 'package:galaxy/language/model/loginModel.dart';
import 'package:galaxy/language/validationmessageservice/validationmessagelogic/validationmsgcubit.dart';
import 'package:galaxy/language/validationmessageservice/validationmessagelogic/validationmsgstate.dart';
import 'package:galaxy/main.dart';
import 'package:galaxy/module/login/pages/loginscreen.dart';
import 'package:galaxy/module/splash/model/splashdefaultmodel.dart';
import 'package:galaxy/module/onboarding/sizeconfig.dart';
import 'package:galaxy/utils/commonutils.dart';
import 'package:galaxy/utils/dialogutils.dart';
import 'package:galaxy/utils/snackbarutil.dart';
import 'package:galaxy/widget/customebuttons/roundbuttonblue.dart';
import 'package:galaxy/widget/custometext.dart';
import 'package:galaxy/widget/customeuiwidgets/footer.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:ui' as ui;

import '../../../prefrence/savedprefrence.dart';
import '../../../utils/sizeutils.dart';
import '../../../utils/validationmsgcodeutils.dart';
import '../../../widget/customebuttons/roundbuttonbluegradient.dart';

class SignInScreenMethod extends StatefulWidget {
  const SignInScreenMethod({super.key});

  @override
  State<SignInScreenMethod> createState() => _SignInScreenMethodState();
}

class _SignInScreenMethodState extends State<SignInScreenMethod> {



  String authFlg = 'P';
  String _selectedLanguage = 'en';
  String _languageLableName= 'English';
  Locale _localeLanguageCode = Locale('en');
  final SavedPrefrence savedPrefrence = SavedPrefrence();
  String? _userIdError;
  String? _passwordMpinError;
  SplashDefaultModel? _splashDefaultData;



  @override
  void initState() {

   // SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

     SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: MyColor.bggradientfirst, // Set the color you want here.
      statusBarIconBrightness: Brightness.light, // Use Brightness.dark for dark icons.
    ));

    _loadCompanyData();  // load company data saved in shared pref.
    _loadSavedLanguage(); // load saved language data saved in shared pref.


  }



  // load company data
  Future<void> _loadCompanyData() async {
    final splashDefaultData = await savedPrefrence.getSplashDefaultData();
    setState(() {
      _splashDefaultData = splashDefaultData!;
    });
  }

  // load saved lamguage code
  Future<void> _loadSavedLanguage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? languageCode = prefs.getString('languageCode');
    String? languageName = prefs.getString('languageName');
    String? languageCodeValue = prefs.getString('languageCodeValue');
    CommonUtils.defaultLanguageCode = "${languageCodeValue}";
    context.read<ValidationMsgCubit>().validationMessage(CommonUtils.LOGINMENUNAME, CommonUtils.defaultLanguageCode, _splashDefaultData!.companyCode!);

    if (languageCode != null) {
      setState(() {
        _selectedLanguage = languageCode;
        _languageLableName = languageName!;
        _localeLanguageCode = Locale(languageCode);
      });
    }
  }

  // chnage language
  void _onLanguageChanged(String languageCode, String languageName, String languageCodeValue) async {
    Locale locale = Locale(languageCode);
    setState(() {
      _selectedLanguage = languageCode;
      _languageLableName = languageName;
      _localeLanguageCode = locale;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('languageCode', languageCode.toString());
    await prefs.setString('languageCodeValue', languageCodeValue.toString());
    await prefs.setString('languageName', languageName.toString());


    // Refresh the app with the new locale
    MyApp? myApp = context.findAncestorWidgetOfExactType<MyApp>();
    myApp?.locale = locale;
    runApp(MyApp(locale: locale));
  }



  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    //culture wise data load from assets file
    AppLocalizations? localizations = AppLocalizations.of(context);
    LoginModel? loginModel = localizations!.loginModel;

    //ui direction not change for arabic
    ui.TextDirection uiDirection = localizations.locale.languageCode == CommonUtils.ARABICCULTURECODE
        ? ui.TextDirection.ltr
        : ui.TextDirection.ltr;

    //text direction change for arabic
    ui.TextDirection textDirection = localizations.locale.languageCode == CommonUtils.ARABICCULTURECODE
        ? ui.TextDirection.rtl
        : ui.TextDirection.ltr;


    return Directionality(
      textDirection: uiDirection,
      child: Scaffold(

        body: BlocConsumer<ValidationMsgCubit, ValidationMsgState>(
          listener: (context, state) {
            if (state is ValidationMsgLoading){
              DialogUtils.showLoadingDialog(context, message: loginModel!.loading);

            }
            else if(state is ValidationMsgSuccess){

              //validation message responce
              DialogUtils.hideLoadingDialog(context);

              final validationMessages = state.validationMessages;
              ValidationMessageCodeUtils.validatorUserId = validationMessages[ValidationMessageCodeUtils.H000001] ?? "${loginModel!.validatorUserId}";
              ValidationMessageCodeUtils.validatorPassword = validationMessages[ValidationMessageCodeUtils.H000002] ?? "${loginModel!.validatorMpin}";
              ValidationMessageCodeUtils.validatorMpin = validationMessages[ValidationMessageCodeUtils.H000003] ?? "${loginModel!.validatorPassword}";

              ValidationMessageCodeUtils.correctionMsgUserCredential = validationMessages[ValidationMessageCodeUtils.H000005] ?? "${loginModel!.correctionMsgUserCredential}";
              ValidationMessageCodeUtils.userLockedMsg = validationMessages[ValidationMessageCodeUtils.H000006] ?? "${loginModel!.lockUserMsg}";

              ValidationMessageCodeUtils.AuthorisedRolesAndRightsMsg = validationMessages[ValidationMessageCodeUtils.H000032] ?? "";

            }
            else if(state is ValidationMsgFailure){

              DialogUtils.hideLoadingDialog(context);

              ValidationMessageCodeUtils.validatorUserId = "${loginModel!.validatorUserId}";
              ValidationMessageCodeUtils.validatorMpin = "${loginModel.validatorMpin}";
              ValidationMessageCodeUtils.validatorPassword = "${loginModel.validatorPassword}";
              ValidationMessageCodeUtils.correctionMsgUserCredential = "${loginModel.correctionMsgUserCredential}";
              ValidationMessageCodeUtils.userLockedMsg = "${loginModel.lockUserMsg}";

              SnackbarUtil.showSnackbar(context, state.error, MyColor.colorRed, icon: Icons.cancel);

            }
          },
          builder: (context, state) {
            return Container(
              width: double.infinity, // Adjust the width as needed
              height: double.infinity, // Adjust the height as needed
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                   MyColor.bggradientfirst, // #0060E5 color
                    MyColor.bggradientsecond, // #1D86FF color
                  ],
                  stops: [0.0, 1.0], // Specifies the start and end of the gradient
                ),
                image: DecorationImage(image: AssetImage(loginbg), fit: BoxFit.cover)
              ),
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height,
              ),

              child: Stack(
                children: [
                  Positioned(
                    top: 50,
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: SizeConfig.blockSizeHorizontal * SizeUtils.MAINPADDINGHORIZONTAL,

                      ),
                      child: Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: "Let's Get Started, \n", // Example for first part of text (e.g., "BAY")
                              style: GoogleFonts.roboto(
                                textStyle: TextStyle(
                                  fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_2_5, // Smaller size for "BAY"
                                  color: MyColor.colorWhite,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                            ),

                            TextSpan(
                              text: "Choose Sign In Method", // Example for last part of text (e.g., "AJ")
                              style: GoogleFonts.roboto(
                                textStyle: TextStyle(
                                  fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_2_5, // Smaller size for "AJ"
                                  color: MyColor.colorWhite,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ],
                        ),
                        textAlign: TextAlign.start,
                      ),
                    ),
                  ),
                  Positioned(
                      bottom: 0,
                      right: 10,
                      left: 10,
                      child: Column(
                        children: [
                          Container(
                            padding: EdgeInsets.all(SizeConfig.blockSizeVertical * SizeUtils.HEIGHT3),
                            decoration: BoxDecoration(
                              color: MyColor.colorWhite,
                              borderRadius: BorderRadius.circular(SizeConfig.blockSizeHorizontal * SizeUtils.BORDERRADIOUS_6),
                            ),
                            child: Column(
                              children: [
                               /* Card(
                                  elevation: 2,
                                  child: Directionality(
                                    textDirection: textDirection,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        color: MyColor.dropdownColor,
                                        borderRadius: BorderRadius.circular(SizeUtils.BORDERRADIOUS),
                                      ),
                                      child: Row(
                                        children: [
                                          const Icon(Icons.language), // Language icon
                                          SizedBox(width: SizeConfig.blockSizeHorizontal,),
                                          Expanded(
                                            child: Container(
                                              margin: EdgeInsets.only(right: localizations.locale.languageCode == CommonUtils.ARABICCULTURECODE ? 0 : 20, left: localizations.locale.languageCode == CommonUtils.ARABICCULTURECODE ? 20 : 0),
                                              child: DropdownButtonHideUnderline(
                                                child: DropdownButton<Language>(
                                                  isExpanded: true, // Make the dropdown content full width
                                                  value: null, // Set the value to null so no label is shown when closed
                                                  hint: CustomeText( // Placeholder text when dropdown is closed
                                                    text: "(${_selectedLanguage.toUpperCase()}) ${_languageLableName}", // Show the label name as hint text
                                                    fontColor: MyColor.colorBlack,
                                                    fontSize: SizeConfig.textMultiplier * 1.8,
                                                    fontWeight: FontWeight.w500,
                                                    textAlign: TextAlign.start,
                                                  ),
                                                  icon: Icon(FontAwesomeIcons.chevronDown), // Dropdown icon
                                                  onChanged: (Language? newValue) {
                                                    if (newValue != null) {
                                                      String languageNameVal = newValue.iSOLanguage!;
                                                      String languageCodeVal = newValue.iSOCultureInfoCode!;
                                                      String language = newValue.iSOCultureInfoCode!.split('-')[0];

                                                      CommonUtils.defaultLanguageCode = "${languageCodeVal}";


                                                      setState(() {
                                                        _selectedLanguage = language;
                                                        _languageLableName = languageNameVal; // Set the language name for display
                                                      });

                                                      // Call validation message API
                                                      context.read<ValidationMsgCubit>().validationMessage(
                                                        CommonUtils.LOGINMENUNAME,
                                                        CommonUtils.defaultLanguageCode,
                                                        _splashDefaultData!.companyCode!,
                                                      );

                                                      // Change the app language
                                                      _onLanguageChanged(language, languageNameVal, languageCodeVal);
                                                    }
                                                  },
                                                  dropdownColor: Colors.white, // Set dropdown background color to white
                                                  items: _splashDefaultData?.language?.map<DropdownMenuItem<Language>>((Language lang) {
                                                    String languageCode = lang.iSOCultureInfoCode!.split('-')[0];
                                                    return DropdownMenuItem<Language>(
                                                      value: lang,
                                                      child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        children: [

                                                          CustomeText(
                                                            text: lang.iSOLanguage ?? '',
                                                            fontColor: MyColor.colorBlack,
                                                            fontSize: SizeConfig.textMultiplier * 1.8,
                                                            fontWeight: FontWeight.w500,
                                                            textAlign: TextAlign.start,
                                                          ),
                                                          if (languageCode == _selectedLanguage)
                                                            Icon(Icons.done, color: Colors.black), // Show done icon for selected language
                                                        ],
                                                      ),
                                                    );
                                                  }).toList() ?? [],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),

                                ),*/
                                Directionality(
                                  textDirection: textDirection,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SvgPicture.asset(glob, height: SizeConfig.blockSizeVertical * SizeUtils.ICONSIZE3,),
                                      SizedBox(width: SizeConfig.blockSizeHorizontal * SizeUtils.WIDTH2,),
                                      DropdownButtonHideUnderline(
                                        child: DropdownButton<Language>(
                                          isExpanded: false, // Make the dropdown content full width
                                          value: null, // Set the value to null so no label is shown when closed
                                          hint: CustomeText( // Placeholder text when dropdown is closed
                                            text: "${_languageLableName.toUpperCase()} (${_selectedLanguage.toUpperCase()})", // Show the label name as hint text
                                            fontColor: MyColor.colorBlack,
                                            fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_9,
                                            fontWeight: FontWeight.w500,
                                            textAlign: TextAlign.start,
                                          ), // Dropdown icon
                                          iconEnabledColor: Colors.transparent,
                                          onChanged: (Language? newValue) {
                                            if (newValue != null) {
                                              String languageNameVal = newValue.iSOLanguage!;
                                              String languageCodeVal = newValue.iSOCultureInfoCode!;
                                              String language = newValue.iSOCultureInfoCode!.split('-')[0];

                                              CommonUtils.defaultLanguageCode = "${languageCodeVal}";


                                              setState(() {
                                                _selectedLanguage = language;
                                                _languageLableName = languageNameVal; // Set the language name for display
                                              });

                                              // Call validation message API
                                              context.read<ValidationMsgCubit>().validationMessage(
                                                CommonUtils.LOGINMENUNAME,
                                                CommonUtils.defaultLanguageCode,
                                                _splashDefaultData!.companyCode!,
                                              );

                                              // Change the app language
                                              _onLanguageChanged(language, languageNameVal, languageCodeVal);
                                            }
                                          },
                                          dropdownColor: Colors.white, // Set dropdown background color to white
                                          items: _splashDefaultData?.language?.map<DropdownMenuItem<Language>>((Language lang) {
                                            String languageCode = lang.iSOCultureInfoCode!.split('-')[0];
                                            return DropdownMenuItem<Language>(
                                              value: lang,
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [

                                                  CustomeText(
                                                    text: lang.iSOLanguage ?? '',
                                                    fontColor: MyColor.colorBlack,
                                                    fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_9,
                                                    fontWeight: FontWeight.w500,
                                                    textAlign: TextAlign.start,
                                                  ),
                                                  if (languageCode == _selectedLanguage)
                                                    Icon(Icons.done, color: Colors.black), // Show done icon for selected language
                                                ],
                                              ),
                                            );
                                          }).toList() ?? [],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: SizeConfig.blockSizeVertical * SizeUtils.HEIGHT3,),
                                RoundedButtonBlueGradient(text: "${loginModel!.signInUserId}", isborderButton: false, icon : userchecklight, textDirection: textDirection ,press: () {
                                  Navigator.push(context, CupertinoPageRoute(builder: (context) => LogInScreen(isMPinEnable: false, authFlag: "P",),));
                                },),
                                SizedBox(height: SizeConfig.blockSizeVertical * SizeUtils.HEIGHT2,),
                                RoundedButtonBlue(text: "${loginModel.signInMPIN}", isborderButton: true, icon : mobilelight, textDirection: textDirection ,press: () {
                                  Navigator.push(context, CupertinoPageRoute(builder: (context) => LogInScreen(isMPinEnable: true, authFlag: "M",),));
                                },),
                                SizedBox(height: SizeConfig.blockSizeVertical * SizeUtils.HEIGHT2,),
                                Text(
                                  "${loginModel.dontHaveAnAccount}",
                                  style: GoogleFonts.roboto(textStyle: TextStyle(
                                      color: MyColor.textColorGrey2,
                                      letterSpacing: 0.8,
                                      fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                      fontWeight: FontWeight.w400)),
                                ),
                                SizedBox(height: SizeConfig.blockSizeVertical * 0.5,),
                                Text(
                                  "${loginModel.createOne}",
                                  style: GoogleFonts.roboto(textStyle: TextStyle(
                                      color: MyColor.bggradientfirst,
                                      letterSpacing: 0.8,
                                      fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_7,
                                      fontWeight: FontWeight.w400)),
                                ),
                                SizedBox(height: SizeConfig.blockSizeVertical * SizeUtils.HEIGHT3,),
                               FooterCompanyName()

                                // CustomeText(text: "App Version ${_splashDefaultData!.appVersion}", fontColor: MyColor.textColorGrey2, fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_3, fontWeight: FontWeight.w400, textAlign: TextAlign.right),

                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: SizeConfig.blockSizeVertical * SizeUtils.HEIGHT2),
                            child: CustomeText(text: "Kale Logistics Mobile Solution", fontColor: MyColor.colorBlack, fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5, fontWeight: FontWeight.w400, textAlign: TextAlign.right),
                          ),

                        ],
                      ))


                ],
              ),
            );
          },
        ), // company name version widget
      ),
    );
  }

}
