import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:galaxy/module/import/model/flightcheck/awblistmodel.dart';
import 'package:galaxy/widget/customeedittext/remarkedittextfeild.dart';

import '../../../../../../core/images.dart';
import '../../../../../../core/mycolor.dart';
import '../../../../../../language/appLocalizations.dart';
import '../../../../../../language/model/lableModel.dart';
import '../../../../../../manager/timermanager.dart';
import '../../../../../../utils/awbformatenumberutils.dart';
import '../../../../../../utils/commonutils.dart';
import '../../../../../../utils/dialogutils.dart';
import '../../../../../../utils/sizeutils.dart';
import '../../../../../../widget/customdivider.dart';
import '../../../../../../widget/customebuttons/roundbuttonblue.dart';
import '../../../../../../widget/custometext.dart';
import '../../../../../../widget/customeuiwidgets/header.dart';
import '../../../../../../widget/customtextfield.dart';
import '../../../../../onboarding/sizeconfig.dart';
import 'dart:ui' as ui;

class MissingItemAndRemarksPage extends StatefulWidget {

  final VoidCallback preclickCallback;
  final VoidCallback nextclickCallback;
  InactivityTimerManager? inactivityTimerManager;
  MissingItemAndRemarksPage({super.key,
    required this.inactivityTimerManager,
    required this.preclickCallback, required this.nextclickCallback});

  @override
  State<MissingItemAndRemarksPage> createState() => _MissingItemAndRemarksPageState();
}

class _MissingItemAndRemarksPageState extends State<MissingItemAndRemarksPage> {


  String missingItems = "Y";
  String verifiedInvoice = "Y";
  String packingSufficient = "Y";
  String evidence = "Y";
  TextEditingController remarkController = TextEditingController();
  FocusNode remarkFocusNode = FocusNode();

