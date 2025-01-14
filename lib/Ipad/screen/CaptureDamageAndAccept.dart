import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../core/images.dart';
import '../../core/mycolor.dart';

import '../../module/onboarding/sizeconfig.dart';
import '../../utils/commonutils.dart';
import '../../utils/dialogutils.dart';
import '../../utils/sizeutils.dart';
import '../../widget/customdivider.dart';
import '../../widget/customebuttons/roundbuttonblue.dart';
import '../../widget/customeedittext/customeedittextwithborder.dart';
import '../../widget/custometext.dart';
import '../../widget/customeuiwidgets/enlargedbinaryimagescreen.dart';
import '../auth/auth.dart';
import '../modal/ShipmentAcceptanceModal.dart';
import '../utils/global.dart';
import '../widget/customDialog.dart';
import 'ImportShipmentListing.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:ui' as ui;
import 'package:image/image.dart' as img;

class CaptureDamageandAccept extends StatefulWidget {
  final ConsignmentAcceptedList shipmentData;
  const CaptureDamageandAccept({super.key, required this.shipmentData});

  @override
  State<CaptureDamageandAccept> createState() => _CaptureDamageandAcceptState();
}

class _CaptureDamageandAcceptState extends State<CaptureDamageandAccept> {
  @override
  void initState() {
    super.initState();
    getDamageDetails(widget.shipmentData );
  }
  final AuthService authService = AuthService();
  Map<String, bool> damageTypes = {
    'Bands Loose': false,
    'Broken': false,
    'Crushed': false,
    'Others': false,
    'Tape Torn': false,
    'Wet': false,
    'Containers': false,
  };

  TextEditingController dmgNOPController = TextEditingController();
  TextEditingController dmgWTController = TextEditingController();
  TextEditingController remarksController = TextEditingController();
  FocusNode rcvNOPFocusNode = FocusNode();

