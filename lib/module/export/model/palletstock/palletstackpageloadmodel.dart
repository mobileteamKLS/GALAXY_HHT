class PalletStackPageLoadModel {
  List<PalletStackDetail>? palletStackDetail;
  String? status;
  String? statusMessage;

  PalletStackPageLoadModel(
      {this.palletStackDetail, this.status, this.statusMessage});

  PalletStackPageLoadModel.fromJson(Map<String, dynamic> json) {
    if (json['PalletStackDetailList'] != null) {
      palletStackDetail = <PalletStackDetail>[];
      json['PalletStackDetailList'].forEach((v) {
        palletStackDetail!.add(new PalletStackDetail.fromJson(v));
      });
    }
    status = json['Status'];
    statusMessage = json['StatusMessage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.palletStackDetail != null) {
      data['PalletStackDetailList'] =
          this.palletStackDetail!.map((v) => v.toJson()).toList();
    }
    data['Status'] = this.status;
    data['StatusMessage'] = this.statusMessage;
    return data;
  }
}

class PalletStackDetail {
  String? uLDNo;
  int? palletSize;
  String? uLDStatus;
  String? flightAirline;
  String? flightNo;
  String? flightDate;
  String? isFlightAssigned;
  String? isFlightDeparted;
  String? uLDLocation;
  String? uLDDestination;
  double? scaleWeight;
  int? uLDSeqNo;
  int? flightSeqNo;
  String? uldConditionCode;

  PalletStackDetail(
      {this.uLDNo,
        this.palletSize,
        this.uLDStatus,
        this.flightAirline,
        this.flightNo,
        this.flightDate,
        this.isFlightAssigned,
        this.isFlightDeparted,
        this.uLDLocation,
        this.uLDDestination,
        this.scaleWeight,
        this.uLDSeqNo,
        this.flightSeqNo,
        this.uldConditionCode});

  PalletStackDetail.fromJson(Map<String, dynamic> json) {
    uLDNo = json['ULDNo'];
    palletSize = json['PalletSize'];
    uLDStatus = json['ULDStatus'];
    flightAirline = json['FlightAirline'];
    flightNo = json['FlightNo'];
    flightDate = json['FlightDate'];
    isFlightAssigned = json['IsFlightAssigned'];
    isFlightDeparted = json['IsFlightDeparted'];
    uLDLocation = json['ULDLocation'];
    uLDDestination = json['ULDDestination'];
    scaleWeight = json['ScaleWeight'];
    uLDSeqNo = json['ULDSeqNo'];
    flightSeqNo = json['FlightSeqNo'];
    uldConditionCode = json['ULDConditionCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ULDNo'] = this.uLDNo;
    data['PalletSize'] = this.palletSize;
    data['ULDStatus'] = this.uLDStatus;
    data['FlightAirline'] = this.flightAirline;
    data['FlightNo'] = this.flightNo;
    data['FlightDate'] = this.flightDate;
    data['IsFlightAssigned'] = this.isFlightAssigned;
    data['IsFlightDeparted'] = this.isFlightDeparted;
    data['ULDLocation'] = this.uLDLocation;
    data['ULDDestination'] = this.uLDDestination;
    data['ScaleWeight'] = this.scaleWeight;
    data['ULDSeqNo'] = this.uLDSeqNo;
    data['FlightSeqNo'] = this.flightSeqNo;
    data['ULDConditionCode'] = this.uldConditionCode;
    return data;
  }
}
