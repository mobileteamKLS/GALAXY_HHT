import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:galaxy/Ipad/modal/ShipmentListingDetails.dart';
import 'package:galaxy/Ipad/utils/global.dart';
import 'package:galaxy/utils/dialogutils.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vibration/vibration.dart';
import '../../core/images.dart';
import '../../core/mycolor.dart';
import '../../module/import/model/flightcheck/mailtypemodel.dart';
import '../../module/onboarding/sizeconfig.dart';
import '../../utils/commonutils.dart';
import '../../utils/sizeutils.dart';
import '../../utils/snackbarutil.dart';
import '../../widget/customebuttons/roundbuttonblue.dart';
import '../../widget/customeedittext/customeedittextwithborder.dart';
import '../../widget/custometext.dart';
import '../auth/auth.dart';
import '../modal/ShipmentAcceptanceModal.dart';
import '../widget/customIpadTextfield.dart';
import 'CaptureDamageAndAccept.dart';
import 'ImportCreateShipment.dart';
import 'ImportShipmentListing.dart';

class ShipmentAcceptanceManually extends StatefulWidget {
  const ShipmentAcceptanceManually({super.key});

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
  FocusNode prefixFocusNode = FocusNode();
  FocusNode awbFocusNode = FocusNode();
  FocusNode houseFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    // awbSearch();
    print("-----${commodityListMaster.length}");
    awbFocusNode.addListener(() {
      if (!awbFocusNode.hasFocus) {
        print("LOST focus");
         leftAWBFocus();
      }
    },);
    houseFocusNode.addListener(() {
      if (!houseFocusNode.hasFocus) {
        // leaveDestinationFocus();
      }
    },);
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
              Icon(Icons.cancel, color: MyColor.colorRed, size: 60),
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

  leftAWBFocus() async {
    if(awbController.text.length!=8){
      showDataNotFoundDialog(context, "Please enter a valid AWB No.");
      return;
    }
    if(prefixController.text.length!=3){
      showDataNotFoundDialog(context, "Please enter a valid AWB No.");
      return;
    }
    if (awbController.text.isNotEmpty && prefixController.text.isNotEmpty) {
      print("iput is valid");
      awbSearch();
    }
  }


