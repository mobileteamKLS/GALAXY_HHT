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
  static String getPageLoadApi = "/FlightCheckIn/GetPageLoad";
  static String getFlightCheckULDListApi = "/FlightCheckIn/GetFlightDetails";
  static String getFlightSummarysApi = "/FlightCheckIn/GetFlightSummary";
  static String updateBDPriority = "/FlightCheckIn/UpdateBDPriority";
  static String recordAtaApi = "/FlightCheckIn/RecordATA";
  static String finalizeFlightApi = "/FlightCheckIn/FlightFinalized";

  // awb list apis
  static String awbListApi = "/FlightCheckIn/GetAWBDetails";
  static String updateBDPriorityAWB = "/FlightCheckIn/UpdateAWBBDPriority";

  // remark acknowledge
  static String updateAWBRemarksAcknowledge = "/FlightCheckIn/UpdateAWBRemarksAcknowledge";

  // mail screen apis
  static String getAddMailDetailsApi = "/FlightCheckIn/GetAddMailView";
  static String addMailApi = "/FlightCheckIn/AddMail";
  static String getMailTypeApi = "/FlightCheckIn/GetMailTypeList";
  static String checkAirportApi = "/AirportCode/AirportCodeValidate";

  // breakdown save - damage and end api
  static String importManifestSaveApi = "/FlightCheckIn/ImportManifestSave";
  static String getDamageDetailsApi = "/FlightCheckIn/GetDamageDetails";
  static String damageDetailsSaveApi = "/FlightCheckIn/DamageSave";
  static String breakDownEndApi = "/FlightCheckIn/BreakDownEnd";

  // house list apis
  static String houseListApi = "/FlightCheckIn/GetHAWBDetails";


  // Binning list details
  static String binningDetailListApi = "/Binning/GetDetails";


}