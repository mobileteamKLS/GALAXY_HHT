import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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

class Damageuipart6 extends StatefulWidget {

  final VoidCallback preclickCallback;
  final VoidCallback nextclickCallback;
  Damageuipart6({super.key, required this.preclickCallback, required this.nextclickCallback});

  @override
  State<Damageuipart6> createState() => _Damageuipart6State();
}

class _Damageuipart6State extends State<Damageuipart6> {

  List<TextEditingController> controllers = [];
  List<FocusNode> focusNodes = [];

  List<String> ContainersList = [
    "Bands Loose",
    "Broken",
    "Crushed",
    "Other",
    "Seams Open",
    "Open",
    "Others",
    "Tape Torn",
    "Torn",
    "Wet",
    "Containers",
  ];





  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    controllers = List.generate(ContainersList.length, (index) => TextEditingController());
    focusNodes = List.generate(ContainersList.length, (index) => FocusNode());
  }

  @override
  void dispose() {
    // Dispose of controllers and focus nodes
    for (var controller in controllers) {
      controller.dispose();
    }
    for (var focusNode in focusNodes) {
      focusNode.dispose();
    }
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
                        Container(
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: MyColor.cardBgColor,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomeText(
                                  text: "14.b) Containers",
                                  fontColor: MyColor.textColorGrey3,
                                  fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_4,
                                  fontWeight: FontWeight.w500,
                                  textAlign: TextAlign.start),
                              SizedBox(height: SizeConfig.blockSizeVertical * SizeUtils.HEIGHT2,),
                              ListView.builder(
                                itemCount: ContainersList.length,
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  String containers = ContainersList[index];
                                  TextEditingController controller = controllers[index];
                                  FocusNode focusNode = focusNodes[index];

                                  return Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                                    child: Directionality(
                                      textDirection: uiDirection,
                                      child: CustomTextField(
                                        controller: controller,
                                        focusNode: focusNode,
                                        onPress: () {},
                                        hasIcon: false,
                                        maxLength: 4,
                                        hastextcolor: true,
                                        animatedLabel: true,
                                        needOutlineBorder: true,
                                        labelText: containers,
                                        readOnly: false,
                                        onChanged: (value) {},
                                        fillColor:  Colors.grey.shade100,
                                        textInputType: TextInputType.number,
                                        inputAction: TextInputAction.next,
                                        hintTextcolor: Colors.black45,
                                        verticalPadding: 0,
                                        digitsOnly: true,
                                        fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_7,
                                        circularCorner: SizeConfig.blockSizeHorizontal * SizeUtils.CIRCULARCORNER,
                                        boxHeight: SizeConfig.blockSizeVertical * SizeUtils.HEIGHT4,
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
