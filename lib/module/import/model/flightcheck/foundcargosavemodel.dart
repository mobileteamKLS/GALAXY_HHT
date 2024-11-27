class FoundCargoSaveModel {
  String? status;
  String? statusMessage;
  int? iMPAWBRowId;
  int? iMShipRowId;

  FoundCargoSaveModel(
      {this.status, this.statusMessage, this.iMPAWBRowId, this.iMShipRowId});

  FoundCargoSaveModel.fromJson(Map<String, dynamic> json) {
    status = json['Status'];
    statusMessage = json['StatusMessage'];
    iMPAWBRowId = json['IMPAWBRowId'];
    iMShipRowId = json['IMPShipRowId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Status'] = this.status;
    data['StatusMessage'] = this.statusMessage;
    data['IMPAWBRowId'] = this.iMPAWBRowId;
    data['IMPShipRowId'] = this.iMShipRowId;
    return data;
  }
}
