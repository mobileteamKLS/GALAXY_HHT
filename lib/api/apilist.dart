class Apilist{
  // splash
  static String defaulApi = "/default";

  // login
  static String cultureMessageApi = "/CultureMessages";
  static String generateTokenApi = "/Authonticate/GenrateTocken";
  static String loginApi = "/login";

  // dashboard
  static String menuNamesApi = "/MenuNames";
  static String subMenuNamesApi = "/SubMenuNames";

  // common for location
  static String validateLocationsApi = "/Location/LocationValidate";

  // uld acceptance
  static String getButtonRolesAndRightsApi = "/ButtonRights";
  static String getDefaultUldAcceptanceApi = "/ULDAcceptance/GetDefault";
  static String getUldAcceptanceListApi = "/ULDAcceptance/GetULDList";
  static String uldAcceptApi = "/ULDAcceptance/ULDAccept";
  static String trollyAcceptApi = "/ULDAcceptance/TrollyAccept";
  static String getUldDamageListApi = "/ULDAcceptance/GetULDDamageList";
  static String uldDamageRecordApi = "/ULDAcceptance/ULDDamageAccept";
  static String uldDamageViewApi = "/ULDAcceptance/ULDDamageView";
  static String getFlightFromUldApi = "/ULDAcceptance/GetFlightDetails";
  static String uldUCRApi = "/ULDAcceptance/UCR";

  // flight check-in
  static String getFlightCheckULDListApi = "/FlightCheckIn/GetFlightDetails";
  static String getFlightSummarysApi = "/FlightCheckIn/GetFlightSummary";
  static String updateBDPriority = "/FlightCheckIn/UpdateBDPriority";
  static String recordAtaApi = "/FlightCheckIn/RecordATA";
  static String finalizeFlightApi = "/FlightCheckIn/FlightFinalized";

  static String awbListApi = "/FlightCheckIn/GetAWBDetails";
}