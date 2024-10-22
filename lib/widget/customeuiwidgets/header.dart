import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:galaxy/module/onboarding/sizeconfig.dart';
import 'package:galaxy/utils/sizeutils.dart';
import 'package:galaxy/widget/custometext.dart';
import '../../core/images.dart';
import '../../core/mycolor.dart';

class HeaderWidget extends StatefulWidget {

  String title;
  VoidCallback onBack;
  String? clearText;
  VoidCallback? onClear;
  Color? titleTextColor;

  HeaderWidget({super.key, required this.title, this.titleTextColor, required this.onBack, this.clearText = "", this.onClear});

  @override
  State<HeaderWidget> createState() => _HeaderWidgetState();
}

class _HeaderWidgetState extends State<HeaderWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              InkWell(
                onTap : () {
                  widget.onBack();
                },
                child: Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: MyColor.colorBlack,
                  size: SizeConfig.blockSizeVertical * 3,
                ),
              ),
              SizedBox(
                width: SizeConfig.blockSizeHorizontal * 2,
              ),
              CustomeText(text: widget.title, fontColor: (widget.titleTextColor == null) ? MyColor.primaryColorblue : widget.titleTextColor!, fontSize: SizeConfig.textMultiplier * SizeUtils.HEADINGTEXTSIZE, fontWeight: FontWeight.w500, textAlign: TextAlign.start)
            ],
          ),
          InkWell(
              onTap: () {
                widget.onClear!();
              },
              child: Row(
                children: [
                  (widget.clearText! != "") ? Padding(
                    padding: const EdgeInsets.only(right: 5),
                    child: SvgPicture.asset(redo, height: SizeConfig.blockSizeVertical * SizeUtils.ICONSIZE2,),
                  ) : SizedBox(),
                  CustomeText(text: widget.clearText!, fontColor: MyColor.primaryColorblue, fontSize: SizeConfig.textMultiplier * SizeUtils.MEDIUMTEXTSIZE, fontWeight: FontWeight.w500, textAlign: TextAlign.center),
                ],
              ))
        ],
      ),
    );
  }
}
