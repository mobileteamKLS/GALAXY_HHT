class UnloadUldAWBListModel {
  List<UnloadAWBDetail>? unloadAWBDetail;
  String? status;
  String? statusMessage;

  UnloadUldAWBListModel(
      {this.unloadAWBDetail, this.status, this.statusMessage});

  UnloadUldAWBListModel.fromJson(Map<String, dynamic> json) {
    if (json['UnloadAWBDetail'] != null) {
      unloadAWBDetail = <UnloadAWBDetail>[];
      json['UnloadAWBDetail'].forEach((v) {
        unloadAWBDetail!.add(new UnloadAWBDetail.fromJson(v));
      });
    }
    status = json['Status'];
    statusMessage = json['StatusMessage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.unloadAWBDetail != null) {
      data['UnloadAWBDetail'] =
          this.unloadAWBDetail!.map((v) => v.toJson()).toList();
    }
    data['Status'] = this.status;
    data['StatusMessage'] = this.statusMessage;
    return data;
  }
}

class UnloadAWBDetail {
  String? aWBNo;
  int? nOP;
  double? weightKg;
  String? sHCCode;
  int? expShipRowId;

  UnloadAWBDetail(
      {this.aWBNo, this.nOP, this.weightKg, this.sHCCode, this.expShipRowId});

  UnloadAWBDetail.fromJson(Map<String, dynamic> json) {
    aWBNo = json['AWBNo'];
    nOP = json['NOP'];
    weightKg = json['WeightKg'];
    sHCCode = json['SHCCode'];
    expShipRowId = json['ExpShipRowId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['AWBNo'] = this.aWBNo;
    data['NOP'] = this.nOP;
    data['WeightKg'] = this.weightKg;
    data['SHCCode'] = this.sHCCode;
    data['ExpShipRowId'] = this.expShipRowId;
    return data;
  }
}
