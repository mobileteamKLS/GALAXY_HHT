import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:galaxy/Ipad/modal/ShipmentListingDetails.dart';
import 'package:galaxy/Ipad/screen/pickUpOperations.dart';
import 'package:galaxy/Ipad/screen/warehouseoperations.dart';
import 'package:galaxy/utils/dialogutils.dart';
import '../../core/images.dart';
import '../../core/mycolor.dart';
import '../../module/login/pages/loginscreen.dart';
import '../../module/onboarding/sizeconfig.dart';
import '../../utils/sizeutils.dart';
import '../../widget/customeedittext/customeedittextwithborder.dart';
import '../auth/auth.dart';
import '../modal/ShipmentAcceptanceModal.dart';
import '../utils/global.dart';
import '../widget/customDialog.dart';
import '../widget/customIpadTextfield.dart';
import 'ImportCreateShipment.dart';
import 'ImportShipmentListing.dart';
import 'ShipmentAcceptance.dart';

class IpadDashboard extends StatefulWidget {
  const IpadDashboard({super.key});

  @override
  State<IpadDashboard> createState() => _IpadDashboardState();
}

class _IpadDashboardState extends State<IpadDashboard> {

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
                  onTap: () {},
                  child: Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: SvgPicture.asset(
                      drawer,
                      height:
                      SizeConfig.blockSizeVertical * SizeUtils.ICONSIZE2,
                    ),
                  ),
                ),
                Text(
                  "  Dashboard",
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                      color: Colors.white),
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
              //   usercog,
              //   height: 25,
              // ),
              // const SizedBox(
              //   width: 10,
              // ),
              // SvgPicture.asset(
              //   bell,
              //   height: 25,
              // ),
              const SizedBox(
                width: 10,
              ),
            ]),
        // drawer: const Drawer(),
        body: Stack(
          children: [
            Container(
              constraints: const BoxConstraints.expand(),
              color: MyColor.screenBgColor,
              child:  Column(
                children: [
                  SizedBox(height: 10,),
                   Padding(
                    padding:
                    EdgeInsets.only(top: 10, left: 20, right: 20),
                    child: Material(
                      color: Colors.transparent,
                      // Ensures background transparency
                      // child: Row(
                      //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //   children: [
                      //     Row(
                      //       children: [
                      //         Icon(Icons.list),
                      //         Text(
                      //           '  Menu',
                      //           style: TextStyle(
                      //               fontWeight: FontWeight.bold, fontSize: 22),
                      //         ),
                      //       ],
                      //     ),
                      //
                      //   ],
                      // ),
                    ),
                  ),
                  SizedBox(height: 20,),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 5, left: 20, right: 20, bottom: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        isCES?RoundedIconButtonNew(
                          icon: Icons.warehouse_outlined,
                          text: 'Warehouse\nOperations',
                          targetPage: WarehouseOperations(),
                          containerColor: Color(0xffD1E2FB),
                          iconColor: MyColor.textColorGrey3,
                          textColor: MyColor.textColorGrey3,
                        ):RoundedIconButtonNew(
                          icon: Icons.list_alt_outlined,
                          text: 'Customs\nOperations',
                          targetPage: WarehouseOperations(),
                          containerColor: Color(0xffD1E2FB),
                          iconColor: MyColor.textColorGrey3,
                          textColor: MyColor.textColorGrey3,
                        ),
                        SizedBox(width: 40,),
                        RoundedIconButtonNew(
                          icon: Icons.fire_truck_outlined,
                          text: 'Pickup\nServices',
                          targetPage: PickupServices(),
                          containerColor: Color(0xffDFD6EF),
                          iconColor: MyColor.textColorGrey3,
                          textColor: MyColor.textColorGrey3,
                        ),

                        // RoundedIconButton(
                        //   icon: CupertinoIcons.square_stack_3d_up,
                        //   text: 'Acceptance',
                        //   targetPage: ShipmentAcceptance(),
                        //   containerColor: Color(0xffE1D9F0),
                        //   iconColor: MyColor.textColorGrey3,
                        //   textColor: MyColor.textColorGrey3,
                        // ),
                        // RoundedIconButton(
                        //   icon: Icons.fireplace_outlined,
                        //   text: 'Place Holder',
                        //   targetPage: ImportShipmentListing(),
                        //   containerColor: Color(0xffffffff),
                        //   iconColor: MyColor.textColorGrey3,
                        //   textColor: MyColor.textColorGrey3,
                        // ),
                        // RoundedIconButton(
                        //   icon: Icons.fireplace_outlined,
                        //   text: 'Place Holder',
                        //   targetPage: ImportShipmentListing(),
                        //   containerColor: Color(0xffffffff),
                        //   iconColor: MyColor.textColorGrey3,
                        //   textColor: MyColor.textColorGrey3,
                        // ),

                      ],
                    ),
                  ),
                  // SizedBox(height: 40,),
                  // const Padding(
                  //   padding:
                  //   EdgeInsets.only(top: 10, left: 20, right: 20),
                  //   child: Material(
                  //     color: Colors.transparent,
                  //     // Ensures background transparency
                  //     child: Row(
                  //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //       children: [
                  //         Row(
                  //           children: [
                  //             Icon(CupertinoIcons.cube),
                  //             Text(
                  //               '  Imports Quick Actions',
                  //               style: TextStyle(
                  //                   fontWeight: FontWeight.bold, fontSize: 22),
                  //             ),
                  //           ],
                  //         ),
                  //
                  //       ],
                  //     ),
                  //   ),
                  // ),
                  // SizedBox(height: 20,),
                  // Padding(
                  //   padding: const EdgeInsets.only(
                  //       top: 5, left: 20, right: 20, bottom: 10),
                  //   child: Row(
                  //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //     children: [
                  //       RoundedIconButton(
                  //         icon: Icons.list,
                  //         text: 'Shipments\nList',
                  //         targetPage: ImportShipmentListing(),
                  //         containerColor: Color(0xffD1E2FB),
                  //         iconColor: MyColor.textColorGrey3,
                  //         textColor: MyColor.textColorGrey3,
                  //       ),
                  //       RoundedIconButton(
                  //         icon: CupertinoIcons.square_stack_3d_up,
                  //         text: 'Acceptance',
                  //         targetPage: ShipmentAcceptance(),
                  //         containerColor: Color(0xffE1D9F0),
                  //         iconColor: MyColor.textColorGrey3,
                  //         textColor: MyColor.textColorGrey3,
                  //       ),
                  //       RoundedIconButton(
                  //         icon: Icons.fireplace_outlined,
                  //         text: 'Place Holder',
                  //         targetPage: ImportShipmentListing(),
                  //         containerColor: Color(0xffffffff),
                  //         iconColor: MyColor.textColorGrey3,
                  //         textColor: MyColor.textColorGrey3,
                  //       ),
                  //       RoundedIconButton(
                  //         icon: Icons.fireplace_outlined,
                  //         text: 'Place Holder',
                  //         targetPage: ImportShipmentListing(),
                  //         containerColor: Color(0xffffffff),
                  //         iconColor: MyColor.textColorGrey3,
                  //         textColor: MyColor.textColorGrey3,
                  //       ),
                  //
                  //     ],
                  //   ),
                  // ),
                ],
              ),
            ),
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: IgnorePointer(
                child: CustomPaint(
                  size: Size(MediaQuery
                      .of(context)
                      .size
                      .width,
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
        //               color: MyColor.primaryColorblue,
        //             ),
        //             Text(
        //               "User Help",
        //               style: TextStyle(color: MyColor.primaryColorblue),
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