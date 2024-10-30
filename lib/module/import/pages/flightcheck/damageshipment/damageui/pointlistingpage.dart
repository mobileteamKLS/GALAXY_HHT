import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:galaxy/module/import/model/flightcheck/awblistmodel.dart';

import '../../../../../../core/images.dart';
import '../../../../../../core/mycolor.dart';
import '../../../../../../language/appLocalizations.dart';
import '../../../../../../language/model/lableModel.dart';
import '../../../../../../manager/timermanager.dart';
import '../../../../../../utils/awbformatenumberutils.dart';
import '../../../../../../utils/commonutils.dart';
import '../../../../../../utils/sizeutils.dart';
import '../../../../../../widget/customdivider.dart';
import '../../../../../../widget/customebuttons/roundbuttonblue.dart';
import '../../../../../../widget/custometext.dart';
import '../../../../../../widget/customeuiwidgets/header.dart';
import '../../../../../../widget/customtextfield.dart';
import '../../../../../onboarding/sizeconfig.dart';
import 'dart:ui' as ui;

class PointListingPage extends StatefulWidget {

  final VoidCallback preclickCallback;
  final VoidCallback nextclickCallback;
  final Function(int) curruentCallback;
  InactivityTimerManager? inactivityTimerManager;
  PointListingPage({super.key, required this.preclickCallback, required this.nextclickCallback, required this.curruentCallback, required this.inactivityTimerManager});

  @override
  State<PointListingPage> createState() => _PointListingPageState();
}

