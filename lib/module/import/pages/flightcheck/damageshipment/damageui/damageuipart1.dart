import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:galaxy/module/import/model/flightcheck/awblistmodel.dart';

import '../../../../../../core/images.dart';
import '../../../../../../core/mycolor.dart';
import '../../../../../../language/appLocalizations.dart';
import '../../../../../../language/model/lableModel.dart';
import '../../../../../../utils/awbformatenumberutils.dart';
import '../../../../../../utils/commonutils.dart';
import '../../../../../../utils/sizeutils.dart';
import '../../../../../../widget/customebuttons/roundbuttonblue.dart';
import '../../../../../../widget/custometext.dart';
import '../../../../../../widget/customeuiwidgets/header.dart';
import '../../../../../../widget/customtextfield.dart';
import '../../../../../onboarding/sizeconfig.dart';
import 'dart:ui' as ui;

class Damageuipart1 extends StatefulWidget {

  FlightCheckInAWBBDList aWBItem;
  final VoidCallback preclickCallback;
  final VoidCallback nextclickCallback;
  Damageuipart1({super.key, required this.aWBItem, required this.preclickCallback, required this.nextclickCallback});

  @override
  State<Damageuipart1> createState() => _Damageuipart1State();
}

class _Damageuipart1State extends State<Damageuipart1> {


  List<String> typesOfDiscrepancy = ["Damage", "Shortage/Partial", "Total Loss"];
  String? selectedDiscrepancy;


