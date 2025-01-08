import 'dart:convert';

import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:easy_date_timeline/easy_date_timeline.dart';

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
import '../widget/customDialog.dart';
import '../widget/horizontalCalendar.dart';
import 'ImportShipmentListing.dart';
import 'package:xml/xml.dart';

class TestDesigns extends StatefulWidget {
  const TestDesigns({super.key});

  @override
  State<TestDesigns> createState() => _TestDesignsState();
}

class _TestDesignsState extends State<TestDesigns> {
  DateTime _selectedDate = DateTime.now();
  String? selectedTime = '10:00-11:00';
  String? selectedSlot;
  bool? acceptAll = false;
  final AuthService authService = AuthService();
  bool isLoading = false;
  bool hasNoRecord = false;
  String slotFilterDate = "Slot Date";
  DateTime selectedDate = DateTime.now();
  final ScrollController _scrollController = ScrollController();
  List<CustomExaminationData> appointBookingList = [];
  List<Map<String, dynamic>> saveList = [];
  List<CustomExaminationMasterData> masterData = [];
  List<bool?> isOnList = [];
  List<TextEditingController> piecesControllers = [];
  List<TextEditingController> remarksControllers = [];
  List<String>slotList =[];

  DateTime pickedDateFromPicker=DateTime.now();
  DatePickerController pickedDateFromPickerController=DatePickerController();
  final ValueNotifier<DateTime> selectedDateNotifier = ValueNotifier<DateTime>(DateTime.now());
  final List<Map<String, String>> slotData = [
    {"label": "Before 6 AM", "time": "00:00-05:59"},
    {"label": "6 AM - 12 PM", "time": "06:00-11:59"},
    {"label": "12 PM - 6 PM", "time": "12:00-17:59"},
    {"label": "After 6 PM", "time": "18:00-23:59"},
  ];
  final List<String> imagePaths = [
    'assets/images/sunrise.png',
    'assets/images/midday.png',
    'assets/images/sunset.png',
    'assets/images/moon.png',
  ];
  final Set<int> selectedIndices = {};
  Set<String> selectedTimes = {};
  late GlobalKey datePickerKey;
  int totalPcs=0;
  double totalWeight=0.00;

  bool isOn=true;
  @override
  void initState() {
    super.initState();
    datePickerKey = GlobalKey();
    fetchMasterData();
  }

  @override
  void dispose() {

    super.dispose();
  }

  String formatTime(int value) => value.toString().padLeft(2, '0');
  int activeIndex = 0;

  searchCustomOperationsData(String date, String slot) async {
    DialogUtils.showLoadingDialog(context);
    appointBookingList = [];
    masterData = [];
    totalPcs=0;
    totalWeight=0.00;
    setState(() {
      hasNoRecord=true;
    });
    var queryParams = {
      "InputXml":
      "<Root><CompanyCode>3</CompanyCode><UserId>1</UserId><AirportCity>JFK</AirportCity><Mode>S</Mode><SlotDate>${date}</SlotDate><SlotTime>${slot}</SlotTime></Root>"
    };

    await authService
        .sendGetWithBody("CustomExamination/GetCustomExamination", queryParams)
        .then((response) {
      print("data received ");
      Map<String, dynamic> jsonData = json.decode(response.body);

      print(jsonData);
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
          setState(() {
            hasNoRecord=true;
          });
          DialogUtils.hideLoadingDialog(context);
          return;
        }
        setState(() {
          hasNoRecord=false;
        });
        setState(() {
          List<CustomExaminationMasterData> tempList = resp
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
          print("length==  = ${masterData.length}");
          print(masterData.toList());

          appointBookingList=mergeLists(tempList,masterData);
          totalPcs = masterData.fold(0, (sum, pc) => sum + int.parse(pc.col7));
          totalWeight = masterData.fold(0, (sum, wt) => sum + double.parse(wt.col8));
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

      }
      DialogUtils.hideLoadingDialog(context);
    }).catchError((onError) {
      DialogUtils.hideLoadingDialog(context);
      print(onError);
    });
  }



