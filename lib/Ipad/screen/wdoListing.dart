import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:galaxy/Ipad/modal/ShipmentListingDetails.dart';
import 'package:intl/intl.dart';
import '../../core/images.dart';
import '../../core/mycolor.dart';
import '../../module/onboarding/sizeconfig.dart';
import '../../utils/dialogutils.dart';
import '../../utils/sizeutils.dart';
import '../../utils/snackbarutil.dart';
import '../../widget/customebuttons/roundbuttonblue.dart';
import '../../widget/customeedittext/customeedittextwithborder.dart';
import '../../widget/custometext.dart';
import '../auth/auth.dart';
import '../modal/wdoModal.dart';
import '../utils/global.dart';
import '../widget/customDialog.dart';
import '../widget/customIpadTextfield.dart';
import 'ImportCreateShipment.dart';
import 'ImportShipmentListing.dart';
import 'createNewDo.dart';

class WdoListing extends StatefulWidget {
  const WdoListing({super.key});

  @override
  State<WdoListing> createState() => _WdoListingState();
}

class _WdoListingState extends State<WdoListing> {

  late List<WdoSearchResult> shipmentListDetails=[];

  final AuthService authService = AuthService();
  bool isLoading = false;
  bool hasNoRecord = false;
  late TextEditingController fromDateController;
  late TextEditingController toDateController;
  late TextEditingController prefixController=TextEditingController();
  late TextEditingController suffixController=TextEditingController();
  late TextEditingController hawbController=TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    fromDateController = TextEditingController(text: _formatDate(DateTime.now()));
    toDateController = TextEditingController(text: _formatDate(DateTime.now()));
    DateTime now = DateTime.now();
    String todayDate = DateFormat('dd-MM-yyyy').format(now);
     getWDOListing(todayDate,todayDate,"","","");
  }

  Future<void> showWDOSearchDialog(BuildContext outerContext) async {


    Future<void> _selectDate(
        BuildContext context, TextEditingController controller,
        {bool isFromDate = false}) async {
      final DateTime? picked = await showDatePicker(
        context: context,
        //initialEntryMode: DatePickerEntryMode.calendarOnly,
        initialDate: isFromDate
            ? DateTime.now().subtract(const Duration(days: 2))
            : DateTime.now(),
        firstDate: DateTime(2020),
        lastDate: DateTime(2101),
        builder: (BuildContext context, Widget? child) {
          return Theme(
            data: ThemeData(
              useMaterial3: false,
              primaryColor: MyColor.primaryColorblue,

              dialogBackgroundColor: Colors.white,
              // Change dialog background color
              colorScheme: const ColorScheme.light(
                primary: MyColor.primaryColorblue,
                onPrimary: Colors.white,
                onSurface: Colors.black,
              ),
              textButtonTheme: TextButtonThemeData(
                style: TextButton.styleFrom(
                  foregroundColor:MyColor.primaryColorblue,
                ),
              ),
            ),
            child: child!,
          );
        },
      );

      if (picked != null) {
        controller.text = DateFormat('dd/MM/yyyy').format(picked);
      }
    }

    void search() async {
      String fromDate = fromDateController.text.trim();
      String toDate = toDateController.text.trim();

      if (fromDate.isEmpty || toDate.isEmpty) {
        await Future.delayed(const Duration(milliseconds: 100));

        return;
      }
      DateTime fromDateTime = DateFormat('dd/MM/yyyy').parse(fromDate);
      DateTime toDateTime = DateFormat('dd/MM/yyyy').parse(toDate);

      String formattedFromDate = DateFormat('dd-MM-yyyy').format(fromDateTime);
      String formattedToDate = DateFormat('dd-MM-yyyy').format(toDateTime);

      getWDOListing(formattedFromDate.toString(), formattedToDate.toString(),prefixController.text.trim(),suffixController.text.trim(),hawbController.text.trim());


      Navigator.pop(context);
    }


    return showDialog(
      context: context,
      barrierColor: Color(0x01000000),
      builder: (BuildContext context) {
        return Align(
          alignment: Alignment.topCenter,
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.75,
            width: MediaQuery.of(context).size.width*0.5,
            child: KeyboardAvoidingWrapper(
              child: Dialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                insetPadding: const EdgeInsets.all(0),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: MyColor.cardBgColor),
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
                  padding: const EdgeInsets.all(16.0),
                  child: SingleChildScrollView(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("WDO Search",
                              style: TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.bold)),
                          const SizedBox(
                            width: double.infinity,
                            child: Divider(color: Colors.grey),
                          ),
                          // Gray horizontal line
                          const SizedBox(height: 16),
                          SizedBox(
                            width:
                            MediaQuery.sizeOf(context)
                                .width,
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
                                    labelText: "Prefix",
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
                                      0.345,
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
                                    labelText: "AWB No",
                                    readOnly: false,
                                    controller: suffixController,
                                    maxLength: 8,
                                    fontSize: 18,
                                    onChanged:
                                        (String, bool) {},
                                  ),
                                )
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                          SizedBox(
                            height:
                            MediaQuery.sizeOf(
                                context)
                                .height *
                                0.04,
                            width:
                            MediaQuery.sizeOf(
                                context)
                                .width ,
                            child:
                            CustomeEditTextWithBorder(
                              lablekey: 'MAWB',
                              hasIcon: false,
                              hastextcolor: true,
                              animatedLabel: true,
                              needOutlineBorder:
                              true,
                              labelText: "HAWB No",
                              readOnly: false,
                              controller: hawbController,
                              maxLength: 8,
                              fontSize: 18,
                              onChanged:
                                  (String, bool) {},
                            ),
                          ),
                          const SizedBox(height: 16),
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
                          const SizedBox(height: 16),
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
              
                          // TextField(
                          //   controller: toDateController,
                          //   decoration: InputDecoration(
                          //     labelText: "To Date",
                          //     suffixIcon: IconButton(
                          //       icon: const Icon(Icons.calendar_today),
                          //       onPressed: () => _selectDate(context, toDateController),
                          //     ),
                          //     border: OutlineInputBorder(
                          //       borderRadius: BorderRadius.circular(6),
                          //     ),
                          //   ),
                          // ),
                          SizedBox(
                              height: MediaQuery.sizeOf(context).height * 0.09),
                          const SizedBox(
                            width: double.infinity,
                            child: Divider(color: Colors.grey),
                          ),
                          const SizedBox(height: 16),
              
                          ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                search();
                              }
              
                              // Navigator.pop(context); // Close dialog after search
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: MyColor.primaryColorblue,
                              minimumSize: const Size.fromHeight(50),
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                    Radius.circular(8)),
                              ),
                            ),
                            child: const Text("SEARCH",
                                style: TextStyle(color: Colors.white)),
                          ),
                          const SizedBox(height: 16),
                          // Space between buttons
              
                          OutlinedButton(
                            onPressed: () {
                              prefixController.clear();
                              suffixController.clear();
                              hawbController.clear();
                              fromDateController.text = _formatDate(DateTime.now());
                              toDateController.text = _formatDate(DateTime.now());
                            },
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color:  MyColor.primaryColorblue),
                              minimumSize: const Size.fromHeight(50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: const Text(
                              "RESET",
                              style: TextStyle(
                                  color:  MyColor.primaryColorblue), // Blue text
                            ),
                          ),
                          const SizedBox(height: 16),
                          // Space between buttons
                          // Cancel button
                          TextButton(
                            onPressed: () {
                              prefixController.clear();
                              suffixController.clear();
                              hawbController.clear();
                              fromDateController.text =_formatDate(DateTime.now());
                              toDateController.text = _formatDate(DateTime.now());
                              Navigator.pop(context);
                            },
                            style: TextButton.styleFrom(
                              minimumSize: const Size.fromHeight(50),
                            ),
                            child: const Text(
                              "CANCEL",
                              style: TextStyle(color:  MyColor.primaryColorblue),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  String _formatDate(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }
  clearAWB(){
    prefixController.clear();
    suffixController.clear();
    hawbController.clear();
  }

  getWDOListing(String fromDate, String toDate,String awbPrefix,String awbSuffix,String hawbNo) async {
    if (isLoading) return;
    shipmentListDetails = [];

    setState(() {
      isLoading = true;
    });

    var queryParams = {
      "AWBPrefix": "$awbPrefix",
      "AWBNo": "$awbSuffix",
      "HAWBNO": "$hawbNo",
      "FromDate": "$fromDate",
      "ToDate": "$toDate"
    };
    await authService
        .sendGetWithBody(
      "WDO/WDOSearch",
      queryParams,
    )
        .then((response) {
      print("data received ");
      Map<String, dynamic> jsonData = json.decode(response.body);
      List<dynamic> resp = jsonData['WDOSearchList'];
      print(jsonData);
      if (jsonData.isEmpty) {
        setState(() {
          hasNoRecord = true;
        });
      }
      else{
       setState(() {
         hasNoRecord=false;
       });
      }
      print("is empty record$hasNoRecord");

      setState(() {
        shipmentListDetails =
            resp.map((json) => WdoSearchResult.fromJSON(json)).toList();
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
        drawer: const Drawer(),
        body: Stack(
          children: [
            Container(
              constraints: const BoxConstraints.expand(),
              color: MyColor.screenBgColor,
              child: Column(
                children: [
                  Padding(
                    padding:
                    const EdgeInsets.only(top: 20, left: 20, right: 20),
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
                                '  Warehouse Delivery Order List  ',
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
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 5, left: 20, right: 20, bottom: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          '',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        Row(
                          children: [
                            GestureDetector(
                              child: const Row(
                                children: [
                                  Icon(
                                    Icons.search,
                                    color: MyColor.primaryColorblue,
                                  ),

                                ],
                              ),
                              onTap: () {
                                // showShipmentSearchBottomSheet(context);
                                showWDOSearchDialog(context);
                              },
                            ),
                          ],
                        )
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
                              WdoSearchResult
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
              Navigator.push(context, MaterialPageRoute(builder: (_)=>CreateNewDO()));
            },
            backgroundColor: MyColor.primaryColorblue,
            child: const Icon(Icons.add),
          ),
        ),
        resizeToAvoidBottomInset: false,
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

  String formatDate(String inputDateString) {
    DateFormat inputFormat = DateFormat("MM/dd/yyyy h:mm:ss a");
    DateTime parsedDate = inputFormat.parse(inputDateString);
    DateFormat outputFormat = DateFormat("dd MMM yy HH:mm");
    return outputFormat.format(parsedDate);
  }

  releaseWDO(WdoSearchResult data) async {

    // return;
    var queryParams = {
      "ArrayOfWDOObjects": "<ArrayOfWDOObjects><WDOObjects><IMPSHIPROWID>${data.impShipRowId}</IMPSHIPROWID><ROTATION_NO /><WDOSEQNO>${data.wdoSeqNo}</WDOSEQNO><PKG_RECD>${data.npr}</PKG_RECD><WT_RECD>${data.wtRec}</WT_RECD><RELEASED_STATUS>0</RELEASED_STATUS><CUSTOMREFNO>${data.impShipRowId??""}</CUSTOMREFNO></WDOObjects></ArrayOfWDOObjects>",
      "StatusKey": "RELEASE",
      "AgentName ": "",
      "AgentCPRNo": "",
      "VehicleNo": "",
      "DriverName": "",
      "SHED_CODE": "KS1",
      "CustmRefNoValue": "",
      "isAbandon": "",
      "AirportCity": "JFK",
      "CompanyCode": "3",
      "UserId": userId.toString()
    };
    DialogUtils.showLoadingDialog(context);
    await authService
        .postData(
      "WDO/ReleaseWDO",
      queryParams,
    )
        .then((response) async {
      print("data received ");
      Map<String, dynamic> jsonData = json.decode(response.body);
      String? status = jsonData['Status'];
      String? statusMessage = jsonData['StatusMessage']??"";
      if(jsonData.isNotEmpty){
        DialogUtils.hideLoadingDialog(context);
        if(status!="S"){
          showDataNotFoundDialog(context, statusMessage!);
        }
        if((status=="S")){
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
            DateTime fromDateTime = DateFormat('dd/MM/yyyy').parse(fromDateController.text.trim());
            DateTime toDateTime = DateFormat('dd/MM/yyyy').parse(toDateController.text.trim());

            String formattedFromDate = DateFormat('dd-MM-yyyy').format(fromDateTime);
            String formattedToDate = DateFormat('dd-MM-yyyy').format(toDateTime);
            clearAWB();
            getWDOListing(formattedFromDate.toString(), formattedToDate.toString(),"","","");
          }
        }

      }
    }).catchError((onError) {

      print(onError);
    });
  }
  revokeWDO(WdoSearchResult data) async {

    // return;
    var queryParams = {
      "ArrayOfWDOObjects": "<ArrayOfWDOObjects><WDOObjects><IMPSHIPROWID>${data.impShipRowId}</IMPSHIPROWID><ROTATION_NO /><WDOSEQNO>${data.wdoSeqNo}</WDOSEQNO><PKG_RECD>${data.npr}</PKG_RECD><WT_RECD>${data.wtRec}</WT_RECD><RELEASED_STATUS>1</RELEASED_STATUS><CUSTOMREFNO>${data.customRefNo??""}</CUSTOMREFNO></WDOObjects></ArrayOfWDOObjects>",
      "StatusKey": "REVOKERELEASE",
      "SHED_CODE": "KS1",
      "AirportCity": "JFK",
      "CompanyCode": "3",
      "UserId": userId.toString()
    };
    DialogUtils.showLoadingDialog(context);
    await authService
        .postData(
      "WDO/RevokeWDO",
      queryParams,
    )
        .then((response) async {
      print("data received ");
      Map<String, dynamic> jsonData = json.decode(response.body);
      String? status = jsonData['Status'];
      String? statusMessage = jsonData['StatusMessage']??"";
      if(jsonData.isNotEmpty){
        DialogUtils.hideLoadingDialog(context);
        if(status!="S"){
          showDataNotFoundDialog(context, statusMessage!);
        }
        if((status=="S")){
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
            DateTime fromDateTime = DateFormat('dd/MM/yyyy').parse(fromDateController.text.trim());
            DateTime toDateTime = DateFormat('dd/MM/yyyy').parse(toDateController.text.trim());
            String formattedFromDate = DateFormat('dd-MM-yyyy').format(fromDateTime);
            String formattedToDate = DateFormat('dd-MM-yyyy').format(toDateTime);
            clearAWB();
            getWDOListing(formattedFromDate.toString(), formattedToDate.toString(),"","","");
          }
        }

      }
    }).catchError((onError) {

      print(onError);
    });
  }

  Widget buildShipmentCardV2(WdoSearchResult shipment) {
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
                  shipment.wdoNo,
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 8),
                buildLabel(shipment.status.toUpperCase(), Colors.lightGreen,20),
                const SizedBox(width: 8),

                const SizedBox(width: 32),
                Text(
                  shipment.awbNumber,
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 8),
                buildLabel("AWB", Colors.deepPurpleAccent,8,isBorder: true,borderColor: Colors.deepPurpleAccent),
                const SizedBox(width: 8),
                buildLabel(shipment.houseNumber==""?"DIRECT":"CONSOL", Colors.white,8,isBorder: true,borderColor: Colors.grey),


                // Container(
                //   height: 30,
                //   decoration: BoxDecoration(
                //     borderRadius: BorderRadius.circular(8),
                //     gradient: const LinearGradient(
                //       colors: [
                //         Color(0xFF0057D8),
                //         Color(0xFF1c86ff),
                //       ],
                //       begin: Alignment.centerLeft,
                //       end: Alignment.centerRight,
                //     ),
                //   ),
                //   child: ElevatedButton(
                //     style: ElevatedButton.styleFrom(
                //         backgroundColor: Colors.transparent,
                //         shadowColor: Colors.transparent),
                //     onPressed: null,
                //     child: const Text(
                //       'Accept Shipment',
                //       style: TextStyle(color: Colors.white),
                //     ),
                //   ),
                // ),


              ],
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                Text(
                  shipment.pfdDateTime,
                  style: const TextStyle(color: Colors.black,fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 8),
                const Icon(
                  Icons.info_outline_rounded,
                  color: MyColor.primaryColorblue,
                ),
              ],
            ),
            const SizedBox(height: 6),

            Row(
              children: [
                SizedBox(
                  width: MediaQuery.sizeOf(context).width*0.73,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const SizedBox(width: 4),
                      SizedBox(
                        width: MediaQuery.sizeOf(context).width*0.22,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Text("HAWB No: "),
                                Text("${shipment.houseNumber}",style: const TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Text("Custom Ref No.: "),
                                Text("${shipment.customRefNo}",style: const TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
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
                                const Text("NOP: "),
                                Text("${shipment.npr}",style: const TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Text("Delivered NOP: "),
                                Text("${shipment.deliveredWdonop}",style: const TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
                              ],
                            ),
                          ],
                        ),
                      ),

                      SizedBox(
                        width: MediaQuery.sizeOf(context).width*0.3,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Text("Flight Details: "),
                                Text(shipment.flightDetails,style: const TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Text("Re Warehouse: "),
                                Text(shipment.reWhDateTime.isNotEmpty?formatDate(shipment.reWhDateTime):"",style: const TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
                              ],
                            ),
                          ],
                        ),
                      ),

                    ],
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Container(
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
                            onPressed: (){
                              if((shipment.status.toUpperCase())=="GENERATED"){
                                releaseWDO(shipment);
                              }else if((shipment.status.toUpperCase())=="REVOKED"){
                                releaseWDO(shipment);
                              }
                              else{
                                revokeWDO(shipment);
                              }
                            },
                            child:  Text(
                              (shipment.status.toUpperCase())=="GENERATED"?'Release':(shipment.status.toUpperCase())=="REVOKED"?"Release":"Revoke",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                        // Icon(
                        //   Icons.more_vert_outlined,
                        //   color: MyColor.primaryColorblue,
                        // ),
                        // Container(
                        //   margin: const EdgeInsets.only(left: 12),
                        //   decoration: BoxDecoration(
                        //     borderRadius: BorderRadius.circular(5),
                        //     color:Color(0xffF2F7FD),
                        //   ),
                        //   child: Icon(
                        //     size: 28,
                        //      Icons.keyboard_arrow_right_outlined,
                        //     color: MyColor.primaryColorblue,
                        //   ),
                        // )
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
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(radius),
        border: isBorder ? Border.all(color: borderColor, width: borderWidth) : null,
      ),
      child: Text(
        text,
        style: const TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
      ),
    );
  }

}
class KeyboardAvoidingWrapper extends StatelessWidget {
  final Widget child;

  const KeyboardAvoidingWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(viewInsets: EdgeInsets.zero),
      child: child,
    );
  }
}