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

