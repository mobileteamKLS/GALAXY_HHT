import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:galaxy/Ipad/screen/pickup.dart';
import 'package:galaxy/Ipad/screen/schedulePickups.dart';
import 'package:galaxy/module/login/pages/loginscreen.dart';
import '../../core/images.dart';
import '../../core/mycolor.dart';
import '../../module/onboarding/sizeconfig.dart';
import '../../utils/sizeutils.dart';
import '../auth/auth.dart';
import '../widget/customDialog.dart';
import '../widget/customIpadTextfield.dart';
import 'ImportShipmentListing.dart';
import 'activePickupRequest.dart';

class PickupServices extends StatefulWidget {
  const PickupServices({super.key});

  @override
  State<PickupServices> createState() => _PickupServicesState();
}

class _PickupServicesState extends State<PickupServices> {
  final AuthService authService = AuthService();
  bool isLoading = false;
  bool hasNoRecord = false;

  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
            automaticallyImplyLeading: false,
            title: Row(
              children: [
                InkWell(
                  onTap: () {
                  },
                  child: Padding(padding: const EdgeInsets.all(2.0),
                    child: SvgPicture.asset(drawer, height: SizeConfig.blockSizeVertical * SizeUtils.ICONSIZE2,),
                  ),
                ),
                const Text(
                 "  Pickup Services",
                  style: TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 24,color: Colors.white),
                ),
              ],
            ),
            iconTheme: const IconThemeData(color: Colors.white, size: 32),
            toolbarHeight: 80,
            flexibleSpace: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF0057D8),
                    Color(0xFF1c86ff),
                  ],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
              ),
            ),
            actions: [
              GestureDetector(
                child: const Icon(Icons.logout_outlined,
                    color: Colors.white, size: 36),
                onTap: () async {
                  //bool? logoutConfirmed = await showLogoutDialog(context);
                  var userSelection =
                  await showDialog(
                    context: context,
                    builder: (BuildContext
                    context) =>
                        CustomConfirmDialog(
                            title:
                            "Logout Confirm ?",
                            description:
                            "Are you sure you want to logout ?",
                            buttonText:
                            "Yes",
                            imagepath:
                            'assets/images/question.gif',
                            isMobile:
                            false),
                  );
                  if (userSelection == true) {

                    Navigator.pushAndRemoveUntil(context, CupertinoPageRoute(builder: (context) => const LogInScreen(isMPinEnable: false, authFlag: "P"),), (route) => false,);
                  }
                },
              ),
              const SizedBox(
                width: 20,
              ),
              // SvgPicture.asset(
              //   bell,
              //   height: 25,
              // ),
              // const SizedBox(
              //   width: 10,
              // ),
            ]),
        // drawer: const Drawer(),
        body: Stack(
          children: [
            Container(
              constraints: const BoxConstraints.expand(),
              color: MyColor.screenBgColor,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding:  EdgeInsets.only(top: 20, left: 20, right: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              GestureDetector(
                                child: const Icon(Icons.arrow_back_ios,
                                    color: MyColor.primaryColorblue),
                                onTap: () {
                                  Navigator.pop(context);
                                },
                              ),
                              const Text(
                                '  Pickup Services',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 22),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(top: 10, left: 20, right: 20),
                      child: Material(
                        color: Colors.transparent,
                        // Ensures background transparency
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Row(
                            //   children: [
                            //     GestureDetector(
                            //       child:  const Icon(Icons.arrow_back_ios,
                            //           color: MyColor.primaryColorblue),
                            //       onTap: () {
                            //         Navigator.pop(context);
                            //       },
                            //     ),
                            //     const Text(
                            //       '  ',
                            //       style: TextStyle(
                            //           fontWeight: FontWeight.bold, fontSize: 22),
                            //     ),
                            //   ],
                            // ),
                          ],
                        ),
                      ),
                    ),
                   SizedBox(
                      height: 20,
                    ),

                     const Padding(
                      padding: EdgeInsets.only(
                          top: 5, left: 20, right: 20, bottom: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          RoundedIconButtonNew(
                            icon: CupertinoIcons.doc,
                            text: 'Active Pickup\nRequests',
                            targetPage: ActivePickupRequest(),
                            containerColor: Color(0xfffcedcf),
                            iconColor: MyColor.textColorGrey3,
                            textColor: MyColor.textColorGrey3,
                          ),
                          // SizedBox(width: 40,),
                          RoundedIconButtonNew(
                            icon: CupertinoIcons.cube_box,
                            text: 'Scheduled\nPickups',
                            targetPage: ScheduledPickups(),
                            containerColor: Color(0xffD1E2FB),
                            iconColor: MyColor.textColorGrey3,
                            textColor: MyColor.textColorGrey3,
                          ),
                          RoundedIconButtonNew(
                            icon: Icons.fire_truck_outlined,
                            text: 'Pickups\n',
                            targetPage: PickUps(),
                            containerColor: Color(0xffFFD0D0),
                            iconColor: MyColor.textColorGrey3,
                            textColor: MyColor.textColorGrey3,
                          ),
                        ],
                      ),
                    )


                  ],
                ),
              ),
            ),
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: IgnorePointer(
                child: CustomPaint(
                  size: Size(MediaQuery.of(context).size.width,
                      100), // Adjust the height as needed
                  painter: AppBarPainterGradient(),
                ),
              ),
            ),
          ],
        ),
        // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        // extendBody: true,
        // bottomNavigationBar: BottomAppBar(
        //   padding: const EdgeInsets.symmetric(horizontal: 10),
        //   height: 60,
        //   color: Colors.white,
        //   surfaceTintColor: Colors.white,
        //   shape: const CircularNotchedRectangle(),
        //   notchMargin: 5,
        //   child: Row(
        //     mainAxisSize: MainAxisSize.max,
        //     mainAxisAlignment: MainAxisAlignment.spaceAround,
        //     children: <Widget>[
        //       GestureDetector(
        //         onTap: () {},
        //         child: const Column(
        //           mainAxisAlignment: MainAxisAlignment.center,
        //           children: [
        //             Icon(CupertinoIcons.chart_pie),
        //             Text("Dashboard"),
        //           ],
        //         ),
        //       ),
        //       GestureDetector(
        //         onTap: () {},
        //         child: const Column(
        //           mainAxisAlignment: MainAxisAlignment.center,
        //           children: [
        //             Icon(
        //               Icons.help_outline,
        //
        //             ),
        //             Text(
        //               "User Help",
        //
        //             ),
        //           ],
        //         ),
        //       ),
        //     ],
        //   ),
        // ),
      ),
    );
  }
}
