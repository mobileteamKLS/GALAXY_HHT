import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:galaxy/utils/dialogutils.dart';
import 'package:galaxy/utils/snackbarutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:toggle_switch/toggle_switch.dart';

import '../../core/images.dart';
import '../../core/mycolor.dart';
import '../../module/onboarding/sizeconfig.dart';
import '../../utils/sizeutils.dart';
import '../../widget/customebuttons/roundbuttonblue.dart';
import '../../widget/customeedittext/customeedittextwithborder.dart';
import '../../widget/custometext.dart';
import '../auth/auth.dart';
import '../modal/ShipmentAcceptanceModal.dart';
import '../utils/global.dart';
import '../widget/customDialog.dart';
import '../widget/customIpadTextfield.dart';
import 'ImportShipmentListing.dart';
import 'package:galaxy/Ipad/modal/ShipmentListingDetails.dart';

class CreateShipment extends StatefulWidget {
  const CreateShipment({super.key});

  @override
  State<CreateShipment> createState() => _CreateShipmentState();
}

class _CreateShipmentState extends State<CreateShipment> {
  int modeSelected = 0;
  TextEditingController prefixController = TextEditingController();
  TextEditingController awbNoController = TextEditingController();
  TextEditingController houseNoController = TextEditingController();
  TextEditingController nopController = TextEditingController();
  TextEditingController grossWeightController = TextEditingController();
  TextEditingController originController = TextEditingController();
  TextEditingController destinationController = TextEditingController();
  TextEditingController codeController = TextEditingController();
  TextEditingController flightNoController = TextEditingController();
  TextEditingController flightDateController = TextEditingController();
  TextEditingController uldController = TextEditingController();
  TextEditingController commTypeController = TextEditingController();
  TextEditingController firmsCodeController = TextEditingController();
  TextEditingController dispositionCodeController = TextEditingController();

  final AuthService authService = AuthService();
  bool isLoading = false;
  bool hasNoRecord = false;
  int selectedComId=-1;
  String selectedComCode="";

  resetData(){
    prefixController.clear();
    awbNoController.clear();
    houseNoController.clear();
    nopController.clear();
    grossWeightController.clear();
    originController.clear();
    destinationController.clear();
    flightNoController.clear();
    flightDateController.clear();
    uldController.clear();
    commTypeController.clear();
    firmsCodeController.clear();
    dispositionCodeController.clear();
    setState(() {
      modeSelected=0;
    });
  }

  validatedShipmentDetails() {
    String uld = "PMC12345BA";
    print("${uld.substring(0, 3)}");
    if (prefixController.text.isEmpty) {
      showDataNotFoundDialog(context, "AWB Prefix is required.");
      return;
    }
    if (awbNoController.text.isEmpty) {
      showDataNotFoundDialog(context, "AWB No is required.");
      return;
    }
    if (nopController.text.isEmpty) {
      showDataNotFoundDialog(context, "Nop is required.");
      return;
    }
    // if (grossWeightController.text.isEmpty) {
    //   showDataNotFoundDialog(context, "Weight is required.");
    //   return;
    // }
    if (originController.text.isEmpty) {
      showDataNotFoundDialog(context, "Origin is required.");
      return;
    }
    if (destinationController.text.isEmpty) {
      showDataNotFoundDialog(context, "Destination is required.");
      return;
    }
    // if (codeController.text.isEmpty) {
    //   showDataNotFoundDialog(context, "Code is required.");
    //   return;
    // }
    if (flightNoController.text.isEmpty) {
      showDataNotFoundDialog(context, "Flight No. is required.");
      return;
    }
    if (flightDateController.text.isEmpty) {
      showDataNotFoundDialog(context, "Flight Date is required.");
      return;
    }
    if (firmsCodeController.text.isEmpty) {
      showDataNotFoundDialog(context, "FIRMS is required.");
      return;
    }
    if (dispositionCodeController.text.isEmpty) {
      showDataNotFoundDialog(context, "Disposition Code is required.");
      return;
    }
    if(modeSelected==1){
      if (houseNoController.text.isEmpty) {
        showDataNotFoundDialog(context, "House No is required.");
        return;
      }
    }
    // final newShipment = ShipmentCreateDetails(
    //     vhRowId: 0,
    //     awbPrefix: prefixController.text,
    //     awbNo: awbNoController.text,
    //     houseNo: houseNoController.text,
    //     pieces: int.parse(nopController.text),
    //     weight: double.parse(grossWeightController.text),
    //     origin: "IST",
    //     destination: "BLR",
    //     commodity: 1,
    //     commodityType: commTypeController.text,
    //     airline: flightNoController.text.substring(0, 2),
    //     fltNo: flightNoController.text.substring(3),
    //     fltDate: flightDateController.text,
    //     uldType: uldController.text.substring(0, 3),
    //     uldNumber: uldController.text.substring(3, 8),
    //     uldOwner: uldController.text.substring(8, 10),
    //     firms: firmsCodeController.text,
    //     disposition: dispositionCodeController.text,
    //     fsnId: 0,
    //     shcDetailsXml: "",
    //     airportCode: "JFK",
    //     companyCode: 3,
    //     cultureCode: "en-US",
    //     userId: 1,
    //     menuId: 1);
    print(flightDateController.text);
    saveShipmentDetails();
  }

