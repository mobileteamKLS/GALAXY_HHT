import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:galaxy/Ipad/screen/wdoListing.dart';
import '../../core/images.dart';
import '../../core/mycolor.dart';
import '../../module/import/model/flightcheck/mailtypemodel.dart';
import '../../module/onboarding/sizeconfig.dart';
import '../../utils/dialogutils.dart';
import '../../utils/sizeutils.dart';
import '../../widget/customeedittext/customeedittextwithborder.dart';
import '../auth/auth.dart';
import '../modal/wdoModal.dart';
import '../utils/global.dart';
import '../widget/customDialog.dart';
import 'ImportShipmentListing.dart';

class DockIn extends StatefulWidget {
  const DockIn({super.key});

  @override
  State<DockIn> createState() => _DockInState();
}

class _DockInState extends State<DockIn> {
  FocusNode mailTypeFocusNode = FocusNode();
  MailTypeList? selectedMailType;
  final AuthService authService = AuthService();

  TextEditingController prefixController = TextEditingController();
  TextEditingController awbController = TextEditingController();
  TextEditingController hawbController = TextEditingController();
  TextEditingController nopController = TextEditingController();
  TextEditingController customRefController = TextEditingController();
  late List<WdoSearchResult> wdoDetailsList=[];
  bool isWDOGenerated=false;
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
                                  '  Dock In',
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
                                vertical: 14, horizontal: 14),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height:
                                  MediaQuery.sizeOf(context).height * 0.007,
                                ),
                                const Text(
                                  ' ENTER OR SCAN VEHICLE TOKEN NUMBER',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 18),
                                ),
                                SizedBox(
                                  height:
                                  MediaQuery.sizeOf(context).height * 0.015,
                                ),
                                SizedBox(
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.start,
                                        children: [

                                          SizedBox(
                                            width: MediaQuery.sizeOf(context)
                                                .width *
                                                0.8,
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
                                                      0.38,
                                                  child:
                                                  CustomeEditTextWithBorder(
                                                    lablekey: 'MAWB',
                                                    hasIcon: false,
                                                    hastextcolor: true,
                                                    animatedLabel: true,
                                                    controller: hawbController,
                                                    needOutlineBorder: true,
                                                    labelText: "VCT No*",
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
                                                Container(
                                                  height: MediaQuery.sizeOf(context)
                                                      .height *
                                                      0.04,
                                                  margin: EdgeInsets.symmetric(horizontal: 5),
                                                  child: Center(
                                                    child: Text("or  ",style: TextStyle(fontSize: 18),),
                                                  ),
                                                ),
                                                InkWell(
                                                  onTap: () {
                                                    // scanQRAWB(true);
                                                  },
                                                  child: Padding(
                                                    padding:
                                                    const EdgeInsets.all(
                                                        2.0),
                                                    child: SvgPicture.asset(
                                                      search,
                                                      height: SizeConfig
                                                          .blockSizeVertical *
                                                          3.2,
                                                    ),
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
                                            0.01,
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
                                vertical: 14, horizontal: 14),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      width:
                                      MediaQuery.sizeOf(context).width * 0.44,
                                      child: const Text(
                                        'VEHICLE DETAILS',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 18),
                                      ),
                                    ),

                                  ],
                                ),
                                Column(
                                  children: [
                                    SizedBox(height: 20),
                                    Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment
                                          .spaceBetween,
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          width:
                                          MediaQuery.of(context)
                                              .size
                                              .width *0.29,
                                          child: Container(
                                            height: 50,
                                            color: Color(0xffE4E7EB),
                                            child: const Center(
                                              child: Text(
                                                  'Vehicle No.',
                                                  style:
                                                  TextStyle(
                                                      fontWeight: FontWeight.w600,
                                                      fontSize: 22)),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width:
                                          MediaQuery.of(context)
                                              .size
                                              .width *0.29,
                                          child: Container(
                                            height: 50,
                                            color: Color(0xffE4E7EB),
                                            child: const Center(
                                              child: Text(
                                                  'Driver Name',
                                                  style:
                                                  TextStyle(
                                                      fontWeight: FontWeight.w600,
                                                      fontSize: 22)),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width:
                                          MediaQuery.of(context)
                                              .size
                                              .width *0.29,
                                          child: Container(
                                            height: 50,
                                            color: Color(0xffE4E7EB),
                                            child: const Center(
                                              child: Text(
                                                  'Door',
                                                  style:
                                                  TextStyle(
                                                      fontWeight: FontWeight.w600,
                                                      fontSize: 22)),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment
                                          .spaceBetween,
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          width:
                                          MediaQuery.of(context)
                                              .size
                                              .width *0.29,
                                          child: Container(
                                            color: const Color(0xffE4E7EB),
                                            child: Container(
                                              height: 50,
                                              color: Color(0xffFAFAFA),
                                              margin: EdgeInsets.all(1.5),
                                              child: const Center(
                                                child: Text(
                                                    "1234",
                                                    style:
                                                    TextStyle(
                                                        fontWeight: FontWeight.w600,
                                                        fontSize: 22)),
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width:
                                          MediaQuery.of(context)
                                              .size
                                              .width *0.29,
                                          child: Container(
                                            color: const Color(0xffE4E7EB),
                                            child: Container(
                                              height: 50,
                                              margin: EdgeInsets.all(1.5),
                                              color: Color(0xffFAFAFA),
                                              child: const Center(
                                                child: Text(
                                                    "ABC",
                                                    style:
                                                    TextStyle(
                                                        fontWeight: FontWeight.w600,
                                                        fontSize: 22)),
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width:
                                          MediaQuery.of(context)
                                              .size
                                              .width *0.29,
                                          child: Container(
                                            color: const Color(0xffE4E7EB),
                                            child: Container(
                                              height: 50,
                                              margin: EdgeInsets.all(1.5),
                                              color:Color(0xffFAFAFA),
                                              child: const Center(
                                                child: Text(
                                                    "123",
                                                    style:
                                                    TextStyle(
                                                        fontWeight: FontWeight.w600,
                                                        fontSize: 22)),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 20),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Column(
                                  children: [

                                    Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment
                                          .spaceBetween,
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          width:
                                          MediaQuery.of(context)
                                              .size
                                              .width *0.45,
                                          child: Container(
                                            height: 50,
                                            color: Color(0xffE4E7EB),
                                            child: const Center(
                                              child: Text(
                                                  'Pieces',
                                                  style:
                                                  TextStyle(
                                                      fontWeight: FontWeight.w600,
                                                      fontSize: 22)),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width:
                                          MediaQuery.of(context)
                                              .size
                                              .width *0.45,
                                          child: Container(
                                            height: 50,
                                            color: Color(0xffE4E7EB),
                                            child: const Center(
                                              child: Text(
                                                  'Weight (Kg)',
                                                  style:
                                                  TextStyle(
                                                      fontWeight: FontWeight.w600,
                                                      fontSize: 22)),
                                            ),
                                          ),
                                        ),

                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment
                                          .spaceBetween,
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          width:
                                          MediaQuery.of(context)
                                              .size
                                              .width *0.45,
                                          child: Container(
                                            color: const Color(0xffE4E7EB),
                                            child: Container(
                                              height: 50,
                                              color: Color(0xffFAFAFA),
                                              margin: EdgeInsets.all(1.5),
                                              child: const Center(
                                                child: Text(
                                                    "10",
                                                    style:
                                                    TextStyle(
                                                        fontWeight: FontWeight.w600,
                                                        fontSize: 22)),
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width:
                                          MediaQuery.of(context)
                                              .size
                                              .width *0.45,
                                          child: Container(
                                            color: const Color(0xffE4E7EB),
                                            child: Container(
                                              height: 50,
                                              margin: EdgeInsets.all(1.5),
                                              color: Color(0xffFAFAFA),
                                              child: const Center(
                                                child: Text(
                                                    "1000.00",
                                                    style:
                                                    TextStyle(
                                                        fontWeight: FontWeight.w600,
                                                        fontSize: 22)),
                                              ),
                                            ),
                                          ),
                                        ),

                                      ],
                                    ),
                                    SizedBox(height: 20),
                                  ],
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
                                        onPressed: () {
                                          //Navigator.pop(context);
                                        },
                                        child: const Text("Clear"),
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
                                        onPressed: () {

                                        },
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

  void showDataNotFoundDialog(BuildContext context, String message,{String status = "E"}) {
    showDialog(
      context: context,
      builder: (BuildContext context) => CustomAlertMessageDialogNew(
        description: message,
        buttonText: "Okay",
        imagepath:status=="E"?'assets/images/warn.gif': 'assets/images/successchk.gif',
        isMobile: false,
      ),
    );
  }

  searchWDODetails() async{
    DialogUtils.showLoadingDialog(context);
    nopController.clear();
    customRefController.clear();
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
        if(wdoDetailsList.first.status=="Generated"){
          setState(() {
            isWDOGenerated=true;
          });
        }
        else{
          setState(() {
            isWDOGenerated=false;
          });
        }
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
    if(isWDOGenerated){
      showDataNotFoundDialog(context, "WDO number is already generated.");
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
        .then((response) async {
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
          bool isTrue=await showDialog(
            context: context,
            builder: (BuildContext context) => CustomAlertMessageDialogNew(
              description: "$statusMessage",
              buttonText: "Okay",
              imagepath:'assets/images/successchk.gif',
              isMobile: false,
            ),
          );
          if(isTrue){
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => const WdoListing()));
          }
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
