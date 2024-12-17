import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:galaxy/Ipad/screen/rejectBooking.dart';
import 'package:galaxy/Ipad/screen/wdoListing.dart';
import 'package:galaxy/module/login/pages/loginscreen.dart';
import '../../core/images.dart';
import '../../core/mycolor.dart';
import '../../language/model/dashboardModel.dart';
import '../../module/onboarding/sizeconfig.dart';
import '../../utils/dialogutils.dart';
import '../../utils/sizeutils.dart';
import '../../widget/custometext.dart';
import '../auth/auth.dart';
import '../modal/ShipmentAcceptanceModal.dart';
import '../utils/global.dart';
import '../widget/customDialog.dart';
import '../widget/customIpadTextfield.dart';
import 'Customsoperation.dart';
import 'ImportCreateShipment.dart';
import 'ImportShipmentListing.dart';
import 'ShipmentAcceptance.dart';
import 'ShipmentAcceptanceManually.dart';
import 'WarehouseLocation.dart';
import 'acceptBooking.dart';
import 'appointmentBooingNew.dart';
import 'appointmentBooking.dart';
import 'availableforExamination.dart';

class WarehouseOperations extends StatefulWidget {
  const WarehouseOperations({super.key});

  @override
  State<WarehouseOperations> createState() => _WarehouseOperationsState();
}

class _WarehouseOperationsState extends State<WarehouseOperations> {
  final AuthService authService = AuthService();
  bool isLoading = false;
  bool hasNoRecord = false;

  @override
  void initState() {
    super.initState();
    fetchMasterData();
  }

  void fetchMasterData() async {
    await Future.delayed(Duration.zero); // Ensures no synchronous blocking
    getCustomerName();
    getCommodity();
    getOriginDestination();
    getFirmsAndDisposition();
  }

  getCommodity() async {
    DialogUtils.showLoadingDialog(context);

    var queryParams = {
      "AirportCode": "BLR",
      "CompanyCode": "3",
      "CultureCode": "en-US",
      "UserId": "1",
      "MenuId": "1"
    };
    await authService
        .getData(
      "CommodityNames/Get",
      queryParams,
    )
        .then((response) {
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
      print("is empty record$hasNoRecord");
      String status = jsonData['Status'];
      String statusMessage = jsonData['StatusMessage'] ?? "";

      if (status != 'S') {
        print("Error: $statusMessage");
        DialogUtils.hideLoadingDialog(context);
        return;
      }
      final List<dynamic> commodities = jsonData['CommodityList'];
      setState(() {
        commodityListMaster = commodities
            .map((commodity) => Commodity.fromJson(commodity))
            .toList();
      });
      DialogUtils.hideLoadingDialog(context);
      print("No of commodities ${commodityListMaster.length}");
    }).catchError((onError) {
      DialogUtils.hideLoadingDialog(context);
      print(onError);
    });
  }

  getCustomerName() async {
    DialogUtils.showLoadingDialog(context);

    var queryParams = {
      "AirportCode": "BLR",
      "CompanyCode": "3",
      "CultureCode": "en-US",
      "UserId": "1",
      "MenuId": "1"
    };
    await authService
        .getData(
      "CustomerNames/Get",
      queryParams,
    )
        .then((response) {
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
      print("is empty record$hasNoRecord");
      String status = jsonData['Status'];
      String statusMessage = jsonData['StatusMessage'] ?? "";

      if (status != 'S') {
        print("Error: $statusMessage");
        DialogUtils.hideLoadingDialog(context);
        return;
      }
      final List<dynamic> customers = jsonData['CustomerList'];
      setState(() {
        customerListMaster =
            customers.map((customer) => Customer.fromJson(customer)).toList();
      });
      DialogUtils.hideLoadingDialog(context);
      print("No of customers ${customerListMaster.length}");
    }).catchError((onError) {
      setState(() {
        isLoading = false;
      });
      print(onError);
    });
  }

