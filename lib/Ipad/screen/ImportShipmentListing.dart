import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:galaxy/Ipad/modal/ShipmentListingDetails.dart';
import 'package:galaxy/Ipad/screen/warehouseoperations.dart';
import '../../core/images.dart';
import '../../core/mycolor.dart';
import '../../module/onboarding/sizeconfig.dart';
import '../../utils/dialogutils.dart';
import '../../utils/sizeutils.dart';
import '../../widget/customeedittext/customeedittextwithborder.dart';
import '../auth/auth.dart';
import '../utils/global.dart';
import '../widget/customDialog.dart';
import 'ImportCreateShipment.dart';
import 'ShipmentAcceptanceManually.dart';
import 'forwardForExamination.dart';

class ImportShipmentListing extends StatefulWidget {
  const ImportShipmentListing({super.key});

  @override
  State<ImportShipmentListing> createState() => _ImportShipmentListingState();
}

class _ImportShipmentListingState extends State<ImportShipmentListing> {
  List<String> selectedFilters = [];
  late List<ShipmentListDetails> shipmentListDetails=[];
  late List<ShipmentStatus> shipmentStatusList=[];
  late List<ShipmentListDetails> shipmentListDetailsToBind=[];
  final AuthService authService = AuthService();
  bool isLoading = false;
  bool hasNoRecord = false;


  @override
  void initState() {
    super.initState();
    getShipmentListing();
  }

