import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:galaxy/module/onboarding/sizeconfig.dart';
import 'package:galaxy/utils/sizeutils.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/mycolor.dart';


class GroupIdCustomTextField extends StatefulWidget {
  final String? labelText;
  final String? prefixicon;
  final String? hintText;
  final Function(String)? onChanged;
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
  final bool showErrorText;
  final VoidCallback? onPress;
  final Color? prefixIconcolor;
  final Color? hintTextcolor;
  final double verticalPadding;
  final double circularCorner;
  final double boxHeight;
  final int? maxLength;
  final double iconSize;
  final TextDirection textDirection;

  const GroupIdCustomTextField(
      {Key? key,
        this.labelText,
        this.readOnly = false,
        this.fillColor = MyColor.transparentColor,
        this.fontColor = MyColor.colorBlack,
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
        this.prefixIconcolor,
        this.hintTextcolor,
        this.verticalPadding = 0,
        this.circularCorner = 30,
        this.onPress,
        this.iconSize = 30,
        this.maxLength = 13,
        this.textDirection = TextDirection.ltr,
        this.boxHeight = 30})
      : super(key: key);

  @override
  State<GroupIdCustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<GroupIdCustomTextField> {
  bool obscureText = true;

  @override
  void initState() {
    super.initState();
    widget.controller?.addListener(_updateTextToUppercase);
  }

  @override
  void dispose() {
    widget.controller?.removeListener(_updateTextToUppercase);
    super.dispose();
  }

  void _updateTextToUppercase() {
    if (widget.controller != null && widget.controller!.text != widget.controller!.text.toUpperCase()) {
      widget.controller!.value = widget.controller!.value.copyWith(
        text: widget.controller!.text.toUpperCase(),
        selection: TextSelection.collapsed(offset: widget.controller!.text.length),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.needOutlineBorder
        ? widget.animatedLabel
            ? TextFormField(
                 textDirection: widget.textDirection,
                onTap: () {
                  if (widget.onPress != null) {
                    widget.onPress!();
                  }
                },
                maxLength: widget.maxLength,
                maxLines: widget.maxLines,
                readOnly: widget.readOnly,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.allow(RegExp("[0-9a-zA-Z]")),
                ],
                style: GoogleFonts.roboto(textStyle: TextStyle(
                    color: widget.hastextcolor == true
                        ? MyColor.colorBlack
                        : MyColor.colorBlack, fontSize: widget.fontSize)),
                //textAlign: TextAlign.left,
                cursorColor: MyColor.primaryColorblue,
                controller: widget.controller,
                autofocus: false,
                textInputAction: widget.inputAction,
                enabled: widget.isEnable,
                focusNode: widget.focusNode,
                validator: widget.validator,
                keyboardType: widget.textInputType,
                obscureText: widget.isPassword ? obscureText : false,
      decoration: InputDecoration(
        counterText: "",
        contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
        labelText: widget.labelText ?? '',
        floatingLabelBehavior: FloatingLabelBehavior.always, // Keeps the label always floating above the field
        labelStyle: GoogleFonts.roboto(textStyle: TextStyle(
            color: widget.hastextcolor
                ? MyColor.colorBlack
                : MyColor.colorBlack, fontSize: widget.fontSize)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6.0),
          borderSide: BorderSide(color: MyColor.borderColor, width: 0.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6.0),
          borderSide: BorderSide(color: MyColor.borderColor, width: 0.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6.0),
          borderSide: BorderSide(color: MyColor.borderColor, width: 0.5),
        ),

        suffixIcon: widget.isShowSuffixIcon
            ? widget.isPassword
            ? IconButton(
            icon: Icon(obscureText
                ? Icons.visibility_off
                : Icons.visibility, color: widget.prefixIconcolor, size: 20), onPressed: _toggle)
            : widget.isIcon
            ? IconButton(
            onPressed: () {
              if (widget.onPress != null) {
                widget.onPress!(); // Handles custom suffix icon event
              }
            },
            icon: SvgPicture.asset(widget.prefixicon!, height: SizeConfig.blockSizeVertical * SizeUtils.ICONSIZE3,))
            : null
            : null,
      ),

      onFieldSubmitted: (text) => widget.nextFocus != null
          ? FocusScope.of(context).requestFocus(widget.nextFocus)
          : null,
                onChanged: (text) => widget.onChanged!(text),
              )
            : TextFormField(
               textDirection: widget.textDirection,
              onTap: () {
                widget.onPress!();
              },
              maxLines: widget.maxLines,
              readOnly: widget.readOnly,
              style: GoogleFonts.poppins(textStyle: TextStyle(
                  color: widget.hastextcolor == true
                      ? widget.fontColor
                      : MyColor.colorBlack, fontSize: widget.fontSize)),
              //textAlign: TextAlign.left,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.allow(RegExp("[0-9a-zA-Z]")),
              ],
              cursorColor: MyColor.colorBlack,
              controller: widget.controller,
              autofocus: false,
              textInputAction: widget.inputAction,
              enabled: widget.isEnable,
              focusNode: widget.focusNode,
              validator: widget.validator,
              keyboardType: widget.textInputType,
              obscureText: widget.isPassword ? obscureText : false,
              decoration: InputDecoration(
               /* prefixIcon: widget.hasIcon ? Icon(widget.prefixicon, color: widget.prefixIconcolor,) : null,*/
                constraints: BoxConstraints.loose(Size.fromHeight(widget.boxHeight)),
                contentPadding: EdgeInsets.symmetric(vertical: widget.verticalPadding, horizontal: 10),
                hintText: widget.hintText != null ? widget.hintText : '',
                hintStyle: GoogleFonts.poppins(textStyle: TextStyle(fontSize: widget.fontSize, color: widget.hintTextcolor, fontWeight: FontWeight.w400)),
                fillColor: widget.fillColor,
                filled: true,
                border: OutlineInputBorder(
                    borderSide: const BorderSide(
                        width: 0.1,
                        color: MyColor.labelTextColor),
                    borderRadius:
                    BorderRadius.circular(widget.circularCorner)),
                focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                        width: 0.1,
                        color: MyColor.labelTextColor),
                    borderRadius:
                    BorderRadius.circular(widget.circularCorner)),
                enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                        width: 0.1,
                        color: MyColor.labelTextColor),
                    borderRadius: BorderRadius.circular(widget.circularCorner)),
                suffixIcon: widget.isShowSuffixIcon
                    ? widget.isPassword
                        ? IconButton(
                            icon: Icon(
                                obscureText
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: MyColor.hintTextColor,
                                size: 20),
                            onPressed: _toggle)
                        : widget.isIcon
                            ? IconButton(
                                onPressed: widget.onSuffixTap,
                                icon: Icon(
                                  widget.isSearch
                                      ? Icons.search_outlined
                                      : widget.isCountryPicker
                                          ? Icons.arrow_drop_down_outlined
                                          : Icons.camera_alt_outlined,
                                  size: 25,
                                  color: MyColor.primaryColorblue,
                                ),
                              )
                            : null
                    : null,
              ),
              onFieldSubmitted: (text) => widget.nextFocus != null
                  ? FocusScope.of(context).requestFocus(widget.nextFocus)
                  : null,
              onChanged: (text) => widget.onChanged!(text),
            )
        : TextFormField(
            onTap: () {
              widget.onPress!();
            },
            maxLines: widget.maxLines,
            readOnly: widget.readOnly,
            style: GoogleFonts.poppins(textStyle: TextStyle(
                color: widget.hastextcolor
                    ? widget.fontColor
                    : MyColor.colorGrey)),
            //textAlign: TextAlign.left,
            cursorColor: MyColor.hintTextColor,
            controller: widget.controller,
            autofocus: false,
            textInputAction: widget.inputAction,
            enabled: widget.isEnable,
            focusNode: widget.focusNode,
            validator: widget.validator,
            keyboardType: widget.textInputType,
            obscureText: widget.isPassword ? obscureText : false,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(vertical: widget.verticalPadding, horizontal: 20),
              labelText: widget.labelText,
              labelStyle: GoogleFonts.poppins(textStyle: TextStyle(
                  color: widget.hastextcolor
                      ? MyColor.textColor
                      : MyColor.getLabelTextColor())),
              fillColor: MyColor.transparentColor,
              filled: true,
              border: UnderlineInputBorder(
                  borderSide: BorderSide(
                      width: 0.5, color: MyColor.getTextFieldDisableBorder())),
              focusedBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(
                      width: 0.5, color: MyColor.primaryColor)),
              enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                      width: 0.5, color: MyColor.getTextFieldDisableBorder())),
              suffixIcon: widget.isShowSuffixIcon
                  ? widget.isPassword
                      ? IconButton(
                          icon: Icon(
                              obscureText
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: MyColor.hintTextColor,
                              size: 20),
                          onPressed: _toggle)
                      : widget.isIcon
                          ? IconButton(
                              onPressed: widget.onSuffixTap,
                              icon: Icon(
                                widget.isSearch
                                    ? Icons.search_outlined
                                    : widget.isCountryPicker
                                        ? Icons.arrow_drop_down_outlined
                                        : Icons.camera_alt_outlined,
                                size: 25,
                                color: MyColor.primaryColorblue,
                              ),
                            )
                          : null
                  : null,
            ),
            onFieldSubmitted: (text) => widget.nextFocus != null
                ? FocusScope.of(context).requestFocus(widget.nextFocus)
                : null,
            onChanged: (text) => widget.onChanged!(text),
          );
  }

  void _toggle() {
    setState(() {
      obscureText = !obscureText;
    });
  }
}
