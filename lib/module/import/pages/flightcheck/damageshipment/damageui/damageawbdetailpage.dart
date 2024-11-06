import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:galaxy/module/import/model/flightcheck/awblistmodel.dart';
import 'package:galaxy/utils/snackbarutil.dart';
import 'package:vibration/vibration.dart';

import '../../../../../../core/images.dart';
import '../../../../../../core/mycolor.dart';
import '../../../../../../language/appLocalizations.dart';
import '../../../../../../language/model/lableModel.dart';
import '../../../../../../manager/timermanager.dart';
import '../../../../../../utils/awbformatenumberutils.dart';
import '../../../../../../utils/commonutils.dart';
import '../../../../../../utils/dialogutils.dart';
import '../../../../../../utils/sizeutils.dart';
import '../../../../../../widget/customebuttons/roundbuttonblue.dart';
import '../../../../../../widget/custometext.dart';
import '../../../../../../widget/customeuiwidgets/header.dart';
import '../../../../../../widget/customtextfield.dart';
import '../../../../../onboarding/sizeconfig.dart';
import 'dart:ui' as ui;

import '../../../../model/flightcheck/damagedetailmodel.dart';

class DamageAwbDetailPage extends StatefulWidget {

  DamageDetailsModel? damageDetailsModel;
  final VoidCallback preclickCallback;
  final VoidCallback nextclickCallback;

  InactivityTimerManager? inactivityTimerManager;


  int npxPieces;
  double npxWeightCo;

  int damageNop;
  double damageWt;
  int enterDamageNop;
  double enterDamageWt;
  int pageView;

  DamageAwbDetailPage({super.key,
    required this.enterDamageNop,
    required this.enterDamageWt,
    required this.damageNop,
    required this.damageWt,
    required this.npxPieces,
    required this.npxWeightCo,
    required this.damageDetailsModel, required this.preclickCallback, required this.nextclickCallback, required this.inactivityTimerManager, required this.pageView});

  @override
  State<DamageAwbDetailPage> createState() => _DamageAwbDetailPageState();
}

class _DamageAwbDetailPageState extends State<DamageAwbDetailPage> {


  List<ReferenceDataTypeOfDiscrepancyList> typesOfDiscrepancy = [];
  ReferenceDataTypeOfDiscrepancyList? selectedDiscrepancy;


  TextEditingController nopController = TextEditingController();
  TextEditingController weightController = TextEditingController();
  TextEditingController documentweightController = TextEditingController();
  TextEditingController actualDocumentweightController = TextEditingController();



  FocusNode nopFocusNode = FocusNode();
  FocusNode weightFocusNode = FocusNode();
  FocusNode documentweightFocusNode = FocusNode();
  FocusNode actualDocumentweightFocusNode = FocusNode();

  int npx = 0;
  double weight = 0.00;
  int differenceNpx = 0;
  double differenceWeight = 0.00;

  double actuleDifferenceWeight = 0.00;

  int totalDamageNop = 0;
  double totalDamageWt = 0.00;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    npx = widget.damageDetailsModel!.damageAWBDetail!.nPX!;
    weight = widget.damageDetailsModel!.damageAWBDetail!.wtExp!;

    typesOfDiscrepancy = List.of(widget.damageDetailsModel!.referenceDataTypeOfDiscrepancyList!);

    if(widget.damageDetailsModel?.damageDetail?.typeDiscrepancy == null){
      selectedDiscrepancy = typesOfDiscrepancy[0];
    }else{

      bool isDMGPresent = typesOfDiscrepancy.any((item) => item.referenceDataIdentifier == widget.damageDetailsModel!.damageDetail!.typeDiscrepancy!);
      if (isDMGPresent) {
        selectedDiscrepancy = typesOfDiscrepancy.firstWhere(
              (item) => item.referenceDataIdentifier == widget.damageDetailsModel!.damageDetail!.typeDiscrepancy!,
          orElse: () => typesOfDiscrepancy[0], // Fallback if "DMG" is not found
        );
      } else {
        selectedDiscrepancy = typesOfDiscrepancy[0];
      }
    }

    documentweightController.text = widget.damageDetailsModel!.damageDetail!.indWtPerDocument!.toStringAsFixed(2);
    actualDocumentweightController.text = widget.damageDetailsModel!.damageDetail!.indWtActualCheck!.toStringAsFixed(2);
    actuleDifferenceWeight = widget.damageDetailsModel!.damageDetail!.indWtDifference!;



