import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:galaxy/Ipad/modal/ShipmentListingDetails.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vibration/vibration.dart';
import '../../core/images.dart';
import '../../core/mycolor.dart';
import '../../module/import/model/flightcheck/damagedetailmodel.dart';
import '../../utils/commonutils.dart';
import '../../utils/snackbarutil.dart';
import '../../widget/customeedittext/customeedittextwithborder.dart';
import '../auth/auth.dart';
import '../widget/customIpadTextfield.dart';
import 'ImportCreateShipment.dart';
import 'ImportShipmentListing.dart';

class CaptureDamageandAccept extends StatefulWidget {
  const CaptureDamageandAccept({super.key});

  @override
  State<CaptureDamageandAccept> createState() => _CaptureDamageandAcceptState();
}

class _CaptureDamageandAcceptState extends State<CaptureDamageandAccept> {
  @override
  void initState() {
    super.initState();
    getDamageDetails();
  }
  final AuthService authService = AuthService();
  Map<String, bool> damageTypes = {
    'Bands Loose': false,
    'Broken': false,
    'Crushed': false,
    'Others': false,
    'Tape Torn': false,
    'Wet': false,
    'Containers': false,
  };

  bool showMore = false;
  bool isLoading = false;
  bool hasNoRecord = false;
  late List<ReferenceData14BList> referenceData14BList;
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                GestureDetector(
                                  child:  const Icon(Icons.arrow_back_ios,
                                      color: MyColor.primaryColorblue),
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                ),
                                const SizedBox(
                                  width: 4,
                                ),
                                const Text(
                                  'Capture Damage & Accept',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 22,
                                  ),
                                ),
                              ],
                            ),
                            GestureDetector(
                              child: const Row(
                                children: [Icon(Icons.restart_alt_outlined, color: Colors.grey,),
                                  Text(
                                    'Reset',
                                    style: TextStyle(
                                        fontWeight: FontWeight.normal, fontSize: 18),
                                  ),],
                              ),
                              onTap: (){

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
                                  height: MediaQuery.sizeOf(context).height*0.59,
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          SizedBox(
                                            width: MediaQuery.sizeOf(context)
                                                    .width*0.9,
                                            child: Row(
                                              children: [
                                                const Text(
                                                  'Unserviceable Shipment (12345654)',
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                Spacer(),
                                                Theme(
                                                  data: ThemeData(useMaterial3: false),
                                                  child: Switch(
                                                    onChanged: (value) async{

                                                      setState(()  {

                                                      });
                                                    },
                                                    value: true,
                                                    activeColor: MyColor.primaryColorblue,
                                                    activeTrackColor: MyColor.bgColorGrey,
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
                                                0.01,
                                      ),
                                      const Row(
                                        children: [
                                          Text("  DAMAGE TYPE",style: TextStyle(color: Colors.black,fontWeight: FontWeight.w800,fontSize: 16),),
                                        ],
                                      ),
                                      isLoading
                                          ? const Center(
                                          child: SizedBox(
                                              height: 100,
                                              width: 100,
                                              child: CircularProgressIndicator()))
                                          : Expanded(
                                        child: SingleChildScrollView(
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                top: 8.0, left: 0.0, bottom: 100),
                                            child: SizedBox(
                                              width: MediaQuery.of(context).size.width / 1.01,
                                              child: (hasNoRecord)
                                                  ? Container(
                                                height: 400,
                                                child: const Center(
                                                  child: Text("NO RECORD FOUND"),
                                                ),
                                              )
                                                  :  ListView.builder(
                                                physics:
                                                const NeverScrollableScrollPhysics(),
                                                itemBuilder: (BuildContext, index) {
                                                  final item = referenceData14BList[index];
                                                  bool isSelected = item.isSelected == 'Y';

                                                  return Container(
                                                    decoration: const BoxDecoration(
                                                      border: Border(
                                                        bottom: BorderSide(
                                                          color: Color(0XFFE4E7EB),
                                                          width: 1.5,
                                                        ),
                                                      ),
                                                    ),
                                                    width: MediaQuery.of(context).size.width * 0.9,
                                                    child: Row(
                                                      children: [
                                                        Text(
                                                          item.referenceDescription!,
                                                          style: const TextStyle(
                                                            fontSize: 14,
                                                            fontWeight: FontWeight.w600,
                                                          ),
                                                        ),
                                                        const Spacer(),
                                                        Theme(
                                                          data: ThemeData(useMaterial3: false),
                                                          child: Switch(
                                                            onChanged: (value) {
                                                              setState(() {
                                                                referenceData14BList[index].isSelected = value ? 'Y' : 'N';
                                                              });
                                                            },
                                                            value: isSelected,
                                                            activeColor: MyColor.primaryColorblue,
                                                            activeTrackColor: Colors.grey,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                },
                                                itemCount: referenceData14BList.length,
                                                shrinkWrap: true,
                                                padding: const EdgeInsets.all(2),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),




                                      // Column(
                                      //   children: [
                                      //     Expanded(
                                      //       child:SingleChildScrollView(
                                      //         child:  ListView.builder(
                                      //           physics:
                                      //           const NeverScrollableScrollPhysics(),
                                      //           shrinkWrap: true,
                                      //           itemCount: damageTypes.length,
                                      //           itemBuilder: (context, index) {
                                      //             if (index >= damageTypes.length) {
                                      //
                                      //               return SwitchListTile(
                                      //                 title: Text('Additional Damage Type ${index - damageTypes.length + 1}'),
                                      //                 value: false,
                                      //                 onChanged: (value) {
                                      //                   // Handle switch change for additional items
                                      //                 },
                                      //               );
                                      //             } else {
                                      //               String key = damageTypes.keys.elementAt(index);
                                      //               return SwitchListTile(
                                      //                 title: Text(key),
                                      //                 value: damageTypes[key]!,
                                      //                 onChanged: (value) {
                                      //                   setState(() {
                                      //                     damageTypes[key] = value;
                                      //                   });
                                      //                 },
                                      //               );
                                      //             }
                                      //           },
                                      //         ),
                                      //       ),
                                      //     ),
                                      //   ],
                                      // ),


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
                                vertical: 18, horizontal: 18),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomeEditTextWithBorder(
                                  lablekey: 'MAWB',
                                  hasIcon: false,
                                  hastextcolor: true,
                                  animatedLabel: true,
                                  needOutlineBorder:
                                  true,
                                  labelText: "Remarks*",
                                  readOnly: false,
                                  maxLength: 3,
                                  maxLines: 4,
                                  textInputType:
                                  TextInputType
                                      .number,
                                  fontSize: 18,
                                  onChanged:
                                      (String, bool) {},
                                ),
                                SizedBox(height: 10,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        GestureDetector(
                                          child:  const Icon(Icons.camera_alt_outlined,
                                              color: MyColor.primaryColorblue),
                                          onTap: () {
                                            Navigator.pop(context);
                                          },
                                        ),
                                        const SizedBox(
                                          width: 8,
                                        ),
                                        const Text(
                                          'Take Photo',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w700,
                                            color: MyColor.primaryColorblue,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const Text(
                                      'Photo Uploaded',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        color: MyColor.primaryColorblue,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
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
                                        child: const Text(
                                            "Cancel"),
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

  getDamageDetails()async {
    if (isLoading) return;

    setState(() {
      isLoading = true;
    });

    var queryParams = {
      "FlightSeqNo": 11169,
      "AWBId": "5323",
      "SHIPId": "5506",
      "AirportCode": "BLR",
      "CompanyCode": 3,
      "CultureCode": "en-US",
      "UserId": 1,
      "MenuId": 1
    };
    await authService
        .postData(
      "FlightCheckIn/GetDamageDetails",
      queryParams,
    )
        .then((response) {
      print("data received ");
      Map<String, dynamic> jsonData = json.decode(response.body);
      List<dynamic> resp = jsonData['ReferenceData14BList'];
      print(jsonData);
      if (jsonData.isEmpty) {
        setState(() {
          hasNoRecord = true;
        });
      }
      else{
        hasNoRecord=false;
      }
      print("is empty record $hasNoRecord");
      setState(() {
        referenceData14BList =
            resp.map((json) => ReferenceData14BList.fromJson(json)).toList();
        // filteredList = listShipmentDetails;
        print("length--  = ${referenceData14BList.length}");
        isLoading = false;

      });
    }).catchError((onError) {
      setState(() {
        isLoading = false;
      });
      print(onError);
    });
  }
}
