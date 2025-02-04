import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:galaxy/Ipad/screen/pickUpOperations.dart';
import 'package:galaxy/Ipad/screen/scan_yardCheckIn.dart';
import 'package:galaxy/Ipad/screen/vehicleTrackingDashboard.dart';
import 'package:galaxy/Ipad/screen/warehouseoperations.dart';

import '../../core/images.dart';
import '../../core/mycolor.dart';
import '../../module/login/pages/loginscreen.dart';
import '../../module/onboarding/sizeconfig.dart';
import '../../utils/sizeutils.dart';
import '../modal/yard_checkin_modal.dart';
import '../utils/global.dart';
import '../widget/customIpadTextfield.dart';
import 'ImportShipmentListing.dart';
import 'manual_yard_checkin.dart';


class EasyYardCheckInScreen extends StatefulWidget {
  const EasyYardCheckInScreen({super.key});

  @override
  State<EasyYardCheckInScreen> createState() => _EasyYardCheckInScreenState();
}

class _EasyYardCheckInScreenState extends State<EasyYardCheckInScreen> {
  String selectedBaseStationBranch = "Select";
  List<WarehouseBaseStationBranch> dummyList = [ ];
  String walkIn = "";
  int custodianId = 0;
  bool isLoading=false;
  @override
  void initState() {
    super.initState();
    if (!isTerminalAlreadySelected) {
      selectedBaseStationID = 0;
      terminalsListDDL = [];
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        //selectTruckerDialog(context);
        showDialog(
            barrierDismissible: false,
            context: context,
            builder: (context) {
              return selectTerminalBox();
            });
      });
    }
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
                const Text(
                  "  Easy Yard Check-In",
                  style: TextStyle(
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
              child:   Column(
                children: [
                  Padding(
                    padding:  EdgeInsets.only(top: 20, left: 20, right: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding:const EdgeInsets.symmetric(horizontal: 8),
                              child: GestureDetector(
                                child: const Icon(Icons.arrow_back_ios,
                                    color: MyColor.primaryColorblue),
                                onTap: () {
                                  setState(() {
                                    isTerminalAlreadySelected = false;
                                  });
                                  Navigator.pop(context);
                                },
                              ),
                            ),
                            const Text(
                           'Easy Yard Check-In',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 22),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20,),
                  const Padding(
                    padding: EdgeInsets.only(
                        top: 5, left: 20, right: 20, bottom: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        RoundedIconButtonNew(
                          icon: checkin,
                          text: 'Yard\nCheck-In',
                          targetPage: ManualYardCheckIn(),
                          containerColor: Color(0xffD1E2FB),
                          iconColor: MyColor.textColorGrey3,
                          textColor: MyColor.textColorGrey3,
                        ),
                        SizedBox(width: 40,),
                        RoundedIconButtonNew(
                          icon: scan,
                          text: 'Scan &\nCheck-In',
                          targetPage: ScanYardCheckIn(),
                          containerColor: Color(0xffDFD6EF),
                          iconColor: MyColor.textColorGrey3,
                          textColor: MyColor.textColorGrey3,
                        ),
                      ],
                    ),
                  )

                ],
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

  getBaseStationBranch(cityId) async {
    baseStationBranchList = [];
    dummyList = [];
    selectedBaseStationBranchID = 0;
    selectedBaseStationBranch = "Select";
    var queryParams = {"CityId": cityId.toString(), "OrganizationId": "0", "UserId": "0"};
    await Global()
        .getData(
      'GetBaseStationWiseBranch',
      queryParams,
    )
        .then((response) {
      print("data received ");
      print(json.decode(response.body)['ResponseObject']);
      Map<String, dynamic> jsonResponse = json.decode(response.body);
      List<dynamic> resp = jsonResponse['ResponseObject'];

      baseStationBranchList = resp
          .map<WarehouseBaseStationBranch>(
              (json) => WarehouseBaseStationBranch.fromJson(json))
          .toList();

      WarehouseBaseStationBranch wt = new WarehouseBaseStationBranch(
          orgName: "",
          organizationId: 0,
          organizationBranchId: 0,
          orgBranchName: "Select");
      // baseStationBranchList.add(wt);
      baseStationBranchList.sort(
              (a, b) => a.organizationBranchId.compareTo(b.organizationBranchId));

      print("length baseStationList = " +
          baseStationBranchList.length.toString());
      print(baseStationBranchList.toString());
      setState(() {
        isLoading = false;
      });
    }).catchError((onError) {
      // setState(() {
      //   isLoading = false;
      // });
      print(onError);
    });
  }

  walkInEnable() {
    List<WarehouseTerminals> filteredTerminals = [];
    for (int i = 0; i < baseStationBranchList.length; i++) {
      filteredTerminals = terminalsList
          .where(
              (terminal) {
                print("----${terminal.custodianName}---- $selectedBaseStationBranch");
               return terminal.custodianName == selectedBaseStationBranch;
              })
          .toList();
      setState(() {
        custodianId = filteredTerminals[0].custudian;
      });
    }

    terminalsListDDL = [];
    terminalsListDDL.add(filteredTerminals[0]);
    print(terminalsListDDL.toString());

  }

  changeValue() async {
    await getBaseStationBranch(selectedBaseStationID);
    // await getCommodity(selectedBaseStation);
    print("******* ${baseStationBranchList.toString()} ********");
    setState(() {
      dummyList = baseStationBranchList;
    });
  }
  // getCommodity(baseStation) async {
  //   commodityList = [];
  //   Commodity wt = new Commodity(
  //     shcId: 0,
  //     specialHandlingCode: 'Select',
  //     description: '',
  //   );
  //   commodityList.add(wt);
  //   selectedBaseForCommId = 0;
  //   var queryParams = {"BaseStation": baseStation};
  //   await Global()
  //       .postData(
  //     Settings.SERVICES['GetCommodity'],
  //     queryParams,
  //   )
  //       .then((response) {
  //     print("data received ");
  //     print(json.decode(response.body)['d']);
  //
  //     var msg = json.decode(response.body)['d'];
  //     var resp = json.decode(msg).cast<Map<String, dynamic>>();
  //
  //     commodityList =
  //         resp.map<Commodity>((json) => Commodity.fromJson(json)).toList();
  //
  //     Commodity wt = new Commodity(
  //       shcId: 0,
  //       specialHandlingCode: 'Select',
  //       description: '',
  //     );
  //     commodityList.add(wt);
  //     // commodityList.sort((a, b) => a.cityid.compareTo(b.cityid));
  //     print("length baseStationList = " + commodityList.length.toString());
  //     setState(() {
  //       isLoading = false;
  //     });
  //   }).catchError((onError) {
  //     // setState(() {
  //     //   isLoading = false;
  //     // });
  //     print(onError);
  //   });
  // }
  selectTerminalBox() {
    return Container(
      height: MediaQuery.of(context).size.height / 5.2, // height: 250,
      width: MediaQuery.of(context).size.width / 3.8,

      child: StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              backgroundColor: Colors.white,
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 10,
                  ),
                  SizedBox(
                    width:MediaQuery.of(context).size.width / 1.4,
                    child: Text(
                      "Select Base Station",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: MyColor.primaryColorblue,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    width:MediaQuery.of(context).size.width / 1.4,
                    child: Wrap(
                      spacing: 5.0,
                      children: List<Widget>.generate(
                        baseStationList.length,
                            (int index) {
                              bool isSelected = selectedBaseStationID ==
                                  baseStationList[index].cityid;
                          return Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: ChoiceChip(
                              label: Text(
                                ' ${baseStationList[index].airportcode}',
                              ),
                              labelStyle: TextStyle(color: MyColor.primaryColorblue),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0),
                                side: BorderSide(
                                  color: isSelected ? MyColor.primaryColorblue : Colors.transparent,
                                ),
                              ),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 24.0, vertical: 8.0),
                              backgroundColor: MyColor.dropdownColor,
                              selectedColor: MyColor.dropdownColor,
                              showCheckmark: false,
                              materialTapTargetSize: MaterialTapTargetSize.padded,
                              selected: isSelected,
                              onSelected: (bool selected) {
                                setState(() async {
                                  selectedBaseStationID = (selected
                                      ? baseStationList[index].cityid
                                      : null)!;
                                  selectedBaseStation =
                                      baseStationList[index].airportcode;
                                  print(selectedBaseStationID);
                                  print(selectedBaseStation);
                                  await changeValue();
                                  setState(() {});
                                });
                              },
                            ),
                          );
                        },
                      ).toList(),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    width:MediaQuery.of(context).size.width / 1.4,
                    child: Text(
                      dummyList.length != 0 ? "Select Terminal" : "",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: MyColor.primaryColorblue,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    width:MediaQuery.of(context).size.width / 1.4,
                    child: Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Wrap(
                        spacing: 5.0,
                        children: List<Widget>.generate(
                          dummyList.length,
                              (int index) {
                                bool isSelected = selectedBaseStationBranchID ==
                                    dummyList[index].organizationBranchId;
                            return ChoiceChip(
                              label: Text(' ${dummyList[index].orgBranchName}'),
                              labelStyle:
                                const TextStyle(color: MyColor.primaryColorblue),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0),
                                side: BorderSide(
                                  color: isSelected ? MyColor.primaryColorblue : Colors.transparent,
                                ),
                              ),

                              padding: const EdgeInsets.symmetric(
                                  horizontal: 24.0, vertical: 8.0),
                              selected:isSelected,
                              showCheckmark: false,
                              backgroundColor: MyColor.dropdownColor,
                              selectedColor: MyColor.dropdownColor,
                              onSelected: (bool selected) {
                                setState(() {
                                  selectedBaseStationBranchID = (selected
                                      ? dummyList[index].organizationBranchId
                                      : null)!;
                                  selectedBaseStationBranch = (selected
                                      ? dummyList[index].orgBranchName
                                      : null)!;
                                  // walkInEnable();
                                });
                              },
                            );
                          },
                        ).toList(),
                      ),
                    ),
                  )
                ],
              ),
              // },),

              actions: [
                // Padding(
                //   padding: const EdgeInsets.only(right: 8.0, bottom: 16.0),
                //   child: ElevatedButton(
                //     //textColor: Colors.black,
                //     onPressed: () {},
                //     style: ElevatedButton.styleFrom(
                //       elevation: 4.0,
                //       shape: RoundedRectangleBorder(
                //           borderRadius: BorderRadius.circular(10.0)), //
                //       padding: const EdgeInsets.all(0.0),
                //     ),
                //     child: Container(
                //       height: 50,
                //       width: 150,
                //       decoration: BoxDecoration(
                //         borderRadius: BorderRadius.circular(10),
                //         color: Colors.white,
                //       ),
                //       child: Padding(
                //         padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                //         child: Align(
                //           alignment: Alignment.center,
                //           child: Text(
                //             'Clear',
                //             style: TextStyle(
                //                 fontSize: 20,
                //                 fontWeight: FontWeight.normal,
                //                 color: Color(0xFF11249F)),
                //           ),
                //         ),
                //       ),
                //     ),
                //   ),
                // ),
                Padding(
                  padding: const EdgeInsets.only(right: 8.0, bottom: 16.0),
                  child: ElevatedButton(
                    //textColor: Colors.black,
                    onPressed: () {
                      if(isTerminalSelected()){
                        setState(() {
                          isTerminalAlreadySelected = true;
                        });
                        Navigator.of(context).pop();
                      }
                      else{
                        if (selectedBaseStationID == 0) {
                          showAlertDialog(
                              context,"Ok",
                              "Alert",
                              "Select Base Station");
                          print("base");
                          return;
                        }
                        if (selectedBaseStationBranchID == 0) {
                          showAlertDialog(
                              context,"Ok",
                              "Alert",
                              "Select Terminal");
                          print("terminal");
                        }
                      }


                    },
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
                    child: const Text(
                      'OK',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.normal,
                          color: Colors.white),
                    ),
                  ),
                ),
              ],
            );
          }),
    );
  }

  bool isTerminalSelected() {
    if (selectedBaseStationID == 0 || selectedBaseStationBranchID == 0) {
      return false;
    }
    return true;
  }

  showAlertDialog(context, buttonText, titleText, msgText) {
    // set up the button
    Widget okButton = TextButton(
      child: Text(buttonText),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(
        titleText,
        style: TextStyle(
            fontFamily: 'Roboto', fontSize: 16, color: Colors.red.shade800),
      ),
      content: Text(
        msgText,
        style: TextStyle(fontFamily: 'Roboto', fontSize: 16),
      ),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
