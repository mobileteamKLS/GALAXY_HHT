import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:galaxy/utils/dialogutils.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:toggle_switch/toggle_switch.dart';

import '../../core/images.dart';
import '../../core/mycolor.dart';
import '../../widget/customebuttons/roundbuttonblue.dart';
import '../../widget/customeedittext/customeedittextwithborder.dart';
import '../../widget/custometext.dart';
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

  saveShipmentDetails() {
    String uld="PMC12345BA";
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
    if (grossWeightController.text.isEmpty) {
      showDataNotFoundDialog(context, "Gross Weight is required.");
      return;
    }
    if (originController.text.isEmpty) {
      showDataNotFoundDialog(context, "Origin is required.");
      return;
    }
    if (destinationController.text.isEmpty) {
      showDataNotFoundDialog(context, "Destination is required.");
      return;
    }
    if (codeController.text.isEmpty) {
      showDataNotFoundDialog(context, "Code is required.");
      return;
    }
    if (flightNoController.text.isEmpty) {
      showDataNotFoundDialog(context, "Flight No. is required.");
      return;
    }
    if (flightDateController.text.isEmpty) {
      showDataNotFoundDialog(context, "Flight Date is required.");
      return;
    }
    if (uldController.text.isEmpty) {
      showDataNotFoundDialog(context, "ULD is required.");
      return;
    }
    final newShipment=ShipmentCreateDetails(
      vhRowId: 0,
      awbPrefix: prefixController.text,
      awbNo: awbNoController.text,
      houseNo: houseNoController.text,
      pieces:int.parse( nopController.text),
      weight: double.parse(grossWeightController.text),
      origin: "IST",
      destination: "BLR",
      commodity: 1,
      commodityType: commTypeController.text,
      airline:flightNoController.text.substring(0,2),
      fltNo: flightNoController.text.substring(3),
      fltDate: flightDateController.text,
      uldType: uldController.text.substring(0,3),
      uldNumber: uldController.text.substring(3,8),
      uldOwner: uldController.text.substring(8,10),
      firms: firmsCodeController.text,
      disposition: dispositionCodeController.text,
      fsnId: 0,
      shcDetailsXml: "",
      airportCode: "BLR",
      companyCode: 3,
      cultureCode: "en-US",
      userId: 1,
      menuId: 1
    );
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
                padding: EdgeInsets.only(top: 20, left: 20, right: 20),
                child: Material(
                  color: Colors.transparent,
                  // Ensures background transparency
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        const Row(
                          children: [
                            Text(
                              'Booking Creation',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18),
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
                                const Text(
                                  "SHIPMENT CREATION DETAILS",
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
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
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

                                          setState(() {
                                            modeSelected = index!;
                                          });
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height:
                                      MediaQuery.sizeOf(context).height * 0.02,
                                ),
                                SizedBox(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      const Icon(
                                        Icons.info_outline_rounded,
                                        color: MyColor.textColorGrey2,
                                      ),
                                      Text.rich(
                                        TextSpan(
                                          children: [
                                            TextSpan(
                                              text: "  You are creating a ",
                                              // Example for first part of text (e.g., "BAY")
                                              style: GoogleFonts.roboto(
                                                textStyle: const TextStyle(
                                                  letterSpacing: 0.5,
                                                  fontSize: 15,
                                                  // Smaller size for "BAY"
                                                  color: MyColor.textColorGrey2,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),
                                            ),
                                            TextSpan(
                                              text: "CONSOLE ",
                                              // Example for last part of text (e.g., "AJ")
                                              style: GoogleFonts.roboto(
                                                textStyle: const TextStyle(
                                                  letterSpacing: 0.5,
                                                  fontSize: 15,
                                                  // Smaller size for "AJ"
                                                  color: MyColor.textColorGrey2,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                            TextSpan(
                                              text: "Shipment",
                                              // Example for last part of text (e.g., "AJ")
                                              style: GoogleFonts.roboto(
                                                textStyle: const TextStyle(
                                                  letterSpacing: 0.5,
                                                  fontSize: 15,
                                                  // Smaller size for "AJ"
                                                  color: MyColor.textColorGrey2,
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
                                SizedBox(
                                  height:
                                      MediaQuery.sizeOf(context).height * 0.02,
                                ),
                                 SizedBox(
                                        child: Column(
                                          children: [
                                            modeSelected == 0?
                                            Row(
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
                                                              "Gross Weight*",
                                                          readOnly: false,
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
                                            ): Row(
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
                                              "Gross Weight*",
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
                                              height: MediaQuery.sizeOf(context)
                                                      .height *
                                                  0.02,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              children: [
                                                SizedBox(
                                                  width:
                                                      MediaQuery.sizeOf(context)
                                                              .width *
                                                          0.44,
                                                  child:
                                                      CustomeEditTextWithBorder(
                                                    lablekey: 'MAWB',
                                                    hasIcon: false,
                                                    hastextcolor: true,
                                                    animatedLabel: true,
                                                    needOutlineBorder: true,
                                                    labelText: "Origin*",
                                                    readOnly: false,
                                                    maxLength: 15,
                                                    fontSize: 18,
                                                    onChanged:
                                                        (String, bool) {},
                                                  ),
                                                ),
                                                SizedBox(
                                                  width:
                                                      MediaQuery.sizeOf(context)
                                                              .width *
                                                          0.44,
                                                  child:
                                                      CustomeEditTextWithBorder(
                                                    lablekey: 'MAWB',
                                                    hasIcon: false,
                                                    hastextcolor: true,
                                                    animatedLabel: true,
                                                    needOutlineBorder: true,
                                                    labelText: "Destination*",
                                                    readOnly: false,
                                                    maxLength: 15,
                                                    fontSize: 18,
                                                    onChanged:
                                                        (String, bool) {},
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: MediaQuery.sizeOf(context)
                                                      .height *
                                                  0.02,
                                            ),
                                            Row(
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
                                                          labelText: "Code*",
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
                                                                    "Flight No*",
                                                                readOnly: false,
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
                                                              CustomeEditTextWithBorderDatePicker(
                                                                lablekey:
                                                                    'MAWB',
                                                                controller: flightDateController,

                                                                labelText:
                                                                    "Flight Date*",
                                                                readOnly: false,
                                                                maxLength: 15,
                                                                fontSize: 18,

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
                                                          labelText: "ULD*",
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
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: MediaQuery.sizeOf(context)
                                                      .height *
                                                  0.02,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              children: [
                                                SizedBox(
                                                  width:
                                                      MediaQuery.sizeOf(context)
                                                              .width *
                                                          0.44,
                                                  child:
                                                      CustomeEditTextWithBorder(
                                                    lablekey: 'MAWB',
                                                    hasIcon: false,
                                                    hastextcolor: true,
                                                    animatedLabel: true,
                                                    needOutlineBorder: true,
                                                    labelText: "Commodity Type",
                                                    readOnly: false,
                                                    maxLength: 15,
                                                    fontSize: 18,
                                                    onChanged:
                                                        (String, bool) {},
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
                                                          labelText:
                                                              "FIRMS Code",
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
                                                              "Disposition Code*",
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
                                        onPressed: () {},
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
                                          saveShipmentDetails();
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
        floatingActionButton: Theme(
          data: ThemeData(useMaterial3: false),
          child: FloatingActionButton(
            onPressed: () {},
            backgroundColor: MyColor.primaryColorblue,
            child: const Icon(Icons.add),
          ),
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
}