  getShipmentListing({String mawbNo="",String statusFilter="" }) async {
    if (isLoading) return;
    shipmentListDetails = [];
    shipmentListDetailsToBind = [];
    shipmentStatusList=[];
    setState(() {
      isLoading = true;
    });

    var queryParams = {
      "PageNo": 1,
      "FilterClause": "1=1",
      "OrderByClause": "1",
      "MAWBNO": mawbNo,
      "StatusCode": statusFilter,
      "AirportCode": "JFK",
      "CompanyCode": 3,
      "CultureCode": "en-US",
      "UserId": userId,
      "MenuId": 1
    };
    await authService
        .postData(
      "ShipmentCreation/GetShipmentList",
      queryParams,
    )
        .then((response) {
      print("data received ");
      Map<String, dynamic> jsonData = json.decode(response.body);
      List<dynamic> resp = jsonData['ShipmentDetailList'];
      List<dynamic> statusData = jsonData['StatusList'];
      print(jsonData);
      if (jsonData.isEmpty) {
        setState(() {
          hasNoRecord = true;
        });
        return;
      }
      else{
        hasNoRecord=false;
      }
      print("is empty record$hasNoRecord");
      shipmentListDetailsToBind =
          resp.map((json) => ShipmentListDetails.fromJSON(json)).toList();
      print("length==  = ${shipmentListDetailsToBind.length}");
      setState(() {
        shipmentListDetails = shipmentListDetailsToBind;
        shipmentStatusList=statusData.map((json)=>ShipmentStatus.fromJson(json)).toList();
        print("length==  = ${shipmentListDetailsToBind.length}");
        // filteredList = listShipmentDetails;
        print("status length--  = ${shipmentStatusList.length}");
        isLoading = false;

      });
    }).catchError((onError) {
      setState(() {
        isLoading = false;
      });
      print(onError);
    });
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

  performBackToStorage(ShipmentListDetails data) async {
    var queryParams={
      "IMPSHIPROWID": data.impShipRowId.toString(),
      "UserID": 1,
      "CompanyCode": "3",
      "AirportCode": "JFK",
      "CultureCode": "en-US",
      "MenuId": 1
    };
    DialogUtils.showLoadingDialog(context);
    await authService
        .postData(
      "OnHandShipment/BackwardExamination",
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
            getShipmentListing(mawbNo:"",statusFilter: selectedFilters.join(","));
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

        body: Stack(
          children: [
            Container(
              constraints: const BoxConstraints.expand(),
              color: MyColor.screenBgColor,
              child: Column(
                children: [
                  const SizedBox(height: 10,),
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 10, left: 20, right: 20),
                    child: Material(
                      color: Colors.transparent,
                      // Ensures background transparency
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                           Row(
                            children: [
                              Container(
                                padding:const EdgeInsets.symmetric(horizontal: 8),
                                child: GestureDetector(
                                  child:  const Icon(Icons.arrow_back_ios,
                                      color: MyColor.primaryColorblue),
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                ),
                              ),
                              const Text(
                                'Shipments List',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 22),
                              ),
                            ],
                          ),
                          Row(
                            children: [
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
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 10,),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 5, left: 20, right: 20, bottom: 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration:  const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Color(0xffB3D8B4),
                                  ),
                                  child:const Text("D",style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),),
                                ),
                                const Text("  Direct Shipment",style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                ),),

                              ],
                            ),
                            SizedBox(width: 40,),
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration:  const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Color(0xffFFD6A2),
                                  ),
                                  child:const Text("C",style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),),
                                ),
                                const Text("  Consol Shipment",style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                ),),

                              ],
                            ),
                          ],
                        ),

                      ],
                    ),
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

                              ShipmentListDetails
                              shipmentDetails =
                              shipmentListDetails
                                  .elementAt(index);
                              return buildShipmentCardV3(
                                  shipmentDetails);
                            },
                            itemCount: shipmentListDetails.length,
                            shrinkWrap: true,
                            padding: const EdgeInsets.all(2),
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Expanded(
                  //     child: SingleChildScrollView(
                  //   child: Padding(
                  //     padding: const EdgeInsets.only(
                  //         top: 5,  bottom: 40),
                  //     child: SizedBox(
                  //       width: MediaQuery.of(context).size.width / 1.01,
                  //       child: ListView.builder(
                  //         physics:
                  //         const NeverScrollableScrollPhysics(),
                  //         shrinkWrap: true,
                  //         padding: const EdgeInsets.all(2),
                  //         itemCount: shipmentDetailsListOld.length,
                  //         itemBuilder: (context, index) {
                  //           final shipment = shipmentDetailsListOld[index];
                  //           return buildShipmentCard(shipment);
                  //         },
                  //       ),
                  //     ),
                  //   ),
                  // ))
                ],
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
              Navigator.push(context, MaterialPageRoute(builder: (_)=>CreateShipment()));
            },
            backgroundColor: MyColor.primaryColorblue,
            child: const Icon(Icons.add),
          ),
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
        //         onTap: () {
        //           Navigator.pushReplacement(context,
        //               MaterialPageRoute(builder: (context) => const WarehouseOperations()));
        //         },
        //         child: const Column(
        //           mainAxisAlignment: MainAxisAlignment.center,
        //           children: [
        //             Icon(CupertinoIcons.chart_pie,
        //               ),
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
        //
        //             ),
        //             Text(
        //               "User Help",
        //
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

  Widget buildShipmentCard(ShipmentListDetails shipment) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  shipment.documentNo,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 8),
                buildLabel("AWB", Colors.deepPurpleAccent,8,isBorder: true,borderColor: Colors.deepPurpleAccent),
                const SizedBox(width: 8),
                buildLabel(shipment.houseNo==""?"DIRECT":"CONSOLE", Colors.white,8,isBorder: true,borderColor: Colors.grey),
                const SizedBox(width: 16),
                buildLabel(shipment.shipmentStatus, Colors.lightBlue,20),
                const SizedBox(width: 8),
                Row(
                  children: [
                    Text(
                      shipment.shipStatusDateTime,
                      style: const TextStyle(color: Colors.black,fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(width: 8),
                    const Icon(
                      Icons.info_outline_rounded,
                      color: MyColor.primaryColorblue,
                    ),
                  ],
                ),
                const Spacer(),
                Container(
                  height: 30,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xFF0057D8),
                        Color(0xFF1c86ff),
                      ],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                  ),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent),
                    onPressed: null,
                    child: const Text(
                      'Accept Shipment',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),


              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Text("MAWB No: "),
                    Text("MAWB1",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
                  ],
                ),
                const SizedBox(width: 12),
                Row(
                  children: [
                    const Text("Declared PCS: "),
                    Text("${shipment.awbPieces}",style: const TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
                  ],
                ),
                const SizedBox(width: 12),
                Row(
                  children: [
                    const Text("Declared Weight: "),
                    Text("${shipment.awbWeight}",style: const TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
                  ],
                ),
                const SizedBox(width: 12),
                Row(
                  children: [
                    const Text("Unit: "),
                    Text(shipment.weightUnit,style: const TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
                  ],
                ),
                const SizedBox(width: 12),
                Row(
                  children: [
                    const Text("Accepted Pcs: "),
                    Text(
                      "${shipment.acceptedPieces}",style: const TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
                  ],
                ),
                const SizedBox(width: 12),
                Row(
                  children: [
                    const Text("Accepted Wt: "),
                    Text(
                      "${shipment.acceptedWeight}",style: const TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
                  ],
                ),
                const SizedBox(width: 12),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildShipmentCardV2(ShipmentListDetails shipment) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  shipment.documentNo,
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 8),
                buildLabel("AWB", Colors.deepPurpleAccent,8,isBorder: true,borderColor: Colors.deepPurpleAccent),
                const SizedBox(width: 8),
                SizedBox(
                    width: MediaQuery.sizeOf(context).width*0.11,
                    child: buildLabel((shipment.houseNo.isEmpty)?"DIRECT":"CONSOL", Colors.white,8,isBorder: true,borderColor: Colors.grey)),
                const SizedBox(width: 20),
                buildLabel(shipment.shipmentStatus.toUpperCase(), Colors.lightBlue,20),
                const SizedBox(width: 8),
                Row(
                  children: [
                    Text(
                      shipment.shipStatusDateTime,
                      style: const TextStyle(color: Colors.black,fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(width: 8),
                    const Icon(
                      Icons.info_outline_rounded,
                      color: MyColor.primaryColorblue,
                    ),
                  ],
                ),

              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Container(

                  width: MediaQuery.sizeOf(context).width*0.6,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                           Row(
                            children: [
                              Text("HAWB No: "),
                              Text((shipment.houseNo.isEmpty)?" - ":shipment.houseNo,style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Text("Unit: "),
                              Text(shipment.weightUnit.toUpperCase(),style: const TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(width: 32),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Text("Declared Pcs: "),
                              Text("${shipment.awbPieces}",style: const TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Text("Accepted Pcs: "),
                              Text(
                                "${shipment.acceptedPieces}",style: const TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(width: 32),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Text("Declared Wt: "),
                              Text("${shipment.awbWeight.toStringAsFixed(2)}",style: const TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Text("Accepted Wt: "),
                              Text(
                                "${shipment.acceptedWeight.toStringAsFixed(2)}",style: const TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
                            ],
                          ),
                        ],
                      ),

                    ],
                  ),
                ),
                const SizedBox(width: 2),
                // Column(
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   children: [
                //     Row(
                //       mainAxisAlignment: MainAxisAlignment.spaceAround,
                //       children: [
                //         GestureDetector(
                //           child: Container(
                //             height: 30,
                //             margin: const EdgeInsets.only(right: 12),
                //             decoration: BoxDecoration(
                //               borderRadius: BorderRadius.circular(8),
                //               gradient: const LinearGradient(
                //                 colors: [
                //                   Color(0xFF0057D8),
                //                   Color(0xFF1c86ff),
                //                 ],
                //                 begin: Alignment.centerLeft,
                //                 end: Alignment.centerRight,
                //               ),
                //             ),
                //             child: ElevatedButton(
                //               style: ElevatedButton.styleFrom(
                //                   backgroundColor: Colors.transparent,
                //                   shadowColor: Colors.transparent),
                //               onPressed: null,
                //               child: const Text(
                //                 'Accepted Shipment',
                //                 style: TextStyle(color: Colors.white),
                //               ),
                //             ),
                //           ),
                //           onTap: (){
                //             Navigator.push(context, MaterialPageRoute(builder: (_)=>ShipmentAcceptanceManually(shipmentListDetails:shipment ,)));
                //           },
                //         ),
                //         const Icon(
                //           Icons.more_vert_outlined,
                //           color: MyColor.primaryColorblue,
                //         ),
                //         Container(
                //           margin: const EdgeInsets.only(left: 12),
                //           decoration: BoxDecoration(
                //             borderRadius: BorderRadius.circular(5),
                //             color:Color(0xffF2F7FD),
                //           ),
                //           child: const Icon(
                //             size: 28,
                //             Icons.keyboard_arrow_right_outlined,
                //             color: MyColor.primaryColorblue,
                //           ),
                //         )
                //       ],)
                //   ],
                // )
              ],
            ),
          ],
        ),
      ),
    );
  }
  Widget buildShipmentCardV3(ShipmentListDetails shipment) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration:  BoxDecoration(
                shape: BoxShape.circle,
                color:shipment.houseNo.isEmpty? const Color(0xffB3D8B4):const Color(0xffFFD6A2),
              ),
              child:Text(shipment.houseNo.isEmpty?"D":"C",style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),),
            ),
            const SizedBox(width: 14,),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    SizedBox(
                      width: MediaQuery.sizeOf(context).width*0.20,

                      child: Text(
                        shipment.documentNo,
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(width: 8),
                    buildLabel("AWB", Colors.deepPurpleAccent,8,isBorder: true,borderColor: Colors.deepPurpleAccent),
                    // const SizedBox(width: 8),
                    // SizedBox(
                    //     width: MediaQuery.sizeOf(context).width*0.11,
                    //     child: buildLabel((shipment.houseNo.isEmpty)?"DIRECT":"CONSOL", Colors.white,8,isBorder: true,borderColor: Colors.grey)),
                    const SizedBox(width: 20),
                    buildLabel(shipment.shipmentStatus.toUpperCase(), Colors.lightBlue,20),
                    const SizedBox(width: 8),
                    Row(
                      children: [
                        Text(
                          shipment.shipStatusDateTime,
                          style: const TextStyle(color: Colors.black,fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(width: 8),
                        const Tooltip(
                          message: "Date & Time of the Status",
                          triggerMode: TooltipTriggerMode.tap,
                          child: Icon(
                            Icons.info_outline_rounded,
                            color: MyColor.primaryColorblue,
                          ),
                        ),
                      ],
                    ),

                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Container(

                      width: MediaQuery.sizeOf(context).width*0.8,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: MediaQuery.sizeOf(context).width*0.18,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                 Row(
                                  children: [
                                    Text("HAWB No: "),
                                    Text((shipment.houseNo.isEmpty)?" - ":shipment.houseNo,style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    const Text("Unit: "),
                                    Text(shipment.weightUnit.toUpperCase(),style: const TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          SizedBox(
                            width: MediaQuery.sizeOf(context).width*0.18,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    const Text("Declared Pcs: "),
                                    Text("${shipment.awbPieces}",style: const TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    const Text("Accepted Pcs: "),
                                    Text(
                                      "${shipment.acceptedPieces}",style: const TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          SizedBox(
                            width: MediaQuery.sizeOf(context).width*0.22,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    const Text("Declared Wt: "),
                                    Text("${shipment.awbWeight.toStringAsFixed(2)}",style: const TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    const Text("Accepted Wt: "),
                                    Text(
                                      "${shipment.acceptedWeight.toStringAsFixed(2)}",style: const TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          (Utils.getStatusAction(shipment.shipmentStatus.toUpperCase())!="")?SizedBox(
                            width: MediaQuery.sizeOf(context).width*0.22,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    GestureDetector(
                                      child: Container(
                                        height: 30,

                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(8),
                                          gradient: const LinearGradient(
                                            colors: [
                                              Color(0xFF0057D8),
                                              Color(0xFF1c86ff),
                                            ],
                                            begin: Alignment.centerLeft,
                                            end: Alignment.centerRight,
                                          ),
                                        ),
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.transparent,
                                              shadowColor: Colors.transparent),
                                          onPressed: null,
                                          child:  Text(
                                            '${Utils.getStatusAction(shipment.shipmentStatus.toUpperCase())}',
                                            style: TextStyle(color: Colors.white),
                                          ),
                                        ),
                                      ),
                                      onTap: (){
                                       // Navigator.push(context, MaterialPageRoute(builder: (_)=>ShipmentAcceptanceManually(shipmentListDetails:shipment)));
                                        switch (Utils.getStatusAction(shipment.shipmentStatus.toUpperCase())) {
                                          case 'Accept Shipment':
                                            Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(builder: (_) => ShipmentAcceptanceManually(shipmentListDetails: shipment,isNavFromList: true,)),
                                            );
                                            break;
                                          case 'Forward For Exam.':
                                            Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(builder: (_) => ForwardForExamination(shipmentListDetails: shipment)), // Assuming this is your Forward Exam page
                                            );
                                            break;
                                          case 'Back To Storage':
                                            performBackToStorage(shipment);
                                            break;
                                          default:
                                          // Handle other actions or show a default message
                                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                              content: Text('Action for the shipment is not implemented yet.'),
                                            ));
                                        }
                                      },
                                    ),
                                    // const Icon(
                                    //   Icons.more_vert_outlined,
                                    //   color: MyColor.primaryColorblue,
                                    // ),
                                    // Container(
                                    //   margin: const EdgeInsets.only(left: 12),
                                    //   decoration: BoxDecoration(
                                    //     borderRadius: BorderRadius.circular(5),
                                    //     color:Color(0xffF2F7FD),
                                    //   ),
                                    //   child: const Icon(
                                    //     size: 28,
                                    //     Icons.keyboard_arrow_right_outlined,
                                    //     color: MyColor.primaryColorblue,
                                    //   ),
                                    // )
                                  ],)
                              ],
                            ),
                          ):SizedBox(),

                        ],
                      ),
                    ),


                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void showShipmentSearchBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      constraints: BoxConstraints(
        minWidth: double.infinity,
      ),
      isScrollControlled: true,
      builder: (BuildContext context) {
        TextEditingController prefixController = TextEditingController();
        TextEditingController awbController = TextEditingController();

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
                                  selectedFilters.clear();
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
                        const Divider(color: Colors.grey),
                        const SizedBox(height: 8),
                        const Text('SORT BY STATUS',
                            style: TextStyle(fontSize: 16)),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: Wrap(
                            spacing: 8.0,
                            children: shipmentStatusList.map((status) {
                              bool isSelected = selectedFilters.contains(status.keyValue);

                              return FilterChip(
                                label: Text(
                                  status.description,
                                  style: const TextStyle(color: MyColor.primaryColorblue),
                                ),
                                selected: isSelected,
                                showCheckmark: false,
                                onSelected: (bool selected) {
                                  setState(() {
                                    if (selected) {
                                      selectedFilters.add(status.keyValue);
                                    } else {
                                      selectedFilters.remove(status.keyValue);
                                    }
                                  });
                                },
                                selectedColor: MyColor.dropdownColor,
                                backgroundColor: MyColor.dropdownColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                  side: BorderSide(
                                    color: isSelected ? MyColor.primaryColorblue : Colors.transparent,
                                  ),
                                ),
                                checkmarkColor: MyColor.primaryColorblue,
                              );
                            }).toList(),
                          ),
                        ),
                        const SizedBox(height: 8),

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
                                  selectedFilters.clear();
                                  awbController.clear();
                                  prefixController.clear();
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
                                  if(awbController.text.isNotEmpty){
                                    if(prefixController.text.length!=3)return;
                                    if(awbController.text.length!=8)return;
                                  }
                                  getShipmentListing(mawbNo:"${prefixController.text.trim()}${awbController.text.trim()}",statusFilter: selectedFilters.join(","));
                                  Navigator.pop(context);
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
  void showShipmentSearchBottomSheetV2(BuildContext context) {
    showModalBottomSheet(
      context: context,
      constraints: BoxConstraints(
       minWidth: double.infinity,
      ),
      isScrollControlled: true,
      backgroundColor: Colors.transparent, // Make background transparent to remove default padding
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Wrap(
              children: [
                Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(16.0),
                      topRight: Radius.circular(16.0),
                    ),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Filter",
                            style: TextStyle(
                                fontSize: 24, fontWeight: FontWeight.bold)),
                        const Divider(color: Colors.grey),
                        const SizedBox(height: 16),
                        const Text('SORT BY STATUS',
                            style: TextStyle(fontSize: 16)),
                        const SizedBox(height: 16),
                        Wrap(
                          spacing: 8.0,
                          children: [
                            FilterChip(
                              label: const Text(
                                'Draft',
                                style: TextStyle(color: MyColor.primaryColorblue),
                              ),
                              selected: true,
                              showCheckmark: false,
                              onSelected: (bool selected) {
                                setState(() {
                                  // Add your logic here for the chip selection.
                                });
                              },
                              selectedColor: MyColor.primaryColorblue.withOpacity(0.1),
                              backgroundColor: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0),
                                side: BorderSide(
                                  color: true
                                      ? MyColor.primaryColorblue
                                      : Colors.transparent,
                                ),
                              ),
                              checkmarkColor: MyColor.primaryColorblue,
                            ),
                            // Add more FilterChips here as needed.
                          ],
                        ),
                        const SizedBox(height: 8),
                        Divider(color: Colors.grey),
                        const SizedBox(height: 4),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'FILTER BY DATE',
                              style: TextStyle(fontSize: 16),
                            ),
                            const SizedBox(height: 16),
                            GestureDetector(
                              child: Row(
                                children: [
                                  const Icon(Icons.calendar_today,
                                      color: MyColor.primaryColorblue),
                                  const SizedBox(width: 8),
                                  Text(
                                    "slotFilterDate",
                                    style: const TextStyle(
                                        fontSize: 16, color: MyColor.primaryColorblue),
                                  ),
                                ],
                              ),
                              onTap: () {
                                // pickDate(context, setState);
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Divider(color: Colors.grey),
                        const SizedBox(height: 8),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                            setState(() {
                              // isFilterApplied = true;
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: MyColor.primaryColorblue,
                            minimumSize: const Size.fromHeight(50),
                          ),
                          child: const Text("SEARCH",
                              style: TextStyle(color: Colors.white)),
                        ),
                        const SizedBox(height: 16),
                        OutlinedButton(
                          onPressed: () {
                            setState(() {
                              // Reset filter logic here.
                            });
                            Navigator.pop(context);
                          },
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: MyColor.primaryColorblue),
                            minimumSize: const Size.fromHeight(50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text(
                            "RESET",
                            style: TextStyle(color: MyColor.primaryColorblue),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget buildLabel(
      String text, Color color, double radius,
      {bool isBorder = false, Color borderColor = Colors.black, double borderWidth = 1.0}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
      decoration: BoxDecoration(
        color:isBorder ? color.withOpacity(0.2):Utils.getStatusColor(text),
        borderRadius: BorderRadius.circular(radius),
        border: isBorder ? Border.all(color: borderColor, width: borderWidth) : null,
      ),
      child: Center(
        child: Text(
          text=="EXAMINATION MARKED COMPLETED"?"EXAM. MARKED COMPLETED":text,
          style: const TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  void backToStorage() {}

}


class AppBarPainterGradient extends CustomPainter {
  @override
  bool shouldRepaint(AppBarPainterGradient oldDelegate) => false;

  @override
  void paint(Canvas canvas, Size size) {
    final Rect rect = Rect.fromLTWH(0.0, 0.0, size.width, size.height);
    const Gradient gradient = LinearGradient(
      colors: [
        Color(0xff0060e6),
        Color(0xFF1c86ff),
      ],
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
    );

    Paint paint_1 = Paint()
      ..shader = gradient.createShader(rect)
      ..style = PaintingStyle.fill;

    Path path_1 = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width * 0.08, 0.0)
      ..cubicTo(
        size.width * 0.04,
        0.0,
        0.0,
        0.00001 * (size.width),
        0.0,
        0.05 * size.width,
      );

    Path path_2 = Path()
      ..moveTo(size.width, 0)
      ..lineTo(size.width * 0.92, 0.0)
      ..cubicTo(
        size.width * 0.96,
        0.0,
        size.width,
        0.00001 * size.width,
        size.width,
        0.05 * size.width,
      );

    canvas.drawPath(path_1, paint_1);
    canvas.drawPath(path_2, paint_1);
    // canvas.drawPath(path_3, paint_2);
  }
}
