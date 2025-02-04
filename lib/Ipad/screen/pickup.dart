import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:galaxy/Ipad/modal/ShipmentListingDetails.dart';
import 'package:galaxy/Ipad/screen/schedulePickups.dart';
import 'package:galaxy/Ipad/utils/global.dart';
import 'package:galaxy/utils/dialogutils.dart';
import 'package:intl/intl.dart';
import 'package:vibration/vibration.dart';
import '../../core/images.dart';
import '../../core/mycolor.dart';
import '../../module/onboarding/sizeconfig.dart';
import '../../utils/commonutils.dart';
import '../../utils/sizeutils.dart';
import '../../utils/snackbarutil.dart';
import '../../widget/customeedittext/customeedittextwithborder.dart';
import '../auth/auth.dart';
import '../modal/ShipmentAcceptanceModal.dart';
import '../modal/pickUpServices.dart';
import '../widget/customDialog.dart';
import '../widget/customIpadTextfield.dart';
import 'CaptureDamageAndAccept.dart';
import 'ImportShipmentListing.dart';

class PickUps extends StatefulWidget {
 final SchedulePickUpData? schedulePickUpData;
  const PickUps({super.key,  this.schedulePickUpData});

  @override
  State<PickUps> createState() =>
      _PickUpsState();
}

