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

class DetailsOfDamage13aPage extends StatefulWidget {

  DamageDetailsModel? damageDetailsModel;
  final VoidCallback preclickCallback;
  final VoidCallback nextclickCallback;
  InactivityTimerManager? inactivityTimerManager;
  int pageView;

  DetailsOfDamage13aPage({super.key,
    required this.pageView,
    required this.inactivityTimerManager,
    required this.damageDetailsModel, required this.preclickCallback, required this.nextclickCallback});

  @override
  State<DetailsOfDamage13aPage> createState() => _DetailsOfDamage13aPageState();
}

class _DetailsOfDamage13aPageState extends State<DetailsOfDamage13aPage> {


  List<FocusNode> focusNodes = [];


  List<ReferenceData14AList> contentList = [];
  List<String> selectedContentList = [];
  bool _showFullList = false;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    contentList = List.from(widget.damageDetailsModel!.referenceData14AList!);



    CommonUtils.CONTENTCONTROLLER = List.generate(contentList.length, (index) => TextEditingController());
    focusNodes = List.generate(contentList.length, (index) => FocusNode());

    if(widget.damageDetailsModel?.damageDetail?.damageContainer == null){

    }else{
      setTextFieldValues(widget.damageDetailsModel!.damageDetail!.damageContainer!);
      print("CHECK_CONTENT ===== ${CommonUtils.SELECTEDCONTENT}");

    }


  }

  @override
  void dispose() {
    // Dispose of controllers and focus nodes
    for (var controller in CommonUtils.CONTENTCONTROLLER) {
      controller.dispose();
    }
    for (var focusNode in focusNodes) {
      focusNode.dispose();
    }

    widget.inactivityTimerManager!.stopTimer();
    super.dispose();
  }


  void clearAllTextFields() {
    CommonUtils.SELECTEDCONTENT = "";
    setState(() {
      for (var controller in CommonUtils.CONTENTCONTROLLER) {
        controller.clear();
      }
      selectedContentList.clear(); // Also clear the selected content list if needed
      if (focusNodes.isNotEmpty) {
        FocusScope.of(context).requestFocus(focusNodes[0]);
      }
    });


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
            clearAllTextFields();
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
                            text: "${lableModel.d} ${lableModel.detailsOfDamageObserved}",
                            fontColor: MyColor.textColorGrey3,
                            fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                            fontWeight: FontWeight.w600,
                            textAlign: TextAlign.start),
                        SizedBox(height: SizeConfig.blockSizeVertical * SizeUtils.TEXTSIZE_0_9,),
                        CustomDivider(space: 0, color: Colors.black, hascolor: true,),

                        SizedBox(height: SizeConfig.blockSizeVertical * 0.3),


                        CustomeText(
                            text: "${lableModel.s13a} ${lableModel.content}",
                            fontColor: MyColor.textColorGrey3,
                            fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_6,
                            fontWeight: FontWeight.w600,
                            textAlign: TextAlign.start),
                        SizedBox(height: SizeConfig.blockSizeVertical),


                        ListView.builder(
                          itemCount: _showFullList ? contentList.length : (contentList.length > 6 ? 6 : contentList.length),
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            ReferenceData14AList content = contentList[index];
                            TextEditingController controller = CommonUtils.CONTENTCONTROLLER[index];
                            FocusNode focusNode = focusNodes[index];

                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: Directionality(
                                textDirection: uiDirection,
                                child: CustomTextField(
                                  controller: controller,
                                  focusNode: focusNode,
                                  onPress: () {

                                  },
                                  hasIcon: false,
                                  maxLength: 4,
                                  hastextcolor: true,
                                  animatedLabel: true,
                                  needOutlineBorder: true,
                                  labelText: "${content.referenceDescription}",
                                  readOnly: (widget.pageView == 0) ? false : true,
                                  onChanged: (value) {
                                    updateSelectedContentList(index, value);
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
                              ),
                            );
                          },
                        ),

                        if (contentList.length > 6) // Only show the button if the list has more than 4 items
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
                    CommonUtils.SELECTEDCONTENT = selectedContentList.join(',').toString();
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
                    CommonUtils.SELECTEDCONTENT = selectedContentList.join(',').toString();
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

  void updateSelectedContentList(int index, String value) {
    String? identifier = contentList[index].referenceDataIdentifier;

    if (identifier != null) {
      // Remove the existing entry for the identifier if it exists
      selectedContentList.removeWhere((item) => item.startsWith('$identifier~'));

      // Only add the entry if value is not empty
      if (value.isNotEmpty) {
        selectedContentList.add('$identifier~$value');
      }else{
        selectedContentList.remove('$identifier~$value');
      }
    }
  }

  void setTextFieldValues(String input) {
    // Parse the input string into a map
    Map<String, String> identifierMap = {};
    List<String> pairs = input.split(',');

    for (String pair in pairs) {
      List<String> parts = pair.split('~');
      if (parts.length == 2) {
        identifierMap[parts[0]] = parts[1];
      }
    }

    // Set each controller's text based on the identifier
    for (int i = 0; i < contentList.length; i++) {
      String? identifier = contentList[i].referenceDataIdentifier;

      if (identifier != null && identifierMap.containsKey(identifier)) {
        String value = identifierMap[identifier]!;
        CommonUtils.CONTENTCONTROLLER[i].text = value;
        updateSelectedContentList(i, value); // Update the selected list if needed
      }
    }
  }


}
