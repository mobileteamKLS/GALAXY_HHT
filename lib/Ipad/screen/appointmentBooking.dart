import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import '../../core/images.dart';
import '../../core/mycolor.dart';
import '../../module/onboarding/sizeconfig.dart';
import '../../utils/dialogutils.dart';
import '../../utils/sizeutils.dart';
import '../../utils/snackbarutil.dart';
import '../../widget/customebuttons/roundbuttonblue.dart';
import '../../widget/custometext.dart';
import '../auth/auth.dart';
import '../modal/CustomsOperations.dart';
import '../utils/global.dart';
import 'ImportShipmentListing.dart';
import 'package:xml/xml.dart';

class AppointmentBooking extends StatefulWidget {
  const AppointmentBooking({super.key});

  @override
  State<AppointmentBooking> createState() => _AppointmentBookingState();
}

class _AppointmentBookingState extends State<AppointmentBooking> {
  String? _selectedDate = '01 Aug 2024';
  String? selectedTime = '10:00-11:00';
  String? selectedSlot;
  bool? acceptAll = false;
  final AuthService authService = AuthService();
  bool isLoading = false;
  bool hasNoRecord = false;
  String slotFilterDate = "Slot Date";
  DateTime? selectedDate;
  List<CustomExaminationMasterData> appointBookingList = [];
  List<Map<String, dynamic>> saveList = [];
  List<CustomExaminationMasterData> masterData = [];
  List<bool?> isOnList = [];
  List<TextEditingController> piecesControllers = [];
  List<TextEditingController> remarksControllers = [];
  List<String>slotList =[];