  void fetchMasterData() async {
    await Future.delayed(Duration.zero);
    DateTime today = DateTime.now();
    var formatter = DateFormat('dd-MM-yyyy');
    String formattedDate = formatter.format(today);
    setState(() {
      slotFilterDate = formattedDate;
    });
    searchCustomOperationsData(formattedDate,"");
  }

  saveBookings() async {
    FocusScope.of(context).requestFocus(FocusNode());
    String xml = buildInputXml(
      saveList: saveList,
      companyCode: "3",
      userId: "1",
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
        .then((response) async {
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
            searchCustomOperationsData(slotFilterDate,selectedTimes.join(','));
          }

        }

      }
      DialogUtils.hideLoadingDialog(context);
    }).catchError((onError) {
      print(onError);
    });
  }

  void _centerSelectedItem() {
        int index = selectedDate.difference(DateTime.now()).inDays;
    _scrollController.animateTo(
      2 * 105.0 - (MediaQuery.of(context).size.width / 2) + 52.5,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
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
                                      '  TestDesigns',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 22),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(height: 20),
                            Column(
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      height:168,
                                      width: MediaQuery.sizeOf(context).width*0.47,

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
                                            vertical: 10, horizontal: 10),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                const Text(" Slot Date",style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                ),),
                                                GestureDetector(
                                                  child: Row(
                                                    children: [
                                                      // Text(
                                                      //   slotFilterDate,
                                                      //   style: const TextStyle(
                                                      //       fontSize: 16,
                                                      //       color: MyColor
                                                      //           .primaryColorblue),
                                                      // ),
                                                      // const SizedBox(width: 8),
                                                      const Icon(Icons.calendar_today,
                                                          color: MyColor
                                                              .primaryColorblue),
                                                    ],
                                                  ),
                                                  onTap: () {
                                                    pickDate(context, setState);
                                                  },
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 4,),
                                            SizedBox(
                                              height: 104,
                                              child: ListView.builder(
                                                itemCount: 30,
                                                controller:_scrollController ,
                                                scrollDirection: Axis.horizontal,
                                                itemBuilder: (ctx, index) {

                                                  DateTime currentDay = selectedDate.add(Duration(days: index-2));
                                                 // print("---$currentDay");
                                                  bool isPickedDate = currentDay.day == selectedDate.day &&
                                                      currentDay.month == selectedDate.month &&
                                                      currentDay.year == selectedDate.year;

                                                  return FittedBox(
                                                    child: GestureDetector(
                                                      child: Container(
                                                        width: 90,
                                                        height: 145,

                                                        alignment: Alignment.center,
                                                        decoration: BoxDecoration(
                                                          color: isPickedDate
                                                              ?  MyColor.primaryColorblue
                                                              :Colors.white,
                                                          borderRadius: BorderRadius.circular(16.0),
                                                        ),
                                                        padding: const EdgeInsets.all(15.0),
                                                        child: Column(
                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                          children: <Widget>[
                                                            Text(
                                                              DateFormat('MMM').format(currentDay).toUpperCase(), // Month format
                                                              style: TextStyle(
                                                                fontSize: 20,
                                                                fontWeight:FontWeight.bold,
                                                                color: isPickedDate
                                                                    ? Colors.white
                                                                    : Colors.black87,
                                                              ),
                                                            ),
                                                            const SizedBox(height: 5),
                                                            Text(
                                                              "${currentDay.day}",
                                                              style: TextStyle(
                                                                fontSize: 25,
                                                                fontWeight: FontWeight.bold,
                                                                color: isPickedDate
                                                                    ? Colors.white
                                                                    : Colors.black87,
                                                              ),
                                                            ),
                                                            const SizedBox(height: 5),
                                                            Text(
                                                              DateFormat('EE').format(currentDay).toUpperCase(),
                                                              style: TextStyle(
                                                                fontSize: 18,
                                                                color:
                                                                isPickedDate ? Colors.white : Colors.black87,
                                                                fontWeight: FontWeight.bold,
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                      onTap: (){
                                                        setState(() {
                                                          selectedDate = currentDay;
                                                          var formatter = DateFormat('dd-MM-yyyy');
                                                          String formattedDate = formatter.format(selectedDate);
                                                          slotFilterDate=formattedDate;
                                                          searchCustomOperationsData(formattedDate,"${selectedTimes.join(',')}");
                                                        });
                                                        _centerSelectedItem();
                                                      },
                                                    ),
                                                  );
                                                },
                                              ),
                                            ),
                                            // SizedBox(
                                            //   height: 120,
                                            //   child:  Column(
                                            //     mainAxisAlignment: MainAxisAlignment.center,
                                            //     children: [
                                            //       EasyDateTimeLine(
                                            //         initialDate: DateTime.now(),
                                            //         onDateChange: (selectedDate) {
                                            //           //[selectedDate] the new date selected.
                                            //         },
                                            //         activeColor: const Color(0xffFFBF9B),
                                            //         dayProps: const EasyDayProps(
                                            //           dayStructure: DayStructure.dayNumDayStr,
                                            //           inactiveBorderRadius: 48.0,
                                            //           height: 56.0,
                                            //           width: 56.0,
                                            //           activeDayNumStyle: TextStyle(
                                            //             fontSize: 18.0,
                                            //             fontWeight: FontWeight.bold,
                                            //           ),
                                            //           inactiveDayNumStyle: TextStyle(
                                            //             fontSize: 18.0,
                                            //           ),
                                            //         ),
                                            //       )
                                            //     ],
                                            //   ),
                                            // ),
                                          ],
                                        ),
                                      ),),
                                    Spacer(),
                                    Container(
                                      height:168,
                                      width: MediaQuery.sizeOf(context).width*0.47,

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
                                            vertical: 10, horizontal: 10),
                                        child:Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            const Text(" Slot Schedule",style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: List.generate(slotData.length, (index) {
                                                final bool isSelected = selectedIndices.contains(index);
                                                return GestureDetector(
                                                  onTap: () {

                                                    setState(() {
                                                      if (isSelected) {
                                                        selectedIndices.remove(index);
                                                        selectedTimes.remove(slotData[index]["time"]);
                                                      } else {
                                                        selectedIndices.add(index);
                                                        selectedTimes.add(slotData[index]["time"]!);
                                                      }
                                                    });
                                                    print("Selected Times: ${selectedTimes.join(', ')}");
                                                    searchCustomOperationsData(slotFilterDate,"${selectedTimes.join(',')}");
                                                  },
                                                  child: Container(
                                                    margin: EdgeInsets.all(4.0),
                                                    width: 80,
                                                    padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
                                                    decoration: BoxDecoration(
                                                      color: isSelected ? MyColor.primaryColorblue : Colors.white,
                                                      border: Border.all(color: Colors.grey),
                                                      borderRadius: BorderRadius.circular(8.0),
                                                    ),
                                                    child: Column(
                                                      mainAxisSize: MainAxisSize.min,
                                                      children: [
                                                        Image.asset(
                                                          imagePaths[index],
                                                          height: 40,
                                                          width: 40,
                                                          color: isSelected ? Colors.white : null,
                                                        ),
                                                        SizedBox(height: 8.0),
                                                        Text(
                                                          slotData[index]['label']!,
                                                          textAlign: TextAlign.center,
                                                          style: TextStyle(
                                                            color: isSelected ? Colors.white : Colors.black,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              }),
                                            ),
                                          ],
                                        ),
                                      ),),
                                  ],
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Container(
                                  padding:  const EdgeInsets.symmetric(
                                      vertical: 14, horizontal: 10),
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
                                  child: Column(
                                    children: [
                                      // Row(
                                      //   crossAxisAlignment: CrossAxisAlignment.center,
                                      //   mainAxisAlignment: MainAxisAlignment.start,
                                      //   children: [
                                      //     Row(
                                      //       mainAxisAlignment: MainAxisAlignment.start,
                                      //       children: [
                                      //
                                      //         Center(
                                      //           child: Text("  Station Name(s):  ",style: TextStyle(
                                      //             fontWeight: FontWeight.bold,
                                      //             fontSize: 18,
                                      //
                                      //           ),),
                                      //         ),
                                      //         Text("Station 1, Station 2,",style: TextStyle(
                                      //           fontSize: 20,
                                      //           fontWeight: FontWeight.bold,
                                      //         ),),
                                      //       ],
                                      //     ),
                                      //
                                      //
                                      //   ],
                                      // ),
                                      // SizedBox(height: 20,),
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [

                                              Center(
                                                child: Text("  Total Pieces  ",style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16,
                                                  color: Colors.grey[700],
                                                ),),
                                              ),
                                              Text("$totalPcs",style: const TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                              ),),
                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [

                                              Center(
                                                child: Text("Total Shipments  ",style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16,
                                                  color: Colors.grey[700],
                                                ),),
                                              ),
                                              Text("${totalWeight.toStringAsFixed(2)}",style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                              ),),
                                            ],
                                          ),


                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                (!hasNoRecord)
                                    ? SingleChildScrollView(
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        top: 8.0, left: 0.0, bottom: 100),
                                    child: SizedBox(
                                      width: MediaQuery.of(context)
                                          .size
                                          .width /
                                          1.01,
                                      child: ListView.builder(
                                        physics:
                                        const NeverScrollableScrollPhysics(),
                                        itemBuilder:
                                            (BuildContext, index) {
                                          CustomExaminationData
                                          shipmentDetails =
                                          appointBookingList
                                              .elementAt(index);
                                          return buildShipmentCardV3(
                                              shipmentDetails,
                                              isOnList[index],
                                              index,
                                                  (value) => checkboxChanged(
                                                  value, index),
                                              piecesControllers[index],
                                              remarksControllers[index]);
                                        },
                                        itemCount:
                                        appointBookingList.length,
                                        shrinkWrap: true,

                                      ),
                                    ),
                                  ),
                                )
                                    : Container(
                                  height:
                                  MediaQuery.of(context).size.height /
                                      1.5,
                                  child: Center(
                                    child: Lottie.asset(
                                        'assets/images/nodata.json'),
                                  ),
                                ),
                                SizedBox(
                                  height:
                                  MediaQuery.sizeOf(context).height * 0.010,
                                ),
                                (!hasNoRecord)
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
                                SizedBox(
                                  height:
                                  MediaQuery.sizeOf(context).height * 0.02,
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

  Widget buildShipmentCardV2(
      CustomExaminationData shipment,
      bool? isOn,
      int index,
      ValueChanged<bool?> onCheckboxChanged,
      TextEditingController piecesController,
      TextEditingController remarksController,
      ) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 2),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      shipment.col2,
                      style:
                      TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              " HAWB No: ",
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              shipment.col3,
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        Row(
                          children: [
                            Text(
                              " Pieces: ",
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              shipment.col5,
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        Row(
                          children: [
                            Text(
                              " Agent: ",
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              shipment.col1,
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                        // Row(
                        //   children: [
                        //     const Text("Unit: "),
                        //     Text("",style: const TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
                        //   ],
                        // ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(width: 8),
                buildLabel("AWB", Colors.deepPurpleAccent, 8,
                    isBorder: true, borderColor: Colors.deepPurpleAccent),
                // const SizedBox(width: 8),
                // SizedBox(
                //     width: MediaQuery.sizeOf(context).width*0.11,
                //     child: buildLabel((false)?"DIRECT":"CONSOL", Colors.white,8,isBorder: true,borderColor: Colors.grey)),
                const SizedBox(width: 20),
                buildLabel(shipment.col4, Colors.lightBlue, 20),
                const SizedBox(width: 8),
                Row(
                  children: [
                    Text(
                      shipment.slot!,
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(width: 8),
                    Icon(
                      Icons.info_outline_rounded,
                      color: MyColor.primaryColorblue,
                    ),
                  ],
                ),
                SizedBox(
                  width: 8,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 200,
                      child: TextFormField(
                        controller: piecesController,
                        decoration: InputDecoration(
                          hintText: 'Enter RFE Pieces',
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 0, horizontal: 15),
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
                            shipment.col7 = value;
                          });
                        },
                      ),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    SizedBox(
                      width: 200,
                      child: TextFormField(
                        maxLines: 2,
                        controller: remarksController,
                        decoration: InputDecoration(
                          hintText: 'Enter Remarks',
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 12, horizontal: 15),
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
                            remarksControllers[index].text = value;
                            shipment.col8 = value;
                          });
                        },
                      ),
                    )
                  ],
                ),
                Center(
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 40, horizontal: 24),
                    child: Theme(
                      data: ThemeData(useMaterial3: false),
                      child: Transform.scale(
                        scale: 2.5,
                        child: Checkbox(
                          isError: true,
                          tristate: true,
                          activeColor: isOn == null
                              ? Colors.red
                              : isOn!
                              ? Colors.green
                              : MyColor.primaryColorblue,
                          value: isOn,
                          onChanged: (bool? value) {
                            setState(() {
                              onCheckboxChanged(value);
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
                              // border color based on state
                              width: 2,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
          ],
        ),
      ),
    );
  }

  Widget buildShipmentCardV3(
      CustomExaminationData shipment,
      bool? isOn,
      int index,
      ValueChanged<bool?> onCheckboxChanged,
      TextEditingController piecesController,
      TextEditingController remarksController,
      ) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 2),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      shipment.col2,
                      style:
                      TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const Text(
                              " HAWB No: ",
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              shipment.col3,
                              style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        Row(
                          children: [
                            const Text(
                              " Pieces: ",
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              shipment.col5,
                              style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        Row(
                          children: [
                            const Text(
                              " Agent: ",
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              shipment.col1,
                              style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                        // Row(
                        //   children: [
                        //     const Text("Unit: "),
                        //     Text("",style: const TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
                        //   ],
                        // ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(width: 8),
                buildLabel("AWB", Colors.deepPurpleAccent, 8,
                    isBorder: true, borderColor: Colors.deepPurpleAccent),
                // const SizedBox(width: 8),
                // SizedBox(
                //     width: MediaQuery.sizeOf(context).width*0.11,
                //     child: buildLabel((false)?"DIRECT":"CONSOL", Colors.white,8,isBorder: true,borderColor: Colors.grey)),
                const SizedBox(width: 20),
                buildLabel(shipment.col4, Colors.lightBlue, 20),
                const SizedBox(width: 8),
                Row(
                  children: [
                    Text(
                      shipment.slot!,
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(width: 8),
                    Icon(
                      Icons.info_outline_rounded,
                      color: MyColor.primaryColorblue,
                    ),
                  ],
                ),
                SizedBox(
                  width: 8,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 200,
                      child: TextFormField(
                        controller: piecesController,
                        decoration: InputDecoration(
                          hintText: 'Enter RFE Pieces',
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 0, horizontal: 15),
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
                            shipment.col7 = value;
                          });
                        },
                      ),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    SizedBox(
                      width: 200,
                      child: TextFormField(
                        maxLines: 2,
                        controller: remarksController,
                        decoration: InputDecoration(
                          hintText: 'Enter Remarks',
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 12, horizontal: 15),
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
                            remarksControllers[index].text = value;
                            shipment.col8 = value;
                          });
                        },
                      ),
                    )
                  ],
                ),
                Center(
                  child: Container(
                    padding: EdgeInsets.only(top: 40, left: 18),
                    child: Theme(
                      data: ThemeData(useMaterial3: false),
                      child: Transform.scale(
                        scale: 2.5,
                        child: Checkbox(
                          // isError: true,
                          tristate: true,
                          activeColor: isOn == null
                              ? Colors.red
                              : isOn!
                              ? Colors.green
                              : MyColor.primaryColorblue,
                          value: isOn,
                          onChanged: (bool? value) {
                            setState(() {
                              onCheckboxChanged(value);
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
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
          ],
        ),
      ),
    );
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

  List<CustomExaminationData> mergeLists(List<CustomExaminationMasterData> listA, List<CustomExaminationMasterData> listB) {
    Map<int, CustomExaminationMasterData> mapB = {
      for (var item in listB) item.queueRowId: item,
    };
    List<CustomExaminationData> result = listA.map((itemA) {
      CustomExaminationMasterData? matchingItemB = mapB[itemA.queueRowId];
      return CustomExaminationData(
        rowId: itemA.rowId,
        messageRowId: itemA.messageRowId,
        queueRowId: itemA.queueRowId,
        elementRowId: itemA.elementRowId,
        elementGuid: itemA.elementGuid,
        col1: itemA.col1,
        col2: itemA.col2,
        col3: itemA.col3,
        col4: itemA.col4,
        col5: itemA.col5,
        col6: itemA.col6,
        col7: itemA.col7,
        col8: itemA.col8,
        slot: "${matchingItemB?.col3}-${matchingItemB?.col4}",
      );
    }).toList();

    return result;
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
          final customExamination = item['item'] as CustomExaminationData;
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
          final customExamination = item['item'] as CustomExaminationData;
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
        pickedDateFromPicker=pickedDate;
        slotFilterDate = DateFormat('dd-MM-yyyy').format(pickedDate);
        selectedDateNotifier.value = pickedDate;
        print("DATE is $slotFilterDate");
      });
      // pickedDateFromPickerController.animateToDate(pickedDateFromPicker);

      // searchCustomOperationsData(slotFilterDate,"${selectedTimes.join(',')}");

    }
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

}



// class DatePickerCustom extends StatefulWidget {
//   const DatePickerCustom({Key? key}) : super(key: key);
//
//   @override
//   State<DatePickerCustom> createState() => _DatePickerCustomState();
// }
//
// class _DatePickerCustomState extends State<DatePickerCustom> {
//   int selectedIndex = 0;
//   DateTime now = DateTime.now();
//   late DateTime lastDayOfMonth;
//   late DateTime firstDayOfMonth;
//
//   @override
//   void initState() {
//     super.initState();
//     // Get the first and last days of the current month
//     firstDayOfMonth = DateTime(now.year, now.month, 1);
//     lastDayOfMonth = DateTime(now.year, now.month + 1, 0); // Last day of current month
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         toolbarHeight: 148.0,
//         title: Column(
//           children: [
//             Row(
//               children: const [
//                 Icon(
//                   Icons.arrow_back_ios,
//                   color: Colors.orange,
//                 ),
//                 Expanded(
//                     child: Text("Workout",
//                         textAlign: TextAlign.center,
//                         style: TextStyle(
//                           color: Colors.black,
//                         ))),
//               ],
//             ),
//             const SizedBox(height: 16.0),
//             // Wrap the Row with SingleChildScrollView for horizontal scrolling
//             SingleChildScrollView(
//               scrollDirection: Axis.horizontal,
//               child: Row(
//                 children: List.generate(
//                   lastDayOfMonth.day,
//                       (index) {
//                     final currentDate =
//                     firstDayOfMonth.add(Duration(days: index));
//                     final dayName = DateFormat('E').format(currentDate);
//                     return Padding(
//                       padding: EdgeInsets.only(
//                           left: index == 0 ? 16.0 : 0.0, right: 16.0),
//                       child: GestureDetector(
//                         onTap: () => setState(() {
//                           selectedIndex = index;
//                         }),
//                         child: Column(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Container(
//                               height: 42.0,
//                               width: 42.0,
//                               alignment: Alignment.center,
//                               decoration: BoxDecoration(
//                                 color: selectedIndex == index
//                                     ? Colors.orange
//                                     : Colors.transparent,
//                                 borderRadius: BorderRadius.circular(44.0),
//                               ),
//                               child: Text(
//                                 dayName.substring(0, 1),
//                                 style: TextStyle(
//                                   fontSize: 24.0,
//                                   color: selectedIndex == index
//                                       ? Colors.white
//                                       : Colors.black54,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                             ),
//                             const SizedBox(height: 8.0),
//                             Text(
//                               "${index + 1}",
//                               style: const TextStyle(
//                                 fontSize: 16.0,
//                                 color: Colors.black54,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                             const SizedBox(height: 8.0),
//                             Container(
//                               height: 2.0,
//                               width: 28.0,
//                               color: selectedIndex == index
//                                   ? Colors.orange
//                                   : Colors.transparent,
//                             ),
//                           ],
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
