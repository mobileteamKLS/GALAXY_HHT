import 'dart:convert';
import 'dart:ui';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:galaxy/Ipad/screen/pickUpOperations.dart';
import 'package:galaxy/Ipad/screen/print.dart';
import 'package:galaxy/Ipad/screen/vehicleTrackingDashboard.dart';
import 'package:galaxy/Ipad/screen/warehouseoperations.dart';
import 'package:galaxy/Ipad/screen/easy_yard_checkin_dashboard.dart';
import 'package:lottie/lottie.dart';

import '../../core/images.dart';
import '../../core/mycolor.dart';
import '../../module/login/pages/loginscreen.dart';
import '../../module/onboarding/sizeconfig.dart';
import '../../utils/dialogutils.dart';
import '../../utils/sizeutils.dart';
import '../modal/yard_checkin_modal.dart';
import '../utils/global.dart';
import '../widget/customIpadTextfield.dart';
import 'ImportShipmentListing.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  @override
  void initState() {
    super.initState();
    fetchTerminal();
  }
  fetchTerminal() async {
    await Future.delayed(Duration.zero);
    getTerminalsList();
    getTerminalBaseStation();
  }

  getTerminalsList() async {
    DialogUtils.showLoadingDialog(context);

    var queryParams = {"":""};// original  {"AdminOrgProdId":"2"}

    await Global()
        .getData(
     'GetTerminal',
      queryParams,
    )
        .then((response) {
      print("data received ");
      print(json.decode(response.body)['ResponseObject']);

      /* terminalsList = responseObjectList.map((e) => WarehouseTerminals.fromJson(e)).toList();
        Map<String, dynamic> jsonResponse = json.decode(response.body);
        List<dynamic> resp = jsonResponse['ResponseObject'];*/


      Map<String, dynamic> jsonResponse = json.decode(response.body);
      List<dynamic> responseObjectList = jsonResponse['ResponseObject'];

      terminalsList = responseObjectList.map((e) => WarehouseTerminals.fromJson(e)).toList();



      /*
        terminalsList = resp
            .map<WarehouseTerminals>((json) => WarehouseTerminals.fromJson(json))
            .toList();*/

      WarehouseTerminals wt =
      new WarehouseTerminals(custudian: 0, custodianName: "Select",iswalkinEnable: false);
      terminalsList.add(wt);
      terminalsList.sort((a, b) => a.custudian.compareTo(b.custudian));

      print("length terminalsList = " + terminalsList.length.toString());

      DialogUtils.hideLoadingDialog(context);
    }).catchError((onError) {

      print(onError);
    });
  }
  getTerminalBaseStation() async {
    DialogUtils.showLoadingDialog(context);
    var queryParams = {'UserId': "0", 'OrganizationId': "0",'PAFlag':'1'};

    await Global()
        .getData(
      'GetUserBaseStation',
      queryParams,
    )
        .then((response) {

      print("data received ");
      print(json.decode(response.body)['ResponseObject']);
      Map<String, dynamic> jsonResponse = json.decode(response.body);
      List<dynamic> resp = jsonResponse['ResponseObject'];
      baseStationList = resp
          .map<WarehouseBaseStation>((json) => WarehouseBaseStation.fromJson(json))
          .toList();
      baseStationList.sort((a, b) => a.cityid.compareTo(b.cityid));

      print("length baseStationList = " + baseStationList.length.toString());
      print("data baseStationList = ${baseStationList[0].organizationId} == ${baseStationList[0].orgName} == ${baseStationList[0].cityid} == ${baseStationList[0].airportcode}");

      DialogUtils.hideLoadingDialog(context);
    }).catchError((onError) {
      // setState(() {
      //   isLoading = false;
      // });
      print(onError);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(

        body:
        Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage(welcometruck), fit: BoxFit.cover),
          ),
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height,
          ),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 3.0, sigmaY: 3.0),
            child: Container(
              child: Container(
                constraints: const BoxConstraints.expand(),
                color: Colors.transparent,
                child:   Column(
                  children: [
                    const SizedBox(height: 10,),
                    const Padding(
                      padding:
                      EdgeInsets.only(top: 10, left: 20, right: 20),
                      child: Material(
                        color: Colors.transparent,

                      ),
                    ),
                    const SizedBox(height: 20,),
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 5, left: 20, right: 20, bottom: 10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            height:
                            MediaQuery.of(context).size.height /
                                2.6,
                            child: Center(
                              child: Lottie.asset(
                                  'assets/images/home.json'),
                            ),
                          ),

                          Center(
                            child: Container(
                              padding: EdgeInsets.only(left: 40),
                              width: MediaQuery.sizeOf(context).width,
                              height:MediaQuery.of(context).size.height*0.06 ,
                              child: Center(
                                child: DefaultTextStyle(
                                  style: TextStyle(
                                      fontSize:
                                      MediaQuery.of(context).size.width / 23, //52,
                                      fontFamily: 'Roboto',
                                      fontWeight: FontWeight.bold,
                                      color: const Color(0XFFed725f)),
                                  child: AnimatedTextKit(
                                    animatedTexts: [
                                      TyperAnimatedText('Welcome !!'),
                                      TyperAnimatedText('Hola !!'),
                                      TyperAnimatedText('Bonjour !!'),
                                      TyperAnimatedText('नमस्ते !!'),
                                      TyperAnimatedText('Bienvenida !!'),
                                      TyperAnimatedText('Welcome !!'),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),

                           Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              // RoundedIconButtonNew(
                              //   icon: scan,
                              //   text: 'Easy Yard\nCheck-In',
                              //   targetPage: PdfViewerScreen(),
                              //   containerColor: Color(0xffD1E2FB),
                              //   iconColor: MyColor.textColorGrey3,
                              //   textColor: MyColor.textColorGrey3,
                              // ),
                              SizedBox(width: 40,),
                              RoundedIconButtonNew(
                                icon: log_in,
                                text: 'Login\n',
                                targetPage: LogInScreen(
                                  isMPinEnable: false,
                                  authFlag: "P",
                                ),
                                containerColor: Color(0xffDFD6EF),
                                iconColor: MyColor.textColorGrey3,
                                textColor: MyColor.textColorGrey3,
                              ),
                            ],
                          ),
                        ],
                      ),
                    )

                  ],
                ),
              ),
            ),
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


}