  Future<void> pickDate(BuildContext context, StateSetter setState) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2001),
      lastDate: DateTime(2101),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData(
            useMaterial3: false,
            primaryColor: MyColor.primaryColorblue,

            dialogBackgroundColor: Colors.white,
            // Change dialog background color
            colorScheme: const ColorScheme.light(
              primary: MyColor.primaryColorblue,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: MyColor.primaryColorblue,
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null && pickedDate != selectedDate) {
      setState(() {
        selectedDate = pickedDate;
        slotFilterDate = DateFormat('dd-MM-yyyy').format(pickedDate);
        print("DATE is $slotFilterDate");
      });
      getSlotTime(slotFilterDate);
    }
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

  searchCustomOperationsData(String date,String slot) async {
    DialogUtils.showLoadingDialog(context);
    appointBookingList = [];
    masterData = [];
    piecesControllers = [];
    remarksControllers = [];
    var queryParams = {
      "InputXml":
          "<Root><CompanyCode>3</CompanyCode><UserId>${userId.toString()}</UserId><AirportCity>JFK</AirportCity><Mode>S</Mode><SlotDate>${date}</SlotDate><SlotTime>${slot}</SlotTime></Root>"
    };

    await authService
        .sendGetWithBody("CustomExamination/GetCustomExamination", queryParams)
        .then((response) {
      print("data received ");
      Map<String, dynamic> jsonData = json.decode(response.body);

      print(jsonData);
      if (jsonData.isEmpty) {
        setState(() {
          hasNoRecord = true;
        });
      } else {
        hasNoRecord = false;
      }
      print("is empty record$hasNoRecord");
      String status = jsonData['RetOutput'][0]['Status'];
      String statusMessage = jsonData['RetOutput'][0]['StrMessage'];

      if (status == 'E') {
        print("Error: $statusMessage");
        DialogUtils.hideLoadingDialog(context);
        showDataNotFoundDialog(context, statusMessage);
        return;
      } else {
        List<dynamic> resp = jsonData['CustomExaminationPList'];
        // List<dynamic> accConsignment = jsonData['ConsignmentAcceptance'];
        if (resp.isEmpty) {
          print("No data");
          DialogUtils.hideLoadingDialog(context);
          return;
        }
        setState(() {
          appointBookingList = resp
              .where((json) {
                return json["ElementRowID"] != -1 && json["ElementRowID"] != 0;
              })
              .map((json) => CustomExaminationMasterData.fromJSON(json))
              .toList();
          masterData = resp
              .where((json) {
                return json["ElementRowID"] == -1;
              })
              .map((json) => CustomExaminationMasterData.fromJSON(json))
              .toList();
          // resp.map((json) => CustomExamination.fromJSON(json)).toList();
          print("length==  = ${appointBookingList.length}");
          // filteredList = listShipmentDetails;
          print("length--  = ${appointBookingList.length}");
        });
        setState(() {
          isOnList = List.generate(appointBookingList.length, (index) => false);
          piecesControllers = List.generate(
              appointBookingList.length,
              (index) =>
                  TextEditingController(text: appointBookingList[index].col7));
          print("Piecs${appointBookingList.first.col5}");
          remarksControllers = List.generate(
              appointBookingList.length,
              (index) =>
                  TextEditingController(text: appointBookingList[index].col8));
        });
        print("Piecs${piecesControllers.first.text}");
      }
      DialogUtils.hideLoadingDialog(context);
    }).catchError((onError) {
      DialogUtils.hideLoadingDialog(context);
      print(onError);
    });
  }

  getSlotTime(String date) async {
    DialogUtils.showLoadingDialog(context);
    appointBookingList = [];
    masterData = [];
    slotList=[];
    selectedSlot="";
    var queryParams = {
      "InputXml":
      "<Root><CompanyCode>3</CompanyCode><UserId>${userId.toString()}</UserId><AirportCity>JFK</AirportCity><Mode>S</Mode><SlotDate>${date}</SlotDate><SlotTime></SlotTime></Root>"
    };

    await authService
        .sendGetWithBody("CustomExamination/GetCustomExamination", queryParams)
        .then((response) {
      print("data received ");
      Map<String, dynamic> jsonData = json.decode(response.body);

      print(jsonData);
      if (jsonData.isEmpty) {
        setState(() {
          hasNoRecord = true;
        });
      } else {
        hasNoRecord = false;
      }
      print("is empty record$hasNoRecord");
      String status = jsonData['RetOutput'][0]['Status'];
      String statusMessage = jsonData['RetOutput'][0]['StrMessage'];

      if (status == 'E') {
        print("Error: $statusMessage");
        DialogUtils.hideLoadingDialog(context);
        showDataNotFoundDialog(context, statusMessage);
        return;
      } else {
        List<dynamic> resp = jsonData['CustomExaminationPList'];
        // List<dynamic> accConsignment = jsonData['ConsignmentAcceptance'];
        if (resp.isEmpty) {
          print("No data");
          DialogUtils.hideLoadingDialog(context);
          return;
        }
        setState(() {
          List<CustomExaminationMasterData> headerList = resp
              .where((json) {
            return json["ElementRowID"] == -1;
          })
              .map((json) => CustomExaminationMasterData.fromJSON(json))
              .toList();
           slotList = headerList
              .map((exam) => '${exam.col3}-${exam.col4}') .toSet()
              .toList();
          selectedSlot = slotList.isNotEmpty ? slotList.first : null;
          print("length==  = ${slotList}");
          print("length--  = ${slotList.length}");
        });
        if (slotList.isEmpty) {
          print("Slot list is empty.");
          DialogUtils.hideLoadingDialog(context);
          return;  // Or show a message if needed
        } else {
          print("first slot: ${slotList.first}");
          searchCustomOperationsData(date, slotList.first);
        }


      }
      DialogUtils.hideLoadingDialog(context);
    }).catchError((onError) {
      DialogUtils.hideLoadingDialog(context);
      print(onError);
    });
  }

  String buildInputXml({
    required List<Map<String, dynamic>> saveList,
    required String companyCode,
    required String userId,
    required String airportCity,
    required String mode,
  }) {
    final builder = XmlBuilder();

    builder.element('Root', nest: () {
      builder.element('Appointment', nest: () {
        for (var item in saveList) {
          final customExamination = item['item'] as CustomExaminationMasterData;
          builder.element('Appointment', nest: () {
            builder.element('MessageRowID', nest: customExamination.messageRowId);
            builder.element('QueueRowID', nest: customExamination.queueRowId);
            builder.element('ElementRowID', nest: customExamination.elementRowId);
            builder.element('ElementGUID', nest: customExamination.elementGuid);
            builder.element('Status', nest: (item['value']!=null?item['value']?"A":"":"R")); // Placeholder for Status
            builder.element('RFEPieces', nest: customExamination.col7); // Assuming col5 holds RFEPieces
            builder.element('Remarks', nest: customExamination.col8); // Assuming col6 holds Remarks
          });
        }
      });

      builder.element('ForwardExamination', nest: () {
        for (var item in saveList) {
          final customExamination = item['item'] as CustomExaminationMasterData;
          builder.element('ForwardExamination', nest: () {
            builder.element('ExaminationRowId', nest: customExamination.rowId);
          });
        }
      });

      builder.element('CompanyCode', nest: companyCode);
      builder.element('UserId', nest: userId);
      builder.element('AirportCity', nest: airportCity);
      builder.element('Mode', nest: mode);
    });

    final xmlDocument = builder.buildDocument();
    return xmlDocument.toXmlString(pretty: true, indent: '  ');
  }

  saveBookings() async {
    FocusScope.of(context).requestFocus(FocusNode());
    String xml = buildInputXml(
      saveList: saveList,
      companyCode: "3",
      userId: userId.toString(),
      airportCity: "JFK",
      mode: "S",
    );
    var queryParams = {
      "InputXML":xml
     };
    bool allNull = isOnList.every((element) => element == null);

    print("---$allNull");
    print(xml);

    DialogUtils.showLoadingDialog(context);
    await authService
        .postData(
      "CustomExamination/CustomExaminationSave",
      queryParams,
    )
        .then((response) {
      print("data received ");
      Map<String, dynamic> jsonData = json.decode(response.body);
      String status = jsonData['RetOutput'][0]['Status'];
      String? statusMessage = jsonData['RetOutput'][0]['StrMessage']??"";
      if (jsonData.isNotEmpty) {
        DialogUtils.hideLoadingDialog(context);
        if (status != "S") {
          showDataNotFoundDialog(context, statusMessage!);
        }
        if ((status == "S")) {
          SnackbarUtil.showSnackbar(
              context, statusMessage!, const Color(0xff43A047));
          getSlotTime(slotFilterDate);
        }

      }
      DialogUtils.hideLoadingDialog(context);
    }).catchError((onError) {
      print(onError);
    });
  }

  void checkboxChanged(bool? value, int index) {
    setState(() {
      isOnList[index] = value;
      if (value !=false) {
        // saveList.removeWhere(
        //         (element) => element["item"] == appointBookingList[index]);
        saveList.add({"item": appointBookingList[index], "value": value});
      } else {
        saveList.removeWhere(
                (element) => element["item"] == appointBookingList[index]);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    fetchMasterData();
  }

  void fetchMasterData() async {
    await Future.delayed(Duration.zero);
    DateTime today = DateTime.now();
    var formatter = DateFormat('dd-MM-yyyy');
    String formattedDate = formatter.format(today);
    setState(() {
      slotFilterDate = formattedDate;
    });
    getSlotTime(formattedDate);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColor.screenBgColor,
      appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Row(
            children: [
              InkWell(
                onTap: () {},
                child: Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: SvgPicture.asset(
                    drawer,
                    height: SizeConfig.blockSizeVertical * SizeUtils.ICONSIZE2,
                  ),
                ),
              ),
               Text(
                  isCES?'  Warehouse Operations':"  Customs Operation",
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                    color: Colors.white),
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
      body: Stack(
        children: [
          Container(
            constraints: const BoxConstraints.expand(),
            color: MyColor.screenBgColor,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
                  child: Material(
                    color: Colors.transparent,
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
                                    '  Appointment Bookings',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 22),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          Column(
                            children: [
                              Container(
                                width: MediaQuery.sizeOf(context).width,
                                color: Color(0xffE4E7EB),
                                padding: EdgeInsets.all(2.0),
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: DataTable(
                                    columns: [
                                      _buildDataColumn('Slot Date'),
                                      _buildDataColumn('Slot Start-End Time'),
                                      _buildDataColumn('Duration(Min)'),
                                      _buildDataColumn('Station Name(s)'),
                                      _buildDataColumn('Shipment Count'),
                                      _buildDataColumn('Pieces'),
                                      const DataColumn(
                                          label: Center(child: Text('Weight'))),
                                      // Last column without divider
                                    ],
                                    rows: [
                                      DataRow(cells: [
                                        DataCell(
                                          GestureDetector(
                                            child: Row(
                                              children: [
                                                Text(
                                                  slotFilterDate,
                                                  style: const TextStyle(
                                                      fontSize: 16,
                                                      color: MyColor
                                                          .primaryColorblue),
                                                ),
                                                const SizedBox(width: 8),
                                                const Icon(Icons.calendar_today,
                                                    color: MyColor
                                                        .primaryColorblue),
                                              ],
                                            ),
                                            onTap: () {
                                              pickDate(context, setState);
                                            },
                                          ),
                                        ),
                                        // DataCell(Center(
                                        //     child:
                                        //         DropdownButtonFormField<String>(
                                        //   value: _selectedDate,
                                        //   items: [
                                        //     '01 Aug 2024',
                                        //     '02 Aug 2024',
                                        //     '03 Aug 2024'
                                        //   ]
                                        //       .map((value) => DropdownMenuItem(
                                        //             value: value,
                                        //             child: Text(value),
                                        //           ))
                                        //       .toList(),
                                        //   onChanged: (value) {
                                        //     _selectedDate = value;
                                        //   },
                                        //   decoration: InputDecoration(
                                        //     filled: true,
                                        //     fillColor: Color(0xffF5F8FA),
                                        //     border: OutlineInputBorder(
                                        //       borderRadius:
                                        //           BorderRadius.circular(8),
                                        //       borderSide:
                                        //           BorderSide.none, // No border
                                        //     ),
                                        //     // contentPadding: EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                                        //   ),
                                        //   icon: const Icon(
                                        //       Icons.arrow_drop_down,
                                        //       color: Colors.blue),
                                        //   style: const TextStyle(
                                        //       fontSize: 16,
                                        //       color: Colors.black),
                                        //   dropdownColor: Colors.white,
                                        // ))),
                                        DataCell(Center(
                                            child:
                                            DropdownButtonFormField<String>(
                                              value: selectedSlot, // Set the initial selected value
                                              items: slotList.isNotEmpty
                                                  ? slotList.map((value) => DropdownMenuItem<String>(
                                                value: value,
                                                child: Text(value),
                                              )).toList()
                                                  : [
                                                const DropdownMenuItem<String>(
                                                  value: '', // or any default value
                                                  child: Text(''),
                                                ),
                                              ],
                                              onChanged: (value) {
                                                setState(() {
                                                  selectedSlot = value;
                                                });
                                                searchCustomOperationsData(slotFilterDate,selectedSlot!);
                                              },
                                              decoration: InputDecoration(
                                                filled: true,
                                                fillColor: Color(0xffF5F8FA),
                                                border: OutlineInputBorder(
                                                  borderRadius: BorderRadius.circular(8),
                                                  borderSide: BorderSide.none, // No border
                                                ),
                                                // contentPadding: EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                                              ),
                                              icon: const Icon(
                                                Icons.arrow_drop_down,
                                                color: Colors.blue,
                                              ),
                                              style: const TextStyle(
                                                fontSize: 16,
                                                color: Colors.black,
                                              ),
                                              dropdownColor: Colors.white,
                                            )

                                          //         DropdownButtonFormField<String>(
                                        //   value: selectedTime,
                                        //   items: [
                                        //     '10:00-11:00',
                                        //     '11:00-12:00',
                                        //     '12:00-13:00'
                                        //   ]
                                        //       .map((value) => DropdownMenuItem(
                                        //             value: value,
                                        //             child: Text(value),
                                        //           ))
                                        //       .toList(),
                                        //   onChanged: (value) {
                                        //     selectedTime = value;
                                        //   },
                                        //   decoration: InputDecoration(
                                        //     filled: true,
                                        //     fillColor: Color(0xffF5F8FA),
                                        //     border: OutlineInputBorder(
                                        //       borderRadius:
                                        //           BorderRadius.circular(8),
                                        //       borderSide:
                                        //           BorderSide.none, // No border
                                        //     ),
                                        //     // contentPadding: EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                                        //   ),
                                        //   icon: const Icon(
                                        //       Icons.arrow_drop_down,
                                        //       color: Colors.blue),
                                        //   style: const TextStyle(
                                        //       fontSize: 16,
                                        //       color: Colors.black),
                                        //   dropdownColor: Colors.white,
                                        // )
                                        )),
                                        DataCell(Center(
                                            child: Text(masterData.isNotEmpty
                                                ? masterData[0].col5 ?? ""
                                                : ""))),
                                        DataCell(Center(
                                            child: Text(masterData.isNotEmpty
                                                ? masterData[0].col1 ?? ""
                                                : ""))),
                                        DataCell(Center(child: Text(masterData.isNotEmpty
                                            ? masterData[0].col6 ?? ""
                                            : ""))),
                                        DataCell(Center(child: Text(masterData.isNotEmpty
                                            ? masterData[0].col7 ?? ""
                                            : ""))),
                                        DataCell(Center(child: Text(masterData.isNotEmpty
                                            ? masterData[0].col8 ?? ""
                                            : ""))),
                                      ]),
                                    ],
                                    headingRowColor:
                                        MaterialStateProperty.resolveWith(
                                      (states) => Color(0xffe6effc),
                                    ),
                                    dataRowColor:
                                        MaterialStateProperty.resolveWith(
                                      (states) => Color(0xfffafafa),
                                    ),
                                    dataRowHeight: 48.0,
                                    columnSpacing:
                                        MediaQuery.sizeOf(context).width *
                                            0.031,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              (!hasNoRecord)
                                  ? Container(
                                      width: MediaQuery.sizeOf(context).width,
                                      color: Color(0xffE4E7EB),
                                      padding: EdgeInsets.all(2.0),
                                      child: SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: DataTable(
                                          columns: [
                                            DataColumn(
                                                label: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                // Checkbox(
                                                //   isError: true,
                                                //   tristate: true,
                                                //   activeColor: acceptAll == null
                                                //       ? Colors.red
                                                //       : acceptAll!
                                                //           ? Colors.green
                                                //           : Colors.grey,
                                                //   value: acceptAll,
                                                //   onChanged: (bool? value) {
                                                //     setState(() {
                                                //       acceptAll = value;
                                                //     });
                                                //   },
                                                // ),
                                                // Text(
                                                //   'Accept \nAll',
                                                //   style: TextStyle(
                                                //     color: MyColor.primaryColorblue,
                                                //     decoration: TextDecoration.underline,
                                                //     decorationStyle: TextDecorationStyle.solid,
                                                //     decorationColor: MyColor.primaryColorblue,
                                                //     decorationThickness: 2,
                                                //   ),
                                                // ),
                                                // SizedBox(
                                                //   width: 8,
                                                // ),
                                                // Text(
                                                //   'Reject\n All',
                                                //   style: TextStyle(color: Colors.red,
                                                //     decoration: TextDecoration.underline,
                                                //     decorationStyle: TextDecorationStyle.solid,
                                                //     decorationColor: Colors.red,
                                                //     decorationThickness: 2,
                                                //   ),
                                                // )
                                              ],
                                            )),
                                            const DataColumn(
                                                label: Text('AWB No.\n')),
                                            const DataColumn(
                                                label: Text('HAWB No.\n')),
                                            const DataColumn(
                                                label: Text(
                                                    'Req. For Exam. (RFE) \n Pieces')),
                                            const DataColumn(
                                                label: Text('Remarks\n')),
                                          ],
                                          rows: List.generate(
                                              appointBookingList.length,
                                              (index) {
                                            return _buildDataRow(
                                              data: appointBookingList[index],
                                              isOn: isOnList[index],
                                              index: index,
                                              onCheckboxChanged: (value) =>
                                                  checkboxChanged(value, index),
                                              piecesController:
                                                  piecesControllers[index],
                                              remarksController:
                                                  remarksControllers[index],
                                            );
                                          }),
                                          dataRowHeight: 64.0,
                                          headingRowColor:
                                              MaterialStateProperty.resolveWith(
                                            (states) => Color(0xffE4E7EB),
                                          ),
                                          dataRowColor:
                                              MaterialStateProperty.resolveWith(
                                            (states) => Color(0xfffafafa),
                                          ),
                                          columnSpacing:
                                              MediaQuery.sizeOf(context).width *
                                                  0.05,
                                        ),
                                      ),
                                    )
                                  :  Container(
                                height: MediaQuery.of(context).size.height/1.5 ,
                                child: Center(
                                  child: Lottie.asset('assets/images/nodata.json'),
                                ),
                              ),
                              SizedBox(
                                height:
                                    MediaQuery.sizeOf(context).height * 0.015,
                              ),
                              (appointBookingList.isNotEmpty)
                                  ? Container(
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(12.0),
                                        color: Colors.white,
                                        boxShadow: [
                                          BoxShadow(
                                            color:
                                                Colors.black.withOpacity(0.1),
                                            spreadRadius: 2,
                                            blurRadius: 8,
                                            offset: const Offset(0,
                                                3), // changes position of shadow
                                          ),
                                        ],
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 14, horizontal: 10),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(
                                              height: 45,
                                              width: MediaQuery.sizeOf(context)
                                                  .width,
                                              child: ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                      MyColor.primaryColorblue,
                                                  textStyle: const TextStyle(
                                                    fontSize: 18,
                                                    color: Colors.white,
                                                  ),
                                                  shape:
                                                      const RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(8)),
                                                  ),
                                                ),
                                                onPressed: () {
                                                  saveBookings();
                                                },
                                                child: const Text(
                                                  "Save",
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                  : SizedBox(),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
              ],
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
    );
  }

  // DataColumn _buildDataColumn(String label) {
  //   return DataColumn(
  //     label: Stack(
  //       alignment: Alignment.centerRight,
  //       children: [
  //         Center(child: Text(label)),
  //         Positioned(
  //           right: 0,
  //           child: Container(
  //             height: double.infinity,
  //             width: 1,
  //             color: Colors.black,
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }
  DataColumn _buildDataColumn(String label) {
    return DataColumn(
      label: Text(label),
    );
  }

  DataRow _buildDataRow({
    required CustomExaminationMasterData data,
    required bool? isOn,
    required int index,
    required ValueChanged<bool?> onCheckboxChanged,
    required TextEditingController piecesController,
    required TextEditingController remarksController,
  }) {
    return DataRow(
      cells: [
        DataCell(
          Theme(
            data: ThemeData(useMaterial3: false),
            child: Checkbox(
              isError: true,
              tristate: true,
              activeColor: isOn == null
                  ? Colors.red
                  : isOn!
                      ? Colors.green
                      : Colors.grey,
              value: isOn,
              onChanged: (bool? value) {
                setState(() {
                  onCheckboxChanged(value);
                });
              },
            ),
            // Switch(
            //   onChanged: (value) async {
            //     setState(() {});
            //   },
            //   value: isOn,
            //   activeColor: MyColor.primaryColorblue,
            //   activeTrackColor: Colors.grey,
            //   inactiveThumbColor: Colors.red,
            // ),
          ),
        ),
        DataCell(Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 4,
            ),
            Text(data.col2, style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(
              height: 8,
            ),
            Row(
              children: [
                const Text('Pieces '),
                Text('${data.col5}',
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
          ],
        )),
        DataCell(Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 4,
            ),
            Text("${data.col3}", style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(
              height: 8,
            ),
            Row(
              children: [
                Text('Weight '),
                Text('${data.col6}',
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
          ],
        )),
        DataCell(
          TextFormField(
          controller: piecesController,
          decoration: InputDecoration(
            hintText: 'Enter RFE Pieces',
            contentPadding:
                const EdgeInsets.symmetric(vertical: 0, horizontal: 15),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: MyColor.borderColor,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: MyColor.borderColor,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: MyColor.primaryColorblue,
              ),
            ),
          ),
          onChanged: (value) {
            setState(() {
              piecesControllers[index].text = value;
              data.col7 = value;
            });
          },
        ),
        ),
        DataCell(SizedBox(
          width: MediaQuery.sizeOf(context).width * 0.3,
          child: TextField(
            controller: remarksController,
            onChanged: (value) {
              setState(() {
                remarksControllers[index].text = value;
                data.col8 = value;
              });
            },
            decoration: InputDecoration(
              hintText: 'Remarks here',
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 0, horizontal: 15),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: MyColor.borderColor,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: MyColor.borderColor,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: MyColor.primaryColorblue,
                ),
              ),
            ),
          ),
        )),
      ],
    );
  }
}
