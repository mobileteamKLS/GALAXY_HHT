import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:galaxy/Ipad/screen/wdoListing.dart';
import 'package:intl/intl.dart';
import 'package:vibration/vibration.dart';
import '../../core/images.dart';
import '../../core/mycolor.dart';
import '../../module/import/model/flightcheck/mailtypemodel.dart';
import '../../module/onboarding/sizeconfig.dart';
import '../../utils/commonutils.dart';
import '../../utils/dialogutils.dart';
import '../../utils/sizeutils.dart';
import '../../utils/snackbarutil.dart';
import '../../widget/customeedittext/customeedittextwithborder.dart';
import '../auth/auth.dart';
import '../modal/VehicleTrack.dart';
import '../modal/wdoModal.dart';
import '../utils/global.dart';
import '../widget/customDialog.dart';
import 'ImportShipmentListing.dart';

class DockOut extends StatefulWidget {
  const DockOut({super.key});

  @override
  State<DockOut> createState() => _DockOutState();
}

class _DockOutState extends State<DockOut> {
  FocusNode mailTypeFocusNode = FocusNode();
  MailTypeList? selectedMailType;
  final AuthService authService = AuthService();
  late List<VctDetails> vctDetailsList=[];
  TextEditingController vctController = TextEditingController();
  bool isDockOutDone=false;

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
                                  '  Dock Out',
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
                                                    controller: vctController,
                                                    needOutlineBorder: true,
                                                    labelText: "VCT No*",
                                                    readOnly: false,
                                                    onPress: () {},
                                                    maxLength: 20,
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
                                                    searchVCTDetails();
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
                                                    scanVCT();
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
                                              .width *0.45,
                                          child: Container(
                                            height: 50,
                                            color: Color(0xffE4E7EB),
                                            child: const Center(
                                              child: Text(
                                                  'Vehicle No.',
                                                  style:
                                                  TextStyle(
                                                      fontWeight: FontWeight.w600,
                                                      fontSize: 20,
                                                      color: Color(0xff3E4C5A))),
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
                                                  'Driver Name',
                                                  style:
                                                  TextStyle(
                                                      fontWeight: FontWeight.w600,
                                                      fontSize: 20,
                                                      color: Color(0xff3E4C5A))),
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
                                              child:  Center(
                                                child: Text(
                                                    "${vctDetailsList.isNotEmpty ? vctDetailsList.first.vehicleNo ?? "" : ""}",
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
                                              child:  Center(
                                                child: Text(
                                                    "${vctDetailsList.isNotEmpty ? vctDetailsList.first.driverName ?? "" : ""}",
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
                                                      fontSize: 20,
                                                      color: Color(0xff3E4C5A))),
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
                                                      fontSize: 20,
                                                      color: Color(0xff3E4C5A))),
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
                                              child:  Center(
                                                child: Text(
                                                    "${vctDetailsList.isNotEmpty ? vctDetailsList.first.pieces ?? "" : ""}",
                                                    style:
                                                    const TextStyle(
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
                                              child:  Center(
                                                child: Text(
                                                    vctDetailsList.isNotEmpty ? vctDetailsList.first.weight.toStringAsFixed(2) ?? "" : "",
                                                    style:
                                                    const TextStyle(
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
                                          clearDetails();
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
                                          backgroundColor:isDockOutDone?MyColor.textColorGrey2:
                                          MyColor.primaryColorblue,
                                          textStyle:  TextStyle(
                                            fontSize: 18,
                                            color:isDockOutDone? MyColor.textColorGrey3: Colors.white,
                                          ),
                                          shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(8)),
                                          ),
                                        ),
                                        onPressed: () {
                                          if(!isDockOutDone){
                                            saveShipmentDetails();
                                          }

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

  Future<void> scanVCT() async {
    String barcodeScanResult = await FlutterBarcodeScanner.scanBarcode(
      '#ff6666',
      'Cancel',
      true,
      ScanMode.DEFAULT, // Scan mode
    );

    print("barcode scann ==== ${barcodeScanResult}");
    if (barcodeScanResult == "-1") {
    } else {
      bool specialCharAllow =
      CommonUtils.containsSpecialCharactersAndAlpha(barcodeScanResult);

      print("SPECIALCHAR_ALLOW ===== ${specialCharAllow}");

      if (false) {
        SnackbarUtil.showSnackbar(
            context, "Only numeric values are accepted.", MyColor.colorRed,
            icon: FontAwesomeIcons.times);
        Vibration.vibrate(duration: 500);
        vctController.clear();

        // WidgetsBinding.instance.addPostFrameCallback((_) {
        //   FocusScope.of(context).requestFocus(igmNoFocusNode);
        // });
      } else {
        String result = barcodeScanResult.replaceAll(" ", "");
        vctController.text=result.trim();
        searchVCTDetails();

      }
    }
  }

  clearDetails(){
    vctController.clear();
    setState(() {
      vctDetailsList=[];
    });
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

  searchVCTDetails() async{
    DialogUtils.showLoadingDialog(context);
    vctDetailsList=[];
    doorList=[];
    var queryParams = {
      "InputXml":"<Root><VCTNo>${vctController.text.trim()}</VCTNo><CompanyCode>3</CompanyCode><UserId>${userId.toString()}</UserId><AirportCity>JFK</AirportCity><Culture>en-US</Culture></Root>"
    };
    await authService
        .sendGetWithBody(
      "VCTDetails/GetVCTDetails",
      queryParams,
    )
        .then((response) {
      print("data received ");
      Map<String, dynamic> jsonData = json.decode(response.body);
      List<dynamic> resp = jsonData['VCTSearchList'];
      List<dynamic> door = jsonData['DoorList'];
      print(jsonData);

      String status = jsonData["VCTDockInOut"][0]['Status'];
      String statusMessage = jsonData["VCTDockInOut"][0]['StatusMessage']??"";
      if (status != 'S') {
        print("Error: $statusMessage");
        DialogUtils.hideLoadingDialog(context);
        showDataNotFoundDialog(context, statusMessage);
        return;
      }
      else{
        setState(() {
          vctDetailsList=resp.map((json) => VctDetails.fromJson(json)).toList();
          doorList=door
              .where((json) {
            return json["Value"] != "-1";
          }).map((json) => Door.fromJson(json)).toList();
          print("Door len ${doorList.length}");
          if(vctDetailsList.first.dockout=="Y"){
            isDockOutDone=true;
          }
          else{
            isDockOutDone=false;
          }
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
    if (vctController.text.isEmpty) {
      showDataNotFoundDialog(context, "VCT No. is required.");
      return;
    }



    final now = DateTime.now();
    final formatter = DateFormat('MM/dd/yyyy HH:mm');
    var queryParams = {
      "InputXml": "<Root><DockInOut>O</DockInOut><TokenNo>${vctController.text.trim()}</TokenNo><DockInDateTime>${formatter.format(now)}</DockInDateTime><IsTruckSealed>Y</IsTruckSealed><Door></Door><CompanyCode>3</CompanyCode><UserId>${userId.toString()}</UserId><AirportCity>JFK</AirportCity><Culture>en-US</Culture></Root>"
    };
    DialogUtils.showLoadingDialog(context);
    await authService
        .postData(
      "VCTDetails/DockInOut",
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
            searchVCTDetails();
            // Navigator.pushReplacement(context,
            //     MaterialPageRoute(builder: (context) => const WdoListing()));
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
