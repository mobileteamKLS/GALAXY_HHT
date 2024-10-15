import 'package:flutter/material.dart';
import '../../core/mycolor.dart';

class CustomDivider extends StatelessWidget {
  final double space;
  final Color color;
  final bool hascolor;
  double? height;
  double? thickness;

  CustomDivider(
      {Key? key,
      this.height = 0.5,
      this.thickness = 0.5,
      this.space = 20,
      this.color = MyColor.colorBlack, this.hascolor =false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Divider(color:
        hascolor ==true?
         color.withOpacity(0.2):color.withOpacity(0), height: height, thickness: thickness),
      ],
    );
  }
}