    totalDamageNop = (int.parse("${widget.damageNop}") + int.parse("${widget.enterDamageNop}"));
    totalDamageWt = (double.parse("${widget.damageWt}") + double.parse("${widget.enterDamageWt}"));


    nopController.text = totalDamageNop.toString();
    weightController.text = totalDamageWt.toStringAsFixed(2);

   /* if(widget.pageView == 1){
      documentweightController.text = widget.damageDetailsModel!.damageDetail!.indWtPerDocument!.toStringAsFixed(2);
      actualDocumentweightController.text = widget.damageDetailsModel!.damageDetail!.indWtActualCheck!.toStringAsFixed(2);
      actuleDifferenceWeight = widget.damageDetailsModel!.damageDetail!.indWtDifference!;
    }*/



    WidgetsBinding.instance.addPostFrameCallback((_) {

      checkLimits();
      //checkPiecesGreterOrNot();
    });

   /* WidgetsBinding.instance.addPostFrameCallback((_) {
      checkWeightGreterOrNot();
    });*/

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
          clearText: (widget.pageView == 0) ? "${lableModel!.clear}" : "",
          onClear: () {
            selectedDiscrepancy = typesOfDiscrepancy[0];
            documentweightController.clear();
            actualDocumentweightController.clear();
            actuleDifferenceWeight = 0.00;

            /*nopController.text = "${widget.damageNop}";
            weightController.text = widget.damageWt.toStringAsFixed(2);

            differenceNpx = npx - widget.damageNop;
            differenceWeight = weight - widget.damageWt;*/

            totalDamageNop = (int.parse("${widget.damageNop}") + int.parse("${widget.enterDamageNop}"));
            totalDamageWt = (double.parse("${widget.damageWt}") + double.parse("${widget.enterDamageWt}"));


            nopController.text = totalDamageNop.toString();
            weightController.text = totalDamageWt.toStringAsFixed(2);

            differenceNpx = npx - totalDamageNop;
            differenceWeight = weight - totalDamageWt;

            if(widget.pageView == 1){
              documentweightController.text = widget.damageDetailsModel!.damageDetail!.indWtPerDocument!.toStringAsFixed(2);
              actualDocumentweightController.text = widget.damageDetailsModel!.damageDetail!.indWtActualCheck!.toStringAsFixed(2);
              actuleDifferenceWeight = widget.damageDetailsModel!.damageDetail!.indWtDifference!;
            }

            setState(() {

            });
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
                            text: (widget.damageDetailsModel!.damageAWBDetail!.houseNo!.isEmpty) ? AwbFormateNumberUtils.formatAWBNumber(widget.damageDetailsModel!.damageAWBDetail!.aWBNo!) : widget.damageDetailsModel!.damageAWBDetail!.houseNo!,
                            fontColor: MyColor.textColorGrey3,
                            fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_7,
                            fontWeight: FontWeight.bold,
                            textAlign: TextAlign.start),
                        SizedBox(height: SizeConfig.blockSizeVertical * SizeUtils.TEXTSIZE_0_9,),
                        Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: Row(
                                children: [
                                  CustomeText(
                                      text:  widget.damageDetailsModel!.damageAWBDetail!.origin!,
                                      fontColor: MyColor.textColorGrey3,
                                      fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_4,
                                      fontWeight: FontWeight.w800,
                                      textAlign: TextAlign.start),
                                  SizedBox(width: SizeConfig.blockSizeHorizontal,),
                                  SvgPicture.asset(arrival, height: SizeConfig.blockSizeVertical * SizeUtils.ICONSIZE2,),
                                  SizedBox(width: SizeConfig.blockSizeHorizontal,),
                                  CustomeText(
                                      text:  widget.damageDetailsModel!.damageAWBDetail!.destination!,
                                      fontColor: MyColor.textColorGrey3,
                                      fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_4,
                                      fontWeight: FontWeight.w800,
                                      textAlign: TextAlign.start),
                                ],
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Row(
                                children: [
                                  CustomeText(
                                    text: "${widget.damageDetailsModel!.damageFlightDetail!.flightNo!}",
                                    fontColor: MyColor.colorBlack,
                                    fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                    fontWeight: FontWeight.w800,
                                    textAlign: TextAlign.start,
                                  ),
                                  SizedBox(width: 5),
                                  CustomeText(
                                    text: " ${widget.damageDetailsModel!.damageFlightDetail!.flightDate!.replaceAll(" ", "-")}",
                                    fontColor: MyColor.textColorGrey2,
                                    fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                    fontWeight: FontWeight.w600,
                                    textAlign: TextAlign.start,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: SizeConfig.blockSizeVertical * SizeUtils.TEXTSIZE_0_9,),

                        Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: Row(
                                children: [
                                  CustomeText(
                                    text: "POL : ",
                                    fontColor: MyColor.textColorGrey2,
                                    fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_4,
                                    fontWeight: FontWeight.w500,
                                    textAlign: TextAlign.start,
                                  ),
                                  SizedBox(width: 5),
                                  CustomeText(
                                    text: widget.damageDetailsModel!.damageAWBDetail!.origin!,
                                    fontColor: MyColor.colorBlack,
                                    fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_4,
                                    fontWeight: FontWeight.w800,
                                    textAlign: TextAlign.start,
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Row(
                                children: [
                                  CustomeText(
                                    text: "POU : ",
                                    fontColor: MyColor.textColorGrey2,
                                    fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_4,
                                    fontWeight: FontWeight.w500,
                                    textAlign: TextAlign.start,
                                  ),
                                  SizedBox(width: 5),
                                  CustomeText(
                                    text: widget.damageDetailsModel!.damageAWBDetail!.offLoadPoint!,
                                    fontColor: MyColor.colorBlack,
                                    fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_4,
                                    fontWeight: FontWeight.w800,
                                    textAlign: TextAlign.start,
                                  ),
                                ],
                              ),
                            ),

                          ],
                        ),


                        SizedBox(height: SizeConfig.blockSizeVertical * SizeUtils.TEXTSIZE_0_9,),
                        Row(
                          children: [
                            CustomeText(
                              text: "DESC : ",
                              fontColor: MyColor.textColorGrey2,
                              fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_4,
                              fontWeight: FontWeight.w500,
                              textAlign: TextAlign.start,
                            ),
                            SizedBox(width: 5),
                            CustomeText(
                              text: widget.damageDetailsModel!.damageAWBDetail!.description!,
                              fontColor: MyColor.colorBlack,
                              fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_4,
                              fontWeight: FontWeight.w800,
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
                            fontWeight: FontWeight.w600,
                            textAlign: TextAlign.start),

                        SizedBox(height: SizeConfig.blockSizeVertical * SizeUtils.TEXTSIZE_0_9),

                        GridView.builder(
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 5.5, // Adjust this to control the height
                            crossAxisSpacing: 0,
                            mainAxisSpacing: 0,
                          ),
                          itemCount: typesOfDiscrepancy.length,
                          itemBuilder: (context, index) {
                            return Row(
                              children: [
                                Radio<ReferenceDataTypeOfDiscrepancyList>(
                                  value: typesOfDiscrepancy[index],
                                  groupValue: selectedDiscrepancy,
                                  onChanged: (ReferenceDataTypeOfDiscrepancyList? value) {

                                    if(widget.pageView == 0){
                                      setState(() {
                                        selectedDiscrepancy = value;
                                      });
                                    }

                                  },
                                ),
                                CustomeText(
                                  text: typesOfDiscrepancy[index].referenceDescription!,
                                  fontColor: MyColor.textColorGrey3,
                                  fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                  fontWeight: FontWeight.w600,
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
                            fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_6,
                            fontWeight: FontWeight.w600,
                            textAlign: TextAlign.start),
                        SizedBox(height: SizeConfig.blockSizeVertical,),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CustomeText(
                                text: "a) Total wt. Shipped (Per AWB)",
                                fontColor: MyColor.textColorGrey3,
                                fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_4,
                                fontWeight: FontWeight.w500,
                                textAlign: TextAlign.start),
                            CustomeText(
                                text: "${widget.damageDetailsModel!.damageAWBDetail!.nPX}/${CommonUtils.formateToTwoDecimalPlacesValue(widget.damageDetailsModel!.damageAWBDetail!.wtExp!)} kg",
                                fontColor: MyColor.textColorGrey3,
                                fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_4,
                                fontWeight: FontWeight.w800,
                                textAlign: TextAlign.start),
                          ],
                        ),
                        SizedBox(height: SizeConfig.blockSizeVertical,),
                        CustomeText(
                            text: "b) Total Wt. As Per Actual Check",
                            fontColor: MyColor.textColorGrey3,
                            fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_4,
                            fontWeight: FontWeight.w500,
                            textAlign: TextAlign.start),
                        SizedBox(height: SizeConfig.blockSizeVertical * SizeUtils.HEIGHT2),
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
                                  readOnly: (widget.pageView == 0) ? false : true,
                                  onChanged: (value) {
                                    if (value.isNotEmpty) {
                                      int enteredNpx = int.tryParse(value) ?? 0;
                                      if (enteredNpx > npx) {
                                        WidgetsBinding.instance.addPostFrameCallback((_) {
                                          FocusScope.of(context).requestFocus(nopFocusNode);
                                        });
                                        SnackbarUtil.showSnackbar(context, "Damage pcs $enteredNpx cannot be greater than Shipment Rcvd pcs - $npx", MyColor.colorRed, icon: FontAwesomeIcons.times);
                                      //  showSnackBar(context, "Entered pieces exceed the limit!");
                                      //  nopController.clear(); // Clear the TextField
                                        setState(() {
                                          differenceNpx = 0;
                                        });
                                      } else {
                                        setState(() {
                                          differenceNpx = npx - enteredNpx; // Calculate difference
                                        });


                                      }
                                    }else{
                                      setState(() {
                                        differenceNpx = 0;
                                      });
                                    }



                                  },
                                  fillColor:  Colors.grey.shade100,
                                  textInputType: TextInputType.number,
                                  inputAction: TextInputAction.next,
                                  hintTextcolor: Colors.black45,
                                  verticalPadding: 0,
                                  digitsOnly: true,

                                  fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_8,
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
                              )
                            ),
                            SizedBox(width: SizeConfig.blockSizeHorizontal * SizeUtils.WIDTH2,),
                            Expanded(
                              flex: 1,
                              child: Directionality(
                                textDirection: uiDirection,
                                child: CustomTextField(
                                  controller: weightController,
                                  focusNode: weightFocusNode,
                                  nextFocus: documentweightFocusNode,
                                  onPress: () {},
                                  hasIcon: false,
                                  hastextcolor: true,
                                  animatedLabel: true,
                                  needOutlineBorder: true,
                                  labelText: "Weight",
                                  readOnly: (widget.pageView == 0) ? false : true,
                                  onChanged: (value) {
                                    if (value.isNotEmpty) {
                                      double enteredWeight = double.tryParse(value) ?? 0.00;
                                      if (enteredWeight > weight) {
                                        WidgetsBinding.instance.addPostFrameCallback((_) {
                                          FocusScope.of(context).requestFocus(weightFocusNode);
                                        });
                                        SnackbarUtil.showSnackbar(context, "Damage pcs $enteredWeight cannot be greater than Shipment Rcvd pcs - $weight", MyColor.colorRed, icon: FontAwesomeIcons.times);
                                        //weightController.clear(); // Clear the TextField
                                        setState(() {
                                          differenceWeight = 0.00;
                                        });
                                      } else {
                                        setState(() {
                                          differenceWeight = weight - enteredWeight; // Calculate difference
                                        });

                                      }
                                    }else{
                                      setState(() {
                                        differenceWeight = 0.00;
                                      });
                                    }
                                  },
                                  fillColor:  Colors.grey.shade100,
                                  textInputType: TextInputType.number,
                                  inputAction: TextInputAction.next,
                                  hintTextcolor: Colors.black45,
                                  verticalPadding: 0,
                                  maxLength: 10,
                                  digitsOnly: false,
                                  doubleDigitOnly: true,
                                  fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_8,
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
                        Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: MyColor.dropdownColor,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CustomeText(
                                  text: "c) Difference",
                                  fontColor: MyColor.textColorGrey3,
                                  fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                  fontWeight: FontWeight.w500,
                                  textAlign: TextAlign.start),
                              CustomeText(
                                  text: "$differenceNpx/${differenceWeight.toStringAsFixed(2)} kg",
                                  fontColor: MyColor.textColorGrey3,
                                  fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                  fontWeight: FontWeight.w800,
                                  textAlign: TextAlign.start),
                            ],
                          ),
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
                            fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_6,
                            fontWeight: FontWeight.w600,
                            textAlign: TextAlign.start),

                        SizedBox(height: SizeConfig.blockSizeVertical * SizeUtils.HEIGHT2,),

                        Directionality(
                          textDirection: uiDirection,
                          child: CustomTextField(
                            controller: documentweightController,
                            focusNode: documentweightFocusNode,
                            nextFocus: actualDocumentweightFocusNode,
                            onPress: () {},
                            hasIcon: false,
                            hastextcolor: true,
                            animatedLabel: true,
                            needOutlineBorder: true,
                            labelText: "a) As Per Document (Kg)",
                            readOnly: (widget.pageView == 0) ? false : true,
                            onChanged: (value) {

                              if (value.isEmpty) {
                                setState(() {
                                  actuleDifferenceWeight = 0.00;
                                });
                              }else{
                                actualDocumentweightController.clear();
                                setState(() {
                                  actuleDifferenceWeight = 0.00;
                                });
                              }


                           //   calculateDifference();
                            },
                            fillColor:  Colors.grey.shade100,
                            textInputType: TextInputType.number,
                            inputAction: TextInputAction.next,
                            hintTextcolor: Colors.black45,
                            verticalPadding: 0,
                            maxLength: 10,
                            digitsOnly: false,
                            doubleDigitOnly: true,
                            fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_8,
                            circularCorner: SizeConfig.blockSizeHorizontal * SizeUtils.CIRCULARCORNER,
                            boxHeight: SizeConfig.blockSizeVertical * SizeUtils.BOXHEIGHT,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Please fill out this field";
                              } else {
                                return null;
                              }
                            },
                          )
                        ),
                        SizedBox(height: SizeConfig.blockSizeVertical * SizeUtils.HEIGHT2,),

                        Directionality(
                            textDirection: uiDirection,
                            child: CustomTextField(
                              controller: actualDocumentweightController,
                              focusNode: actualDocumentweightFocusNode,
                              onPress: () {},
                              hasIcon: false,
                              hastextcolor: true,
                              animatedLabel: true,
                              needOutlineBorder: true,
                              labelText: "b) As Per Actual Weight Check (Kg)",
                              readOnly: (widget.pageView == 0) ? false : true,
                              onChanged: (value) {
                                calculateDifference();
                              },
                              fillColor:  Colors.grey.shade100,
                              textInputType: TextInputType.number,
                              inputAction: TextInputAction.next,
                              hintTextcolor: Colors.black45,
                              verticalPadding: 0,
                              maxLength: 10,
                              digitsOnly: false,
                              doubleDigitOnly: true,
                              fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_8,
                              circularCorner: SizeConfig.blockSizeHorizontal * SizeUtils.CIRCULARCORNER,
                              boxHeight: SizeConfig.blockSizeVertical * SizeUtils.BOXHEIGHT,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Please fill out this field";
                                } else {
                                  return null;
                                }
                              },
                            )
                        ),

