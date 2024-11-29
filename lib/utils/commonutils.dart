
import 'package:flutter/cupertino.dart';


class CommonUtils{

  static String airportCode = "BLR";

  static int defaultComapnyCode = 3;
  static String defaultLanguageCode = "en-US";
  static String LOGINMENUNAME = "HHT000";
  static String ARABICCULTURECODE = "ar";

  static String tempActionSorting = '';
  static String tempFilterSorting = '';

  static int ULDBT = 1;
  static int TROLLYBT = 0;
  static int ULDSEQUENCENUMBER = -1;
  static int FLIGHTSEQUENCENUMBER = -1;
  static String ULDNUMBER = "";
  static int TABCONTROLLERINDEX = 0;
  static String ULDNUMBERCEHCK = "";
  static String FLIGHTNUMBERCHECK = "";

  static List<String> SELECTEDIMAGELIST = [];
  static List<String> SELECTEDDAMAGEIMAGELIST = [];

  static String ULDUCRNO = "";
  static String UCRBTSTATUS = "";
  static String UCRGROUPID = "";
  static String ULDGROUPID = "";

  static String TROLLYTYPENUMBER = "";
  static String TROLLYDATETIME = "";

  static String SELECTEDTYPEOFDISCRPENCY = "";

  static int shipTotalPcs = 0;
  static String ShipTotalWt = "0.00";

  static int shipDamagePcs = 0;
  static String ShipDamageWt = "0.00";

  static int shipDifferencePcs = 0;
  static String shipDifferenceWt = "0.00";

  static String individualWTPerDoc = "0.00";
  static String individualWTActChk = "0.00";
  static String individualWTDifference = "0.00";


  static String SELECTEDMATERIAL = "";
  static String SELECTEDTYPE = "";
  static String SELECTEDMARKANDLABLE = "";
  static String SELECTEDOUTRERPACKING = "";
  static String SELECTEDINNERPACKING = "";

  static List<TextEditingController> CONTENTCONTROLLER = [];
  static String SELECTEDCONTENT = "";

  static List<TextEditingController> CONTAINERCONTROLLER = [];
  static String SELECTEDCONTAINER = "";

  static String SELECTEDDAMAGEDISCOVER = "";
  static String SELECTEDDAMAGEAPPARENTLY = "";
  static String SELECTEDSALVAGEACTION = "";
  static String SELECTEDDISPOSITION = "";
  static String SELECTEDWHETHER = "";

  static String MISSINGITEM = "Y";
  static String VERIFIEDINVOICE = "Y";
  static String SUFFICIENT = "Y";
  static String EVIDENCE = "Y";
  static String REMARKS = "";


  static String getImagePath(String imageName){
    return "assets/images/${imageName}";
  }

  static String getSVGImagePath(String imageName){
    return "assets/svgImages/${imageName}.svg";
  }




  static String getLableFromAssets(String lableKey, String langCode){

    String cleanedString = removeExtraIcons(lableKey);

    return cleanedString;

  }


  static String removeExtraIcons(String input) {
    // This regular expression matches any non-alphanumeric character.
    RegExp regex = RegExp(r'[^a-zA-Z0-9\s]');
    return input.replaceAll(regex, '');
  }


  static bool containsSpecialCharacters(String input) {
    // Define a regular expression pattern for special characters
    final specialCharactersRegex = RegExp(r'[!@#\$%^&*(),.?":{}|<>]');

    // Returns true if the input contains any special characters
    return specialCharactersRegex.hasMatch(input);
  }

  static bool containsSpecialCharactersAndAlpha(String input) {
    // Define a regular expression pattern for special characters
    final specialCharactersRegex = RegExp(r'[!@#\$%^&*(),.?":{}|<>a-zA-Z]');

    // Returns true if the input contains any special characters
    return specialCharactersRegex.hasMatch(input);
  }



  static String formateToTwoDecimalPlacesValue(double value){
    return value.toStringAsFixed(2);
  }

  static String formatMessage(String template, List<String> values) {
    String formattedMessage = template;
    for (int i = 0; i < values.length; i++) {
      formattedMessage = formattedMessage.replaceAll('{$i}', values[i]);
    }
    return formattedMessage;
  }


}