  @override
  void initState() {
    // TODO: implement initState

    missingItems = CommonUtils.MISSINGITEM;
    verifiedInvoice = CommonUtils.VERIFIEDINVOICE;
    packingSufficient = CommonUtils.SUFFICIENT;
    evidence = CommonUtils.EVIDENCE;

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
          clearText: "${lableModel!.clear}",
          onClear: () {
            missingItems = CommonUtils.MISSINGITEM = "Y";
            verifiedInvoice = CommonUtils.VERIFIEDINVOICE = "Y";
            packingSufficient = CommonUtils.SUFFICIENT = "Y";
            evidence = CommonUtils.EVIDENCE = "Y";
            remarkController.clear();
            CommonUtils.REMARKS = "";
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
                            text: "15.a) Any Space For Missing Items",
                            fontColor: MyColor.textColorGrey3,
                            fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_6,
                            fontWeight: FontWeight.w600,
                            textAlign: TextAlign.start),
                        SizedBox(height: SizeConfig.blockSizeVertical * SizeUtils.TEXTSIZE_0_9,),


                        IntrinsicHeight(
                          child: Row(
                            children: [
                              // Yes Option
                              Expanded(
                                flex: 1,
                                child: InkWell(
                                  onTap: () {
                                    setState(() {
                                      missingItems = "Y";
                                    });
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: missingItems == "Y" ? MyColor.primaryColorblue : MyColor.colorWhite, // Selected blue, unselected white
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(10),
                                        bottomLeft: Radius.circular(10),
                                      ),
                                      border: Border.symmetric(horizontal: BorderSide(color: MyColor.primaryColorblue), vertical: BorderSide(color: MyColor.primaryColorblue)), // Border color
                                    ),
                                    padding: EdgeInsets.symmetric(vertical:16, horizontal: 10),
                                    child: Center(
                                        child: CustomeText(text: "YES", fontColor: missingItems == "Y" ? MyColor.colorWhite : MyColor.textColorGrey3, fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5, fontWeight: FontWeight.w600, textAlign: TextAlign.center)
                                    ),
                                  ),
                                ),
                              ),
                              // No Option
                              Expanded(
                                flex: 1,
                                child: InkWell(
                                  onTap: () {
                                    setState(() {
                                      missingItems = "N";
                                    });
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: missingItems == "N" ? MyColor.primaryColorblue : MyColor.colorWhite, // Selected blue, unselected white
                                      border: Border.symmetric(horizontal: BorderSide(color: MyColor.primaryColorblue)), // Border color
                                    ),
                                    padding: EdgeInsets.symmetric(vertical:16, horizontal: 10),
                                    child: Center(
                                        child: CustomeText(text: "NO", fontColor: missingItems == "N" ? MyColor.colorWhite : MyColor.textColorGrey3, fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5, fontWeight: FontWeight.w600, textAlign: TextAlign.center)
                                    ),
                                  ),
                                ),
                              ),

                              Expanded(
                                flex: 1,
                                child: InkWell(
                                  onTap: () {
                                    setState(() {
                                      missingItems = "N/A";
                                    });
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: missingItems == "N/A" ? MyColor.primaryColorblue : MyColor.colorWhite, // Selected blue, unselected white
                                      borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(10),
                                        bottomRight: Radius.circular(10),
                                      ),
                                      border: Border.symmetric(horizontal: BorderSide(color: MyColor.primaryColorblue), vertical: BorderSide(color: MyColor.primaryColorblue)), // Border color
                                    ),
                                    padding: EdgeInsets.symmetric(vertical:16, horizontal: 10),
                                    child: Center(
                                        child: CustomeText(text: "N/A", fontColor: missingItems == "N/A" ? MyColor.colorWhite : MyColor.textColorGrey3, fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5, fontWeight: FontWeight.w600, textAlign: TextAlign.center)
                                    ),
                                  ),
                                ),
                              ),

                            ],
                          ),
                        )
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
                            text: "b) Is Shortage Verified By Invoice",
                            fontColor: MyColor.textColorGrey3,
                            fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_6,
                            fontWeight: FontWeight.w600,
                            textAlign: TextAlign.start),
                        SizedBox(height: SizeConfig.blockSizeVertical * SizeUtils.TEXTSIZE_0_9,),


                        IntrinsicHeight(
                          child: Row(
                            children: [
                              // Yes Option
                              Expanded(
                                flex: 1,
                                child: InkWell(
                                  onTap: () {
                                    setState(() {
                                      verifiedInvoice = "Y";
                                    });
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: verifiedInvoice == "Y" ? MyColor.primaryColorblue : MyColor.colorWhite, // Selected blue, unselected white
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(10),
                                        bottomLeft: Radius.circular(10),
                                      ),
                                      border: Border.symmetric(horizontal: BorderSide(color: MyColor.primaryColorblue), vertical: BorderSide(color: MyColor.primaryColorblue)), // Border color
                                    ),
                                    padding: EdgeInsets.symmetric(vertical:16, horizontal: 10),
                                    child: Center(
                                        child: CustomeText(text: "YES", fontColor: verifiedInvoice == "Y" ? MyColor.colorWhite : MyColor.textColorGrey3, fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5, fontWeight: FontWeight.w600, textAlign: TextAlign.center)
                                    ),
                                  ),
                                ),
                              ),
                              // No Option
                              Expanded(
                                flex: 1,
                                child: InkWell(
                                  onTap: () {
                                    setState(() {
                                      verifiedInvoice = "N";
                                    });
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: verifiedInvoice == "N" ? MyColor.primaryColorblue : MyColor.colorWhite, // Selected blue, unselected white
                                      border: Border.symmetric(horizontal: BorderSide(color: MyColor.primaryColorblue)), // Border color
                                    ),
                                    padding: EdgeInsets.symmetric(vertical:16, horizontal: 10),
                                    child: Center(
                                        child: CustomeText(text: "NO", fontColor: verifiedInvoice == "N" ? MyColor.colorWhite : MyColor.textColorGrey3, fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5, fontWeight: FontWeight.w600, textAlign: TextAlign.center)
                                    ),
                                  ),
                                ),
                              ),

                              Expanded(
                                flex: 1,
                                child: InkWell(
                                  onTap: () {
                                    setState(() {
                                      verifiedInvoice = "N/A";
                                    });
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: verifiedInvoice == "N/A" ? MyColor.primaryColorblue : MyColor.colorWhite, // Selected blue, unselected white
                                      borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(10),
                                        bottomRight: Radius.circular(10),
                                      ),
                                      border: Border.symmetric(horizontal: BorderSide(color: MyColor.primaryColorblue), vertical: BorderSide(color: MyColor.primaryColorblue)), // Border color
                                    ),
                                    padding: EdgeInsets.symmetric(vertical:16, horizontal: 10),
                                    child: Center(
                                        child: CustomeText(text: "N/A", fontColor: verifiedInvoice == "N/A" ? MyColor.colorWhite : MyColor.textColorGrey3, fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5, fontWeight: FontWeight.w600, textAlign: TextAlign.center)
                                    ),
                                  ),
                                ),
                              ),

                            ],
                          ),
                        )
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
                            text: "16) Is Packing Sufficient?",
                            fontColor: MyColor.textColorGrey3,
                            fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_6,
                            fontWeight: FontWeight.w600,
                            textAlign: TextAlign.start),
                        SizedBox(height: SizeConfig.blockSizeVertical * SizeUtils.TEXTSIZE_0_9,),


                        IntrinsicHeight(
                          child: Row(
                            children: [
                              // Yes Option
                              Expanded(
                                flex: 1,
                                child: InkWell(
                                  onTap: () {
                                    setState(() {
                                      packingSufficient = "Y";
                                    });
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: packingSufficient == "Y" ? MyColor.primaryColorblue : MyColor.colorWhite, // Selected blue, unselected white
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(10),
                                        bottomLeft: Radius.circular(10),
                                      ),
                                      border: Border.all(color: MyColor.primaryColorblue), // Border color
                                    ),
                                    padding: EdgeInsets.symmetric(vertical:16, horizontal: 10),
                                    child: Center(
                                        child: CustomeText(text: "YES", fontColor: packingSufficient == "Y" ? MyColor.colorWhite : MyColor.textColorGrey3, fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5, fontWeight: FontWeight.w600, textAlign: TextAlign.center)

                                    ),
                                  ),
                                ),
                              ),
                              // No Option
                              Expanded(
                                flex: 1,
                                child: InkWell(
                                  onTap: () {
                                    setState(() {
                                      packingSufficient = "N";
                                    });
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: packingSufficient == "N" ? MyColor.primaryColorblue : MyColor.colorWhite, // Selected blue, unselected white
                                      borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(10),
                                        bottomRight: Radius.circular(10),
                                      ),
                                      border: Border.all(color:MyColor.primaryColorblue), // Border color
                                    ),
                                    padding: EdgeInsets.symmetric(vertical:16, horizontal: 10),
                                    child: Center(
                                        child: CustomeText(text: "NO", fontColor: packingSufficient == "N" ? MyColor.colorWhite : MyColor.textColorGrey3, fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5, fontWeight: FontWeight.w600, textAlign: TextAlign.center)
                                    ),
                                  ),
                                ),
                              ),


                            ],
                          ),
                        ),
                        SizedBox(height: SizeConfig.blockSizeVertical * SizeUtils.TEXTSIZE_0_9,),

                        CustomeText(
                            text: "Explain in remark box (#18)",
                            fontColor: MyColor.textColorGrey2,
                            fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_6,
                            fontWeight: FontWeight.w600,
                            textAlign: TextAlign.start),

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
                            text: "17) Any Evidence Of Pilferage",
                            fontColor: MyColor.textColorGrey3,
                            fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_6,
                            fontWeight: FontWeight.w600,
                            textAlign: TextAlign.start),
                        SizedBox(height: SizeConfig.blockSizeVertical * SizeUtils.TEXTSIZE_0_9,),

                        IntrinsicHeight(
                          child: Row(
                            children: [
                              // Yes Option
                              Expanded(
                                flex: 1,
                                child: InkWell(
                                  onTap: () {
                                    setState(() {
                                      evidence = "Y";
                                    });
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: evidence == "Y" ? MyColor.primaryColorblue : MyColor.colorWhite, // Selected blue, unselected white
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(10),
                                        bottomLeft: Radius.circular(10),
                                      ),
                                      border: Border.all(color: MyColor.primaryColorblue), // Border color
                                    ),
                                    padding: EdgeInsets.symmetric(vertical:16, horizontal: 10),
                                    child: Center(
                                        child: CustomeText(text: "YES", fontColor: evidence == "Y" ? MyColor.colorWhite : MyColor.textColorGrey3, fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5, fontWeight: FontWeight.w600, textAlign: TextAlign.center)
                                    ),
                                  ),
                                ),
                              ),
                              // No Option
                              Expanded(
                                flex: 1,
                                child: InkWell(
                                  onTap: () {
                                    setState(() {
                                      evidence = "N";
                                    });
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: evidence == "N" ? MyColor.primaryColorblue : MyColor.colorWhite, // Selected blue, unselected white
                                      borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(10),
                                        bottomRight: Radius.circular(10),
                                      ),
                                      border: Border.all(color:MyColor.primaryColorblue), // Border color
                                    ),
                                    padding: EdgeInsets.symmetric(vertical:16, horizontal: 10),
                                    child: Center(
                                        child: CustomeText(text: "NO", fontColor: evidence == "N" ? MyColor.colorWhite : MyColor.textColorGrey3, fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5, fontWeight: FontWeight.w600, textAlign: TextAlign.center)
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: SizeConfig.blockSizeVertical * SizeUtils.TEXTSIZE_0_9,),

                        CustomeText(
                            text: "Explain in remark box (#18)",
                            fontColor: MyColor.textColorGrey2,
                            fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_6,
                            fontWeight: FontWeight.w600,
                            textAlign: TextAlign.start),
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
                            text: "18) Remarks (In Case of Irregularity of Live Animal Type of Injury and Reason as Diagnosed by the Veterinarian)",
                            fontColor: MyColor.textColorGrey3,
                            fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_6,
                            fontWeight: FontWeight.w600,
                            textAlign: TextAlign.start),
                        SizedBox(height: SizeConfig.blockSizeVertical * SizeUtils.HEIGHT2),

                        Directionality(
                          textDirection: uiDirection,
                          child: RemarkCustomTextField(
                            controller: remarkController,
                            focusNode: remarkFocusNode,
                            onPress: () {},
                            hasIcon: false,
                            hastextcolor: true,
                            animatedLabel: true,
                            needOutlineBorder: true,
                            labelText: "Remarks *",
                            readOnly: false,
                            onChanged: (value) {},
                            fillColor:  Colors.grey.shade100,
                            textInputType: TextInputType.text,
                            inputAction: TextInputAction.next,
                            hintTextcolor: Colors.black45,
                            verticalPadding: 0,
                            maxLength: 30,
                            digitsOnly: false,
                            doubleDigitOnly: false,
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
                      ],
                    ),
                  ),
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
                    FocusManager.instance.primaryFocus?.unfocus();
                    CommonUtils.MISSINGITEM = missingItems;
                    CommonUtils.VERIFIEDINVOICE = verifiedInvoice;
                    CommonUtils.SUFFICIENT = packingSufficient;
                    CommonUtils.EVIDENCE = evidence;
                    CommonUtils.REMARKS = remarkController.text;
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

                    if (remarkController.text.isEmpty) {
                      openValidationDialog("Please enter remarks.", remarkFocusNode, lableModel);
                      return;
                    }

                    FocusManager.instance.primaryFocus?.unfocus();


                    CommonUtils.MISSINGITEM = missingItems;
                    CommonUtils.VERIFIEDINVOICE = verifiedInvoice;
                    CommonUtils.SUFFICIENT = packingSufficient;
                    CommonUtils.EVIDENCE = evidence;
                    CommonUtils.REMARKS = remarkController.text;
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

  Future<void> openValidationDialog(String message, FocusNode focuseNode, LableModel lableModel) async {
    bool? empty = await DialogUtils.showDataNotFoundDialogbot(
        context, "${message}", lableModel);

    if (empty == true) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        FocusScope.of(context).requestFocus(focuseNode);
      });
    }
  }
}
