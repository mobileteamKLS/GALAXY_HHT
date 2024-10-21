import 'package:flutter/services.dart';

class DecimalTextInputFormatter extends TextInputFormatter {
  final int maxDigitsBeforeDecimal;
  final int maxDigitsAfterDecimal;

  DecimalTextInputFormatter({
    required this.maxDigitsBeforeDecimal,
    required this.maxDigitsAfterDecimal,
  });

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    String newText = newValue.text;

    // Regular expression for digits before and after decimal
    final regExp = RegExp(r'^\d{0,' + maxDigitsBeforeDecimal.toString() + r'}(\.\d{0,' +
        maxDigitsAfterDecimal.toString() + r'})?$');

    // If the new value matches the regular expression, return it
    if (regExp.hasMatch(newText)) {
      return newValue;
    }

    // If it doesn't match, return the old value (to block the invalid input)
    return oldValue;
  }
}