import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:galaxy/core/mycolor.dart';
import 'package:galaxy/language/validationmessageservice/validationmessagelogic/validationmsgcubit.dart';
import 'package:galaxy/module/dashboard/service/menuLogic/menucubit.dart';
import 'package:galaxy/module/import/services/flightcheck/flightchecklogic/flightcheckcubit.dart';
import 'package:galaxy/module/submenu/service/subMenuLogic/submenucubit.dart';
import 'package:galaxy/module/splash/page/splashscreen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Ipad/screen/ImportShipmentListing.dart';
import 'Ipad/screen/IpadDashBoard.dart';
import 'language/appLocalizations.dart';
import 'module/splash/service/splashrepository.dart';
import 'module/import/services/uldacceptance/uldacceptancelogic/uldacceptancecubit.dart';
import 'module/onboarding/onboardscreen.dart';
import 'module/login/services/loginlogic/logincubit.dart';
import 'module/splash/service/splashlogic/splashcubit.dart';


Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();
  //load local language
  Locale? locale = await _loadSavedLanguage();
  runApp(MyApp(locale: locale));
}

// check for local language
Future<Locale?> _loadSavedLanguage() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? languageCode = prefs.getString('languageCode');
  if (languageCode != null) {
    return Locale(languageCode);
  }else{
    prefs.setString('languageCode', 'en');
    prefs.setString('languageName', 'English');
    prefs.setString('languageCodeValue', 'en-US');
    return const Locale('en');
  }
  return null;
}

class MyApp extends StatelessWidget {

  final MaterialColor customPrimarySwatch = const MaterialColor(
    0xFF0060E5, // The primary color value
    <int, Color>{
      50: Color(0xffe3f2fd), // 10% opacity
      100: Color(0xffbbdefb), // 20% opacity
      200: Color(0xff90caf9), // 30% opacity
      300: Color(0xff64b5f6), // 40% opacity
      400: Color(0xff42a5f5), // 50% opacity
      500: Color(0xff2196f3), // 60% opacity
      600: Color(0xff1e88e5), // 70% opacity
      700: Color(0xff1976d2), // 80% opacity
      800: Color(0xff1565c0), // 90% opacity
      900: Color(0xff0d47a1), // 100% opacity
    },
  );

  late Locale? locale;
  MyApp({Key? key, this.locale}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        //BlocProvider(create: (context) => CompanyLogoCubit(CompanyLogoRepository())..getCompanyLogo(CommonUtils.airportCode),),
        BlocProvider(create: (context) => SplashCubit(SplashRepository())),
        BlocProvider(create: (context) => ValidationMsgCubit(),),
        BlocProvider(create: (context) => LoginCubit(),),
        BlocProvider(create: (context) => MenuCubit(),),
        BlocProvider(create: (context) => SubMenuCubit(),),
        BlocProvider(create: (context) => UldAcceptanceCubit(),),
        BlocProvider(create: (context) => FlightCheckCubit(),),
      ],
      child: MaterialApp(

        title: 'Galaxy',
        locale: locale ?? const Locale('en'),  // Add Default Language
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],

        // add Supported all languages
        supportedLocales: const [
          Locale('en', 'US'),
          Locale('hi', 'IN'),
          Locale('ar', 'AE'),
        ],
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          timePickerTheme: TimePickerThemeData(
              entryModeIconColor: MyColor.primaryColorblue,
              backgroundColor: Colors.grey.shade200,
              // timeSelectorSeparatorColor: MaterialStateProperty.all<Color>(MyColor.primaryColorblue),
              helpTextStyle: GoogleFonts.poppins(textStyle: const TextStyle(color: MyColor.colorBlack, fontWeight: FontWeight.w500)),
              shape: ContinuousRectangleBorder(borderRadius: BorderRadius.circular(15)),
              hourMinuteShape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
              dayPeriodTextStyle: GoogleFonts.poppins(textStyle: const TextStyle(fontWeight: FontWeight.w600)),
              dialTextStyle: GoogleFonts.poppins(textStyle: const TextStyle(fontWeight: FontWeight.w600)),
              cancelButtonStyle: ButtonStyle(
                foregroundColor: MaterialStateProperty.all<Color>(MyColor.primaryColorblue), // Text color
                textStyle: MaterialStateProperty.all<TextStyle>(
                  GoogleFonts.poppins(textStyle: const TextStyle(fontWeight: FontWeight.w600)),
                ),
              ),
              confirmButtonStyle: ButtonStyle(
                foregroundColor: MaterialStateProperty.all<Color>(MyColor.primaryColorblue), // Text color
                textStyle: MaterialStateProperty.all<TextStyle>(
                  GoogleFonts.poppins(textStyle: TextStyle(fontWeight: FontWeight.w600)),
                ),
              ),
              dayPeriodShape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10)))

          ),
          datePickerTheme: DatePickerThemeData(
            cancelButtonStyle: ButtonStyle(
              foregroundColor: MaterialStateProperty.all<Color>(MyColor.primaryColorblue), // Text color
              textStyle: MaterialStateProperty.all<TextStyle>(
                GoogleFonts.poppins(textStyle: const TextStyle(fontWeight: FontWeight.w600)),
              ),
            ),
            confirmButtonStyle: ButtonStyle(
              foregroundColor: MaterialStateProperty.all<Color>(MyColor.primaryColorblue), // Text color
              textStyle: MaterialStateProperty.all<TextStyle>(
                GoogleFonts.poppins(textStyle: const TextStyle(fontWeight: FontWeight.w600)),
              ),
            ),
          ),
          colorScheme: ColorScheme.fromSwatch(primarySwatch: customPrimarySwatch).copyWith(secondary: MyColor.primaryColorblue),
          // colorScheme: ColorScheme.fromSeed(seedColor: MyColor.primaryColorblue).copyWith(inversePrimary: MyColor.primaryColorblue),
          useMaterial3: true,
        ),
        home: FutureBuilder<bool>(
            future: checkIfOnboardingSeen(),   // check onBoarding screen
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else {
                // when
                return snapshot.data == true ? const SplashScreen() : const IpadDashboard();
              }
            }
        ),
      ),
    );
  }

  Future<bool> checkIfOnboardingSeen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('onboardingSeen') ?? false;
  }
}