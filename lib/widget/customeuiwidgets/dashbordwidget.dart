import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:galaxy/core/images.dart';
import 'package:galaxy/widget/custometext.dart';
import '../../core/mycolor.dart';
import '../../module/onboarding/sizeconfig.dart';
import '../../utils/sizeutils.dart';

class DashboardCustomeWidget extends StatefulWidget {
  String title;
  String imageUrl;
  VoidCallback onClick;
  Color bgColor;

  DashboardCustomeWidget({
    super.key,
    required this.title,
    required this.imageUrl,
    required this.onClick,
    required this.bgColor
  });

  @override
  State<DashboardCustomeWidget> createState() => _DashboardCustomeWidgetState();
}

class _DashboardCustomeWidgetState extends State<DashboardCustomeWidget> {

  double screenWidth = 0;
  double screenHeight = 0;

  @override
  Widget build(BuildContext context) {

    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;

    return InkWell(
      onTap: () {
        widget.onClick();
      },
      child: Card(

        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(SizeConfig.blockSizeHorizontal * SizeUtils.CIRCULARCORNER),
        ),

        color: widget.bgColor,
        elevation: 5,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(SizeConfig.blockSizeHorizontal * SizeUtils.CIRCULARCORNER),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              widget.imageUrl.isNotEmpty
                  ? SvgPicture.asset(widget.imageUrl, height: screenHeight * 0.06, width: screenWidth * 0.06, fit: BoxFit.cover)
                  : Image.asset(
                height: SizeConfig.blockSizeHorizontal * 10,
                width: SizeConfig.blockSizeHorizontal * 10,
                galaxylogo,
              ),
              CustomeText(
                  text: widget.title,
                  fontColor: MyColor.textColorGrey3,
                  fontSize: screenHeight * 0.018,
                  fontWeight: FontWeight.w500,
                  textAlign: TextAlign.start)
            ],
          ),
        ),
      ),
    );

    /*return InkWell(
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
              height: double.infinity,
              decoration: BoxDecoration(
                  color: MyColor.colorBlueWhite,
                  borderRadius: BorderRadius.circular(SizeConfig.blockSizeHorizontal * SizeUtils.CIRCULARCORNER),
              ),

             child: Column(
               mainAxisAlignment: MainAxisAlignment.center,
               children: [
                 SvgPicture.asset(widget.imageUrl, height: 50, width: 50, fit: BoxFit.cover,),
                 SizedBox(height: SizeConfig.blockSizeVertical * SizeUtils.HEIGHT2,),
                 CustomeText(
                     text: widget.title,
                     fontWeight: FontWeight.w600,
                     fontColor: MyColor.textColorGrey3,
                     fontSize: SizeConfig.textMultiplier * SizeUtils.TEXTSIZE_1_8,
                     textAlign: TextAlign.center)
               ],
             ),
             
             *//* child: widget.imageUrl.isNotEmpty
                   ? Image.asset(widget.imageUrl,
                     errorBuilder: (context, error, stackTrace) {
                     return Image.asset(galaxylogo);
                    },
                  )
                  : Image.asset(galaxylogo),*//*

            ),

            *//*Positioned(
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
                        textAlign: TextAlign.center)))*//*
          ],
        ),
      ),
    );*/
  }
}
