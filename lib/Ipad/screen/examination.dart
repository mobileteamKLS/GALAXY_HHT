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

class Examination extends StatefulWidget {
  const Examination({super.key});

  @override
  State<Examination> createState() =>
      _ExaminationState();
}

class _ExaminationState
    extends State<Examination> {
  TextEditingController prefixController = TextEditingController();
  FocusNode mailTypeFocusNode = FocusNode();
  MailTypeList? selectedMailType;
  bool value=false;
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
                                  '  Forward For Examination',
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
                                  child: Row(
                                    children: [
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                width: MediaQuery.sizeOf(context)
                                                    .width *
                                                    0.44,
                                                child: const Text("  Request For Examination",style: TextStyle(color: Colors.black,fontWeight: FontWeight.w800,fontSize: 20),),

                                              ),

                                            ],
                                          ),
                                          SizedBox(
                                            height:
                                            MediaQuery.sizeOf(context).height *
                                                0.01,
                                          ),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: [
                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  _buildDetailColumn('   AWB No.', '   12598745632'),
                                                  const SizedBox(height: 20),
                                                ],
                                              ),
                                              SizedBox(
                                                width: 80,
                                              ),
                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  _buildDetailColumn('HAWB No', 'H123'),
                                                  const SizedBox(height: 20),
                                                ],
                                              ),
                                              SizedBox(
                                                width: 80,
                                              ),
                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  _buildDetailColumn('Remarks', 'Remarks test'),
                                                  SizedBox(height: 20),


                                                ],
                                              ),

                                            ],
                                          ),

                                        ],
                                      ),
                                      Spacer(),

                                      Container(


                                        child: Column(
                                          children: [
                                            Container(
                                              width:
                                              MediaQuery.sizeOf(context)
                                                  .width *
                                                  0.18,
                                              height: MediaQuery.sizeOf(context)
                                                  .height *
                                                  0.08,
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(4.0),
                                                color: MyColor.borderColor,
                                              ),
                                              padding: EdgeInsets.all(8),
                                              child:  Center(child: Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  const Text("10",style: TextStyle(color: Colors.black,fontWeight: FontWeight.w800,fontSize: 32),),
                                                  const Text("Exam Pieces",style: TextStyle(color: Colors.black,fontWeight: FontWeight.w800,fontSize: 18),),
                                                ],
                                              )),

                                            ),

                                          ],
                                        ),

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
                                const Text("  Forward For Examination",style: TextStyle(color: Colors.black,fontWeight: FontWeight.w800,fontSize: 20),),
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
                                        labelText: "Custom Ref. No.",
                                        // controller: originController,
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
                                        labelText: "Custom Ref. No.",
                                        // controller: destinationController,
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
                                          0.44,
                                      child: CustomeEditTextWithBorder(
                                        lablekey: 'MAWB',
                                        hasIcon: false,
                                        hastextcolor: true,
                                        animatedLabel: true,
                                        needOutlineBorder: true,
                                        labelText: "Remark",
                                        // controller: originController,
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
                                        labelText: "Exam Location",
                                        // controller: destinationController,
                                        readOnly: false,
                                        maxLength: 15,
                                        fontSize: 18,
                                        onChanged: (String, bool) {},
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: MediaQuery.sizeOf(context).height * 0.015,
                                ),
                                Container(
                                  width: MediaQuery.sizeOf(context).width,
                                  color: const Color(0xffE4E7EB),
                                  padding: const EdgeInsets.all(2.0),
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: DataTable(
                                      columns:  [

                                        DataColumn(label: Text('Group Id')),
                                        DataColumn(label: Text('Location')),
                                        DataColumn(label: Text('NOP')),
                                        DataColumn(label: Text('Exam Pieces')),
                                        DataColumn(label: Center(
                                          child: Checkbox(
                                            value: value,
                                            onChanged: (bool? newValue) {
                                              setState(() {
                                                value = newValue!;
                                              });
                                            },
                                          ),
                                        ),),

                                      ],
                                      rows:  [
                                        DataRow(cells: [
                                          const DataCell(Text('Group Id 1')),
                                          const DataCell(Text('Location1')),
                                          const DataCell(Text('7')),
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
                                           DataCell(Checkbox(
                                            tristate: true, // Example with tristate
                                            value: value,
                                            onChanged: (bool? newValue) {
                                              setState(() {
                                                value = newValue!;
                                              });
                                            },
                                          ),)

                                        ]),
                                      ],
                                      headingRowColor:
                                      MaterialStateProperty.resolveWith((states) => Color(0xfff1f1f1)),
                                      dataRowColor:  MaterialStateProperty.resolveWith((states) => Color(0xfffafafa)),
                                      columnSpacing: MediaQuery.sizeOf(context).width*0.12,
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
                                SizedBox(
                                  height: 45,
                                  width: MediaQuery.sizeOf(context).width ,
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
                                    onPressed: () {

                                    },
                                    child: const Text(
                                      "Forward For Examination",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
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
