
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

  static String ULDUCRNO = "";
  static String UCRBTSTATUS = "";
  static String UCRGROUPID = "";
  static String ULDGROUPID = "";

  static String TROLLYTYPENUMBER = "";
  static String TROLLYDATETIME = "";


  static String SELECTEDMATERIAL = "";
  static String SELECTEDTYPE = "";
  static String SELECTEDMARKANDLABLE = "";
  static String SELECTEDOUTRERPACKING = "";
  static String SELECTEDINNERPACKING = "";
  static String SELECTEDCONTENT = "";
  static String SELECTEDCONTAINER = "";
  static String SELECTEDDAMAGEDISCOVER = "";
  static String SELECTEDDAMAGEAPPARENTLY = "";
  static String SELECTEDSALVAGEACTION = "";
  static String SELECTEDDISPOSITION = "";
  static String SELECTEDWHETHER = "";

  static String MISSINGITEM = "";
  static String VERIFIEDINVOICE = "";
  static String SUFFICIENT = "";
  static String EVIDENCE = "";
  static String REMARKS = "";


  static String getImagePath(String imageName){
    return "assets/images/${imageName}";
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


}