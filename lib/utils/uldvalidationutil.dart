import 'package:galaxy/utils/commonutils.dart';

class UldValidationUtil {


  static String validateUldNumberwithSpace1(String uldNumber) {
    // Remove all spaces

    String uldFullNumber = "";

    uldNumber = uldNumber.replaceAll(' ', '');
    print("+++++++++++++uldNumber ${uldNumber}");
    // Check overall length
    if (uldNumber.length < 9 || uldNumber.length > 11) {
      return "";
    }

    // Validate ULD Type (first 3 characters, all alphabetic)
    String uldType = uldNumber.substring(0, 3);
    if (!RegExp(r'^[A-Z]{3}$').hasMatch(uldType)) {
      return "";
    }
    print("+++++++++++++uldTypelength ${uldType.length}");

    // Determine ULD No and ULD Owner parts
    String uldNo;
    String uldOwner;
    if (uldNumber.length == 9) {
      // ULD Owner must be 2 characters long
      uldOwner = uldNumber.substring(uldNumber.length - 2);
      uldNo = uldNumber.substring(3, uldNumber.length - 2);
    } else if (uldNumber.length == 10) {
      // ULD Owner can be 2 or 3 characters long
      uldOwner = uldNumber.substring(uldNumber.length - 3);
      if (!RegExp(r'^[A-Z][A-Z0-9]{2}$').hasMatch(uldOwner)) {
        uldOwner = uldNumber.substring(uldNumber.length - 2);
      }
      uldNo = uldNumber.substring(3, uldNumber.length - uldOwner.length);
    } else {
      // ULD Owner must be 3 characters long
      uldOwner = uldNumber.substring(uldNumber.length - 3);
      uldNo = uldNumber.substring(3, uldNumber.length - 3);
    }

    // Validate ULD Owner
    if (uldOwner.length == 3) {
      if (!RegExp(r'^[A-Z][A-Z0-9]{2}$').hasMatch(uldOwner)) {
        return "ULD Owner must be either 2 or 3 characters long and contain at least one alphabetic character.";
      }
    } else if (uldOwner.length == 2) {
      if (!RegExp(r'^[A-Z0-9]{2}$').hasMatch(uldOwner) || RegExp(r'^[0-9]{2}$').hasMatch(uldOwner)) {
        return "ULD Owner must be 2 characters long and contain at least one alphabetic character.";
      }
    } else {
      return "ULD Owner must be either 2 or 3 characters long.";
    }

    print("+++++++++++++uldOwnerlength ${uldOwner.length}");
    // Validate ULD No
    if (uldNo.length == 5) {
      if (!RegExp(r'^\d{5}$').hasMatch(uldNo)) {
        return "ULD No of length 5 must contain only numeric characters.";
      }
    } else if (uldNo.length == 4) {
      if (!RegExp(r'^\d{3}[A-Z0-9]$').hasMatch(uldNo)) {
        return "ULD No of length 4 must have the first 3 characters as numeric and the last character as either an alphabetic character or a digit.";
      }
    } else {
      return "ULD No must be either 4 or 5 characters long.";
    }

    print("+++++++++++++uldNolength ${uldNo.length}");



   // return "Valid";

    CommonUtils.ULDNUMBERCEHCK =  "${uldType} ${uldNo} ${uldOwner}";

    return "Valid";


  }


}