class _PointListingPageState extends State<PointListingPage> {



  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }

  @override
  void dispose() {
    // Dispose of controllers and focus nodes
    super.dispose();
    widget.inactivityTimerManager!.stopTimer();
  }



  @override
  Widget build(BuildContext context) {

    AppLocalizations? localizations = AppLocalizations.of(context);
    LableModel? lableModel = localizations!.lableModel;

    //ui direction not change for arabic
    ui.TextDirection uiDirection =
    localizations.locale.languageCode == CommonUtils.ARABICCULTURECODE
        ? ui.TextDirection.ltr
        : ui.TextDirection.ltr;

    //text direction change for arabic
    ui.TextDirection textDirection =
    localizations.locale.languageCode == CommonUtils.ARABICCULTURECODE
        ? ui.TextDirection.rtl
        : ui.TextDirection.ltr;


    return Column(
      children: [
        HeaderWidget(
          titleTextColor: MyColor.colorBlack,
          title: "Damage & Save",
          onBack: () {
            widget.inactivityTimerManager!.stopTimer();
            Navigator.pop(context, "Done");
          },
          clearText: "",
          onClear: () {

          },
        ),
        SizedBox(height: SizeConfig.blockSizeVertical),
        Expanded(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 0,
                  right: 0,
                  top: 0,
                  bottom: 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(10),

                    decoration: BoxDecoration(
                      color: MyColor.colorWhite,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: MyColor.colorBlack.withOpacity(0.09),
                          spreadRadius: 2,
                          blurRadius: 15,
                          offset: Offset(0, 3), // changes position of shadow
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: InkWell(
                            onTap: () {
                              widget.nextclickCallback();
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [

                                Row(
                                  children: [
                                    CustomeText(
                                        text: "C)",
                                        fontColor: MyColor.textColorGrey3,
                                        fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_4,
                                        fontWeight: FontWeight.w600,
                                        textAlign: TextAlign.start),

                                    SizedBox(width: 5,),

                                    CustomeText(
                                        text: "PACKING DETAILS",
                                        fontColor: MyColor.textColorGrey3,
                                        fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_4,
                                        fontWeight: FontWeight.w600,
                                        textAlign: TextAlign.start),
                                  ],
                                ),



                                Container(
                                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 8),
                                  decoration: BoxDecoration(
                                      color: MyColor.dropdownColor,
                                      borderRadius: BorderRadius.circular(SizeConfig.blockSizeHorizontal * SizeUtils.WIDTH3)
                                  ),
                                  child: Icon(Icons.navigate_next_rounded, color: MyColor.primaryColorblue, size: SizeConfig.blockSizeVertical * SizeUtils.ICONSIZE_2_5,),
                                ),

                              ],
                            ),
                          ),
                        ),

                        CustomDivider(space: 0, color: Colors.black, hascolor: true,),



                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: InkWell(
                            onTap: () {
                              widget.nextclickCallback();
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [

                                Padding(
                                  padding: const EdgeInsets.only(left: 20),
                                  child: Row(
                                    children: [
                                      CustomeText(
                                          text: "9)",
                                          fontColor: MyColor.textColorGrey3,
                                          fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                          fontWeight: FontWeight.w600,
                                          textAlign: TextAlign.start),

                                      SizedBox(width: 5,),

                                      CustomeText(
                                          text: "Container",
                                          fontColor: MyColor.textColorGrey3,
                                          fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                          fontWeight: FontWeight.w600,
                                          textAlign: TextAlign.start),
                                    ],
                                  ),
                                ),


                                Container(
                                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 8),
                                  decoration: BoxDecoration(
                                      color: MyColor.dropdownColor,
                                      borderRadius: BorderRadius.circular(SizeConfig.blockSizeHorizontal * SizeUtils.WIDTH3)
                                  ),
                                  child: Icon(Icons.navigate_next_rounded, color: MyColor.primaryColorblue, size: SizeConfig.blockSizeVertical * SizeUtils.ICONSIZE_2_5,),
                                ),
                              ],
                            ),
                          ),
                        ),


                        CustomDivider(space: 0, color: Colors.black, hascolor: true,),


                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: InkWell(
                            onTap: () {
                              widget.nextclickCallback();
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [


                                Padding(
                                  padding: const EdgeInsets.only(left: 40),
                                  child: Row(
                                    children: [
                                      CustomeText(
                                          text: "a)",
                                          fontColor: MyColor.textColorGrey3,
                                          fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                          fontWeight: FontWeight.w600,
                                          textAlign: TextAlign.start),

                                      SizedBox(width: 5,),

                                      CustomeText(
                                          text: "Material",
                                          fontColor: MyColor.textColorGrey3,
                                          fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                          fontWeight: FontWeight.w600,
                                          textAlign: TextAlign.start),
                                    ],
                                  ),
                                ),


                                Container(
                                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 8),
                                  decoration: BoxDecoration(
                                      color: MyColor.dropdownColor,
                                      borderRadius: BorderRadius.circular(SizeConfig.blockSizeHorizontal * SizeUtils.WIDTH3)
                                  ),
                                  child: Icon(Icons.navigate_next_rounded, color: MyColor.primaryColorblue, size: SizeConfig.blockSizeVertical * SizeUtils.ICONSIZE_2_5,),
                                ),
                              ],
                            ),
                          ),
                        ),


                        CustomDivider(space: 0, color: Colors.black, hascolor: true,),

                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: InkWell(
                            onTap: () {
                              widget.nextclickCallback();
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [

                                Padding(
                                  padding: const EdgeInsets.only(left: 40),
                                  child: Row(
                                    children: [
                                      CustomeText(
                                          text: "b)",
                                          fontColor: MyColor.textColorGrey3,
                                          fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                          fontWeight: FontWeight.w600,
                                          textAlign: TextAlign.start),

                                      SizedBox(width: 5,),

                                      CustomeText(
                                          text: "Type",
                                          fontColor: MyColor.textColorGrey3,
                                          fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                          fontWeight: FontWeight.w600,
                                          textAlign: TextAlign.start),
                                    ],
                                  ),
                                ),


                                Container(
                                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 8),
                                  decoration: BoxDecoration(
                                      color: MyColor.dropdownColor,
                                      borderRadius: BorderRadius.circular(SizeConfig.blockSizeHorizontal * SizeUtils.WIDTH3)
                                  ),
                                  child: Icon(Icons.navigate_next_rounded, color: MyColor.primaryColorblue, size: SizeConfig.blockSizeVertical * SizeUtils.ICONSIZE_2_5,),
                                ),
                              ],
                            ),
                          ),
                        ),


                        CustomDivider(space: 0, color: Colors.black, hascolor: true,),

                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: InkWell(
                            onTap: () {
                              widget.curruentCallback(3);
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [

                                Padding(
                                  padding: const EdgeInsets.only(left: 12),
                                  child: Row(
                                    children: [
                                      CustomeText(
                                          text: "10)",
                                          fontColor: MyColor.textColorGrey3,
                                          fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                          fontWeight: FontWeight.w600,
                                          textAlign: TextAlign.start),

                                      SizedBox(width: 5,),

                                      CustomeText(
                                          text: "Mark & Label",
                                          fontColor: MyColor.textColorGrey3,
                                          fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                          fontWeight: FontWeight.w600,
                                          textAlign: TextAlign.start),
                                    ],
                                  ),
                                ),


                                Container(
                                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 8),
                                  decoration: BoxDecoration(
                                      color: MyColor.dropdownColor,
                                      borderRadius: BorderRadius.circular(SizeConfig.blockSizeHorizontal * SizeUtils.WIDTH3)
                                  ),
                                  child: Icon(Icons.navigate_next_rounded, color: MyColor.primaryColorblue, size: SizeConfig.blockSizeVertical * SizeUtils.ICONSIZE_2_5,),
                                ),
                              ],
                            ),
                          ),
                        ),


                        CustomDivider(space: 0, color: Colors.black, hascolor: true,),

                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: InkWell(
                            onTap: () {
                              widget.curruentCallback(4);
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [

                                Padding(
                                  padding: const EdgeInsets.only(left: 12),
                                  child: Row(
                                    children: [
                                      CustomeText(
                                          text: "11)",
                                          fontColor: MyColor.textColorGrey3,
                                          fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                          fontWeight: FontWeight.w600,
                                          textAlign: TextAlign.start),

                                      SizedBox(width: 5,),

                                      CustomeText(
                                          text: "Outer Packing",
                                          fontColor: MyColor.textColorGrey3,
                                          fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                          fontWeight: FontWeight.w600,
                                          textAlign: TextAlign.start),
                                    ],
                                  ),
                                ),


                                Container(
                                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 8),
                                  decoration: BoxDecoration(
                                      color: MyColor.dropdownColor,
                                      borderRadius: BorderRadius.circular(SizeConfig.blockSizeHorizontal * SizeUtils.WIDTH3)
                                  ),
                                  child: Icon(Icons.navigate_next_rounded, color: MyColor.primaryColorblue, size: SizeConfig.blockSizeVertical * SizeUtils.ICONSIZE_2_5,),
                                ),
                              ],
                            ),
                          ),
                        ),


                        CustomDivider(space: 0, color: Colors.black, hascolor: true,),

                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: InkWell(
                            onTap: () {
                              widget.curruentCallback(5);
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [

                                Padding(
                                  padding: const EdgeInsets.only(left: 12),
                                  child: Row(
                                    children: [
                                      CustomeText(
                                          text: "12)",
                                          fontColor: MyColor.textColorGrey3,
                                          fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                          fontWeight: FontWeight.w600,
                                          textAlign: TextAlign.start),

                                      SizedBox(width: 5,),

                                      CustomeText(
                                          text: "Inner Packing",
                                          fontColor: MyColor.textColorGrey3,
                                          fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                          fontWeight: FontWeight.w600,
                                          textAlign: TextAlign.start),
                                    ],
                                  ),
                                ),


                                Container(
                                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 8),
                                  decoration: BoxDecoration(
                                      color: MyColor.dropdownColor,
                                      borderRadius: BorderRadius.circular(SizeConfig.blockSizeHorizontal * SizeUtils.WIDTH3)
                                  ),
                                  child: Icon(Icons.navigate_next_rounded, color: MyColor.primaryColorblue, size: SizeConfig.blockSizeVertical * SizeUtils.ICONSIZE_2_5,),
                                ),
                              ],
                            ),
                          ),
                        ),


                        CustomDivider(space: 0, color: Colors.black, hascolor: true,),

                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: InkWell(
                            onTap: () {
                              widget.curruentCallback(6);
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [

                                Row(
                                  children: [
                                    CustomeText(
                                        text: "D)",
                                        fontColor: MyColor.textColorGrey3,
                                        fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_4,
                                        fontWeight: FontWeight.w600,
                                        textAlign: TextAlign.start),

                                    SizedBox(width: 5,),

                                    CustomeText(
                                        text: "DETAILS OF DAMAGE OBSERVED",
                                        fontColor: MyColor.textColorGrey3,
                                        fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_4,
                                        fontWeight: FontWeight.w600,
                                        textAlign: TextAlign.start),
                                  ],
                                ),


                                Container(
                                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 8),
                                  decoration: BoxDecoration(
                                      color: MyColor.dropdownColor,
                                      borderRadius: BorderRadius.circular(SizeConfig.blockSizeHorizontal * SizeUtils.WIDTH3)
                                  ),
                                  child: Icon(Icons.navigate_next_rounded, color: MyColor.primaryColorblue, size: SizeConfig.blockSizeVertical * SizeUtils.ICONSIZE_2_5,),
                                ),
                              ],
                            ),
                          ),
                        ),


                        CustomDivider(space: 0, color: Colors.black, hascolor: true,),

                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: InkWell(
                            onTap: () {
                              widget.curruentCallback(6);
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [

                                Padding(
                                  padding: const EdgeInsets.only(left: 12),
                                  child: Row(
                                    children: [
                                      CustomeText(
                                          text: "13.a)",
                                          fontColor: MyColor.textColorGrey3,
                                          fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                          fontWeight: FontWeight.w600,
                                          textAlign: TextAlign.start),

                                      SizedBox(width: 5,),

                                      CustomeText(
                                          text: "Content",
                                          fontColor: MyColor.textColorGrey3,
                                          fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                          fontWeight: FontWeight.w600,
                                          textAlign: TextAlign.start),
                                    ],
                                  ),
                                ),


                                Container(
                                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 8),
                                  decoration: BoxDecoration(
                                      color: MyColor.dropdownColor,
                                      borderRadius: BorderRadius.circular(SizeConfig.blockSizeHorizontal * SizeUtils.WIDTH3)
                                  ),
                                  child: Icon(Icons.navigate_next_rounded, color: MyColor.primaryColorblue, size: SizeConfig.blockSizeVertical * SizeUtils.ICONSIZE_2_5,),
                                ),
                              ],
                            ),
                          ),
                        ),


                        CustomDivider(space: 0, color: Colors.black, hascolor: true,),

                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: InkWell(
                            onTap: () {
                              widget.curruentCallback(7);
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [

                                Padding(
                                  padding: const EdgeInsets.only(left: 12),
                                  child: Row(
                                    children: [
                                      CustomeText(
                                          text: "13.b)",
                                          fontColor: MyColor.textColorGrey3,
                                          fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                          fontWeight: FontWeight.w600,
                                          textAlign: TextAlign.start),

                                      SizedBox(width: 5,),

                                      CustomeText(
                                          text: "Containers",
                                          fontColor: MyColor.textColorGrey3,
                                          fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                          fontWeight: FontWeight.w600,
                                          textAlign: TextAlign.start),
                                    ],
                                  ),
                                ),


                                Container(
                                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 8),
                                  decoration: BoxDecoration(
                                      color: MyColor.dropdownColor,
                                      borderRadius: BorderRadius.circular(SizeConfig.blockSizeHorizontal * SizeUtils.WIDTH3)
                                  ),
                                  child: Icon(Icons.navigate_next_rounded, color: MyColor.primaryColorblue, size: SizeConfig.blockSizeVertical * SizeUtils.ICONSIZE_2_5,),
                                ),
                              ],
                            ),
                          ),
                        ),


                        CustomDivider(space: 0, color: Colors.black, hascolor: true,),

                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: InkWell(
                            onTap: () {
                              widget.curruentCallback(8);
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [

                                Padding(
                                  padding: const EdgeInsets.only(left: 24),
                                  child: Row(
                                    children: [
                                      CustomeText(
                                          text: "14)",
                                          fontColor: MyColor.textColorGrey3,
                                          fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                          fontWeight: FontWeight.w600,
                                          textAlign: TextAlign.start),

                                      SizedBox(width: 5,),

                                      CustomeText(
                                          text: "Damage Discovered",
                                          fontColor: MyColor.textColorGrey3,
                                          fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                          fontWeight: FontWeight.w600,
                                          textAlign: TextAlign.start),
                                    ],
                                  ),
                                ),



                                Container(
                                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 8),
                                  decoration: BoxDecoration(
                                      color: MyColor.dropdownColor,
                                      borderRadius: BorderRadius.circular(SizeConfig.blockSizeHorizontal * SizeUtils.WIDTH3)
                                  ),
                                  child: Icon(Icons.navigate_next_rounded, color: MyColor.primaryColorblue, size: SizeConfig.blockSizeVertical * SizeUtils.ICONSIZE_2_5,),
                                ),
                              ],
                            ),
                          ),
                        ),


                        CustomDivider(space: 0, color: Colors.black, hascolor: true,),

                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: InkWell(
                            onTap: () {
                              widget.curruentCallback(9);
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [

                                Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: Row(
                                    children: [
                                      CustomeText(
                                          text: "15.a)",
                                          fontColor: MyColor.textColorGrey3,
                                          fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                          fontWeight: FontWeight.w600,
                                          textAlign: TextAlign.start),

                                      SizedBox(width:5,),

                                      CustomeText(
                                          text: "Any Space For Missing Items",
                                          fontColor: MyColor.textColorGrey3,
                                          fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                          fontWeight: FontWeight.w600,
                                          textAlign: TextAlign.start),
                                    ],
                                  ),
                                ),


                                Container(
                                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 8),
                                  decoration: BoxDecoration(
                                      color: MyColor.dropdownColor,
                                      borderRadius: BorderRadius.circular(SizeConfig.blockSizeHorizontal * SizeUtils.WIDTH3)
                                  ),
                                  child: Icon(Icons.navigate_next_rounded, color: MyColor.primaryColorblue, size: SizeConfig.blockSizeVertical * SizeUtils.ICONSIZE_2_5,),
                                ),
                              ],
                            ),
                          ),
                        ),


                        CustomDivider(space: 0, color: Colors.black, hascolor: true,),

                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: InkWell(
                            onTap: () {
                              widget.curruentCallback(9);
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [

                                Padding(
                                  padding: const EdgeInsets.only(left: 32),
                                  child: Row(
                                    children: [
                                      CustomeText(
                                          text: "b)",
                                          fontColor: MyColor.textColorGrey3,
                                          fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                          fontWeight: FontWeight.w600,
                                          textAlign: TextAlign.start),

                                      SizedBox(width: 5,),

                                      CustomeText(
                                          text: "Is Shortage Verified By Invoice",
                                          fontColor: MyColor.textColorGrey3,
                                          fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                          fontWeight: FontWeight.w600,
                                          textAlign: TextAlign.start),
                                    ],
                                  ),
                                ),


                                Container(
                                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 8),
                                  decoration: BoxDecoration(
                                      color: MyColor.dropdownColor,
                                      borderRadius: BorderRadius.circular(SizeConfig.blockSizeHorizontal * SizeUtils.WIDTH3)
                                  ),
                                  child: Icon(Icons.navigate_next_rounded, color: MyColor.primaryColorblue, size: SizeConfig.blockSizeVertical * SizeUtils.ICONSIZE_2_5,),
                                ),
                              ],
                            ),
                          ),
                        ),


                        CustomDivider(space: 0, color: Colors.black, hascolor: true,),


                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: InkWell(
                            onTap: () {
                              widget.curruentCallback(9);
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [

                                Padding(
                                  padding: const EdgeInsets.only(left: 24),
                                  child: Row(
                                    children: [
                                      CustomeText(
                                          text: "16)",
                                          fontColor: MyColor.textColorGrey3,
                                          fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                          fontWeight: FontWeight.w600,
                                          textAlign: TextAlign.start),

                                      SizedBox(width: 5,),

                                      CustomeText(
                                          text: "Is Packing Sufficient?",
                                          fontColor: MyColor.textColorGrey3,
                                          fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                          fontWeight: FontWeight.w600,
                                          textAlign: TextAlign.start),
                                    ],
                                  ),
                                ),




                                Container(
                                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 8),
                                  decoration: BoxDecoration(
                                      color: MyColor.dropdownColor,
                                      borderRadius: BorderRadius.circular(SizeConfig.blockSizeHorizontal * SizeUtils.WIDTH3)
                                  ),
                                  child: Icon(Icons.navigate_next_rounded, color: MyColor.primaryColorblue, size: SizeConfig.blockSizeVertical * SizeUtils.ICONSIZE_2_5,),
                                ),
                              ],
                            ),
                          ),
                        ),


                        CustomDivider(space: 0, color: Colors.black, hascolor: true,),


                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: InkWell(
                            onTap: () {
                              widget.curruentCallback(9);
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [

                                Padding(
                                  padding: const EdgeInsets.only(left: 24),
                                  child: Row(
                                    children: [
                                      CustomeText(
                                          text: "17)",
                                          fontColor: MyColor.textColorGrey3,
                                          fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                          fontWeight: FontWeight.w600,
                                          textAlign: TextAlign.start),

                                      SizedBox(width: 5,),

                                      CustomeText(
                                          text: "Any Evidence Of Pilferage",
                                          fontColor: MyColor.textColorGrey3,
                                          fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                          fontWeight: FontWeight.w600,
                                          textAlign: TextAlign.start),
                                    ],
                                  ),
                                ),



                                Container(
                                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 8),
                                  decoration: BoxDecoration(
                                      color: MyColor.dropdownColor,
                                      borderRadius: BorderRadius.circular(SizeConfig.blockSizeHorizontal * SizeUtils.WIDTH3)
                                  ),
                                  child: Icon(Icons.navigate_next_rounded, color: MyColor.primaryColorblue, size: SizeConfig.blockSizeVertical * SizeUtils.ICONSIZE_2_5,),
                                ),
                              ],
                            ),
                          ),
                        ),


                        CustomDivider(space: 0, color: Colors.black, hascolor: true,),


                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: InkWell(
                            onTap: () {
                              widget.curruentCallback(9);
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [

                                Padding(
                                  padding: const EdgeInsets.only(left: 24),
                                  child: Row(
                                    children: [
                                      CustomeText(
                                          text: "18)",
                                          fontColor: MyColor.textColorGrey3,
                                          fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                          fontWeight: FontWeight.w600,
                                          textAlign: TextAlign.start),

                                      SizedBox(width: 5,),

                                      CustomeText(
                                          text: "Remarks",
                                          fontColor: MyColor.textColorGrey3,
                                          fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                          fontWeight: FontWeight.w600,
                                          textAlign: TextAlign.start),
                                    ],
                                  ),
                                ),


                                Container(
                                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 8),
                                  decoration: BoxDecoration(
                                      color: MyColor.dropdownColor,
                                      borderRadius: BorderRadius.circular(SizeConfig.blockSizeHorizontal * SizeUtils.WIDTH3)
                                  ),
                                  child: Icon(Icons.navigate_next_rounded, color: MyColor.primaryColorblue, size: SizeConfig.blockSizeVertical * SizeUtils.ICONSIZE_2_5,),
                                ),
                              ],
                            ),
                          ),
                        ),


                        CustomDivider(space: 0, color: Colors.black, hascolor: true,),


                        Padding(
                          padding: const EdgeInsets.only(left: 33.0, bottom: 8, top: 8, right: 8),
                          child: InkWell(
                            onTap: () {
                              widget.curruentCallback(10);
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [

                                Flexible(
                                  child: Row(
                                    children: [
                                      CustomeText(
                                          text: "19)",
                                          fontColor: MyColor.textColorGrey3,
                                          fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                          fontWeight: FontWeight.w600,
                                          textAlign: TextAlign.start),

                                      SizedBox(width: 5,),

                                      Flexible(
                                        child: CustomeText(
                                            text: "The Damage Apparently Caused By",
                                            fontColor: MyColor.textColorGrey3,
                                            fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                            fontWeight: FontWeight.w600,
                                            textAlign: TextAlign.start),
                                      ),
                                    ],
                                  ),
                                ),


                                Container(
                                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 8),
                                  decoration: BoxDecoration(
                                      color: MyColor.dropdownColor,
                                      borderRadius: BorderRadius.circular(SizeConfig.blockSizeHorizontal * SizeUtils.WIDTH3)
                                  ),
                                  child: Icon(Icons.navigate_next_rounded, color: MyColor.primaryColorblue, size: SizeConfig.blockSizeVertical * SizeUtils.ICONSIZE_2_5,),
                                ),
                              ],
                            ),
                          ),
                        ),




                        CustomDivider(space: 0, color: Colors.black, hascolor: true,),


                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: InkWell(
                            onTap: () {
                              widget.curruentCallback(11);
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [

                                Row(
                                  children: [
                                    CustomeText(
                                        text: "E)",
                                        fontColor: MyColor.textColorGrey3,
                                        fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_4,
                                        fontWeight: FontWeight.w600,
                                        textAlign: TextAlign.start),

                                    SizedBox(width: 8,),

                                    CustomeText(
                                        text: "ACTION TAKEN",
                                        fontColor: MyColor.textColorGrey3,
                                        fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_4,
                                        fontWeight: FontWeight.w600,
                                        textAlign: TextAlign.start),
                                  ],
                                ),


                                Container(
                                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 8),
                                  decoration: BoxDecoration(
                                      color: MyColor.dropdownColor,
                                      borderRadius: BorderRadius.circular(SizeConfig.blockSizeHorizontal * SizeUtils.WIDTH3)
                                  ),
                                  child: Icon(Icons.navigate_next_rounded, color: MyColor.primaryColorblue, size: SizeConfig.blockSizeVertical * SizeUtils.ICONSIZE_2_5,),
                                ),
                              ],
                            ),
                          ),
                        ),


                        CustomDivider(space: 0, color: Colors.black, hascolor: true,),


                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: InkWell(
                            onTap: () {
                              widget.curruentCallback(11);
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [


                                Padding(
                                  padding: const EdgeInsets.only(left: 24),
                                  child: Row(
                                    children: [
                                      CustomeText(
                                          text: "20)",
                                          fontColor: MyColor.textColorGrey3,
                                          fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                          fontWeight: FontWeight.w600,
                                          textAlign: TextAlign.start),

                                      SizedBox(width: 5,),

                                      CustomeText(
                                          text: "Salvage Action",
                                          fontColor: MyColor.textColorGrey3,
                                          fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                          fontWeight: FontWeight.w600,
                                          textAlign: TextAlign.start),
                                    ],
                                  ),
                                ),

                                Container(
                                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 8),
                                  decoration: BoxDecoration(
                                      color: MyColor.dropdownColor,
                                      borderRadius: BorderRadius.circular(SizeConfig.blockSizeHorizontal * SizeUtils.WIDTH3)
                                  ),
                                  child: Icon(Icons.navigate_next_rounded, color: MyColor.primaryColorblue, size: SizeConfig.blockSizeVertical * SizeUtils.ICONSIZE_2_5,),
                                ),
                              ],
                            ),
                          ),
                        ),


                        CustomDivider(space: 0, color: Colors.black, hascolor: true,),

                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: InkWell(
                            onTap: () {
                              widget.curruentCallback(11);
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [

                                Padding(
                                  padding: const EdgeInsets.only(left: 24),
                                  child: Row(
                                    children: [
                                      CustomeText(
                                          text: "21)",
                                          fontColor: MyColor.textColorGrey3,
                                          fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                          fontWeight: FontWeight.w600,
                                          textAlign: TextAlign.start),

                                      SizedBox(width: 5,),

                                      CustomeText(
                                          text: "Disposition",
                                          fontColor: MyColor.textColorGrey3,
                                          fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                          fontWeight: FontWeight.w600,
                                          textAlign: TextAlign.start),
                                    ],
                                  ),
                                ),


                                Container(
                                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 8),
                                  decoration: BoxDecoration(
                                      color: MyColor.dropdownColor,
                                      borderRadius: BorderRadius.circular(SizeConfig.blockSizeHorizontal * SizeUtils.WIDTH3)
                                  ),
                                  child: Icon(Icons.navigate_next_rounded, color: MyColor.primaryColorblue, size: SizeConfig.blockSizeVertical * SizeUtils.ICONSIZE_2_5,),
                                ),
                              ],
                            ),
                          ),
                        ),


                        CustomDivider(space: 0, color: Colors.black, hascolor: true,),

                        Padding(
                          padding: const EdgeInsets.only(left: 33, right: 8.0, top: 8, bottom: 8),
                          child: InkWell(
                            onTap: () {
                              widget.curruentCallback(12);
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [

                                Flexible(
                                  child: Row(
                                    children: [
                                      CustomeText(
                                          text: "22)",
                                          fontColor: MyColor.textColorGrey3,
                                          fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                          fontWeight: FontWeight.w600,
                                          textAlign: TextAlign.start),

                                      SizedBox(width: 5,),

                                      Flexible(
                                        child: CustomeText(
                                            text: "Any damage remarked in : a) The AWB. b) The Manifest",
                                            fontColor: MyColor.textColorGrey3,
                                            fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                            fontWeight: FontWeight.w600,
                                            textAlign: TextAlign.start),
                                      ),
                                    ],
                                  ),
                                ),


                                Container(
                                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 8),
                                  decoration: BoxDecoration(
                                      color: MyColor.dropdownColor,
                                      borderRadius: BorderRadius.circular(SizeConfig.blockSizeHorizontal * SizeUtils.WIDTH3)
                                  ),
                                  child: Icon(Icons.navigate_next_rounded, color: MyColor.primaryColorblue, size: SizeConfig.blockSizeVertical * SizeUtils.ICONSIZE_2_5,),
                                ),
                              ],
                            ),
                          ),
                        ),


                        CustomDivider(space: 0, color: Colors.black, hascolor: true,),

                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: InkWell(
                            onTap: () {
                              widget.curruentCallback(12);
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [


                                Padding(
                                  padding: const EdgeInsets.only(left: 24),
                                  child: Row(
                                    children: [
                                      CustomeText(
                                          text: "23)",
                                          fontColor: MyColor.textColorGrey3,
                                          fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                          fontWeight: FontWeight.w600,
                                          textAlign: TextAlign.start),

                                      SizedBox(width: 5,),

                                      CustomeText(
                                          text: "Weather Condition ?",
                                          fontColor: MyColor.textColorGrey3,
                                          fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                          fontWeight: FontWeight.w600,
                                          textAlign: TextAlign.start),
                                    ],
                                  ),
                                ),

                                Container(
                                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 8),
                                  decoration: BoxDecoration(
                                      color: MyColor.dropdownColor,
                                      borderRadius: BorderRadius.circular(SizeConfig.blockSizeHorizontal * SizeUtils.WIDTH3)
                                  ),
                                  child: Icon(Icons.navigate_next_rounded, color: MyColor.primaryColorblue, size: SizeConfig.blockSizeVertical * SizeUtils.ICONSIZE_2_5,),
                                ),
                              ],
                            ),
                          ),
                        ),


                        CustomDivider(space: 0, color: Colors.black, hascolor: true,),

                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: InkWell(
                            onTap: () {
                              widget.curruentCallback(12);
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [

                                Padding(
                                  padding: const EdgeInsets.only(left: 24),
                                  child: Row(
                                    children: [
                                      CustomeText(
                                          text: "24)",
                                          fontColor: MyColor.textColorGrey3,
                                          fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                          fontWeight: FontWeight.w600,
                                          textAlign: TextAlign.start),

                                      SizedBox(width: 5,),

                                      CustomeText(
                                          text: "Representative",
                                          fontColor: MyColor.textColorGrey3,
                                          fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                          fontWeight: FontWeight.w600,
                                          textAlign: TextAlign.start),
                                    ],
                                  ),
                                ),


                                Container(
                                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 8),
                                  decoration: BoxDecoration(
                                      color: MyColor.dropdownColor,
                                      borderRadius: BorderRadius.circular(SizeConfig.blockSizeHorizontal * SizeUtils.WIDTH3)
                                  ),
                                  child: Icon(Icons.navigate_next_rounded, color: MyColor.primaryColorblue, size: SizeConfig.blockSizeVertical * SizeUtils.ICONSIZE_2_5,),
                                ),
                              ],
                            ),
                          ),
                        ),

                        CustomDivider(space: 0, color: Colors.black, hascolor: true,),

                      ],
                    ),
                  )






                ],
              ),
            ),
          ),
        ),
        SizedBox(height: SizeConfig.blockSizeVertical),
        Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: MyColor.colorWhite,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: MyColor.colorBlack.withOpacity(0.09),
                spreadRadius: 2,
                blurRadius: 15,
                offset: Offset(0, 3), // changes position of shadow
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: RoundedButtonBlue(
                  text: "Previous",
                  press: () async {
                    widget.preclickCallback();
                  },
                ),
              ),
              SizedBox(
                width: SizeConfig.blockSizeHorizontal * SizeUtils.WIDTH4,
              ),
              Expanded(
                flex: 1,
                child: RoundedButtonBlue(
                  text: "Next",
                  press: () async {
                    widget.nextclickCallback();
                  },
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
