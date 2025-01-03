import 'dart:convert';

import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:easy_date_timeline/easy_date_timeline.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import '../../core/images.dart';
import '../../core/mycolor.dart';
import '../../module/onboarding/sizeconfig.dart';
import '../../utils/dialogutils.dart';
import '../../utils/sizeutils.dart';
import '../../utils/snackbarutil.dart';
import '../../widget/customebuttons/roundbuttonblue.dart';
import '../../widget/customeedittext/customeedittextwithborder.dart';
import '../../widget/custometext.dart';
import '../auth/auth.dart';
import '../modal/CustomsOperations.dart';
import '../modal/ShipmentAcceptanceModal.dart';
import '../modal/forwardForExam.dart';
import '../utils/global.dart';
import '../widget/customDialog.dart';
import '../widget/customIpadTextfield.dart';
import '../widget/horizontalCalendar.dart';
import 'ImportShipmentListing.dart';
import 'package:xml/xml.dart';

class OnHandShipment extends StatefulWidget {
  const OnHandShipment({super.key});

  @override
  State<OnHandShipment> createState() => _OnHandShipmentState();
}

class _OnHandShipmentState extends State<OnHandShipment> {
  DateTime _selectedDate = DateTime.now();
  String? selectedTime = '10:00-11:00';
  String? selectedSlot;
  bool? acceptAll = false;
  final AuthService authService = AuthService();
  bool isLoading = false;
  bool hasNoRecord = false;
  String slotFilterDate = "Slot Date";
  DateTime? selectedDate;
  List<OnHandShipReq> appointBookingList = [];
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
  TextEditingController commTypeController = TextEditingController();
  TextEditingController toDateController = TextEditingController();
  TextEditingController fromDateController = TextEditingController();
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

