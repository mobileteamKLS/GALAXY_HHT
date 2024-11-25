import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomeText extends StatefulWidget {

  String text;
  Color fontColor;
  double fontSize;
  FontWeight fontWeight;
  TextAlign textAlign;
  TextDirection? textDirection;
  final TextDecoration textDecoration;
  int? maxLine;

  CustomeText({super.key, required this.text, required this.fontColor, required this.fontSize, required this.fontWeight, required this.textAlign, this.textDirection, this.textDecoration = TextDecoration.none, this.maxLine = 3});

  @override
  State<CustomeText> createState() => _CustomeTextState();
}

class _CustomeTextState extends State<CustomeText> {
  @override
  Widget build(BuildContext context) {
    return Text(
      maxLines: widget.maxLine,
      widget.text,
      textAlign : widget.textAlign,
      textDirection: widget.textDirection,
      style: GoogleFonts.roboto(
          textStyle: TextStyle(
              fontSize: widget.fontSize,
              color: widget.fontColor,
              fontWeight: widget.fontWeight,
              decoration: widget.textDecoration,
              decorationColor: widget.fontColor
          )
      ), // Allow text to wrap into multiple lines if needed
    );
  }
}
