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
  // found cargo save
  static String foundCargoSaveApi = "/FlightCheckIn/FoundCargoSave";

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
  static String getBinningPageLoadApi = "/Binning/GetPageLoad";
  static String binningDetailListApi = "/Binning/GetDetails";
  static String binningSaveApi = "/Binning/Save";

  // Shipment Damage details
  static String getShipmentDamageDetailListApi = "/ShipmentDamage/GetDetails";
  static String revokeDamageApi = "/ShipmentDamage/RevokeDamage";


  // Export Airside release
  static String getAirsideReleasePageLoadApi = "/AirsideRelease/GetPageLoad";
  static String getAirsideReleaseListApi = "/AirsideRelease/Search";
  static String getAirsideShipmentListApi = "/AirsideRelease/GetAWBDetails";
  static String getreleaseULDOrTrollyApi = "/AirsideRelease/Release";
  static String getreleasePriorityUpdateApi = "/AirsideRelease/PriorityUpdate";
  static String getSignUploadApi = "/AirsideRelease/SignUpload";
  static String getBatteryUpdateApi = "/AirsideRelease/BatteryStrengthUpdate";
  static String getTempratureUpdateApi = "/AirsideRelease/TemperatureUpdate";


}