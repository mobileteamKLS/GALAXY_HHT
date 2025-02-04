import 'dart:convert';

import 'package:date_picker_timeline/date_picker_widget.dart';
// import 'package:easy_date_timeline/easy_date_timeline.dart';

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
  List<OnHandShipReq> onHandShipmentList = [];
  List<Map<String, dynamic>> saveList = [];
  List<CustomExaminationMasterData> masterData = [];
  List<bool?> isOnList = [];
  List<TextEditingController> piecesControllers = [];
  List<TextEditingController> remarksControllers = [];
  List<String>slotList =[];
  String selectedIndex = "P";

  DateTime pickedDateFromPicker=DateTime.now();
  DatePickerController pickedDateFromPickerController=DatePickerController();


  int totalPcs=0;
  double totalWeight=0.00;
  TextEditingController commTypeController = TextEditingController();
  TextEditingController toDateController = TextEditingController();
  TextEditingController fromDateController = TextEditingController();
  TextEditingController prefixController = TextEditingController();
  TextEditingController awbController = TextEditingController();
  bool isOn=true;
  @override
  void initState() {
    super.initState();
    fetchMasterData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  String formatTime(int value) => value.toString().padLeft(2, '0');
  int activeIndex = 0;

  searchOnHandRequests(String fromDate, String toDate,String comm,String status,String awbNo) async {
    DialogUtils.showLoadingDialog(context);
    onHandShipmentList = [];
    remarksList=[];
    saveList=[];
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
      "UserID": userId,
      "AirportCode": "JFK",
      "CultureCode": "en-US",
      "MenuId": 1,
      "ShipmentStatus": status,
      "FilterClause": awbNo
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
        List<dynamic> remarks = jsonData['RemakrsData'];
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

          onHandShipmentList=resp.map((data)=>OnHandShipReq.fromJson(data)).toList();
          remarksList=remarks.map((data)=>RemarksData.fromJson(data)).toList();
          totalPcs = onHandShipmentList.fold(0, (sum, pc) => sum + pc.pieces);
          totalWeight = onHandShipmentList.fold(0, (sum, wt) => sum + wt.weight);

        });

        setState(() {
          isOnList = List.generate(onHandShipmentList.length, (index) => false);
          piecesControllers = List.generate(
              onHandShipmentList.length,
                  (index) =>
                  TextEditingController(text: onHandShipmentList[index].rfePieces.toString()));
          print("Piecs${onHandShipmentList.first.rfePieces}");
          remarksControllers = List.generate(
              onHandShipmentList.length,
                  (index) =>
                  TextEditingController(text: onHandShipmentList[index].remarks));
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
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom,left: 16,right: 16,top: 16),
              child: SingleChildScrollView(
                child: Padding(
                  padding:  const EdgeInsets.only( bottom: 0),
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
                                  awbController.clear();
                                  prefixController.clear();
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
                        const SizedBox(height: 4),
                        SizedBox(
                          width: MediaQuery.sizeOf(context).width*0.7,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'FILTER BY AWB No.',
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
                                            0.1,
                                        child:
                                        CustomeEditTextWithBorder(
                                          lablekey: 'MAWB',
                                          hasIcon: false,
                                          controller: prefixController,
                                          hastextcolor: true,
                                          textInputType:
                                          TextInputType
                                              .number,
                                          animatedLabel: true,
                                          needOutlineBorder:
                                          true,
                                          labelText: "Prefix*",
                                          readOnly: false,
                                          maxLength: 15,
                                          fontSize: 18,
                                          onChanged:
                                              (String, bool) {},
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
                                            0.32,
                                        child:
                                        CustomeEditTextWithBorder(
                                          lablekey: 'MAWB',
                                          hasIcon: false,
                                          textInputType:
                                          TextInputType
                                              .number,
                                          controller: awbController,
                                          hastextcolor: true,
                                          animatedLabel: true,
                                          needOutlineBorder:
                                          true,
                                          labelText: "AWB No*",
                                          readOnly: false,
                                          maxLength: 15,
                                          fontSize: 18,
                                          onChanged:
                                              (String, bool) {},
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
                        const SizedBox(height: 8),
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
                        const SizedBox(height: 8),
                        const Text('SORT BY STATUS',
                            style: TextStyle(fontSize: 16)),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: Wrap(
                            spacing: 8.0,
                            children: [
                              ChoiceChip(
                                label: const Text('Pending for RFE',style: TextStyle(color: MyColor.primaryColorblue),),
                                selected: selectedIndex == "P",

                                showCheckmark: false,
                                selectedColor: MyColor.dropdownColor,
                                backgroundColor: MyColor.dropdownColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                  side: BorderSide(
                                    color: selectedIndex == "P" ? MyColor.primaryColorblue : Colors.transparent,
                                  ),
                                ),
                                checkmarkColor: MyColor.primaryColorblue,
                                onSelected: (bool selected) {
                                  setState(() {

                                    if (selectedIndex != "P") {
                                      selectedIndex = "P";
                                    }
                                  });
                                },
                              ),
                              ChoiceChip(
                                label: Text('All Shipment',style: const TextStyle(color: MyColor.primaryColorblue),),
                                selected: selectedIndex == "A",
                                showCheckmark: false,
                                selectedColor: MyColor.dropdownColor,
                                backgroundColor: MyColor.dropdownColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                  side: BorderSide(
                                    color: selectedIndex == "A" ? MyColor.primaryColorblue : Colors.transparent,
                                  ),
                                ),
                                checkmarkColor: MyColor.primaryColorblue,
                                onSelected: (bool selected) {
                                  setState(() {

                                    if (selectedIndex != "A") {
                                      selectedIndex = "A";
                                    }
                                  });
                                },
                              ),
                            ]
                          ),
                        ),
                        const SizedBox(height: 8),
                        SizedBox(
                          height: MediaQuery.sizeOf(context).height * 0.10,
                        ),

                        const SizedBox(
                          width: double.infinity,
                          child: Divider(color: Colors.grey),
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
                                  prefixController.clear();
                                  awbController.clear();
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
                                    searchOnHandRequests(formattedFromDate,formattedToDate,commTypeController.text,selectedIndex,(prefixController.text.isNotEmpty && awbController.text.isNotEmpty)?"${prefixController.text}-${awbController.text}":"");

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
    final DateFormat dateFormat = DateFormat('dd/MM/yyyy');
    toDateController.text=dateFormat.format(today);
    fromDateController.text=dateFormat.format(today);
    var formatter = DateFormat('MM/dd/yyyy');
    String formattedDate = formatter.format(today);
    setState(() {
      slotFilterDate = formattedDate;
    });
    searchOnHandRequests(formattedDate,formattedDate,"","P","");
  }

  saveOnHandRequest() async {
    FocusScope.of(context).requestFocus(FocusNode());
    String xml = buildInputXml(
      saveList: saveList,
    );
    var queryParams = {
      "InputXML":xml,
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
      "OnHandShipment/RequestForExamination",
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
            fetchMasterData();
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
                                      'On Hand Shipment',
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
                                                child: Text("Total Weight  ",style: TextStyle(
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
                                          onHandShipmentList
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
                                        onHandShipmentList.length,
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
                                              backgroundColor:selectedIndex=="P"?
                                              MyColor.primaryColorblue:MyColor.textColorGrey2,
                                              textStyle:  TextStyle(
                                                fontSize: 18,
                                                color:selectedIndex=="P"? Colors.white:MyColor.textColorGrey3,
                                              ),
                                              shape:
                                              const RoundedRectangleBorder(
                                                borderRadius:
                                                BorderRadius.all(
                                                    Radius.circular(8)),
                                              ),
                                            ),
                                            onPressed: () {
                                              saveOnHandRequest();
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
                SizedBox(
                  width: 106,
                  child: Row(
                    children: [
                      buildLabel(shipment.commodity.toUpperCase(),  Color(0xffD1E2FB), 8,
                         ),

                      // Icon(
                      //   Icons.info_outline_rounded,
                      //   color: MyColor.primaryColorblue,
                      // ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 8,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 250,
                      child: TextFormField(
                        controller: piecesController,
                        enabled: selectedIndex=="P",
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
                    const SizedBox(
                      height: 8,
                    ),
                    SizedBox(
                      width: 250,
                      child: TypeAheadField<RemarksData>(
                        controller: remarksController,
                        debounceDuration: const Duration(
                            milliseconds: 300),
                        suggestionsCallback: (search) {
                          if (search.isEmpty) {
                            return null;
                          }
                          if(RemarksService.isValidAgent(search)){
                            return null;
                          }

                          return RemarksService.find(search);},
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
                                Text(item.description
                                    ),
                              ],
                            ),
                          );
                        },
                        builder: (context, controller,
                            focusNode) =>
                            TextFormField(
                              controller: controller,
                              focusNode: focusNode,
                              enabled: selectedIndex=="P",
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
                              'No Remarks Found',
                              style: TextStyle(
                                  fontSize: 16)),
                        ),
                        onSelected: (value) {
                          remarksController.text = value
                              .description                              ;

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
                          onChanged:selectedIndex=="A"? null:(bool? value) {
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
        saveList.add({"item": onHandShipmentList[index], "value": value});
      } else {
        saveList.removeWhere(
                (element) => element["item"] == onHandShipmentList[index]);
      }
    });
  }

  String buildInputXml({
    required List<Map<String, dynamic>> saveList,
  }) {
    final builder = XmlBuilder();

    builder.element('Root', nest: () {
        for (var item in saveList) {
          final reqData = item['item'] as OnHandShipReq;
          builder.element('MAWBNoDt', nest: () {
            builder.element('MAWBNo', nest: reqData.awb.replaceAll("-", ""));
            builder.element('HouseNo', nest: reqData.hawb);
            builder.element('RequestNOP', nest: reqData.rfePieces);
            builder.element('RequestRemark', nest: reqData.remarks);
            builder.element('SpecificISID', nest: reqData.impShipRowId);

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

  Widget buildLabel(
      String text, Color color, double radius,
      {bool isBorder = false, Color borderColor = Colors.black, double borderWidth = 1.0}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
      decoration: BoxDecoration(
        color: isBorder?color.withOpacity(0.2):color,
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