                        SizedBox(height: SizeConfig.blockSizeVertical,),
                        
                        Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: MyColor.dropdownColor,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CustomeText(
                                  text: "c) Difference",
                                  fontColor: MyColor.textColorGrey3,
                                  fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                  fontWeight: FontWeight.w500,
                                  textAlign: TextAlign.start),
                              CustomeText(
                                  text: "${actuleDifferenceWeight.toStringAsFixed(2)} kg",
                                  fontColor: MyColor.textColorGrey3,
                                  fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                  fontWeight: FontWeight.w800,
                                  textAlign: TextAlign.start),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),



                ],
              ),
            ),
          ),
        ),
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
          child: RoundedButtonBlue(
            text: "Next",
            press: () async {

              if (nopController.text.isEmpty) {
                openValidationDialog("${lableModel!.piecesMsg}", nopFocusNode, lableModel);
                return;
              }

              int enteredNpx = int.tryParse(nopController.text) ?? 0;
              if (enteredNpx > npx) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  FocusScope.of(context).requestFocus(nopFocusNode);
                });
                SnackbarUtil.showSnackbar(context, "Damage pcs $enteredNpx cannot be greater than Shipment Rcvd pcs - $npx", MyColor.colorRed, icon: FontAwesomeIcons.times);
                return;
              }

              double enteredWeight = double.tryParse(weightController.text) ?? 0.00;
              if (enteredWeight > weight) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  FocusScope.of(context).requestFocus(weightFocusNode);
                });
                SnackbarUtil.showSnackbar(context, "Damage pcs $enteredWeight cannot be greater than Shipment Rcvd pcs - $weight", MyColor.colorRed, icon: FontAwesomeIcons.times);
                //weightController.clear(); // Clear the TextField
               return;
              }



              if(int.parse(nopController.text) == 0){
                openValidationDialog("Please enter pieces greater than 0.", nopFocusNode, lableModel!);
                return;
              }

              if(double.parse(weightController.text) == 0){
                openValidationDialog("Please enter weight greater than 0.", weightFocusNode, lableModel!);
                return;
              }

              if (weightController.text.isEmpty) {
                openValidationDialog("${lableModel!.weightMsg}", weightFocusNode, lableModel!);
                return;
              }


              CommonUtils.SELECTEDTYPEOFDISCRPENCY = (selectedDiscrepancy == null) ? " " : selectedDiscrepancy!.referenceDataIdentifier!;
              CommonUtils.shipTotalPcs = widget.damageDetailsModel!.damageAWBDetail!.nPX!;
              CommonUtils.ShipTotalWt = CommonUtils.formateToTwoDecimalPlacesValue(widget.damageDetailsModel!.damageAWBDetail!.wtExp!);
              CommonUtils.shipDamagePcs = int.tryParse(nopController.text) ?? 0;
              CommonUtils.ShipDamageWt = CommonUtils.formateToTwoDecimalPlacesValue(double.tryParse(weightController.text) ?? 0.00);

              CommonUtils.shipDifferencePcs = differenceNpx;
              CommonUtils.shipDifferenceWt = CommonUtils.formateToTwoDecimalPlacesValue(differenceWeight);


              CommonUtils.individualWTPerDoc = CommonUtils.formateToTwoDecimalPlacesValue(double.tryParse(documentweightController.text) ?? 0.00);
              CommonUtils.individualWTActChk = CommonUtils.formateToTwoDecimalPlacesValue(double.tryParse(actualDocumentweightController.text) ?? 0.00);
              CommonUtils.individualWTDifference = CommonUtils.formateToTwoDecimalPlacesValue(actuleDifferenceWeight);




              widget.nextclickCallback();
            },
          ),
        )
      ],
    );
  }

  void calculateDifference() {
    double documentWeight = double.tryParse(documentweightController.text) ?? 0.0;
    double actualWeight = double.tryParse(actualDocumentweightController.text) ?? 0.0;

    // If actual weight exceeds document weight, show snackbar and clear the text
    if (actualWeight > documentWeight) {
      SnackbarUtil.showSnackbar(context, "Actual weight cannot be greater than document weight!", MyColor.colorRed, icon: FontAwesomeIcons.times);
      Vibration.vibrate(duration: 500);
      actualDocumentweightController.clear();
      setState(() {
        actuleDifferenceWeight = 0.00;
      });

    } else {
      setState(() {
        actuleDifferenceWeight = documentWeight - actualWeight; // Calculate the difference
      });
    }
  }


  // validation dialog
  Future<void> openValidationDialog(String message, FocusNode focuseNode, LableModel lableModel) async {
    bool? empty = await DialogUtils.showDataNotFoundDialogbot(
        context, "${message}", lableModel);

    if (empty == true) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        FocusScope.of(context).requestFocus(focuseNode);
      });
    }
  }

  void checkLimits() {
    int enteredNpx = totalDamageNop;
    double enteredWeight = totalDamageWt;

    // Check piece limit first
    if (enteredNpx > npx) {
      // Focus on piece input and show message for pieces if limit is exceeded
      WidgetsBinding.instance.addPostFrameCallback((_) {
        FocusScope.of(context).requestFocus(nopFocusNode);
      });
      SnackbarUtil.showSnackbar(
        context,
        "Damage pcs $enteredNpx cannot be greater than Shipment Rcvd pcs - $npx",
        MyColor.colorRed,
        icon: FontAwesomeIcons.times,
      );
      differenceNpx = 0;
      return; // Exit the function if the piece limit is exceeded
    } else {
      differenceNpx = npx - totalDamageNop;
    }

    // If piece limit is within range, proceed to check weight limit
    if (enteredWeight > weight) {
      // Focus on weight input and show message for weight if limit is exceeded
      WidgetsBinding.instance.addPostFrameCallback((_) {
        FocusScope.of(context).requestFocus(weightFocusNode);
      });
      SnackbarUtil.showSnackbar(
        context,
        "Damage weight $enteredWeight cannot be greater than Shipment Rcvd weight - $weight",
        MyColor.colorRed,
        icon: FontAwesomeIcons.times,
      );
      differenceWeight = 0.00;
    } else {
      differenceWeight = weight - totalDamageWt;
    }

    // Update state if both limits are within range
    setState(() {});
  }


}
