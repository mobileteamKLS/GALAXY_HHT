import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:galaxy/Ipad/modal/ShipmentListingDetails.dart';
import 'package:galaxy/Ipad/screen/warehouseoperations.dart';
import '../../core/images.dart';
import '../../core/mycolor.dart';
import '../../widget/customeedittext/customeedittextwithborder.dart';
import '../auth/auth.dart';
import '../modal/ShipmentAcceptanceModal.dart';
import '../utils/global.dart';
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
    getCommodity();
    getCustomerName();
  }

  getCommodity() async {
    if (isLoading) return;

    setState(() {
      isLoading = true;
    });

    var queryParams = {
      "AirportCode":"BLR",
      "CompanyCode":"3",
      "CultureCode":"en-US",
      "UserId":"1",
      "MenuId":"1"
    };
    await authService
        .getData(
      "CommodityNames/Get",
      queryParams,
    )
        .then((response) {
      print("data received ");
      Map<String, dynamic> jsonData = json.decode(response.body);

      print(jsonData);
      if (jsonData.isEmpty) {
        setState(() {
          hasNoRecord = true;
        });
      }
      else{
        hasNoRecord=false;
      }
      print("is empty record$hasNoRecord");
      String status = jsonData['Status'];
      String statusMessage = jsonData['StatusMessage'];

      if (status != 'S') {
        print("Error: $statusMessage");
        return;
      }
      final List<dynamic> commodities = jsonData['CommodityList'];
      setState(() {
        commodityListMaster = commodities
            .map((commodity) => Commodity.fromJson(commodity))
            .toList();
        isLoading = false;

      });
      print("No of commodities ${commodityListMaster.length}");
    }).catchError((onError) {
      setState(() {
        isLoading = false;
      });
      print(onError);
    });
  }
  getCustomerName() async {
    if (isLoading) return;

    setState(() {
      isLoading = true;
    });

    var queryParams = {
      "AirportCode":"BLR",
      "CompanyCode":"3",
      "CultureCode":"en-US",
      "UserId":"1",
      "MenuId":"1"
    };
    await authService
        .getData(
      "CustomerNames/Get",
      queryParams,
    )
        .then((response) {
      print("data received ");
      Map<String, dynamic> jsonData = json.decode(response.body);

      print(jsonData);
      if (jsonData.isEmpty) {
        setState(() {
          hasNoRecord = true;
        });
      }
      else{
        hasNoRecord=false;
      }
      print("is empty record$hasNoRecord");
      String status = jsonData['Status'];
      String statusMessage = jsonData['StatusMessage'];

      if (status != 'S') {
        print("Error: $statusMessage");
        return;
      }
      final List<dynamic> customers = jsonData['CustomerList'];
      setState(() {
        customerListMaster =
            customers.map((customer) => Customer.fromJson(customer)).toList();
        isLoading = false;

      });
      print("No of commodities ${customerListMaster.length}");
    }).catchError((onError) {
      setState(() {
        isLoading = false;
      });
      print(onError);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
            title: const Text(
              'Landing Page',
              style: TextStyle(color: Colors.white),
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
              SvgPicture.asset(
                usercog,
                height: 25,
              ),
              const SizedBox(
                width: 10,
              ),
              SvgPicture.asset(
                bell,
                height: 25,
              ),
              const SizedBox(
                width: 10,
              ),
            ]),
        drawer: const Drawer(),
        body: Stack(
          children: [
            Container(
              constraints: const BoxConstraints.expand(),
              color: MyColor.screenBgColor,
              child: const Column(
                children: [
                  SizedBox(height: 10,),
                  const Padding(
                    padding:
                    EdgeInsets.only(top: 10, left: 20, right: 20),
                    child: Material(
                      color: Colors.transparent,
                      // Ensures background transparency
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.list),
                              Text(
                                '  Menu',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 22),
                              ),
                            ],
                          ),

                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 20,),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 5, left: 20, right: 20, bottom: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        RoundedIconButton(
                          icon: Icons.warehouse_outlined,
                          text: 'Warehouse\nOperations',
                          targetPage: WarehouseOperations(),
                          containerColor: Color(0xffD1E2FB),
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
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        extendBody: true,
        bottomNavigationBar: BottomAppBar(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          height: 60,
          color: Colors.white,
          surfaceTintColor: Colors.white,
          shape: const CircularNotchedRectangle(),
          notchMargin: 5,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              GestureDetector(
                onTap: () {},
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(CupertinoIcons.chart_pie),
                    Text("Dashboard"),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {},
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.help_outline,
                      color: MyColor.primaryColorblue,
                    ),
                    Text(
                      "User Help",
                      style: TextStyle(color: MyColor.primaryColorblue),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


}
