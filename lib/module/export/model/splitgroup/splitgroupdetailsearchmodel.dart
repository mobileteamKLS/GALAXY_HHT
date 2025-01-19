class GetSplitGroupDetailSearchModel {
  List<SplitGroupDetailList>? splitGroupDetailList;
  String? status;
  String? statusMessage;

  GetSplitGroupDetailSearchModel(
      {this.splitGroupDetailList, this.status, this.statusMessage});

  GetSplitGroupDetailSearchModel.fromJson(Map<String, dynamic> json) {
    if (json['SplitGroupDetailList'] != null) {
      splitGroupDetailList = <SplitGroupDetailList>[];
      json['SplitGroupDetailList'].forEach((v) {
        splitGroupDetailList!.add(new SplitGroupDetailList.fromJson(v));
      });
    }
    status = json['Status'];
    statusMessage = json['StatusMessage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.splitGroupDetailList != null) {
      data['SplitGroupDetailList'] =
          this.splitGroupDetailList!.map((v) => v.toJson()).toList();
    }
    data['Status'] = this.status;
    data['StatusMessage'] = this.statusMessage;
    return data;
  }
}

class SplitGroupDetailList {
  String? acceptanceLevel;
  int? expAWBRowId;
  int? expShipRowId;
  int? shipmentNo;
  int? stockRowId;
  String? houseNo;
  int? sBNo;
  int? nOP;
  double? weight;
  String? groupId;
  String? locationCode;
  String? aWBNo;
  String? mPSNo;
  String? bAG;

  SplitGroupDetailList(
      {this.acceptanceLevel,
        this.expAWBRowId,
        this.expShipRowId,
        this.shipmentNo,
        this.stockRowId,
        this.houseNo,
        this.sBNo,
        this.nOP,
        this.weight,
        this.groupId,
        this.locationCode,
        this.aWBNo,
        this.mPSNo,
        this.bAG});

  SplitGroupDetailList.fromJson(Map<String, dynamic> json) {
    acceptanceLevel = json['AcceptanceLevel'];
    expAWBRowId = json['ExpAWBRowId'];
    expShipRowId = json['ExpShipRowId'];
    shipmentNo = json['ShipmentNo'];
    stockRowId = json['StockRowId'];
    houseNo = json['HouseNo'];
    sBNo = json['SBNo'];
    nOP = json['NOP'];
    weight = json['Weight'];
    groupId = json['GroupId'];
    locationCode = json['LocationCode'];
    aWBNo = json['AWBNo'];
    mPSNo = json['MPSNo'];
    bAG = json['BAG'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['AcceptanceLevel'] = this.acceptanceLevel;
    data['ExpAWBRowId'] = this.expAWBRowId;
    data['ExpShipRowId'] = this.expShipRowId;
    data['ShipmentNo'] = this.shipmentNo;
    data['StockRowId'] = this.stockRowId;
    data['HouseNo'] = this.houseNo;
    data['SBNo'] = this.sBNo;
    data['NOP'] = this.nOP;
    data['Weight'] = this.weight;
    data['GroupId'] = this.groupId;
    data['LocationCode'] = this.locationCode;
    data['AWBNo'] = this.aWBNo;
    data['MPSNo'] = this.mPSNo;
    data['BAG'] = this.bAG;
    return data;
  }
}
