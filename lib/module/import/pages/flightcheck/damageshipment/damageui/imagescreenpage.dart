import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../../../core/images.dart';
import '../../../../../../core/mycolor.dart';
import '../../../../../../language/appLocalizations.dart';
import '../../../../../../language/model/lableModel.dart';
import '../../../../../../utils/commonutils.dart';
import '../../../../../../utils/dialogutils.dart';
import '../../../../../../utils/sizeutils.dart';
import '../../../../../../widget/customdivider.dart';
import '../../../../../../widget/customebuttons/roundbuttonblue.dart';
import '../../../../../../widget/custometext.dart';
import '../../../../../../widget/customeuiwidgets/enlargedbinaryimagescreen.dart';
import '../../../../../../widget/customeuiwidgets/header.dart';
import '../../../../../../widget/customtextfield.dart';
import '../../../../../onboarding/sizeconfig.dart';
import 'dart:ui' as ui;
import 'package:image/image.dart' as img;

import '../../../../model/flightcheck/damagedetailmodel.dart';

class ImageScreenPage extends StatefulWidget {
  DamageDetailsModel? damageDetailsModel;
  final VoidCallback preclickCallback;
  final VoidCallback nextclickCallback;
  ImageScreenPage({super.key, required this.damageDetailsModel, required this.preclickCallback, required this.nextclickCallback});

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


    selectImageBase64List = List.from(CommonUtils.SELECTEDIMAGELIST);
    images = generateImageXMLData(CommonUtils.SELECTEDIMAGELIST);
    imageCount = "${selectImageBase64List.length}";

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
                            text: "22) Any damage remarked in : a) The AWB. b) The Manifest",
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
                            readOnly: false,
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
                            text: "23) Weather Condition ?",
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
                                  value: selectedWhetherList.contains("${whetherCondition.referenceDataIdentifier}~"),
                                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                  activeColor: MyColor.primaryColorblue,
                                  inactiveThumbColor: MyColor.thumbColor,
                                  inactiveTrackColor: MyColor.textColorGrey2,
                                  trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
                                  onChanged: (value) {
                                    setState(() {
                                      if (value) {
                                        selectedWhetherList.add("${whetherCondition.referenceDataIdentifier}~");
                                      } else {
                                        selectedWhetherList.remove("${whetherCondition.referenceDataIdentifier}~");
                                      }
                                    });
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
                            text: "24) Representative",
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
                            onPress: () {},
                            hasIcon: false,
                            hastextcolor: true,
                            animatedLabel: true,
                            needOutlineBorder: true,
                            labelText: "GHA Rep.",
                            readOnly: false,
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
                            onPress: () {},
                            hasIcon: false,
                            hastextcolor: true,
                            animatedLabel: true,
                            needOutlineBorder: true,
                            labelText: "Airline Rep.",
                            readOnly: false,
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
                            readOnly: false,
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
                                var result = await showImageDialog(context, lableModel, 0, selectImageBase64List);
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
                  text: "Record Damage",
                  press: () async {
                    String exactWording = wordController.text;
                    String ghaRep = ghaController.text;
                    String airlineRep = airlineController.text;
                    String securityRep = securityController.text;
                    CommonUtils.SELECTEDWHETHER = selectedWhetherList.join('').toString();



                  },
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  static Future<Map<String, String>?> showImageDialog(BuildContext context, LableModel lableModel, int recordView, List<String> selectImageList) {

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
                                  _takePicture(setState, lableModel);
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
                                  _attachPhotoFromGallery(setState, lableModel);
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
                                  Positioned(
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
                                  ),
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
                                                  imageList: imageList!,
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

}
