import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:galaxy/Ipad/screen/rejectBooking.dart';
import 'package:galaxy/Ipad/screen/wdoListing.dart';
import 'package:galaxy/module/login/pages/loginscreen.dart';
import '../../core/images.dart';
import '../../core/mycolor.dart';
import '../../module/onboarding/sizeconfig.dart';
import '../../utils/sizeutils.dart';
import '../utils/global.dart';
import '../widget/customIpadTextfield.dart';
import 'ImportShipmentListing.dart';
import 'dockIn.dart';
import 'dockOut.dart';

class VehicleTrackingOperations extends StatefulWidget {
  const VehicleTrackingOperations({super.key});

  @override
  State<VehicleTrackingOperations> createState() => _VehicleTrackingOperationsState();
}

class _VehicleTrackingOperationsState extends State<VehicleTrackingOperations> {

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
              Text(
                isCES?'  Warehouse Operations':"  Customs Operation",
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
            ),
        // drawer: const Drawer(),
        body: Stack(
          children: [
            Container(
              constraints: const BoxConstraints.expand(),
              color: MyColor.screenBgColor,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                     Padding(
                      padding: EdgeInsets.only(top: 10, left: 20, right: 20),
                      child: Material(
                        color: Colors.transparent,
                        // Ensures background transparency
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                GestureDetector(
                                  child:  const Icon(Icons.arrow_back_ios,
                                      color: MyColor.primaryColorblue),
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                ),
                                const Text(
                                  ' Vehicle Track',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold, fontSize: 22),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    isCES
                        ? const SizedBox(
                      height: 20,
                    )
                        : SizedBox(),
                    isCES
                        ? const Padding(
                      padding: EdgeInsets.only(
                          top: 5, left: 20, right: 20, bottom: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          // RoundedIconButtonNew(
                          //   icon: Icons.login_outlined,
                          //   text: 'Gate In',
                          //   targetPage: GateIn(),
                          //   containerColor: Color(0xffFDEECF),
                          //   iconColor: MyColor.textColorGrey3,
                          //   textColor: MyColor.textColorGrey3,
                          // ),
                          // SizedBox(width: 40,),
                          RoundedIconButtonNew(
                            icon: dock_in,
                            text: 'Dock In',
                            targetPage: DockIn(),
                            containerColor: Color(0xffD1E2FB),
                            iconColor: MyColor.textColorGrey3,
                            textColor: MyColor.textColorGrey3,
                          ),
                          SizedBox(width: 40,),
                          RoundedIconButtonNew(
                            icon:dock_out,
                            text: 'Dock Out',
                            targetPage: DockOut(),
                            containerColor: Color(0xffFFD0D0),
                            iconColor: MyColor.textColorGrey3,
                            textColor: MyColor.textColorGrey3,
                          ),
                        ],
                      ),
                    )
                        : const SizedBox(),
                    isCES
                        ? const SizedBox(
                      height: 20,
                    )
                        : const SizedBox(),
                    isCES
                        ? const Padding(
                      padding: EdgeInsets.only(
                          top: 5, left: 20, right: 20, bottom: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          // RoundedIconButtonNew(
                          //   icon: Icons.logout_outlined,
                          //   text: 'Gate Out',
                          //   targetPage: GateOut(),
                          //   containerColor: Color(0xffFFD7BC),
                          //   iconColor: MyColor.textColorGrey3,
                          //   textColor: MyColor.textColorGrey3,
                          // ),
                          // SizedBox(width: 40,),

                        ],
                      ),
                    )
                        : SizedBox(),


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