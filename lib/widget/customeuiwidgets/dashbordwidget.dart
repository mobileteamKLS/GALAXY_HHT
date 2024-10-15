import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:galaxy/core/images.dart';
import 'package:galaxy/widget/custometext.dart';
import '../../core/mycolor.dart';
import '../../module/onboarding/sizeconfig.dart';
import '../../utils/sizeutils.dart';

class DashboardCustomeWidget extends StatefulWidget {
  String title;
  String imageUrl;
  VoidCallback onClick;
  DashboardCustomeWidget({super.key, required this.title, required this.imageUrl, required this.onClick});

  @override
  State<DashboardCustomeWidget> createState() => _DashboardCustomeWidgetState();
}

class _DashboardCustomeWidgetState extends State<DashboardCustomeWidget> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        widget.onClick();
      },
      child: Container(
        margin: EdgeInsets.only(bottom: SizeConfig.blockSizeVertical * 1, left: SizeConfig.blockSizeHorizontal * 1, right: SizeConfig.blockSizeHorizontal * 1, top: SizeConfig.blockSizeVertical * 1),
        child: Stack(
          children: [

            Container(
              margin: EdgeInsets.only(bottom: SizeConfig.blockSizeVertical * 1.5 ),
              width: double.infinity,

              decoration: BoxDecoration(
                  color: MyColor.colorWhite,
                  borderRadius: BorderRadius.circular(SizeConfig.blockSizeHorizontal * SizeUtils.CIRCULARCORNER),
                  border: Border.all(color: MyColor.primaryColorblue, width: 0.5)
              ),

              child: widget.imageUrl.isNotEmpty
                   ? Image.asset(widget.imageUrl,
                     errorBuilder: (context, error, stackTrace) {
                     return Image.asset(galaxylogo);
                    },
                  )
                  : Image.asset(galaxylogo),

            ),

            Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                    decoration: BoxDecoration(color: MyColor.primaryColorblue, borderRadius: BorderRadius.circular(SizeConfig.blockSizeHorizontal * SizeUtils.CIRCULARCORNER)),
                    margin: EdgeInsets.symmetric(horizontal:SizeConfig.blockSizeHorizontal * 2,),
                    padding: EdgeInsets.symmetric(horizontal: SizeConfig.blockSizeHorizontal * SizeUtils.BUTTONHORIZONTALSIZE, vertical: SizeConfig.blockSizeVertical * SizeUtils.BUTTONVERTICALSIZE),

                    child: CustomeText(
                        text: widget.title,
                        fontWeight: FontWeight.w600,
                        fontColor: MyColor.colorWhite,
                        fontSize: SizeConfig.textMultiplier * SizeUtils.MEDIUMTEXTSIZE,
                        textAlign: TextAlign.center)))
          ],
        ),
      ),
    );
  }
}
