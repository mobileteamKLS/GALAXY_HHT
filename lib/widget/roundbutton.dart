import 'package:flutter/material.dart';
import 'package:galaxy/widget/custometext.dart';

import '../core/mycolor.dart';
import '../module/onboarding/sizeconfig.dart';
import '../utils/sizeutils.dart';



class RoundedButton extends StatefulWidget {
  final bool isColorChange;
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

  const RoundedButton({
    super.key,
    this.isColorChange = false,
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
    this.focusNode
  });

  @override
  State<RoundedButton> createState() => _RoundedButtonState();
}

class _RoundedButtonState extends State<RoundedButton> {
  @override
  Widget build(BuildContext context) {
    
    return InkWell(
      focusNode: widget.focusNode,
      onTap: widget.press,
      splashColor: MyColor.screenBgColor,
      child: Container(
          padding: EdgeInsets.symmetric(vertical: widget.verticalPadding, horizontal: widget.horizontalPadding),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(SizeUtils.BORDERRADIOUS), color: widget.color),
          child: Center(child: CustomeText(text:  widget.text, fontColor: widget.textColor!, fontSize: widget.textSize, fontWeight: FontWeight.w500, textAlign: TextAlign.center, textDirection: widget.textDirection,))
      ),
    );
  }
}
