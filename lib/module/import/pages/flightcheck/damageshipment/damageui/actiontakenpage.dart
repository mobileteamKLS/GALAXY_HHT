import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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

class ActionTakenPage extends StatefulWidget {


  DamageDetailsModel? damageDetailsModel;
  final VoidCallback preclickCallback;
  final VoidCallback nextclickCallback;
  InactivityTimerManager? inactivityTimerManager;
  int pageView;

  ActionTakenPage({super.key,
    required this.pageView,
    required this.inactivityTimerManager,
    required this.damageDetailsModel, required this.preclickCallback, required this.nextclickCallback});

  @override
  State<ActionTakenPage> createState() => _ActionTakenPageState();
}

class _ActionTakenPageState extends State<ActionTakenPage> {



  List<ReferenceData21List> salvageActionList = [];
  List<String> selectedsalvageActionList = [];


  List<ReferenceData22List> dispositionList = [];
  List<String> selecteddispositionList = [];



  @override
  void dispose() {
    // Dispose of controllers and focus nodes
    super.dispose();
    widget.inactivityTimerManager!.stopTimer();
  }




  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    salvageActionList = List.from(widget.damageDetailsModel!.referenceData21List!);
    dispositionList = List.from(widget.damageDetailsModel!.referenceData22List!);


    if(widget.damageDetailsModel?.damageDetail?.actionSalvage == null
        || widget.damageDetailsModel?.damageDetail?.actionDisposition == null){

    }else{
      CommonUtils.SELECTEDSALVAGEACTION = widget.damageDetailsModel!.damageDetail!.actionSalvage!;
      CommonUtils.SELECTEDDISPOSITION = widget.damageDetailsModel!.damageDetail!.actionDisposition!;

    }






    List<String> selectedSalvageActionListItem = CommonUtils.SELECTEDSALVAGEACTION.split(",");
    for (var item in salvageActionList) {
      if (selectedSalvageActionListItem.contains(item.referenceDataIdentifier)) {
        selectedsalvageActionList.add("${item.referenceDataIdentifier},");
      }
    }

    List<String> selectedDispositionListItem = CommonUtils.SELECTEDDISPOSITION.split(",");
    for (var item in dispositionList) {
      if (selectedDispositionListItem.contains(item.referenceDataIdentifier)) {
        selecteddispositionList.add("${item.referenceDataIdentifier},");
      }
    }


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
            widget.inactivityTimerManager?.stopTimer();
            Navigator.pop(context, "Done");
          },
          clearText: "${lableModel!.clear}",
          onClear: () {

            CommonUtils.SELECTEDSALVAGEACTION = "";
            selectedsalvageActionList.clear();
            CommonUtils.SELECTEDDISPOSITION = "";
            selecteddispositionList.clear();
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
                            text: "${lableModel.e} ${lableModel.actionTaken}",
                            fontColor: MyColor.textColorGrey3,
                            fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                            fontWeight: FontWeight.w600,
                            textAlign: TextAlign.start),
                        SizedBox(height: SizeConfig.blockSizeVertical * SizeUtils.TEXTSIZE_0_9,),
                        CustomDivider(space: 0, color: Colors.black, hascolor: true,),

                        SizedBox(height: SizeConfig.blockSizeVertical * 0.3),

                        CustomeText(
                            text: "${lableModel.s20} ${lableModel.salvageAction}",
                            fontColor: MyColor.textColorGrey3,
                            fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_6,
                            fontWeight: FontWeight.w600,
                            textAlign: TextAlign.start),
                        SizedBox(height: SizeConfig.blockSizeVertical * 0.3),

                        ListView.builder(
                          itemCount: salvageActionList.length,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            ReferenceData21List salvageAction = salvageActionList[index];

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
                                              child: CustomeText(text: "${salvageAction.referenceDescription}".substring(0, 2).toUpperCase(), fontColor: MyColor.colorBlack, fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_8, fontWeight: FontWeight.w500, textAlign: TextAlign.center),
                                            ),
                                            SizedBox(
                                              width: 15,
                                            ),
                                            Flexible(child: CustomeText(text: salvageAction.referenceDescription!, fontColor: MyColor.textColorGrey3, fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5_5, fontWeight: FontWeight.w500, textAlign: TextAlign.start)),
                                          ],
                                        ),
                                      ),
                                      SizedBox(width: 2),
                                      Switch(
                                        value: selectedsalvageActionList.contains("${salvageAction.referenceDataIdentifier},"),
                                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                        activeColor: MyColor.primaryColorblue,
                                        inactiveThumbColor: MyColor.thumbColor,
                                        inactiveTrackColor: MyColor.textColorGrey2,
                                        trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
                                        onChanged: (value) {

                                          if(widget.pageView == 0){
                                            setState(() {
                                              if (value) {
                                                selectedsalvageActionList.add("${salvageAction.referenceDataIdentifier},");
                                              } else {
                                                selectedsalvageActionList.remove("${salvageAction.referenceDataIdentifier},");
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
                  ),


                  SizedBox(height: SizeConfig.blockSizeVertical),

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
                            text: "${lableModel.s21} ${lableModel.disposition}",
                            fontColor: MyColor.textColorGrey3,
                            fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_6,
                            fontWeight: FontWeight.w600,
                            textAlign: TextAlign.start),
                        SizedBox(height: SizeConfig.blockSizeVertical * 0.3),

                        ListView.builder(
                          itemCount: dispositionList.length,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            ReferenceData22List disposition = dispositionList[index];

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
                                              child: CustomeText(text: "${disposition.referenceDescription}".substring(0, 2).toUpperCase(), fontColor: MyColor.colorBlack, fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_8, fontWeight: FontWeight.w500, textAlign: TextAlign.center),
                                            ),
                                            SizedBox(
                                              width: 15,
                                            ),
                                            Flexible(child: CustomeText(text: disposition.referenceDescription!, fontColor: MyColor.textColorGrey3, fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5_5, fontWeight: FontWeight.w500, textAlign: TextAlign.start)),
                                          ],
                                        ),
                                      ),
                                      SizedBox(width: 2),
                                      Switch(
                                        value: selecteddispositionList.contains("${disposition.referenceDataIdentifier},"),
                                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                        activeColor: MyColor.primaryColorblue,
                                        inactiveThumbColor: MyColor.thumbColor,
                                        inactiveTrackColor: MyColor.textColorGrey2,
                                        trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
                                        onChanged: (value) {

                                          if(widget.pageView == 0){
                                            setState(() {
                                              if (value) {
                                                selecteddispositionList.add("${disposition.referenceDataIdentifier},");
                                              } else {
                                                selecteddispositionList.remove("${disposition.referenceDataIdentifier},");
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
                    CommonUtils.SELECTEDSALVAGEACTION = selectedsalvageActionList.join('').toString();
                    CommonUtils.SELECTEDDISPOSITION = selecteddispositionList.join('').toString();
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
                    CommonUtils.SELECTEDSALVAGEACTION = selectedsalvageActionList.join('').toString();
                    CommonUtils.SELECTEDDISPOSITION = selecteddispositionList.join('').toString();
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
