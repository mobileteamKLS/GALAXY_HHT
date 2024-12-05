class AirsideShipmentListModel {
  List<AirsideReleaseAWBDetailList>? airsideReleaseAWBDetailList;
  String? status;
  String? statusMessage;

  AirsideShipmentListModel(
      {this.airsideReleaseAWBDetailList, this.status, this.statusMessage});

  AirsideShipmentListModel.fromJson(Map<String, dynamic> json) {
    if (json['AirsideReleaseAWBDetailList'] != null) {
      airsideReleaseAWBDetailList = <AirsideReleaseAWBDetailList>[];
      json['AirsideReleaseAWBDetailList'].forEach((v) {
        airsideReleaseAWBDetailList!
            .add(new AirsideReleaseAWBDetailList.fromJson(v));
      });
    }
    status = json['Status'];
    statusMessage = json['StatusMessage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.airsideReleaseAWBDetailList != null) {
      data['AirsideReleaseAWBDetailList'] =
          this.airsideReleaseAWBDetailList!.map((v) => v.toJson()).toList();
    }
    data['Status'] = this.status;
    data['StatusMessage'] = this.statusMessage;
    return data;
  }
}

class AirsideReleaseAWBDetailList {
  String? aWBNo;
  int? nOP;
  double? weightKg;
  String? nOG;
  String? commodity;
  String? temp;
  String? tempUnit;
  String? shockWatch;
  String? screeningStatus;
  String? screeningMachine;
  int? priority;
  String? sHCCode;

  AirsideReleaseAWBDetailList(
      {this.aWBNo,
        this.nOP,
        this.weightKg,
        this.nOG,
        this.commodity,
        this.temp,
        this.tempUnit,
        this.shockWatch,
        this.screeningStatus,
        this.screeningMachine,
        this.priority,
        this.sHCCode});

  AirsideReleaseAWBDetailList.fromJson(Map<String, dynamic> json) {
    aWBNo = json['AWBNo'];
    nOP = json['NOP'];
    weightKg = json['WeightKg'];
    nOG = json['NOG'];
    commodity = json['Commodity'];
    temp = json['Temp'];
    tempUnit = json['TempUnit'];
    shockWatch = json['ShockWatch'];
    screeningStatus = json['ScreeningStatus'];
    screeningMachine = json['ScreeningMachine'];
    priority = json['Priority'];
    sHCCode = json['SHCCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['AWBNo'] = this.aWBNo;
    data['NOP'] = this.nOP;
    data['WeightKg'] = this.weightKg;
    data['NOG'] = this.nOG;
    data['Commodity'] = this.commodity;
    data['Temp'] = this.temp;
    data['TempUnit'] = this.tempUnit;
    data['ShockWatch'] = this.shockWatch;
    data['ScreeningStatus'] = this.screeningStatus;
    data['ScreeningMachine'] = this.screeningMachine;
    data['Priority'] = this.priority;
    data['SHCCode'] = this.sHCCode;
    return data;
  }
}
