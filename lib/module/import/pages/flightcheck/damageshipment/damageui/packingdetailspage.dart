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

import '../../../../model/flightcheck/damagedetailmodel.dart';

class PackingDetailsPage extends StatefulWidget {

  DamageDetailsModel? damageDetailsModel;
  final VoidCallback preclickCallback;
  final VoidCallback nextclickCallback;
  InactivityTimerManager? inactivityTimerManager;

  int pageView;

  PackingDetailsPage({super.key,
    required this.pageView,
    required this.inactivityTimerManager,
    required this.damageDetailsModel,  required this.preclickCallback, required this.nextclickCallback});

  @override
  State<PackingDetailsPage> createState() => _PackingDetailsPageState();
}

class _PackingDetailsPageState extends State<PackingDetailsPage> {


  List<ReferenceData9AList> materialList = [];
  List<String> selectedMaterialList = [];

  List<ReferenceData9BList> typeList = [];
  List<String> selectedTypeList = [];


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    
    materialList = List.from(widget.damageDetailsModel!.referenceData9AList!);
    typeList = List.from(widget.damageDetailsModel!.referenceData9BList!);


    if(widget.damageDetailsModel?.damageDetail?.packContainerMaterial == null || widget.damageDetailsModel?.damageDetail?.packContainerType == null){

    }else{
      CommonUtils.SELECTEDMATERIAL = widget.damageDetailsModel!.damageDetail!.packContainerMaterial!;
      CommonUtils.SELECTEDTYPE = widget.damageDetailsModel!.damageDetail!.packContainerType!;

    }



    List<String> selectedMaterialListItem = CommonUtils.SELECTEDMATERIAL.split(",");
    for (var item in materialList) {
      if (selectedMaterialListItem.contains(item.referenceDataIdentifier)) {
        selectedMaterialList.add("${item.referenceDataIdentifier},");
      }
    }

    List<String> selectedTypeListItem = CommonUtils.SELECTEDTYPE.split(",");
    for (var item in typeList) {
      if (selectedTypeListItem.contains(item.referenceDataIdentifier)) {
        selectedTypeList.add("${item.referenceDataIdentifier},");
      }
    }



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
          title: "${lableModel!.damageAndSave}",
          onBack: () {
            widget.inactivityTimerManager!.stopTimer();
            Navigator.pop(context, "Done");
          },
          clearText: "${lableModel!.clear}",
          onClear: () {
            CommonUtils.SELECTEDMATERIAL = "";
            CommonUtils.SELECTEDTYPE = "";
            selectedMaterialList.clear();
            selectedTypeList.clear();
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
                            text: "${lableModel.c} ${lableModel.packingDetails}",
                            fontColor: MyColor.textColorGrey3,
                            fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                            fontWeight: FontWeight.w600,
                            textAlign: TextAlign.start),
                        SizedBox(height: SizeConfig.blockSizeVertical * SizeUtils.TEXTSIZE_0_9,),
                        CustomDivider(space: 0, color: Colors.black, hascolor: true,),

                        SizedBox(height: SizeConfig.blockSizeVertical * 0.3),

                        CustomeText(
                            text: "${lableModel.s9} ${lableModel.container}",
                            fontColor: MyColor.textColorGrey3,
                            fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_6,
                            fontWeight: FontWeight.w600,
                            textAlign: TextAlign.start),
                        SizedBox(height: SizeConfig.blockSizeVertical * 0.3),

                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomeText(
                                text: "${lableModel.a} ${lableModel.material}",
                                fontColor: MyColor.textColorGrey3,
                                fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_6,
                                fontWeight: FontWeight.w600,
                                textAlign: TextAlign.start),

                            ListView.builder(
                              itemCount: materialList.length,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                ReferenceData9AList material = materialList[index];

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
                                                  child: CustomeText(text: "${material.referenceDescription}".substring(0, 2).toUpperCase(), fontColor: MyColor.colorBlack, fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_8, fontWeight: FontWeight.w500, textAlign: TextAlign.center),
                                                ),
                                                SizedBox(
                                                  width: 15,
                                                ),
                                                Flexible(child: CustomeText(text: material.referenceDescription!, fontColor: MyColor.textColorGrey3, fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5_5, fontWeight: FontWeight.w500, textAlign: TextAlign.start)),
                                              ],
                                            ),
                                          ),
                                          SizedBox(width: 2),
                                          Switch(
                                            value: selectedMaterialList.contains("${material.referenceDataIdentifier},"),
                                            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                            activeColor: MyColor.primaryColorblue,
                                            inactiveThumbColor: MyColor.thumbColor,
                                            inactiveTrackColor: MyColor.textColorGrey2,
                                            trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
                                            onChanged: (value) {

                                              if(widget.pageView == 0){
                                                setState(() {
                                                  if (value) {
                                                    selectedMaterialList.add("${material.referenceDataIdentifier},");
                                                  } else {
                                                    selectedMaterialList.remove("${material.referenceDataIdentifier},");
                                                  }
                                                });
                                              }


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
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomeText(
                                text: "${lableModel.b} ${lableModel.type}",
                                fontColor: MyColor.textColorGrey3,
                                fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_6,
                                fontWeight: FontWeight.w600,
                                textAlign: TextAlign.start),

                            ListView.builder(
                              itemCount: typeList.length,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                ReferenceData9BList type = typeList[index];

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
                                                  child: CustomeText(text: "${type.referenceDescription}".substring(0, 2).toUpperCase(), fontColor: MyColor.colorBlack, fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_8, fontWeight: FontWeight.w500, textAlign: TextAlign.center),
                                                ),
                                                SizedBox(
                                                  width: 15,
                                                ),
                                                Flexible(child: CustomeText(text: type.referenceDescription!, fontColor: MyColor.textColorGrey3, fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5_5, fontWeight: FontWeight.w500, textAlign: TextAlign.start)),
                                              ],
                                            ),
                                          ),
                                          SizedBox(width: 2),
                                          Switch(
                                            value: selectedTypeList.contains("${type.referenceDataIdentifier},"),
                                            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                            activeColor: MyColor.primaryColorblue,
                                            inactiveThumbColor: MyColor.thumbColor,
                                            inactiveTrackColor: MyColor.textColorGrey2,
                                            trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
                                            onChanged: (value) {

                                              if(widget.pageView == 0){
                                                setState(() {
                                                  if (value) {
                                                    selectedTypeList.add("${type.referenceDataIdentifier},");
                                                  } else {
                                                    selectedTypeList.remove("${type.referenceDataIdentifier},");
                                                  }
                                                });
                                              }


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
                  text: "${lableModel.previous}",
                  press: () async {
                    CommonUtils.SELECTEDMATERIAL = selectedMaterialList.join('').toString();
                    CommonUtils.SELECTEDTYPE = selectedTypeList.join('').toString();
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
                  text: "${lableModel.next}",
                  press: () async {
                    CommonUtils.SELECTEDMATERIAL = selectedMaterialList.join('').toString();
                    CommonUtils.SELECTEDTYPE = selectedTypeList.join('').toString();
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