class _PickUpsState
    extends State<PickUps> {
  final AuthService authService = AuthService();
  bool isLoading = false;
  bool hasNoRecord = false;
  List<VCTItem> dropdownItems = [];
  TextEditingController prefixController = TextEditingController();
  TextEditingController awbController = TextEditingController();
  TextEditingController houseController = TextEditingController();
  TextEditingController totalNOPController = TextEditingController();
  TextEditingController totalWTController = TextEditingController();
  TextEditingController masterUnitController = TextEditingController();
  TextEditingController customBrokerController = TextEditingController();
  TextEditingController rcvNOPController = TextEditingController();
  TextEditingController rcvWTController = TextEditingController();
  TextEditingController rcvUnitController = TextEditingController();
  TextEditingController remarksController = TextEditingController();
  FocusNode prefixFocusNode = FocusNode();
  FocusNode awbFocusNode = FocusNode();
  FocusNode houseFocusNode = FocusNode();
  FocusNode rcvNOPFocusNode = FocusNode();
  // List<ConsignmentAcceptedList> acceptedPiecesList = [];
  // List<ConsignmentAcceptedList> acceptedConsignment = [];
  // List<RemainingPcs> remainPiecesList = [];
  int pieceStatus = 0;
  int selectedComId=-1;
  int selectedAgentId=-1;
  List<PickUpData> awbDataList=[];

  @override
  void initState() {
    super.initState();
    // awbSearch();
    prefixController = TextEditingController(
        text: widget.schedulePickUpData?.col3.substring(0,3) ?? '');
    awbController = TextEditingController(
        text: widget.schedulePickUpData?.col3.substring(4) ?? '');
    houseController=TextEditingController(
        text: widget.schedulePickUpData?.col4 ?? '');
    totalNOPController=TextEditingController(
        text: widget.schedulePickUpData?.col6 ?? '');
    totalWTController=TextEditingController(
        text: widget.schedulePickUpData?.col7 ?? '');
    masterUnitController.text = "KG";
    rcvUnitController.text = "KG";
    setDefaultRemainValues();
    print("-----${commodityListMaster.length}");
    // if( widget.schedulePickUpData!.col3.isNotEmpty){
    fetchMasterData();
    // }
    awbFocusNode.addListener(
          () {
        if (!awbFocusNode.hasFocus) {
          print("LOST focus");
          leftAWBFocus();
        }
      },
    );

    rcvNOPFocusNode.addListener(
          () {
        if (!rcvNOPFocusNode.hasFocus) {
          print("LOST focus NOP");
          // if (remainPiecesList.isNotEmpty) {
          //   print("NOt empty");
          //   checkPieces();
          // }
          if(rcvNOPController.text.isEmpty){
            setState(() {
              rcvNOPController.text="0";
              rcvWTController.text="0.00";
            });
          }
        }
      },
    );

    houseFocusNode.addListener(
          () {
        if (!houseFocusNode.hasFocus) {

          if(houseController.text.isEmpty){
            return;
          }
          print("LOST focus house");
          leftAWBFocus();
        }
      },
    );
    // prefixController.text=widget.shipmentListDetails?.documentNo.substring(0,3)??"";
    // awbController.text=widget.shipmentListDetails?.documentNo.substring(4)??"";
    // houseController.text=widget.shipmentListDetails?.houseNo??"";
    // if(widget.shipmentListDetails!=null){
    //   if(houseController.text.isNotEmpty){
    //     houseFocusNode.requestFocus();
    //   }
    //   else{
    //     awbFocusNode.requestFocus();
    //   }
    // }
  }


  @override
  void dispose() {
    super.dispose();
  }

  void fetchMasterData() async {
    await Future.delayed(Duration.zero);
    awbSearch();
  }

  clearFieldsOnGet() {
    awbDataList=[];
    totalNOPController.clear();
    totalWTController.clear();
    customBrokerController.clear();
    remarksController.clear();
    rcvNOPController.text="0";
    rcvWTController.text="0.00";
    setState(() {
      pieceStatus = 0;
    });
  }

  resetData() {
    prefixController.clear();
    awbController.clear();
    houseController.clear();
    customBrokerController.clear();
    totalNOPController.clear();
    remarksController.clear();
    totalWTController.clear();
    rcvNOPController.text="0";
    rcvWTController.text="0.00";

    setState(() {
      pieceStatus = 0;
    });
  }

  setDefaultRemainValues(){
    rcvNOPController.text="0";
    rcvWTController.text="0.00";
  }

  checkPieces() {
    print("checkPieces");
    if(rcvNOPController.text.isEmpty || rcvNOPController.text=="0"){
      setState(() {
        pieceStatus = 0;
      });
    }
    if (int.parse(rcvNOPController.text)
        ==
        int.parse(totalNOPController.text)) {
      setState(() {
        pieceStatus = 1; //matches
        print("status $pieceStatus");
      });
    } else if (int.parse(rcvNOPController.text) <
        int.parse(totalNOPController.text)) {

      setState(() {
        pieceStatus = 2; //partial
        print("status $pieceStatus");
      });
    }
    else{
      setState(() {
        pieceStatus = 3; //exceeds
      });
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

  leftAWBFocus() async {
    if(awbController.text.isEmpty){
      return;
    }
    if (awbController.text.length != 8) {
      showDataNotFoundDialog(context, "Please enter a valid AWB No.");
      return;
    }
    if (prefixController.text.length != 3) {
      showDataNotFoundDialog(context, "Please enter a valid AWB Prefix.");
      return;
    }
    if (awbController.text.isNotEmpty && prefixController.text.isNotEmpty) {
      print("iput is valid");
      awbSearch();
    }
  }

  awbSearch() async {
    if(awbController.text.isEmpty){
      return;
    }
    FocusScope.of(context).unfocus();
    DialogUtils.showLoadingDialog(context);
    // houseController.clear();
    clearFieldsOnGet();
    var queryParams = {
      "AWBPrefix": prefixController.text,
      "AWBNo": awbController.text,
      "HouseNo": houseController.text,
      "userid": userId,
      "AirportCity": "JFK",
      "CompanyCode": 3,
      "CultureCode": "en-US",
      "MenuId": 1
    };

    await authService
        .sendGetWithBody("Pickup/GetMAWBPickupDetails", queryParams)
        .then((response) async {
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
      String statusMessage = jsonData['StatusMessage'];
      print("is empty record$hasNoRecord");
      String status = jsonData['Status'];

      if (status == 'E') {
        print("Error: $statusMessage");
        DialogUtils.hideLoadingDialog(context);
        showDataNotFoundDialog(context, statusMessage);
        return;
      } else {
        List<dynamic> pickUpDataList = jsonData['GetAWBDetails'];
        setState(() {
          awbDataList = pickUpDataList
              .map((json) => PickUpData.fromJson(json))
              .toList();
        });
        print(awbDataList.length);
        setState(() {
          houseController.text=awbDataList.first.houseNo;
          totalNOPController.text=awbDataList.first.pieces.toString();
          totalWTController.text=awbDataList.first.weight.toStringAsFixed(2);
        });
      }
      DialogUtils.hideLoadingDialog(context);
    }).catchError((onError) {
      DialogUtils.hideLoadingDialog(context);
      print(onError);
    });
  }

  String formatDate(String inputDateString) {
    DateFormat inputFormat = DateFormat("MM/dd/yyyy h:mm:ss a");
    DateTime parsedDate = inputFormat.parse(inputDateString);
    DateFormat outputFormat = DateFormat("dd MMM yy HH:mm");
    return outputFormat.format(parsedDate);
  }

  performPickUpAction(bool isCompleting) async {
    if (prefixController.text.isEmpty) {
      showDataNotFoundDialog(context, "AWB Prefix is required.");
      return;
    }

    if (awbController.text.isEmpty) {
      showDataNotFoundDialog(context, "AWB No is required.");
      return;
    }
    if(!isCompleting){
      if (remarksController.text.isEmpty) {
        showDataNotFoundDialog(context, "Remarks is required.");
        return;
      }
    }

    var queryParams = {
      "QueueRowID": widget.schedulePickUpData?.queueRowId??awbDataList.first.queueRowId,
      "ElementRowID": widget.schedulePickUpData?.elementRowId??awbDataList.first.elementRowId,
      "intPcs": int.parse(rcvNOPController.text),
      "Wt": double.parse(rcvWTController.text),
      "Remark": remarksController.text,
      "PickupAction": isCompleting?"S":"F",
      "Custombrk": customBrokerController.text,
      "unit": "KG",
      "userid": userId,
      "AirportCity": "JFK",
      "CompanyCode": 3,
      "CultureCode": "en-US",
      "MenuId": 1
    };
    // print(queryParams);
    // return;
    DialogUtils.showLoadingDialog(context);
    await authService
        .postData(
      "Pickup/PickupAction",
      queryParams,
    )
        .then((response) async {
      print("data received ");
      Map<String, dynamic> jsonData = json.decode(response.body);
      String status = jsonData['Status'];
      String? statusMessage = jsonData['StatusMessage'] ?? "";
      if (jsonData.isNotEmpty) {
        DialogUtils.hideLoadingDialog(context);
        if (status != "S") {
          showDataNotFoundDialog(context, statusMessage!);
        }
        if ((status == "S")) {
          //SnackbarUtil.showSnackbar(context,statusMessage!,              const Color(0xff43A047));
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
                MaterialPageRoute(builder: (context) => const ScheduledPickups()));
          }
        }
      }
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
                  '  Pickup Services',
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
              const SizedBox(
                width: 10,
              ),
            ]),
        // drawer: const Drawer(),
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
                                  'Pickup',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 22),
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
                                                    hastextcolor: true,
                                                    animatedLabel: true,
                                                    needOutlineBorder: true,
                                                    labelText: "Prefix*",
                                                    readOnly: false,
                                                    focusNode: prefixFocusNode,
                                                    controller:
                                                    prefixController,
                                                    maxLength: 3,
                                                    onPress: () {},
                                                    textInputType:
                                                    TextInputType.number,
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
                                                  MediaQuery.sizeOf(context)
                                                      .height *
                                                      0.04,
                                                  width:
                                                  MediaQuery.sizeOf(context)
                                                      .width *
                                                      0.25,
                                                  child:
                                                  CustomeEditTextWithBorder(
                                                    lablekey: 'MAWB',
                                                    hasIcon: false,
                                                    hastextcolor: true,
                                                    animatedLabel: true,
                                                    textInputType:
                                                    TextInputType.number,
                                                    needOutlineBorder: true,
                                                    labelText: "AWB No*",
                                                    onPress: () {},
                                                    focusNode: awbFocusNode,
                                                    readOnly: false,
                                                    controller: awbController,
                                                    maxLength: 8,
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
                                                      0.37,
                                                  child:
                                                  CustomeEditTextWithBorder(
                                                    lablekey: 'MAWB',
                                                    hasIcon: false,
                                                    hastextcolor: true,
                                                    animatedLabel: true,

                                                    needOutlineBorder: true,
                                                    labelText: "HAWB No*",
                                                    onPress: () {},
                                                    readOnly: false,
                                                    noUpperCase: true,
                                                    focusNode: houseFocusNode,
                                                    controller: houseController,
                                                    maxLength: 8,
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
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                        children: [
                                          Container(
                                            width: MediaQuery.sizeOf(context)
                                                .width *
                                                0.45,
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
                                                      0.22,
                                                  child:
                                                  CustomeEditTextWithBorder(
                                                    lablekey: 'MAWB',
                                                    hasIcon: false,
                                                    hastextcolor: true,
                                                    animatedLabel: true,
                                                    needOutlineBorder: true,
                                                    labelText: "NoP*",
                                                    controller:
                                                    totalNOPController,
                                                    readOnly: true,
                                                    onPress: () {},
                                                    textInputType:
                                                    TextInputType.number,
                                                    maxLength: 4,
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
                                                  MediaQuery.sizeOf(context)
                                                      .height *
                                                      0.04,
                                                  width:
                                                  MediaQuery.sizeOf(context)
                                                      .width *
                                                      0.20,
                                                  child:
                                                  CustomeEditTextWithBorder(
                                                    lablekey: 'MAWB',
                                                    hasIcon: false,
                                                    hastextcolor: true,
                                                    animatedLabel: true,
                                                    needOutlineBorder: true,
                                                    labelText: "Total Weight*",
                                                    controller:
                                                    totalWTController,
                                                    onPress: () {},
                                                    readOnly: true,
                                                    textInputType:
                                                    TextInputType.number,
                                                    maxLength: 4,
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
                                                0.45,
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
                                                      0.12,
                                                  child:
                                                  CustomeEditTextWithBorder(
                                                    lablekey: 'MAWB',
                                                    hasIcon: false,
                                                    hastextcolor: true,
                                                    animatedLabel: true,
                                                    needOutlineBorder: true,
                                                    labelText: "Unit*",
                                                    controller:
                                                    masterUnitController,
                                                    onPress: () {},
                                                    readOnly: true,
                                                    textInputType:
                                                    TextInputType.number,
                                                    maxLength: 4,
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
                                                  MediaQuery.sizeOf(context)
                                                      .height *
                                                      0.04,
                                                  width:
                                                  MediaQuery.sizeOf(context)
                                                      .width *
                                                      0.30,
                                                  child:
                                                  TypeAheadField<Customer>(
                                                    controller: customBrokerController,
                                                    debounceDuration: const Duration(
                                                        milliseconds: 300),
                                                    suggestionsCallback: (search){
                                                      if (search.isEmpty) {
                                                        return null;
                                                      }
                                                      return AgentService.find(search);},
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
                                                            Text(item.customerName
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
                                                          isSpaceAllowed: true,
                                                          hastextcolor: true,
                                                          animatedLabel: true,
                                                          needOutlineBorder: true,
                                                          onPress: () {},
                                                          labelText: "Custom Broker",
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
                                                      child: Text('No Customer Found',
                                                          style: TextStyle(
                                                              fontSize: 16)),
                                                    ),
                                                    onSelected: (value) {
                                                      setState(() {
                                                        customBrokerController.text = value
                                                            .customerName
                                                            .toUpperCase();
                                                        selectedAgentId=value.customerId;
                                                        print("Agent ID $selectedAgentId");
                                                      });
                                                    },
                                                  ),

                                                )
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
                                      const Row(
                                        children: [
                                          Text("   CAPTURE RECEIVED SHIPMENT",
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w800,
                                                  fontSize: 16)),
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
                                                0.45,
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
                                                      0.22,
                                                  child:
                                                  CustomeEditTextWithBorder(
                                                    lablekey: 'MAWB',
                                                    hasIcon: false,
                                                    hastextcolor: true,
                                                    animatedLabel: true,
                                                    needOutlineBorder: true,
                                                    labelText: "Received NoP*",
                                                    controller:
                                                    rcvNOPController,
                                                    focusNode: rcvNOPFocusNode,
                                                    readOnly: false,
                                                    onPress: () {},
                                                    textInputType:
                                                    TextInputType.number,
                                                    maxLength: 4,
                                                    fontSize: 18,
                                                    onChanged: (String, bool) {
                                                      print("Change");
                                                      checkPieces();
                                                      if(rcvNOPController.text.isEmpty){
                                                        setState(() {
                                                          rcvNOPController.text="0";
                                                          rcvWTController.text="0.00";
                                                        });
                                                      }
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
                                                      0.20,
                                                  child:
                                                  CustomeEditTextWithBorder(
                                                    lablekey: 'MAWB',
                                                    hasIcon: false,
                                                    hastextcolor: true,
                                                    animatedLabel: true,
                                                    needOutlineBorder: true,
                                                    onPress: () {},
                                                    labelText:
                                                    "Received Weight*",
                                                    readOnly: false,
                                                    controller: rcvWTController,
                                                    textInputType:
                                                    TextInputType.number,
                                                    maxLength: 7,
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
                                                0.45,
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
                                                      0.12,
                                                  child:
                                                  CustomeEditTextWithBorder(
                                                    lablekey: 'MAWB',
                                                    hasIcon: false,
                                                    hastextcolor: true,
                                                    animatedLabel: true,
                                                    needOutlineBorder: true,
                                                    labelText: "Unit*",
                                                    readOnly: true,
                                                    onPress: () {},
                                                    controller:
                                                    rcvUnitController,
                                                    textInputType:
                                                    TextInputType.number,
                                                    maxLength: 4,
                                                    fontSize: 18,
                                                    onChanged:
                                                        (String, bool) {},
                                                  ),
                                                ),
                                                const SizedBox(
                                                  width: 20,
                                                ),
                                                SizedBox(
                                                  height:
                                                  MediaQuery.sizeOf(context)
                                                      .height *
                                                      0.04,
                                                  width:
                                                  MediaQuery.sizeOf(context)
                                                      .width *
                                                      0.20,
                                                  child: pieceStatus == 0
                                                      ? SizedBox()
                                                      : pieceStatus == 1
                                                      ? const Row(
                                                    children: [
                                                      Icon(
                                                        Icons
                                                            .check_circle,
                                                        color: Color(0xff43A047),
                                                      ),
                                                      Text(
                                                        "  Pieces Matched",
                                                        style: TextStyle(
                                                            color: Color(0xff43A047),fontWeight: FontWeight.w700),
                                                      )
                                                    ],
                                                  )
                                                      : pieceStatus == 2
                                                      ? const Row(
                                                    children: [
                                                      Icon(
                                                        Icons.info_outlined
                                                        ,
                                                        color: Color(0xffFD8D00),
                                                      ),
                                                      Text(
                                                        "  Part Received",
                                                        style: TextStyle(
                                                            color:
                                                            Color(0xffFD8D00),fontWeight: FontWeight.w700),
                                                      )
                                                    ],
                                                  )
                                                      : const Row(
                                                    children: [
                                                      Icon(
                                                        Icons
                                                            .info_outlined,
                                                        color: Color(0xffB00020),
                                                      ),
                                                      Text(
                                                        "  Pieces Mismatched",
                                                        style: TextStyle(
                                                            color:
                                                            Color(0xffB00020),fontWeight: FontWeight.w700),
                                                      )
                                                    ],
                                                  ),
                                                )
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
                                        mainAxisAlignment:
                                        MainAxisAlignment.start
                                        ,
                                        children: [

                                          SizedBox(
                                            width: MediaQuery.sizeOf(context)
                                                .width *
                                                0.90,
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
                                                      0.45,
                                                  child:
                                                  CustomeEditTextWithBorder(
                                                    controller: remarksController,
                                                    lablekey: 'MAWB',
                                                    hasIcon: false,
                                                    hastextcolor: true,
                                                    animatedLabel: true,
                                                    needOutlineBorder: true,
                                                    noUpperCase: true,
                                                    isSpaceAllowed: true,
                                                    labelText: "Remarks",
                                                    onPress: () {},
                                                    maxLength: 35,
                                                    fontSize: 18,
                                                    onChanged:
                                                        (String, bool) {},
                                                  ),
                                                ),
                                                const SizedBox(
                                                  width: 20,
                                                ),
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
                                                      const Row(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Column(
                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                        children: [
                                                          Icon(
                                                            Icons
                                                                .info_outlined,
                                                            color: Color(0xff3E4C5A),
                                                          ),
                                                        ],
                                                      ),
                                                      Text(
                                                        "  Entering remarks is mandatory,\n if the pick-up fails",
                                                        style: TextStyle(
                                                            color:
                                                            Color(0xff3E4C5A),fontWeight: FontWeight.w700),
                                                      )
                                                    ],
                                                  ),
                                                )
                                              ],
                                            ),
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
                                              color: Color(0xffD50000)),
                                          textStyle: const TextStyle(
                                            fontSize: 18,
                                            color: Color(0xffD50000),
                                          ),
                                          shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(8)),
                                          ),
                                        ),
                                        onPressed: () {
                                          performPickUpAction(false);
                                        },
                                        child: const Text(
                                            "Fail Pickup",style: TextStyle(color: Color(0xffD50000)),),
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
                                          if(pieceStatus!=3) {
                                            performPickUpAction(true);
                                          }
                                        },
                                        child: const Text(
                                          "Complete Pickup",
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
        awbController.clear();
        // WidgetsBinding.instance.addPostFrameCallback((_) {
        //   FocusScope.of(context).requestFocus(igmNoFocusNode);
        // });
      } else {
        String result = barcodeScanResult.replaceAll(" ", "");
        if (isHawb) {
          houseController.text = result;
        } else {
          String prefix = result.substring(0, 2);
          String awb = result.substring(3);
          prefixController.text = prefix;
          awbController.text = awb;
        }
      }
    }
  }
}
