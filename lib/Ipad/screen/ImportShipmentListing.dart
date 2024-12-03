import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:galaxy/Ipad/modal/ShipmentListingDetails.dart';
import 'package:galaxy/Ipad/screen/warehouseoperations.dart';
import '../../core/images.dart';
import '../../core/mycolor.dart';
import '../../module/onboarding/sizeconfig.dart';
import '../../utils/sizeutils.dart';
import '../../widget/customeedittext/customeedittextwithborder.dart';
import '../auth/auth.dart';
import 'ImportCreateShipment.dart';
import 'ShipmentAcceptanceManually.dart';

class ImportShipmentListing extends StatefulWidget {
  const ImportShipmentListing({super.key});

  @override
  State<ImportShipmentListing> createState() => _ImportShipmentListingState();
}

class _ImportShipmentListingState extends State<ImportShipmentListing> {
  final List<ShipmentDetails> shipmentDetailsListOld = [
    ShipmentDetails(
        awbNumber: "125-76676867",
        mawbNumber: "MAWB01",
        date: "16 SEP 2024 12:23",
        declaredPcs: 12,
        declaredWeight: 60.0,
        unit: "Kg",
        acceptedPcs: 24,
        acceptedWeight: 17,
        awb: "AWB",
        shipmentType: "CONSOLE",
        status: "CREATED"),
    ShipmentDetails(
        awbNumber: "125-76676867",
        mawbNumber: "MAWB02",
        date: "17 SEP 2024 12:23",
        declaredPcs: 12,
        declaredWeight: 60.0,
        unit: "Kg",
        acceptedPcs: 24,
        acceptedWeight: 17,
        awb: "AWB",
        shipmentType: "DIRECT",
        status: "PENDING"),
  ];
  late List<ShipmentListDetails> shipmentListDetails=[];
  late List<ShipmentListDetails> shipmentListDetailsToBind=[];
  final AuthService authService = AuthService();
  bool isLoading = false;
  bool hasNoRecord = false;


  @override
  void initState() {
    super.initState();
    getShipmentListing();
  }

