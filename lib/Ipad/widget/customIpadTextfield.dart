import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:galaxy/module/onboarding/sizeconfig.dart';
import 'package:galaxy/utils/commonutils.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../core/images.dart';
import '../../core/mycolor.dart';
import '../../utils/flightnumbervalidationutils.dart';
import '../../utils/sizeutils.dart';

class CustomeEditTextWithBorderDatePicker extends StatefulWidget {
  final String lablekey;
  final String? labelText;
  final IconData? prefixicon;
  final String? hintText;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final bool readOnly;
  final bool isEnable;
  final TextInputAction inputAction;
  final double fontSize;
  final Color fillColor;
  final Color fontColor;
  final Color? prefixIconcolor;
  final double verticalPadding;
  final double circularCorner;
  final int? maxLength;


  const CustomeEditTextWithBorderDatePicker({
    Key? key,
    required this.lablekey,
    this.labelText,
    this.hintText,
    this.prefixicon,
    this.controller,
    this.focusNode,
    this.readOnly = true, // Make it read-only since it's for date input only
    this.isEnable = true,
    this.inputAction = TextInputAction.next,
    this.fontSize = 10,
    this.fillColor = Colors.transparent,
    this.fontColor = Colors.black,
    this.prefixIconcolor,
    this.verticalPadding = 0,
    this.circularCorner = 6,
    this.maxLength = 13,

  }) : super(key: key);

  @override
  State<CustomeEditTextWithBorderDatePicker> createState() => _CustomeEditTextWithBorderDatePickerState();
}

class _CustomeEditTextWithBorderDatePickerState extends State<CustomeEditTextWithBorderDatePicker> {
  final DateFormat dateFormat = DateFormat('yyyy-MM-dd');

  void _pickDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null && widget.controller != null) {
      widget.controller!.text = dateFormat.format(pickedDate);
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      readOnly: widget.readOnly,
      controller: widget.controller,
      style: GoogleFonts.roboto(
        textStyle: TextStyle(
          color: widget.fontColor,
          fontSize: widget.fontSize,
        ),
      ),
      cursorColor: MyColor.primaryColorblue,
      textInputAction: widget.inputAction,
      decoration: InputDecoration(
        prefixIcon: widget.prefixicon != null
            ? Icon(
          widget.prefixicon,
          color: widget.prefixIconcolor,
        )
            : null,
        contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
        labelText: widget.labelText ?? '',
        floatingLabelBehavior: FloatingLabelBehavior.always,
        labelStyle: GoogleFonts.roboto(
          textStyle: TextStyle(
            color: widget.fontColor,
            fontSize: widget.fontSize,
          ),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(widget.circularCorner),
          borderSide: const BorderSide(color:MyColor.borderColor, width: 0.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(widget.circularCorner),
          borderSide: const BorderSide(color:MyColor.borderColor, width: 0.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(widget.circularCorner),
          borderSide: const BorderSide(color:MyColor.borderColor, width: 0.5),
        ),

        suffixIcon: IconButton(
          onPressed: () {
            print("Date picker");
            _pickDate();
          } ,
          icon: const Icon(Icons.calendar_today, color: MyColor.primaryColorblue),
        ),
      ),
    );
  }
}
