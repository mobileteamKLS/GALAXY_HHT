class CreateULDTrolleyModel {
  String? status;
  String? statusMessage;
  int? ULDSeqNo;

  CreateULDTrolleyModel(
      {
        this.status,
        this.statusMessage,
        this.ULDSeqNo});

  CreateULDTrolleyModel.fromJson(Map<String, dynamic> json) {
    status = json['Status'];
    statusMessage = json['StatusMessage'];
    ULDSeqNo = json['ULDSeqNo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Status'] = this.status;
    data['StatusMessage'] = this.statusMessage;
    data['ULDSeqNo'] = this.ULDSeqNo;
    return data;
  }
}
