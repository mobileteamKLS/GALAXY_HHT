class VCTItem {
  final int consignmentRowId;
  final String houseNo;

  VCTItem({required this.consignmentRowId, required this.houseNo});

  factory VCTItem.fromJson(Map<String, dynamic> json) {
    return VCTItem(
      consignmentRowId: json['ConsignmentRowId'],
      houseNo: json['HouseNo'],
    );
  }
}

class VCTMasterDataForDamage {
  final int consignmentRowId;
  final String documentNo;
  final int impAWBRowId;
  final int impShipRowId;
  final String mawbInd;
  final int bookedFlightSequenceNumber;

  VCTMasterDataForDamage({
    required this.consignmentRowId,
    required this.documentNo,
    required this.impAWBRowId,
    required this.impShipRowId,
    required this.mawbInd,
    required this.bookedFlightSequenceNumber,
  });

  factory VCTMasterDataForDamage.fromJson(Map<String, dynamic> json) {
    return VCTMasterDataForDamage(
      consignmentRowId: json['ConsignmentRowId'],
      documentNo: json['DocumentNo'],
      impAWBRowId: json['ImpAWBRowId'],
      impShipRowId: json['ImpShipRowId'],
      mawbInd: json['MAWBInd'],
      bookedFlightSequenceNumber: json['BookedFlightSequenceNumber'],
    );
  }
}

class Commodity {
  final int commodityId;
  final String commodityType;
  final String commodityCode;

  Commodity({
    required this.commodityId,
    required this.commodityType,
    required this.commodityCode,
  });

  factory Commodity.fromJson(Map<String, dynamic> json) {
    return Commodity(
      commodityId: json['CommodityId'],
      commodityType: json['CommodityType'],
      commodityCode: json['CommodityCode'],
    );
  }
}

class Customer {
  final int customerId;
  final String customerName;

  Customer({
    required this.customerId,
    required this.customerName,
  });

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      customerId: json['CustomerId'],
      customerName: json['CustomerName'],
    );
  }
}

class RemainingPcs {
  String documentNo;
  String houseNo;
  String groupId;
  int agentId;
  String commodity;
  int remainingPkg;
  double remainingWt;
  int consignmentRowId;
  int houseRowId;

  RemainingPcs({
    required this.documentNo,
    required this.houseNo,
    required this.groupId,
    required this.agentId,
    required this.commodity,
    required this.remainingPkg,
    required this.remainingWt,
    required this.consignmentRowId,
    required this.houseRowId,
  });

  factory RemainingPcs.fromJSON(Map<String, dynamic> json) => RemainingPcs(
    documentNo: json["DocumentNo"],
    houseNo: json["HouseNo"],
    groupId: json["GroupId"],
    agentId: json["AgentId"],
    commodity: json["Commodity"],
    remainingPkg: json["RemainingPkg"],
    remainingWt: json["RemainingWt"],
    consignmentRowId: json["ConsignmentRowID"],
    houseRowId: json["HouseRowId"],
  );

  Map<String, dynamic> toJson() => {
    "DocumentNo": documentNo,
    "HouseNo": houseNo,
    "GroupId": groupId,
    "AgentId": agentId,
    "Commodity": commodity,
    "RemainingPkg": remainingPkg,
    "RemainingWt": remainingWt,
    "ConsignmentRowID": consignmentRowId,
    "HouseRowId": houseRowId,
  };
}

class ConsignmentAcceptedList {
  String documentNo;
  String houseNo;
  String nop;
  double weight;
  String groupId;
  int agentId;
  String commodity;
  int consignmentRowId;
  int houseRowId;
  String acceptanceBy;
  String acceptanceOn;
  int totalNpo;
  double totalWt;
  int awbId;
  int shipId;

  ConsignmentAcceptedList({
    required this.documentNo,
    required this.houseNo,
    required this.nop,
    required this.weight,
    required this.groupId,
    required this.agentId,
    required this.commodity,
    required this.consignmentRowId,
    required this.houseRowId,
    required this.acceptanceBy,
    required this.acceptanceOn,
    required this.totalNpo,
    required this.totalWt,
    required this.awbId,
    required this.shipId,
  });

  factory ConsignmentAcceptedList.fromJSON(Map<String, dynamic> json) => ConsignmentAcceptedList(
    documentNo: json["DocumentNo"],
    houseNo: json["HouseNo"],
    nop: json["NOP"],
    weight: json["Weight"],
    groupId: json["GroupId"],
    agentId: json["AgentId"],
    commodity: json["Commodity"],
    consignmentRowId: json["ConsignmentRowID"],
    houseRowId: json["HouseRowId"],
    acceptanceBy: json["AcceptanceBy"],
    acceptanceOn: json["AcceptanceOn"],
    totalNpo: json["TotalNPO"],
    totalWt: json["TotalWt"],
    awbId: json["AWBId"],
    shipId: json["ShipId"],
  );

  Map<String, dynamic> toJson() => {
    "DocumentNo": documentNo,
    "HouseNo": houseNo,
    "NOP": nop,
    "Weight": weight,
    "GroupId": groupId,
    "AgentId": agentId,
    "Commodity": commodity,
    "ConsignmentRowID": consignmentRowId,
    "HouseRowId": houseRowId,
    "AcceptanceBy": acceptanceBy,
    "AcceptanceOn": acceptanceOn,
    "TotalNPO": totalNpo,
    "TotalWt": totalWt,
  };
}

class DamageData14BList {
  String? referenceDataIdentifier;
  String? referenceDescription;
  String? isSelected;


  DamageData14BList({this.referenceDataIdentifier,
    this.referenceDescription,
    this.isSelected,
  });

  DamageData14BList.fromJson(Map<String, dynamic> json) {
    referenceDataIdentifier = json['REFERENCE_DATA_IDENTIFIER'];
    referenceDescription = json['REFERENCE_DESCRIPTION'];
    isSelected = json['IsSelected'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['REFERENCE_DATA_IDENTIFIER'] = this.referenceDataIdentifier;
    data['REFERENCE_DESCRIPTION'] = this.referenceDescription;
    data['IsSelected'] = this.isSelected;

    return data;
  }


}