  TextEditingController nopController = TextEditingController();
  TextEditingController weightController = TextEditingController();
  FocusNode nopFocusNode = FocusNode();
  FocusNode weightFocusNode = FocusNode();

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
            Navigator.pop(context, "true");
          },
          clearText: "",
          onClear: () {

          },
        ),
        SizedBox(height: SizeConfig.blockSizeVertical * SizeUtils.HEIGHT2,),
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CustomeText(
                                text: "AWB No. ${AwbFormateNumberUtils.formatAWBNumber(widget.aWBItem.aWBNo!)}",
                                fontColor: MyColor.textColorGrey2,
                                fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                fontWeight: FontWeight.w500,
                                textAlign: TextAlign.start),
                            Row(
                              children: [
                                CustomeText(
                                  text: "AJ 010",
                                  fontColor: MyColor.colorBlack,
                                  fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                  fontWeight: FontWeight.w600,
                                  textAlign: TextAlign.start,
                                ),
                                SizedBox(width: 5),
                                CustomeText(
                                  text: " 23-SEP-24",
                                  fontColor: MyColor.textColorGrey2,
                                  fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                  fontWeight: FontWeight.w600,
                                  textAlign: TextAlign.start,
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: SizeConfig.blockSizeVertical,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                CustomeText(
                                  text: "POL : ",
                                  fontColor: MyColor.textColorGrey2,
                                  fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_4,
                                  fontWeight: FontWeight.w400,
                                  textAlign: TextAlign.start,
                                ),
                                SizedBox(width: 5),
                                CustomeText(
                                  text: "BLR",
                                  fontColor: MyColor.colorBlack,
                                  fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_4,
                                  fontWeight: FontWeight.w600,
                                  textAlign: TextAlign.start,
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                CustomeText(
                                  text: "POU : ",
                                  fontColor: MyColor.textColorGrey2,
                                  fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_4,
                                  fontWeight: FontWeight.w400,
                                  textAlign: TextAlign.start,
                                ),
                                SizedBox(width: 5),
                                CustomeText(
                                  text: "IST",
                                  fontColor: MyColor.colorBlack,
                                  fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_4,
                                  fontWeight: FontWeight.w600,
                                  textAlign: TextAlign.start,
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                CustomeText(
                                    text: "BLR",
                                    fontColor: MyColor.textColorGrey2,
                                    fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_4,
                                    fontWeight: FontWeight.w400,
                                    textAlign: TextAlign.start),
                                SizedBox(width: SizeConfig.blockSizeHorizontal,),
                                SvgPicture.asset(arrival, height: SizeConfig.blockSizeVertical * SizeUtils.ICONSIZE2,),
                                SizedBox(width: SizeConfig.blockSizeHorizontal,),
                                CustomeText(
                                    text: "IST",
                                    fontColor: MyColor.textColorGrey2,
                                    fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_4,
                                    fontWeight: FontWeight.w400,
                                    textAlign: TextAlign.start),
                              ],
                            )
                          ],
                        ),


                        SizedBox(height: SizeConfig.blockSizeVertical,),
                        Row(
                          children: [
                            CustomeText(
                              text: "Commodity : ",
                              fontColor: MyColor.textColorGrey2,
                              fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_4,
                              fontWeight: FontWeight.w400,
                              textAlign: TextAlign.start,
                            ),
                            SizedBox(width: 5),
                            CustomeText(
                              text: widget.aWBItem.commodity!,
                              fontColor: MyColor.colorBlack,
                              fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_4,
                              fontWeight: FontWeight.w600,
                              textAlign: TextAlign.start,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: SizeConfig.blockSizeVertical,),
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

                        CustomeText(
                            text: "B) TYPE OF DISCREPANCY",
                            fontColor: MyColor.textColorGrey3,
                            fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                            fontWeight: FontWeight.w500,
                            textAlign: TextAlign.start),

                        SizedBox(height: SizeConfig.blockSizeVertical,),

                        GridView.builder(
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 5.5, // Adjust this to control the height
                            crossAxisSpacing: 0,
                            mainAxisSpacing: 0,
                          ),
                          itemCount: typesOfDiscrepancy.length,
                          itemBuilder: (context, index) {
                            return Row(
                              children: [
                                Radio<String>(
                                  value: typesOfDiscrepancy[index],
                                  groupValue: selectedDiscrepancy,
                                  onChanged: (String? value) {
                                    setState(() {
                                      selectedDiscrepancy = value;
                                    });
                                  },
                                ),
                                CustomeText(
                                  text: typesOfDiscrepancy[index],
                                  fontColor: MyColor.textColorGrey2,
                                  fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                  fontWeight: FontWeight.w500,
                                  textAlign: TextAlign.start,
                                ),
                              ],
                            );
                          },
                        ),


                      ],
                    ),
                  ),
                  SizedBox(height: SizeConfig.blockSizeVertical,),
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

                        CustomeText(
                            text: "7) Shipment weight Details",
                            fontColor: MyColor.textColorGrey3,
                            fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                            fontWeight: FontWeight.w500,
                            textAlign: TextAlign.start),
                        SizedBox(height: SizeConfig.blockSizeVertical,),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CustomeText(
                                text: "a) Total wt. Shipped (Per AWB)",
                                fontColor: MyColor.textColorGrey2,
                                fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_3,
                                fontWeight: FontWeight.w500,
                                textAlign: TextAlign.start),
                            CustomeText(
                                text: "11/110.00 kg",
                                fontColor: MyColor.textColorGrey2,
                                fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_3,
                                fontWeight: FontWeight.w500,
                                textAlign: TextAlign.start),
                          ],
                        ),
                        SizedBox(height: SizeConfig.blockSizeVertical,),
                        CustomeText(
                            text: "b) Total Wt. As Per Actual Check",
                            fontColor: MyColor.textColorGrey2,
                            fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_3,
                            fontWeight: FontWeight.w500,
                            textAlign: TextAlign.start),
                        SizedBox(height: SizeConfig.blockSizeVertical * 1.5,),
                        Row(
                          children: [
                            Expanded(
                              flex:1,
                              child: Directionality(
                                textDirection: uiDirection,
                                child: CustomTextField(
                                  controller: nopController,
                                  focusNode: nopFocusNode,
                                  onPress: () {},
                                  hasIcon: false,
                                  maxLength: 4,
                                  hastextcolor: true,
                                  animatedLabel: true,
                                  needOutlineBorder: true,
                                  labelText: "Pieces",
                                  readOnly: false,
                                  onChanged: (value) {},
                                  fillColor:  Colors.grey.shade100,
                                  textInputType: TextInputType.number,
                                  inputAction: TextInputAction.next,
                                  hintTextcolor: Colors.black45,
                                  verticalPadding: 0,
                                  digitsOnly: true,

                                  fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_6,
                                  circularCorner: SizeConfig.blockSizeHorizontal * SizeUtils.CIRCULARCORNER,
                                  boxHeight: SizeConfig.blockSizeVertical * SizeUtils.BOXHEIGHT,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return "Please fill out this field";
                                    } else {
                                      return null;
                                    }
                                  },
                                ),
                              ),
                            ),
                            SizedBox(width: SizeConfig.blockSizeHorizontal * SizeUtils.WIDTH2,),
                            Expanded(
                              flex: 1,
                              child: Directionality(
                                textDirection: uiDirection,
                                child: CustomTextField(
                                  controller: weightController,
                                  focusNode: weightFocusNode,
                                  onPress: () {},
                                  hasIcon: false,
                                  hastextcolor: true,
                                  animatedLabel: true,
                                  needOutlineBorder: true,
                                  labelText: "Weight",
                                  readOnly: false,
                                  onChanged: (value) {},
                                  fillColor:  Colors.grey.shade100,
                                  textInputType: TextInputType.number,
                                  inputAction: TextInputAction.next,
                                  hintTextcolor: Colors.black45,
                                  verticalPadding: 0,
                                  maxLength: 10,
                                  digitsOnly: false,
                                  doubleDigitOnly: true,
                                  fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_6,
                                  circularCorner: SizeConfig.blockSizeHorizontal * SizeUtils.CIRCULARCORNER,
                                  boxHeight: SizeConfig.blockSizeVertical * SizeUtils.BOXHEIGHT,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return "Please fill out this field";
                                    } else {
                                      return null;
                                    }
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: SizeConfig.blockSizeVertical,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CustomeText(
                                text: "c) Difference",
                                fontColor: MyColor.textColorGrey2,
                                fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_3,
                                fontWeight: FontWeight.w500,
                                textAlign: TextAlign.start),
                            CustomeText(
                                text: "11/110.00 kg",
                                fontColor: MyColor.textColorGrey2,
                                fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_3,
                                fontWeight: FontWeight.w500,
                                textAlign: TextAlign.start),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: SizeConfig.blockSizeVertical,),
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

                        CustomeText(
                            text: "8) Individual Wt. Of Each Damage Pkg./Pcs.",
                            fontColor: MyColor.textColorGrey3,
                            fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                            fontWeight: FontWeight.w500,
                            textAlign: TextAlign.start),

                        SizedBox(height: SizeConfig.blockSizeVertical * 1.5,),

                        Directionality(
                          textDirection: uiDirection,
                          child: CustomTextField(
                            controller: weightController,
                            focusNode: weightFocusNode,
                            onPress: () {},
                            hasIcon: false,
                            hastextcolor: true,
                            animatedLabel: true,
                            needOutlineBorder: true,
                            labelText: "a) As Per Document (Kg)",
                            readOnly: false,
                            onChanged: (value) {},
                            fillColor:  Colors.grey.shade100,
                            textInputType: TextInputType.number,
                            inputAction: TextInputAction.next,
                            hintTextcolor: Colors.black45,
                            verticalPadding: 0,
                            maxLength: 10,
                            digitsOnly: false,
                            doubleDigitOnly: true,
                            fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_6,
                            circularCorner: SizeConfig.blockSizeHorizontal * SizeUtils.CIRCULARCORNER,
                            boxHeight: SizeConfig.blockSizeVertical * SizeUtils.BOXHEIGHT,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Please fill out this field";
                              } else {
                                return null;
                              }
                            },
                          ),
                        ),
                        SizedBox(height: SizeConfig.blockSizeVertical * 1.5,),

                        Directionality(
                          textDirection: uiDirection,
                          child: CustomTextField(
                            controller: weightController,
                            focusNode: weightFocusNode,
                            onPress: () {},
                            hasIcon: false,
                            hastextcolor: true,
                            animatedLabel: true,
                            needOutlineBorder: true,
                            labelText: "b) As Per Actual Weight Check (Kg)",
                            readOnly: false,
                            onChanged: (value) {},
                            fillColor:  Colors.grey.shade100,
                            textInputType: TextInputType.number,
                            inputAction: TextInputAction.next,
                            hintTextcolor: Colors.black45,
                            verticalPadding: 0,
                            maxLength: 10,
                            digitsOnly: false,
                            doubleDigitOnly: true,
                            fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_6,
                            circularCorner: SizeConfig.blockSizeHorizontal * SizeUtils.CIRCULARCORNER,
                            boxHeight: SizeConfig.blockSizeVertical * SizeUtils.BOXHEIGHT,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Please fill out this field";
                              } else {
                                return null;
                              }
                            },
                          ),
                        ),

                        SizedBox(height: SizeConfig.blockSizeVertical,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CustomeText(
                                text: "c) Difference",
                                fontColor: MyColor.textColorGrey2,
                                fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_3,
                                fontWeight: FontWeight.w500,
                                textAlign: TextAlign.start),
                            CustomeText(
                                text: "0.00 kg",
                                fontColor: MyColor.textColorGrey2,
                                fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_3,
                                fontWeight: FontWeight.w500,
                                textAlign: TextAlign.start),
                          ],
                        ),
                      ],
                    ),
                  ),



                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            padding: EdgeInsets.all(10),
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
          ),
        )
      ],
    );
  }
}