  saveShipmentDetails() async {
    DateTime flightDate = DateFormat('dd/MM/yyyy').parse(flightDateController.text.trim());
    String formattedFlightDate = DateFormat('yyyy-MM-dd').format(flightDate);
    var queryParams = {
      "VHRowId": 0,
      "AWBPrefix": prefixController.text,
      "AWBNo": awbNoController.text,
      "HouseNo": houseNoController.text,
      "Pieces": int.parse(nopController.text),
      "Weight": double.parse(grossWeightController.text),
      "Origin": originController.text,
      "Destination": destinationController.text,
      "Commodity": selectedComId,
      "CommodityType": selectedComCode,
      "Airline": flightNoController.text.substring(0, 2),
      "FltNo": flightNoController.text.substring(3),
      "FltDate": "$formattedFlightDate",
      "ULDType":uldController.text.isNotEmpty? uldController.text.substring(0, 3):"",
      "ULDNumber":uldController.text.isNotEmpty?uldController.text.substring(3, 8):"",
      "ULDOwner": uldController.text.isNotEmpty?uldController.text.substring(8, 10):"",
      "FIRMS": firmsCodeController.text,
      "Disposition":dispositionCodeController.text,
      "FSNId": 0,
      "SHCDetailsXML": "",
      "AirportCode": "JFK",
      "CompanyCode": 3,
      "CultureCode": "en-US",
      "UserId": 1,
      "MenuId": 1
    };
    DialogUtils.showLoadingDialog(context);
    await authService
        .postData(
      "ShipmentCreation/Save",
      queryParams,
    )
        .then((response) async {
      print("data received ");
      Map<String, dynamic> jsonData = json.decode(response.body);
      String status = jsonData['Status'];
      String? statusMessage = jsonData['StatusMessage']??"";
      if(jsonData.isNotEmpty){
        DialogUtils.hideLoadingDialog(context);
        if(status!="S"){
          showDataNotFoundDialog(context, statusMessage!);
        }
        if((status=="S")){
          //SnackbarUtil.showSnackbar(context, "Shipment Saved successfully", Color(0xff43A047));
          bool isTrue=await showDialog(
            context: context,
            builder: (BuildContext context) => CustomAlertMessageDialogNew(
              description: "Shipment created successfully",
              buttonText: "Okay",
              imagepath:'assets/images/successchk.gif',
              isMobile: false,
            ),
          );
        if(isTrue){
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const ImportShipmentListing()));
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
                padding: EdgeInsets.only(top: 20, left: 20, right: 20),
                child: Material(
                  color: Colors.transparent,
                  // Ensures background transparency
                  child: SingleChildScrollView(
                    child: Column(
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
                                  '  Shipment Creation',
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
                                const Text(
                                  "  SHIPMENT CREATION DETAILS",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 14),
                                ),
                                SizedBox(
                                  height:
                                      MediaQuery.sizeOf(context).height * 0.01,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(width: 10,),
                                    SizedBox(
                                      height: 45,
                                      width: MediaQuery.sizeOf(context).width *
                                          0.32,
                                      child: ToggleSwitch(
                                        minWidth:
                                            MediaQuery.sizeOf(context).width *
                                                0.5,
                                        minHeight: 45.0,
                                        fontSize: 14.0,
                                        initialLabelIndex: modeSelected,
                                        activeBgColor: const [
                                          MyColor.primaryColorblue
                                        ],
                                        activeFgColor: Colors.white,
                                        inactiveBgColor: Colors.white,
                                        inactiveFgColor: Colors.grey[900],
                                        totalSwitches: 2,
                                        labels: const [
                                          'Create MAWB',
                                          'Create HAWB'
                                        ],
                                        cornerRadius: 0.0,
                                        borderWidth: 0.5,
                                        borderColor: const [Colors.grey],
                                        onToggle: (index) {
                                          print('switched to: $index');
                                          prefixController.clear();
                                          awbNoController.clear();
                                          nopController.clear();
                                          grossWeightController.clear();
                                          houseNoController.clear();
                                          setState(() {
                                            modeSelected = index!;
                                          });
                                        },
                                      ),
                                    ),
                                    SizedBox(width: MediaQuery.sizeOf(context).width*0.14,),
                                    SizedBox(
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          const Icon(
                                            Icons.info_outline_rounded,
                                            color:Color(0xffFD8D00),
                                          ),
                                          Text.rich(
                                            TextSpan(
                                              children: [
                                                TextSpan(
                                                  text: "  You are creating a ",

                                                  style: GoogleFonts.roboto(
                                                    textStyle: const TextStyle(
                                                      letterSpacing: 0.5,
                                                      fontSize: 15,

                                                      color: Color(0xffFD8D00),
                                                      fontWeight: FontWeight.w400,
                                                    ),
                                                  ),
                                                ),
                                                modeSelected == 0
                                                    ? TextSpan(
                                                  text: "DIRECT ",

                                                  style: GoogleFonts.roboto(
                                                    textStyle:
                                                    const TextStyle(
                                                      letterSpacing: 0.5,
                                                      fontSize: 15,
                                                      color: Color(0xffFD8D00),
                                                      fontWeight:
                                                      FontWeight.bold,
                                                    ),
                                                  ),
                                                )
                                                    : TextSpan(
                                                  text: "CONSOL ",

                                                  style: GoogleFonts.roboto(
                                                    textStyle:
                                                    const TextStyle(
                                                      letterSpacing: 0.5,
                                                      fontSize: 15,
                                                      // Smaller size for "AJ"
                                                      color: Color(0xffFD8D00),
                                                      fontWeight:
                                                      FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                                TextSpan(
                                                  text: "Shipment",

                                                  style: GoogleFonts.roboto(
                                                    textStyle: const TextStyle(
                                                      letterSpacing: 0.5,
                                                      fontSize: 15,

                                                      color:Color(0xffFD8D00),
                                                      fontWeight: FontWeight.w400,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            textAlign: TextAlign.start,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                // SizedBox(
                                //   height:
                                //       MediaQuery.sizeOf(context).height * 0.02,
                                // ),

                                SizedBox(
                                  height:
                                      MediaQuery.sizeOf(context).height * 0.02,
                                ),
                                SizedBox(
                                  child: Column(
                                    children: [
                                      modeSelected == 0
                                          ? Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              children: [
                                                SizedBox(
                                                  width:
                                                      MediaQuery.sizeOf(context)
                                                              .width *
                                                          0.44,
                                                  child: Row(
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
                                                          hastextcolor: true,
                                                          animatedLabel: true,
                                                          needOutlineBorder:
                                                              true,
                                                          labelText: "Prefix*",
                                                          readOnly: false,
                                                          maxLength: 3,
                                                          textInputType:
                                                              TextInputType
                                                                  .number,
                                                          fontSize: 18,
                                                          controller: prefixController,
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
                                                          hastextcolor: true,
                                                          animatedLabel: true,
                                                          textInputType:
                                                              TextInputType
                                                                  .number,
                                                          needOutlineBorder:
                                                              true,
                                                          labelText: "AWB No*",
                                                          readOnly: false,
                                                          controller: awbNoController,
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
                                                  width:
                                                      MediaQuery.sizeOf(context)
                                                              .width *
                                                          0.45,
                                                  child: Row(
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
                                                                0.22,
                                                        child:
                                                            CustomeEditTextWithBorder(
                                                          lablekey: 'MAWB',
                                                          hasIcon: false,
                                                          hastextcolor: true,
                                                          animatedLabel: true,
                                                          needOutlineBorder:
                                                              true,
                                                          labelText: "NoP*",
                                                          readOnly: false,
                                                          controller: nopController,
                                                          textInputType:
                                                              TextInputType
                                                                  .number,
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
                                                            MediaQuery.sizeOf(
                                                                        context)
                                                                    .height *
                                                                0.04,
                                                        width:
                                                            MediaQuery.sizeOf(
                                                                        context)
                                                                    .width *
                                                                0.20,
                                                        child:
                                                            CustomeEditTextWithBorder(
                                                          lablekey: 'MAWB',
                                                          hasIcon: false,
                                                          hastextcolor: true,
                                                          animatedLabel: true,
                                                          needOutlineBorder:
                                                              true,
                                                          labelText:
                                                              "Weight",
                                                          readOnly: false,
                                                          controller: grossWeightController,
                                                          textInputType:
                                                              TextInputType
                                                                  .number,
                                                          maxLength: 4,
                                                          fontSize: 18,
                                                          onChanged:
                                                              (String, bool) {},
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            )
                                          : Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              children: [
                                                SizedBox(
                                                  width:
                                                      MediaQuery.sizeOf(context)
                                                              .width *
                                                          0.44,
                                                  child: Row(
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
                                                          hastextcolor: true,
                                                          animatedLabel: true,
                                                          needOutlineBorder:
                                                              true,
                                                          controller: prefixController,
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
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            SizedBox(
                                                              height: MediaQuery
                                                                          .sizeOf(
                                                                              context)
                                                                      .height *
                                                                  0.04,
                                                              width: MediaQuery
                                                                          .sizeOf(
                                                                              context)
                                                                      .width *
                                                                  0.15,
                                                              child:
                                                                  CustomeEditTextWithBorder(
                                                                lablekey:
                                                                    'MAWB',
                                                                hasIcon: false,
                                                                hastextcolor:
                                                                    true,
                                                                animatedLabel:
                                                                    true,
                                                                needOutlineBorder:
                                                                    true,
                                                                labelText:
                                                                    "AWB No*",
                                                                readOnly: false,
                                                                controller: awbNoController,
                                                                maxLength: 15,
                                                                fontSize: 18,
                                                                onChanged:
                                                                    (String,
                                                                        bool) {},
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                              width: 10,
                                                            ),
                                                            SizedBox(
                                                              height: MediaQuery
                                                                          .sizeOf(
                                                                              context)
                                                                      .height *
                                                                  0.04,
                                                              width: MediaQuery
                                                                          .sizeOf(
                                                                              context)
                                                                      .width *
                                                                  0.15,
                                                              child:
                                                                  CustomeEditTextWithBorder(
                                                                lablekey:
                                                                    'MAWB',
                                                                hasIcon: false,
                                                                hastextcolor:
                                                                    true,
                                                                animatedLabel:
                                                                    true,
                                                                needOutlineBorder:
                                                                    true,
                                                                labelText:
                                                                    "HAWB No*",
                                                                controller: houseNoController,
                                                                readOnly: false,
                                                                maxLength: 15,
                                                                fontSize: 18,
                                                                onChanged:
                                                                    (String,
                                                                        bool) {},
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                                SizedBox(
                                                  width:
                                                      MediaQuery.sizeOf(context)
                                                              .width *
                                                          0.45,
                                                  child: Row(
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
                                                                0.22,
                                                        child:
                                                            CustomeEditTextWithBorder(
                                                          lablekey: 'MAWB',
                                                          hasIcon: false,
                                                          hastextcolor: true,
                                                          animatedLabel: true,
                                                          needOutlineBorder:
                                                              true,
                                                          labelText: "NoP*",
                                                          readOnly: false,
                                                          controller: nopController,
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
                                                                0.20,
                                                        child:
                                                            CustomeEditTextWithBorder(
                                                          lablekey: 'MAWB',
                                                          hasIcon: false,
                                                          hastextcolor: true,
                                                          animatedLabel: true,
                                                          needOutlineBorder:
                                                              true,
                                                          labelText:
                                                              "Weight",
                                                          controller: grossWeightController,
                                                          readOnly: false,
                                                          maxLength: 15,
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
                                                0.435,
                                            child: TypeAheadField<OriginDestination>(
                                              controller: originController,
                                              debounceDuration: const Duration(
                                                  milliseconds: 300),
                                              suggestionsCallback: (search) =>
                                                  OriginAndDestinationService.find(search),
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
                                                      Text(item.airportCodeI313
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
                                                    "Origin*",
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
                                                    'No Origin Found',
                                                    style: TextStyle(
                                                        fontSize: 16)),
                                              ),
                                              onSelected: (value) {
                                                originController.text = value
                                                    .airportCodeI313
                                                    .toUpperCase();

                                              },
                                            ),
                                          ),
                                          Container(
                                            width: MediaQuery.sizeOf(context)
                                                    .width *
                                                0.445,
                                            padding: EdgeInsets.only(right: 6),
                                            child: TypeAheadField<OriginDestination>(
                                              controller: destinationController,
                                              debounceDuration: const Duration(
                                                  milliseconds: 300),
                                              suggestionsCallback: (search) =>
                                                  OriginAndDestinationService.find(search),
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
                                                      Text(item.airportCodeI313
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
                                                    "Destination*",
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
                                                    'No Destination Found',
                                                    style: TextStyle(
                                                        fontSize: 16)),
                                              ),
                                              onSelected: (value) {
                                                destinationController.text = value
                                                    .airportCodeI313
                                                    .toUpperCase();

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
                                                // SizedBox(
                                                //   height:
                                                //       MediaQuery.sizeOf(context)
                                                //               .height *
                                                //           0.04,
                                                //   width:
                                                //       MediaQuery.sizeOf(context)
                                                //               .width *
                                                //           0.1,
                                                //   child:
                                                //       CustomeEditTextWithBorder(
                                                //     lablekey: 'MAWB',
                                                //     hasIcon: false,
                                                //     hastextcolor: true,
                                                //     animatedLabel: true,
                                                //     needOutlineBorder: true,
                                                //     labelText: "Code*",
                                                //     controller: codeController,
                                                //     readOnly: false,
                                                //     maxLength: 15,
                                                //     fontSize: 18,
                                                //     onChanged:
                                                //         (String, bool) {},
                                                //   ),
                                                // ),
                                                // const SizedBox(
                                                //   width: 15,
                                                // ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
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
                                                              0.165,
                                                      child:
                                                          CustomeEditTextWithBorder(
                                                        lablekey: 'MAWB',
                                                        hasIcon: false,
                                                        hastextcolor: true,
                                                        animatedLabel: true,
                                                        needOutlineBorder:
                                                            true,
                                                        labelText:
                                                            "Flight No*",
                                                        readOnly: false,
                                                        controller: flightNoController,
                                                        maxLength: 15,
                                                        fontSize: 18,
                                                        onChanged:
                                                            (String, bool) {},
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      width: 10,
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
                                                              0.26,
                                                      child:
                                                          CustomeEditTextWithBorderDatePicker(
                                                        lablekey: 'MAWB',
                                                        controller:
                                                            flightDateController,
                                                        labelText:
                                                            "Flight Date*",
                                                        readOnly: false,
                                                        maxLength: 15,
                                                        fontSize: 18,
                                                      ),
                                                    ),
                                                  ],
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
                                                    labelText: "ULD No.",
                                                    readOnly: false,
                                                    controller: uldController,
                                                    maxLength: 15,
                                                    fontSize: 18,
                                                    onChanged:
                                                        (String, bool) {},
                                                  ),
                                                ),
                                                const SizedBox(
                                                  width: 15,
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
                                          SizedBox(
                                            width: MediaQuery.sizeOf(context)
                                                    .width *
                                                0.44,
                                            child: TypeAheadField<Commodity>(
                                              controller: commTypeController,
                                              debounceDuration: const Duration(
                                                  milliseconds: 300),
                                              suggestionsCallback: (search) =>
                                                  CommodityService.find(search),
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
                                                commTypeController.text = value
                                                    .commodityType
                                                    .toUpperCase();
                                                selectedComId=value.commodityId;
                                                selectedComCode=value.commodityCode;
                                              },
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
                                                  TypeAheadField<FrmAndDcpCode>(
                                                    controller: firmsCodeController,
                                                    debounceDuration: const Duration(
                                                        milliseconds: 300),
                                                    suggestionsCallback: (search) =>
                                                        FirmsCodeService.find(search),
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
                                                            Text(item.referenceDataIdentifier
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
                                                          "FIRMS Code*",
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
                                                          'No FIRMS Code Found',
                                                          style: TextStyle(
                                                              fontSize: 16)),
                                                    ),
                                                    onSelected: (value) {
                                                      firmsCodeController.text = value
                                                          .referenceDataIdentifier
                                                          .toUpperCase();

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
                                                  TypeAheadField<FrmAndDcpCode>(
                                                    controller: dispositionCodeController,
                                                    debounceDuration: const Duration(
                                                        milliseconds: 300),
                                                    suggestionsCallback: (search) =>
                                                        DispositionCodeService.find(search),
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
                                                            Text(item.referenceDataIdentifier
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
                                                          "Disposition Code*",
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
                                                          'No Disposition Code Found',
                                                          style: TextStyle(
                                                              fontSize: 16)),
                                                    ),
                                                    onSelected: (value) {
                                                      dispositionCodeController.text = value
                                                          .referenceDataIdentifier
                                                          .toUpperCase();

                                                    },
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
                                // : SizedBox(
                                //     child: Column(
                                //       children: [
                                //         Row(
                                //           mainAxisAlignment:
                                //               MainAxisAlignment.spaceAround,
                                //           children: [
                                //             SizedBox(
                                //               width:
                                //                   MediaQuery.sizeOf(context)
                                //                           .width *
                                //                       0.44,
                                //               child: Row(
                                //                 children: [
                                //                   SizedBox(
                                //                     height:
                                //                         MediaQuery.sizeOf(
                                //                                     context)
                                //                                 .height *
                                //                             0.04,
                                //                     width:
                                //                         MediaQuery.sizeOf(
                                //                                     context)
                                //                                 .width *
                                //                             0.1,
                                //                     child:
                                //                         CustomeEditTextWithBorder(
                                //                       lablekey: 'MAWB',
                                //                       hasIcon: false,
                                //                       hastextcolor: true,
                                //                       animatedLabel: true,
                                //                       needOutlineBorder:
                                //                           true,
                                //                       labelText: "Prefix*",
                                //                       readOnly: false,
                                //                       maxLength: 15,
                                //                       fontSize: 18,
                                //                       onChanged:
                                //                           (String, bool) {},
                                //                     ),
                                //                   ),
                                //                   const SizedBox(
                                //                     width: 15,
                                //                   ),
                                //                   SizedBox(
                                //                     height:
                                //                         MediaQuery.sizeOf(
                                //                                     context)
                                //                                 .height *
                                //                             0.04,
                                //                     width:
                                //                         MediaQuery.sizeOf(
                                //                                     context)
                                //                                 .width *
                                //                             0.32,
                                //                     child: Row(
                                //                       mainAxisAlignment:
                                //                           MainAxisAlignment
                                //                               .spaceBetween,
                                //                       children: [
                                //                         SizedBox(
                                //                           height: MediaQuery
                                //                                       .sizeOf(
                                //                                           context)
                                //                                   .height *
                                //                               0.04,
                                //                           width: MediaQuery
                                //                                       .sizeOf(
                                //                                           context)
                                //                                   .width *
                                //                               0.15,
                                //                           child:
                                //                               CustomeEditTextWithBorder(
                                //                             lablekey:
                                //                                 'MAWB',
                                //                             hasIcon: false,
                                //                             hastextcolor:
                                //                                 true,
                                //                             animatedLabel:
                                //                                 true,
                                //                             needOutlineBorder:
                                //                                 true,
                                //                             labelText:
                                //                                 "AWB No*",
                                //                             readOnly: false,
                                //                             maxLength: 15,
                                //                             fontSize: 18,
                                //                             onChanged:
                                //                                 (String,
                                //                                     bool) {},
                                //                           ),
                                //                         ),
                                //                         const SizedBox(
                                //                           width: 10,
                                //                         ),
                                //                         SizedBox(
                                //                           height: MediaQuery
                                //                                       .sizeOf(
                                //                                           context)
                                //                                   .height *
                                //                               0.04,
                                //                           width: MediaQuery
                                //                                       .sizeOf(
                                //                                           context)
                                //                                   .width *
                                //                               0.15,
                                //                           child:
                                //                               CustomeEditTextWithBorder(
                                //                             lablekey:
                                //                                 'MAWB',
                                //                             hasIcon: false,
                                //                             hastextcolor:
                                //                                 true,
                                //                             animatedLabel:
                                //                                 true,
                                //                             needOutlineBorder:
                                //                                 true,
                                //                             labelText:
                                //                                 "HAWB No*",
                                //                             readOnly: false,
                                //                             maxLength: 15,
                                //                             fontSize: 18,
                                //                             onChanged:
                                //                                 (String,
                                //                                     bool) {},
                                //                           ),
                                //                         ),
                                //                       ],
                                //                     ),
                                //                   )
                                //                 ],
                                //               ),
                                //             ),
                                //             SizedBox(
                                //               width:
                                //                   MediaQuery.sizeOf(context)
                                //                           .width *
                                //                       0.45,
                                //               child: Row(
                                //                 children: [
                                //                   SizedBox(
                                //                     height:
                                //                         MediaQuery.sizeOf(
                                //                                     context)
                                //                                 .height *
                                //                             0.04,
                                //                     width:
                                //                         MediaQuery.sizeOf(
                                //                                     context)
                                //                                 .width *
                                //                             0.22,
                                //                     child:
                                //                         CustomeEditTextWithBorder(
                                //                       lablekey: 'MAWB',
                                //                       hasIcon: false,
                                //                       hastextcolor: true,
                                //                       animatedLabel: true,
                                //                       needOutlineBorder:
                                //                           true,
                                //                       labelText: "NoP*",
                                //                       readOnly: false,
                                //                       maxLength: 15,
                                //                       fontSize: 18,
                                //                       onChanged:
                                //                           (String, bool) {},
                                //                     ),
                                //                   ),
                                //                   const SizedBox(
                                //                     width: 15,
                                //                   ),
                                //                   SizedBox(
                                //                     height:
                                //                         MediaQuery.sizeOf(
                                //                                     context)
                                //                                 .height *
                                //                             0.04,
                                //                     width:
                                //                         MediaQuery.sizeOf(
                                //                                     context)
                                //                                 .width *
                                //                             0.20,
                                //                     child:
                                //                         CustomeEditTextWithBorder(
                                //                       lablekey: 'MAWB',
                                //                       hasIcon: false,
                                //                       hastextcolor: true,
                                //                       animatedLabel: true,
                                //                       needOutlineBorder:
                                //                           true,
                                //                       labelText:
                                //                           "Gross Weight*",
                                //                       readOnly: false,
                                //                       maxLength: 15,
                                //                       fontSize: 18,
                                //                       onChanged:
                                //                           (String, bool) {},
                                //                     ),
                                //                   )
                                //                 ],
                                //               ),
                                //             ),
                                //           ],
                                //         ),
                                //         SizedBox(
                                //           height: MediaQuery.sizeOf(context)
                                //                   .height *
                                //               0.02,
                                //         ),
                                //         Row(
                                //           mainAxisAlignment:
                                //               MainAxisAlignment.spaceAround,
                                //           children: [
                                //             SizedBox(
                                //               width:
                                //                   MediaQuery.sizeOf(context)
                                //                           .width *
                                //                       0.44,
                                //               child:
                                //                   CustomeEditTextWithBorder(
                                //                 lablekey: 'MAWB',
                                //                 hasIcon: false,
                                //                 hastextcolor: true,
                                //                 animatedLabel: true,
                                //                 needOutlineBorder: true,
                                //                 labelText: "Origin*",
                                //                 readOnly: false,
                                //                 maxLength: 15,
                                //                 fontSize: 18,
                                //                 onChanged:
                                //                     (String, bool) {},
                                //               ),
                                //             ),
                                //             SizedBox(
                                //               width:
                                //                   MediaQuery.sizeOf(context)
                                //                           .width *
                                //                       0.44,
                                //               child:
                                //                   CustomeEditTextWithBorder(
                                //                 lablekey: 'MAWB',
                                //                 hasIcon: false,
                                //                 hastextcolor: true,
                                //                 animatedLabel: true,
                                //                 needOutlineBorder: true,
                                //                 labelText: "Destination*",
                                //                 readOnly: false,
                                //                 maxLength: 15,
                                //                 fontSize: 18,
                                //                 onChanged:
                                //                     (String, bool) {},
                                //               ),
                                //             ),
                                //           ],
                                //         ),
                                //         SizedBox(
                                //           height: MediaQuery.sizeOf(context)
                                //                   .height *
                                //               0.02,
                                //         ),
                                //         Row(
                                //           mainAxisAlignment:
                                //               MainAxisAlignment.spaceAround,
                                //           children: [
                                //             SizedBox(
                                //               width:
                                //                   MediaQuery.sizeOf(context)
                                //                           .width *
                                //                       0.44,
                                //               child: Row(
                                //                 children: [
                                //                   SizedBox(
                                //                     height:
                                //                         MediaQuery.sizeOf(
                                //                                     context)
                                //                                 .height *
                                //                             0.04,
                                //                     width:
                                //                         MediaQuery.sizeOf(
                                //                                     context)
                                //                                 .width *
                                //                             0.1,
                                //                     child:
                                //                         CustomeEditTextWithBorder(
                                //                       lablekey: 'MAWB',
                                //                       hasIcon: false,
                                //                       hastextcolor: true,
                                //                       animatedLabel: true,
                                //                       needOutlineBorder:
                                //                           true,
                                //                       labelText: "Code*",
                                //                       readOnly: false,
                                //                       maxLength: 15,
                                //                       fontSize: 18,
                                //                       onChanged:
                                //                           (String, bool) {},
                                //                     ),
                                //                   ),
                                //                   const SizedBox(
                                //                     width: 15,
                                //                   ),
                                //                   SizedBox(
                                //                     height:
                                //                         MediaQuery.sizeOf(
                                //                                     context)
                                //                                 .height *
                                //                             0.04,
                                //                     width:
                                //                         MediaQuery.sizeOf(
                                //                                     context)
                                //                                 .width *
                                //                             0.32,
                                //                     child: Row(
                                //                       mainAxisAlignment:
                                //                           MainAxisAlignment
                                //                               .spaceBetween,
                                //                       children: [
                                //                         SizedBox(
                                //                           height: MediaQuery
                                //                                       .sizeOf(
                                //                                           context)
                                //                                   .height *
                                //                               0.04,
                                //                           width: MediaQuery
                                //                                       .sizeOf(
                                //                                           context)
                                //                                   .width *
                                //                               0.15,
                                //                           child:
                                //                               CustomeEditTextWithBorder(
                                //                             lablekey:
                                //                                 'MAWB',
                                //                             hasIcon: false,
                                //                             hastextcolor:
                                //                                 true,
                                //                             animatedLabel:
                                //                                 true,
                                //                             needOutlineBorder:
                                //                                 true,
                                //                             labelText:
                                //                                 "Flight No*",
                                //                             readOnly: false,
                                //                             maxLength: 15,
                                //                             fontSize: 18,
                                //                             onChanged:
                                //                                 (String,
                                //                                     bool) {},
                                //                           ),
                                //                         ),
                                //                         SizedBox(
                                //                           width: 10,
                                //                         ),
                                //                         SizedBox(
                                //                           height: MediaQuery
                                //                                       .sizeOf(
                                //                                           context)
                                //                                   .height *
                                //                               0.04,
                                //                           width: MediaQuery
                                //                                       .sizeOf(
                                //                                           context)
                                //                                   .width *
                                //                               0.15,
                                //                           child:
                                //                               CustomeEditTextWithBorder(
                                //                             lablekey:
                                //                                 'MAWB',
                                //                             hasIcon: false,
                                //                             hastextcolor:
                                //                                 true,
                                //                             animatedLabel:
                                //                                 true,
                                //                             needOutlineBorder:
                                //                                 true,
                                //                             labelText:
                                //                                 "Flight Date*",
                                //                             readOnly: false,
                                //                             maxLength: 15,
                                //                             fontSize: 18,
                                //                             onChanged:
                                //                                 (String,
                                //                                     bool) {},
                                //                           ),
                                //                         ),
                                //                       ],
                                //                     ),
                                //                   )
                                //                 ],
                                //               ),
                                //             ),
                                //             SizedBox(
                                //               width:
                                //                   MediaQuery.sizeOf(context)
                                //                           .width *
                                //                       0.45,
                                //               child: Row(
                                //                 children: [
                                //                   SizedBox(
                                //                     height:
                                //                         MediaQuery.sizeOf(
                                //                                     context)
                                //                                 .height *
                                //                             0.04,
                                //                     width:
                                //                         MediaQuery.sizeOf(
                                //                                     context)
                                //                                 .width *
                                //                             0.22,
                                //                     child:
                                //                         CustomeEditTextWithBorder(
                                //                       lablekey: 'MAWB',
                                //                       hasIcon: false,
                                //                       hastextcolor: true,
                                //                       animatedLabel: true,
                                //                       needOutlineBorder:
                                //                           true,
                                //                       labelText: "ULD*",
                                //                       readOnly: false,
                                //                       maxLength: 15,
                                //                       fontSize: 18,
                                //                       onChanged:
                                //                           (String, bool) {},
                                //                     ),
                                //                   ),
                                //                   const SizedBox(
                                //                     width: 15,
                                //                   ),
                                //                 ],
                                //               ),
                                //             ),
                                //           ],
                                //         ),
                                //         SizedBox(
                                //           height: MediaQuery.sizeOf(context)
                                //                   .height *
                                //               0.02,
                                //         ),
                                //         Row(
                                //           mainAxisAlignment:
                                //               MainAxisAlignment.spaceAround,
                                //           children: [
                                //             SizedBox(
                                //               width:
                                //                   MediaQuery.sizeOf(context)
                                //                           .width *
                                //                       0.44,
                                //               child:
                                //                   CustomeEditTextWithBorder(
                                //                 lablekey: 'MAWB',
                                //                 hasIcon: false,
                                //                 hastextcolor: true,
                                //                 animatedLabel: true,
                                //                 needOutlineBorder: true,
                                //                 labelText: "Commodity Type",
                                //                 readOnly: false,
                                //                 maxLength: 15,
                                //                 fontSize: 18,
                                //                 onChanged:
                                //                     (String, bool) {},
                                //               ),
                                //             ),
                                //             SizedBox(
                                //               width:
                                //                   MediaQuery.sizeOf(context)
                                //                           .width *
                                //                       0.45,
                                //               child: Row(
                                //                 children: [
                                //                   SizedBox(
                                //                     height:
                                //                         MediaQuery.sizeOf(
                                //                                     context)
                                //                                 .height *
                                //                             0.04,
                                //                     width:
                                //                         MediaQuery.sizeOf(
                                //                                     context)
                                //                                 .width *
                                //                             0.22,
                                //                     child:
                                //                         CustomeEditTextWithBorder(
                                //                       lablekey: 'MAWB',
                                //                       hasIcon: false,
                                //                       hastextcolor: true,
                                //                       animatedLabel: true,
                                //                       needOutlineBorder:
                                //                           true,
                                //                       labelText:
                                //                           "FIRMS Code",
                                //                       readOnly: false,
                                //                       maxLength: 15,
                                //                       fontSize: 18,
                                //                       onChanged:
                                //                           (String, bool) {},
                                //                     ),
                                //                   ),
                                //                   const SizedBox(
                                //                     width: 15,
                                //                   ),
                                //                   SizedBox(
                                //                     height:
                                //                         MediaQuery.sizeOf(
                                //                                     context)
                                //                                 .height *
                                //                             0.04,
                                //                     width:
                                //                         MediaQuery.sizeOf(
                                //                                     context)
                                //                                 .width *
                                //                             0.20,
                                //                     child:
                                //                         CustomeEditTextWithBorder(
                                //                       lablekey: 'MAWB',
                                //                       hasIcon: false,
                                //                       hastextcolor: true,
                                //                       animatedLabel: true,
                                //                       needOutlineBorder:
                                //                           true,
                                //                       labelText:
                                //                           "Disposition Weight*",
                                //                       readOnly: false,
                                //                       maxLength: 15,
                                //                       fontSize: 18,
                                //                       onChanged:
                                //                           (String, bool) {},
                                //                     ),
                                //                   )
                                //                 ],
                                //               ),
                                //             ),
                                //           ],
                                //         ),
                                //       ],
                                //     ),
                                //   ),
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
                                          validatedShipmentDetails();
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
        // floatingActionButton: Theme(
        //   data: ThemeData(useMaterial3: false),
        //   child: FloatingActionButton(
        //     onPressed: () {},
        //     backgroundColor: MyColor.primaryColorblue,
        //     child: const Icon(Icons.add),
        //   ),
        // ),
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
}
