import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:galaxy/module/import/services/flightcheck/flightchecklogic/flightcheckcubit.dart';
import 'package:galaxy/module/import/services/flightcheck/flightchecklogic/flightcheckstate.dart';
import 'package:galaxy/utils/snackbarutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:vibration/vibration.dart';

import '../../../../../../core/images.dart';
import '../../../../../../core/mycolor.dart';
import '../../../../../../language/appLocalizations.dart';
import '../../../../../../language/model/lableModel.dart';
import '../../../../../../manager/timermanager.dart';
import '../../../../../../utils/commonutils.dart';
import '../../../../../../utils/dialogutils.dart';
import '../../../../../../utils/sizeutils.dart';
import '../../../../../../utils/validationmsgcodeutils.dart';
import '../../../../../../widget/customdivider.dart';
import '../../../../../../widget/customebuttons/roundbuttonblue.dart';
import '../../../../../../widget/custometext.dart';
import '../../../../../../widget/customeuiwidgets/enlargedbinaryimagescreen.dart';
import '../../../../../../widget/customeuiwidgets/header.dart';
import '../../../../../../widget/customtextfield.dart';
import '../../../../../onboarding/sizeconfig.dart';
import 'dart:ui' as ui;
import 'package:image/image.dart' as img;

import '../../../../model/flightcheck/awblistmodel.dart';
import '../../../../model/flightcheck/damagedetailmodel.dart';
import '../../../../model/flightcheck/flightcheckuldlistmodel.dart';
import '../../../../model/flightcheck/hawblistmodel.dart';
import '../../../../model/uldacceptance/buttonrolesrightsmodel.dart';

class ImageScreenPage extends StatefulWidget {

  List<ButtonRight> buttonRightsList;
  FlightDetailSummary flightDetailSummary;
  FlightCheckInAWBBDList? aWBItem;
  FlightCheckInHAWBBDList? haWBItem;
  DamageDetailsModel? damageDetailsModel;
  final VoidCallback preclickCallback;
  final VoidCallback nextclickCallback;
  final Function(int) curruentCallback;
  int userId;
  int companyCode;
  int menuId;
  String groupId;
  InactivityTimerManager? inactivityTimerManager;
  int pageView;

  ImageScreenPage({super.key,
    required this.pageView,
    required this.buttonRightsList,
    required this.inactivityTimerManager,
    this.aWBItem,
    this.haWBItem,
    required this.flightDetailSummary,
    required this.damageDetailsModel,
    required this.preclickCallback,
    required this.nextclickCallback,
    required this.curruentCallback,
    required this.userId,
    required this.companyCode,
    required this.menuId,
    required this.groupId});

  @override
  State<ImageScreenPage> createState() => _ImageScreenPageState();
}

class _ImageScreenPageState extends State<ImageScreenPage> {

  List<String> selectImageBase64List = [];
  String images = "";
  String imageCount = "0";

  TextEditingController ghaController = TextEditingController();
  TextEditingController airlineController = TextEditingController();
  TextEditingController securityController = TextEditingController();

  FocusNode ghaFocusNode = FocusNode();
  FocusNode airlineFocusNode = FocusNode();
  FocusNode securityFocusNode = FocusNode();


  TextEditingController wordController = TextEditingController();

  FocusNode wordFocusNode = FocusNode();

  String selectedOption = "Yes";

  List<ReferenceData17List> whetherConditionList = [];
  List<String> selectedWhetherList = [];




  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    whetherConditionList = List.from(widget.damageDetailsModel!.referenceData17List!);



    if(widget.damageDetailsModel?.damageDetail?.weatherCondition == null
        || widget.damageDetailsModel?.damageDetail?.damageRemarked == null
        || widget.damageDetailsModel?.damageDetail?.gHARep == null
        || widget.damageDetailsModel?.damageDetail?.airlineRep == null
        || widget.damageDetailsModel?.damageDetail?.securityRep == null){

    }else{
      CommonUtils.SELECTEDWHETHER = widget.damageDetailsModel!.damageDetail!.weatherCondition!;
      wordController.text = widget.damageDetailsModel!.damageDetail!.damageRemarked!;
      ghaController.text = widget.damageDetailsModel!.damageDetail!.gHARep!;
      airlineController.text = widget.damageDetailsModel!.damageDetail!.airlineRep!;
      securityController.text = widget.damageDetailsModel!.damageDetail!.securityRep!;

    }




