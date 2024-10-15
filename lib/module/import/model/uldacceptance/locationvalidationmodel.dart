class LocationValidationModel {
  String? messageCode;
  String? status;
  String? statusMessage;

  LocationValidationModel({this.messageCode, this.status, this.statusMessage});

  LocationValidationModel.fromJson(Map<String, dynamic> json) {
    messageCode = json['MessageCode'];
    status = json['Status'];
    statusMessage = json['StatusMessage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['MessageCode'] = this.messageCode;
    data['Status'] = this.status;
    data['StatusMessage'] = this.statusMessage;
    return data;
  }
}
