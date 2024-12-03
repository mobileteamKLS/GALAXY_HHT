import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:galaxy/core/images.dart';
import 'package:galaxy/core/mycolor.dart';
import 'package:galaxy/module/onboarding/sizeconfig.dart';
import 'package:galaxy/prefrence/savedprefrence.dart';
import 'package:galaxy/utils/commonutils.dart';
import 'package:galaxy/utils/sizeutils.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../Ipad/screen/ImportShipmentListing.dart';
import '../../../Ipad/screen/IpadDashBoard.dart';
import '../../login/pages/loginscreen.dart';
import '../../login/pages/signinscreenmethods.dart';
import '../model/splashdefaultmodel.dart';
import '../service/splashlogic/splashcubit.dart';
import '../service/splashlogic/splashstate.dart';

// spalsh screen for landing page load for company code, appversion and culture list
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final SavedPrefrence savedPrefrence = SavedPrefrence();

  SplashDefaultModel? _splashDefaultData;

  @override
  void initState() {
    super.initState();
    _navigateToLogin();
   // SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Color(0xFFD1E3FC), // Set the color you want here.
      statusBarIconBrightness: Brightness.dark, // Use Brightness.dark for dark icons.
    ));
    //loadDefaultPage(); //load company name api with airportcode
  }

  Future<void> loadDefaultPage() async {
    context.read<SplashCubit>().getDefaultPageLoad(CommonUtils.airportCode).then((_) async {
      final splashDefaultData = await savedPrefrence.getSplashDefaultData(); // get company data
      if (splashDefaultData != null) {
       /* setState(() {
          _splashDefaultData = splashDefaultData;
        });*/
      }
    });
  }
  void _navigateToLogin() {
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(
        CupertinoPageRoute(
          builder: (BuildContext context) => const LogInScreen(
            isMPinEnable: false,
            authFlag: "P",
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      body: Container(
            decoration: const BoxDecoration(
              gradient: RadialGradient(
                center: Alignment.center,
                radius: 1.0,
                colors: [
                  Color(0xFFF5F9FF), // #F5F9FF color
                  Color(0xFFD1E3FC), // #D1E3FC color
                ],
                stops: [0.0, 1.0],
              ),
            ),
            child: Stack(
              children: [
                Positioned(
                  right: 0,
                  left: 0,
                  bottom: 70,
                  child: Center(
                    child: Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: "Kale Logistics", // Example for first part of text (e.g., "BAY")
                            style: GoogleFonts.roboto(
                              textStyle: TextStyle(
                                fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_9, // Smaller size for "BAY"
                                color: MyColor.textColorBlueHigh,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),

                          TextSpan(
                            text: " Solution©", // Example for last part of text (e.g., "AJ")
                            style: GoogleFonts.roboto(
                              textStyle: TextStyle(
                                fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_9, // Smaller size for "AJ"
                                color: MyColor.textColorBlueHigh,
                                fontWeight: FontWeight.w400,
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
                  top: 0,
                  right: 50,
                  left: 50,
                  bottom: 0,
                  child: Image.asset(kaleGalaxyLogo),
                ),
              ],
            ),
          ),
    );
  }
}
