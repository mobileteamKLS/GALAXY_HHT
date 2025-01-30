import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:galaxy/core/images.dart';
import 'package:galaxy/widget/custometext.dart';
import '../../core/mycolor.dart';
import '../../module/onboarding/sizeconfig.dart';
import '../../utils/sizeutils.dart';

class SubMenuWidget extends StatefulWidget {
  String title;
  String imageUrl;
  VoidCallback onClick;
  Color bgColor;

  SubMenuWidget(
      {super.key,
      required this.title,
      required this.imageUrl,
      required this.onClick,
      required this.bgColor});

  @override
  State<SubMenuWidget> createState() => _SubMenuWidgetState();
}

class _SubMenuWidgetState extends State<SubMenuWidget> {

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
                  ? SvgPicture.asset(
                  widget.imageUrl,
                  height: screenHeight * 0.045,
                  width: screenWidth * 0.045,
                fit: BoxFit.cover,)
                  : Image.asset(
                height: SizeConfig.blockSizeHorizontal * 10,
                width: SizeConfig.blockSizeHorizontal * 10,
                galaxylogo,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: CustomeText(
                  maxLine: 2,
                    text: widget.title,
                    fontColor: MyColor.textColorGrey3,
                    fontSize: screenHeight * 0.016,
                    fontWeight: FontWeight.w500,
                    textAlign: TextAlign.center),
              )
            ],
          ),
        ),
      ),
    );
  }
}
