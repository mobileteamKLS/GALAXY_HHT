class FlightCheckULDListModel {
  List<FlightDetailList>? flightDetailList;
  List<AWBRemarkList>? aWBRemarkList;
  FlightDetailSummary? flightDetailSummary;
  String? status;
  String? statusMessage;

  FlightCheckULDListModel(
      {this.flightDetailList,
        this.flightDetailSummary,
        this.status,
        this.statusMessage});

  FlightCheckULDListModel.fromJson(Map<String, dynamic> json) {
    if (json['FlightDetailList'] != null) {
      flightDetailList = <FlightDetailList>[];
      json['FlightDetailList'].forEach((v) {
        flightDetailList!.add(new FlightDetailList.fromJson(v));
      });
    }
    if (json['AWBRemarkList'] != null) {
      aWBRemarkList = <AWBRemarkList>[];
      json['AWBRemarkList'].forEach((v) {
        aWBRemarkList!.add(new AWBRemarkList.fromJson(v));
      });
    }
    flightDetailSummary = json['FlightDetailSummary'] != null
        ? FlightDetailSummary.fromJson(json['FlightDetailSummary'])
        : null;
    status = json['Status'];
    statusMessage = json['StatusMessage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.flightDetailList != null) {
      data['FlightDetailList'] =
          this.flightDetailList!.map((v) => v.toJson()).toList();
    }
    if (this.aWBRemarkList != null) {
      data['AWBRemarkList'] =
          this.aWBRemarkList!.map((v) => v.toJson()).toList();
    }
    if (this.flightDetailSummary != null) {
      data['FlightDetailSummary'] = this.flightDetailSummary!.toJson();
    }
    data['Status'] = this.status;
    data['StatusMessage'] = this.statusMessage;
    return data;
  }
}

class FlightDetailList {
  int? uLDId;
  String? uLDNo;
  int? shipment;
  int? scanned;
  int? nPX;
  int? nPR;
  int? damageNOP;
  int? progress;
  int? bDPriority;
  String? isIntact;
  String? groupId;
  String? transit;
  String? sHCCode;
  String? damageConditionCode;
  String? uldAcceptStatus;
  String? bDEndStatus;

  FlightDetailList(
      {this.uLDId,
        this.uLDNo,
        this.shipment,
        this.scanned,
        this.nPX,
        this.nPR,
        this.damageNOP,
        this.progress,
        this.bDPriority,
        this.isIntact,
        this.groupId,
        this.transit,
        this.sHCCode,
        this.damageConditionCode,
        this.uldAcceptStatus,
        this.bDEndStatus,});

  FlightDetailList.fromJson(Map<String, dynamic> json) {
    uLDId = json['ULDId'];
    uLDNo = json['ULDNo'];
    shipment = json['Shipment'];
    scanned = json['Scanned'];
    nPX = json['NPX'];
    nPR = json['NPR'];
    damageNOP = json['DamageNOP'];
    progress = json['Progress'];
    bDPriority = json['BDPriority'];
    isIntact = json['IsIntact'];
    groupId = json['GroupId'];
    transit = json['Transit'];
    sHCCode = json['SHCCode'];
    damageConditionCode = json['DamageConditionCode'];
    uldAcceptStatus = json['ULDAcceptStatus'];
    bDEndStatus = json['BDEndStatus'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ULDId'] = this.uLDId;
    data['ULDNo'] = this.uLDNo;
    data['Shipment'] = this.shipment;
    data['Scanned'] = this.scanned;
    data['NPX'] = this.nPX;
    data['NPR'] = this.nPR;
    data['DamageNOP'] = this.damageNOP;
    data['Progress'] = this.progress;
    data['BDPriority'] = this.bDPriority;
    data['IsIntact'] = this.isIntact;
    data['GroupId'] = this.groupId;
    data['Transit'] = this.transit;
    data['SHCCode'] = this.sHCCode;
    data['DamageConditionCode'] = this.damageConditionCode;
    data['ULDAcceptStatus'] = this.uldAcceptStatus;
    data['BDEndStatus'] = this.bDEndStatus;
    return data;
  }
}

class AWBRemarkList {
  bool? isHighPriority;
  String? remark;
  String? AWBNo;

  AWBRemarkList({this.isHighPriority, this.remark, this.AWBNo});

  AWBRemarkList.fromJson(Map<String, dynamic> json) {
    isHighPriority = json['IsHighPriority'];
    remark = json['Remark'];
    AWBNo = json['AWBNo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['IsHighPriority'] = this.isHighPriority;
    data['Remark'] = this.remark;
    data['AWBNo'] = this.AWBNo;
    return data;
  }
}

class FlightDetailSummary {
  int? flightSeqNo;
  String? flightNo;
  String? aTAT;
  String? flightStatus;
  String? customRef;
  String? isNext;
  String? flightDate;
  String? displaySTA;
  String? aTA;
  int? progress;

  FlightDetailSummary(
      {this.flightSeqNo,
        this.flightNo,
        this.aTAT,
        this.flightStatus,
        this.customRef,
        this.isNext,
        this.flightDate,
        this.displaySTA,
        this.aTA,
        this.progress});

  FlightDetailSummary.fromJson(Map<String, dynamic> json) {
    flightSeqNo = json['FlightSeqNo'];
    flightNo = json['FlightNo'];
    aTAT = json['ATAT'];
    flightStatus = json['FlightStatus'];
    customRef = json['CustomRef'];
    isNext = json['IsNext'];
    flightDate = json['FlightDate'];
    displaySTA = json['DisplaySTA'];
    aTA = json['ATA'];
    progress = json['Progress'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['FlightSeqNo'] = this.flightSeqNo;
    data['FlightNo'] = this.flightNo;
    data['ATAT'] = this.aTAT;
    data['FlightStatus'] = this.flightStatus;
    data['CustomRef'] = this.customRef;
    data['IsNext'] = this.isNext;
    data['FlightDate'] = this.flightDate;
    data['DisplaySTA'] = this.displaySTA;
    data['ATA'] = this.aTA;
    data['Progress'] = this.progress;
    return data;
  }
}
