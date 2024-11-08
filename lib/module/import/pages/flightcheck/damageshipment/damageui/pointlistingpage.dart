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
        Directionality(
          textDirection: uiDirection,
          child: HeaderWidget(
            titleTextColor: MyColor.colorBlack,
            title: "${lableModel!.damageAndSave}",
            onBack: () {
              widget.inactivityTimerManager!.stopTimer();
              Navigator.pop(context, "Done");
            },
            clearText: "",
            onClear: () {

            },
          ),
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
                                        text: "${lableModel.c}",
                                        fontColor: MyColor.textColorGrey3,
                                        fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_4,
                                        fontWeight: FontWeight.w600,
                                        textAlign: TextAlign.start),

                                    SizedBox(width: 5,),

                                    CustomeText(
                                        text: "${lableModel.packingDetails}",
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
                                          text: "${lableModel.s9}",
                                          fontColor: MyColor.textColorGrey3,
                                          fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                          fontWeight: FontWeight.w600,
                                          textAlign: TextAlign.start),

                                      SizedBox(width: 5,),

                                      CustomeText(
                                          text: "${lableModel.container}",
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
                                          text: "${lableModel.a}",
                                          fontColor: MyColor.textColorGrey3,
                                          fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                          fontWeight: FontWeight.w600,
                                          textAlign: TextAlign.start),

                                      SizedBox(width: 5,),

                                      CustomeText(
                                          text: "${lableModel.material}",
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
                                          text: "${lableModel.b}",
                                          fontColor: MyColor.textColorGrey3,
                                          fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                          fontWeight: FontWeight.w600,
                                          textAlign: TextAlign.start),

                                      SizedBox(width: 5,),

                                      CustomeText(
                                          text: "${lableModel.type}",
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
                                          text: "${lableModel.s10}",
                                          fontColor: MyColor.textColorGrey3,
                                          fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                          fontWeight: FontWeight.w600,
                                          textAlign: TextAlign.start),

                                      SizedBox(width: 5,),

                                      CustomeText(
                                          text:"${lableModel.markAndLabel}",
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
                                          text: "${lableModel.s11}",
                                          fontColor: MyColor.textColorGrey3,
                                          fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                          fontWeight: FontWeight.w600,
                                          textAlign: TextAlign.start),

                                      SizedBox(width: 5,),

                                      CustomeText(
                                          text: "${lableModel.outerPacking}",
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
                                          text: "${lableModel.s12}",
                                          fontColor: MyColor.textColorGrey3,
                                          fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                          fontWeight: FontWeight.w600,
                                          textAlign: TextAlign.start),

                                      SizedBox(width: 5,),

                                      CustomeText(
                                          text: "${lableModel.innerPacking}",
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
                                        text: "${lableModel.d}",
                                        fontColor: MyColor.textColorGrey3,
                                        fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_4,
                                        fontWeight: FontWeight.w600,
                                        textAlign: TextAlign.start),

                                    SizedBox(width: 5,),

                                    CustomeText(
                                        text: "${lableModel.detailsOfDamageObserved}",
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
                                          text: "${lableModel.s13a}",
                                          fontColor: MyColor.textColorGrey3,
                                          fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                          fontWeight: FontWeight.w600,
                                          textAlign: TextAlign.start),

                                      SizedBox(width: 5,),

                                      CustomeText(
                                          text: "${lableModel.content}",
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
                                          text: "${lableModel.s13b}",
                                          fontColor: MyColor.textColorGrey3,
                                          fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                          fontWeight: FontWeight.w600,
                                          textAlign: TextAlign.start),

                                      SizedBox(width: 5,),

                                      CustomeText(
                                          text: "${lableModel.containers}",
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
                                          text: "${lableModel.s14}",
                                          fontColor: MyColor.textColorGrey3,
                                          fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                          fontWeight: FontWeight.w600,
                                          textAlign: TextAlign.start),

                                      SizedBox(width: 5,),

                                      CustomeText(
                                          text: "${lableModel.damageDiscovered}",
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
                                          text: "${lableModel.s15a}",
                                          fontColor: MyColor.textColorGrey3,
                                          fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                          fontWeight: FontWeight.w600,
                                          textAlign: TextAlign.start),

                                      SizedBox(width:5,),

                                      CustomeText(
                                          text: "${lableModel.anySpaceForMissingItems}",
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
                          padding: const EdgeInsets.only(left: 40.0, bottom: 8, top: 8, right: 8),
                          child: InkWell(
                            onTap: () {
                              widget.curruentCallback(9);
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [

                                Flexible(
                                  child: Row(
                                    children: [
                                      CustomeText(
                                          text: "${lableModel.b}",
                                          fontColor: MyColor.textColorGrey3,
                                          fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                          fontWeight: FontWeight.w600,
                                          textAlign: TextAlign.start),

                                      SizedBox(width: 5,),

                                      Flexible(
                                        child: CustomeText(
                                            text: "${lableModel.isShortageVerifiedByInvoice}",
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
                                          text: "${lableModel.s16}",
                                          fontColor: MyColor.textColorGrey3,
                                          fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                          fontWeight: FontWeight.w600,
                                          textAlign: TextAlign.start),

                                      SizedBox(width: 5,),

                                      CustomeText(
                                          text: "${lableModel.isPackingSufficient}",
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
                                          text: "${lableModel.s17}",
                                          fontColor: MyColor.textColorGrey3,
                                          fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                          fontWeight: FontWeight.w600,
                                          textAlign: TextAlign.start),

                                      SizedBox(width: 5,),

                                      CustomeText(
                                          text: "${lableModel.anyEvidenceOfPilferage}",
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
                                          text: "${lableModel.s18}",
                                          fontColor: MyColor.textColorGrey3,
                                          fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                          fontWeight: FontWeight.w600,
                                          textAlign: TextAlign.start),

                                      SizedBox(width: 5,),

                                      CustomeText(
                                          text: "${lableModel.remarks}",
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
                                          text: "${lableModel.s19}",
                                          fontColor: MyColor.textColorGrey3,
                                          fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                          fontWeight: FontWeight.w600,
                                          textAlign: TextAlign.start),

                                      SizedBox(width: 5,),

                                      Flexible(
                                        child: CustomeText(
                                            text: "${lableModel.theDamageApparentlyCausedBy}",
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
                                        text: "${lableModel.e}",
                                        fontColor: MyColor.textColorGrey3,
                                        fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_4,
                                        fontWeight: FontWeight.w600,
                                        textAlign: TextAlign.start),

                                    SizedBox(width: 8,),

                                    CustomeText(
                                        text: "${lableModel.actionTaken}",
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
                                          text: "${lableModel.s20}",
                                          fontColor: MyColor.textColorGrey3,
                                          fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                          fontWeight: FontWeight.w600,
                                          textAlign: TextAlign.start),

                                      SizedBox(width: 5,),

                                      CustomeText(
                                          text: "${lableModel.salvageAction}",
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
                                          text: "${lableModel.s21}",
                                          fontColor: MyColor.textColorGrey3,
                                          fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                          fontWeight: FontWeight.w600,
                                          textAlign: TextAlign.start),

                                      SizedBox(width: 5,),

                                      CustomeText(
                                          text: "${lableModel.disposition}",
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
                                          text: "${lableModel.s22}",
                                          fontColor: MyColor.textColorGrey3,
                                          fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                          fontWeight: FontWeight.w600,
                                          textAlign: TextAlign.start),

                                      SizedBox(width: 5,),

                                      Flexible(
                                        child: CustomeText(
                                            text: "${lableModel.anyDamageRemarks}",
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
                                          text: "${lableModel.s23}",
                                          fontColor: MyColor.textColorGrey3,
                                          fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                          fontWeight: FontWeight.w600,
                                          textAlign: TextAlign.start),

                                      SizedBox(width: 5,),

                                      CustomeText(
                                          text: "${lableModel.weatherCondition}",
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
                                          text:  "${lableModel.s24}",
                                          fontColor: MyColor.textColorGrey3,
                                          fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                          fontWeight: FontWeight.w600,
                                          textAlign: TextAlign.start),

                                      SizedBox(width: 5,),

                                      CustomeText(
                                          text:  "${lableModel.representative}",
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
                  text:  "${lableModel.previous}",
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
                  text:  "${lableModel.next}",
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
