class BinningDetailListModel {
  List<BinningDetailList>? binningDetailList;
  BinningSummary? binningSummary;
  String? status;
  String? statusMessage;

  BinningDetailListModel(
      {this.binningDetailList,
        this.binningSummary,
        this.status,
        this.statusMessage});

  BinningDetailListModel.fromJson(Map<String, dynamic> json) {
    if (json['BinningDetailList'] != null) {
      binningDetailList = <BinningDetailList>[];
      json['BinningDetailList'].forEach((v) {
        binningDetailList!.add(new BinningDetailList.fromJson(v));
      });
    }
    binningSummary = json['BinningSummary'] != null
        ? new BinningSummary.fromJson(json['BinningSummary'])
        : null;
    status = json['Status'];
    statusMessage = json['StatusMessage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.binningDetailList != null) {
      data['BinningDetailList'] =
          this.binningDetailList!.map((v) => v.toJson()).toList();
    }
    if (this.binningSummary != null) {
      data['BinningSummary'] = this.binningSummary!.toJson();
    }
    data['Status'] = this.status;
    data['StatusMessage'] = this.statusMessage;
    return data;
  }
}

class BinningDetailList {
  int? flightSeqNo;
  String? iGMNo;
  String? flightNo;
  String? flightDate;
  String? aWBNo;
  String? hAWBNo;
  int? nOP;
  double? weight;
  double? volume;
  String? nOG;
  String? sHCCode;
  String? commodity;
  String? remark;
  String? locationCode;
  int? locationId;

  BinningDetailList(
      {
        this.flightSeqNo,
        this.iGMNo,
        this.flightNo,
        this.flightDate,
        this.aWBNo,
        this.hAWBNo,
        this.nOP,
        this.weight,
        this.volume,
        this.nOG,
        this.sHCCode,
        this.commodity,
        this.remark,
        this.locationCode,
        this.locationId});

  BinningDetailList.fromJson(Map<String, dynamic> json) {
    flightSeqNo = json['FlightSeqNo'];
    iGMNo = json['IGMNo'];
    flightNo = json['FlightNo'];
    flightDate = json['FlightDate'];
    aWBNo = json['AWBNo'];
    hAWBNo = json['HAWBNo'];
    nOP = json['NOP'];
    weight = json['Weight'];
    volume = json['Volume'];
    nOG = json['NOG'];
    sHCCode = json['SHCCode'];
    commodity = json['Commodity'];
    remark = json['Remark'];
    locationCode = json['LocationCode'];
    locationId = json['LocationId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['FlightSeqNo'] = this.flightSeqNo;
    data['IGMNo'] = this.iGMNo;
    data['FlightNo'] = this.flightNo;
    data['FlightDate'] = this.flightDate;
    data['AWBNo'] = this.aWBNo;
    data['HAWBNo'] = this.hAWBNo;
    data['NOP'] = this.nOP;
    data['Weight'] = this.weight;
    data['Volume'] = this.volume;
    data['NOG'] = this.nOG;
    data['SHCCode'] = this.sHCCode;
    data['Commodity'] = this.commodity;
    data['Remark'] = this.remark;
    data['LocationCode'] = this.locationCode;
    data['LocationId'] = this.locationId;
    return data;
  }
}

class BinningSummary {
  String? currentLocationCode;
  int? currentLocationId;
  String? suggestion;

  BinningSummary(
      {this.currentLocationCode, this.currentLocationId, this.suggestion});

  BinningSummary.fromJson(Map<String, dynamic> json) {
    currentLocationCode = json['CurrentLocationCode'];
    currentLocationId = json['CurrentLocationId'];
    suggestion = json['Suggestion'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['CurrentLocationCode'] = this.currentLocationCode;
    data['CurrentLocationId'] = this.currentLocationId;
    data['Suggestion'] = this.suggestion;
    return data;
  }
}
