class AirSideReleaseSearchModel {
  List<AirsideReleaseDetailList>? airsideReleaseDetailList;
  AirsideReleaseFlightDetail? airsideReleaseFlightDetail;
  String? status;
  String? statusMessage;

  AirSideReleaseSearchModel(
      {this.airsideReleaseDetailList,
        this.airsideReleaseFlightDetail,
        this.status,
        this.statusMessage});

  AirSideReleaseSearchModel.fromJson(Map<String, dynamic> json) {
    if (json['AirsideReleaseDetailList'] != null) {
      airsideReleaseDetailList = <AirsideReleaseDetailList>[];
      json['AirsideReleaseDetailList'].forEach((v) {
        airsideReleaseDetailList!.add(new AirsideReleaseDetailList.fromJson(v));
      });
    }
    airsideReleaseFlightDetail = json['AirsideReleaseFlightDetail'] != null
        ? new AirsideReleaseFlightDetail.fromJson(
        json['AirsideReleaseFlightDetail'])
        : null;
    status = json['Status'];
    statusMessage = json['StatusMessage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.airsideReleaseDetailList != null) {
      data['AirsideReleaseDetailList'] =
          this.airsideReleaseDetailList!.map((v) => v.toJson()).toList();
    }
    if (this.airsideReleaseFlightDetail != null) {
      data['AirsideReleaseFlightDetail'] =
          this.airsideReleaseFlightDetail!.toJson();
    }
    data['Status'] = this.status;
    data['StatusMessage'] = this.statusMessage;
    return data;
  }
}

class AirsideReleaseDetailList {
  int? uLDSeqNo;
  String? uLDNo;
  String? uLDType;
  String? rTemp;
  String? rTempUnit;
  double? scaleWeight;
  String? status;
  String? isReleased;
  String? releaseDate;
  String? zoneWiseTemp;
  String? location;
  String? tempDateTime;
  int? defaultTemp;
  int? shipmentCount;
  int? battery;
  int? priority;
  String? sHCCode;
  String? gpNo;

  AirsideReleaseDetailList(
      {this.uLDSeqNo,
        this.uLDNo,
        this.uLDType,
        this.rTemp,
        this.rTempUnit,
        this.scaleWeight,
        this.status,
        this.isReleased,
        this.releaseDate,
        this.zoneWiseTemp,
        this.location,
        this.tempDateTime,
        this.defaultTemp,
        this.shipmentCount,
        this.battery,
        this.priority,
        this.sHCCode,
        this.gpNo});

  AirsideReleaseDetailList.fromJson(Map<String, dynamic> json) {
    uLDSeqNo = json['ULDSeqNo'];
    uLDNo = json['ULDNo'];
    uLDType = json['ULDType'];
    rTemp = json['RTemp'];
    rTempUnit = json['RTempUnit'];
    scaleWeight = json['ScaleWeight'];
    status = json['Status'];
    isReleased = json['IsReleased'];
    releaseDate = json['ReleaseDate'];
    zoneWiseTemp = json['ZoneWiseTemp'];
    location = json['Location'];
    tempDateTime = json['TempDateTime'];
    defaultTemp = json['DefaultTemp'];
    shipmentCount = json['ShipmentCount'];
    battery = json['Battery'];
    priority = json['Priority'];
    sHCCode = json['SHCCode'];
    gpNo = json['GPNo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ULDSeqNo'] = this.uLDSeqNo;
    data['ULDNo'] = this.uLDNo;
    data['ULDType'] = this.uLDType;
    data['RTemp'] = this.rTemp;
    data['RTempUnit'] = this.rTempUnit;
    data['ScaleWeight'] = this.scaleWeight;
    data['Status'] = this.status;
    data['IsReleased'] = this.isReleased;
    data['ReleaseDate'] = this.releaseDate;
    data['ZoneWiseTemp'] = this.zoneWiseTemp;
    data['Location'] = this.location;
    data['TempDateTime'] = this.tempDateTime;
    data['DefaultTemp'] = this.defaultTemp;
    data['ShipmentCount'] = this.shipmentCount;
    data['Battery'] = this.battery;
    data['Priority'] = this.priority;
    data['SHCCode'] = this.sHCCode;
    data['GPNo'] = this.gpNo;
    return data;
  }
}

class AirsideReleaseFlightDetail {
  int? flightSeqNo;
  String? flightNo;
  String? flightDate;
  int? containerCount;
  int? palletCount;
  int? bulkCount;

  AirsideReleaseFlightDetail(
      {this.flightSeqNo,
        this.flightNo,
        this.flightDate,
        this.containerCount,
        this.palletCount,
        this.bulkCount});

  AirsideReleaseFlightDetail.fromJson(Map<String, dynamic> json) {
    flightSeqNo = json['FlightSeqNo'];
    flightNo = json['FlightNo'];
    flightDate = json['FlightDate'];
    containerCount = json['ContainerCount'];
    palletCount = json['PalletCount'];
    bulkCount = json['BulkCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['FlightSeqNo'] = this.flightSeqNo;
    data['FlightNo'] = this.flightNo;
    data['FlightDate'] = this.flightDate;
    data['ContainerCount'] = this.containerCount;
    data['PalletCount'] = this.palletCount;
    data['BulkCount'] = this.bulkCount;
    return data;
  }
}
