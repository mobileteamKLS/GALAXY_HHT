class PageLoadDefaultModel {
  String? IsAWBRemarksAcknowledge;
  String? IsGroupBasedAcceptChar;
  int? IsGroupBasedAcceptNumber;
  String? status;
  String? statusMessage;

  PageLoadDefaultModel({this.IsAWBRemarksAcknowledge, this.IsGroupBasedAcceptChar, this.IsGroupBasedAcceptNumber, this.status, this.statusMessage});

  PageLoadDefaultModel.fromJson(Map<String, dynamic> json) {
    IsAWBRemarksAcknowledge = json['IsAWBRemarksAcknowledge'];
    IsGroupBasedAcceptChar = json['IsGroupBasedAcceptChar'];
    IsGroupBasedAcceptNumber = json['IsGroupBasedAcceptNumber'];
    status = json['Status'];
    statusMessage = json['StatusMessage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['IsAWBRemarksAcknowledge'] = this.IsAWBRemarksAcknowledge;
    data['IsGroupBasedAcceptChar'] = this.IsGroupBasedAcceptChar;
    data['IsGroupBasedAcceptNumber'] = this.IsGroupBasedAcceptNumber;
    data['Status'] = this.status;
    data['StatusMessage'] = this.statusMessage;
    return data;
  }
}
