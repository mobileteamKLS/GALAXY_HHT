
class ShipmentListDetails {
  int rowNo;
  String shipmentStatus;
  int rowId;
  String tokenNo;
  String airportCity;
  int awbPieces;
  double awbWeight;
  int pieces;
  double weight;
  double chargeableWt;
  String origin;
  String destination;
  String agentName;
  String sbNumber;
  String bookedOnAirline;
  String acceptedProcess;
  String documentNo;
  String fltAirline;
  String fltNo;
  String fltDate;
  String firms;
  String disposition;
  int fsnId;
  String commodityType;
  String weightUnit;
  String houseNo;
  int commoditySrNo;
  int vehicleRowId;
  String commodity;
  String uldType;
  String uldNumber;
  String uldOwner;
  int commodityGroupCode;
  String referenceDescription;
  String fsnSource;
  bool isComplete;
  String shipStatusDateTime;
  int acceptedPieces;
  double acceptedWeight;
  int vehicleConsignmentRowId;
  String handleCode1;
  String handleCode2;
  String handleCode3;
  String handleCode4;
  String handleCode5;
  String handleCode6;
  String handleCode7;
  String handleCode8;
  String handleCode9;
  int impShipRowId;

  ShipmentListDetails({
    required this.rowNo,
    required this.shipmentStatus,
    required this.rowId,
    required this.tokenNo,
    required this.airportCity,
    required this.awbPieces,
    required this.awbWeight,
    required this.pieces,
    required this.weight,
    required this.chargeableWt,
    required this.origin,
    required this.destination,
    required this.agentName,
    required this.sbNumber,
    required this.bookedOnAirline,
    required this.acceptedProcess,
    required this.documentNo,
    required this.fltAirline,
    required this.fltNo,
    required this.fltDate,
    required this.firms,
    required this.disposition,
    required this.fsnId,
    required this.commodityType,
    required this.weightUnit,
    required this.houseNo,
    required this.commoditySrNo,
    required this.vehicleRowId,
    required this.commodity,
    required this.uldType,
    required this.uldNumber,
    required this.uldOwner,
    required this.commodityGroupCode,
    required this.referenceDescription,
    required this.fsnSource,
    required this.isComplete,
    required this.shipStatusDateTime,
    required this.acceptedPieces,
    required this.acceptedWeight,
    required this.vehicleConsignmentRowId,
    required this.handleCode1,
    required this.handleCode2,
    required this.handleCode3,
    required this.handleCode4,
    required this.handleCode5,
    required this.handleCode6,
    required this.handleCode7,
    required this.handleCode8,
    required this.handleCode9,
    required this.impShipRowId,
  });

  factory ShipmentListDetails.fromJSON(Map<String, dynamic> json) => ShipmentListDetails(
    rowNo: json["RowNo"],
    shipmentStatus: json["ShipmentStatus"],
    rowId: json["RowId"],
    tokenNo: json["TokenNo"],
    airportCity: json["AirportCity"],
    awbPieces: json["AWBPieces"],
    awbWeight: json["AWBWeight"],
    pieces: json["Pieces"],
    weight: json["Weight"],
    chargeableWt: json["ChargeableWt"],
    origin: json["Origin"],
    destination: json["Destination"],
    agentName: json["AgentName"],
    sbNumber: json["SBNumber"],
    bookedOnAirline: json["BookedOnAirline"],
    acceptedProcess: json["AcceptedProcess"],
    documentNo: json["DocumentNo"],
    fltAirline: json["FltAirline"],
    fltNo: json["FltNo"],
    fltDate: json["FltDate"],
    firms: json["FIRMS"],
    disposition: json["Disposition"],
    fsnId: json["FSNId"],
    commodityType: json["CommodityType"],
    weightUnit: json["WeightUnit"],
    houseNo: json["HouseNo"],
    commoditySrNo: json["CommoditySrNo"],
    vehicleRowId: json["VehicleRowId"],
    commodity: json["Commodity"],
    uldType: json["ULDType"],
    uldNumber: json["ULDNumber"],
    uldOwner: json["ULDOwner"],
    commodityGroupCode: json["CommodityGroupCode"],
    referenceDescription: json["ReferenceDescription"],
    fsnSource: json["FSNSource"],
    isComplete: json["IsComplete"],
    shipStatusDateTime: json["ShipStatusDateTime"],
    acceptedPieces: json["AcceptedPieces"],
    acceptedWeight: json["AcceptedWeight"],
    vehicleConsignmentRowId: json["VehicleConsignmentRowId"],
    handleCode1: json["HandleCode1"],
    handleCode2: json["HandleCode2"],
    handleCode3: json["HandleCode3"],
    handleCode4: json["HandleCode4"],
    handleCode5: json["HandleCode5"],
    handleCode6: json["HandleCode6"],
    handleCode7: json["HandleCode7"],
    handleCode8: json["HandleCode8"],
    handleCode9: json["HandleCode9"],
    impShipRowId: json['ImpShipRowId']
  );

