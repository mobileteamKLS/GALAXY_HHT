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
                    padding:
                        const EdgeInsets.only(top: 10, left: 20, right: 20),
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
                                          fontWeight: FontWeight.bold,
                                          fontSize: 22),
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
                            alignment: Alignment.centerLeft,
                            // Ensure left alignment
                            child: const TabBar(
                              labelColor: MyColor.primaryColorblue,
                              unselectedLabelColor: Colors.grey,
                              indicatorColor: MyColor.primaryColorblue,
                              indicatorPadding: EdgeInsets.zero,
                              // Remove indicator padding
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
                                AppointmentBooking(),
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

class AppointmentBooking extends StatefulWidget {
  const AppointmentBooking({super.key});

  @override
  State<AppointmentBooking> createState() => _AppointmentBookingState();
}

class _AppointmentBookingState extends State<AppointmentBooking> {
  String? selectedDate = '01 Aug 2024';
  String? selectedTime = '10:00-11:00';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColor.screenBgColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Column(
            children: [
              Container(
                width: MediaQuery.sizeOf(context).width,
                color: Color(0xffE4E7EB),
                padding: EdgeInsets.all(2.0),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    columns: [
                      _buildDataColumn('Slot Date'),
                      _buildDataColumn('Slot Start-End Time'),
                      _buildDataColumn('Duration(Min)'),
                      _buildDataColumn('Station Name(s)'),
                      _buildDataColumn('Shipment Count'),
                      _buildDataColumn('Pieces'),
                      DataColumn(label: Center(child: Text('Weight'))),
                      // Last column without divider
                    ],
                    rows: [
                      DataRow(cells: [
                        DataCell(Center(
                            child: DropdownButtonFormField<String>(
                          value: selectedDate,
                          items: ['01 Aug 2024', '02 Aug 2024', '03 Aug 2024']
                              .map((value) => DropdownMenuItem(
                                    value: value,
                                    child: Text(value),
                                  ))
                              .toList(),
                          onChanged: (value) {
                            selectedDate = value;
                          },
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Color(0xffF5F8FA),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide.none, // No border
                            ),
                            // contentPadding: EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                          ),
                          icon: Icon(Icons.arrow_drop_down, color: Colors.blue),
                          style: TextStyle(fontSize: 16, color: Colors.black),
                          dropdownColor: Colors.white,
                        ))),
                        DataCell(Center(
                            child: DropdownButtonFormField<String>(
                          value: selectedTime,
                          items: ['10:00-11:00', '11:00-12:00', '12:00-13:00']
                              .map((value) => DropdownMenuItem(
                                    value: value,
                                    child: Text(value),
                                  ))
                              .toList(),
                          onChanged: (value) {
                            selectedTime = value;
                          },
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Color(0xffF5F8FA),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide.none, // No border
                            ),
                            // contentPadding: EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                          ),
                          icon: Icon(Icons.arrow_drop_down, color: Colors.blue),
                          style: TextStyle(fontSize: 16, color: Colors.black),
                          dropdownColor: Colors.white,
                        ))),
                        DataCell(Center(child: Text('60'))),
                        DataCell(Center(child: Text('-'))),
                        DataCell(Center(child: Text('10'))),
                        DataCell(Center(child: Text('-'))),
                        DataCell(Center(child: Text('-'))),
                      ]),
                    ],
                    headingRowColor: MaterialStateProperty.resolveWith(
                      (states) => Color(0xffe6effc),
                    ),
                    dataRowColor: MaterialStateProperty.resolveWith(
                      (states) => Color(0xfffafafa),
                    ),
                    dataRowHeight: 48.0,
                    columnSpacing: MediaQuery.sizeOf(context).width * 0.031,
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                width: MediaQuery.sizeOf(context).width,
                color: Color(0xffE4E7EB),
                padding: EdgeInsets.all(2.0),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    columns: const [
                      DataColumn(
                          label: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Accept \nAll',
                            style: TextStyle(
                              color: MyColor.primaryColorblue,
                              decoration: TextDecoration.underline,
                              decorationStyle: TextDecorationStyle.solid,
                              decorationColor: MyColor.primaryColorblue,
                              decorationThickness: 2,
                            ),
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          Text(
                            'Reject\n All',
                            style: TextStyle(color: Colors.red,
                              decoration: TextDecoration.underline,
                              decorationStyle: TextDecorationStyle.solid,
                              decorationColor: Colors.red,
                              decorationThickness: 2,
                            ),
                          )
                        ],
                      )),
                      DataColumn(label: Text('AWB No.\n')),
                      DataColumn(label: Text('HAWB No.\n')),
                      DataColumn(label: Text('Req. For Exam. (RFE) \n Pieces')),
                      DataColumn(label: Text('Remarks\n')),
                    ],
                    rows: [
                      _buildDataRow(
                        switchColor: Colors.blue,
                        awbNo: '176-12345454',
                        pieces: '10',
                        weight: '1000.00',
                        hawbNo: '-',
                        agent: 'AGT001',
                        remarks: 'Commodity PER',
                        isOn: true,
                      ),
                      _buildDataRow(
                        switchColor: Colors.red,
                        awbNo: '176-12345454',
                        pieces: '7',
                        weight: '700.00',
                        hawbNo: 'HAWB01',
                        agent: 'AGT002',
                        remarks: 'Commodity PER',
                        isOn: false,
                      ),
                    ],
                    dataRowHeight: 64.0,
                    headingRowColor: MaterialStateProperty.resolveWith(
                      (states) => Color(0xffE4E7EB),
                    ),
                    dataRowColor: MaterialStateProperty.resolveWith(
                      (states) => Color(0xfffafafa),
                    ),
                    columnSpacing: MediaQuery.sizeOf(context).width * 0.028,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  DataColumn _buildDataColumn(String label) {
    return DataColumn(
      label: Stack(
        alignment: Alignment.centerRight,
        children: [
          Center(child: Text(label)),
          Positioned(
            right: 0,
            child: Container(
              height: double.infinity,
              width: 1,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  DataRow _buildDataRow({
    required Color switchColor,
    required String awbNo,
    required String pieces,
    required String weight,
    required String hawbNo,
    required String agent,
    required String remarks,
    required bool isOn,
  }) {
    return DataRow(
      cells: [
        DataCell(
          Theme(
            data: ThemeData(useMaterial3: false),
            child: Switch(
              onChanged: (value) async {
                setState(() {});
              },
              value: isOn,
              activeColor: MyColor.primaryColorblue,
              activeTrackColor: Colors.grey,
              inactiveThumbColor: Colors.red,
            ),
          ),
        ),
        DataCell(Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(awbNo, style: TextStyle(fontWeight: FontWeight.bold)),
            Text('Pieces $pieces'),
          ],
        )),
        DataCell(Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(hawbNo),
            Text('Weight $weight'),
          ],
        )),
        DataCell(TextFormField(
          decoration: InputDecoration(
            hintText: 'Enter RFE Pieces',
            contentPadding:
                const EdgeInsets.symmetric(vertical: 0, horizontal: 15),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: MyColor.borderColor,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: MyColor.borderColor,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: MyColor.primaryColorblue,
              ),
            ),
          ),
        )),
        DataCell(SizedBox(
          width: MediaQuery.sizeOf(context).width * 0.3,
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Remarks here',
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 0, horizontal: 15),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: MyColor.borderColor,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: MyColor.borderColor,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: MyColor.primaryColorblue,
                ),
              ),
            ),
          ),
        )),
      ],
    );
  }

  Widget buildRow(
    BuildContext context, {
    required String awbNo,
    required String hawbNo,
    required String pieces,
    required String weight,
    required String agent,
    required String remarks,
    required bool isAccepted,
  }) {
    return Container(
      padding: EdgeInsets.all(8.0),
      color: Color(0xFFF5F8FA), // Background color for rows
      child: Row(
        children: [
          // Accept/Reject Toggle
          Expanded(
            child: Center(
              child: Switch(
                value: isAccepted,
                activeColor: Colors.blue,
                inactiveThumbColor: Colors.red,
                onChanged: (value) {
                  // Handle switch change
                },
              ),
            ),
          ),
          // AWB No. and details
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(awbNo, style: TextStyle(fontWeight: FontWeight.bold)),
                Row(
                  children: [
                    Text("Pieces ", style: TextStyle(color: Colors.grey)),
                    Text(pieces, style: TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
              ],
            ),
          ),
          // HAWB No.
          Expanded(
            flex: 2,
            child: Column(
              children: [
                Center(
                  child: Text(hawbNo, style: TextStyle(color: Colors.black)),
                ),
                Row(
                  children: [
                    Text("Weight ", style: TextStyle(color: Colors.grey)),
                    Text(weight, style: TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
              ],
            ),
          ),
          // RFE Input Field
          Expanded(
            flex: 2,
            child: TextField(
              decoration: InputDecoration(
                hintText: "Enter RFE Pieces",
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4.0)),
                contentPadding: EdgeInsets.symmetric(horizontal: 8.0),
              ),
            ),
          ),
          // Remarks
          Expanded(
            flex: 2,
            child: TextField(
              decoration: InputDecoration(
                hintText: "Remarks here",
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4.0)),
                contentPadding: EdgeInsets.symmetric(horizontal: 8.0),
              ),
            ),
          ),
          // Agent and Remarks
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Agent ", style: TextStyle(color: Colors.grey)),
                Text(agent, style: TextStyle(fontWeight: FontWeight.bold)),
                Text(remarks, style: TextStyle(color: Colors.grey)),
              ],
            ),
          ),
        ],
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