  bool showMore = false;
  bool isLoading = false;
  bool hasNoRecord = false;
  bool isSelected = false;
  List<String> selectImageBase64List = [];
  String images = "";
  String imagesArray = "";
  String imageCount = "0";
  int diffNop=0;
  double diffWt=0.00;
  int problemSeqId=0;
  late List<DamageData14BList> referenceData14BList;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
            automaticallyImplyLeading: false,
            title: Row(
              children: [
                InkWell(
                  onTap: () {
                  },
                  child: Padding(padding: const EdgeInsets.all(2.0),
                    child: SvgPicture.asset(drawer, height: SizeConfig.blockSizeVertical * SizeUtils.ICONSIZE2,),
                  ),
                ),
                Text(
                  isCES?'  Warehouse Operations':"  Customs Operation",
                  style: TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 24,color: Colors.white),
                ),
              ],
            ),
            iconTheme: const IconThemeData(color: Colors.white, size: 32),
            toolbarHeight: 80,
            flexibleSpace: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF0057D8),
                    Color(0xFF1c86ff),
                  ],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
              ),
            ),
            actions: [
              // SvgPicture.asset(
              //   usercog,
              //   height: 25,
              // ),
              // const SizedBox(
              //   width: 10,
              // ),
              // SvgPicture.asset(
              //   bell,
              //   height: 25,
              // ),
              // const SizedBox(
              //   width: 10,
              // ),
            ]),
        // drawer: const Drawer(),
        body: Stack(
          children: [
            Container(

              color: MyColor.screenBgColor,
              child: Padding(
                padding: EdgeInsets.only(top: 20, left: 20, right: 20),
                child: Material(
                  color: Colors.transparent,
                  // Ensures background transparency
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                GestureDetector(
                                  child:  const Icon(Icons.arrow_back_ios,
                                      color: MyColor.primaryColorblue),
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                ),
                                const SizedBox(
                                  width: 4,
                                ),
                                const Text(
                                  'Capture Damage & Accept',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 22,
                                  ),
                                ),
                              ],
                            ),
                            // GestureDetector(
                            //   child: const Row(
                            //     children: [Icon(Icons.restart_alt_outlined, color: Colors.grey,),
                            //       Text(
                            //         'Reset',
                            //         style: TextStyle(
                            //             fontWeight: FontWeight.normal, fontSize: 18),
                            //       ),],
                            //   ),
                            //   onTap: (){
                            //     setState(() {
                            //       isSelected=false;
                            //     });
                            //     print("RESET");
                            //   },
                            // )
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12.0),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                spreadRadius: 2,
                                blurRadius: 8,
                                offset: const Offset(
                                    0, 3), // changes position of shadow
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 14, horizontal: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(

                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          SizedBox(
                                            width: MediaQuery.sizeOf(context)
                                                    .width*0.9,
                                            child: Padding(
                                              padding: const EdgeInsets.only(left: 8),
                                              child: Row(
                                                children: [
                                                   Text(
                                                    'Unserviceable Shipment (${widget.shipmentData.documentNo})',
                                                    style: const TextStyle(
                                                      fontSize: 18,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                  Spacer(),
                                                  // Theme(
                                                  //   data: ThemeData(useMaterial3: false),
                                                  //   child: Switch(
                                                  //     onChanged: (value) async{
                                                  //
                                                  //       setState(()  {
                                                  //
                                                  //       });
                                                  //     },
                                                  //     value: true,
                                                  //     activeColor: MyColor.primaryColorblue,
                                                  //     activeTrackColor: MyColor.bgColorGrey,
                                                  //   ),
                                                  // ),
                                                ],
                                              ),
                                            ),
                                          ),

                                        ],
                                      ),
                                      SizedBox(
                                        height:
                                        MediaQuery.sizeOf(context).height *
                                            0.02,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                        children: [
                                          SizedBox(
                                            width: MediaQuery.sizeOf(context)
                                                .width *
                                                0.45,
                                            child: Row(
                                              children: [
                                                SizedBox(
                                                  height:
                                                  MediaQuery.sizeOf(context)
                                                      .height *
                                                      0.04,
                                                  width:
                                                  MediaQuery.sizeOf(context)
                                                      .width *
                                                      0.22,
                                                  child:
                                                  CustomeEditTextWithBorder(
                                                    lablekey: 'MAWB',
                                                    hasIcon: false,
                                                    hastextcolor: true,
                                                    animatedLabel: true,
                                                    needOutlineBorder: true,
                                                    labelText: "Damaged NoP*",
                                                    controller:
                                                    dmgNOPController,
                                                    focusNode: rcvNOPFocusNode,
                                                    readOnly: false,
                                                    onPress: () {},
                                                    textInputType:
                                                    TextInputType.number,
                                                    maxLength: 4,
                                                    fontSize: 18,
                                                    onChanged: (String, bool) {
                                                      print("Change");
                                                      if(int.parse(dmgNOPController.text)>widget.shipmentData.totalNpo){
                                                        dmgNOPController.text=dmgNOPController.text.substring(0,dmgNOPController.text.length-1);
                                                        showDataNotFoundDialog(context, "Damaged pcs can not be greater than received pcs");
                                                      }
                                                      else{
                                                        setState(() {
                                                          diffNop=widget.shipmentData.totalNpo-int.parse(dmgNOPController.text);
                                                        });
                                                      }
                                                    },
                                                  ),
                                                ),
                                                const SizedBox(
                                                  width: 15,
                                                ),
                                                SizedBox(
                                                  height:
                                                  MediaQuery.sizeOf(context)
                                                      .height *
                                                      0.04,
                                                  width:
                                                  MediaQuery.sizeOf(context)
                                                      .width *
                                                      0.20,
                                                  child:
                                                  CustomeEditTextWithBorder(
                                                    lablekey: 'MAWB',
                                                    hasIcon: false,
                                                    hastextcolor: true,
                                                    animatedLabel: true,
                                                    needOutlineBorder: true,
                                                    onPress: () {},
                                                    labelText:
                                                    "Damaged Weight*",
                                                    readOnly: false,
                                                    controller: dmgWTController,
                                                    textInputType:
                                                    TextInputType.number,
                                                    maxLength: 7,
                                                    fontSize: 18,
                                                    onChanged:
                                                        (String, bool) {
                                                          if(double.parse(dmgWTController.text)>widget.shipmentData.totalWt){
                                                            dmgWTController.text=dmgWTController.text.substring(0,dmgWTController.text.length-1);
                                                            showDataNotFoundDialog(context, "Damaged wt can not be greater than received wt");
                                                          }
                                                          else {
                                                           setState(() {
                                                             diffWt = widget
                                                                 .shipmentData
                                                                 .totalWt -
                                                                 double.parse(
                                                                     dmgWTController
                                                                         .text);
                                                           });
                                                          }
                                                        },
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            width: MediaQuery.sizeOf(context)
                                                .width *
                                                0.45,
                                            child: Row(
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                SizedBox(
                                                  height:
                                                  MediaQuery.sizeOf(context)
                                                      .height *
                                                      0.04,
                                                  width:
                                                  MediaQuery.sizeOf(context)
                                                      .width *
                                                      0.30,
                                                  child:
                                                  Center(child: Row(
                                                    children: [
                                                      Text("Difference:  ",style: TextStyle(fontSize: 16)),
                                                      Text("${diffNop}/${diffWt.toStringAsFixed(2)} KG",style: TextStyle(fontSize: 16,fontWeight: FontWeight.w700)),
                                                    ],
                                                  )),
                                                ),
                                                const SizedBox(
                                                  width: 20,
                                                ),
                                                // SizedBox(
                                                //   height:
                                                //   MediaQuery.sizeOf(context)
                                                //       .height *
                                                //       0.04,
                                                //   width:
                                                //   MediaQuery.sizeOf(context)
                                                //       .width *
                                                //       0.20,
                                                //   child: Text("ABC"),
                                                // )
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),

                                      SizedBox(
                                        height:
                                            MediaQuery.sizeOf(context).height *
                                                0.01,
                                      ),
                                      const Row(
                                        children: [
                                          Text("  DAMAGE TYPE",style: TextStyle(color: Colors.black,fontWeight: FontWeight.w800,fontSize: 16),),
                                        ],
                                      ),
                                      isLoading
                                          ? const Center(
                                          child: SizedBox(
                                              height: 100,
                                              width: 100,
                                              child: CircularProgressIndicator()))
                                          : Padding(
                                            padding: const EdgeInsets.only(
                                                top: 8.0, left: 0.0, bottom: 100),
                                            child: SizedBox(
                                              width: MediaQuery.of(context).size.width / 1.01,
                                              child: (hasNoRecord)
                                                  ? Container(
                                                height: 400,
                                                child: const Center(
                                                  child: Text("NO RECORD FOUND"),
                                                ),
                                              ):    ListView.builder(
                                                physics:
                                                const NeverScrollableScrollPhysics(),
                                        itemBuilder: (BuildContext, index) {
                                          final item = referenceData14BList[index];
                                          isSelected = item.isSelected == 'Y';

                                          return Container(
                                            padding: EdgeInsets.only(left: 8),
                                            decoration: const BoxDecoration(
                                              border: Border(
                                                bottom: BorderSide(
                                                  color: Color(0XFFE4E7EB),
                                                  width: 1.5,
                                                ),
                                              ),
                                            ),
                                            width: MediaQuery.of(context).size.width * 0.9,
                                            child: Row(
                                              children: [
                                                Text(
                                                  item.referenceDescription!,
                                                  style: const TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                                const Spacer(),
                                                Theme(
                                                  data: ThemeData(useMaterial3: false),
                                                  child: Switch(
                                                    onChanged: (value) {
                                                      setState(() {
                                                        referenceData14BList[index].isSelected = value ? 'Y' : 'N';
                                                      });
                                                    },
                                                    value: isSelected,
                                                    activeColor: MyColor.primaryColorblue,
                                                    activeTrackColor: Colors.grey,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                        itemCount: referenceData14BList.length,
                                        shrinkWrap: true,
                                        padding: const EdgeInsets.all(2),
                                      )
                                                ,
                                            ),
                                          ),




                                      // Column(
                                      //   children: [
                                      //     Expanded(
                                      //       child:SingleChildScrollView(
                                      //         child:  ListView.builder(
                                      //           physics:
                                      //           const NeverScrollableScrollPhysics(),
                                      //           shrinkWrap: true,
                                      //           itemCount: damageTypes.length,
                                      //           itemBuilder: (context, index) {
                                      //             if (index >= damageTypes.length) {
                                      //
                                      //               return SwitchListTile(
                                      //                 title: Text('Additional Damage Type ${index - damageTypes.length + 1}'),
                                      //                 value: false,
                                      //                 onChanged: (value) {
                                      //                   // Handle switch change for additional items
                                      //                 },
                                      //               );
                                      //             } else {
                                      //               String key = damageTypes.keys.elementAt(index);
                                      //               return SwitchListTile(
                                      //                 title: Text(key),
                                      //                 value: damageTypes[key]!,
                                      //                 onChanged: (value) {
                                      //                   setState(() {
                                      //                     damageTypes[key] = value;
                                      //                   });
                                      //                 },
                                      //               );
                                      //             }
                                      //           },
                                      //         ),
                                      //       ),
                                      //     ),
                                      //   ],
                                      // ),


                                      SizedBox(
                                        height:
                                            MediaQuery.sizeOf(context).height *
                                                0.02,
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.sizeOf(context).height * 0.015,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12.0),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                spreadRadius: 2,
                                blurRadius: 8,
                                offset: const Offset(
                                    0, 3), // changes position of shadow
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 18, horizontal: 18),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomeEditTextWithBorder(
                                  lablekey: 'MAWB',
                                  hasIcon: false,
                                  hastextcolor: true,
                                  animatedLabel: true,
                                  controller: remarksController,
                                  onPress: () {},
                                  needOutlineBorder:
                                  true,
                                  noUpperCase: true,
                                  isSpaceAllowed: true,
                                  labelText: "Remarks*",
                                  readOnly: false,
                                  maxLength: 500,
                                  maxLines: 4,
                                  fontSize: 18,
                                  onChanged:
                                      (String, bool) {},
                                ),
                                SizedBox(height: 10,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    InkWell(
                                      onTap: () async {
                                        var result = await showImageDialog(context, 0, selectImageBase64List);
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
                                        CustomeText(text: "Take / View Photo", fontColor: MyColor.primaryColorblue, fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5, fontWeight: FontWeight.w500, textAlign: TextAlign.start)
                                      ],),
                                    ),
                                    Row(

                                      children: [
                                        CustomeText(text: "Photo Count", fontColor: MyColor.textColorGrey2, fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5, fontWeight: FontWeight.w400, textAlign: TextAlign.start),
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
                        ),
                        SizedBox(
                          height: MediaQuery.sizeOf(context).height * 0.015,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12.0),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                spreadRadius: 2,
                                blurRadius: 8,
                                offset: const Offset(
                                    0, 3), // changes position of shadow
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 14, horizontal: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(
                                      height: 45,
                                      width: MediaQuery.sizeOf(context).width *
                                          0.42,
                                      child: OutlinedButton(
                                        style: OutlinedButton.styleFrom(
                                          side: const BorderSide(
                                              color: MyColor.primaryColorblue),
                                          textStyle: const TextStyle(
                                            fontSize: 18,
                                            color: MyColor.primaryColorblue,
                                          ),
                                          shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(8)),
                                          ),
                                        ),
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: const Text(
                                            "Cancel"),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    SizedBox(
                                      height: 45,
                                      width: MediaQuery.sizeOf(context).width *
                                          0.42,
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              MyColor.primaryColorblue,
                                          textStyle: const TextStyle(
                                            fontSize: 18,
                                            color: Colors.white,
                                          ),
                                          shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(8)),
                                          ),
                                        ),
                                        onPressed: () {
                                          saveDamage(widget.shipmentData);
                                        },
                                        child: const Text(
                                          "Save",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),

                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.sizeOf(context).height * 0.09,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: IgnorePointer(
                child: CustomPaint(
                  size: Size(MediaQuery.of(context).size.width,
                      100), // Adjust the height as needed
                  painter: AppBarPainterGradient(),
                ),
              ),
            ),
          ],
        ),
        // floatingActionButton: Theme(
        //   data: ThemeData(useMaterial3: false),
        //   child: FloatingActionButton(
        //     onPressed: () {
        //       Navigator.push(
        //           context, MaterialPageRoute(builder: (_) => CreateShipment()));
        //     },
        //     backgroundColor: MyColor.primaryColorblue,
        //     child: const Icon(Icons.add),
        //   ),
        // ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        extendBody: true,
        bottomNavigationBar: BottomAppBar(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          height: 60,
          color: Colors.white,
          surfaceTintColor: Colors.white,
          shape: const CircularNotchedRectangle(),
          notchMargin: 5,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              GestureDetector(
                onTap: () {},
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(CupertinoIcons.chart_pie),
                    Text("Dashboard"),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {},
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.help_outline,
                      color: MyColor.primaryColorblue,
                    ),
                    Text(
                      "User Help",
                      style: TextStyle(color: MyColor.primaryColorblue),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static Future<Map<String, String>?> showImageDialog(BuildContext context,  int recordView, List<String> selectImageList) {

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


    Future<void> _takePicture(StateSetter setState, ) async {
      var status = await Permission.camera.status;
      if (!status.isGranted) {
        await Permission.camera.request();
      }

      if (await Permission.camera.isGranted) {
        final pickedFile = await _picker.pickImage(source: ImageSource.camera);

        if (pickedFile != null) {
          DialogUtils.showLoadingDialog(context, message:"Loading...");
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

    Future<void> _attachPhotoFromGallery(StateSetter setState) async {
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        DialogUtils.showLoadingDialog(context, message: "Loading...");
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
                            CustomeText(text: "Add Photos", fontColor:  MyColor.colorBlack, fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_2_0, fontWeight: FontWeight.w500, textAlign: TextAlign.start),
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
                                  _takePicture(setState);
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SvgPicture.asset(camera, height: SizeConfig.blockSizeVertical * SizeUtils.HEIGHT3,),
                                    SizedBox(width: SizeConfig.blockSizeHorizontal * SizeUtils.WIDTH2,),
                                    CustomeText(text: "Take Photo", fontColor: MyColor.primaryColorblue, fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5, fontWeight: FontWeight.w500, textAlign: TextAlign.start)
                                  ],),
                              ),
                            ),

                            Expanded(
                              flex: 1,
                              child: InkWell(
                                onTap: () {
                                  _attachPhotoFromGallery(setState);
                                },
                                child: Row(children: [
                                  SvgPicture.asset(link, height: SizeConfig.blockSizeVertical * SizeUtils.HEIGHT3,),
                                  SizedBox(width: SizeConfig.blockSizeHorizontal * SizeUtils.WIDTH2,),
                                  CustomeText(text: "Attach Photo", fontColor: MyColor.primaryColorblue, fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5, fontWeight: FontWeight.w500, textAlign: TextAlign.start)
                                ],),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: SizeConfig.blockSizeVertical),
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: CustomeText(text: "Damage Photos", fontColor:  MyColor.colorBlack, fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5, fontWeight: FontWeight.w500, textAlign: TextAlign.start),
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
                                text: "Cancel",
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
                                text: "Save",
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

  getDamageDetails(ConsignmentAcceptedList shipment)async {
    if (isLoading) return;

    setState(() {
      isLoading = true;
    });


    var queryParams = {
      "FlightSeqNo": "${shipment.flightSeqNo}",
      "AWBId": "${shipment.awbId}",
      "SHIPId": "${shipment.shipId}",
      "ProblemSeqId": "0",
      "AirportCode": "JFK",
      "CompanyCode": "3",
      "CultureCode": "en-US",
      "UserId": userId.toString(),
      "MenuId": "1"
    };
    await authService
        .postData(
      "AWBDamage/GetDamageDetails",
      queryParams,
    )
        .then((response) {
      print("data received ");
      Map<String, dynamic> jsonData = json.decode(response.body);
      List<dynamic> resp = jsonData['ReferenceData14BList'];
      print(jsonData);
      if (jsonData.isEmpty) {
        setState(() {
          hasNoRecord = true;
        });
      }
      else{
        hasNoRecord=false;
      }
      print("is empty record $hasNoRecord");
      setState(() {
        referenceData14BList =
            resp.map((json) => DamageData14BList.fromJson(json)).toList();
        // filteredList = listShipmentDetails;
        print("length--  = ${referenceData14BList.length}");
        if(jsonData['DamageDetail']['SeqNo']>0){
          dmgWTController.text=jsonData['DamageDetail']['TotWtActualCheck'].toStringAsFixed(2);
          dmgNOPController.text=jsonData['DamageDetail']['TotPcsActualCheck'].toString();
          diffWt=jsonData['DamageDetail']['TotWtDifference'];
          diffNop=jsonData['DamageDetail']['TotPcsDifference'];
          problemSeqId=jsonData['DamageDetail']['SeqNo'];
          remarksController.text=jsonData['DamageDetail']['Remark'];
          List<String> damageContainersList = jsonData['DamageDetail']["DamageContainers"].split(", ");
          print(damageContainersList.toList());
          setState(() {
            for (var item in referenceData14BList) {
              if (damageContainersList.contains(item.referenceDataIdentifier)) {
                item.isSelected = 'Y';
              }
            }
          });
        }
        else{
          dmgWTController.text=jsonData['DamageDetail']['TotWtShippedAwb'].toStringAsFixed(2);
          dmgNOPController.text=jsonData['DamageDetail']['TotPcsShippedAwb'].toString();
        }

        isLoading = false;

      });
    }).catchError((onError) {
      setState(() {
        isLoading = false;
      });
      print(onError);
    });
  }

  saveDamage(ConsignmentAcceptedList shipment) async {
    if (dmgNOPController.text.isEmpty) {
      showDataNotFoundDialog(context, "Damaged NOP is required.");
      return;
    }
    if (dmgWTController.text.isEmpty) {
      showDataNotFoundDialog(context, "Damaged Weight is required.");
      return;
    }
    if (remarksController.text.isEmpty) {
      showDataNotFoundDialog(context, "Remark is required.");
      return;
    }

    List<String> selectedIdentifiers = [];

    for (var item in referenceData14BList) {
      if (item.isSelected == "Y") {
        selectedIdentifiers.add(item.referenceDataIdentifier ?? '');
      }
    }
    print(selectedIdentifiers.join(', '));


    var queryParams = {

        "AwbPrefix": shipment.documentNo.substring(0,3),
        "AwbNumber": shipment.documentNo.substring(3),
        "AWBId": shipment.awbId,
        "SHIPId": shipment.shipId,
        "FlightSeqNo": shipment.flightSeqNo,
        "HouseSeqNo": 0,//shipment.houseRowId,
        "TypeOfDiscrepancy": "DMG",
        "ShipTotalPcs": shipment.totalNpo,
        "ShipTotalWt": "${shipment.totalWt}",
        "ShipDamagePcs": int.parse(dmgNOPController.text),
        "ShipDamageWt": dmgWTController.text,
        "ShipDifferencePcs": diffNop,
        "ShipDifferenceWt": "$diffWt",
        "IndividualWTPerDoc": "",
        "IndividualWTActChk": "",
        "IndividualWTDifference": "",
        "ContainerMaterial": "",
        "ContainerType": "",
        "MarksLabels": "",
        "OuterPacking": "",
        "InnerPacking": "",
        "IsSufficient": "Y",
        "DamageObserContent": "",
        "DamageObserContainers": selectedIdentifiers.join(', '),
        "DamageDiscovered": "",
        "SpaceForMissing": "",
        "VerifiedInvoice": "",
        "WeatherCondition": "",
        "AparentCause": "",
        "DamageRemarked": "",
        "EvidenceOfPilerage": "",
        "Remarks": remarksController.text,
        "SalvageAction": "",
        "Disposition": "",
        "GHARepresent": "",
        "AirlineRepresent": "",
        "SecurityRepresent": "",
        "ProblemSeqId": problemSeqId,
        "XmlBinaryImage": "${selectImageBase64List.join(',')}",
        "AirportCode": "JFK",
        "CompanyCode": 3,
        "CultureCode": "en-US",
        "UserId": userId.toString(),
        "MenuId": 1
        };
    // print(queryParams);
    // return;
    DialogUtils.showLoadingDialog(context);
    await authService
        .postData(
      "AWBDamage/DamageSave",
      queryParams,
    )
        .then((response) async {
      print("data received ");
      Map<String, dynamic> jsonData = json.decode(response.body);
      String status = jsonData['Status'];
      String? statusMessage = jsonData['StatusMessage'] ?? "";
      if (jsonData.isNotEmpty) {
        DialogUtils.hideLoadingDialog(context);
        if (status != "S") {
          showDataNotFoundDialog(context, statusMessage!);
        }
        if ((status == "S")) {
          //SnackbarUtil.showSnackbar(context,statusMessage!,              const Color(0xff43A047));
          bool isTrue=await showDialog(
            context: context,
            builder: (BuildContext context) => CustomAlertMessageDialogNew(
              description: "Damage saved successfully",
              buttonText: "Okay",
              imagepath:'assets/images/successchk.gif',
              isMobile: false,
            ),
          );
          if(isTrue){

          }
        }
      }
    }).catchError((onError) {
      print(onError);
    });
  }

  void showDataNotFoundDialog(BuildContext context, String message,{String status = "E"}) {
    showDialog(
      context: context,
      builder: (BuildContext context) => CustomAlertMessageDialogNew(
        description: message,
        buttonText: "Okay",
        imagepath:status=="E"?'assets/images/warn.gif': 'assets/images/successchk.gif',
        isMobile: false,
      ),
    );
  }


}
