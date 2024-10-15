import 'package:galaxy/utils/commonutils.dart';

class UldValidationUtil {

  static String validateUldNumber(String uldNumber) {
    // Check if the ULD number length is either 9, 10, or 11 characters
    if (uldNumber.length != 9 && uldNumber.length != 10 && uldNumber.length != 11) {
      return "ULD number must be 9, 10, or 11 characters long.";
    }

    // Extract parts from the ULD number
    String uldType = uldNumber.substring(0, 3);
    String uldNo;
    String uldOwner;

    if (uldNumber.length == 9 || uldNumber.length == 10) {
      uldNo = uldNumber.substring(3, uldNumber.length - 2);
      uldOwner = uldNumber.substring(uldNumber.length - 2);
    } else {
      uldNo = uldNumber.substring(3, uldNumber.length - 3);
      uldOwner = uldNumber.substring(uldNumber.length - 3);
    }

    // Validate ULD Type (3 alphabetic characters)
    if (!RegExp(r'^[A-Z]{3}$').hasMatch(uldType)) {
      return "ULD Type must be exactly 3 alphabetic characters.";
    }

    // Validate ULD No
    if (uldNo.length == 5) {
      if (!RegExp(r'^\d{5}$').hasMatch(uldNo)) {
        return "ULD No of length 5 must contain only numeric characters.";
      }
    } else if (uldNo.length == 4) {
      if (!RegExp(r'^\d{3}[A-Z0-9]$').hasMatch(uldNo)) {
        return "ULD No of length 4 must end with an alphabetic character or a digit.";
      }
    } else {
      return "ULD No must be either 4 or 5 characters long.";
    }

    // Validate ULD Owner
    if (uldOwner.length == 3) {
      if (!RegExp(r'^[A-Z][A-Z0-9]{2}$').hasMatch(uldOwner)) {
        return "ULD Owner of length 3 must start with an alphabetic character.";
      }
    } else if (uldOwner.length == 2) {
      if (!RegExp(r'[A-Z]').hasMatch(uldOwner)) {
        return "ULD Owner of length 2 must contain at least one alphabetic character.";
      }
    } else {
      return "ULD Owner must be either 2 or 3 characters long.";
    }

    return "Valid";
  }


  static String validateUldNumber1(String uldNumber) {
    // Split the ULD number into parts
    List<String> parts = uldNumber.split(' ');

    if (parts.length != 3) {
      return "ULD number must be in the format 'ULDType ULDNo ULDOwner'.";
    }

    String uldType = parts[0];
    String uldNo = parts[1];
    String uldOwner = parts[2];

    // Validate ULD Type (3 alphabetic characters)
    if (uldType.length != 3 || !RegExp(r'^[A-Z]{3}$').hasMatch(uldType)) {
      return "ULD Type must be exactly 3 alphabetic characters.";
    }

    // Validate ULD No
    if (uldNo.length == 5) {
      if (!RegExp(r'^\d{5}$').hasMatch(uldNo)) {
        return "ULD No of length 5 must contain only numeric characters.";
      }
    } else if (uldNo.length == 4) {
      if (!RegExp(r'^\d{3}[A-Z]$').hasMatch(uldNo)) {
        return "ULD No of length 4 must end with an alphabetic character or a digit.";
      }
    } else {
      return "ULD No must be either 4 or 5 characters long.";
    }

    // Validate ULD Owner
    if (uldOwner.length == 3) {
      if (!RegExp(r'^[A-Z][A-Z0-9]{2}$').hasMatch(uldOwner)) {
        return "ULD Owner of length 3 must start with an alphabetic character.";
      }
    } else if (uldOwner.length == 2) {
      if (!RegExp(r'^[A-Z0-9]*[A-Z][A-Z0-9]*$').hasMatch(uldOwner)) {
        return "ULD Owner of length 2 must contain at least one alphabetic character.";
      }
    } else {
      return "ULD Owner must be either 2 or 3 characters long.";
    }

    return "Valid";
  }

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