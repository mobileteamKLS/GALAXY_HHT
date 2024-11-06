class HAWBModel {
  int? aWBProgress;
  List<HAWBRemarksList>? hAWBRemarksList;
  List<FlightCheckInHAWBBDList>? flightCheckInHAWBBDList;
  String? status;
  String? statusMessage;

  HAWBModel(
      {this.aWBProgress,
        this.hAWBRemarksList,
        this.flightCheckInHAWBBDList,
        this.status,
        this.statusMessage});

  HAWBModel.fromJson(Map<String, dynamic> json) {
    aWBProgress = json['AWBProgress'];
    if (json['HAWBRemarksList'] != null) {
      hAWBRemarksList = <HAWBRemarksList>[];
      json['HAWBRemarksList'].forEach((v) {
        hAWBRemarksList!.add(new HAWBRemarksList.fromJson(v));
      });
    }
    if (json['FlightCheckInHAWBBDList'] != null) {
      flightCheckInHAWBBDList = <FlightCheckInHAWBBDList>[];
      json['FlightCheckInHAWBBDList'].forEach((v) {
        flightCheckInHAWBBDList!.add(new FlightCheckInHAWBBDList.fromJson(v));
      });
    }
    status = json['Status'];
    statusMessage = json['StatusMessage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['AWBProgress'] = this.aWBProgress;
    if (this.hAWBRemarksList != null) {
      data['HAWBRemarksList'] =
          this.hAWBRemarksList!.map((v) => v.toJson()).toList();
    }
    if (this.flightCheckInHAWBBDList != null) {
      data['FlightCheckInHAWBBDList'] =
          this.flightCheckInHAWBBDList!.map((v) => v.toJson()).toList();
    }
    data['Status'] = this.status;
    data['StatusMessage'] = this.statusMessage;
    return data;
  }

}

class HAWBRemarksList {
  bool? isHighPriority;
  String? remark;
  String? aWBNo;
  int? iMPAWBRowId;

  HAWBRemarksList(
      {this.isHighPriority, this.remark, this.aWBNo, this.iMPAWBRowId});

  HAWBRemarksList.fromJson(Map<String, dynamic> json) {
    isHighPriority = json['IsHighPriority'];
    remark = json['Remark'];
    aWBNo = json['AWBNo'];
    iMPAWBRowId = json['IMPAWBRowId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['IsHighPriority'] = this.isHighPriority;
    data['Remark'] = this.remark;
    data['AWBNo'] = this.aWBNo;
    data['IMPAWBRowId'] = this.iMPAWBRowId;
    return data;
  }
}

class FlightCheckInHAWBBDList {
  int? iMPAWBRowId;
  int? iMPSHIPRowId;
  int? uSeqNo;
  String? aWBNo;
  String? houseNo;
  int? nPX;
  int? nPR;
  double? weightExp;
  double? weightRec;
  int? shortLanded;
  int? excessLanded;
  int? damageNOP;
  double? damageWeight;
  String? aWBRemarksInd;
  String? agentName;
  String? mAWBInd;
  String? sHCCode;
  int? bDPriority;
  String? isIntact;
  String? transit;
  String? destination;
  String? commodity;
  String? nOG;
  int? progress;

  FlightCheckInHAWBBDList(
      {this.iMPAWBRowId,
        this.iMPSHIPRowId,
        this.uSeqNo,
        this.aWBNo,
        this.houseNo,
        this.nPX,
        this.nPR,
        this.weightExp,
        this.weightRec,
        this.shortLanded,
        this.excessLanded,
        this.damageNOP,
        this.damageWeight,
        this.aWBRemarksInd,
        this.agentName,
        this.mAWBInd,
        this.sHCCode,
        this.bDPriority,
        this.isIntact,
        this.transit,
        this.destination,
        this.commodity,
        this.nOG,
        this.progress});

  FlightCheckInHAWBBDList.fromJson(Map<String, dynamic> json) {
    iMPAWBRowId = json['IMPAWBRowId'];
    iMPSHIPRowId = json['IMPShipRowId'];
    uSeqNo = json['USeqNo'];
    aWBNo = json['AWBNo'];
    houseNo = json['HouseNo'];
    nPX = json['NPX'];
    nPR = json['NPR'];
    weightExp = json['WeightExp'];
    weightRec = json['WeightRec'];
    shortLanded = json['ShortLanded'];
    excessLanded = json['ExcessLanded'];
    damageNOP = json['DamageNOP'];
    damageWeight = json['DamageWeight'];
    aWBRemarksInd = json['AWBRemarksInd'];
    agentName = json['AgentName'];
    mAWBInd = json['MAWBInd'];
    sHCCode = json['SHCCode'];
    bDPriority = json['BDPriority'];
    isIntact = json['IsIntact'];
    transit = json['Transit'];
    destination = json['Destination'];
    commodity = json['Commodity'];
    nOG = json['NOG'];
    progress = json['Progress'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['IMPAWBRowId'] = this.iMPAWBRowId;
    data['IMPShipRowId'] = this.iMPSHIPRowId;
    data['USeqNo'] = this.uSeqNo;
    data['AWBNo'] = this.aWBNo;
    data['HouseNo'] = this.houseNo;
    data['NPX'] = this.nPX;
    data['NPR'] = this.nPR;
    data['WeightExp'] = this.weightExp;
    data['WeightRec'] = this.weightRec;
    data['ShortLanded'] = this.shortLanded;
    data['ExcessLanded'] = this.excessLanded;
    data['DamageNOP'] = this.damageNOP;
    data['DamageWeight'] = this.damageWeight;
    data['AWBRemarksInd'] = this.aWBRemarksInd;
    data['AgentName'] = this.agentName;
    data['MAWBInd'] = this.mAWBInd;
    data['SHCCode'] = this.sHCCode;
    data['BDPriority'] = this.bDPriority;
    data['IsIntact'] = this.isIntact;
    data['Transit'] = this.transit;
    data['Destination'] = this.destination;
    data['Commodity'] = this.commodity;
    data['NOG'] = this.nOG;
    data['Progress'] = this.progress;
    return data;
  }
}
