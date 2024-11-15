import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:galaxy/utils/awbformatenumberutils.dart';
import 'package:galaxy/widget/customedrawer/customedrawer.dart';
import 'package:galaxy/widget/custometext.dart';

import '../../../../core/mycolor.dart';
import '../../../../language/appLocalizations.dart';
import '../../../../language/model/lableModel.dart';
import '../../../../utils/commonutils.dart';
import '../../../../utils/sizeutils.dart';
import '../../../../widget/customdivider.dart';
import '../../../../widget/customeuiwidgets/footer.dart';
import '../../../../widget/customeuiwidgets/header.dart';
import '../../../../widget/header/mainheadingwidget.dart';
import '../../../login/model/userlogindatamodel.dart';
import '../../../onboarding/sizeconfig.dart';
import '../../../splash/model/splashdefaultmodel.dart';
import '../../../submenu/model/submenumodel.dart';
import '../../model/flightcheck/flightcheckuldlistmodel.dart';
import 'dart:ui' as ui;

class AwbRemarkListpage extends StatefulWidget {
  String mainMenuName;
  List<AWBRemarkList>? aWBRemarkList;
  UserDataModel user;
  SplashDefaultModel splashDefaultData;
  List<SubMenuName> importSubMenuList = [];
  List<SubMenuName> exportSubMenuList = [];

  AwbRemarkListpage({super.key,
    required this.importSubMenuList,
    required this.exportSubMenuList,
    required this.user, required this.splashDefaultData, required this.aWBRemarkList, required this.mainMenuName});

  @override
  State<AwbRemarkListpage> createState() => _AwbRemarkListpageState();
}

class _AwbRemarkListpageState extends State<AwbRemarkListpage> {

  List<bool> isExpandedList = [];

