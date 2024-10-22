class AWBModel {
  List<FlightCheckInAWBBDList>? flightCheckInAWBBDList;
  List<AWBRemarksList>? aWBRemarksList;
  String? status;
  String? statusMessage;
  int? ULDProgress;

  AWBModel({this.flightCheckInAWBBDList, this.aWBRemarksList, this.status, this.statusMessage});

  AWBModel.fromJson(Map<String, dynamic> json) {
    if (json['FlightCheckInAWBBDList'] != null) {
      flightCheckInAWBBDList = <FlightCheckInAWBBDList>[];
      json['FlightCheckInAWBBDList'].forEach((v) {
        flightCheckInAWBBDList!.add(new FlightCheckInAWBBDList.fromJson(v));
      });
    }

    if (json['AWBRemarksList'] != null) {
      aWBRemarksList = <AWBRemarksList>[];
      json['AWBRemarksList'].forEach((v) {
        aWBRemarksList!.add(new AWBRemarksList.fromJson(v));
      });
    }

    ULDProgress = json['ULDProgress'];
    status = json['Status'];
    statusMessage = json['StatusMessage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.flightCheckInAWBBDList != null) {
      data['FlightCheckInAWBBDList'] =
          this.flightCheckInAWBBDList!.map((v) => v.toJson()).toList();
    }
    if (this.aWBRemarksList != null) {
      data['AWBRemarksList'] =
          this.aWBRemarksList!.map((v) => v.toJson()).toList();
    }
    data['ULDProgress'] = this.ULDProgress;
    data['Status'] = this.status;
    data['StatusMessage'] = this.statusMessage;
    return data;
  }
}

class FlightCheckInAWBBDList {
  int? iMPAWBRowId;
  int? iMPShipRowId;
  int? uSeqNo;
  String? aWBNo;
  int? nPX;
  int? nPR;
  double? weightExp;
  double? weightRec;
  int? shortLanded;
  int? excessLanded;
  int? damageNOP;
  double? damageWeight;
  String? remark;
  String? agentName;
  String? mAWBInd;
  String? sHCCode;
  int? bDPriority;
  String? isIntact;
  String? transit;
  String? destination;
  String? commodity;
  String? NOG;
  int? progress;

  FlightCheckInAWBBDList(
      {this.iMPAWBRowId,
        this.iMPShipRowId,
        this.uSeqNo,
        this.aWBNo,
        this.nPX,
        this.nPR,
        this.weightExp,
        this.weightRec,
        this.shortLanded,
        this.excessLanded,
        this.damageNOP,
        this.damageWeight,
        this.remark,
        this.agentName,
        this.mAWBInd,
        this.sHCCode,
        this.bDPriority,
        this.isIntact,
        this.transit,
        this.destination,
        this.commodity,
        this.NOG,
        this.progress});

  FlightCheckInAWBBDList.fromJson(Map<String, dynamic> json) {
    iMPAWBRowId = json['IMPAWBRowId'];
    iMPShipRowId = json['IMPShipRowId'];
    uSeqNo = json['USeqNo'];
    aWBNo = json['AWBNo'];
    nPX = json['NPX'];
    nPR = json['NPR'];
    weightExp = json['WeightExp'];
    weightRec = json['WeightRec'];
    shortLanded = json['ShortLanded'];
    excessLanded = json['ExcessLanded'];
    damageNOP = json['DamageNOP'];
    damageWeight = json['DamageWeight'];
    remark = json['AWBRemarksInd'];
    agentName = json['AgentName'];
    mAWBInd = json['MAWBInd'];
    sHCCode = json['SHCCode'];
    bDPriority = json['BDPriority'];
    isIntact = json['IsIntact'];
    transit = json['Transit'];
    destination = json['Destination'];
    commodity = json['Commodity'];
    NOG = json['NOG'];
    progress = json['Progress'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['IMPAWBRowId'] = this.iMPAWBRowId;
    data['IMPShipRowId'] = this.iMPShipRowId;
    data['USeqNo'] = this.uSeqNo;
    data['AWBNo'] = this.aWBNo;
    data['NPX'] = this.nPX;
    data['NPR'] = this.nPR;
    data['WeightExp'] = this.weightExp;
    data['WeightRec'] = this.weightRec;
    data['ShortLanded'] = this.shortLanded;
    data['ExcessLanded'] = this.excessLanded;
    data['DamageNOP'] = this.damageNOP;
    data['DamageWeight'] = this.damageWeight;
    data['AWBRemarksInd'] = this.remark;
    data['AgentName'] = this.agentName;
    data['MAWBInd'] = this.mAWBInd;
    data['SHCCode'] = this.sHCCode;
    data['BDPriority'] = this.bDPriority;
    data['IsIntact'] = this.isIntact;
    data['Transit'] = this.transit;
    data['Destination'] = this.destination;
    data['Commodity'] = this.commodity;
    data['NOG'] = this.NOG;
    data['Progress'] = this.progress;
    return data;
  }



}


class AWBRemarksList {
  bool? isHighPriority;
  String? remark;
  String? aWBNo;
  int? iMPAWBRowId;

  AWBRemarksList(
      {this.isHighPriority, this.remark, this.aWBNo, this.iMPAWBRowId});

  AWBRemarksList.fromJson(Map<String, dynamic> json) {
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
