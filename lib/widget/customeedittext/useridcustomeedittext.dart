import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:galaxy/core/images.dart';
import 'package:galaxy/module/onboarding/sizeconfig.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/mycolor.dart';
import '../../utils/sizeutils.dart';

class UserIdCustomeEditText extends StatefulWidget {

  final String? labelText;
  final String? prefixicon;
  final String? hintText;
  final Function? onChanged;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final FocusNode? nextFocus;
  final FormFieldValidator? validator;
  final TextInputType? textInputType;
  final bool isEnable;
  final bool isPassword;
  final bool isShowSuffixIcon;
  final bool isIcon;
  final VoidCallback? onSuffixTap;
  final bool isSearch;
  final bool isCountryPicker;
  final TextInputAction inputAction;
  final bool needOutlineBorder;
  final bool readOnly;
  final bool needRequiredSign;
  final int maxLines;
  final bool animatedLabel;
  final Color fillColor;
  final Color fontColor;
  final bool isRequired;
  final bool hasIcon;
  final bool hastextcolor;
  final double fontSize;
  final double iconSize;
  final bool showErrorText;
  final VoidCallback? onPress;
  final double circularCorner;
  final double verticalPadding;
  final Color? prefixIconcolor;
  final Color? hintTextcolor;
  final Color? cursorColor;
  final int? maxLength;
  final String? errorText;
  final bool? digitsOnly;
  final TextDirection textDirection;

  const UserIdCustomeEditText({super.key,
    this.labelText,
    this.readOnly = false,
    this.fillColor = MyColor.transparentColor,
    this.fontColor = MyColor.colorWhite,
    required this.onChanged,
    this.hintText,
    this.prefixicon,
    this.controller,
    this.focusNode,
    this.nextFocus,
    this.validator,
    this.textInputType,
    this.isEnable = true,
    this.isPassword = false,
    this.isShowSuffixIcon = false,
    this.isIcon = false,
    this.onSuffixTap,
    this.fontSize = 10,
    this.iconSize = 30,
    this.isSearch = false,
    this.isCountryPicker = false,
    this.inputAction = TextInputAction.next,
    this.needOutlineBorder = false,
    this.needRequiredSign = false,
    this.maxLines = 1,
    this.animatedLabel = false,
    this.isRequired = false,
    this.hasIcon = false,
    this.hastextcolor = false,
    this.showErrorText = true,
    this.onPress,
    this.circularCorner = 30,
    this.verticalPadding = 20,
    this.prefixIconcolor,
    this.cursorColor = Colors.white,
    this.maxLength = 24,
    this.errorText,
    this.digitsOnly = false,
    this.textDirection = TextDirection.ltr,
  this.hintTextcolor});

  @override
  State<UserIdCustomeEditText> createState() => _UserIdCustomeEditTextState();
}

class _UserIdCustomeEditTextState extends State<UserIdCustomeEditText> {
  bool obscureText = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      textDirection: widget.textDirection,
     onTap: () {
      // widget.onPress!();
     },

      focusNode: widget.focusNode,
      readOnly: widget.readOnly,
      cursorColor: widget.cursorColor,
      controller: widget.controller,
      keyboardType: widget.textInputType,
      obscureText: widget.isPassword ? obscureText : false,
      // validator: widget.validator,
    /*  inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.allow(RegExp("[0-9a-zA-Z]")),
      ],*/
      maxLines: widget.maxLines,
      maxLength: widget.maxLength,
      style: GoogleFonts.roboto(textStyle: TextStyle(color: MyColor.colorBlack, fontSize: widget.fontSize, fontWeight: FontWeight.w500)),
      decoration: InputDecoration(
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: MyColor.textColorGrey2), // default border color
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: MyColor.textColorGrey2), // color when field is focused
        ),
        errorBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: MyColor.colorRed), // color for error state
        ),
        focusedErrorBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: MyColor.textColorGrey2), // focused error state color
        ),
        border: const UnderlineInputBorder(),
        errorText: widget.errorText,
        errorStyle: GoogleFonts.roboto(textStyle: TextStyle(fontWeight: FontWeight.w400, color: MyColor.colorRed)),
        counterText: "",
        /*contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 0),*/
        hintText: widget.hintText,
        hintStyle: GoogleFonts.roboto(textStyle: TextStyle(color: MyColor.textColorGrey2, fontWeight: FontWeight.w500, fontSize: widget.fontSize)),

        suffixIcon: widget.isShowSuffixIcon
            ? widget.isPassword
            ? IconButton(
            icon: SvgPicture.asset(obscureText ? eyeslash : eye, height: SizeConfig.blockSizeVertical * SizeUtils.HEIGHT3), onPressed: _toggle)
            : widget.isIcon
            ? Padding(
              padding: EdgeInsets.all(SizeConfig.blockSizeVertical * SizeUtils.HEIGHT_1_5),
              child: SvgPicture.asset(widget.prefixicon!, height: SizeConfig.blockSizeVertical * SizeUtils.ICONSIZE_2_5),
            )
            : null
            : null,
      ),
      onFieldSubmitted: (text) => widget.nextFocus != null
          ? FocusScope.of(context).requestFocus(widget.nextFocus)
          : null,
      onChanged: (text) => widget.onChanged!(text),
      textInputAction: widget.inputAction,
    );
  }

  void _toggle() {
    setState(() {
      obscureText = !obscureText;
    });
  }
}
