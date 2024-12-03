import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:galaxy/module/onboarding/sizeconfig.dart';
import 'package:galaxy/utils/commonutils.dart';
import 'package:galaxy/utils/uldvalidationutil.dart';
import 'package:galaxy/widget/custometext.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/images.dart';
import '../../core/mycolor.dart';
import '../../utils/flightnumbervalidationutils.dart';
import '../../utils/sizeutils.dart';



class CustomeEditTextWithBorder extends StatefulWidget {
  final String lablekey;
  final String? labelText;
  final IconData? prefixicon;
  final String? hintText;
  final Function(String, bool)? onChanged;
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
  final List<TextInputFormatter>? inputFormatters;
  final noUpperCase;

  const CustomeEditTextWithBorder(
      {Key? key,
        required this.lablekey,
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
        this.noUpperCase = false,
        this.prefixIconcolor,
        this.hintTextcolor,
        this.verticalPadding = 0,
        this.circularCorner = 30,
        this.onPress,
        this.maxLength = 13,
        this.textDirection = TextDirection.ltr,
        this.inputFormatters,
        this.boxHeight = 30})
      : super(key: key);

  @override
  State<CustomeEditTextWithBorder> createState() => _ULDCustomTextFieldState();
}

class _ULDCustomTextFieldState extends State<CustomeEditTextWithBorder> {
  bool obscureText = true;
  String? suffixIcon;
  Color? suffixIconColor;

  @override
  void initState() {
    super.initState();
   if(!widget.noUpperCase)widget.controller?.addListener(_updateTextToUppercase);
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

    bool obscureText = true;
    return TextFormField(
      textDirection: widget.textDirection,
      onTap: () {
        widget.onPress!();
      },
      maxLength: widget.maxLength,
      maxLines: widget.maxLines,
      readOnly: widget.readOnly,
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.allow(RegExp("[0-9a-zA-Z.]")),
      ],
      /*  inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'[A-Z0-9]')), // Allow only alphanumeric characters
      ],*/
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
        prefixIcon: widget.hasIcon ? Icon(widget.prefixicon, color: widget.prefixIconcolor,) : null,
        contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
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
        suffixIcon: (widget.isShowSuffixIcon) ? suffixIcon != null
            ? Padding(
              padding: const EdgeInsets.all(12.0),
              child: SvgPicture.asset(suffixIcon!, height: SizeConfig.blockSizeVertical * SizeUtils.ICONSIZE2, ),
            )/*Icon(
          suffixIcon,
          color: suffixIconColor,
        )*/
            : null : null,
      ),

      onFieldSubmitted: (text) => widget.nextFocus != null
          ? FocusScope.of(context).requestFocus(widget.nextFocus)
          : null,

      onChanged: (text) {


        widget.onChanged!(text, false);

        if(widget.lablekey == "ULD"){
          String validationMessage = UldValidationUtil.validateUldNumberwithSpace1(text);
          print("Check Validation Number === ${validationMessage} == ${widget.controller!.text} == ${text.length}");
          setState(() {
            if (validationMessage == "Valid") {
              print("CHECK_VALID_=== ${CommonUtils.ULDNUMBERCEHCK}");
              widget.controller!.text = CommonUtils.ULDNUMBERCEHCK;
              suffixIcon = donecircle;
              suffixIconColor = MyColor.colorGreen;
              widget.onChanged!(text, true);
            }else if(text.isEmpty){
              suffixIcon = null;
              widget.onChanged!(text, false);
            } else {
              suffixIcon = infored;
              suffixIconColor = MyColor.colorRed;
            }
          });
        }
        else if(widget.lablekey == "FLIGHT"){
          bool validationMessage = FlightNumberValidationUtil.isValidFlightNumber12(text);
          print("Check Flight Number === ${validationMessage} == ${text} == ${text.length}");
          setState(() {
            if (validationMessage) {
              suffixIcon = donecircle;
              print("CHECK_VALID_=== ${CommonUtils.FLIGHTNUMBERCHECK}");
              widget.controller!.text = CommonUtils.FLIGHTNUMBERCHECK;
              suffixIconColor = MyColor.colorGreen;
              widget.onChanged!(text, true);
            }else if(text.isEmpty){
              suffixIcon = null;
              widget.onChanged!(text, false);
            } else {
              suffixIcon = infored;
              suffixIconColor = MyColor.colorRed;
            }
          });
        }
        else if(widget.lablekey == "LOCATION"){
          suffixIcon = donecircle;
          suffixIconColor = MyColor.colorGreen;
          widget.onChanged!(text, true);
        }
        else if(widget.lablekey == "AIRPORT"){
          suffixIcon = donecircle;
          suffixIconColor = MyColor.colorGreen;
          widget.onChanged!(text, true);
        }


      },
      /*onChanged: (text) => widget.onChanged!(text),*/
    );
  }

  void _toggle() {
    setState(() {
      obscureText = !obscureText;
    });
  }
}