  getShipmentListing() async {
    if (isLoading) return;
    shipmentListDetails = [];
    shipmentListDetailsToBind = [];
    setState(() {
      isLoading = true;
    });

    var queryParams = {
      "PageNo": 1,
      "FilterClause": "1=1",
      "OrderByClause": "1",
      "AirportCode": "JFK",
      "CompanyCode": 3,
      "CultureCode": "en-US",
      "UserId": 1,
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
      shipmentListDetailsToBind =
          resp.map((json) => ShipmentListDetails.fromJSON(json)).toList();
      print("length==  = ${shipmentListDetailsToBind.length}");
      setState(() {
        shipmentListDetails = shipmentListDetailsToBind;
        // filteredList = listShipmentDetails;
        print("length--  = ${shipmentListDetails.length}");
        isLoading = false;

      });
    }).catchError((onError) {
      setState(() {
        isLoading = false;
      });
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
                const Text(
                  '  Warehouse Operations',
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
                              GestureDetector(
                                child:  const Icon(Icons.arrow_back_ios,
                                    color: MyColor.primaryColorblue),
                                onTap: () {
                                  Navigator.pop(context);
                                },
                              ),
                              const Text(
                                '  SHIPMENTS LIST',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 22),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              // IconButton(
                              //   icon: const Icon(
                              //     Icons.search,
                              //     color: MyColor.primaryColorblue,
                              //   ),
                              //   onPressed: () {
                              //     print("Search button pressed");
                              //     // showShipmentSearchDialog(context);
                              //   },
                              // ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 10,),
                  // Padding(
                  //   padding: const EdgeInsets.only(
                  //       top: 5, left: 20, right: 20, bottom: 10),
                  //   child: Row(
                  //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //     children: [
                  //       const Text(
                  //         'Showing (0/0)',
                  //         style: TextStyle(
                  //             fontWeight: FontWeight.bold, fontSize: 18),
                  //       ),
                  //       Row(
                  //         children: [
                  //           GestureDetector(
                  //             child: const Row(
                  //               children: [
                  //                 Icon(
                  //                   Icons.filter_alt_outlined,
                  //                   color: MyColor.primaryColorblue,
                  //                 ),
                  //                 Text(
                  //                   ' Filter',
                  //                   style: TextStyle(fontSize: 18),
                  //                 )
                  //               ],
                  //             ),
                  //             onTap: () {
                  //               showShipmentSearchBottomSheet(context);
                  //             },
                  //           ),
                  //         ],
                  //       )
                  //     ],
                  //   ),
                  // ),
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
                              return buildShipmentCardV2(
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
                    child: buildLabel(shipment.houseNo==""?"DIRECT":"CONSOL", Colors.white,8,isBorder: true,borderColor: Colors.grey)),
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
                              Text(shipment.houseNo==""?" - ":shipment.houseNo,style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Text("Unit: "),
                              Text(shipment.weightUnit,style: const TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
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
                              const Text("Declared PCS: "),
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
                              const Text("Declared Weight: "),
                              Text("${shipment.awbWeight}",style: const TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Text("Accepted Wt: "),
                              Text(
                                "${shipment.acceptedWeight}",style: const TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
                            ],
                          ),
                        ],
                      ),

                    ],
                  ),
                ),
                const SizedBox(width: 2),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        GestureDetector(
                          child: Container(
                            height: 30,
                            margin: const EdgeInsets.only(right: 12),
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
                                'Accepted Shipment',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: (_)=>ShipmentAcceptanceManually(shipmentListDetails:shipment ,)));
                          },
                        ),
                        const Icon(
                          Icons.more_vert_outlined,
                          color: MyColor.primaryColorblue,
                        ),
                        Container(
                          margin: const EdgeInsets.only(left: 12),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color:Color(0xffF2F7FD),
                          ),
                          child: const Icon(
                            size: 28,
                            Icons.keyboard_arrow_right_outlined,
                            color: MyColor.primaryColorblue,
                          ),
                        )
                      ],)
                  ],
                )
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
        // List<String> selectedFilters = [];

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
                        const Text("Filter",
                            style: TextStyle(
                                fontSize: 24, fontWeight: FontWeight.bold)),

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
                                        child:
                                        CustomeEditTextWithBorder(
                                          lablekey: 'MAWB',
                                          hasIcon: false,
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
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'FILTER BY DATE',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  const SizedBox(height: 16),
                                  GestureDetector(
                                    child: const Row(
                                      children: [
                                        Icon(Icons.calendar_today,
                                            color: MyColor.primaryColorblue),
                                        SizedBox(width: 8),
                                        Text(
                                          "slotFilterDate",
                                          style: TextStyle(
                                              fontSize: 16, color: MyColor.primaryColorblue),
                                        ),
                                      ],
                                    ),
                                    onTap: () {
                                      // pickDate(context, setState);
                                    },
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
                            children: [
                              FilterChip(
                                label: const Text(
                                  'Draft',
                                  style: TextStyle(color: MyColor.primaryColorblue),
                                ),
                                selected: true,
                                // selectedFilters.contains('DRAFT'),
                                showCheckmark: false,
                                onSelected: (bool selected) {
                                  setState(() {
                                    // selected
                                    //     ? selectedFilters.add('DRAFT')
                                    //     : selectedFilters.remove('DRAFT');
                                  });
                                },
                                selectedColor: MyColor.primaryColorblue.withOpacity(0.1),
                                backgroundColor: Colors.transparent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                  side: BorderSide(
                                    color:true // selectedFilters.contains('DRAFT')
                                        ? MyColor.primaryColorblue
                                        : Colors.transparent,
                                  ),
                                ),
                                checkmarkColor: MyColor.primaryColorblue,
                              ),
                              FilterChip(
                                label: const Text(
                                  'Gated-in',
                                  style: TextStyle(color: MyColor.primaryColorblue),
                                ),
                                selected: false,//selectedFilters.contains('GATED-IN'),
                                showCheckmark: false,
                                onSelected: (bool selected) {
                                  setState(() {
                                    // selected
                                    //     ? selectedFilters.add('GATED-IN')
                                    //     : selectedFilters.remove('GATED-IN');
                                  });
                                },
                                selectedColor: MyColor.primaryColorblue.withOpacity(0.1),
                                backgroundColor: Colors.transparent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                  side: BorderSide(
                                    color:false //selectedFilters.contains('GATED-IN')
                                        ?MyColor.primaryColorblue
                                        : Colors.transparent,
                                  ),
                                ),
                              ),
                              FilterChip(
                                label: const Text(
                                  'Gate-in Pending',
                                  style: TextStyle(color: MyColor.primaryColorblue),
                                ),
                                selected:true,
                                //selectedFilters.contains('PENDING FOR GATE-IN'),
                                showCheckmark: false,
                                onSelected: (bool selected) {
                                  setState(() {
                                    // selected
                                    //     ? selectedFilters.add('PENDING FOR GATE-IN')
                                    //     : selectedFilters.remove('PENDING FOR GATE-IN');
                                  });
                                },
                                selectedColor: MyColor.primaryColorblue.withOpacity(0.1),
                                backgroundColor: Colors.transparent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                  side: BorderSide(
                                    color:false
                                    //selectedFilters.contains('PENDING FOR GATE-IN')
                                        ? MyColor.primaryColorblue
                                        : Colors.transparent,
                                  ),
                                ),
                              ),
                              FilterChip(
                                label: const Text(
                                  'Gate-in Rejected',
                                  style: TextStyle(color: MyColor.primaryColorblue),
                                ),
                                selected:false,
                                //selectedFilters.contains('REJECT FOR GATE-IN'),
                                showCheckmark: false,
                                onSelected: (bool selected) {
                                  setState(() {
                                    // selected
                                    //     ? selectedFilters.add('REJECT FOR GATE-IN')
                                    //     : selectedFilters
                                    //     .remove('REJECT FOR GATE-IN');
                                  });
                                },
                                selectedColor: MyColor.primaryColorblue.withOpacity(0.1),
                                backgroundColor: Colors.transparent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                  side: BorderSide(
                                    color: false//selectedFilters.contains('REJECT FOR GATE-IN')
                                        ?MyColor.primaryColorblue
                                        : Colors.transparent,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),

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
                                onPressed: () {},
                                child: const Text(
                                  "Save",
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

}

class ShipmentDetailsList extends StatelessWidget {
  final List<ShipmentDetails> shipmentDetailsList;

  ShipmentDetailsList({required this.shipmentDetailsList});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: shipmentDetailsList.length,
      itemBuilder: (context, index) {
        final shipment = shipmentDetailsList[index];
        return buildShipmentCard(shipment);
      },
    );
  }

  Widget buildShipmentCard(ShipmentDetails shipment) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      elevation: 3,
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  shipment.awbNumber,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(width: 8),
                _buildLabel("AWB", Colors.blueAccent),
                SizedBox(width: 4),
                _buildLabel("CONSOL", Colors.grey),
                SizedBox(width: 4),
                _buildLabel("CREATED", Colors.lightBlue),
                Spacer(),
                Text(
                  shipment.date,
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("MAWB No: ${shipment.mawbNumber}",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                Text("Declared PCS: ${shipment.declaredPcs}"),
                Text("Declared Weight: ${shipment.declaredWeight}"),
                Text("Unit: ${shipment.unit}"),
                Text("Accepted Pcs: ${shipment.acceptedPcs}"),
                Text("Accepted Wt: ${shipment.acceptedWeight}"),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        text,
        style: TextStyle(color: color, fontWeight: FontWeight.bold),
      ),
    );
  }
}

class ShipmentDetails {
  final String awbNumber;
  final String mawbNumber;
  final String date;
  final int declaredPcs;
  final double declaredWeight;
  final String unit;
  final int acceptedPcs;
  final int acceptedWeight;
  final String awb;
  final String shipmentType;
  final String status;

  ShipmentDetails({
    required this.awbNumber,
    required this.mawbNumber,
    required this.date,
    required this.declaredPcs,
    required this.declaredWeight,
    required this.unit,
    required this.acceptedPcs,
    required this.acceptedWeight,
    required this.awb,
    required this.shipmentType,
    required this.status,
  });
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
