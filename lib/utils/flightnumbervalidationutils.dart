import 'package:galaxy/utils/commonutils.dart';

class FlightNumberValidationUtil {


  static bool isValidFlightNumber(String flightNumber) {
    // Split the flight number into carrier code and flight number parts
    final parts = flightNumber.split(' ');

    // Ensure there are exactly two parts
    if (parts.length != 2) {
      return false;
    }

    // Validate the carrier code
    final carrierCode = parts[0];
    if (!RegExp(r'^[A-Z0-9]{2,3}$').hasMatch(carrierCode)) {
      return false;
    }

    // Check carrier code length and respective rules
    if (carrierCode.length == 2) {
      if (!RegExp(r'^[A-Z0-9]{2}$').hasMatch(carrierCode) || RegExp(r'^\d{2}$').hasMatch(carrierCode)) {
        return false;
      }
    } else if (carrierCode.length == 3) {
      if (!RegExp(r'^[A-Z]{3}$').hasMatch(carrierCode)) {
        return false;
      }
    }

    // Validate the flight number part
    final flightNo = parts[1];
    if (!RegExp(r'^\d{3,5}[A-Z]?$').hasMatch(flightNo)) {
      return false;
    }

    return true;
  }



  static bool isValidFlightNumber12(String flightNumber) {
    // Remove all spaces
    flightNumber = flightNumber.replaceAll(' ', '');

    // Ensure the length is between 5 and 8 characters
    if (flightNumber.length < 5 || flightNumber.length > 8) {
      return false;
    }

    String carrierCode;
    String flightNo;

    // Try different ways to split the flight number
    if (flightNumber.length == 5) {
      // XX123 or X1234
      if (RegExp(r'^[A-Z0-9]{2}\d{3}$').hasMatch(flightNumber)) {
        carrierCode = flightNumber.substring(0, 2);
        flightNo = flightNumber.substring(2);
      } else {
        return false;
      }
    } else if (flightNumber.length == 6) {
      // XX1234 or XXX123
      if (RegExp(r'^[A-Z0-9]{2}\d{4}$').hasMatch(flightNumber)) {
        carrierCode = flightNumber.substring(0, 2);
        flightNo = flightNumber.substring(2);
      } else if (RegExp(r'^[A-Z]{3}\d{3}$').hasMatch(flightNumber)) {
        carrierCode = flightNumber.substring(0, 3);
        flightNo = flightNumber.substring(3);
      } else {
        return false;
      }
    } else if (flightNumber.length == 7) {
      // XX12345, XXX1234, or XX1234A
      if (RegExp(r'^[A-Z0-9]{2}\d{5}$').hasMatch(flightNumber)) {
        carrierCode = flightNumber.substring(0, 2);
        flightNo = flightNumber.substring(2);
      } else if (RegExp(r'^[A-Z]{3}\d{4}$').hasMatch(flightNumber)) {
        carrierCode = flightNumber.substring(0, 3);
        flightNo = flightNumber.substring(3);
      } else if (RegExp(r'^[A-Z0-9]{2}\d{4}[A-Z]$').hasMatch(flightNumber)) {
        carrierCode = flightNumber.substring(0, 2);
        flightNo = flightNumber.substring(2);
      } else {
        return false;
      }
    } else if (flightNumber.length == 8) {
      // XXX12345 or XXX1234A
      if (RegExp(r'^[A-Z]{3}\d{5}$').hasMatch(flightNumber)) {
        carrierCode = flightNumber.substring(0, 3);
        flightNo = flightNumber.substring(3);
      } else if (RegExp(r'^[A-Z]{3}\d{4}[A-Z]$').hasMatch(flightNumber)) {
        carrierCode = flightNumber.substring(0, 3);
        flightNo = flightNumber.substring(3);
      } else {
        return false;
      }
    } else {
      return false;
    }

    // Validate the carrier code
    if (!RegExp(r'^[A-Z0-9]{2,3}$').hasMatch(carrierCode)) {
      return false;
    }

    print("CARIRRCODE----- ${carrierCode.length}");
    print("CARIRRCODE----- ${flightNo.length}");

    // Check carrier code length and respective rules
    if (carrierCode.length == 2) {
      if (!RegExp(r'^[A-Z0-9]{2}$').hasMatch(carrierCode) || RegExp(r'^\d{2}$').hasMatch(carrierCode)) {
        return false;
      }
    } else if (carrierCode.length == 3) {
      if (!RegExp(r'^[A-Z]{3}$').hasMatch(carrierCode)) {
        return false;
      }
    }

    // Validate the flight number part
    if (!RegExp(r'^\d{3,5}[A-Z]?$').hasMatch(flightNo)) {
      return false;
    }

    CommonUtils.FLIGHTNUMBERCHECK = "${carrierCode} ${flightNo}";

    return true;
  }



}
