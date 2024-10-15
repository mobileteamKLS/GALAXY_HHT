class FlightCheckSummaryModel {
  FlightSummary? flightSummary;
  String? status;
  String? statusMessage;

  FlightCheckSummaryModel(
      {this.flightSummary, this.status, this.statusMessage});

  FlightCheckSummaryModel.fromJson(Map<String, dynamic> json) {
    flightSummary = json['FlightSummary'] != null
        ? new FlightSummary.fromJson(json['FlightSummary'])
        : null;
    status = json['Status'];
    statusMessage = json['StatusMessage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.flightSummary != null) {
      data['FlightSummary'] = this.flightSummary!.toJson();
    }
    data['Status'] = this.status;
    data['StatusMessage'] = this.statusMessage;
    return data;
  }
}

class FlightSummary {
  int? aWBCount;
  int? nPX;
  int? nPR;
  double? weightExp;
  double? weightRec;
  int? shortLanded;
  int? excessLanded;
  int? damagePkgs;
  int? progress;

  FlightSummary(
      {this.aWBCount,
        this.nPX,
        this.nPR,
        this.weightExp,
        this.weightRec,
        this.shortLanded,
        this.excessLanded,
        this.damagePkgs,
        this.progress});

  FlightSummary.fromJson(Map<String, dynamic> json) {
    aWBCount = json['AWBCount'];
    nPX = json['NPX'];
    nPR = json['NPR'];
    weightExp = json['WeightExp'];
    weightRec = json['WeightRec'];
    shortLanded = json['ShortLanded'];
    excessLanded = json['ExcessLanded'];
    damagePkgs = json['DamagePkgs'];
    progress = json['Progress'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['AWBCount'] = this.aWBCount;
    data['NPX'] = this.nPX;
    data['NPR'] = this.nPR;
    data['WeightExp'] = this.weightExp;
    data['WeightRec'] = this.weightRec;
    data['ShortLanded'] = this.shortLanded;
    data['ExcessLanded'] = this.excessLanded;
    data['DamagePkgs'] = this.damagePkgs;
    data['Progress'] = this.progress;
    return data;
  }
}
