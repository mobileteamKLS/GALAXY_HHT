import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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

class WarehouseLocation extends StatefulWidget {
  const WarehouseLocation({super.key});

  @override
  State<WarehouseLocation> createState() =>
      _WarehouseLocationState();
}

class _WarehouseLocationState
    extends State<WarehouseLocation> {
  TextEditingController prefixController = TextEditingController();
  TextEditingController awbController = TextEditingController();
  TextEditingController hawbController = TextEditingController();
  final AuthService authService = AuthService();
  List<WarehouseLocationShipmentList> wareHouseShipmentList=[];
  List<WarehouseLocationList> wareHouseLocationList=[];
  List<TextEditingController> groupIdControllers = [];
  List<TextEditingController> locationControllers = [];
  List<TextEditingController> nopControllers = [];
  List<TextEditingController> weightControllers = [];
  List<bool> editStates = [];
  @override
  void initState() {
    super.initState();
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



  // String generateDynamicXml({
  //   required List<WarehouseLocationList> wareHouseLocationList,
  //   required String isid,
  //   required String airportCity,
  //   required String companyCode,
  //   required String mode,
  //   required String userId,
  // }) {
  //
  //   final filteredList =
  //   wareHouseLocationList.where((item) => item.iwSeqNo == 0).toList();
  //
  //   final locElements = filteredList.map((item) {
  //     return '''
  //   <LOC>
  //     <LocCode>${item.locCode}</LocCode>
  //     <NOP>${item.nop}</NOP>
  //     <Weight>${item.weight}</Weight>
  //     <Volume>0</Volume>
  //     <GroupId>${item.groupId}</GroupId>
  //   </LOC>
  //   ''';
  //   }).join();
  //
  //   final locXml = '<LOCS>$locElements</LOCS>';
  //
  //   final data = {
  //     "LocXML": locXml,
  //     "ISID": isid,
  //     "IWSeqNo": "",
  //     "AirportCity": airportCity,
  //     "CompanyCode": companyCode,
  //     "Mode": mode,
  //     "UserId": userId,
  //   };
  //   return jsonEncode(data);
  // }

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

  searchWarehouseLocationDetails() async{
    print("API call");
    if(prefixController.text.isEmpty){
      return;
    }
    if(awbController.text.isEmpty){
      return;
    }
    DialogUtils.showLoadingDialog(context);
    wareHouseLocationList=[];
    wareHouseShipmentList=[];
    editStates=[];
    var queryParams = {
      "AWBPrefix":"${prefixController.text}",
      "AWBNo": "${awbController.text}",
      "HAWBNO": "${hawbController.text}"
    };
    await authService
        .sendGetWithBody(
      "WarehouseLocation/WarehouseLocationSearch",
      queryParams,
    )
        .then((response) {
      print("data received ");
      Map<String, dynamic> jsonData = json.decode(response.body);
      List<dynamic> wlShipmentResp = jsonData['WarehouseLocationShipmentList'];
      List<dynamic> wlLocationResp = jsonData['WarehouseCurrentLocationList'];
      print(jsonData);

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
          wareHouseShipmentList=wlShipmentResp.map((json) => WarehouseLocationShipmentList.fromJson(json)).toList();
          wareHouseLocationList=wlLocationResp.map((json) => WarehouseLocationList.fromJson(json)).toList();
        });
        setState(() {
          groupIdControllers = List.generate(
              wareHouseLocationList.length,
                  (index) =>
                  TextEditingController(text: wareHouseLocationList[index].groupId));
          locationControllers = List.generate(
              wareHouseLocationList.length,
                  (index) =>
                  TextEditingController(text: wareHouseLocationList[index].locCode));
          nopControllers = List.generate(
              wareHouseLocationList.length,
                  (index) =>
                  TextEditingController(text: wareHouseLocationList[index].nop.toString()));
          weightControllers = List.generate(
              wareHouseLocationList.length,
                  (index) =>
                  TextEditingController(text: wareHouseLocationList[index].weight.toString()));
          editStates = List.generate(wareHouseLocationList.length, (_) => false);
        });
        print("wareHouseShipmentList Length  ${wareHouseShipmentList.length}");
        print("wareHouseLocationList Length  ${wareHouseLocationList.length}");
      }
      DialogUtils.hideLoadingDialog(context);

    }).catchError((onError) {
      setState(() {

      });
      print(onError);
    });
  }

  saveUpdateLocation() async {
    if(prefixController.text.isEmpty){

      return;
    }
    if(awbController.text.isEmpty){
      return;
    }
    // if (locController.text.isEmpty) {
    //   showDataNotFoundDialog(context, "Location is required.");
    //   return;
    // }
    //
    // if (groupController.text.isEmpty) {
    //   showDataNotFoundDialog(context, "Group Id is required.");
    //   return;
    // }
    //
    // if (nopController.text.isEmpty) {
    //   showDataNotFoundDialog(context, "NOP is required.");
    //   return;
    // }
    String xml = buildInputXmlSaveUpdate(
      wareHouseLocationList: wareHouseLocationList,
      iSId: '${wareHouseShipmentList.first.impshiprowid.toString()}',
      iWSeqNo: '',
      airportCity: "JFK",
      companyCode: "3",
      mode: "S",
      userId: "1",
    );

    print("Save XML   $xml");
     // return;
    var queryParams = {
      "LocXML": "$xml",
      "ISID": "${wareHouseShipmentList.first.impshiprowid.toString()}",
      "IWSeqNo": "",
      "AirportCity": "JFK",
      "CompanyCode": "3",
      "Mode": "S",
      "UserId": "1"
    };
    DialogUtils.showLoadingDialog(context);
    await authService
        .postData(
      "WarehouseLocation/WarehouseLocationSaveUpdate",
      queryParams,
    )
        .then((response) async {
      print("data received ");
      Map<String, dynamic> jsonData = json.decode(response.body);
      String? status = jsonData['Status'];
      String? statusMessage = jsonData['StatusMessage']??"";
      if(jsonData.isNotEmpty){
        DialogUtils.hideLoadingDialog(context);
        if(status!="S"){
          bool isTrue=await showDialog(
            context: context,
            builder: (BuildContext context) => CustomAlertMessageDialogNew(
              description: "$statusMessage",
              buttonText: "Okay",
              imagepath:'assets/images/warn.gif',
              isMobile: false,
            ),
          );
          if(isTrue){
            searchWarehouseLocationDetails();
          }
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
            searchWarehouseLocationDetails();
            // Navigator.pushReplacement(context,
            //     MaterialPageRoute(builder: (context) => const ImportShipmentListing()));
          }
        }

      }
    }).catchError((onError) {

      print(onError);
    });
  }
  deleteLocation(WarehouseLocationList data) async {

    // return;
    var queryParams = {
      "ISID": "${data.isid}",
      "IWSeqNo": "${data.iwSeqNo}",
      "AirportCity": "JFK",
      "CompanyCode": "3",
      "Mode": "D",
      "UserId": "1"
    };
    DialogUtils.showLoadingDialog(context);
    await authService
        .postData(
      "WarehouseLocation/WarehouseLocationSaveUpdate",
      queryParams,
    )
        .then((response) async {
      print("data received ");
      Map<String, dynamic> jsonData = json.decode(response.body);
      String? status = jsonData['Status'];
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
            searchWarehouseLocationDetails();
            // Navigator.pushReplacement(context,
            //     MaterialPageRoute(builder: (context) => const ImportShipmentListing()));
          }
        }

      }
    }).catchError((onError) {

      print(onError);
    });
  }



  void addBlankRow() {
    setState(() {
      wareHouseLocationList.add(WarehouseLocationList(nop: 0, sequenceNumber: '', locCode: '', weight: 0.00, whInTime: null, whOutTime: null, groupId: '', isid: 0, iwSeqNo: 0));
      groupIdControllers.add(TextEditingController());
      locationControllers.add(TextEditingController());
      nopControllers.add(TextEditingController());
      weightControllers.add(TextEditingController());
      editStates.add(true);
    });
  }

  double calculateWeight(int enteredNOP){
    int rcvNop=wareHouseShipmentList[0].npr;
    double rcvWt=wareHouseShipmentList[0].weight;
    double actWt=0.00;
    if(enteredNOP.isNaN){
      rcvNop=0;
    }
    else{
      if(enteredNOP==0){
        showDataNotFoundDialog(context,"NOP should be greater than 0.");
      }
      else if(rcvNop != null && rcvNop != 0){
         actWt = roundNumber((enteredNOP / rcvNop!) * rcvWt, 2);
      }
    }
    return actWt;
  }
  double roundNumber(double value, int decimals) {
    return (value * (10 ^ decimals)).round() / (10 ^ decimals);
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
                  style: const TextStyle(
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
                                                    controller: prefixController,
                                                    hastextcolor: true,
                                                    animatedLabel: true,
                                                    needOutlineBorder: true,
                                                    labelText: "Prefix*",
                                                    readOnly: false,
                                                    onPress: () {},
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
                                                    controller: awbController,
                                                    hastextcolor: true,
                                                    animatedLabel: true,
                                                    textInputType:
                                                    TextInputType.number,
                                                    needOutlineBorder: true,
                                                    labelText: "AWB No*",
                                                    onPress: () {},
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
                                                const SizedBox(
                                                  width: 15,
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
                                                    searchWarehouseLocationDetails();
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
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                                        children: [
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              _buildDetailColumn('Accepted Pcs', '${wareHouseShipmentList.isNotEmpty ? wareHouseShipmentList[0].npr ?? "" : ""}'),
                                              SizedBox(height: 20),
                                              _buildDetailColumn('Flight No.', '${wareHouseShipmentList.isNotEmpty ? wareHouseShipmentList[0].flightNo ?? "" : ""}'),

                                            ],
                                          ),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              _buildDetailColumn('Accepted Wt', '${wareHouseShipmentList.isNotEmpty ? wareHouseShipmentList[0].weight.toStringAsFixed(2) ?? "" : ""}'),
                                              SizedBox(height: 20),
                                              _buildDetailColumn('Flight Date', '${wareHouseShipmentList.isNotEmpty ? wareHouseShipmentList[0].sta ?? "" : ""}'),


                                            ],
                                          ),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              _buildDetailColumn('Located Pcs', '${wareHouseShipmentList.isNotEmpty ? wareHouseShipmentList[0].inWhnop ?? "" : ""}'),
                                              SizedBox(height: 20),
                                              _buildDetailColumn('Commodity', '${wareHouseShipmentList.isNotEmpty ? wareHouseShipmentList[0].commodity ?? "" : ""}'),

                                            ],
                                          ),

                                          // Column(
                                          //   crossAxisAlignment: CrossAxisAlignment.start,
                                          //   children: [
                                          //     _buildDetailColumn('Accepted Wt.', '${wareHouseShipmentList.isNotEmpty ? wareHouseShipmentList[0].wtPreDel ?? "" : ""}'),
                                          //     SizedBox(height: 20),
                                          //     _buildDetailColumn('NOG', '${wareHouseShipmentList.isNotEmpty ? wareHouseShipmentList[0].nog ?? "" : ""}'),
                                          //
                                          //   ],
                                          // ),
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
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text("  Current Location",style: TextStyle(color: Colors.black,fontWeight: FontWeight.w800,fontSize: 20),),
                                    GestureDetector(
                                      child: const Row(
                                        children: [
                                          Icon(Icons.add,
                                              color: MyColor.primaryColorblue),
                                          Text(
                                            ' Add Row',
                                            style: TextStyle(
                                               fontSize: 18,color:  MyColor.primaryColorblue),
                                          ),
                                        ],
                                      ),
                                      onTap: (){
                                        addBlankRow();
                                      },
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10,),
                                (wareHouseLocationList.isNotEmpty)?Container(
                                  width: MediaQuery.sizeOf(context).width,
                                  color: const Color(0xffE4E7EB),
                                  padding: const EdgeInsets.all(2.0),
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                      child: DataTable(
                                        columns:  [
                                          DataColumn(label: Center(child: SizedBox(width: MediaQuery.sizeOf(context).width*0.15,child: Center(child: Text('Action'))))),
                                          DataColumn(label: Center(child: SizedBox(width: MediaQuery.sizeOf(context).width*0.15,child: Center(child: Text('Group Id'))))),
                                          DataColumn(label: Center(child: SizedBox(width: MediaQuery.sizeOf(context).width*0.15,child: Center(child: Text('Location'))))),
                                          DataColumn(label: Center(child: SizedBox(width: MediaQuery.sizeOf(context).width*0.15,child: Center(child: Text('NOP'))))),
                                          DataColumn(label: Center(child: SizedBox(width: MediaQuery.sizeOf(context).width*0.15,child: Center(child: Text('Weight'))))),
                                          DataColumn(label: Center(child: SizedBox(width: MediaQuery.sizeOf(context).width*0.15,child: Center(child: Text('In Time'))))),

                                        ],
                                      rows:  List.generate(
                                          wareHouseLocationList.length,
                                              (index) {
                                            return buildDataRow(
                                              data: wareHouseLocationList[index],
                                              index: index,
                                              groupIdController: groupIdControllers[index],
                                              locationIdController: locationControllers[index],
                                              nopController: nopControllers[index],
                                              weightController: weightControllers[index]
                                            );
                                          }),
                                      headingRowColor:
                                      MaterialStateProperty.resolveWith((states) =>Color(0xffE4E7EB)),
                                      dataRowColor:  MaterialStateProperty.resolveWith((states) => Color(0xfffafafa)),
                                      columnSpacing: MediaQuery.sizeOf(context).width*0.04,
                                      dataRowHeight: 56.0,
                                    ),

                                  ),
                                ):SizedBox(),
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
                                           saveUpdateLocation();
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
    required WarehouseLocationList data,
    required int index,
    required TextEditingController groupIdController,
    required TextEditingController locationIdController,
    required TextEditingController nopController,
    required TextEditingController weightController,
  }) {
    return DataRow(cells: [
      DataCell(
        SizedBox(
          width:  MediaQuery.sizeOf(context).width*0.15,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                onTap: () {
                  scanNOP( nopControllers[index]);
                },
                child: Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: SvgPicture.asset(
                    search,
                    height: SizeConfig.blockSizeVertical * SizeUtils.ICONSIZE2,
                  ),
                ),
              ),
              const SizedBox(width: 16), // Space between icons
              InkWell(
                onTap: () {
                  setState(() {
                    editStates[index] = !editStates[index];
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: SvgPicture.asset(
                    pen,
                    height: SizeConfig.blockSizeVertical * SizeUtils.ICONSIZE2,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              GestureDetector(
                child: const Icon(
                  Icons.delete,
                  color: Colors.red,
                  size: 30,
                ),
                onTap: (){
                  deleteLocation(data);
                },
              ),
            ],
          ),
        ),
      ),
      DataCell(SizedBox(
        height: 45,
        width:  MediaQuery.sizeOf(context).width*0.15,
        child: TextFormField(
          controller: groupIdController,
          enabled:  editStates[index],
          onChanged: (value) {
            setState(() {
              groupIdControllers[index].text = value;
              data.groupId = value;
            });
          },
          decoration: InputDecoration(
            hintText: 'Group Id',

            contentPadding:
                const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: MyColor.borderColor,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: MyColor.borderColor,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: MyColor.primaryColorblue,
              ),
            ),
          ),
        ),
      )),
      DataCell(SizedBox(
        height: 45,
        width: MediaQuery.sizeOf(context).width*0.15,
        child: TextFormField(
          controller: locationIdController,
          enabled:  editStates[index],
          onChanged: (value) {
            setState(() {
              locationControllers[index].text = value;
              data.locCode = value;
            });
          },
          decoration: InputDecoration(
            hintText: 'Location',
            contentPadding:
                const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: MyColor.borderColor,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: MyColor.borderColor,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: MyColor.primaryColorblue,
              ),
            ),
          ),
        ),
      )),
      DataCell(SizedBox(
        height: 45,
        width:  MediaQuery.sizeOf(context).width*0.15,
        child: TextFormField(
          controller: nopController,
          textAlign: TextAlign.right,
          enabled:  editStates[index],
          onChanged: (value) {
            setState(() {
              if(value.isEmpty){
                weightControllers[index].clear();
              }
              nopControllers[index].text = value;
              data.nop = int.parse(value);
              double calWt=calculateWeight(int.parse(value));
              print("Calculated WT $calWt");
              weightControllers[index].text=calWt.toStringAsFixed(2);
              data.weight=calWt;
            });
          },
          decoration: InputDecoration(
            hintText: 'NOP',
            contentPadding:
                const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: MyColor.borderColor,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: MyColor.borderColor,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: MyColor.primaryColorblue,
              ),
            ),
          ),
        ),
      )),
      DataCell(SizedBox(
        height: 45,
        width:  MediaQuery.sizeOf(context).width*0.15,
        child: TextFormField(
          controller: weightController,
          textAlign: TextAlign.right,
          enabled:  editStates[index],
          onChanged: (value) {
            setState(() {
              weightControllers[index].text = value;
              data.weight=double.parse(value);
            });
          },
          decoration: InputDecoration(
            hintText: 'Weight',
            contentPadding:
                const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: MyColor.borderColor,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: MyColor.borderColor,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: MyColor.primaryColorblue,
              ),
            ),
          ),
        ),
      )),
       DataCell(SizedBox(width: MediaQuery.sizeOf(context).width*0.18,child: Text((data.whInTime!=null)?DateFormat('dd MMM yyyy, HH:mm').format(DateTime.parse(data.whInTime.toString())):""))),
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
}
