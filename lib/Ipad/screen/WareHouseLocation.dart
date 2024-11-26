import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_svg/svg.dart';
import '../../core/images.dart';
import '../../core/mycolor.dart';
import '../../module/import/model/flightcheck/mailtypemodel.dart';
import '../../module/onboarding/sizeconfig.dart';
import '../../utils/commonutils.dart';
import '../../utils/sizeutils.dart';
import '../../utils/snackbarutil.dart';
import '../../widget/customeedittext/customeedittextwithborder.dart';
import '../../widget/custometext.dart';
import 'ImportShipmentListing.dart';

class WarehouseLocation extends StatefulWidget {
  const WarehouseLocation({super.key});

  @override
  State<WarehouseLocation> createState() =>
      _WarehouseLocationState();
}

class _WarehouseLocationState
    extends State<WarehouseLocation> {
  TextEditingController prefixController = TextEditingController();
  FocusNode mailTypeFocusNode = FocusNode();
  MailTypeList? selectedMailType;
  List<MailTypeList>? mailTypeList = [
    MailTypeList(referenceDataIdentifier: "A", referenceDescription: "A"),
    MailTypeList(referenceDataIdentifier: "B", referenceDescription: "B"),
  ];
  // TextEditingController prefixController = TextEditingController();
  // TextEditingController prefixController = TextEditingController();
  // TextEditingController prefixController = TextEditingController();
  // TextEditingController prefixController = TextEditingController();
  // TextEditingController prefixController = TextEditingController();
  // TextEditingController prefixController = TextEditingController();
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
                padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
                child: Material(
                  color: Colors.transparent,
                  // Ensures background transparency
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
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
                                  '  Warehouse Location',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold, fontSize: 22),
                                ),
                              ],
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
                                                        (String, bool) {

                                                    },
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
                                                    labelText: "HAWB No*",
                                                    readOnly: false,
                                                    maxLength: 8,
                                                    fontSize: 18,
                                                    onChanged:
                                                        (String, bool) {},
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 15,
                                                ),
                                                Container(
                                                  height:
                                                  MediaQuery.sizeOf(context)
                                                      .height *
                                                      0.04,
                                                  width:
                                                  MediaQuery.sizeOf(context)
                                                      .width *
                                                      0.1,

                                                  child: Column(
                                                    children: [
                                                      Container(

                                                        decoration: BoxDecoration(
                                                          borderRadius: BorderRadius.circular(4.0),
                                                          color: MyColor.primaryColorblue,
                                                        ),
                                                        padding: EdgeInsets.all(8),
                                                        child: Icon(Icons.search,
                                                            color: Colors.white,size: 32,),
                                                      ),

                                                    ],
                                                  ),

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
                                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                                        children: [
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              _buildDetailColumn('Declared Pcs', '10'),
                                              SizedBox(height: 20),
                                              _buildDetailColumn('Flight No.', 'BA1190'),

                                            ],
                                          ),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              _buildDetailColumn('Declared Weight', '100.00'),
                                              SizedBox(height: 20),
                                              _buildDetailColumn('Flight Date', '01 AUG 2024'),


                                            ],
                                          ),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              _buildDetailColumn('Accepted Pcs.', '10'),
                                              SizedBox(height: 20),
                                              _buildDetailColumn('Commodity', 'Commodity Name'),

                                            ],
                                          ),

                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              _buildDetailColumn('Accepted Wt.', '100.00'),
                                              SizedBox(height: 20),
                                              _buildDetailColumn('NOG', 'Mobile Phones'),

                                            ],
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
                                const Text("  Current Location",style: TextStyle(color: Colors.black,fontWeight: FontWeight.w800,fontSize: 20),),
                                const SizedBox(height: 10,),
                                Container(
                                  width: MediaQuery.sizeOf(context).width,
                                  color: const Color(0xffE4E7EB),
                                  padding: const EdgeInsets.all(2.0),
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: DataTable(
                                      columns: const [
                                        DataColumn(label: Text('Action')),
                                        DataColumn(label: Text('Group Id')),
                                        DataColumn(label: Text('Location')),
                                        DataColumn(label: Text('NOP')),
                                        DataColumn(label: Text('In Time')),

                                      ],
                                      rows:  [
                                        DataRow(cells: [
                                           DataCell(Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              InkWell(
                                                onTap: () {
                                                },
                                                child: Padding(padding: const EdgeInsets.all(2.0),
                                                  child: SvgPicture.asset(search, height: SizeConfig.blockSizeVertical * SizeUtils.ICONSIZE2,),
                                                ),
                                              ),
                                              const SizedBox(width: 16), // Space between icons
                                              InkWell(
                                                onTap: () {
                                                },
                                                child: Padding(padding: const EdgeInsets.all(2.0),
                                                  child: SvgPicture.asset(pen, height: SizeConfig.blockSizeVertical * SizeUtils.ICONSIZE2,),
                                                ),
                                              ),
                                              const SizedBox(width: 16),
                                              const Icon(
                                                Icons.delete,
                                                color: Colors.red,
                                                size: 30,
                                              ),
                                            ],
                                          ),),
                                          DataCell(SizedBox(
                                            height: 45,
                                            width: 150,
                                            child: TextFormField(
                                              decoration: InputDecoration(
                                                hintText: 'Location1',
                                                contentPadding:
                                                const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                  BorderRadius.circular(8),
                                                  borderSide: const BorderSide(
                                                    color: MyColor.borderColor,
                                                  ),
                                                ),
                                                enabledBorder:
                                                OutlineInputBorder(
                                                  borderRadius:
                                                  BorderRadius.circular(8),
                                                  borderSide: const BorderSide(
                                                    color: MyColor.borderColor,
                                                  ),
                                                ),
                                                focusedBorder:
                                                OutlineInputBorder(
                                                  borderRadius:
                                                  BorderRadius.circular(8),
                                                  borderSide: const BorderSide(
                                                    color: MyColor
                                                        .primaryColorblue,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          )),
                                          DataCell(SizedBox(
                                            height: 45,
                                            width: 150,
                                            child: TextFormField(
                                              decoration: InputDecoration(
                                                hintText: 'Group ID',
                                                contentPadding:
                                                const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                  BorderRadius.circular(8),
                                                  borderSide: const BorderSide(
                                                    color: MyColor.borderColor,
                                                  ),
                                                ),
                                                enabledBorder:
                                                OutlineInputBorder(
                                                  borderRadius:
                                                  BorderRadius.circular(8),
                                                  borderSide: const BorderSide(
                                                    color: MyColor.borderColor,
                                                  ),
                                                ),
                                                focusedBorder:
                                                OutlineInputBorder(
                                                  borderRadius:
                                                  BorderRadius.circular(8),
                                                  borderSide: const BorderSide(
                                                    color: MyColor
                                                        .primaryColorblue,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          )),
                                          DataCell(SizedBox(
                                            height: 45,
                                            width: 150,
                                            child: TextFormField(
                                              decoration: InputDecoration(
                                                hintText: '7',
                                                contentPadding:
                                                const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                  borderSide: const BorderSide(
                                                    color: MyColor.borderColor,
                                                  ),
                                                ),
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                  borderSide: const BorderSide(
                                                    color: MyColor.borderColor,
                                                  ),
                                                ),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                  borderSide: const BorderSide(
                                                    color: MyColor
                                                        .primaryColorblue,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          )), // Assuming "-" for empty cells
                                          const DataCell(Text('01 AUG 2024 09:30')),

                                        ]),
                                      ],
                                      headingRowColor:
                                      MaterialStateProperty.resolveWith((states) => Color(0xfff1f1f1)),
                                      dataRowColor:  MaterialStateProperty.resolveWith((states) => Color(0xfffafafa)),
                                      columnSpacing: MediaQuery.sizeOf(context).width*0.025,
                                      dataRowHeight: 48.0,

                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.sizeOf(context).height * 0.015,
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
  Widget _buildDetailColumn(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.grey[700],
          ),
        ),
        SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
