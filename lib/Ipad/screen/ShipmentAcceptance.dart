import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:galaxy/Ipad/modal/ShipmentListingDetails.dart';
import 'package:vibration/vibration.dart';
import '../../core/images.dart';
import '../../core/mycolor.dart';
import '../../utils/commonutils.dart';
import '../../utils/snackbarutil.dart';
import '../../widget/customeedittext/customeedittextwithborder.dart';
import '../auth/auth.dart';
import '../widget/customIpadTextfield.dart';
import 'ImportCreateShipment.dart';
import 'ImportShipmentListing.dart';
import 'ShipmentAcceptanceManually.dart';

class ShipmentAcceptance extends StatefulWidget {
  const ShipmentAcceptance({super.key});

  @override
  State<ShipmentAcceptance> createState() => _ShipmentAcceptanceState();
}

class _ShipmentAcceptanceState extends State<ShipmentAcceptance> {
  @override
  void initState() {
    super.initState();
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
              padding: EdgeInsets.only(top: 20, left: 20, right: 20),
              color: MyColor.screenBgColor,
              child:  SingleChildScrollView(
                child: Column(
                  children: [
                    const Row(
                      children: [
                        Text(
                          'Shipment Acceptance',
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
                            vertical: 14, horizontal: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "SCAN THE SHIPMENT",
                              style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14),
                            ),
                            SizedBox(
                              height:
                              MediaQuery.sizeOf(context).height * 0.01,
                            ),
                            Container(
                              height: MediaQuery.sizeOf(context).height*0.6,
                              decoration: BoxDecoration(
                                color: Colors.grey[800],
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Center(
                                child: Icon(
                                  Icons.qr_code_scanner,
                                  size: 100,
                                  color: Colors.white54,
                                ),
                              ),
                            ),
                            SizedBox(height: 24),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  height: 45,
                                  width: MediaQuery.sizeOf(context).width ,
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
                                      // saveShipmentDetails();
                                    },
                                    child: const Text(
                                      "TAP TO SCAN BARCODE",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                const Text(
                                  "OR",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: Colors.grey),
                                ),
                                const SizedBox(height: 16),
                                SizedBox(
                                  height: 45,
                                  width: MediaQuery.sizeOf(context).width,
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
                                      Navigator.push(context, MaterialPageRoute(builder: (_)=>ShipmentAcceptanceManually()));
                                    },
                                    child: const Text("CAPTURE MANUALLY"),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.sizeOf(context).height * 0.015,
                    ),

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
                  size: Size(MediaQuery
                      .of(context)
                      .size
                      .width,
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
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (_) => CreateShipment()));
            },
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

  Future<void> scanQR(String lableModel) async {
    String barcodeScanResult =  await FlutterBarcodeScanner.scanBarcode(
      '#ff6666', // Color for the scanner overlay
      'Cancel', // Text for the cancel button
      true, // Enable flash option
      ScanMode.DEFAULT, // Scan mode
    );

    print("barcode scann ==== ${barcodeScanResult}");
    if(barcodeScanResult == "-1"){
    }else{
      // Truncate the result to a maximum of 12 characters

      //  String sanitizedResult = barcodeScanResult.replaceAll(RegExp(r'[^a-zA-Z0-9]'), '');

      bool specialCharAllow = CommonUtils.containsSpecialCharacters(barcodeScanResult);

      print("SPECIALCHAR_ALLOW ===== ${specialCharAllow}");


      if(specialCharAllow == true){
        SnackbarUtil.showSnackbar(context, "Only alphanumeric characters are accepted.", MyColor.colorRed, icon: FontAwesomeIcons.times);
        Vibration.vibrate(duration: 500);

        WidgetsBinding.instance.addPostFrameCallback((_) {
          // FocusScope.of(context).requestFocus(av7NoFocusNode);
        });
      }else{

        String result = barcodeScanResult.replaceAll(" ", "");

        String truncatedResult = result.length > 12
            ? result.substring(0, 12)
            : result;

      }

    }
  }

}
