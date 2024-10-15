import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:galaxy/core/images.dart';
import 'package:galaxy/widget/custometext.dart';
import '../../core/mycolor.dart';
import '../../module/onboarding/sizeconfig.dart';
import '../../utils/sizeutils.dart';

class SubMenuWidget extends StatefulWidget {
  String title;
  String imageUrl;
  VoidCallback onClick;

  SubMenuWidget(
      {super.key,
      required this.title,
      required this.imageUrl,
      required this.onClick});

  @override
  State<SubMenuWidget> createState() => _SubMenuWidgetState();
}

class _SubMenuWidgetState extends State<SubMenuWidget> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        widget.onClick();
      },
      child: Card(

        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(SizeConfig.blockSizeHorizontal * SizeUtils.CIRCULARCORNER),
        ),

        color: MyColor.colorWhite,
        elevation: 5,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(SizeConfig.blockSizeHorizontal * SizeUtils.CIRCULARCORNER),
            border: Border.all(color: MyColor.primaryColorblue, width: 0.5),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              widget.imageUrl.isNotEmpty
                  ? Image.asset(
                height: SizeConfig.blockSizeHorizontal * 10,
                width: SizeConfig.blockSizeHorizontal * 10,
                widget.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Image.asset(
                    height: SizeConfig.blockSizeHorizontal * 10,
                    width: SizeConfig.blockSizeHorizontal * 10,
                    galaxylogo,
                  );
                },
              )
                  : Image.asset(
                height: SizeConfig.blockSizeHorizontal * 10,
                width: SizeConfig.blockSizeHorizontal * 10,
                galaxylogo,
              ),
              CustomeText(
                  text: widget.title,
                  fontColor: MyColor.colorBlack,
                  fontSize: SizeConfig.textMultiplier * SizeUtils.MEDIUMTEXTSIZE,
                  fontWeight: FontWeight.w500,
                  textAlign: TextAlign.start)
            ],
          ),
        ),
      ),
    );
  }
}