  getOriginDestination() async {
    DialogUtils.showLoadingDialog(context);
    originDestinationMaster=[];
    var queryParams = {
      "CompanyCode": "3"
    };
    await authService
        .sendGetWithBody(
      "ShipmentCreation/AirlineData",
      queryParams,
    )
        .then((response) {
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
      print("is empty record$hasNoRecord");
      String status = jsonData['Status'];
      String statusMessage = jsonData['StatusMessage'] ?? "";

      if (status != 'S') {
        print("Error: $statusMessage");
        DialogUtils.hideLoadingDialog(context);
        return;
      }
      final List<dynamic> originDestinationList = jsonData['ReferenceDataListAirline'];
      setState(() {
        originDestinationMaster =
            originDestinationList.map((customer) => OriginDestination.fromJson(customer)).toList();
      });
      DialogUtils.hideLoadingDialog(context);
      print("No of origin and destination ${originDestinationMaster.length}");
    }).catchError((onError) {
      setState(() {
        isLoading = false;
      });
      print(onError);
    });
  }
  getFirmsAndDisposition() async {
    DialogUtils.showLoadingDialog(context);
    firmsCodeMaster=[];
    dispositionCodeMaster=[];
    var queryParams = {
      "CompanyCode": "3",
      "AirportCode" : "JFk"
    };
    await authService
        .sendGetWithBody(
      "ShipmentCreation/FRMDCPData",
      queryParams,
    )
        .then((response) {
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
      print("is empty record$hasNoRecord");
      String status = jsonData['Status'];
      String statusMessage = jsonData['StatusMessage'] ?? "";

      if (status != 'S') {
        print("Error: $statusMessage");
        DialogUtils.hideLoadingDialog(context);
        return;
      }
      final List<dynamic> firmsList = jsonData['ReferenceDataListFRM'];
      final List<dynamic> dispositionCodeList = jsonData['ReferenceDataListDCP'];
      setState(() {
        firmsCodeMaster =
            firmsList.map((customer) => FrmAndDcpCode.fromJson(customer)).toList();
        dispositionCodeMaster =
            dispositionCodeList.map((customer) => FrmAndDcpCode.fromJson(customer)).toList();
      });
      DialogUtils.hideLoadingDialog(context);
      print("No of Firms Code ${firmsCodeMaster.length}");
      print("No of Disposition Code ${dispositionCodeMaster.length}");
    }).catchError((onError) {
      setState(() {
        isLoading = false;
      });
      print(onError);
    });
  }

