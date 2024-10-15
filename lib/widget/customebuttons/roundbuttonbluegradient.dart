import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:galaxy/widget/custometext.dart';

import '../../core/mycolor.dart';
import '../../module/onboarding/sizeconfig.dart';
import '../../utils/sizeutils.dart';



class RoundedButtonBlueGradient extends StatefulWidget {
  final bool isborderButton;
  final String text;
  final VoidCallback press;
  final Color color;
  final Color? textColor;
  final double? width;
  final double horizontalPadding;
  final double verticalPadding;
  final double cornerRadius;
  final double textSize;
  final bool isOutlined;
  final Widget? child;
  final TextDirection? textDirection;
  final FocusNode? focusNode;
  final String? icon;

  const RoundedButtonBlueGradient({
    super.key,
    this.isborderButton = false,
    this.width = 1,
    this.child,
    this.cornerRadius = 10,
    this.textSize = 14,
    required this.text,
    required this.press,
    this.isOutlined = false,
    this.horizontalPadding = 20,
    this.verticalPadding = 12,
    this.color = MyColor.primaryColor,
    this.textColor = MyColor.colorWhite,
    this.textDirection = TextDirection.ltr,
    this.focusNode,
    this.icon
  });

  @override
  State<RoundedButtonBlueGradient> createState() => _RoundedButtonBlueGradientState();
}

class _RoundedButtonBlueGradientState extends State<RoundedButtonBlueGradient> {
  @override
  Widget build(BuildContext context) {
    
    return (widget.isborderButton == true) ? InkWell(
      focusNode: widget.focusNode,
      onTap: widget.press,
      child: Container(
          decoration: BoxDecoration(
              border: Border.all(color: MyColor.bggradientfirst, width: 1.5),
              borderRadius: BorderRadius.circular(SizeUtils.BORDERRADIOUS)
          ),
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Directionality(
            textDirection: widget.textDirection!,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                (widget.icon != null) ? SvgPicture.asset(widget.icon!, height: SizeConfig.blockSizeVertical * SizeUtils.ICONSIZE_2_5,) : SizedBox(),
                (widget.icon != null) ? const SizedBox(width: 10,) : SizedBox(),
                CustomeText(text:  widget.text, fontColor: MyColor.bggradientfirst, fontSize: widget.textSize, fontWeight: FontWeight.w500, textAlign: TextAlign.center, textDirection: widget.textDirection,),
              ],
            ),
          )
      ),
    ) : InkWell(
      focusNode: widget.focusNode,
      onTap: widget.press,
      splashColor: MyColor.screenBgColor,
      child: Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                MyColor.bggradientfirst, // #0060E5 color
                MyColor.bggradientsecond, // #1D86FF color
              ],
              stops: [0.0, 1.0], // Specifies the start and end of the gradient
            ),
            borderRadius: BorderRadius.circular(SizeUtils.BORDERRADIOUS)
          ),
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: widget.verticalPadding),
          child: Directionality(
            textDirection: widget.textDirection!,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                (widget.icon != null) ? SvgPicture.asset(widget.icon!, height: SizeConfig.blockSizeVertical * SizeUtils.ICONSIZE_2_5) : SizedBox(),
                (widget.icon != null) ? SizedBox(width: 10,) : SizedBox(),
                CustomeText(text: widget.text, fontColor: widget.textColor!, fontSize: widget.textSize, fontWeight: FontWeight.w500, textAlign: TextAlign.center, textDirection: widget.textDirection,),
              ],
            ),
          )
      ),
    );
  }
}
