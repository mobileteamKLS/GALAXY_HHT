import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:galaxy/Ipad/modal/yard_checkin_modal.dart';
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
import '../../widget/customebuttons/roundbuttonblue.dart';
import '../../widget/customeedittext/customeedittextwithborder.dart';
import '../../widget/custometext.dart';
import '../auth/auth.dart';
import '../modal/warehouseLocationModal.dart';
import '../utils/global.dart';
import '../widget/customDialog.dart';
import 'ImportShipmentListing.dart';
import 'package:xml/xml.dart';

  class ManualYardCheckIn extends StatefulWidget {
  const ManualYardCheckIn({super.key});

  @override
  State<ManualYardCheckIn> createState() =>
      _ManualYardCheckInState();
}

class _ManualYardCheckInState
    extends State<ManualYardCheckIn> {
  TextEditingController prefixController = TextEditingController();
  TextEditingController vehicleNoController = TextEditingController();
  TextEditingController vtNoController = TextEditingController();
  final AuthService authService = AuthService();
  List<WarehouseLocationShipmentList> wareHouseShipmentList=[];
  List<WarehouseLocationList> wareHouseLocationList=[];
  List<TextEditingController> groupIdControllers = [];
  List<TextEditingController> locationControllers = [];
  List<TextEditingController> nopControllers = [];
  List<TextEditingController> weightControllers = [];
  List<VtDetails>vehicleTokensListDetails=[];
  List<bool> editStates = [];
  bool? isOn=false;
  List<bool?> isOnList = [];
  @override
  void initState() {
    super.initState();
  }

  void checkboxChanged(bool? value, int index) {
    setState(() {
      isOnList[index] = value;
      // if (value !=false) {
      //   saveList.removeWhere(
      //           (element) => element["item"] == forwardExamData[index]);
      //   saveList.add({"item": forwardExamData[index], "value": value});
      // } else {
      //   saveList.removeWhere(
      //           (element) => element["item"] == forwardExamData[index]);
      // }
    });
  }

  getTokenDetailsByVTNO() async {
    DialogUtils.showLoadingDialog(context);
    vehicleTokensListDetails = [];


    var queryParams = {
      "OperationType": vtNoController.text.startsWith("I") ? "2" : "1", // modeType.toString(),
      "TokenNo": vtNoController.text.trim(),
      "OrganizationBranchId":"11239"
    };
    await Global()
        .getData(
      'submitVehicleTokenNo',
      queryParams,
    )
        .then((response) {
      print("data received ");
      print("----${json.decode(response.body)['ResponseObject']}");
      Map<String, dynamic> jsonResponse = json.decode(response.body);
      List<dynamic> responseObjectList = jsonResponse['ResponseObject'];
      if(responseObjectList.first["errorMsg"]!=null){
        print( responseObjectList.first["errorMsg"]);
        DialogUtils.hideLoadingDialog(context);
        showDataNotFoundDialog(context, responseObjectList.first["errorMsg"]);
        return;
      }
      setState(() {
        vehicleTokensListDetails = responseObjectList.map((e) => VtDetails.fromVTJson(e)).toList();
        isOnList = List.generate(vehicleTokensListDetails.length, (index) => false);
        print(
            "length  = ${vehicleTokensListDetails.length}");

      });
      DialogUtils.hideLoadingDialog(context);
    }).catchError((onError) {
      setState(() {
        DialogUtils.hideLoadingDialog(context);
      });
      print(onError);
    });
  }

  getTokenDetailsByVehicleNo() async {
      DialogUtils.showLoadingDialog(context);
    vehicleTokensListDetails = [];
    var queryParams = {
      "OperationType": "1",
      "VehicleNo": vehicleNoController.text.trim(),
      "OrganizationBranchId":"11239"
    };
    await Global()
        .getData(
      'submitVehicleNo',
      queryParams,
    )
        .then((response) {
      print("data received ");
      print(json.decode(response.body)['ResponseObject']);
      Map<String, dynamic> jsonResponse = json.decode(response.body);
      List<dynamic> responseObjectList = jsonResponse['ResponseObject'];
      setState(() {
        vehicleTokensListDetails = responseObjectList.map((e) => VtDetails.fromVehicleNoJson(e)).toList();
        isOnList = List.generate(vehicleTokensListDetails.length, (index) => false);
        print(
            "length  = ${vehicleTokensListDetails.length}");
        DialogUtils.hideLoadingDialog(context);
      });
    }).catchError((onError) {
      DialogUtils.hideLoadingDialog(context);
      print(onError);
    });
  }

  String buildInputXmlSaveUpdate({
    required List<WarehouseLocationList> wareHouseLocationList,
    required String iSId,
    required String iWSeqNo,
    required String companyCode,
    required String userId,
    required String airportCity,
    required String mode,
  }) {
    final builder = XmlBuilder();
    builder.element('LOCS', nest: () {
      //.where((w) => w.iwSeqNo == 0)
      for (var item in wareHouseLocationList) {
        builder.element('LOC', nest: () {
          builder.element('LocCode', nest: item.locCode);
          builder.element('NOP', nest: item.nop.toString());
          builder.element('Weight', nest: item.weight.toStringAsFixed(2));
          builder.element('Volume', nest: '0');
          builder.element('GroupId', nest: item.groupId);
        });
      }
    });


    final xmlDocument = builder.buildDocument();
    return xmlDocument.toXmlString(pretty: true, indent: '  ');
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

  searchVehicleDetails(){
    if(vehicleNoController.text.isEmpty && vtNoController.text.isEmpty){
      showDataNotFoundDialog(context, "Please enter Vehicle No. or VT No.");
      return;
    }
    if(vehicleNoController.text.isEmpty){
      getTokenDetailsByVTNO();
    }
    else{
      getTokenDetailsByVehicleNo();
    }
  }

  resetData(){
    prefixController.clear();
    vehicleNoController.clear();
    vtNoController.clear();
    wareHouseLocationList=[];
    wareHouseShipmentList=[];
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
                  '  Easy Yard Check-In',
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
                                  '  Yard Check-In',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold, fontSize: 22),
                                ),
                              ],
                            ),
                            GestureDetector(
                              child: const Row(
                                children: [Icon(CupertinoIcons.restart, color: MyColor.primaryColorblue,),
                                  Text(
                                    ' Reset',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500, fontSize: 18,color: MyColor.primaryColorblue,),
                                  ),],
                              ),
                              onTap: (){
                                setState(() {
                                  resetData();
                                });

                              },
                            )
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
                                          Container(

                                            width: MediaQuery.sizeOf(context)
                                                .width *
                                                0.39,
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
                                                      0.30,
                                                  child:
                                                  CustomeEditTextWithBorder(
                                                    lablekey: 'MAWB',
                                                    hasIcon: false,
                                                    controller: vehicleNoController,
                                                    hastextcolor: true,
                                                    animatedLabel: true,
                                                    textInputType:
                                                    TextInputType.number,
                                                    needOutlineBorder: true,
                                                    labelText: "Vehicle No",
                                                    onPress: () {},
                                                    readOnly: false,
                                                    maxLength: 16,
                                                    fontSize: 18,
                                                    onChanged:
                                                        (String, bool) {},
                                                  ),
                                                ),
                                                const SizedBox(
                                                  width: 15,
                                                ),
                                                InkWell(
                                                  onTap: () {
                                                    scanQRAWB(false);
                                                  },
                                                  child: Padding(
                                                    padding:
                                                    const EdgeInsets.all(
                                                        2.0),
                                                    child: SvgPicture.asset(
                                                      search,
                                                      height: SizeConfig
                                                          .blockSizeVertical *
                                                          SizeUtils.ICONSIZE2,
                                                    ),
                                                  ),
                                                ),
                                                const Text("   OR"),
                                              ],
                                            ),
                                          ),

                                          SizedBox(

                                            width: MediaQuery.sizeOf(context)
                                                .width *
                                                0.39,
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
                                                      0.30,
                                                  child:
                                                  CustomeEditTextWithBorder(
                                                    lablekey: 'MAWB',
                                                    controller: vtNoController,
                                                    hasIcon: false,
                                                    hastextcolor: true,
                                                    animatedLabel: true,
                                                    textInputType:
                                                    TextInputType.text,
                                                    needOutlineBorder: true,
                                                    labelText: "VT No",
                                                    readOnly: false,
                                                    maxLength: 18,
                                                    fontSize: 18,
                                                    onChanged:
                                                        (String, bool) {},
                                                  ),
                                                ),
                                                const SizedBox(
                                                  width: 15,
                                                ),
                                                InkWell(
                                                  onTap: () {
                                                    scanQRAWB(true);
                                                  },
                                                  child: Padding(
                                                    padding:
                                                    const EdgeInsets.all(
                                                        2.0),
                                                    child: SvgPicture.asset(
                                                      search,
                                                      height: SizeConfig
                                                          .blockSizeVertical *
                                                          SizeUtils.ICONSIZE2,
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  width: 20,
                                                ),

                                              ],
                                            ),
                                          ),
                                          GestureDetector(
                                            child: Container(
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
                                            onTap: (){
                                              print("Searc");
                                              searchVehicleDetails();
                                            },
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
                          width: double.infinity,
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
                                const Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text("  Vehicles",style: TextStyle(color: Colors.black,fontWeight: FontWeight.w800,fontSize: 20),),
                                  ],
                                ),
                                const SizedBox(height: 10,),
                               Container(
                                  width: MediaQuery.sizeOf(context).width,
                                  color: const Color(0xffE4E7EB),
                                  padding: const EdgeInsets.all(2.0),
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: DataTable(
                                      columns:  [
                                        DataColumn(label: Center(child: SizedBox(width: 20,child: Center(child: Text(''))))),
                                        DataColumn(label: Center(child: SizedBox(width: MediaQuery.sizeOf(context).width*0.15,child: Center(child: Text('Vehicle No.'))))),
                                        DataColumn(label: Center(child: SizedBox(width: MediaQuery.sizeOf(context).width*0.15,child: Center(child: Text('Mode'))))),
                                        DataColumn(label: Center(child: SizedBox(width: MediaQuery.sizeOf(context).width*0.15,child: Center(child: Text('Driver Name'))))),
                                        DataColumn(label: Center(child: SizedBox(width: MediaQuery.sizeOf(context).width*0.15,child: Center(child: Text('Time Slot'))))),


                                      ],
                                      rows:List.generate(
                                          vehicleTokensListDetails.length,
                                              (index) {
                                                return buildDataRow(
                                          data: vehicleTokensListDetails[index],
                                          isOn: isOnList[index],
                                          index: index,
                                          onCheckboxChanged: (value) =>
                                              checkboxChanged(value, index),
                                        );
                                          }),
                                      headingRowColor:
                                      MaterialStateProperty.resolveWith((states) =>Color(0xffE4E7EB)),
                                      dataRowColor:  MaterialStateProperty.resolveWith((states) => Color(0xfffafafa)),
                                      columnSpacing: MediaQuery.sizeOf(context).width*0.06,
                                      dataRowHeight: 56.0,
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
                                          Navigator.pop(context);
                                        },
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
                                        onPressed: () {
                                          // saveUpdateLocation();
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
  Future<void> scanNOP(TextEditingController nopController) async {
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
        nopController.clear();

        // WidgetsBinding.instance.addPostFrameCallback((_) {
        //   FocusScope.of(context).requestFocus(igmNoFocusNode);
        // });
      } else {
        String result = barcodeScanResult.replaceAll(" ", "");
        nopController.text=result.trim();


      }
    }
  }

  DataRow buildDataRow({
    required VtDetails data,
    required bool? isOn,
    required int index,
    required ValueChanged<bool?> onCheckboxChanged,
  }) {
    return DataRow(cells: [
      DataCell(Center(
          child: SizedBox(
            child: Center(
              child: Container(
                child: Theme(
                  data: ThemeData(useMaterial3: false),
                  child: Checkbox(
                    activeColor: isOn == null
                        ? Colors.red
                        : isOn!
                        ? Colors.green
                        : MyColor.primaryColorblue,
                    value: isOn,
                    onChanged: (bool? value) {
                      setState(() {
                        onCheckboxChanged(value!);
                      });
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(2),
                      side: BorderSide(
                        color: isOn == null
                            ? Colors.red
                            : isOn!
                            ? Colors.green
                            : MyColor.primaryColorblue,
                        width: 2,
                      ),
                    ),
                  ),

                ),
              ),
            ),))),
      DataCell(Center(child: SizedBox(width: MediaQuery.sizeOf(context).width*0.15,child: Center(child: Text(data.vehicleRegNo))))),
      DataCell(Center(child: SizedBox(width: MediaQuery.sizeOf(context).width*0.15,child: Center(child: Text(data.mode))))),
      DataCell(Center(child: SizedBox(width: MediaQuery.sizeOf(context).width*0.15,child: Center(child: Text(data.driverName))))),
      DataCell(Center(child: SizedBox(width: MediaQuery.sizeOf(context).width*0.15,child: Center(child: Text('${DateFormat('d MMM yyyy').format(DateTime.parse(data.slotDate))}\n ${DateTime.parse(data.timeStart).hour.toString().padLeft(2, '0')}:${DateTime.parse(data.timeStart).minute.toString().padLeft(2, '0')}-${DateTime.parse(data.timeEnd).hour.toString().padLeft(2, '0')}:${DateTime.parse(data.timeEnd).minute.toString().padLeft(2, '0')}'))))),
    ]);
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

  Future<void> scanQRAWB(bool isHawb) async {
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
        prefixController.clear();
        vehicleNoController.clear();
        // WidgetsBinding.instance.addPostFrameCallback((_) {
        //   FocusScope.of(context).requestFocus(igmNoFocusNode);
        // });
      } else {
        String result = barcodeScanResult.replaceAll(" ", "");
        if (isHawb) {
          vtNoController.text = result;
        } else {
          String prefix = result.substring(0, 3);
          String awb = result.substring(3);
          prefixController.text = prefix;
          vehicleNoController.text = awb;
        }
      }
    }
  }
}