  static Future<bool?> showLogoutDialog(BuildContext context, ) {
    return showDialog<bool>(
      barrierColor: MyColor.colorBlack.withOpacity(0.5),
      context: context,

      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: MyColor.colorWhite,
          title: CustomeText(text: "Logout",fontSize: SizeConfig.textMultiplier * SizeUtils.HEADINGTEXTSIZE, textAlign: TextAlign.start, fontColor: MyColor.colorRed, fontWeight: FontWeight.w600),
          content: CustomeText(text: "Are you sure you want to logout?",fontSize: SizeConfig.textMultiplier * 1.7, textAlign: TextAlign.start, fontColor: MyColor.colorBlack, fontWeight: FontWeight.w400),
          actions: <Widget>[
            InkWell(
                onTap: () {
                  Navigator.of(context).pop(false);
                },
                child: CustomeText(text: "Cancel",fontSize: SizeConfig.textMultiplier * SizeUtils.MEDIUMTEXTSIZE, textAlign: TextAlign.start, fontColor: MyColor.primaryColorblue, fontWeight: FontWeight.w400)),

            SizedBox(width: SizeConfig.blockSizeHorizontal * 1.8,),

            InkWell(
                onTap: () {
                  Navigator.of(context).pop(true);
                },
                child: CustomeText(text: "Ok",fontSize: SizeConfig.textMultiplier * SizeUtils.MEDIUMTEXTSIZE, textAlign: TextAlign.end, fontColor: MyColor.colorRed, fontWeight: FontWeight.w400)),

          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
            title: Row(
              children: [
                InkWell(
                  onTap: () {},
                  child: Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: SvgPicture.asset(
                      drawer,
                      height:
                          SizeConfig.blockSizeVertical * SizeUtils.ICONSIZE2,
                    ),
                  ),
                ),
                Text(
                  isCES ? '  Warehouse Operations' : "  Customs Operation",
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                      color: Colors.white),
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
              GestureDetector(
                child: const Icon(Icons.logout_outlined,
                    color: Colors.white, size: 36),
                onTap: () async {
                  //bool? logoutConfirmed = await showLogoutDialog(context);
                  var userSelection =
                  await showDialog(
                    context: context,
                    builder: (BuildContext
                    context) =>
                        CustomConfirmDialog(
                            title:
                            "Logout Confirm ?",
                            description:
                            "Are you sure you want to logout ?",
                            buttonText:
                            "Yes",
                            imagepath:
                            'assets/images/question.gif',
                            isMobile:
                            false),
                  );
                  if (userSelection == true) {
                    
                    Navigator.pushAndRemoveUntil(context, CupertinoPageRoute(builder: (context) => const LogInScreen(isMPinEnable: false, authFlag: "P"),), (route) => false,);
                  }
                },
              ),
              const SizedBox(
                width: 20,
              ),
              // SvgPicture.asset(
              //   bell,
              //   height: 25,
              // ),
              // const SizedBox(
              //   width: 10,
              // ),
            ]),
        // drawer: const Drawer(),
        body: Stack(
          children: [
            Container(
              constraints: const BoxConstraints.expand(),
              color: MyColor.screenBgColor,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    const Padding(
                      padding: EdgeInsets.only(top: 10, left: 20, right: 20),
                      child: Material(
                        color: Colors.transparent,
                        // Ensures background transparency
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Row(
                            //   children: [
                            //     GestureDetector(
                            //       child:  const Icon(Icons.arrow_back_ios,
                            //           color: MyColor.primaryColorblue),
                            //       onTap: () {
                            //         Navigator.pop(context);
                            //       },
                            //     ),
                            //     const Text(
                            //       '  ',
                            //       style: TextStyle(
                            //           fontWeight: FontWeight.bold, fontSize: 22),
                            //     ),
                            //   ],
                            // ),
                          ],
                        ),
                      ),
                    ),
                    isCES
                        ? SizedBox(
                            height: 20,
                          )
                        : SizedBox(),
                    isCES
                        ? const Padding(
                            padding: EdgeInsets.only(
                                top: 5, left: 20, right: 20, bottom: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                RoundedIconButtonNew(
                                  icon: CupertinoIcons.doc,
                                  text: 'Shipments\nList',
                                  targetPage: ImportShipmentListing(),
                                  containerColor: Color(0xfffcedcf),
                                  iconColor: MyColor.textColorGrey3,
                                  textColor: MyColor.textColorGrey3,
                                ),
                                // SizedBox(width: 40,),
                                RoundedIconButtonNew(
                                  icon: CupertinoIcons.add,
                                  text: 'Create\nShipment',
                                  targetPage: CreateShipment(),
                                  containerColor: Color(0xffD1E2FB),
                                  iconColor: MyColor.textColorGrey3,
                                  textColor: MyColor.textColorGrey3,
                                ),
                                RoundedIconButtonNew(
                                  icon: CupertinoIcons.cube_box,
                                  text: 'Shipment\nAcceptance',
                                  targetPage: ShipmentAcceptanceManually(),
                                  containerColor: Color(0xffffd7bd),
                                  iconColor: MyColor.textColorGrey3,
                                  textColor: MyColor.textColorGrey3,
                                ),
                              ],
                            ),
                          )
                        : SizedBox(),
                    isCES
                        ? SizedBox(
                            height: 20,
                          )
                        : SizedBox(),
                    isCES
                        ? const Padding(
                            padding: EdgeInsets.only(
                                top: 5, left: 20, right: 20, bottom: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                RoundedIconButtonNew(
                                  icon: Icons.trolley,
                                  text: 'Warehouse\nLocation',
                                  targetPage: WarehouseLocation(),
                                  containerColor: Color(0xffffd1d1),
                                  iconColor: MyColor.textColorGrey3,
                                  textColor: MyColor.textColorGrey3,
                                ),
                                SizedBox(width: 40,),
                                RoundedIconButtonNew(
                                  icon: Icons.local_shipping_outlined,
                                  text: 'Warehouse\nDelivery Order',
                                  targetPage: WdoListing(),
                                  containerColor: Color(0xffb4d9b5),
                                  iconColor: MyColor.textColorGrey3,
                                  textColor: MyColor.textColorGrey3,
                                ),
                                // RoundedIconButton(
                                //   icon: CupertinoIcons.checkmark_rectangle,
                                //   text: 'Customs\nOperation',
                                //   targetPage: CustomsOperation(),
                                //   containerColor: Color(0xffe1d8f0),
                                //   iconColor: MyColor.textColorGrey3,
                                //   textColor: MyColor.textColorGrey3,
                                // ),
                              ],
                            ),
                          )
                        : SizedBox(),
                    (!isCES)
                        ? SizedBox(
                            height: 20,
                          )
                        : SizedBox(),
                    (!isCES)
                        ? Padding(
                            padding: EdgeInsets.only(
                                top: 5, left: 20, right: 20, bottom: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                RoundedIconButtonNew(
                                  icon: CupertinoIcons.doc,
                                  text: 'Appointment\nBookings',
                                  targetPage: AppointmentBooking(),
                                  containerColor: Color(0xfffcedcf),
                                  iconColor: MyColor.textColorGrey3,
                                  textColor: MyColor.textColorGrey3,
                                ),
                                // SizedBox(width: 40,),
                                RoundedIconButtonNew(
                                  icon: Icons.check_circle_outline,
                                  text: 'Accepted\nBookings',
                                  targetPage: AcceptBooking(),
                                  containerColor: Color(0xffb4d9b5),
                                  iconColor: MyColor.textColorGrey3,
                                  textColor: MyColor.textColorGrey3,
                                ),
                                RoundedIconButtonNew(
                                  icon: Icons.cancel_outlined,
                                  text: 'Rejected\nBookings',
                                  targetPage: RejectBooking(),
                                  containerColor: Color(0xffffd1d1),
                                  iconColor: MyColor.textColorGrey3,
                                  textColor: MyColor.textColorGrey3,
                                ),
                              ],
                            ),
                          )
                        : SizedBox(),
                    (!isCES)
                        ? SizedBox(
                            height: 20,
                          )
                        : SizedBox(),
                    (!isCES)
                        ? const Padding(
                            padding: EdgeInsets.only(
                                top: 5, left: 20, right: 20, bottom: 10),
                            child: Row(
                              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                RoundedIconButtonNew(
                                  icon: Icons.search,
                                  text: 'Available For\nExamination',
                                  targetPage: AvailableForExamination(),
                                  containerColor: Color(0xffe1d8f0),
                                  iconColor: MyColor.textColorGrey3,
                                  textColor: MyColor.textColorGrey3,
                                ),
                                 SizedBox(width: 40,),
                                // RoundedIconButtonNew(
                                //   icon: Icons.search,
                                //   text: 'Test \nUI',
                                //   targetPage: AppointmentBookingNew(),
                                //   containerColor:Color(0xffe1d8f0),
                                //   iconColor: MyColor.textColorGrey3,
                                //   textColor: MyColor.textColorGrey3,
                                // ),
                              ],
                            ),
                          )
                        : SizedBox(),

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
}
