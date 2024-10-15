import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/mycolor.dart';

class DropDownTextField extends StatefulWidget {
  final String? labelText;
  final IconData? prefixicon;
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
  final TextDirection textDirection;
  final List<String> items;
  final String? selectedItem;

  const DropDownTextField(
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
        this.maxLength = 13,
        this.textDirection = TextDirection.ltr,
        this.boxHeight = 30,
        required this.items,
        this.selectedItem,})
      : super(key: key);

  @override
  State<DropDownTextField> createState() => _DropDownTextFieldState();
}

class _DropDownTextFieldState extends State<DropDownTextField> {
  late String? _selectedItem;

  @override
  void initState() {
    super.initState();
    widget.controller?.addListener(_updateTextToUppercase);
    _selectedItem = widget.selectedItem;
  }

  @override
  void dispose() {
    widget.controller?.removeListener(_updateTextToUppercase);
    super.dispose();
  }

  void _updateTextToUppercase() {
    if (widget.controller != null &&
        widget.controller!.text != widget.controller!.text.toUpperCase()) {
      widget.controller!.value = widget.controller!.value.copyWith(
        text: widget.controller!.text.toUpperCase(),
        selection: TextSelection.collapsed(
            offset: widget.controller!.text.length),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          textDirection: widget.textDirection,
          onTap: () {
            widget.onPress!();
          },
          maxLength: widget.maxLength,
          maxLines: widget.maxLines,
          readOnly: true, // Set to true for dropdown
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.allow(RegExp("[0-9a-zA-Z ]")),
          ],
          style: GoogleFonts.poppins(textStyle: TextStyle(
              color: widget.hastextcolor == true
                  ? MyColor.colorBlack
                  : MyColor.colorBlack,
              fontSize: widget.fontSize)),
          cursorColor: MyColor.primaryColorblue,
          controller: widget.controller,
          autofocus: false,
          textInputAction: widget.inputAction,
          enabled: widget.isEnable,
          focusNode: widget.focusNode,
          validator: widget.validator,
          keyboardType: widget.textInputType,
          obscureText: widget.isPassword ? true : false,
          decoration: InputDecoration(
            counterText: "",
            constraints:
            BoxConstraints.loose(Size.fromHeight(widget.boxHeight)),
            hintText: widget.hintText != null ? widget.hintText! : '',
            prefixIcon: widget.hasIcon
                ? Icon(
              widget.prefixicon,
              color: widget.prefixIconcolor,
            )
                : null,
            contentPadding: EdgeInsets.symmetric(
                vertical: widget.verticalPadding, horizontal: 10),
            labelText: widget.labelText ?? '',
            labelStyle: GoogleFonts.poppins(
                textStyle: TextStyle(
                    color: widget.hastextcolor
                        ? MyColor.colorBlack
                        : MyColor.colorBlack,
                    fontSize: widget.fontSize)),
            fillColor: widget.fillColor,
            filled: true,
            errorStyle: widget.showErrorText == false
                ? const TextStyle(color: MyColor.colorRed, fontSize: 0)
                : null,
            border: OutlineInputBorder(
                borderSide: BorderSide(
                    width: 0.1, color: MyColor.getTextFieldDisableBorder()),
                borderRadius: BorderRadius.circular(widget.circularCorner)),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    width: 0.1, color: MyColor.getTextFieldDisableBorder()),
                borderRadius: BorderRadius.circular(widget.circularCorner)),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    width: 0.1, color: MyColor.getTextFieldDisableBorder()),
                borderRadius: BorderRadius.circular(widget.circularCorner)),
            suffixIcon: (widget.isShowSuffixIcon)
                ? Icon(Icons.arrow_drop_down_sharp)
                : null,
          ),
        ),

      ],
    );
  }
}
