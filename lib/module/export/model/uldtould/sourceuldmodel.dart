class SourceULDModel {
  SourceULDDetail? sourceULDDetail;
  List<SourceULDAWBDetailList>? sourceULDAWBDetailList;
  String? status;
  String? statusMessage;

  SourceULDModel(
      {this.sourceULDDetail,
        this.sourceULDAWBDetailList,
        this.status,
        this.statusMessage});

  SourceULDModel.fromJson(Map<String, dynamic> json) {
    sourceULDDetail = json['SourceULDDetail'] != null
        ? new SourceULDDetail.fromJson(json['SourceULDDetail'])
        : null;
    if (json['SourceULDAWBDetailList'] != null) {
      sourceULDAWBDetailList = <SourceULDAWBDetailList>[];
      json['SourceULDAWBDetailList'].forEach((v) {
        sourceULDAWBDetailList!.add(new SourceULDAWBDetailList.fromJson(v));
      });
    }
    status = json['Status'];
    statusMessage = json['StatusMessage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.sourceULDDetail != null) {
      data['SourceULDDetail'] = this.sourceULDDetail!.toJson();
    }
    if (this.sourceULDAWBDetailList != null) {
      data['SourceULDAWBDetailList'] =
          this.sourceULDAWBDetailList!.map((v) => v.toJson()).toList();
    }
    data['Status'] = this.status;
    data['StatusMessage'] = this.statusMessage;
    return data;
  }
}

class SourceULDDetail {
  int? sourceULDSeqNo;
  String? sourceULDType;
  String? sourceULDStatus;
  String? sourceULDConditionCode;
  int? sourceFlightSeqNo;
  String? sourceFlightNo;
  String? sourceFlightDate;
  String? sourceDestination;

  SourceULDDetail(
      {this.sourceULDSeqNo,
        this.sourceULDType,
        this.sourceULDStatus,
        this.sourceULDConditionCode,
        this.sourceFlightSeqNo,
        this.sourceFlightNo,
        this.sourceFlightDate,
        this.sourceDestination});

  SourceULDDetail.fromJson(Map<String, dynamic> json) {
    sourceULDSeqNo = json['SourceULDSeqNo'];
    sourceULDType = json['SourceULDType'];
    sourceULDStatus = json['SourceULDStatus'];
    sourceULDConditionCode = json['SourceULDConditionCode'];
    sourceFlightSeqNo = json['SourceFlightSeqNo'];
    sourceFlightNo = json['SourceFlightNo'];
    sourceFlightDate = json['SourceFlightDate'];
    sourceDestination = json['SourceDestination'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['SourceULDSeqNo'] = this.sourceULDSeqNo;
    data['SourceULDType'] = this.sourceULDType;
    data['SourceULDStatus'] = this.sourceULDStatus;
    data['SourceULDConditionCode'] = this.sourceULDConditionCode;
    data['SourceFlightSeqNo'] = this.sourceFlightSeqNo;
    data['SourceFlightNo'] = this.sourceFlightNo;
    data['SourceFlightDate'] = this.sourceFlightDate;
    data['SourceDestination'] = this.sourceDestination;
    return data;
  }
}

class SourceULDAWBDetailList {
  String? aWBNo;
  int? nOP;
  double? weightKg;
  String? sHCCode;
  int? expShipRowId;

  SourceULDAWBDetailList(
      {this.aWBNo, this.nOP, this.weightKg, this.sHCCode, this.expShipRowId});

  SourceULDAWBDetailList.fromJson(Map<String, dynamic> json) {
    aWBNo = json['AWBNo'];
    nOP = json['NOP'];
    weightKg = json['WeightKg'];
    sHCCode = json['SHCCode'];
    expShipRowId = json['ExpShipRowId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['AWBNo'] = this.aWBNo;
    data['NOP'] = this.nOP;
    data['WeightKg'] = this.weightKg;
    data['SHCCode'] = this.sHCCode;
    data['ExpShipRowId'] = this.expShipRowId;
    return data;
  }
}
