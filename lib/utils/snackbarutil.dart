import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:galaxy/widget/custometext.dart';
import 'package:google_fonts/google_fonts.dart';

import '../core/mycolor.dart';

class SnackbarUtil {

  static void showSnackbar(BuildContext context, String message, Color backgroundColor, {IconData? icon}) {
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          content: Container(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 8),
              decoration: BoxDecoration(
                color: backgroundColor,
                border: Border.all(color: backgroundColor, width: 3),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x19000000),
                    spreadRadius: 2.0,
                    blurRadius: 8.0,
                    offset: Offset(2, 4),
                  )
                ],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                      radius: 10,
                      backgroundColor: MyColor.colorWhite,
                      child: Icon(icon, color: backgroundColor, size: 17, )),
                   Flexible(
                     child: Padding(
                      padding: EdgeInsets.only(left: 8.0),
                      child: CustomeText(text: message, fontColor: MyColor.colorWhite, fontSize: 14, fontWeight: FontWeight.w500, textAlign: TextAlign.start),
                                       ),
                   ),
                ],
              )
          ),
        )
    );
  }
}