    List<String> selectedwhetherConditionListItem = CommonUtils.SELECTEDWHETHER.split(",");
    for (var item in whetherConditionList) {
      if (selectedwhetherConditionListItem.contains(item.referenceDataIdentifier)) {
        selectedWhetherList.add("${item.referenceDataIdentifier},");
      }
    }
    widget.damageDetailsModel!.damageImagesList!.map((e) {
      CommonUtils.SELECTEDIMAGELIST.add(e.BinaryFile!);
    },
    ).toList();

    selectImageBase64List = List.from(CommonUtils.SELECTEDIMAGELIST);
    images = generateImageXMLData(CommonUtils.SELECTEDIMAGELIST);
    imageCount = "${selectImageBase64List.length}";

  }

/*  @override
  void dispose() {
    // Dispose of controllers and focus nodes
    super.dispose();
    widget.inactivityTimerManager!.stopTimer();
  }*/



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


    return BlocListener<FlightCheckCubit, FlightCheckState>(listener: (context, state) {
      if(state is MainLoadingState){
        DialogUtils.showLoadingDialog(context, message: lableModel.loading);
      }else if(state is DamageBreakDownSaveSuccessState){
        DialogUtils.hideLoadingDialog(context);
        if(state.damageBreakDownSaveModel.status == "E"){
          SnackbarUtil.showSnackbar(context, state.damageBreakDownSaveModel.statusMessage!, MyColor.colorRed, icon: FontAwesomeIcons.times);
          Vibration.vibrate(duration: 500);
        }
        else if(state.damageBreakDownSaveModel.status == "V"){
          SnackbarUtil.showSnackbar(context, state.damageBreakDownSaveModel.statusMessage!, MyColor.colorRed, icon: FontAwesomeIcons.times);
          Vibration.vibrate(duration: 500);
        }
        else{


          CommonUtils.SELECTEDWHETHER = "";
          selectedWhetherList.clear();
          wordController.clear();
          ghaController.clear();
          airlineController.clear();
          securityController.clear();

          selectImageBase64List.clear();
          CommonUtils.SELECTEDIMAGELIST.clear();
          imageCount = "0";

          CommonUtils.shipTotalPcs = 0;
          CommonUtils.ShipTotalWt = "0.00";
          CommonUtils.shipDamagePcs = 0;
          CommonUtils.ShipDamageWt = "0.00";
          CommonUtils.shipDifferencePcs = 0;
          CommonUtils.shipDifferenceWt = "0.00";
          CommonUtils.individualWTPerDoc = "0.00";
          CommonUtils.individualWTActChk = "0.00";
          CommonUtils.individualWTDifference = "0.00";
          CommonUtils.SELECTEDMATERIAL = "";
          CommonUtils.SELECTEDTYPE = "";
          CommonUtils.SELECTEDMARKANDLABLE = "";
          CommonUtils.SELECTEDOUTRERPACKING = "";
          CommonUtils.SELECTEDINNERPACKING = "";
          CommonUtils.SELECTEDDAMAGEDISCOVER = "";
          CommonUtils.SELECTEDDAMAGEAPPARENTLY = "";
          CommonUtils.SELECTEDSALVAGEACTION = "";
          CommonUtils.SELECTEDDISPOSITION = "";
          CommonUtils.MISSINGITEM = "Y";
          CommonUtils.VERIFIEDINVOICE = "Y";
          CommonUtils.SUFFICIENT = "Y";
          CommonUtils.EVIDENCE = "Y";
          CommonUtils.REMARKS = "";

          CommonUtils.SELECTEDCONTENT = "";
          CommonUtils.SELECTEDCONTAINER = "";
         /* for (var controller in CommonUtils.CONTENTCONTROLLER) {
            controller.clear();
          }

          for (var controller in CommonUtils.CONTAINERCONTROLLER) {
            controller.clear();
          }*/

          SnackbarUtil.showSnackbar(context, state.damageBreakDownSaveModel.statusMessage!, MyColor.colorGreen, icon: Icons.done);
          Navigator.pop(context, "true");
        }
      }else if(state is DamageBreakDownSaveFailureState){
        DialogUtils.hideLoadingDialog(context);
        SnackbarUtil.showSnackbar(context, state.error, MyColor.colorRed, icon: FontAwesomeIcons.times);
        Vibration.vibrate(duration: 500);
      }
    },
    child: Column(
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

            CommonUtils.SELECTEDWHETHER = "";
            selectedWhetherList.clear();

            wordController.clear();
            ghaController.clear();
            airlineController.clear();
            securityController.clear();

            images = "";
            selectImageBase64List.clear();
            CommonUtils.SELECTEDIMAGELIST.clear();
            imageCount = "0";

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
                            text: "${lableModel.s22} ${lableModel.anyDamageRemarks}",
                            fontColor: MyColor.textColorGrey3,
                            fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_6,
                            fontWeight: FontWeight.w600,
                            textAlign: TextAlign.start),
                        SizedBox(height: SizeConfig.blockSizeVertical * SizeUtils.HEIGHT2),



                        Directionality(
                          textDirection: uiDirection,
                          child: CustomTextField(
                            controller: wordController,
                            focusNode: wordFocusNode,
                            onPress: () {},
                            hasIcon: false,
                            hastextcolor: true,
                            animatedLabel: true,
                            needOutlineBorder: true,
                            labelText: "Exact Wording",
                            readOnly: (widget.pageView == 0) ? false : true,
                            onChanged: (value) {},
                            fillColor:  Colors.grey.shade100,
                            textInputType: TextInputType.text,
                            inputAction: TextInputAction.next,
                            hintTextcolor: Colors.black45,
                            verticalPadding: 0,
                            maxLength: 12,
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
                            text: "${lableModel.s23} ${lableModel.weatherCondition}",
                            fontColor: MyColor.textColorGrey3,
                            fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_6,
                            fontWeight: FontWeight.w600,
                            textAlign: TextAlign.start),


                        SizedBox(height: SizeConfig.blockSizeVertical,),
                        GridView.builder(
                          itemCount: whetherConditionList.length,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3, // Number of columns
                            crossAxisSpacing: 5, // Spacing between columns
                            mainAxisSpacing: 0, // Spacing between rows
                            childAspectRatio: 3, // Adjust based on your desired width/height ratio
                          ),
                          itemBuilder: (context, index) {
                            ReferenceData17List whetherCondition = whetherConditionList[index];

                            return Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Flexible(
                                  child: CustomeText(
                                    text: whetherCondition.referenceDescription!,
                                    fontColor: MyColor.textColorGrey3,
                                    fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5_5,
                                    fontWeight: FontWeight.w500,
                                    textAlign: TextAlign.start,
                                  ),
                                ),
                                Switch(
                                  value: selectedWhetherList.contains("${whetherCondition.referenceDataIdentifier},"),
                                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                  activeColor: MyColor.primaryColorblue,
                                  inactiveThumbColor: MyColor.thumbColor,
                                  inactiveTrackColor: MyColor.textColorGrey2,
                                  trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
                                  onChanged: (value) {

                                    if(widget.pageView == 0){
                                      setState(() {
                                        if (value) {
                                          selectedWhetherList.add("${whetherCondition.referenceDataIdentifier},");
                                        } else {
                                          selectedWhetherList.remove("${whetherCondition.referenceDataIdentifier},");
                                        }
                                      });
                                    }


                                  },
                                )
                              ],
                            );
                          },
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
                            text: "${lableModel.s24} ${lableModel.representative}",
                            fontColor: MyColor.textColorGrey3,
                            fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_6,
                            fontWeight: FontWeight.w600,
                            textAlign: TextAlign.start),
                        SizedBox(height: SizeConfig.blockSizeVertical * SizeUtils.HEIGHT2),


                        Directionality(
                          textDirection: uiDirection,
                          child: CustomTextField(
                            controller: ghaController,
                            focusNode: ghaFocusNode,
                            nextFocus: airlineFocusNode,
                            onPress: () {},
                            hasIcon: false,
                            hastextcolor: true,
                            animatedLabel: true,
                            needOutlineBorder: true,
                            labelText: "GHA Rep.",
                            readOnly: (widget.pageView == 0) ? false : true,
                            onChanged: (value) {},
                            fillColor:  Colors.grey.shade100,
                            textInputType: TextInputType.text,
                            inputAction: TextInputAction.next,
                            hintTextcolor: Colors.black45,
                            verticalPadding: 0,
                            maxLength: 12,
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
                        ),
                        SizedBox(height: SizeConfig.blockSizeVertical * SizeUtils.HEIGHT2,),
                        Directionality(
                          textDirection: uiDirection,
                          child: CustomTextField(
                            controller: airlineController,
                            focusNode: airlineFocusNode,
                            nextFocus: securityFocusNode,
                            onPress: () {},
                            hasIcon: false,
                            hastextcolor: true,
                            animatedLabel: true,
                            needOutlineBorder: true,
                            labelText: "Airline Rep.",
                            readOnly: (widget.pageView == 0) ? false : true,
                            onChanged: (value) {},
                            fillColor:  Colors.grey.shade100,
                            textInputType: TextInputType.text,
                            inputAction: TextInputAction.next,
                            hintTextcolor: Colors.black45,
                            verticalPadding: 0,
                            maxLength: 12,
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
                        ),
                        SizedBox(height: SizeConfig.blockSizeVertical * SizeUtils.HEIGHT2,),
                        Directionality(
                          textDirection: uiDirection,
                          child: CustomTextField(
                            controller: securityController,
                            focusNode: securityFocusNode,
                            onPress: () {},
                            hasIcon: false,
                            hastextcolor: true,
                            animatedLabel: true,
                            needOutlineBorder: true,
                            labelText: "Security Rep.",
                            readOnly: (widget.pageView == 0) ? false : true,
                            onChanged: (value) {},
                            fillColor:  Colors.grey.shade100,
                            textInputType: TextInputType.text,
                            inputAction: TextInputAction.next,
                            hintTextcolor: Colors.black45,
                            verticalPadding: 0,
                            maxLength: 12,
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
                        ),
                        SizedBox(height: SizeConfig.blockSizeVertical * SizeUtils.HEIGHT2,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            InkWell(
                              onTap: () async {
                                var result = await showImageDialog(context, lableModel, 0, selectImageBase64List, widget.pageView);
                                if(result != null){
                                  images = result['images']!;
                                  imageCount = result['imageCount']!;
                                  selectImageBase64List = CommonUtils.SELECTEDIMAGELIST;
                                  setState(() {

                                  });

                                }

                              },
                              child: Row(children: [
                                SvgPicture.asset(camera, height: SizeConfig.blockSizeVertical * SizeUtils.HEIGHT3,),
                                SizedBox(width: SizeConfig.blockSizeHorizontal,),
                                CustomeText(text: "${lableModel.takeViewPhoto}", fontColor: MyColor.primaryColorblue, fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5, fontWeight: FontWeight.w500, textAlign: TextAlign.start)
                              ],),
                            ),
                            Row(

                              children: [
                                CustomeText(text: "${lableModel.photoCount}", fontColor: MyColor.textColorGrey2, fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5, fontWeight: FontWeight.w400, textAlign: TextAlign.start),
                                SizedBox(width: SizeConfig.blockSizeHorizontal,),
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 1),
                                  decoration: BoxDecoration(
                                      color: MyColor.btCountColor,
                                      borderRadius: BorderRadius.circular(SizeConfig.blockSizeHorizontal * SizeUtils.BORDERRADIOUS_6)
                                  ),
                                  child: CustomeText(
                                      text: "${imageCount}",
                                      fontColor: MyColor.textColorGrey2,
                                      fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                      fontWeight: FontWeight.w500,
                                      textAlign: TextAlign.center),
                                )
                              ],
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
                    CommonUtils.SELECTEDWHETHER = selectedWhetherList.join('').toString();
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
                  text: "${lableModel.recordDamage}",
                  press: () async {

                    if(widget.flightDetailSummary.flightStatus == "A"){
                      String totalImages = "$images";

                      print("IAMGSSS ==== $images");

                      if(isButtonEnabled("awbrecorddamage", widget.buttonRightsList)){
                        if(CommonUtils.REMARKS.isEmpty){
                          SnackbarUtil.showSnackbar(context, "Please enter remarks.", MyColor.colorRed, icon: FontAwesomeIcons.times);
                          widget.curruentCallback(9);
                          return;
                        }


                        if (ghaController.text.isEmpty) {
                          openValidationDialog("Please enter GHA Representative.", ghaFocusNode, lableModel);
                          return;
                        }

                        if (airlineController.text.isEmpty) {
                          openValidationDialog("Please enter Airline Representative.", airlineFocusNode, lableModel);
                          return;
                        }

                        if (securityController.text.isEmpty) {
                          openValidationDialog("Please enter Security Representative.", airlineFocusNode, lableModel);
                          return;
                        }





                        String exactWording = wordController.text;
                        String ghaRep = ghaController.text;
                        String airlineRep = airlineController.text;
                        String securityRep = securityController.text;
                        CommonUtils.SELECTEDWHETHER = selectedWhetherList.join('').toString();

                        List<String> awb = widget.damageDetailsModel!.damageAWBDetail!.aWBNo!.split(" ");
                        String awbPrefix = awb[0];
                        String awbNumber = awb[1];



                        int? awbId = (widget.haWBItem == null) ? widget.aWBItem!.iMPAWBRowId : widget.haWBItem!.iMPAWBRowId;
                        int? shipId = (widget.haWBItem == null) ? widget.aWBItem!.iMPShipRowId! : widget.haWBItem!.iMPSHIPRowId;
                        int flightSeqNo = widget.flightDetailSummary.flightSeqNo!;
                        String typeOfDiscrepancy = CommonUtils.SELECTEDTYPEOFDISCRPENCY;

                        int shipTotalPcs =  CommonUtils.shipTotalPcs;
                        String ShipTotalWt =  CommonUtils.ShipTotalWt;
                        int shipDamagePcs =  CommonUtils.shipDamagePcs;
                        String ShipDamageWt =  CommonUtils.ShipDamageWt;
                        int shipDifferencePcs =  CommonUtils.shipDifferencePcs;
                        String shipDifferenceWt =  CommonUtils.shipDifferenceWt;

                        String individualWTPerDoc =  CommonUtils.individualWTPerDoc;
                        String individualWTActChk =  CommonUtils.individualWTActChk;
                        String individualWTDifference =  CommonUtils.individualWTDifference;

                        String containerMaterial = CommonUtils.SELECTEDMATERIAL;
                        String containerType = CommonUtils.SELECTEDTYPE;
                        String marksLabels = CommonUtils.SELECTEDMARKANDLABLE;
                        String outerPacking = CommonUtils.SELECTEDOUTRERPACKING;
                        String innerPacking = CommonUtils.SELECTEDINNERPACKING;
                        String damageObserContent = CommonUtils.SELECTEDCONTENT;
                        String damageObserContainers = CommonUtils.SELECTEDCONTAINER;
                        String damageDiscovered = CommonUtils.SELECTEDDAMAGEDISCOVER;
                        String spaceForMissing = CommonUtils.MISSINGITEM;
                        String verifiedInvoice = CommonUtils.VERIFIEDINVOICE;
                        String isSufficient = CommonUtils.SUFFICIENT;
                        String evidenceOfPilerage = CommonUtils.EVIDENCE;
                        String remarksValue = CommonUtils.REMARKS;
                        String aparentCause = CommonUtils.SELECTEDDAMAGEAPPARENTLY;
                        String salvageAction = CommonUtils.SELECTEDSALVAGEACTION;
                        String disposition = CommonUtils.SELECTEDDISPOSITION;
                        String damageRemarked = exactWording;
                        String weatherCondition = CommonUtils.SELECTEDWHETHER;
                        String GHARepresent = ghaRep;
                        String AirlineRepresent = airlineRep;
                        String SecurityRepresent = securityRep;
                        int problemSeqId = widget.damageDetailsModel!.damageDetail!.seqNo!;

                        context.read<FlightCheckCubit>().damageBreakDownSave(
                            awbPrefix, awbNumber,
                            awbId!, shipId!, flightSeqNo,
                            typeOfDiscrepancy,
                            shipTotalPcs, ShipTotalWt, shipDamagePcs, ShipDamageWt, shipDifferencePcs, shipDifferenceWt,
                            individualWTPerDoc, individualWTActChk, individualWTDifference,
                            containerMaterial,
                            containerType,
                            marksLabels,
                            outerPacking,
                            innerPacking,
                            damageObserContent,
                            damageObserContainers,
                            damageDiscovered,
                            spaceForMissing,
                            verifiedInvoice,
                            isSufficient,
                            evidenceOfPilerage,
                            remarksValue,
                            aparentCause,
                            salvageAction,
                            disposition,
                            damageRemarked,
                            weatherCondition,
                            GHARepresent,
                            AirlineRepresent,
                            SecurityRepresent,
                            problemSeqId,
                            totalImages,
                            widget.groupId,
                            widget.userId, widget.companyCode, widget.menuId);

                      }
                      else{
                        SnackbarUtil.showSnackbar(context, ValidationMessageCodeUtils.AuthorisedRolesAndRightsMsg, MyColor.colorRed, icon: FontAwesomeIcons.times);
                        Vibration.vibrate(duration: 500);
                      }
                    }else if(widget.flightDetailSummary.flightStatus == "F"){
                      SnackbarUtil.showSnackbar(context, "${lableModel.flightisFinalizedMsg}", MyColor.colorRed, icon: FontAwesomeIcons.times);
                      Vibration.vibrate(duration: 500);
                    }else if(widget.flightDetailSummary.flightStatus == "N"){
                      SnackbarUtil.showSnackbar(context, "${lableModel.flightisNotArrivedMsg}", MyColor.colorRed, icon: FontAwesomeIcons.times);
                      Vibration.vibrate(duration: 500);
                    }



                  },
                ),
              ),
            ],
          ),
        )
      ],
    ),
    );
  }

  static Future<Map<String, String>?> showImageDialog(BuildContext context, LableModel lableModel, int recordView, List<String> selectImageList, int pageView) {

    print("IMAGELIST COUNT S ==== ${selectImageList.length}");

    List<String> imageList = (selectImageList.isNotEmpty) ? List.from(selectImageList) : [];

    print("IMAGELIST COUNT ==== ${imageList.length}");


    FocusNode imageFocus = FocusNode();
    FocusNode removeIconFocus = FocusNode();


    final ImagePicker _picker = ImagePicker();


    Future<File?> _resizeImage(File imageFile) async {
      try {
        Uint8List imageBytes = await imageFile.readAsBytes();
        img.Image? decodedImage = img.decodeImage(imageBytes);

        if (decodedImage != null) {
          img.Image resizedImage = img.copyResize(decodedImage, width: 500, height: 500);
          // Save the resized image to a file
          File resizedImageFile = await imageFile.writeAsBytes(img.encodeJpg(resizedImage));
          return resizedImageFile;
        }
      } catch (e) {
        print('Error resizing image: $e');
      }
      return null;
    }

    String generateImageXMLData(List<String> selectImageList) {
      StringBuffer xmlBuffer = StringBuffer();
      xmlBuffer.write('<BinaryImageLists>');
      for (String base64Image in selectImageList) {
        xmlBuffer.write('<BinaryImageList>');
        xmlBuffer.write('<BinaryImage>$base64Image</BinaryImage>');
        xmlBuffer.write('</BinaryImageList>');
      }
      xmlBuffer.write('</BinaryImageLists>');
      return xmlBuffer.toString();
    }


    Future<void> _takePicture(StateSetter setState, LableModel lableModel) async {
      var status = await Permission.camera.status;
      if (!status.isGranted) {
        await Permission.camera.request();
      }

      if (await Permission.camera.isGranted) {
        final pickedFile = await _picker.pickImage(source: ImageSource.camera);

        if (pickedFile != null) {
          DialogUtils.showLoadingDialog(context, message: lableModel.loading);
          try {
            // Resize the image
            File? resizedImageFile = await _resizeImage(File(pickedFile.path));

            if (resizedImageFile != null) {
              String base64Image = base64Encode(await resizedImageFile.readAsBytes());
              setState(() {
                imageList.insert(0, base64Image);
              });
            } else {
              print('Failed to resize image.');
            }
          } finally {
            DialogUtils.hideLoadingDialog(context);
          }
        } else {
          print('No image selected.');
        }
      } else {
        print('Camera permission not granted.');
      }
    }

    Future<void> _attachPhotoFromGallery(StateSetter setState, LableModel lableModel) async {
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        DialogUtils.showLoadingDialog(context, message: lableModel.loading);
        try {
          // Resize the image if needed
          File? resizedImageFile = await _resizeImage(File(pickedFile.path));

          if (resizedImageFile != null) {
            String base64Image = base64Encode(await resizedImageFile.readAsBytes());
            setState(() {
              imageList.insert(0, base64Image); // Add the image to the beginning of the list
            });
          } else {
            print('Failed to resize image.');
          }
        } finally {
          DialogUtils.hideLoadingDialog(context);
        }
      } else {
        print('No image selected.');
      }
    }



    return showModalBottomSheet<Map<String, String>>(
      backgroundColor: MyColor.colorWhite,
      context: context,
      isScrollControlled: true,
      builder: (BuildContext newContext) {
        return StatefulBuilder(
            builder:(BuildContext context, StateSetter setState) {
              return FractionallySizedBox(
                widthFactor: 1,  // Adjust the width to 90% of the screen width
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 15, top: 15, left: 15, bottom: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CustomeText(text: "${lableModel.addPhotos}", fontColor:  MyColor.colorBlack, fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_2_0, fontWeight: FontWeight.w500, textAlign: TextAlign.start),
                            InkWell(
                                onTap: () {
                                  Navigator.pop(context, null);
                                },
                                child: SvgPicture.asset(cancel, height: SizeConfig.blockSizeVertical * SizeUtils.HEIGHT3,))
                          ],
                        ),
                      ),
                      CustomDivider(
                        space: 0,
                        color: Colors.black,
                        hascolor: true,
                        thickness: 1,
                      ),
                      SizedBox(height: SizeConfig.blockSizeVertical),
                      Padding(
                        padding: const EdgeInsets.only(right: 15, top: 15, left: 15),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 1,
                              child: InkWell(
                                onTap: () {
                                  if(pageView == 0){
                                    _takePicture(setState, lableModel);
                                  }

                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SvgPicture.asset(camera, height: SizeConfig.blockSizeVertical * SizeUtils.HEIGHT3,),
                                    SizedBox(width: SizeConfig.blockSizeHorizontal * SizeUtils.WIDTH2,),
                                    CustomeText(text: "${lableModel.takePhoto}", fontColor: MyColor.primaryColorblue, fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5, fontWeight: FontWeight.w500, textAlign: TextAlign.start)
                                  ],),
                              ),
                            ),

                            Expanded(
                              flex: 1,
                              child: InkWell(
                                onTap: () {
                                  if(pageView == 0){
                                    _attachPhotoFromGallery(setState, lableModel);
                                  }

                                },
                                child: Row(children: [
                                  SvgPicture.asset(link, height: SizeConfig.blockSizeVertical * SizeUtils.HEIGHT3,),
                                  SizedBox(width: SizeConfig.blockSizeHorizontal * SizeUtils.WIDTH2,),
                                  CustomeText(text: "${lableModel.attachPhotos}", fontColor: MyColor.primaryColorblue, fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5, fontWeight: FontWeight.w500, textAlign: TextAlign.start)
                                ],),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: SizeConfig.blockSizeVertical),
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: CustomeText(text: "${lableModel.damagePhotos}", fontColor:  MyColor.colorBlack, fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5, fontWeight: FontWeight.w500, textAlign: TextAlign.start),
                      ),
                      SizedBox(height: SizeConfig.blockSizeVertical),

                      if (recordView == 0 || recordView == 2)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: GridView.builder(
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                // Number of columns
                                crossAxisSpacing: 5,
                                // Spacing between columns
                                mainAxisSpacing: 7),
                            // Spacing between rows),
                            shrinkWrap: true,
                            itemCount: imageList.length,
                            // Limit to 3 items max
                            itemBuilder: (context, index) {
                              String base64Image = imageList[index];

                              return Stack(
                                children: [
                                  // Image displayed in the grid
                                  InkWell(
                                    onTap: () {
                                      // Navigate to Enlarge image screen
                                      Navigator.push(
                                        context,
                                        CupertinoPageRoute(
                                            builder: (context) =>
                                                EnlargedBinaryImageScreen(
                                                  binaryFile: base64Image,
                                                  imageList: imageList,
                                                  index: index,
                                                ),
                                            fullscreenDialog:
                                            true),
                                      );
                                    },
                                    focusNode: imageFocus,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(12.0),
                                      child: Image.memory(base64Decode(base64Image),
                                        fit: BoxFit.cover,
                                        width: double.infinity,
                                        // Ensure the image takes up the full space
                                        height: double.infinity, // Ensure the image takes up the full space
                                      ),
                                    ),
                                  ),

                                  // Positioned remove icon on top right of the image
                                  (pageView == 0) ? Positioned(
                                    top: 5,
                                    right: 5,
                                    child: InkWell(
                                      onTap: () {
                                        setState(() {
                                          imageList.removeAt(index); // Remove the selected image
                                        });
                                      },
                                      focusNode: removeIconFocus,
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                        decoration: const BoxDecoration(
                                            borderRadius: BorderRadius.all(Radius.circular(10)),
                                            color: MyColor.colorWhite
                                        ),

                                        child: SvgPicture.asset(trashcan, height: SizeConfig.blockSizeVertical * SizeUtils.HEIGHT2,),
                                      ),
                                    ),
                                  ) : Container(),
                                ],
                              );
                            },
                          ),
                        ),

                      if (recordView == 1)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: GridView.builder(
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                // Number of columns
                                crossAxisSpacing: 5,
                                // Spacing between columns
                                mainAxisSpacing: 5),
                            // Spacing between rows),
                            shrinkWrap: true,
                            itemCount: imageList.length,
                            // Limit to 3 items max
                            itemBuilder:
                                (context,
                                index) {
                              String
                              base64Image = imageList[index];
                              return Stack(
                                children: [
                                  // Image displayed in the grid
                                  InkWell(
                                    onTap: () {
                                      // Navigate to Enlarge image screen
                                      Navigator
                                          .push(
                                        context,
                                        CupertinoPageRoute(
                                            builder: (context) =>
                                                EnlargedBinaryImageScreen(
                                                  binaryFile: base64Image,
                                                  imageList: imageList,
                                                  index: index,
                                                ),
                                            fullscreenDialog:
                                            true),
                                      );
                                    },
                                    focusNode: imageFocus,
                                    child:
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(15.0),
                                      child: Image.memory(base64Decode(base64Image),
                                        fit: BoxFit.cover,
                                        width: double.infinity,
                                        // Ensure the image takes up the full space
                                        height: double.infinity, // Ensure the image takes up the full space
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ),

                      SizedBox(height: SizeConfig.blockSizeVertical),
                      CustomDivider(
                        space: 0,
                        color: Colors.black,
                        hascolor: true,
                        thickness: 1,
                      ),
                      SizedBox(height: SizeConfig.blockSizeVertical),
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: RoundedButtonBlue(
                                text: "${lableModel.cancel}",
                                isborderButton: true,
                                press: () {
                                  Navigator.pop(context, null);
                                },
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              flex: 1,
                              child: RoundedButtonBlue(
                                text: "${lableModel.save}",
                                press: () {

                                  CommonUtils.SELECTEDIMAGELIST = imageList;
                                  String images = "${generateImageXMLData(imageList)}";
                                  String count = imageList.length.toString();
                                  Navigator.pop(context, {
                                    "images" : images,
                                    "imageCount" : count
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
        );
      },
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

  String generateImageXMLData(List<String> selectImageList) {
    StringBuffer xmlBuffer = StringBuffer();
    xmlBuffer.write('<BinaryImageLists>');
    for (String base64Image in selectImageList) {
      xmlBuffer.write('<BinaryImageList>');
      xmlBuffer.write('<BinaryImage>$base64Image</BinaryImage>');
      xmlBuffer.write('</BinaryImageList>');
    }
    xmlBuffer.write('</BinaryImageLists>');
    return xmlBuffer.toString();
  }


  bool isButtonEnabled(String buttonId, List<ButtonRight> buttonList) {
    ButtonRight? button = buttonList.firstWhere(
          (button) => button.buttonId == buttonId,
    );
    return button.isEnable == 'Y';
  }

}
