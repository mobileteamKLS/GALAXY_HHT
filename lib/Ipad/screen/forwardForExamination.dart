import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_svg/svg.dart';
import 'package:galaxy/Ipad/auth/auth.dart';
import 'package:intl/intl.dart';
import '../../core/images.dart';
import '../../core/mycolor.dart';
import '../../module/import/model/flightcheck/mailtypemodel.dart';
import '../../module/onboarding/sizeconfig.dart';
import '../../utils/commonutils.dart';
import '../../utils/dialogutils.dart';
import '../../utils/sizeutils.dart';
import '../../utils/snackbarutil.dart';
import '../../widget/customeedittext/customeedittextwithborder.dart';
import '../../widget/custometext.dart';
import '../modal/ShipmentListingDetails.dart';
import '../modal/forwardForExam.dart';
import '../utils/global.dart';
import '../widget/customDialog.dart';
import '../widget/customIpadTextfield.dart';
import 'ImportShipmentListing.dart';
import 'package:xml/xml.dart';

class ForwardForExamination extends StatefulWidget {
  final ShipmentListDetails shipmentListDetails;
  const ForwardForExamination({super.key, required this.shipmentListDetails});

  @override
  State<ForwardForExamination> createState() =>
      _ForwardForExaminationState();
}

class _ForwardForExaminationState
    extends State<ForwardForExamination> {

  bool value=false;
  TextEditingController customRefNoController = TextEditingController();
  TextEditingController customRefDateController = TextEditingController();
  TextEditingController remarkController = TextEditingController();
  TextEditingController locController = TextEditingController();
  List<ForwardForExamData> forwardExamData=[];
  AuthService authService=AuthService();
  List<TextEditingController> examPiecesControllers = [];
  List<bool?> isOnList = [];
  List<Map<String, dynamic>> saveList = [];
  // TextEditingController prefixController = TextEditingController();
  // TextEditingController prefixController = TextEditingController();
  @override
  void initState() {
    super.initState();
    fetchMasterData();
  }

  void fetchMasterData() async {
    await Future.delayed(Duration.zero);
    searchForwardForExamData(widget.shipmentListDetails);
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

  searchForwardForExamData(ShipmentListDetails data) async{
    DialogUtils.showLoadingDialog(context);
    forwardExamData=[];
    var queryParams = {
      "AWBPrefix": data.documentNo.substring(0,3),
      "AWBNo": data.documentNo.substring(4),
      "HAWBNumber": data.houseNo,
      "ISID": data.impShipRowId,
      "CompanyCode": "3",
      "UserID": userId,
      "AirportCode": "JFK",
      "CultureCode": "en-US",
      "MenuId": 1
    };
    await authService
        .sendGetWithBody(
      "OnHandShipment/GetDetailsofFFE",
      queryParams,
    )
        .then((response) {
      print("data received ");
      Map<String, dynamic> jsonData = json.decode(response.body);
      List<dynamic> resp = jsonData['OnHandShiForwardForExamList'];

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
          forwardExamData=resp.map((json) => ForwardForExamData.fromJson(json)).toList();

        });
        setState(() {
          isOnList = List.generate(forwardExamData.length, (index) => false);
          examPiecesControllers = List.generate(
              forwardExamData.length,
                  (index) =>
                  TextEditingController(text: forwardExamData[index].examinationNop.toString()));

          // nopControllers = List.generate(
          //     wareHouseLocationList.length,
          //         (index) =>
          //         TextEditingController(text: wareHouseLocationList[index].nop.toString()));
          // weightControllers = List.generate(
          //     wareHouseLocationList.length,
          //         (index) =>
          //         TextEditingController(text: wareHouseLocationList[index].weight.toString()));
          // editStates = List.generate(wareHouseLocationList.length, (_) => false);
        });
        print("wareHouseShipmentList Length  ${forwardExamData.length}");

      }
      DialogUtils.hideLoadingDialog(context);

    }).catchError((onError) {
      setState(() {

      });
      print(onError);
    });
  }

  saveExamPieces() async {
    FocusScope.of(context).requestFocus(FocusNode());
    String xml = buildInputXmlForFirstFormat(
      saveList: saveList,
    );
    var queryParams = {
      "XMLDoc":xml,
      "MAWBNo": widget.shipmentListDetails.documentNo.replaceAll("-", ""),
      "HouseNo": widget.shipmentListDetails.houseNo,
      "CompanyCode": "3",
      "UserID": userId,
      "AirportCode": "JFK",
      "CultureCode": "en-US",
      "MenuId": 1
    };
    bool allFalse = isOnList.every((element) => element == false);
    if(allFalse){
      showDataNotFoundDialog(context,"Please select at least one record.");
      return;
    }

    print(xml);

    DialogUtils.showLoadingDialog(context);
    await authService
        .postData(
      "OnHandShipment/ForwardExamination",
      queryParams,
    )
        .then((response) async {
      print("data received ");
      Map<String, dynamic> jsonData = json.decode(response.body);
      String status = jsonData['Status'];
      String? statusMessage = jsonData['StatusMessage']??"";
      if (jsonData.isNotEmpty) {
        DialogUtils.hideLoadingDialog(context);
        if (status != "S") {
          showDataNotFoundDialog(context, statusMessage!);
        }
        if ((status == "S")) {
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
            // searchCustomOperationsData(slotFilterDate,selectedTimes.join(','));
          }

        }

      }
      DialogUtils.hideLoadingDialog(context);
    }).catchError((onError) {
      print(onError);
    });
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
                                Container(
                                  padding:const EdgeInsets.symmetric(horizontal: 8),
                                  child: GestureDetector(
                                    child: const Icon(Icons.arrow_back_ios,
                                        color: MyColor.primaryColorblue),
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                  ),
                                ),
                                const Text(
                                  'Forward For Examination',
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
                                                child: Padding(
                                                  padding: const EdgeInsets.only(left:8.0),
                                                  child: const Text("Request For Examination",style: TextStyle(color: Colors.black,fontWeight: FontWeight.w800,fontSize: 20),),
                                                ),

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
                                              Padding(
                                                padding: const EdgeInsets.only(left:8.0),
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    _buildDetailColumn('AWB No.', widget.shipmentListDetails.documentNo),
                                                    const SizedBox(height: 20),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(
                                                width: 80,
                                              ),
                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  _buildDetailColumn('HAWB No', widget.shipmentListDetails.houseNo),
                                                  const SizedBox(height: 20),
                                                ],
                                              ),
                                              SizedBox(
                                                width: 80,
                                              ),
                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  _buildDetailColumn('Remarks', forwardExamData.isNotEmpty?'${forwardExamData.first.status}':""),
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
                                                borderRadius: BorderRadius.circular(8.0),
                                                color: Color(0xffE4E7EB),
                                              ),
                                              padding: EdgeInsets.all(8),
                                              child:   Center(child: Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Text(forwardExamData.isNotEmpty?"${forwardExamData.first.remainExaminationNop}":"",style: TextStyle(color: Colors.black,fontWeight: FontWeight.w800,fontSize: 32),),
                                                  Text("Exam Pieces",style: TextStyle(color: Colors.black,fontWeight: FontWeight.w800,fontSize: 18),),
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
                                        controller: customRefNoController,
                                        hastextcolor: true,
                                        animatedLabel: true,
                                        needOutlineBorder: true,
                                        labelText: "Custom Ref. No.",
                                        // controller: originController,
                                        readOnly: false,
                                        maxLength: 15,
                                        fontSize: 18,
                                        onChanged: (String, bool) {},
                                        onPress: () {},
                                      ),
                                    ),
                                    SizedBox(
                                      width: MediaQuery.sizeOf(context)
                                          .width *
                                          0.44,
                                      child:  CustomeEditTextWithBorderDatePicker(
                                        lablekey: 'MAWB',
                                        controller: customRefDateController,
                                        labelText:
                                        "Custom Ref. Date",
                                        readOnly: false,
                                        maxLength: 15,
                                        fontSize: 18,
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
                                        controller: remarkController,
                                        hastextcolor: true,
                                        animatedLabel: true,
                                        needOutlineBorder: true,
                                        labelText: "Remark",
                                        // controller: originController,
                                        readOnly: false,
                                        maxLength: 15,
                                        fontSize: 18,
                                        onChanged: (String, bool) {},
                                        onPress: () {},
                                      ),
                                    ),
                                    SizedBox(
                                      width: MediaQuery.sizeOf(context)
                                          .width *
                                          0.44,
                                      child: CustomeEditTextWithBorder(
                                        lablekey: 'MAWB',
                                        hasIcon: false,
                                        controller: locController,
                                        hastextcolor: true,
                                        animatedLabel: true,
                                        needOutlineBorder: true,
                                        labelText: "Exam Location*",
                                        // controller: destinationController,
                                        readOnly: false,
                                        maxLength: 15,
                                        fontSize: 18,
                                        onChanged: (String, bool) {},
                                        onPress: () {},
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: MediaQuery.sizeOf(context).height * 0.015,
                                ),
                                (forwardExamData.isNotEmpty)?Container(
                                  width: MediaQuery.sizeOf(context).width,
                                  color: const Color(0xffE4E7EB),
                                  padding: const EdgeInsets.all(2.0),
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: DataTable(
                                      columns:  [
                                        DataColumn(label: Center(child: SizedBox(width: MediaQuery.sizeOf(context).width*0.15,child: Center(child: Text('Group Id'))))),
                                        DataColumn(label: Center(child: SizedBox(width: MediaQuery.sizeOf(context).width*0.15,child: Center(child: Text('Location'))))),
                                        DataColumn(label: Center(child: SizedBox(width: MediaQuery.sizeOf(context).width*0.15,child: Center(child: Text('NOP'))))),
                                        DataColumn(label: Center(child: SizedBox(width: MediaQuery.sizeOf(context).width*0.15,child: Center(child: Text('Exam Pieces'))))),
                                        DataColumn(label: Center(child: SizedBox(width: MediaQuery.sizeOf(context).width*0.15,child: Center(child: Text(''))))),
                                      ],
                                      rows:  List.generate(
                                          forwardExamData.length,
                                              (index) {
                                            return buildDataRow(
                                                  data: forwardExamData[index],
                                                  index: index,
                                                  isOn: isOnList[index],
                                                  onCheckboxChanged: (value) =>
                                                      checkboxChanged(
                                                          value, index),
                                                  examPcsController:
                                                      examPiecesControllers[
                                                          index]);
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
                                      saveExamPieces();
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

  void checkboxChanged(bool? value, int index) {
    setState(() {
      isOnList[index] = value;
      if (value !=false) {
        saveList.removeWhere(
                (element) => element["item"] == forwardExamData[index]);
        saveList.add({"item": forwardExamData[index], "value": value});
      } else {
        saveList.removeWhere(
                (element) => element["item"] == forwardExamData[index]);
      }
    });
  }

  // String buildInputXml({
  //   required List<Map<String, dynamic>> saveList,
  //   required String companyCode,
  //   required String userId,
  //   required String airportCity,
  //   required String mode,
  // }) {
  //   final builder = XmlBuilder();
  //   DateTime customRefDate;
  //   String formattedCustomRefDate="";
  //   if(customRefDateController.text.isNotEmpty){
  //     customRefDate = DateFormat('dd/MM/yyyy').parse(customRefDateController.text.trim());
  //      formattedCustomRefDate = DateFormat('dd/MM/yyyy').format(customRefDate);
  //      print(formattedCustomRefDate);
  //   }
  //
  //   builder.element('ROOT', nest: () {
  //     for (var item in saveList) {
  //       final data = item['item'] as ForwardForExamData;
  //       builder.element('ForwordForExamination', nest: () {
  //         builder.element('uxHdnWLID', nest: data.sequenceNumber);
  //         builder.element('Location', nest: locController.text);
  //         builder.element('NOP', nest: data.nop.toString());
  //         builder.element('ExamPieces', nest: data.examinationNop.toString());
  //         builder.element('CustomsRefNo', nest: customRefNoController.text);
  //         builder.element('CustomsRefDate', nest:formattedCustomRefDate??"");
  //         builder.element('Remark', nest: remarkController.text);
  //       });
  //     }
  //   });
  //
  //   final xmlDocument = builder.buildDocument();
  //   return xmlDocument.toXmlString(pretty: true, indent: '  ');
  // }

  String buildInputXmlForFirstFormat({
    required List<Map<String, dynamic>> saveList,

  }) {
    final builder = XmlBuilder();
    DateTime customRefDate;
    String formattedCustomRefDate = "";

    if (customRefDateController.text.isNotEmpty) {
      customRefDate = DateFormat('dd/MM/yyyy').parse(customRefDateController.text.trim());
      formattedCustomRefDate = DateFormat('dd/MM/yyyy').format(customRefDate);
    }

    builder.element('ROOT', nest: () {
      for (var item in saveList) {
        final data = item['item'] as ForwardForExamData;
        builder.element('ForwordForExamination', attributes: {
          'uxHdnWLID': data.sequenceNumber.toString(),
          'Location': locController.text,
          'NOP': data.nop.toString(),
          'ExamPieces': data.examinationNop.toString(),
          'CustomsRefNo': customRefNoController.text,
          'CustomsRefDate': formattedCustomRefDate.isNotEmpty ? formattedCustomRefDate : '',
          'Remark': remarkController.text,
        });
      }
    });

    final xmlDocument = builder.buildDocument();
    return xmlDocument.toXmlString(pretty: true, indent: '  ');
  }


  DataRow buildDataRow( {
    required ForwardForExamData data,
    required bool? isOn,
    required int index,
    required ValueChanged<bool?> onCheckboxChanged,
    required TextEditingController examPcsController,

  }) {
    return DataRow(cells: [
      DataCell(SizedBox(
          width: MediaQuery.sizeOf(context).width * 0.15,
          child: Center(child: Text("${data.groupId}")))),
      DataCell(SizedBox(
        width: MediaQuery.sizeOf(context).width * 0.15,
        child: Center(child: Text("${data.loc}")),
      )),
      DataCell(SizedBox(
          width: MediaQuery.sizeOf(context).width * 0.15,
          child: Center(child: Text("${data.nop}")))),
      DataCell(SizedBox(
        width: MediaQuery.sizeOf(context).width * 0.15,
        child: TextFormField(
          controller: examPcsController,
          onChanged: (value) {
            setState(() {
              examPiecesControllers[index].text = value;
              data.examinationNop=int.parse(value);

            });
          },
          decoration: InputDecoration(
            hintText: 'Exam Pieces',
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
      DataCell(Center(
          child: SizedBox(
              width: MediaQuery.sizeOf(context).width * 0.12,
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
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }


}
