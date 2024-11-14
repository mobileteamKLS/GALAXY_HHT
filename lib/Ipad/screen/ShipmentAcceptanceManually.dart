import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:galaxy/Ipad/modal/ShipmentListingDetails.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vibration/vibration.dart';
import '../../core/images.dart';
import '../../core/mycolor.dart';
import '../../utils/commonutils.dart';
import '../../utils/snackbarutil.dart';
import '../../widget/customeedittext/customeedittextwithborder.dart';
import '../auth/auth.dart';
import '../widget/customIpadTextfield.dart';
import 'ImportCreateShipment.dart';
import 'ImportShipmentListing.dart';

class ShipmentAcceptanceManually extends StatefulWidget {
  const ShipmentAcceptanceManually({super.key});

  @override
  State<ShipmentAcceptanceManually> createState() =>
      _ShipmentAcceptanceManuallyState();
}

class _ShipmentAcceptanceManuallyState
    extends State<ShipmentAcceptanceManually> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
            title: const Text(
              'Imports',
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
              child: Padding(
                padding: EdgeInsets.only(top: 20, left: 20, right: 20),
                child: Material(
                  color: Colors.transparent,
                  // Ensures background transparency
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Text(
                              'Booking Creation',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12.0),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                spreadRadius: 2,
                                blurRadius: 8,
                                offset: const Offset(
                                    0, 3), // changes position of shadow
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 14, horizontal: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height:
                                      MediaQuery.sizeOf(context).height * 0.02,
                                ),
                                SizedBox(
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          SizedBox(
                                            width: MediaQuery.sizeOf(context)
                                                    .width *
                                                0.44,
                                            child: Row(
                                              children: [
                                                SizedBox(
                                                  height:
                                                      MediaQuery.sizeOf(context)
                                                              .height *
                                                          0.04,
                                                  width:
                                                      MediaQuery.sizeOf(context)
                                                              .width *
                                                          0.1,
                                                  child:
                                                      CustomeEditTextWithBorder(
                                                    lablekey: 'MAWB',
                                                    hasIcon: false,
                                                    hastextcolor: true,
                                                    animatedLabel: true,
                                                    needOutlineBorder: true,
                                                    labelText: "Prefix*",
                                                    readOnly: false,
                                                    maxLength: 3,
                                                    textInputType:
                                                        TextInputType.number,
                                                    fontSize: 18,
                                                    onChanged:
                                                        (String, bool) {},
                                                  ),
                                                ),
                                                const SizedBox(
                                                  width: 15,
                                                ),
                                                SizedBox(
                                                  height:
                                                      MediaQuery.sizeOf(context)
                                                              .height *
                                                          0.04,
                                                  width:
                                                      MediaQuery.sizeOf(context)
                                                              .width *
                                                          0.32,
                                                  child:
                                                      CustomeEditTextWithBorder(
                                                    lablekey: 'MAWB',
                                                    hasIcon: false,
                                                    hastextcolor: true,
                                                    animatedLabel: true,
                                                    textInputType:
                                                        TextInputType.number,
                                                    needOutlineBorder: true,
                                                    labelText: "AWB No*",
                                                    readOnly: false,
                                                    maxLength: 8,
                                                    fontSize: 18,
                                                    onChanged:
                                                        (String, bool) {},
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            width: MediaQuery.sizeOf(context)
                                                    .width *
                                                0.44,
                                            child: CustomeEditTextWithBorder(
                                              lablekey: 'MAWB',
                                              hasIcon: false,
                                              hastextcolor: true,
                                              animatedLabel: true,
                                              needOutlineBorder: true,
                                              labelText: "HAWB No*",
                                              readOnly: false,
                                              maxLength: 15,
                                              fontSize: 18,
                                              onChanged: (String, bool) {},
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height:
                                            MediaQuery.sizeOf(context).height *
                                                0.02,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          SizedBox(
                                            width: MediaQuery.sizeOf(context)
                                                    .width *
                                                0.45,
                                            child: Row(
                                              children: [
                                                SizedBox(
                                                  height:
                                                      MediaQuery.sizeOf(context)
                                                              .height *
                                                          0.04,
                                                  width:
                                                      MediaQuery.sizeOf(context)
                                                              .width *
                                                          0.22,
                                                  child:
                                                      CustomeEditTextWithBorder(
                                                    lablekey: 'MAWB',
                                                    hasIcon: false,
                                                    hastextcolor: true,
                                                    animatedLabel: true,
                                                    needOutlineBorder: true,
                                                    labelText: "NoP*",
                                                    readOnly: false,
                                                    textInputType:
                                                        TextInputType.number,
                                                    maxLength: 4,
                                                    fontSize: 18,
                                                    onChanged:
                                                        (String, bool) {},
                                                  ),
                                                ),
                                                const SizedBox(
                                                  width: 15,
                                                ),
                                                SizedBox(
                                                  height:
                                                      MediaQuery.sizeOf(context)
                                                              .height *
                                                          0.04,
                                                  width:
                                                      MediaQuery.sizeOf(context)
                                                              .width *
                                                          0.20,
                                                  child:
                                                      CustomeEditTextWithBorder(
                                                    lablekey: 'MAWB',
                                                    hasIcon: false,
                                                    hastextcolor: true,
                                                    animatedLabel: true,
                                                    needOutlineBorder: true,
                                                    labelText: "Total Weight*",
                                                    readOnly: false,
                                                    textInputType:
                                                        TextInputType.number,
                                                    maxLength: 4,
                                                    fontSize: 18,
                                                    onChanged:
                                                        (String, bool) {},
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            width: MediaQuery.sizeOf(context)
                                                    .width *
                                                0.45,
                                            child: Row(
                                              children: [
                                                SizedBox(
                                                  height:
                                                      MediaQuery.sizeOf(context)
                                                              .height *
                                                          0.04,
                                                  width:
                                                      MediaQuery.sizeOf(context)
                                                              .width *
                                                          0.22,
                                                  child:
                                                      CustomeEditTextWithBorder(
                                                    lablekey: 'MAWB',
                                                    hasIcon: false,
                                                    hastextcolor: true,
                                                    animatedLabel: true,
                                                    needOutlineBorder: true,
                                                    labelText: "Unit*",
                                                    readOnly: false,
                                                    textInputType:
                                                        TextInputType.number,
                                                    maxLength: 4,
                                                    fontSize: 18,
                                                    onChanged:
                                                        (String, bool) {},
                                                  ),
                                                ),
                                                const SizedBox(
                                                  width: 15,
                                                ),
                                                SizedBox(
                                                  height:
                                                      MediaQuery.sizeOf(context)
                                                              .height *
                                                          0.04,
                                                  width:
                                                      MediaQuery.sizeOf(context)
                                                              .width *
                                                          0.20,
                                                  child:
                                                      CustomeEditTextWithBorder(
                                                    lablekey: 'MAWB',
                                                    hasIcon: false,
                                                    hastextcolor: true,
                                                    animatedLabel: true,
                                                    needOutlineBorder: true,
                                                    labelText: "Group Id*",
                                                    readOnly: false,
                                                    textInputType:
                                                        TextInputType.number,
                                                    maxLength: 4,
                                                    fontSize: 18,
                                                    onChanged:
                                                        (String, bool) {},
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height:
                                            MediaQuery.sizeOf(context).height *
                                                0.02,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          SizedBox(
                                            width: MediaQuery.sizeOf(context)
                                                    .width *
                                                0.44,
                                            child: CustomeEditTextWithBorder(
                                              lablekey: 'MAWB',
                                              hasIcon: false,
                                              hastextcolor: true,
                                              animatedLabel: true,
                                              needOutlineBorder: true,
                                              labelText: "Commodity/Activity*",
                                              readOnly: false,
                                              maxLength: 15,
                                              fontSize: 18,
                                              onChanged: (String, bool) {},
                                            ),
                                          ),
                                          SizedBox(
                                            width: MediaQuery.sizeOf(context)
                                                    .width *
                                                0.44,
                                            child: CustomeEditTextWithBorder(
                                              lablekey: 'MAWB',
                                              hasIcon: false,
                                              hastextcolor: true,
                                              animatedLabel: true,
                                              needOutlineBorder: true,
                                              labelText: "Agent Code - Name*",
                                              readOnly: false,
                                              maxLength: 15,
                                              fontSize: 18,
                                              onChanged: (String, bool) {},
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height:
                                            MediaQuery.sizeOf(context).height *
                                                0.02,
                                      ),
                                      Row(
                                        children: [
                                          const Text("   CAPTURE RECEIVED SHIPMENT"),
                                        ],
                                      ),
                                      SizedBox(
                                        height:
                                        MediaQuery.sizeOf(context).height *
                                            0.02,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          SizedBox(
                                            width: MediaQuery.sizeOf(context)
                                                    .width *
                                                0.44,
                                            child: Row(
                                              children: [
                                                SizedBox(
                                                  height:
                                                      MediaQuery.sizeOf(context)
                                                              .height *
                                                          0.04,
                                                  width:
                                                      MediaQuery.sizeOf(context)
                                                              .width *
                                                          0.1,
                                                  child:
                                                      CustomeEditTextWithBorder(
                                                    lablekey: 'MAWB',
                                                    hasIcon: false,
                                                    hastextcolor: true,
                                                    animatedLabel: true,
                                                    needOutlineBorder: true,
                                                    labelText: "Code*",
                                                    readOnly: false,
                                                    maxLength: 15,
                                                    fontSize: 18,
                                                    onChanged:
                                                        (String, bool) {},
                                                  ),
                                                ),
                                                const SizedBox(
                                                  width: 15,
                                                ),
                                                SizedBox(
                                                  height:
                                                      MediaQuery.sizeOf(context)
                                                              .height *
                                                          0.04,
                                                  width:
                                                      MediaQuery.sizeOf(context)
                                                              .width *
                                                          0.32,
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      SizedBox(
                                                        height:
                                                            MediaQuery.sizeOf(
                                                                        context)
                                                                    .height *
                                                                0.04,
                                                        width:
                                                            MediaQuery.sizeOf(
                                                                        context)
                                                                    .width *
                                                                0.15,
                                                        child:
                                                            CustomeEditTextWithBorder(
                                                          lablekey: 'MAWB',
                                                          hasIcon: false,
                                                          hastextcolor: true,
                                                          animatedLabel: true,
                                                          needOutlineBorder:
                                                              true,
                                                          labelText:
                                                              "Flight No*",
                                                          readOnly: false,
                                                          maxLength: 15,
                                                          fontSize: 18,
                                                          onChanged:
                                                              (String, bool) {},
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        width: 10,
                                                      ),
                                                      SizedBox(
                                                        height:
                                                            MediaQuery.sizeOf(
                                                                        context)
                                                                    .height *
                                                                0.04,
                                                        width:
                                                            MediaQuery.sizeOf(
                                                                        context)
                                                                    .width *
                                                                0.15,
                                                        child:
                                                            CustomeEditTextWithBorderDatePicker(
                                                          lablekey: 'MAWB',
                                                          // controller: flightDateController,

                                                          labelText:
                                                              "Flight Date*",
                                                          readOnly: false,
                                                          maxLength: 15,
                                                          fontSize: 18,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            width: MediaQuery.sizeOf(context)
                                                    .width *
                                                0.45,
                                            child: Row(
                                              children: [
                                                SizedBox(
                                                  height:
                                                      MediaQuery.sizeOf(context)
                                                              .height *
                                                          0.04,
                                                  width:
                                                      MediaQuery.sizeOf(context)
                                                              .width *
                                                          0.22,
                                                  child:
                                                      CustomeEditTextWithBorder(
                                                    lablekey: 'MAWB',
                                                    hasIcon: false,
                                                    hastextcolor: true,
                                                    animatedLabel: true,
                                                    needOutlineBorder: true,
                                                    labelText: "ULD*",
                                                    readOnly: false,
                                                    maxLength: 15,
                                                    fontSize: 18,
                                                    onChanged:
                                                        (String, bool) {},
                                                  ),
                                                ),
                                                const SizedBox(
                                                  width: 15,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height:
                                            MediaQuery.sizeOf(context).height *
                                                0.02,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          SizedBox(
                                            width: MediaQuery.sizeOf(context)
                                                    .width *
                                                0.44,
                                            child: CustomeEditTextWithBorder(
                                              lablekey: 'MAWB',
                                              hasIcon: false,
                                              hastextcolor: true,
                                              animatedLabel: true,
                                              needOutlineBorder: true,
                                              labelText: "Commodity Type",
                                              readOnly: false,
                                              maxLength: 15,
                                              fontSize: 18,
                                              onChanged: (String, bool) {},
                                            ),
                                          ),
                                          SizedBox(
                                            width: MediaQuery.sizeOf(context)
                                                    .width *
                                                0.45,
                                            child: Row(
                                              children: [
                                                SizedBox(
                                                  height:
                                                      MediaQuery.sizeOf(context)
                                                              .height *
                                                          0.04,
                                                  width:
                                                      MediaQuery.sizeOf(context)
                                                              .width *
                                                          0.22,
                                                  child:
                                                      CustomeEditTextWithBorder(
                                                    lablekey: 'MAWB',
                                                    hasIcon: false,
                                                    hastextcolor: true,
                                                    animatedLabel: true,
                                                    needOutlineBorder: true,
                                                    labelText: "FIRMS Code",
                                                    readOnly: false,
                                                    maxLength: 15,
                                                    fontSize: 18,
                                                    onChanged:
                                                        (String, bool) {},
                                                  ),
                                                ),
                                                const SizedBox(
                                                  width: 15,
                                                ),
                                                SizedBox(
                                                  height:
                                                      MediaQuery.sizeOf(context)
                                                              .height *
                                                          0.04,
                                                  width:
                                                      MediaQuery.sizeOf(context)
                                                              .width *
                                                          0.20,
                                                  child:
                                                      CustomeEditTextWithBorder(
                                                    lablekey: 'MAWB',
                                                    hasIcon: false,
                                                    hastextcolor: true,
                                                    animatedLabel: true,
                                                    needOutlineBorder: true,
                                                    labelText:
                                                        "Disposition Code*",
                                                    readOnly: false,
                                                    maxLength: 15,
                                                    fontSize: 18,
                                                    onChanged:
                                                        (String, bool) {},
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                )

                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.sizeOf(context).height * 0.015,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12.0),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                spreadRadius: 2,
                                blurRadius: 8,
                                offset: const Offset(
                                    0, 3), // changes position of shadow
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 14, horizontal: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(
                                      height: 45,
                                      width: MediaQuery.sizeOf(context).width *
                                          0.42,
                                      child: OutlinedButton(
                                        style: OutlinedButton.styleFrom(
                                          side: const BorderSide(
                                              color: MyColor.primaryColorblue),
                                          textStyle: const TextStyle(
                                            fontSize: 18,
                                            color: MyColor.primaryColorblue,
                                          ),
                                          shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(8)),
                                          ),
                                        ),
                                        onPressed: () {},
                                        child: const Text("Cancel"),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    SizedBox(
                                      height: 45,
                                      width: MediaQuery.sizeOf(context).width *
                                          0.42,
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              MyColor.primaryColorblue,
                                          textStyle: const TextStyle(
                                            fontSize: 18,
                                            color: Colors.white,
                                          ),
                                          shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(8)),
                                          ),
                                        ),
                                        onPressed: () {},
                                        child: const Text(
                                          "Save",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
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
        floatingActionButton: Theme(
          data: ThemeData(useMaterial3: false),
          child: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (_) => CreateShipment()));
            },
            backgroundColor: MyColor.primaryColorblue,
            child: const Icon(Icons.add),
          ),
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
