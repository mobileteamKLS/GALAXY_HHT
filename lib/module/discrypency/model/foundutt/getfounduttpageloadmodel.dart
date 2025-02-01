class GetFoundUTTPageLoadModel {
  int? isGroupBasedAcceptNumber;
  String? isGroupBasedAcceptChar;
  String? uLDGroupIdIsMandatory;
  String? status;
  String? statusMessage;

  GetFoundUTTPageLoadModel(
      {this.isGroupBasedAcceptNumber,
        this.isGroupBasedAcceptChar,
        this.uLDGroupIdIsMandatory,
        this.status,
        this.statusMessage});

  GetFoundUTTPageLoadModel.fromJson(Map<String, dynamic> json) {
    isGroupBasedAcceptNumber = json['IsGroupBasedAcceptNumber'];
    isGroupBasedAcceptChar = json['IsGroupBasedAcceptChar'];
    uLDGroupIdIsMandatory = json['ULDGroupIdIsMandatory'];
    status = json['Status'];
    statusMessage = json['StatusMessage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['IsGroupBasedAcceptNumber'] = this.isGroupBasedAcceptNumber;
    data['IsGroupBasedAcceptChar'] = this.isGroupBasedAcceptChar;
    data['ULDGroupIdIsMandatory'] = this.uLDGroupIdIsMandatory;
    data['Status'] = this.status;
    data['StatusMessage'] = this.statusMessage;
    return data;
  }
}