  Map<String, dynamic> toMap() => {
    "RowNo": rowNo,
    "ShipmentStatus": shipmentStatus,
    "RowId": rowId,
    "TokenNo": tokenNo,
    "AirportCity": airportCity,
    "AWBPieces": awbPieces,
    "AWBWeight": awbWeight,
    "Pieces": pieces,
    "Weight": weight,
    "ChargeableWt": chargeableWt,
    "Origin": origin,
    "Destination": destination,
    "AgentName": agentName,
    "SBNumber": sbNumber,
    "BookedOnAirline": bookedOnAirline,
    "AcceptedProcess": acceptedProcess,
    "DocumentNo": documentNo,
    "FltAirline": fltAirline,
    "FltNo": fltNo,
    "FltDate": fltDate,
    "FIRMS": firms,
    "Disposition": disposition,
    "FSNId": fsnId,
    "CommodityType": commodityType,
    "WeightUnit": weightUnit,
    "HouseNo": houseNo,
    "CommoditySrNo": commoditySrNo,
    "VehicleRowId": vehicleRowId,
    "Commodity": commodity,
    "ULDType": uldType,
    "ULDNumber": uldNumber,
    "ULDOwner": uldOwner,
    "CommodityGroupCode": commodityGroupCode,
    "ReferenceDescription": referenceDescription,
    "FSNSource": fsnSource,
    "IsComplete": isComplete,
    "ShipStatusDateTime": shipStatusDateTime,
    "AcceptedPieces": acceptedPieces,
    "AcceptedWeight": acceptedWeight,
    "VehicleConsignmentRowId": vehicleConsignmentRowId,
    "HandleCode1": handleCode1,
    "HandleCode2": handleCode2,
    "HandleCode3": handleCode3,
    "HandleCode4": handleCode4,
    "HandleCode5": handleCode5,
    "HandleCode6": handleCode6,
    "HandleCode7": handleCode7,
    "HandleCode8": handleCode8,
    "HandleCode9": handleCode9,
  };
}

class ShipmentStatus {
  String keyValue;
  String description;

  ShipmentStatus({
    required this.keyValue,
    required this.description,
  });

  factory ShipmentStatus.fromJson(Map<String, dynamic> json) => ShipmentStatus(
    keyValue: json["KeyValue"],
    description: json["Description"],
  );

  Map<String, dynamic> toJson() => {
    "KeyValue": keyValue,
    "Description": description,
  };
}

class ShipmentCreateDetails {
  int vhRowId;
  String awbPrefix;
  String awbNo;
  String houseNo;
  int pieces;
  double weight;
  String origin;
  String destination;
  int commodity;
  String commodityType;
  String airline;
  String fltNo;
  String fltDate;
  String uldType;
  String uldNumber;
  String uldOwner;
  String firms;
  String disposition;
  int fsnId;
  String shcDetailsXml;
  String airportCode;
  int companyCode;
  String cultureCode;
  int userId;
  int menuId;

  ShipmentCreateDetails({
    required this.vhRowId,
    required this.awbPrefix,
    required this.awbNo,
    required this.houseNo,
    required this.pieces,
    required this.weight,
    required this.origin,
    required this.destination,
    required this.commodity,
    required this.commodityType,
    required this.airline,
    required this.fltNo,
    required this.fltDate,
    required this.uldType,
    required this.uldNumber,
    required this.uldOwner,
    required this.firms,
    required this.disposition,
    required this.fsnId,
    required this.shcDetailsXml,
    required this.airportCode,
    required this.companyCode,
    required this.cultureCode,
    required this.userId,
    required this.menuId,
  });

  factory ShipmentCreateDetails.fromMap(Map<String, dynamic> json) => ShipmentCreateDetails(
    vhRowId: json["VHRowId"],
    awbPrefix: json["AWBPrefix"],
    awbNo: json["AWBNo"],
    houseNo: json["HouseNo"],
    pieces: json["Pieces"],
    weight: json["Weight"],
    origin: json["Origin"],
    destination: json["Destination"],
    commodity: json["Commodity"],
    commodityType: json["CommodityType"],
    airline: json["Airline"],
    fltNo: json["FltNo"],
    fltDate: json["FltDate"],
    uldType: json["ULDType"],
    uldNumber: json["ULDNumber"],
    uldOwner: json["ULDOwner"],
    firms: json["FIRMS"],
    disposition: json["Disposition"],
    fsnId: json["FSNId"],
    shcDetailsXml: json["SHCDetailsXML"],
    airportCode: json["AirportCode"],
    companyCode: json["CompanyCode"],
    cultureCode: json["CultureCode"],
    userId: json["UserId"],
    menuId: json["MenuId"],
  );

  Map<String, dynamic> toMap() => {
    "VHRowId": vhRowId,
    "AWBPrefix": awbPrefix,
    "AWBNo": awbNo,
    "HouseNo": houseNo,
    "Pieces": pieces,
    "Weight": weight,
    "Origin": origin,
    "Destination": destination,
    "Commodity": commodity,
    "CommodityType": commodityType,
    "Airline": airline,
    "FltNo": fltNo,
    "FltDate": fltDate,
    "ULDType": uldType,
    "ULDNumber": uldNumber,
    "ULDOwner": uldOwner,
    "FIRMS": firms,
    "Disposition": disposition,
    "FSNId": fsnId,
    "SHCDetailsXML": shcDetailsXml,
    "AirportCode": airportCode,
    "CompanyCode": companyCode,
    "CultureCode": cultureCode,
    "UserId": userId,
    "MenuId": menuId,
  };
}
