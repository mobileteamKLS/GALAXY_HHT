class SplitGroupDefaultPageLoadModel {
  String? status;
  String? statusMessage;
  String? IsGroupBasedAcceptChar;
  int? IsGroupBasedAcceptNumber;

  SplitGroupDefaultPageLoadModel(
      {this.status, this.statusMessage, this.IsGroupBasedAcceptChar, this.IsGroupBasedAcceptNumber});

  SplitGroupDefaultPageLoadModel.fromJson(Map<String, dynamic> json) {
    status = json['Status'];
    statusMessage = json['StatusMessage'];
    IsGroupBasedAcceptChar = json['IsGroupBasedAcceptChar'];
    IsGroupBasedAcceptNumber = json['IsGroupBasedAcceptNumber'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Status'] = this.status;
    data['StatusMessage'] = this.statusMessage;
    data['IsGroupBasedAcceptChar'] = this.IsGroupBasedAcceptChar;
    data['IsGroupBasedAcceptNumber'] = this.IsGroupBasedAcceptNumber;
    return data;
  }
}

