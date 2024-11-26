class ShipmentDamageListModel {
  List<DamageDetailList>? damageDetailList;
  String? status;
  String? statusMessage;

  ShipmentDamageListModel(
      {this.damageDetailList, this.status, this.statusMessage});

  ShipmentDamageListModel.fromJson(Map<String, dynamic> json) {
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
  String? flightNo;
  String? flightDate;
  int? flightSeqNo;
  int? iMPAWBRowId;
  int? iMPShipRowId;
  int? problemSeqId;
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
      {
        this.flightNo,
        this.flightDate,
        this.flightSeqNo,
        this.iMPAWBRowId,
        this.iMPShipRowId,
        this.problemSeqId,
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
    flightNo = json['FlightNo'];
    flightDate = json['FlightDate'];
    flightSeqNo = json['FlightSeqNo'];
    iMPAWBRowId = json['IMPAWBRowId'];
    iMPShipRowId = json['IMPShipRowId'];
    problemSeqId = json['ProblemSeqId'];
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
    data['FlightNo'] = this.flightNo;
    data['FlightDate'] = this.flightDate;
    data['FlightSeqNo'] = this.flightSeqNo;
    data['IMPAWBRowId'] = this.iMPAWBRowId;
    data['IMPShipRowId'] = this.iMPShipRowId;
    data['ProblemSeqId'] = this.problemSeqId;
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
