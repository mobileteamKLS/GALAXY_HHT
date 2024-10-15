import 'package:flutter/material.dart';
import 'package:galaxy/widget/custometext.dart';
import '../../core/mycolor.dart';

class CustomUndelineText extends StatelessWidget {
  final String text;
  double fontSize;
  TextDirection? textDirection;
  CustomUndelineText({super.key, required this.text, required this.fontSize, this.textDirection});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          border: Border(
              bottom: BorderSide(
        color: MyColor.colorWhite,
      ))),
      child: CustomeText(text: text, fontColor: MyColor.colorWhite, fontSize: fontSize, fontWeight: FontWeight.w500, textAlign: TextAlign.start)
    );
  }
}
