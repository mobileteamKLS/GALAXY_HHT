import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:galaxy/Ipad/modal/ShipmentListingDetails.dart';
import 'package:galaxy/Ipad/screen/warehouseoperations.dart';
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
import '../widget/customDialog.dart';
import '../widget/customIpadTextfield.dart';
import 'CaptureDamageAndAccept.dart';
import 'ImportShipmentListing.dart';

class ShipmentAcceptanceManually extends StatefulWidget {
  final ShipmentListDetails? shipmentListDetails;
  final bool isNavFromList;
  const ShipmentAcceptanceManually({super.key, this.shipmentListDetails, required this.isNavFromList});

  @override
  State<ShipmentAcceptanceManually> createState() =>
      _ShipmentAcceptanceManuallyState();
}

class _ShipmentAcceptanceManuallyState
    extends State<ShipmentAcceptanceManually> {
  final AuthService authService = AuthService();
  bool isLoading = false;
  bool hasNoRecord = false;
  List<VCTItem> dropdownItems = [];
  TextEditingController prefixController = TextEditingController();
  TextEditingController awbController = TextEditingController();
  TextEditingController houseController = TextEditingController();
  TextEditingController commodityController = TextEditingController();
  TextEditingController agentController = TextEditingController();
  TextEditingController totalNOPController = TextEditingController();
  TextEditingController totalWTController = TextEditingController();
  TextEditingController masterUnitController = TextEditingController();
  TextEditingController groupIDController = TextEditingController();
  TextEditingController rcvNOPController = TextEditingController();
  TextEditingController rcvWTController = TextEditingController();
  TextEditingController rcvUnitController = TextEditingController();
  FocusNode prefixFocusNode = FocusNode();
  FocusNode awbFocusNode = FocusNode();
  FocusNode houseFocusNode = FocusNode();
  FocusNode rcvNOPFocusNode = FocusNode();
  List<ConsignmentAcceptedList> acceptedPiecesList = [];
  List<ConsignmentAcceptedList> acceptedConsignment = [];
  List<RemainingPcs> remainPiecesList = [];
  int pieceStatus = 0;
  int selectedComId=-1;
  int selectedAgentId=-1;

  @override
  void initState() {
    super.initState();
    // awbSearch();
    masterUnitController.text = "KG";
    rcvUnitController.text = "KG";
    setDefaultRemainValues();
    print("-----${commodityListMaster.length}");
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
          if (remainPiecesList.isNotEmpty) {
            print("NOt empty");
            checkPieces();
          }
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
    prefixController.text=widget.shipmentListDetails?.documentNo.substring(0,3)??"";
    awbController.text=widget.shipmentListDetails?.documentNo.substring(4)??"";
    houseController.text=widget.shipmentListDetails?.houseNo??"";
    if(widget.shipmentListDetails!=null){
      if(houseController.text.isNotEmpty){
        houseFocusNode.requestFocus();
      }
      else{
        awbFocusNode.requestFocus();
      }
    }
  }


  @override
  void dispose() {
    super.dispose();
  }

  clearFieldsOnGet() {
    totalNOPController.clear();
    totalWTController.clear();
    groupIDController.clear();
    commodityController.clear();
    agentController.clear();
    rcvNOPController.text="0";
    rcvWTController.text="0.00";
    acceptedPiecesList = [];
    acceptedConsignment = [];
    remainPiecesList = [];
    setState(() {
      pieceStatus = 0;
    });
  }

  resetData() {
    prefixController.clear();
    awbController.clear();
    houseController.clear();
    groupIDController.clear();
    totalNOPController.clear();
    totalWTController.clear();
    commodityController.clear();
    agentController.clear();
    rcvNOPController.text="0";
    rcvWTController.text="0.00";
    acceptedPiecesList = [];
    acceptedConsignment = [];
    remainPiecesList = [];
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
    if ((int.parse(rcvNOPController.text) +
        (acceptedConsignment.first.totalNpo-remainPiecesList.first.remainingPkg)) ==
        acceptedConsignment.first.totalNpo) {
      setState(() {
        pieceStatus = 1; //matches
        print("status $pieceStatus");
      });
    } else if ((int.parse(rcvNOPController.text) +
        (acceptedConsignment.first.totalNpo-remainPiecesList.first.remainingPkg)) <
        acceptedConsignment.first.totalNpo) {
      print("total pcs ${acceptedConsignment.first.totalNpo}-----${(int.parse(rcvNOPController.text) +
          remainPiecesList.first.remainingPkg)}");
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
      showDataNotFoundDialog(context, "Please enter a valid AWB No.");
      return;
    }
    if (awbController.text.isNotEmpty && prefixController.text.isNotEmpty) {
      print("iput is valid");
      awbSearch();
    }
  }

    awbSearch() async {
    FocusScope.of(context).unfocus();
    DialogUtils.showLoadingDialog(context);
    // houseController.clear();
    clearFieldsOnGet();
    var queryParams = {
      "InputXML":
          "<Root><AWBPrefix>${prefixController.text}</AWBPrefix><AWBNo>${awbController.text}</AWBNo><HAWBNO>${houseController.text}</HAWBNO><AirportCity>JFK</AirportCity><Culture>en-US</Culture><CompanyCode>3</CompanyCode><UserId>${userId.toString()}</UserId></Root>"
    };

    await authService
        .sendGetWithBody("ShipmentAcceptance/GetShipmentDetails", queryParams)
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
      String statusMessage = jsonData['ReturnOutput'][0]['StrMessage'];
      print("is empty record$hasNoRecord");
      String status = jsonData['ReturnOutput'][0]['Status'];

      if (status == 'E') {
        print("Error: $statusMessage");
        DialogUtils.hideLoadingDialog(context);
        showDataNotFoundDialog(context, statusMessage);
        return;
      } else {

      //   houseController.text=
      // jsonData['ConsignmentAcceptance'][0]['HouseNo'].toString();
        List<dynamic> accPcsList = jsonData['ConsignmentAcceptanceList'];
        List<dynamic> accConsignment = jsonData['ConsignmentAcceptance'];
        List<dynamic> remainingPcsList = jsonData['ConsignmentPending'];
        if(houseController.text.isEmpty){
          if(accConsignment.isNotEmpty && accConsignment.length>1){
            print("multiple house ");
            DialogUtils.hideLoadingDialog(context);
            bool isTrue=await showDialog(
              context: context,
              builder: (BuildContext context) => CustomAlertMessageDialogNew(
                description: "Please enter HAWB No.",
                buttonText: "Okay",
                imagepath:'assets/images/warn.gif',
                isMobile: false,
              ),
            );
            if(isTrue){
              houseFocusNode.requestFocus();
            }
            return;
          }
          else if(accConsignment.isNotEmpty && accConsignment.length==1){
            houseController.text =
                jsonData['ConsignmentAcceptance'][0]['HouseNo'].toString();
            DialogUtils.hideLoadingDialog(context);
            awbSearchForHouse();
          }
        }
        totalNOPController.text =jsonData['ConsignmentAcceptance'][0]['TotalNPO'].toString();
        totalWTController.text = jsonData['ConsignmentAcceptance'][0]['TotalWt'].toString();

        Customer? selectedCustomer = customerListMaster.firstWhere(
              (customer) => customer.customerId ==jsonData['ConsignmentAcceptance'][0]['AgentId'],
          orElse: () => Customer(customerId: 0, customerName: ""),
        );
        Commodity? selectedComm=commodityListMaster.firstWhere(
                (customer) => customer.commodityType.toUpperCase() ==jsonData['ConsignmentAcceptance'][0]['Commodity'].toUpperCase(),
            orElse: () => Commodity(commodityId: -1, commodityCode: "",commodityType: ""),);
        agentController.text=selectedCustomer.customerName;
        selectedAgentId=selectedCustomer.customerId;
        selectedComId=selectedComm.commodityId;
        commodityController.text = selectedComm.commodityType;
        rcvNOPController.text=jsonData['ConsignmentPending'][0]['RemainingPkg'].toString();
        rcvWTController.text=jsonData['ConsignmentPending'][0]['RemainingWt'].toString();

        setState(() {
          acceptedPiecesList = accPcsList
              .map((json) => ConsignmentAcceptedList.fromJSON(json))
              .toList();
          acceptedConsignment = accConsignment
              .map((json) => ConsignmentAcceptedList.fromJSON(json))
              .toList();
          remainPiecesList = remainingPcsList
              .map((json) => RemainingPcs.fromJSON(json))
              .toList();
        });
        checkPieces();
        print("ConsignmentAcceptanceList List ${acceptedPiecesList.length}");
        print("Acceptance Consignment ${acceptedConsignment.length}");
        print("Acceptance Consignment ${remainPiecesList.length}");
      }
      DialogUtils.hideLoadingDialog(context);
    }).catchError((onError) {
      // DialogUtils.hideLoadingDialog(context);
      print(onError);
    });
  }
  awbSearchForHouse() async {
    FocusScope.of(context).unfocus();
    DialogUtils.showLoadingDialog(context);
    clearFieldsOnGet();
    var queryParams = {
      "InputXML":
          "<Root><AWBPrefix>${prefixController.text}</AWBPrefix><AWBNo>${awbController.text}</AWBNo><HAWBNO>${houseController.text}</HAWBNO><AirportCity>JFK</AirportCity><Culture>en-US</Culture><CompanyCode>3</CompanyCode><UserId>${userId.toString()}</UserId></Root>"
    };

    await authService
        .sendGetWithBody("ShipmentAcceptance/GetShipmentDetails", queryParams)
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
      String statusMessage = jsonData['ReturnOutput'][0]['StrMessage'];
      print("is empty record$hasNoRecord");
      String status = jsonData['ReturnOutput'][0]['Status'];

      if (status == 'E') {
        print("Error: $statusMessage");
        DialogUtils.hideLoadingDialog(context);
        showDataNotFoundDialog(context, statusMessage);
        return;
      } else {

      //   houseController.text=
      // jsonData['ConsignmentAcceptance'][0]['HouseNo'].toString();
        List<dynamic> accPcsList = jsonData['ConsignmentAcceptanceList'];
        List<dynamic> accConsignment = jsonData['ConsignmentAcceptance'];
        List<dynamic> remainingPcsList = jsonData['ConsignmentPending'];
        if(houseController.text.isEmpty){
          if(accConsignment.isNotEmpty && accConsignment.length>1){
            print("multiple house ");
            DialogUtils.hideLoadingDialog(context);
            showDataNotFoundDialog(context, "Please enter HAWB No.");
            return;
          }
          else if(accConsignment.isNotEmpty && accConsignment.length>1){

          }
        }
        totalNOPController.text =
            jsonData['ConsignmentAcceptance'][0]['TotalNPO'].toString();
        totalWTController.text =
            jsonData['ConsignmentAcceptance'][0]['TotalWt'].toString();
        Customer? selectedCustomer = customerListMaster.firstWhere(
              (customer) => customer.customerId ==jsonData['ConsignmentAcceptance'][0]['AgentId'],
          orElse: () => Customer(customerId: 0, customerName: ""),
        );
        Commodity? selectedComm=commodityListMaster.firstWhere(
              (customer) => customer.commodityType.toUpperCase() ==jsonData['ConsignmentAcceptance'][0]['Commodity'].toUpperCase(),
          orElse: () => Commodity(commodityId: -1, commodityCode: "",commodityType: ""),);
        agentController.text=selectedCustomer.customerName;
        commodityController.text = selectedComm.commodityType;
        agentController.text=selectedCustomer.customerName;
        selectedAgentId=selectedCustomer.customerId;
        selectedComId=selectedComm.commodityId;
        rcvNOPController.text=jsonData['ConsignmentPending'][0]['RemainingPkg'].toString();
        rcvWTController.text=jsonData['ConsignmentPending'][0]['RemainingWt'].toString();

        setState(() {
          acceptedPiecesList = accPcsList
              .map((json) => ConsignmentAcceptedList.fromJSON(json))
              .toList();
          acceptedConsignment = accConsignment
              .map((json) => ConsignmentAcceptedList.fromJSON(json))
              .toList();
          remainPiecesList = remainingPcsList
              .map((json) => RemainingPcs.fromJSON(json))
              .toList();
        });
        checkPieces();
        print("ConsignmentAcceptanceList List ${acceptedPiecesList.length}");
        print("Acceptance Consignment ${acceptedConsignment.length}");
        print("Acceptance Consignment ${remainPiecesList.length}");
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

  acceptShipment() async {
    if (prefixController.text.isEmpty) {
      showDataNotFoundDialog(context, "AWB Prefix is required.");
      return;
    }

    if (awbController.text.isEmpty) {
      showDataNotFoundDialog(context, "AWB No is required.");
      return;
    }

    if (commodityController.text.isEmpty) {
      showDataNotFoundDialog(context, "Commodity is required.");
      return;
    }

    if (agentController.text.isEmpty) {
      showDataNotFoundDialog(context, "Agent is required.");
      return;
    }
    // if (groupIDController.text.isEmpty) {
    //   showDataNotFoundDialog(context, "Group ID is required.");
    //   return;
    // }
    print("COMM ID $selectedComId");
    print("Agent ID $selectedAgentId");
    String shipmentType="";
    if(houseController.text.isEmpty){
      shipmentType="A";
    }
    else{
      shipmentType="H";
    }

    var queryParams = {
      "InputXML":
          "<Root><Type>$shipmentType</Type><ConsignmentRowId>${acceptedConsignment.first.consignmentRowId}</ConsignmentRowId><HouseRowId>${acceptedConsignment.first.houseRowId}</HouseRowId><ConsignmentDimensionsXML><ROOT><Dimensions NOP=\"0\" RowId=\"-1\" UOM=\"c\" Length=\"0\" Width=\"0\" Height=\"0\" Volume=\"0.0\" /></ROOT></ConsignmentDimensionsXML><RemainingPieces>${rcvNOPController.text}</RemainingPieces><RemainingWt>${rcvWTController.text}</RemainingWt><ChargeableWt>0</ChargeableWt><Remark></Remark><IsSecured>N</IsSecured><TareWtType>-1</TareWtType><TareWeight>0</TareWeight><GroupId>${groupIDController.text}</GroupId><IsULD>N</IsULD><CommoditySrNo>${selectedComId}</CommoditySrNo><AgentId>${selectedAgentId}</AgentId><AirportCode>JFK</AirportCode><CompanyCode>3</CompanyCode><CultureCode>en-US</CultureCode><UserId>${userId.toString()}</UserId><MenuId>0</MenuId></Root>"
    };
    // print(queryParams);
    // return;
    DialogUtils.showLoadingDialog(context);
    await authService
        .postData(
      "ShipmentAcceptance/CBWShipmentAcceptanceSave",
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
            awbSearch();
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
                                GestureDetector(
                                  child: const Icon(Icons.arrow_back_ios,
                                      color: MyColor.primaryColorblue),
                                  onTap: () async {
                                    DialogUtils.hideLoadingDialog(context);
                                    if(widget.isNavFromList){
                                      await Future.delayed(Duration(milliseconds: 200));
                                      Navigator.pushReplacement(context,
                                          MaterialPageRoute(builder: (context) => const ImportShipmentListing()));
                                    }
                                    else{
                                      await Future.delayed(Duration(milliseconds: 200));
                                      Navigator.pushReplacement(context,
                                          MaterialPageRoute(builder: (context) => const WarehouseOperations()));
                                    }

                                  },
                                ),
                                const Text(
                                  '  Shipment Acceptance',
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
                                                          0.22,
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
                                                          0.20,
                                                  child:
                                                      CustomeEditTextWithBorder(
                                                    lablekey: 'MAWB',
                                                    hasIcon: false,
                                                    hastextcolor: true,
                                                    animatedLabel: true,
                                                    controller:
                                                        groupIDController,
                                                    needOutlineBorder: true,
                                                    labelText: "Group Id",
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
                                            child: TypeAheadField<Commodity>(
                                              controller: commodityController,
                                              debounceDuration: const Duration(
                                                  milliseconds: 300),
                                              suggestionsCallback: (search) {
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
                                                onPress: () {},
                                                labelText:
                                                    "Commodity*",
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
                                              setState(() {
                                                commodityController.text = value
                                                    .commodityType
                                                    .toUpperCase();
                                                selectedComId=value.commodityId;
                                                print("COMM ID $selectedComId");
                                              });
                                              },
                                            ),
                                          ),
                                          SizedBox(
                                            width: MediaQuery.sizeOf(context)
                                                    .width *
                                                0.44,
                                            child: TypeAheadField<Customer>(
                                              controller: agentController,
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
                                                hastextcolor: true,
                                                animatedLabel: true,
                                                isSpaceAllowed: true,
                                                needOutlineBorder: true,
                                                onPress: () {},
                                                labelText: "Agent Code - Name*",
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
                                                 agentController.text = value
                                                     .customerName
                                                     .toUpperCase();
                                                 selectedAgentId=value.customerId;
                                                 print("Agent ID $selectedAgentId");
                                               });
                                              },
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
                                                    TextInputType.numberWithOptions(signed: false, decimal: true),
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
                                                          0.22,
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
                                const Text(
                                  "  Part Shipment History",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w800,
                                      fontSize: 16),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  width: MediaQuery.sizeOf(context).width,
                                  color: Color(0xffE4E7EB),
                                  padding: EdgeInsets.all(2.0),
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: DataTable(
                                      columns: const [
                                        DataColumn(label: Text('Received NoP')),
                                        DataColumn(
                                            label: Text('Received Weight')),
                                        DataColumn(label: Text('Unit')),
                                        DataColumn(label: Text('Accepted By')),
                                        DataColumn(label: Text('Accepted On')),
                                        DataColumn(label: Text('Group ID')),
                                      ],
                                      rows: acceptedPiecesList.map((item) {
                                        return DataRow(cells: [
                                          DataCell(Text(item.nop)),
                                          DataCell(Text(item.weight.toStringAsFixed(2))),
                                          const DataCell(Text('KG')),
                                          DataCell(Text(item.acceptanceBy)),
                                          DataCell(Text(formatDate(item.acceptanceOn))),
                                          DataCell(Text(item.groupId)),
                                        ]);
                                      }).toList(),
                                      headingRowColor:
                                          MaterialStateColor.resolveWith(
                                              (states) => Color(0xffE4E7EB)),
                                      dataRowColor:
                                          MaterialStateColor.resolveWith(
                                              (states) => Color(0xfffafafa)),
                                      columnSpacing:
                                          acceptedPiecesList.isNotEmpty
                                              ? MediaQuery.sizeOf(context)
                                                      .width *
                                                  0.072
                                              : 70,
                                      dataRowHeight: 48.0,
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
                                          side:  BorderSide(
                                              color: acceptedPiecesList.isNotEmpty? MyColor.primaryColorblue:MyColor.textColorGrey2),
                                          textStyle:  TextStyle(
                                            fontSize: 18,
                                            color:acceptedPiecesList.isNotEmpty? MyColor.primaryColorblue:MyColor.textColorGrey2,
                                          ),
                                          shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(8)),
                                          ),
                                        ),
                                        onPressed: () {
                                          if (acceptedPiecesList.isNotEmpty) {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (_) =>
                                                        CaptureDamageandAccept(
                                                          shipmentData:
                                                          acceptedConsignment
                                                                  .first,
                                                        )));
                                          } else {}
                                        },
                                        child:  Text(
                                            "Capture Damage",style: TextStyle(color: acceptedPiecesList.isNotEmpty? MyColor.primaryColorblue:MyColor.textColorGrey2),),
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
                                            acceptShipment();
                                          }
                                        },
                                        child: const Text(
                                          "Accept",
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
          String prefix = result.substring(0, 3);
          String awb = result.substring(3);
          prefixController.text = prefix;
          awbController.text = awb;
        }
      }
    }
  }
}
