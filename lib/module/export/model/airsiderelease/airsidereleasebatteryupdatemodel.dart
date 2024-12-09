class AirsideReleaseBatteryUpdateModel {
  String? status;
  String? statusMessage;

  AirsideReleaseBatteryUpdateModel(
      {this.status, this.statusMessage});

  AirsideReleaseBatteryUpdateModel.fromJson(Map<String, dynamic> json) {
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