  @override
  void initState() {
    super.initState();
    // Sort the list so that high priority items are at the top
    widget.aWBRemarkList?.sort((a, b) {
      if (b.isHighPriority == true && a.isHighPriority != true) {
        return 1;
      } else if (b.isHighPriority != true && a.isHighPriority == true) {
        return -1;
      } else {
        return 0;
      }
    });

    isExpandedList = List.filled(widget.aWBRemarkList!.length, false);

  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

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

    return Directionality(
      textDirection: uiDirection,
      child: SafeArea(
        child: Scaffold(
          key: _scaffoldKey,
          drawer: BuildCustomeDrawer(
            importSubMenuList: widget.importSubMenuList,
            exportSubMenuList: widget.exportSubMenuList,
            user: widget.user,
            splashDefaultData: widget.splashDefaultData,
            onDrawerCloseIcon: () {
              _scaffoldKey.currentState?.closeDrawer();
            },
          ) ,
          body: Stack(

            children: [
              MainHeadingWidget(mainMenuName: widget.mainMenuName,
                onDrawerIconTap: () => _scaffoldKey.currentState?.openDrawer(),
              ),
              Positioned(
                top: SizeConfig.blockSizeVertical * SizeUtils.HEIGHT8,
                bottom: 0,
                right: 0,
                left: 0,
                child: Container(
                  decoration: BoxDecoration(
                      color: MyColor.bgColorGrey,
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(
                              SizeConfig.blockSizeVertical * SizeUtils.WIDTH2),
                          topLeft: Radius.circular(
                              SizeConfig.blockSizeVertical *
                                  SizeUtils.WIDTH2))),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 10, right: 15, top: 12, bottom: 12),
                        child: HeaderWidget(
                          title: "${lableModel!.information}",
                          titleTextColor: MyColor.colorBlack,
                          onBack: () {
                            Navigator.pop(context);
                          },
                          clearText: "",
                        ),
                      ),


                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 10,
                              right: 10,
                              top: 0,
                              bottom: 0),
                          child: Directionality(
                            textDirection: textDirection,
                            child: Container(
                              decoration: BoxDecoration(
                                color: MyColor.colorWhite,
                                borderRadius:
                                BorderRadius.circular(8),
                                boxShadow: [
                                  BoxShadow(
                                    color: MyColor.colorBlack.withOpacity(0.09),
                                    spreadRadius: 2,
                                    blurRadius: 15,
                                    offset: Offset(0, 3), // changes position of shadow
                                  ),
                                ],
                              ),
                              child: (widget.aWBRemarkList!.isNotEmpty)
                                  ? ListView.builder(
                                itemCount: widget.aWBRemarkList!.length,
                                itemBuilder: (context, index) {

                                  bool isTextMoreThanTwoLines = _isTextMoreThanTwoLines(
                                    widget.aWBRemarkList![index].remark!,
                                    SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                  );

                                  return Column(
                                    children: [

                                      Padding(
                                        padding: const EdgeInsets.only(left: 8, right: 8, top: 12, bottom: 4),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    children: [
                                                      CustomeText(
                                                          text: AwbFormateNumberUtils.formatAWBNumber(widget.aWBRemarkList![index].AWBNo!),
                                                          fontColor: MyColor.textColorGrey3,
                                                          fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_7,
                                                          fontWeight: FontWeight.w700,
                                                          textAlign: TextAlign.start
                                                      ),
                                                      SizedBox(width: SizeConfig.blockSizeHorizontal * SizeUtils.WIDTH2,),
                                                      CircleAvatar(
                                                        radius: 10,
                                                        backgroundColor: (widget.aWBRemarkList![index].isHighPriority == true)
                                                            ? MyColor.colorRed
                                                            : Colors.transparent,
                                                        child: CustomeText(
                                                          text: (widget.aWBRemarkList![index].isHighPriority == true) ? "P" : "",
                                                          fontColor: MyColor.colorWhite,
                                                          fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                                          fontWeight: FontWeight.w500,
                                                          textAlign: TextAlign.center,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(height: SizeConfig.blockSizeVertical,),

                                                  Text(widget.aWBRemarkList![index].remark!,
                                                  style: TextStyle(
                                                      fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_5,
                                                      color: MyColor.textColorGrey2,
                                                      fontWeight: FontWeight.w400),
                                                  textAlign: TextAlign.start,
                                                  maxLines: isExpandedList[index] ? null : 2,
                                                  overflow: isExpandedList[index] ? TextOverflow.visible : TextOverflow.ellipsis,
                                                  ),
                                                ],
                                              ),
                                            ),
                                            isTextMoreThanTwoLines ? InkWell(
                                              onTap: () {
                                                setState(() {
                                                  isExpandedList[index] = !isExpandedList[index];
                                                });

                                              },
                                              child: Container(
                                                padding: EdgeInsets.symmetric(vertical: 5, horizontal: 8),
                                                decoration: BoxDecoration(
                                                    color: MyColor.dropdownColor,
                                                    borderRadius: BorderRadius.circular(SizeConfig.blockSizeHorizontal * SizeUtils.WIDTH3)
                                                ),
                                                child: Icon( isExpandedList[index] ? Icons.keyboard_arrow_up_rounded : Icons.navigate_next_rounded, color: MyColor.primaryColorblue, size: SizeConfig.blockSizeVertical * SizeUtils.ICONSIZE_2_6,),
                                              ),
                                            ) : SizedBox()
                                          ],
                                        ),
                                      ),

                                      const Divider(color: MyColor.textColorGrey, thickness: 0.3,)
                                    ],
                                  );


                                },)
                                  : Center(child: CustomeText(text: "${lableModel.infonotfound}", fontColor: MyColor.textColor,
                                  fontSize: SizeConfig.textMultiplier * 2.1,
                                  fontWeight: FontWeight.w500,
                                  textAlign: TextAlign.center),)
                            ),
                          ),
                        ),
                      ),





                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool _isTextMoreThanTwoLines(String text, double fontSize) {
    final TextPainter textPainter = TextPainter(
      text: TextSpan(text: text, style: TextStyle(fontSize: fontSize)),
      maxLines: 2,
      textDirection: TextDirection.ltr,
    )..layout(maxWidth: MediaQuery.of(context).size.width * 0.7); // Adjust maxWidth as needed

    return textPainter.didExceedMaxLines;
  }
}
