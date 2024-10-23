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
import '../../../../../../widget/customdivider.dart';
import '../../../../../../widget/customebuttons/roundbuttonblue.dart';
import '../../../../../../widget/custometext.dart';
import '../../../../../../widget/customeuiwidgets/header.dart';
import '../../../../../../widget/customtextfield.dart';
import '../../../../../onboarding/sizeconfig.dart';
import 'dart:ui' as ui;

class Damageuipart3 extends StatefulWidget {

  final VoidCallback preclickCallback;
  final VoidCallback nextclickCallback;
  Damageuipart3({super.key, required this.preclickCallback, required this.nextclickCallback});

  @override
  State<Damageuipart3> createState() => _Damageuipart2State();
}

class _Damageuipart2State extends State<Damageuipart3> {




  List<String> outerPackingList = [
    "BALE",
    "Bag,handbag",
    "BundlE",
    "Drum",
    "FIBREBOARD",
    "Wooden/Metal Barrel",
    "Wooden Crate",
    "Hoopiron",
    "Cardboard Carton",
    "Sacket",
    "Metal Box",
    "Others",
    "Pouch",
    "Roll",
    "Sack, Cloth",
    "Sack, Paper",
    "Suitcase",
    "Unpacked",
    "Wooden Box"
  ];
  List<String> selectedOuterPackingList = [];


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
          clearText: "${lableModel!.clear}",
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

                        CustomeText(
                            text: "11) Outer Packing",
                            fontColor: MyColor.textColorGrey3,
                            fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                            fontWeight: FontWeight.w500,
                            textAlign: TextAlign.start),

                        SizedBox(height: SizeConfig.blockSizeVertical,),
                        Container(
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: MyColor.cardBgColor,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: ListView.builder(
                            itemCount: outerPackingList.length,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              String outerPacking = outerPackingList[index];

                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Flexible(child: CustomeText(text: outerPacking, fontColor: MyColor.textColorGrey2, fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_4, fontWeight: FontWeight.w500, textAlign: TextAlign.start)),
                                      Transform.scale(
                                        scale: 0.8,
                                        child: Switch(
                                          value: selectedOuterPackingList.contains("${outerPacking}~"),
                                          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                          activeColor: MyColor.primaryColorblue,
                                          inactiveThumbColor: MyColor.thumbColor,
                                          inactiveTrackColor: MyColor.textColorGrey2,
                                          trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
                                          onChanged: (value) {
                                            setState(() {
                                              if (value) {
                                                selectedOuterPackingList.add("${outerPacking}~");
                                              } else {
                                                selectedOuterPackingList.remove("${outerPacking}~");
                                              }
                                            });
                                          },
                                        ),
                                      )
                                    ],
                                  ),
                                  CustomDivider(
                                    space: 0,
                                    color: Colors.black,
                                    hascolor: true,
                                  ),
                                ],
                              );
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
