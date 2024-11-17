import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../core/images.dart';
import '../../core/mycolor.dart';
import '../widget/customIpadTextfield.dart';
import 'ImportCreateShipment.dart';
import 'ImportShipmentListing.dart';
import 'ShipmentAcceptance.dart';

class CustomsOperation extends StatefulWidget {
  const CustomsOperation({super.key});

  @override
  State<CustomsOperation> createState() => _CustomsOperationState();
}

class _CustomsOperationState extends State<CustomsOperation> {
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
              'Landing Page',
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.only(top: 10, left: 20, right: 20),
              child: Material(
                color: Colors.transparent,
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
                                '  Customs Operations',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 22),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: DefaultTabController(
                length: 4,
                child: Column(
                  children: [
                    Container(
                      alignment: Alignment.centerLeft, // Ensure left alignment
                      child: const TabBar(

                        labelColor: MyColor.primaryColorblue,
                        unselectedLabelColor: Colors.grey,
                        indicatorColor: MyColor.primaryColorblue,
                        indicatorPadding: EdgeInsets.zero, // Remove indicator padding
                        tabs: [
                          Tab(text: 'Appointment Booking List'),
                          Tab(text: 'Accepted'),
                          Tab(text: 'Rejected'),
                          Tab(text: 'Available for Examination'),
                        ],
                      ),
                    ),
                    const Expanded(
                      child: TabBarView(
                        children: [
                          AppointmentBookingListView(),
                          AcceptedView(),
                          RejectedView(),
                          AvailableForExaminationView(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
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
}

class AppointmentBookingListView extends StatelessWidget {
  const AppointmentBookingListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColor.screenBgColor,
      body: SingleChildScrollView(
        child:Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 16),
          child: Column(
            children: [
              Container(
                width: MediaQuery.sizeOf(context).width,
                color: Color(0xffE4E7EB),
                padding: EdgeInsets.all(2.0),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    columns: const [
                      DataColumn(label: Text('Slot Date')),
                      DataColumn(label: Text('Slot Start-End Time')),
                      DataColumn(label: Text('Duration(Min)')),
                      DataColumn(label: Text('Station Name(s)')),
                      DataColumn(label: Text('Shipment Count')),
                      DataColumn(label: Text('Pieces')),
                      DataColumn(label: Text('Weight')),
                    ],
                    rows: const [
                      DataRow(cells: [
                        DataCell(Text('10')),
                        DataCell(Text('1000.00')),
                        DataCell(Text('KG')),
                        DataCell(Text('-')), // Assuming "-" for empty cells
                        DataCell(Text('01 AUG 2024 09:30')),
                        DataCell(Text('-')), // Assuming "-" for empty cells
                        DataCell(Text('-')), // Assuming "-" for empty cells
                      ]),
                    ],
                    headingRowColor:
                    WidgetStateProperty.resolveWith((states) => Color(0xffe6effc)),
                    dataRowColor:  WidgetStateProperty.resolveWith((states) => Color(0xfffafafa)),

                    dataRowHeight: 48.0,

                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AcceptedView extends StatelessWidget {
  const AcceptedView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Accepted View',
        style: TextStyle(fontSize: 18),
      ),
    );
  }
}

class RejectedView extends StatelessWidget {
  const RejectedView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Rejected View',
        style: TextStyle(fontSize: 18),
      ),
    );
  }
}

class AvailableForExaminationView extends StatelessWidget {
  const AvailableForExaminationView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Available for Examination View',
        style: TextStyle(fontSize: 18),
      ),
    );
  }
}
