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

import '../../../../model/flightcheck/damagedetailmodel.dart';

class DamageDiscoveredPage extends StatefulWidget {

  DamageDetailsModel? damageDetailsModel;
  final VoidCallback preclickCallback;
  final VoidCallback nextclickCallback;
  DamageDiscoveredPage({super.key, required this.damageDetailsModel, required this.preclickCallback, required this.nextclickCallback});

  @override
  State<DamageDiscoveredPage> createState() => _DamageDiscoveredPageState();
}

class _DamageDiscoveredPageState extends State<DamageDiscoveredPage> {



  List<ReferenceData15List> damageDiscoveredList = [];
  List<String> selecteddamageDiscoveredList = [];
  bool _showFullList = false;



  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    damageDiscoveredList = List.from(widget.damageDetailsModel!.referenceData15List!);

  }

  @override
  void dispose() {
    // Dispose of controllers and focus nodes
    super.dispose();
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
              child: Container(
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
                        text: "14) Damage Discovered",
                        fontColor: MyColor.textColorGrey3,
                        fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_6,
                        fontWeight: FontWeight.w600,
                        textAlign: TextAlign.start),
                    SizedBox(height: SizeConfig.blockSizeVertical * SizeUtils.TEXTSIZE_0_9,),
                    CustomDivider(space: 0, color: Colors.black, hascolor: true,),

                    SizedBox(height: SizeConfig.blockSizeVertical * 0.3),

                    ListView.builder(
                      itemCount: _showFullList ? damageDiscoveredList.length : (damageDiscoveredList.length > 6 ? 6 : damageDiscoveredList.length),
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        ReferenceData15List damageDiscovered = damageDiscoveredList[index];

                        Color backgroundColor = MyColor.colorList[index % MyColor.colorList.length];

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: SizeUtils.HEIGHT5),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Row(
                                      children: [
                                        CircleAvatar(
                                          radius: SizeConfig.blockSizeVertical * SizeUtils.TEXTSIZE_2_2,
                                          backgroundColor: backgroundColor,
                                          child: CustomeText(text: "${damageDiscovered.referenceDescription}".substring(0, 2).toUpperCase(), fontColor: MyColor.colorBlack, fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_8, fontWeight: FontWeight.w500, textAlign: TextAlign.center),
                                        ),
                                        SizedBox(
                                          width: 15,
                                        ),
                                        Flexible(child: CustomeText(text: damageDiscovered.referenceDescription!, fontColor: MyColor.textColorGrey3, fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5_5, fontWeight: FontWeight.w500, textAlign: TextAlign.start)),
                                      ],
                                    ),
                                  ),
                                  SizedBox(width: 2),
                                  Switch(
                                    value: selecteddamageDiscoveredList.contains("${damageDiscovered.referenceDataIdentifier}~"),
                                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                    activeColor: MyColor.primaryColorblue,
                                    inactiveThumbColor: MyColor.thumbColor,
                                    inactiveTrackColor: MyColor.textColorGrey2,
                                    trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
                                    onChanged: (value) {
                                      setState(() {
                                        if (value) {
                                          selecteddamageDiscoveredList.add("${damageDiscovered.referenceDataIdentifier}~");
                                        } else {
                                          selecteddamageDiscoveredList.remove("${damageDiscovered.referenceDataIdentifier}~");
                                        }
                                      });
                                    },
                                  )
                                ],
                              ),
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

                    if (damageDiscoveredList.length > 6) // Only show the button if the list has more than 4 items
                      InkWell(
                        onTap: () {
                          setState(() {
                            _showFullList = !_showFullList; // Toggle between showing full list and limited list
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CustomeText(
                                text: _showFullList ? "${lableModel.showLess}" : "${lableModel.showMore}", // Change text based on state
                                fontColor: MyColor.primaryColorblue,
                                fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                fontWeight: FontWeight.w500, textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),

                  ],
                ),
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