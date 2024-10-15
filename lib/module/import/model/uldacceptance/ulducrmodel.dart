class UldUCRModel {
  String? status;
  String? statusMessage;
  int? uldSeqNo;

  UldUCRModel({this.status, this.statusMessage, this.uldSeqNo});

  UldUCRModel.fromJson(Map<String, dynamic> json) {
    status = json['Status'];
    statusMessage = json['StatusMessage'];
    uldSeqNo = json['ULDSeqNo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Status'] = this.status;
    data['StatusMessage'] = this.statusMessage;
    data['ULDSeqNo'] = this.uldSeqNo;
    return data;
  }
}
