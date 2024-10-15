class DefaultUldAcceptanceModel {
  String? uLDGroupIdIsMandatory;
  String? uLDTrollyAcceptance;
  String? status;
  String? statusMessage;

  DefaultUldAcceptanceModel(
      {this.uLDGroupIdIsMandatory, this.status, this.statusMessage});

  DefaultUldAcceptanceModel.fromJson(Map<String, dynamic> json) {
    uLDGroupIdIsMandatory = json['ULDGroupIdIsMandatory'];
    uLDTrollyAcceptance = json['ULDTrollyAcceptance'];
    status = json['Status'];
    statusMessage = json['StatusMessage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ULDGroupIdIsMandatory'] = this.uLDGroupIdIsMandatory;
    data['ULDTrollyAcceptance'] = this.uLDTrollyAcceptance;
    data['Status'] = this.status;
    data['StatusMessage'] = this.statusMessage;
    return data;
  }
}
