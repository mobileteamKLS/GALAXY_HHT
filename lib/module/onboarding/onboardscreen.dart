import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:galaxy/core/mycolor.dart';
import 'package:galaxy/widget/customebuttons/roundbuttonblue.dart';
import 'package:galaxy/widget/custometext.dart';
import 'package:galaxy/widget/roundbutton.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../splash/page/splashscreen.dart';
import '../../utils/sizeutils.dart';
import 'sizeconfig.dart';
import 'onboardcontent.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  late PageController _controller;

  @override
  void initState() {
    _controller = PageController();
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.white, // Set the color you want here.
      statusBarIconBrightness: Brightness.dark, // Use Brightness.dark for dark icons.
    ));
    super.initState();
  }

  int _currentPage = 0;
  List colors = const [
    MyColor.colorWhite,
    MyColor.colorWhite,
    MyColor.colorWhite,
    MyColor.colorWhite,
  ];

  AnimatedContainer _buildDots({int? index}) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(50),
        ),
        color: MyColor.primaryColorblue,
      ),
      margin: const EdgeInsets.only(right: 5),
      height: 10,
      curve: Curves.easeIn,
      width: _currentPage == index ? 20 : 10,
    );
  }

  Future<void> _completeOnboarding() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboardingSeen', true);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => SplashScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);


    return Scaffold(
      backgroundColor: MyColor.colorWhite,
      body: Stack(
        children: [



          Positioned(
            top: 0,
            bottom: 0,
            right: 0,
            left: 0,
            child: PageView.builder(
              physics: const BouncingScrollPhysics(),
              controller: _controller,
              onPageChanged: (value) => setState(() => _currentPage = value),
              itemCount: contents.length,
              itemBuilder: (context, i) {
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: SizeConfig.blockSizeHorizontal * SizeUtils.WIDTH6),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [



                      Image.asset(
                        contents[i].image,
                        height:  SizeConfig.blockSizeVertical * 25,
                      ),
                      SizedBox(
                        height:  SizeConfig.blockSizeVertical * SizeUtils.HEIGHT3,
                      ),
                      CustomeText(text:  contents[i].title,
                          fontColor: MyColor.primaryColorblue,
                          fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_2_5,
                          fontWeight: FontWeight.w600,
                          textAlign: TextAlign.center),
                      SizedBox(height: SizeConfig.blockSizeVertical * 2),
                      CustomeText(text:  contents[i].desc,
                          fontColor: MyColor.primaryColorblue,
                          fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_2_0,
                          fontWeight: FontWeight.w300,
                          textAlign: TextAlign.center),

                    ],
                  ),
                );
              },
            ),
          ),
          Positioned(
            bottom: 10,
            left: 0,
            right: 0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [

                if (_currentPage == 0)
                  Padding(
                    padding: EdgeInsets.all(30),
                    child: RoundedButtonBlue(
                      text: 'Get Started',
                      press: () {
                        _controller.nextPage(
                          duration: const Duration(milliseconds: 200),
                          curve: Curves.easeIn,
                        );
                      },
                    ),
                  )else if(_currentPage + 1 == contents.length)
                  Padding(
                    padding: EdgeInsets.all(30),
                    child: RoundedButtonBlue(
                      text: 'Start',
                      press: _completeOnboarding,
                    ),
                  )
                else
                  Padding(
                  padding: const EdgeInsets.all(30),
                  child: Column(
                    children: [
                      TextButton(
                        onPressed: () {
                          _controller.jumpToPage(5);
                        },
                        style: TextButton.styleFrom(
                          elevation: 0,
                          textStyle: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: SizeConfig.blockSizeHorizontal * 4,
                          ),
                        ),
                        child: CustomeText(text: "Skip",
                            fontColor: MyColor.primaryColorblue,
                            fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_9,
                            fontWeight: FontWeight.w400,
                            textAlign: TextAlign.center),
                      ),

                     SizedBox(height: SizeConfig.blockSizeVertical,),

                      RoundedButtonBlue(
                        text: 'Next',
                        press: () {
                          _controller.nextPage(
                            duration: const Duration(milliseconds: 200),
                            curve: Curves.easeIn,
                          );
                        },
                      )

                    ],
                  ),
                )
              ],
            ),
          ),

          Positioned(
            top: 50,
            left: 20,
            right: 20,
            child: Container(
              height: 3,
              child: LinearProgressIndicator(
                value: (_currentPage + 1) / contents.length, // Calculate progress
                backgroundColor: MyColor.dropdownColor, // Progress bar background color
                color: MyColor.primaryColorblue, // Progress bar active color
                minHeight: 4.0, // Height of the progress bar
              ),
            ),
          ),
        ],
      ),
    );
  }
}

