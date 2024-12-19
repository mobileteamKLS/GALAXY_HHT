import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../core/images.dart';
import '../../core/mycolor.dart';
import '../../module/import/model/flightcheck/mailtypemodel.dart';
import '../../module/onboarding/sizeconfig.dart';
import '../../utils/dialogutils.dart';
import '../../utils/sizeutils.dart';
import '../../utils/snackbarutil.dart';
import '../../widget/customebuttons/roundbuttonblue.dart';
import '../../widget/customeedittext/customeedittextwithborder.dart';
import '../../widget/custometext.dart';
import '../auth/auth.dart';
import '../modal/wdoModal.dart';
import '../utils/global.dart';
import 'ImportShipmentListing.dart';

class CreateNewDO extends StatefulWidget {
  const CreateNewDO({super.key});

  @override
  State<CreateNewDO> createState() => _CreateNewDOState();
}

class _CreateNewDOState extends State<CreateNewDO> {
  FocusNode mailTypeFocusNode = FocusNode();
  MailTypeList? selectedMailType;
  final AuthService authService = AuthService();

  TextEditingController prefixController = TextEditingController();
  TextEditingController awbController = TextEditingController();
  TextEditingController hawbController = TextEditingController();
  TextEditingController nopController = TextEditingController();
  TextEditingController customRefController = TextEditingController();
  late List<WdoSearchResult> wdoDetailsList=[];
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
            actions: [
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
              // const SizedBox(
              //   width: 10,
              // ),
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
                                  '  Create New WDO',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 22),
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
                                                    controller: prefixController,
                                                    maxLength: 3,
                                                    textInputType:
                                                        TextInputType.number,
                                                    fontSize: 18,
                                                    onPress: () {},
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
                                                    controller: awbController,
                                                    onPress: () {},
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
                                                    controller: hawbController,
                                                    needOutlineBorder: true,
                                                    labelText: "HAWB No*",
                                                    readOnly: false,
                                                    onPress: () {},
                                                    maxLength: 8,
                                                    fontSize: 18,
                                                    onChanged:
                                                        (String, bool) {},
                                                  ),
                                                ),
                                                const SizedBox(
                                                  width: 15,
                                                ),
                                                GestureDetector(
                                                  child: SizedBox(
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
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        4.0),
                                                            color: MyColor
                                                                .primaryColorblue,
                                                          ),
                                                          padding:
                                                              EdgeInsets.all(8),
                                                          child: const Icon(
                                                            Icons.search,
                                                            color: Colors.white,
                                                            size: 32,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  onTap: (){
                                                    searchWDODetails();
                                                  },
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
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 8.0),
                                        child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8, vertical: 4),
                                            decoration: BoxDecoration(
                                              color: const Color(0xffFDEECF),
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            child:  Text(
                                              "WDO ${wdoDetailsList.isNotEmpty ? wdoDetailsList[0].status ?? "" : ""}",
                                              style: const TextStyle(
                                                  color: Colors.black87,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height:
                                            MediaQuery.sizeOf(context).height *
                                                0.02,
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 8.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                _buildDetailColumn('WDO Number',
                                                    wdoDetailsList.isNotEmpty ? wdoDetailsList[0].wdoNo ?? "" : ""),
                                                SizedBox(height: 20),
                                                _buildDetailColumn(
                                                    'Flight No.',wdoDetailsList.isNotEmpty ? (wdoDetailsList[0].flightDetails != null ? RegExp(r"^[A-Za-z]+\d+").stringMatch(wdoDetailsList[0].flightDetails) ?? "" : "") : ""),
                                              ],
                                            ),
                                            const SizedBox(
                                              width: 80,
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                _buildDetailColumn(
                                                    'Delivered NOP', "${wdoDetailsList.isNotEmpty ? wdoDetailsList[0].deliveredWdonop ?? "" : ""}"),
                                                SizedBox(height: 20),
                                                _buildDetailColumn(
                                                    'Flight Date',
                                                    "${wdoDetailsList.isNotEmpty ? (wdoDetailsList[0].flightDetails != null ? RegExp(r"(?<=\/).+").stringMatch(wdoDetailsList[0].flightDetails) ?? "" : "") : ""}"),
                                              ],
                                            ),
                                            const SizedBox(
                                              width: 80,
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                _buildDetailColumn(
                                                    'Prepared For Delivery',
                                                    "${wdoDetailsList.isNotEmpty ? wdoDetailsList[0].pfdDateTime ?? "" : ""}"),
                                                SizedBox(height: 20),
                                                _buildDetailColumn(
                                                    'Released', wdoDetailsList.isNotEmpty ? wdoDetailsList[0].releasedDateTime ?? "" : ""),
                                              ],
                                            ),
                                            SizedBox(
                                              width: 80,
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                _buildDetailColumn(
                                                    'Out of Warehouse', wdoDetailsList.isNotEmpty ? wdoDetailsList[0].outWhDateTime ?? "" : ""),
                                                SizedBox(height: 20),
                                                _buildDetailColumn(
                                                    'Re-warehouse', wdoDetailsList.isNotEmpty ? wdoDetailsList[0].reWhDateTime ?? "" : ""),
                                              ],
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
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                SizedBox(
                                  width:
                                      MediaQuery.sizeOf(context).width * 0.44,
                                  child: CustomeEditTextWithBorder(
                                    lablekey: 'MAWB',
                                    hasIcon: false,
                                    hastextcolor: true,
                                    animatedLabel: true,
                                    needOutlineBorder: true,
                                    controller: nopController,
                                    labelText: "NOP",
                                    onPress: () {},
                                    readOnly: true,
                                    maxLength: 15,
                                    fontSize: 18,
                                    onChanged: (String, bool) {},
                                  ),
                                ),
                                SizedBox(
                                  width:
                                      MediaQuery.sizeOf(context).width * 0.44,
                                  child: CustomeEditTextWithBorder(
                                    lablekey: 'MAWB',
                                    hasIcon: false,
                                    hastextcolor: true,
                                    textInputType:
                                    TextInputType.number,
                                    animatedLabel: true,
                                    needOutlineBorder: true,
                                    controller: customRefController,
                                    onPress: () {},
                                    labelText: "Custom Reference Number",
                                    readOnly: false,
                                    maxLength: 20,
                                    fontSize: 18,
                                    onChanged: (String, bool) {},
                                  ),
                                ),
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
                                SizedBox(
                                  height: 45,
                                  width: MediaQuery.sizeOf(context).width,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: MyColor.primaryColorblue,
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
                                      saveShipmentDetails();
                                    },
                                    child: const Text(
                                      "Generate",
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

  void showDataNotFoundDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: MyColor.colorWhite,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.cancel, color: MyColor.colorRed, size: 60),
              SizedBox(height: (MediaQuery.sizeOf(context).height / 100) * 2),
              CustomeText(
                text: message,
                fontColor: MyColor.colorBlack,
                fontSize: (MediaQuery.sizeOf(context).height / 100) * 1.6,
                fontWeight: FontWeight.w400,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: (MediaQuery.sizeOf(context).height / 100) * 2),
              RoundedButtonBlue(
                text: "Ok",
                color: MyColor.primaryColorblue,
                press: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  searchWDODetails() async{
    DialogUtils.showLoadingDialog(context);
    nopController.clear();
    var queryParams = {
      "AWBPrefix":prefixController.text.trim(),
      "AWBNo": awbController.text.trim(),
      "HAWBNO": ""
      // "AWBPrefix": "",
      // "AWBNo": "",
      // "HAWBNO": "",
      // "FromDate": "20-11-2024",
      // "ToDate": "02-12-2024"
    };
    await authService
        .sendGetWithBody(
      "WDO/WDOSearch",
      queryParams,
    )
        .then((response) {
      print("data received ");
      Map<String, dynamic> jsonData = json.decode(response.body);
       List<dynamic> resp = jsonData['WDOSearchList'];
      print(jsonData);
      if (jsonData.isEmpty) {

      }
      else{

      }
      String status = jsonData['Status'];
      String statusMessage = jsonData['StatusMessage']??"";
      if (status != 'S') {
        print("Error: $statusMessage");
        DialogUtils.hideLoadingDialog(context);
        showDataNotFoundDialog(context, statusMessage);
        return;
      }
      else{
        setState(() {
          wdoDetailsList=resp.map((json) => WdoSearchResult.fromJSON(json)).toList();
          nopController.text=wdoDetailsList.first.totWdonop.toString();
        });
      }
      DialogUtils.hideLoadingDialog(context);

    }).catchError((onError) {
      setState(() {

      });
      print(onError);
    });
  }

  saveShipmentDetails() async {
    if (prefixController.text.isEmpty) {
      showDataNotFoundDialog(context, "AWB Prefix is required.");
      return;
    }

    if (awbController.text.isEmpty) {
      showDataNotFoundDialog(context, "AWB No is required.");
      return;
    }

    if (customRefController.text.isEmpty) {
      showDataNotFoundDialog(context, "Custom reference is required.");
      return;
    }
    var queryParams = {
      "ArrayOfWDOObjects": "<ArrayOfWDOObjects><WDOObjects><IMPSHIPROWID>${wdoDetailsList.first.impShipRowId}</IMPSHIPROWID><ROTATION_NO>${customRefController.text}</ROTATION_NO><PKG_RECD>${nopController.text}</PKG_RECD><WT_RECD>${wdoDetailsList.first.wtRec}</WT_RECD></WDOObjects></ArrayOfWDOObjects>",
      "AirportCity": "JFK",
      "CompanyCode": "3",
      "UserId": "1"
    };
    DialogUtils.showLoadingDialog(context);
    await authService
        .postData(
      "WDO/GenerateWDO",
      queryParams,
    )
        .then((response) {
      print("data received ");
      Map<String, dynamic> jsonData = json.decode(response.body);
      String status = jsonData['Status'];
      String? statusMessage = jsonData['StatusMessage']??"";
      if(jsonData.isNotEmpty){
        DialogUtils.hideLoadingDialog(context);
        if(status!="S"){
          showDataNotFoundDialog(context, statusMessage!);
        }
        if((status=="S")){
          SnackbarUtil.showSnackbar(context, "Shipment Saved successfully", Color(0xff43A047));
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const ImportShipmentListing()));
        }

      }
    }).catchError((onError) {

      print(onError);
    });
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
