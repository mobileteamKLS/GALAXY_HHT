class AirsideSignUploadModel {
  String? status;
  String? statusMessage;

  AirsideSignUploadModel(
      {this.status, this.statusMessage});

  AirsideSignUploadModel.fromJson(Map<String, dynamic> json) {
    status = json['Status'];
    statusMessage = json['StatusMessage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Status'] = this.status;
    data['StatusMessage'] = this.statusMessage;
    return data;
  }
}
