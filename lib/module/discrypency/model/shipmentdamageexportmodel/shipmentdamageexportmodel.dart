class ShipmentDamageExportModel {
  List<DamageDetailList>? damageDetailList;
  String? status;
  String? statusMessage;

  ShipmentDamageExportModel(
      {this.damageDetailList, this.status, this.statusMessage});

  ShipmentDamageExportModel.fromJson(Map<String, dynamic> json) {
    if (json['DamageDetailList'] != null) {
      damageDetailList = <DamageDetailList>[];
      json['DamageDetailList'].forEach((v) {
        damageDetailList!.add(new DamageDetailList.fromJson(v));
      });
    }
    status = json['Status'];
    statusMessage = json['StatusMessage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.damageDetailList != null) {
      data['DamageDetailList'] =
          this.damageDetailList!.map((v) => v.toJson()).toList();
    }
    data['Status'] = this.status;
    data['StatusMessage'] = this.statusMessage;
    return data;
  }
}

class DamageDetailList {
  int? expAWBRowId;
  int? flightSeqNo;
  String? flightNo;
  String? flightDate;
  int? problemSeqId;
  int? expShipRowId;
  int? uSeqNo;
  String? aWBNo;
  String? houseNo;
  int? nPX;
  int? nPR;
  double? weightExp;
  double? weightRec;
  int? damageNOP;
  double? damageWeight;
  String? agentName;
  String? mAWBInd;
  String? sHCCode;
  String? destination;
  String? commodity;
  String? nOG;
  String? groupId;
  int? nOP;
  double? weight;
  double? volume;

  DamageDetailList(
      {this.expAWBRowId,
        this.flightSeqNo,
        this.flightNo,
        this.flightDate,
        this.problemSeqId,
        this.expShipRowId,
        this.uSeqNo,
        this.aWBNo,
        this.houseNo,
        this.nPX,
        this.nPR,
        this.weightExp,
        this.weightRec,
        this.damageNOP,
        this.damageWeight,
        this.agentName,
        this.mAWBInd,
        this.sHCCode,
        this.destination,
        this.commodity,
        this.nOG,
        this.groupId,
        this.nOP,
        this.weight,
        this.volume});

  DamageDetailList.fromJson(Map<String, dynamic> json) {
    expAWBRowId = json['ExpAWBRowId'];
    flightSeqNo = json['FlightSeqNo'];
    flightNo = json['FlightNo'];
    flightDate = json['FlightDate'];
    problemSeqId = json['ProblemSeqId'];
    expShipRowId = json['ExpShipRowId'];
    uSeqNo = json['USeqNo'];
    aWBNo = json['AWBNo'];
    houseNo = json['HouseNo'];
    nPX = json['NPX'];
    nPR = json['NPR'];
    weightExp = json['WeightExp'];
    weightRec = json['WeightRec'];
    damageNOP = json['DamageNOP'];
    damageWeight = json['DamageWeight'];
    agentName = json['AgentName'];
    mAWBInd = json['MAWBInd'];
    sHCCode = json['SHCCode'];
    destination = json['Destination'];
    commodity = json['Commodity'];
    nOG = json['NOG'];
    groupId = json['GroupId'];
    nOP = json['NOP'];
    weight = json['Weight'];
    volume = json['Volume'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ExpAWBRowId'] = this.expAWBRowId;
    data['FlightSeqNo'] = this.flightSeqNo;
    data['FlightNo'] = this.flightNo;
    data['FlightDate'] = this.flightDate;
    data['ProblemSeqId'] = this.problemSeqId;
    data['ExpShipRowId'] = this.expShipRowId;
    data['USeqNo'] = this.uSeqNo;
    data['AWBNo'] = this.aWBNo;
    data['HouseNo'] = this.houseNo;
    data['NPX'] = this.nPX;
    data['NPR'] = this.nPR;
    data['WeightExp'] = this.weightExp;
    data['WeightRec'] = this.weightRec;
    data['DamageNOP'] = this.damageNOP;
    data['DamageWeight'] = this.damageWeight;
    data['AgentName'] = this.agentName;
    data['MAWBInd'] = this.mAWBInd;
    data['SHCCode'] = this.sHCCode;
    data['Destination'] = this.destination;
    data['Commodity'] = this.commodity;
    data['NOG'] = this.nOG;
    data['GroupId'] = this.groupId;
    data['NOP'] = this.nOP;
    data['Weight'] = this.weight;
    data['Volume'] = this.volume;
    return data;
  }
}
