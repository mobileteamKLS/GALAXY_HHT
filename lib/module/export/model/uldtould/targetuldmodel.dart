class TargetULDModel {
  TargetULDDetail? targetULDDetail;
  String? status;
  String? statusMessage;

  TargetULDModel({this.targetULDDetail, this.status, this.statusMessage});

  TargetULDModel.fromJson(Map<String, dynamic> json) {
    targetULDDetail = json['TargetULDDetail'] != null
        ? new TargetULDDetail.fromJson(json['TargetULDDetail'])
        : null;
    status = json['Status'];
    statusMessage = json['StatusMessage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.targetULDDetail != null) {
      data['TargetULDDetail'] = this.targetULDDetail!.toJson();
    }
    data['Status'] = this.status;
    data['StatusMessage'] = this.statusMessage;
    return data;
  }
}

class TargetULDDetail {
  int? targetULDSeqNo;
  String? targetULDType;
  String? targetULDStatus;
  String? targetULDConditionCode;
  int? targetFlightSeqNo;

  TargetULDDetail(
      {this.targetULDSeqNo,
        this.targetULDType,
        this.targetULDStatus,
        this.targetULDConditionCode,
        this.targetFlightSeqNo});

  TargetULDDetail.fromJson(Map<String, dynamic> json) {
    targetULDSeqNo = json['TargetULDSeqNo'];
    targetULDType = json['TargetULDType'];
    targetULDStatus = json['TargetULDStatus'];
    targetULDConditionCode = json['TargetULDConditionCode'];
    targetFlightSeqNo = json['TargetFlightSeqNo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['TargetULDSeqNo'] = this.targetULDSeqNo;
    data['TargetULDType'] = this.targetULDType;
    data['TargetULDStatus'] = this.targetULDStatus;
    data['TargetULDConditionCode'] = this.targetULDConditionCode;
    data['TargetFlightSeqNo'] = this.targetFlightSeqNo;
    return data;
  }
}
