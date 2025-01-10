class BuildUpAWBModel {
  List<AWBRemarksList>? aWBRemarksList;
  List<BuildUpAWBDetailList>? buildUpAWBDetailList;
  String? status;
  String? statusMessage;

  BuildUpAWBModel(
      {this.aWBRemarksList,
        this.buildUpAWBDetailList,
        this.status,
        this.statusMessage});

  BuildUpAWBModel.fromJson(Map<String, dynamic> json) {
    if (json['AWBRemarksList'] != null) {
      aWBRemarksList = <AWBRemarksList>[];
      json['AWBRemarksList'].forEach((v) {
        aWBRemarksList!.add(new AWBRemarksList.fromJson(v));
      });
    }
    if (json['BuildUpAWBDetailList'] != null) {
      buildUpAWBDetailList = <BuildUpAWBDetailList>[];
      json['BuildUpAWBDetailList'].forEach((v) {
        buildUpAWBDetailList!.add(new BuildUpAWBDetailList.fromJson(v));
      });
    }
    status = json['Status'];
    statusMessage = json['StatusMessage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.aWBRemarksList != null) {
      data['AWBRemarksList'] =
          this.aWBRemarksList!.map((v) => v.toJson()).toList();
    }
    if (this.buildUpAWBDetailList != null) {
      data['BuildUpAWBDetailList'] =
          this.buildUpAWBDetailList!.map((v) => v.toJson()).toList();
    }
    data['Status'] = this.status;
    data['StatusMessage'] = this.statusMessage;
    return data;
  }
}

class AWBRemarksList {
  int? isHighPriority;
  String? remark;
  String? aWBNo;
  int? expAWBRowId;

  AWBRemarksList(
      {this.isHighPriority, this.remark, this.aWBNo, this.expAWBRowId});

  AWBRemarksList.fromJson(Map<String, dynamic> json) {
    isHighPriority = json['IsHighPriority'];
    remark = json['Remark'];
    aWBNo = json['AWBNo'];
    expAWBRowId = json['ExpAWBRowId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['IsHighPriority'] = this.isHighPriority;
    data['Remark'] = this.remark;
    data['AWBNo'] = this.aWBNo;
    data['ExpAWBRowId'] = this.expAWBRowId;
    return data;
  }
}

class BuildUpAWBDetailList {
  String? aWBNo;
  int? nOP;
  double? weightKg;
  String? nOG;
  String? commodity;
  String? priority;
  String? sHCCode;
  String? aWBRemarksInd;
  String? groupBasedAcceptInd;
  int? expAWBRowId;
  int? expShipRowId;
  int? remainingNOP;
  double? remainingWeightKg;
  int? manifestedNOP;
  double? manifestedWeightKg;

  BuildUpAWBDetailList(
      {this.aWBNo,
        this.nOP,
        this.weightKg,
        this.nOG,
        this.commodity,
        this.priority,
        this.sHCCode,
        this.aWBRemarksInd,
        this.groupBasedAcceptInd,
        this.expAWBRowId,
        this.expShipRowId,
        this.remainingNOP,
        this.remainingWeightKg,
        this.manifestedNOP,
        this.manifestedWeightKg});

  BuildUpAWBDetailList.fromJson(Map<String, dynamic> json) {
    aWBNo = json['AWBNo'];
    nOP = json['NOP'];
    weightKg = json['WeightKg'];
    nOG = json['NOG'];
    commodity = json['Commodity'];
    priority = json['Priority'];
    sHCCode = json['SHCCode'];
    aWBRemarksInd = json['AWBRemarksInd'];
    groupBasedAcceptInd = json['GroupBasedAcceptInd'];
    expAWBRowId = json['ExpAWBRowId'];
    expShipRowId = json['ExpShipRowId'];
    remainingNOP = json['RemainingNOP'];
    remainingWeightKg = json['RemainingWeightKg'];
    manifestedNOP = json['ManifestedNOP'];
    manifestedWeightKg = json['ManifestedWeightKg'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['AWBNo'] = this.aWBNo;
    data['NOP'] = this.nOP;
    data['WeightKg'] = this.weightKg;
    data['NOG'] = this.nOG;
    data['Commodity'] = this.commodity;
    data['Priority'] = this.priority;
    data['SHCCode'] = this.sHCCode;
    data['AWBRemarksInd'] = this.aWBRemarksInd;
    data['GroupBasedAcceptInd'] = this.groupBasedAcceptInd;
    data['ExpAWBRowId'] = this.expAWBRowId;
    data['ExpShipRowId'] = this.expShipRowId;
    data['RemainingNOP'] = this.remainingNOP;
    data['RemainingWeightKg'] = this.remainingWeightKg;
    data['ManifestedNOP'] = this.manifestedNOP;
    data['ManifestedWeightKg'] = this.manifestedWeightKg;
    return data;
  }
}
