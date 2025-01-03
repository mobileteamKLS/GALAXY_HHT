import 'package:flutter/material.dart';
import 'custometext.dart';


class ULDNumberWidget extends StatelessWidget {
  final String uldNo;
  final double smallFontSize;
  final double bigFontSize;
  final Color fontColor;
  final String uldType;

  const ULDNumberWidget({
    Key? key,
    required this.uldNo,
    required this.smallFontSize,
    required this.bigFontSize,
    required this.fontColor,
    required this.uldType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Split the ULD number into parts

    if(uldNo.isNotEmpty){
      if(uldType == "U" || uldType == "P" || uldType == "C"){
        final parts = uldNo.split(' ');
        return Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomeText(text: parts[0], fontColor: fontColor, fontSize: smallFontSize, fontWeight: FontWeight.w400, textAlign: TextAlign.center),
            SizedBox(width: 3,),
            CustomeText(text: parts[1], fontColor: fontColor, fontSize: bigFontSize, fontWeight: FontWeight.w700, textAlign: TextAlign.center),
            SizedBox(width: 3,),
            CustomeText(text: parts[2], fontColor: fontColor, fontSize: smallFontSize, fontWeight: FontWeight.w400, textAlign: TextAlign.center),

          ],
        );
      }else{
        return CustomeText(text: uldNo, fontColor: fontColor, fontSize: bigFontSize, fontWeight: FontWeight.w700, textAlign: TextAlign.start);
      }

    }else{

      return CustomeText(text: "-", fontColor: fontColor, fontSize: bigFontSize, fontWeight: FontWeight.w700, textAlign: TextAlign.start);
    }


  }
}
