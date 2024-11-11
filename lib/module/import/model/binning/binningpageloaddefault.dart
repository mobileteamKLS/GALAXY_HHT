class BinningPageLoadDefaultModel {
  String? IsGroupBasedAcceptChar;
  int? IsGroupBasedAcceptNumber;
  String? status;
  String? statusMessage;

  BinningPageLoadDefaultModel({this.IsGroupBasedAcceptChar, this.IsGroupBasedAcceptNumber, this.status, this.statusMessage});

  BinningPageLoadDefaultModel.fromJson(Map<String, dynamic> json) {
    IsGroupBasedAcceptChar = json['IsGroupBasedAcceptChar'];
    IsGroupBasedAcceptNumber = json['IsGroupBasedAcceptNumber'];
    status = json['Status'];
    statusMessage = json['StatusMessage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['IsGroupBasedAcceptChar'] = this.IsGroupBasedAcceptChar;
    data['IsGroupBasedAcceptNumber'] = this.IsGroupBasedAcceptNumber;
    data['Status'] = this.status;
    data['StatusMessage'] = this.statusMessage;
    return data;
  }
}