  awbSearch() async {
    DialogUtils.showLoadingDialog(context);
    var queryParams ={
      "InputXML": "<Root><AWBPrefix>${prefixController.text}</AWBPrefix><AWBNo>${awbController.text}</AWBNo><HAWBNO>${houseController.text}</HAWBNO><AirportCity>JFK</AirportCity><Culture>en-US</Culture><CompanyCode>3</CompanyCode><UserId>1</UserId></Root>"
    };

    await authService.sendXmlInGetWithBody("ShipmentAcceptance/GetShipmentDetails",queryParams)
        .then((response) {
      print("data received ");
      Map<String, dynamic> jsonData = json.decode(response.body);

      print(jsonData);
      if (jsonData.isEmpty) {
        setState(() {
          hasNoRecord = true;
        });
      }
      else{
        hasNoRecord=false;
      }
      print("is empty record$hasNoRecord");
      String status = jsonData['ReturnOutput'][0]['Status'];
      String statusMessage = jsonData['ReturnOutput'][0]['StrMessage'];

      if (status != 'S') {
        print("Error: $statusMessage");
        DialogUtils.hideLoadingDialog(context);
        showDataNotFoundDialog(context, statusMessage);
        return;
      }
      DialogUtils.hideLoadingDialog(context);
    }).catchError((onError) {
      DialogUtils.hideLoadingDialog(context);
      print(onError);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
            title: const Text(
              'Imports',
              style: TextStyle(color: Colors.white),
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
                                  '  Shipment Acceptance',
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
                                                    hastextcolor: true,
                                                    animatedLabel: true,
                                                    needOutlineBorder: true,
                                                    labelText: "Prefix*",
                                                    readOnly: false,
                                                    focusNode: prefixFocusNode,
                                                    controller: prefixController,
                                                    maxLength: 3, onPress: () {},
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
                                                          0.26,
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
                                                  child: Padding(padding: const EdgeInsets.all(2.0),
                                                    child: SvgPicture.asset(search, height: SizeConfig.blockSizeVertical * SizeUtils.ICONSIZE2,),
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
                                                      0.38,
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
                                                    onPress: () {},
                                                    readOnly: false,
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
                                                  child: Padding(padding: const EdgeInsets.all(2.0),
                                                    child: SvgPicture.asset(search, height: SizeConfig.blockSizeVertical * SizeUtils.ICONSIZE2,),
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
                                                    labelText: "NoP*",
                                                    readOnly: false,
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
                                                        onPress: () {},
                                                    readOnly: false,
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
                                                        onPress: () {},
                                                    readOnly: false,
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
                                                    labelText: "Group Id*",
                                                        onPress: () {},
                                                    readOnly: false,
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
                                            child: TypeAheadField<
                                                Commodity>(
                                              controller: commodityController,
                                              debounceDuration:
                                              const Duration(milliseconds: 300),
                                              suggestionsCallback: (search) =>
                                                  CommodityService.find(search),
                                              itemBuilder: (context, item) {
                                                return Container(
                                                  decoration: const BoxDecoration(
                                                    border: Border(
                                                      top: BorderSide(
                                                          color: Colors.black, width: 0.2),
                                                      left: BorderSide(
                                                          color: Colors.black, width: 0.2),
                                                      right: BorderSide(
                                                          color: Colors.black, width: 0.2),
                                                      bottom: BorderSide
                                                          .none, // No border on the bottom
                                                    ),
                                                  ),
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: Row(
                                                    children: [

                                                      Text(item.commodityType.toUpperCase()),
                                                    ],
                                                  ),
                                                );
                                              },
                                              builder: (context, controller, focusNode) =>
                                                  CustomeEditTextWithBorder(
                                                    lablekey: 'MAWB',
                                                    controller: controller,
                                                    focusNode: focusNode,
                                                    hasIcon: false,
                                                    hastextcolor: true,
                                                    animatedLabel: true,
                                                    needOutlineBorder: true,
                                                    onPress: () {},
                                                    labelText: "Commodity/Activity*",
                                                    readOnly: false,

                                                    fontSize: 18,
                                                    onChanged: (String, bool) {},
                                                  ),
                                              decorationBuilder: (context, child) =>
                                                  Material(
                                                    type: MaterialType.card,
                                                    elevation: 4,
                                                    borderRadius: BorderRadius.circular(8.0),
                                                    child: child,
                                                  ),
                                              // itemSeparatorBuilder: (context, index) =>
                                              //     Divider(),
                                              emptyBuilder: (context) => const Padding(
                                                padding: EdgeInsets.all(8.0),
                                                child: Text('No Commodity Found',
                                                    style: TextStyle(fontSize: 16)),
                                              ),
                                              onSelected: (value) {
                                                commodityController.text =
                                                    value.commodityType
                                                        .toUpperCase();

                                              },
                                            ),
                                          ),
                                          SizedBox(
                                            width: MediaQuery.sizeOf(context)
                                                    .width *
                                                0.44,
                                            child: TypeAheadField<
                                                Customer>(
                                              controller: agentController,
                                              debounceDuration:
                                              const Duration(milliseconds: 300),
                                              suggestionsCallback: (search) =>
                                                  AgentService.find(search),
                                              itemBuilder: (context, item) {
                                                return Container(
                                                  decoration: const BoxDecoration(
                                                    border: Border(
                                                      top: BorderSide(
                                                          color: Colors.black, width: 0.2),
                                                      left: BorderSide(
                                                          color: Colors.black, width: 0.2),
                                                      right: BorderSide(
                                                          color: Colors.black, width: 0.2),
                                                      bottom: BorderSide
                                                          .none, // No border on the bottom
                                                    ),
                                                  ),
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: Row(
                                                    children: [

                                                      Text(item.customerName.toUpperCase()),
                                                    ],
                                                  ),
                                                );
                                              },
                                              builder: (context, controller, focusNode) =>
                                                  CustomeEditTextWithBorder(
                                                    lablekey: 'MAWB',
                                                    controller: controller,
                                                    focusNode: focusNode,
                                                    hasIcon: false,
                                                    hastextcolor: true,
                                                    animatedLabel: true,
                                                    needOutlineBorder: true,
                                                    onPress: () {},
                                                    labelText: "Agent Code - Name*",
                                                    readOnly: false,

                                                    fontSize: 18,
                                                    onChanged: (String, bool) {},
                                                  ),
                                              decorationBuilder: (context, child) =>
                                                  Material(
                                                    type: MaterialType.card,
                                                    elevation: 4,
                                                    borderRadius: BorderRadius.circular(8.0),
                                                    child: child,
                                                  ),
                                              // itemSeparatorBuilder: (context, index) =>
                                              //     Divider(),
                                              emptyBuilder: (context) => const Padding(
                                                padding: EdgeInsets.all(8.0),
                                                child: Text('No Customer Found',
                                                    style: TextStyle(fontSize: 16)),
                                              ),
                                              onSelected: (value) {
                                                agentController.text =
                                                    value.customerName
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
                                      const Row(
                                        children: [
                                          Text("   CAPTURE RECEIVED SHIPMENT",style: TextStyle(color: Colors.black,fontWeight: FontWeight.w800,fontSize: 16)),
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
                                                    readOnly: false,
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
                                                    labelText: "Received Weight*",
                                                    readOnly: false,
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
                                                    readOnly: false,
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
                        // SizedBox(
                        //   height: MediaQuery.sizeOf(context).height * 0.015,
                        // ),
                        // Container(
                        //   decoration: BoxDecoration(
                        //     borderRadius: BorderRadius.circular(12.0),
                        //     color: Colors.white,
                        //     boxShadow: [
                        //       BoxShadow(
                        //         color: Colors.black.withOpacity(0.1),
                        //         spreadRadius: 2,
                        //         blurRadius: 8,
                        //         offset: const Offset(
                        //             0, 3), // changes position of shadow
                        //       ),
                        //     ],
                        //   ),
                        //   child: Padding(
                        //     padding: const EdgeInsets.symmetric(
                        //         vertical: 14, horizontal: 10),
                        //     child: Column(
                        //       crossAxisAlignment: CrossAxisAlignment.start,
                        //       children: [
                        //         const Text("  Part Shipment History",style: TextStyle(color: Colors.black,fontWeight: FontWeight.w800,fontSize: 16),),
                        //         SizedBox(height: 10,),
                        //         Container(
                        //           width: MediaQuery.sizeOf(context).width,
                        //           color: Color(0xffE4E7EB),
                        //           padding: EdgeInsets.all(2.0),
                        //           child: SingleChildScrollView(
                        //             scrollDirection: Axis.horizontal,
                        //             child: DataTable(
                        //               columns: const [
                        //                 DataColumn(label: Text('Received NoP')),
                        //                 DataColumn(label: Text('Received Weight')),
                        //                 DataColumn(label: Text('Unit')),
                        //                 DataColumn(label: Text('Accepted By')),
                        //                 DataColumn(label: Text('Accepted On')),
                        //                 DataColumn(label: Text('Group ID')),
                        //               ],
                        //               rows: const [
                        //                 DataRow(cells: [
                        //                   DataCell(Text('10')),
                        //                   DataCell(Text('1000.00')),
                        //                   DataCell(Text('KG')),
                        //                   DataCell(Text('-')), // Assuming "-" for empty cells
                        //                   DataCell(Text('01 AUG 2024 09:30')),
                        //                   DataCell(Text('-')), // Assuming "-" for empty cells
                        //                 ]),
                        //               ],
                        //               headingRowColor:
                        //               WidgetStateProperty.resolveWith((states) => Color(0xfff1f1f1)),
                        //               dataRowColor:  WidgetStateProperty.resolveWith((states) => Color(0xfffafafa)),
                        //               columnSpacing: 64.0,
                        //               dataRowHeight: 48.0,
                        //
                        //             ),
                        //           ),
                        //         ),
                        //       ],
                        //     ),
                        //   ),
                        // ),
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
                                          Navigator.push(context, MaterialPageRoute(builder: (_)=>const CaptureDamageandAccept()));
                                        },
                                        child: const Text("Capture Damage & Accept"),
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
                                        onPressed: () {},
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

  Future<void> scanQRAWB(bool isHawb) async {
    String barcodeScanResult =  await FlutterBarcodeScanner.scanBarcode(
      '#ff6666', // Color for the scanner overlay
      'Cancel', // Text for the cancel button
      true, // Enable flash option
      ScanMode.DEFAULT, // Scan mode
    );

    print("barcode scann ==== ${barcodeScanResult}");
    if(barcodeScanResult == "-1"){

    }else{

      bool specialCharAllow = CommonUtils.containsSpecialCharactersAndAlpha(barcodeScanResult);

      print("SPECIALCHAR_ALLOW ===== ${specialCharAllow}");


      if(false){
        SnackbarUtil.showSnackbar(context, "Only numeric values are accepted.", MyColor.colorRed, icon: FontAwesomeIcons.times);
        Vibration.vibrate(duration: 500);
        prefixController.clear();
        awbController.clear();
        // WidgetsBinding.instance.addPostFrameCallback((_) {
        //   FocusScope.of(context).requestFocus(igmNoFocusNode);
        // });
      }else{

        String result = barcodeScanResult.replaceAll(" ", "");
        if(isHawb){
          houseController.text=result;
        }
        else{
          String prefix = result.substring(0, 2);
          String awb = result.substring(3);
          prefixController.text = prefix;
          awbController.text = awb;
        }

        //callFlightCheckULDListApi(context, locationController.text, truncatedResult, "", "1900-01-01", _user!.userProfile!.userIdentity!, _splashDefaultData!.companyCode!, widget.menuId, (_isOpenULDFlagEnable == true) ? 1 : 0);
      }
    }
  }


}
