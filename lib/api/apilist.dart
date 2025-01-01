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


  //Export PallateStack
  static String getPalletStackDefaultPageLoadApi = "/PalletStack/GetPageLoad";
  static String getPalletStackPageLoadApi = "/PalletStack/Search";
  static String getPalletStacklistApi = "/PalletStack/GetPalletDetails";
  static String getPalletStackAssignFlightApi = "/PalletStack/AssignFlight";
  static String getPalletStackULDConditionCodeApi = "/PalletStack/GetULDConditionCodeList";
  static String getPalletStackUpdateULDConditionCodeApi = "/PalletStack/ULDConditionCodeUpdate";
  static String addPalletStackApi = "/PalletStack/AddPallet";
  static String removePalletStackApi = "/PalletStack/RemovePallet";
  static String revokePalletStackApi = "/PalletStack/RevokeULD";
  static String reopenClosePalletStackApi = "/PalletStack/PalletStatusUpdate";


  // Retrive ULD
  static String retriveULDTypeList = "/RetrieveULD/GetULDTypeList";
  static String retriveULDDetailList = "/RetrieveULD/GetULDDetailList";
  static String retriveULDList = "/RetrieveULD/GetULDList";
  static String retriveULDSearch = "/RetrieveULD/GetSearchULD";
  static String addToListApi = "/RetrieveULD/AddToList";
  static String retrieveULDBtnApi = "/RetrieveULD/RequestULD";
  static String cancelULDApi = "/RetrieveULD/CancelULD";


  // ULD TO ULD
  static String sourceULDApi = "/ULDToULD/GetSourceULD";
  static String targetULDApi = "/ULDToULD/GetTargetULD";
  static String moveULDApi = "/ULDToULD/MoveULD";
  static String removeFlightApi = "/ULDToULD/RemoveFlight";

  // Unload ULD
  static String unloadULDPageLoadApi = "/Unload/GetPageLoad";
  static String uldListApi = "/Unload/Search";
  static String uldawbListApi = "/Unload/GetAWBDetails";
  static String unloadOpenULDApi = "/Unload/OpenULD";
  static String unloadRemoveAWBApi = "/Unload/RemoveShipment";

  // Empty ULD/Trolley
  static String emptyULDTrollPageLoadApi = "/EmptyULDTrolley/GetPageLoad";
  static String searchULDTrollPageLoadApi = "/EmptyULDTrolley/Search";
  static String createULDTrolleyApi = "/EmptyULDTrolley/Create";


  // ULD Close
  static String closeULDSearchApi = "/CloseULD/Search";
  static String closeULDEquipmentApi = "/CloseULD/GetEequipmentList";
  static String saveEquipmentApi = "/CloseULD/SaveEequipment";
  static String closeULDContourApi = "/CloseULD/GetContourList";
  static String saveContourApi = "/CloseULD/SaveContour";
  static String closeULDScaleApi = "/CloseULD/GetScaleList";
  static String saveScaleApi = "/CloseULD/SaveScale";

}