  searchOnHandRequests(String fromDate, String toDate,String comm) async {
    DialogUtils.showLoadingDialog(context);
    appointBookingList = [];
    totalPcs=0;
    totalWeight=0.00;
    setState(() {
      hasNoRecord=true;
    });
    var queryParams = {
      "FromDate": fromDate,
      "ToDate": toDate,
      "Commodity": comm.isEmpty?"-1":comm,
      "CompanyCode": "3",
      "UserID": 1,
      "AirportCode": "JFK",
      "CultureCode": "en-US",
      "MenuId": 1
    };

    await authService
        .sendGetWithBody("OnHandShipment/GetListReqForExamination", queryParams)
        .then((response) {
      print("data received ");
      Map<String, dynamic> jsonData = json.decode(response.body);

      print(jsonData);
      print("is empty record$hasNoRecord");
      String status = jsonData['Status'];
      String statusMessage = jsonData['StatusMessage'];

      if (status == 'E') {
        print("Error: $statusMessage");
        DialogUtils.hideLoadingDialog(context);
        showDataNotFoundDialog(context, statusMessage);
        return;
      } else {
        List<dynamic> resp = jsonData['OnHandShiReqForExamList'];
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
         

          appointBookingList=resp.map((data)=>OnHandShipReq.fromJson(data)).toList();
          totalPcs = appointBookingList.fold(0, (sum, pc) => sum + pc.pieces);
          totalWeight = appointBookingList.fold(0, (sum, wt) => sum + wt.weight);
        });

        setState(() {
          isOnList = List.generate(appointBookingList.length, (index) => false);
          piecesControllers = List.generate(
              appointBookingList.length,
                  (index) =>
                  TextEditingController(text: appointBookingList[index].rfePieces.toString()));
          print("Piecs${appointBookingList.first.rfePieces}");
          remarksControllers = List.generate(
              appointBookingList.length,
                  (index) =>
                  TextEditingController(text: appointBookingList[index].remarks));
        });

      }
      DialogUtils.hideLoadingDialog(context);
    }).catchError((onError) {
      DialogUtils.hideLoadingDialog(context);
      print(onError);
    });
  }

  void showShipmentSearchBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      constraints: const BoxConstraints(
        minWidth: double.infinity,
      ),

      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Padding(
                  padding:  EdgeInsets.only( bottom: MediaQuery.of(context).viewInsets.bottom),
                  child: SizedBox(
                    width: MediaQuery.sizeOf(context).width,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text("Filter",
                                style: TextStyle(
                                    fontSize: 24, fontWeight: FontWeight.bold)),
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
                                  commTypeController.clear();
                                  fromDateController.clear();
                                  toDateController.clear();
                                });

                              },
                            )
                          ],
                        ),

                        const SizedBox(
                          width: double.infinity,
                          child: Divider(color: Colors.grey),
                        ),
                        const SizedBox(height: 4),
                        SizedBox(
                          width: MediaQuery.sizeOf(context).width,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'FILTER BY DATE',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  const SizedBox(height: 16),
                                  Row(
                                    children: [
                                      SizedBox(
                                        height:
                                        MediaQuery.sizeOf(
                                            context)
                                            .height *
                                            0.04,
                                        width:
                                        MediaQuery.sizeOf(
                                            context)
                                            .width *
                                            0.44,
                                        child:
                                        CustomeEditTextWithBorderDatePicker(
                                          lablekey: 'MAWB',
                                          controller:
                                          fromDateController,
                                          labelText:
                                          "From Date",
                                          readOnly: false,
                                          maxLength: 15,
                                          fontSize: 18,
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 15,
                                      ),
                                      SizedBox(
                                        height:
                                        MediaQuery.sizeOf(
                                            context)
                                            .height *
                                            0.04,
                                        width:
                                        MediaQuery.sizeOf(
                                            context)
                                            .width *
                                            0.44,
                                        child:
                                        CustomeEditTextWithBorderDatePicker(
                                          lablekey: 'MAWB',
                                          controller:
                                          toDateController,
                                          labelText:
                                          "To Date",
                                          readOnly: false,
                                          maxLength: 15,
                                          fontSize: 18,
                                        ),
                                      )
                                    ],
                                  ),
                                  const SizedBox(height: 16),
                                ],
                              ),

                            ],
                          ),
                        ),
                        const Divider(color: Colors.grey),
                        const SizedBox(height: 8),
                        const Text('SORT BY COMMODITY',
                            style: TextStyle(fontSize: 16)),
                        const SizedBox(height: 16),
                        SizedBox(
                          height:
                          MediaQuery.sizeOf(
                              context)
                              .height *
                              0.04,
                          width: MediaQuery.of(context).size.width*0.44,
                          child:  TypeAheadField<Commodity>(
                            controller: commTypeController,
                            debounceDuration: const Duration(
                                milliseconds: 300),
                            suggestionsCallback: (search){
                              if (search.isEmpty) {
                                return null;
                              }
                              return CommodityService.find(search);},
                            itemBuilder: (context, item) {
                              return Container(
                                decoration:
                                const BoxDecoration(
                                  border: Border(
                                    top: BorderSide(
                                        color: Colors.black,
                                        width: 0.2),
                                    left: BorderSide(
                                        color: Colors.black,
                                        width: 0.2),
                                    right: BorderSide(
                                        color: Colors.black,
                                        width: 0.2),
                                    bottom: BorderSide
                                        .none, // No border on the bottom
                                  ),
                                ),
                                padding:
                                const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    Text(item.commodityType
                                        .toUpperCase()),
                                  ],
                                ),
                              );
                            },
                            builder: (context, controller,
                                focusNode) =>
                                CustomeEditTextWithBorder(
                                  lablekey: 'MAWB',
                                  controller: controller,
                                  focusNode: focusNode,
                                  hasIcon: false,
                                  hastextcolor: true,
                                  animatedLabel: true,
                                  needOutlineBorder: true,
                                  noUpperCase: true,
                                  onPress: () {},
                                  labelText:
                                  "Commodity",
                                  readOnly: false,
                                  fontSize: 18,
                                  onChanged: (String, bool) {},
                                ),
                            decorationBuilder:
                                (context, child) => Material(
                              type: MaterialType.card,
                              elevation: 4,
                              borderRadius:
                              BorderRadius.circular(8.0),
                              child: child,
                            ),
                            // itemSeparatorBuilder: (context, index) =>
                            //     Divider(),
                            emptyBuilder: (context) =>
                            const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                  'No Commodity Found',
                                  style: TextStyle(
                                      fontSize: 16)),
                            ),
                            onSelected: (value) {
                              setState((){
                                commTypeController.text = value
                                    .commodityType;
                                print(commTypeController.text);
                              });

                            },
                          ),
                        ),
                         SizedBox(height: MediaQuery.sizeOf(
                            context)
                            .height *
                            0.12,),

                        Container(
                          width: double.infinity,
                          child: const Divider(color: Colors.grey),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment:
                          MainAxisAlignment.spaceAround,
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
                                  commTypeController.clear();
                                  fromDateController.clear();
                                  toDateController.clear();
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
                                  if(fromDateController.text.isNotEmpty){
                                    DateTime fromDateTime = DateFormat('dd/MM/yyyy').parse(fromDateController.text.trim());
                                    DateTime toDateTime = DateFormat('dd/MM/yyyy').parse(toDateController.text.trim());

                                    String formattedFromDate = DateFormat('MM/dd/yyyy').format(fromDateTime);
                                    String formattedToDate = DateFormat('MM/dd/yyyy').format(toDateTime);
                                    searchOnHandRequests(formattedFromDate,formattedToDate,commTypeController.text);

                                    Navigator.pop(context);
                                  }
                                  //getShipmentListing(mawbNo:"${prefixController.text.trim()}${awbController.text.trim()}",statusFilter: selectedFilters.join(","));

                                },
                                child: const Text(
                                  "Search",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ],
                        ),
                        // ElevatedButton(
                        //   onPressed: () {
                        //     Navigator.pop(context);
                        //     // filterShipments();
                        //     setState(() {
                        //       // isFilterApplied = true;
                        //     });
                        //   },
                        //   style: ElevatedButton.styleFrom(
                        //     backgroundColor: MyColor.primaryColorblue,
                        //     minimumSize: const Size.fromHeight(50),
                        //   ),
                        //   child: const Text("SEARCH",
                        //       style: TextStyle(color: Colors.white)),
                        // ),
                        // const SizedBox(height: 16),
                        // OutlinedButton(
                        //   onPressed: () {
                        //     setState(() {
                        //       // selectedFilters.clear();
                        //       // isFilterApplied = false;
                        //       // selectedDate = null;
                        //       // slotFilterDate = "Slot Date";
                        //     });
                        //     Navigator.pop(context);
                        //     // filterShipments();
                        //   },
                        //   style: OutlinedButton.styleFrom(
                        //     side: const BorderSide(color: MyColor.primaryColorblue),
                        //     minimumSize: const Size.fromHeight(50),
                        //     shape: RoundedRectangleBorder(
                        //       borderRadius: BorderRadius.circular(10),
                        //     ),
                        //   ),
                        //   child: const Text(
                        //     "RESET",
                        //     style: TextStyle(color:MyColor.primaryColorblue),
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  void fetchMasterData() async {
    await Future.delayed(Duration.zero);
    DateTime today = DateTime.now();
    var formatter = DateFormat('MM/dd/yyyy');
    String formattedDate = formatter.format(today);
    setState(() {
      slotFilterDate = formattedDate;
    });
    searchOnHandRequests(formattedDate,formattedDate,"");
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
                                      '  On Hand Shipment',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 22),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    GestureDetector(
                                      child: const Row(
                                        children: [
                                          Icon(
                                            Icons.filter_alt_outlined,
                                            color: MyColor.primaryColorblue,
                                          ),
                                          Text(
                                            ' Filter',
                                            style: TextStyle(fontSize: 18),
                                          )
                                        ],
                                      ),
                                      onTap: () {
                                        showShipmentSearchBottomSheet(context);
                                      },
                                    ),
                                  ],
                                )
                              ],
                            ),
                            SizedBox(height: 20),
                            Column(
                              children: [

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
                                              OnHandShipReq
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

  Widget buildShipmentCardV3(
      OnHandShipReq shipment,
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
                    SizedBox(
                      width: MediaQuery.sizeOf(context).width*0.20,
                      child: Text(
                        shipment.awb,
                        style:
                        const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(
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
                              shipment.hawb,
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
                              shipment.pieces.toString(),
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
                              " Weight: ",
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              shipment.weight.toStringAsFixed(2),
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

                const SizedBox(width: 8),
                Row(
                  children: [
                    buildLabel(shipment.commodity.toUpperCase(),  Color(0xffCCDFFA), 8,
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
                            shipment.rfePieces = int.parse(value);
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
                            shipment.remarks = value;
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
                        child:Checkbox(
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

