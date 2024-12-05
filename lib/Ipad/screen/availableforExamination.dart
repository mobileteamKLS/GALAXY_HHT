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

class AvailableForExamination extends StatefulWidget {
  const AvailableForExamination({super.key});

  @override
  State<AvailableForExamination> createState() => _AvailableForExaminationState();
}

class _AvailableForExaminationState extends State<AvailableForExamination> {
  String? _selectedDate = '01 Aug 2024';
  String? selectedTime = '10:00-11:00';
  bool? acceptAll;
  final AuthService authService = AuthService();
  bool isLoading = false;
  bool hasNoRecord = false;
  String slotFilterDate = "Slot Date";
  DateTime? selectedDate;
  List<AvailableExamination> appointBookingList=[];
  List<bool?> isOnList = [];
  List<TextEditingController> piecesControllers = [];
  List<TextEditingController> remarksControllers = [];


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
              primary:MyColor.primaryColorblue,
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
      searchCustomOperationsData();
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

  searchCustomOperationsData() async {
    DialogUtils.showLoadingDialog(context);
    appointBookingList=[];
    var queryParams = {
      "InputXml":
      "<Root><CompanyCode>3</CompanyCode><UserId>1</UserId><AirportCity>JFK</AirportCity><Mode>C</Mode><SlotDate></SlotDate><SlotTime></SlotTime></Root>"
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
        List<dynamic> resp = jsonData['CustomExaminationCompleteList'];
        // List<dynamic> accConsignment = jsonData['ConsignmentAcceptance'];
        if(resp.isEmpty){
          print("No data");
          DialogUtils.hideLoadingDialog(context);
          return;
        }
        setState(() {

          appointBookingList =
              resp.map((json) => AvailableExamination.fromJson(json)).toList();
          print("length==  = ${appointBookingList.length}");
        });

      }
      DialogUtils.hideLoadingDialog(context);
    }).catchError((onError) {
      DialogUtils.hideLoadingDialog(context);
      print(onError);
    });
  }

  void checkboxChanged(bool? value, int index) {
    setState(() {
      isOnList[index] = value;
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
      slotFilterDate=formattedDate;
    });
    searchCustomOperationsData();
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
                style: TextStyle(
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
            child: SingleChildScrollView(
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
                                      '  Available For Examination',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 22),
                                    ),
                                  ],
                                ),
                              ],
                            ),

                            Column(
                              children: [

                                const SizedBox(
                                  height: 10,
                                ),
                                (appointBookingList.isNotEmpty)
                                    ? SingleChildScrollView(
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        top: 8.0, left: 0.0, bottom: 100),
                                    child: SizedBox(
                                      width: MediaQuery.of(context).size.width / 1.01,
                                      child: ListView.builder(
                                        physics:
                                        const NeverScrollableScrollPhysics(),
                                        itemBuilder: (BuildContext, index) {

                                          AvailableExamination
                                          shipmentDetails =
                                          appointBookingList
                                              .elementAt(index);
                                          return buildShipmentCardV2(
                                              shipmentDetails);
                                        },
                                        itemCount: appointBookingList.length,
                                        shrinkWrap: true,
                                        padding: const EdgeInsets.all(2),
                                      ),
                                    ),
                                  ),
                                ):   Container(
                          height:
                          MediaQuery.of(context).size.height /
                          1.5,
                      child: Center(
                        child: Lottie.asset(
                            'assets/images/nodata.json'),
                      ),
                    ),
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
  Widget buildShipmentCardV2(AvailableExamination shipment) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  shipment.awb,
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 8),
                buildLabel("AWB", Colors.deepPurpleAccent,8,isBorder: true,borderColor: Colors.deepPurpleAccent),
                const SizedBox(width: 8),
                SizedBox(
                    width: MediaQuery.sizeOf(context).width*0.11,
                    child: buildLabel(shipment.hawb==""?"DIRECT":"CONSOL", Colors.white,8,isBorder: true,borderColor: Colors.grey)),

                const SizedBox(width: 8),
                 Row(
                  children: [
                    Text(
                      shipment.ffeDateTime,
                      style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),
                    ),
                    SizedBox(width: 8),
                    Icon(
                      Icons.info_outline_rounded,
                      color: MyColor.primaryColorblue,
                    ),
                  ],
                ),
                //const SizedBox(width: 16),

              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Container(

                  width: MediaQuery.sizeOf(context).width*0.9,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width:180,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text("HAWB No: "),
                                    Text(shipment.hawb==""?" - ":shipment.hawb,style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    const Text("Commodity: "),
                                    Text(
                                      "${shipment.commodity}",style: const TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
                                  ],
                                ),
                                const SizedBox(height: 8),

                              ],
                            ),
                          ),
                          const SizedBox(width: 24),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  SizedBox(
                                    width: 120,
                                    child: Row(
                                      children: [
                                        const Text("Declared PCS: "),
                                        Text("${shipment.totalPieces}",style: const TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
                                      ],
                                    ),
                                  ),

                                  const SizedBox(width: 64),
                                  SizedBox(
                                    width: 180,
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Text("Declared Weight: "),
                                        Text("${shipment.totalWeight}",style: const TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 32),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text("Unit: "),
                                      Text("KG",style: const TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  SizedBox(
                                    width: 120,
                                    child: Row(
                                      children: [
                                        const Text("FFE Pcs: "),
                                        Text(shipment.forwardNop.toString(),style: const TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 64),
                                  SizedBox(
                                    width: 180,
                                    child: Row(
                                      children: [
                                        const Text("FFE By: "),
                                        Text(shipment.ffeBy.toString(),style: const TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 24),
                                  GestureDetector(
                                    child: Container(
                                      height: 30,
                                      margin: const EdgeInsets.only(right: 12),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        gradient: const LinearGradient(
                                          colors: [
                                            Color(0xFF0057D8),
                                            Color(0xFF1c86ff),
                                          ],
                                          begin: Alignment.centerLeft,
                                          end: Alignment.centerRight,
                                        ),
                                      ),
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.transparent,
                                            shadowColor: Colors.transparent),
                                        onPressed: null,
                                        child: const Text(
                                          'End Examination',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ),
                                    onTap: (){
                                      print("Save");
                                      endExamination(shipment.examinationRowId.toString());


                                    },
                                  ),

                                ],
                              ),

                            ],
                          ),



                          // Column(
                          //   crossAxisAlignment: CrossAxisAlignment.start,
                          //   mainAxisAlignment: MainAxisAlignment.start,
                          //   children: [
                          //     Row(
                          //       crossAxisAlignment: CrossAxisAlignment.start,
                          //       children: [
                          //         const Text("Declared Weight: "),
                          //         Text("${shipment.col6}",style: const TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
                          //       ],
                          //     ),
                          //     // const SizedBox(height: 4),
                          //     // Row(
                          //     //   children: [
                          //     //     const Text("Unit: "),
                          //     //     Text(
                          //     //       "KG",style: const TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
                          //     //   ],
                          //     // ),
                          //   ],
                          // ),

                        ],
                      ),
                      Row(
                        children: [
                          const Text("FFE Date & Time: "),
                          Text(
                            "${shipment.ffeDateTime}",style: const TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
                        ],
                      ),
                    ],
                  ),
                ),

              ],
            ),
          ],
        ),
      ),
    );
  }

  endExamination(String examinationId) async {

    var queryParams = {
      "InputXML": "<Root><Appointment><Appointment><MessageRowID></MessageRowID><QueueRowID></QueueRowID><ElementRowID></ElementRowID><ElementGUID></ElementGUID><Status></Status><RFEPieces></RFEPieces><Remarks></Remarks></Appointment></Appointment><ForwardExamination><ForwardExamination><ExaminationRowId>$examinationId</ExaminationRowId></ForwardExamination></ForwardExamination><CompanyCode>3</CompanyCode><UserId>1</UserId><AirportCity>JFK</AirportCity><Mode>C</Mode></Root>"
    };
    print(queryParams);

    DialogUtils.showLoadingDialog(context);
    await authService
        .postData(
      "CustomExamination/CustomExaminationSave",
      queryParams,
    )
        .then((response) {
      print("data received ");
      Map<String, dynamic> jsonData = json.decode(response.body);
      String? status = jsonData['Status']??"";
      String? statusMessage = jsonData['StatusMessage'] ?? "";
      if (jsonData.isNotEmpty) {
        DialogUtils.hideLoadingDialog(context);
        if (status != "S") {
          showDataNotFoundDialog(context, statusMessage!);
        }
        if ((status == "S")) {
          SnackbarUtil.showSnackbar(
              context, statusMessage!, const Color(0xff43A047));
          searchCustomOperationsData();
        }
      }
    }).catchError((onError) {
      print(onError);
    });
  }

  Widget buildLabel(
      String text, Color color, double radius,
      {bool isBorder = false, Color borderColor = Colors.black, double borderWidth = 1.0}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(radius),
        border: isBorder ? Border.all(color: borderColor, width: borderWidth) : null,
      ),
      child: Center(
        child: Text(
          text,
          style: const TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
        ),
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
    required CustomExamination data,
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
            SizedBox(height: 4,),
            Text(data.col2, style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 8,),
            Row(
              children: [
                Text('Pieces '),
                Text('${data.col5}',style: TextStyle(fontWeight: FontWeight.bold)),

              ],
            ),
          ],
        )),
        DataCell(Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 4,),
            Text("${data.col3}", style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 8,),
            Row(
              children: [
                Text('Weight '),
                Text('${data.col6}', style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
          ],
        )),
        DataCell(TextFormField(
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
        )),
        DataCell(SizedBox(
          width: MediaQuery.sizeOf(context).width * 0.3,
          child: TextField(
            controller:remarksController,
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

  Widget buildRow(
      BuildContext context, {
        required String awbNo,
        required String hawbNo,
        required String pieces,
        required String weight,
        required String agent,
        required String remarks,
        required bool isAccepted,
      }) {
    return Container(
      padding: EdgeInsets.all(8.0),
      color: Color(0xFFF5F8FA), // Background color for rows
      child: Row(
        children: [
          // Accept/Reject Toggle
          Expanded(
            child: Center(
              child: Switch(
                value: isAccepted,
                activeColor: Colors.blue,
                inactiveThumbColor: Colors.red,
                onChanged: (value) {
                  // Handle switch change
                },
              ),
            ),
          ),
          // AWB No. and details
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(awbNo, style: TextStyle(fontWeight: FontWeight.bold)),
                Row(
                  children: [
                    Text("Pieces ", style: TextStyle(color: Colors.grey)),
                    Text(pieces, style: TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
              ],
            ),
          ),
          // HAWB No.
          Expanded(
            flex: 2,
            child: Column(
              children: [
                Center(
                  child: Text(hawbNo, style: TextStyle(color: Colors.black)),
                ),
                Row(
                  children: [
                    Text("Weight ", style: TextStyle(color: Colors.grey)),
                    Text(weight, style: TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
              ],
            ),
          ),
          // RFE Input Field
          Expanded(
            flex: 2,
            child: TextField(
              decoration: InputDecoration(
                hintText: "Enter RFE Pieces",
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4.0)),
                contentPadding: EdgeInsets.symmetric(horizontal: 8.0),
              ),
            ),
          ),
          // Remarks
          Expanded(
            flex: 2,
            child: TextField(
              decoration: InputDecoration(
                hintText: "Remarks here",
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4.0)),
                contentPadding: EdgeInsets.symmetric(horizontal: 8.0),
              ),
            ),
          ),
          // Agent and Remarks
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Agent ", style: TextStyle(color: Colors.grey)),
                Text(agent, style: TextStyle(fontWeight: FontWeight.bold)),
                Text(remarks, style: TextStyle(color: Colors.grey)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
