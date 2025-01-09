class FlightSearchModel {
  FlightDetail? flightDetail;
  FlightStatusDetail? flightStatusDetail;
  List<FlightAirRouteList>? flightAirRouteList;
  String? status;
  String? statusMessage;

  FlightSearchModel(
      {this.flightDetail,
        this.flightStatusDetail,
        this.flightAirRouteList,
        this.status,
        this.statusMessage});

  FlightSearchModel.fromJson(Map<String, dynamic> json) {
    flightDetail = json['FlightDetail'] != null
        ? new FlightDetail.fromJson(json['FlightDetail'])
        : null;
    flightStatusDetail = json['FlightStatusDetail'] != null
        ? new FlightStatusDetail.fromJson(json['FlightStatusDetail'])
        : null;
    if (json['FlightAirRouteList'] != null) {
      flightAirRouteList = <FlightAirRouteList>[];
      json['FlightAirRouteList'].forEach((v) {
        flightAirRouteList!.add(new FlightAirRouteList.fromJson(v));
      });
    }
    status = json['Status'];
    statusMessage = json['StatusMessage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.flightDetail != null) {
      data['FlightDetail'] = this.flightDetail!.toJson();
    }
    if (this.flightStatusDetail != null) {
      data['FlightStatusDetail'] = this.flightStatusDetail!.toJson();
    }
    if (this.flightAirRouteList != null) {
      data['FlightAirRouteList'] =
          this.flightAirRouteList!.map((v) => v.toJson()).toList();
    }
    data['Status'] = this.status;
    data['StatusMessage'] = this.statusMessage;
    return data;
  }
}

class FlightDetail {
  int? flightSeqNo;
  String? flightNo;
  String? flightDate;
  String? eTD;
  int? remainingTime;
  String? flightStatus;
  String? routePoint;

  FlightDetail(
      {this.flightSeqNo,
        this.flightNo,
        this.flightDate,
        this.eTD,
        this.remainingTime,
        this.flightStatus,
        this.routePoint});

  FlightDetail.fromJson(Map<String, dynamic> json) {
    flightSeqNo = json['FlightSeqNo'];
    flightNo = json['FlightNo'];
    flightDate = json['FlightDate'];
    eTD = json['ETD'];
    remainingTime = json['RemainingTime'];
    flightStatus = json['FlightStatus'];
    routePoint = json['RoutePoint'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['FlightSeqNo'] = this.flightSeqNo;
    data['FlightNo'] = this.flightNo;
    data['FlightDate'] = this.flightDate;
    data['ETD'] = this.eTD;
    data['RemainingTime'] = this.remainingTime;
    data['FlightStatus'] = this.flightStatus;
    data['RoutePoint'] = this.routePoint;
    return data;
  }
}

class FlightStatusDetail {
  double? lAvsMAN;
  String? uWSStatus;
  String? nOTOCStatus;
  String? manifestStatus;
  int? uLDCount;
  int? trolleyCount;
  int? cargoPieces;
  double? cargoWeight;
  int? mailPieces;
  double? mailWeight;
  int? courierPieces;
  double? courierWeight;

  FlightStatusDetail(
      {this.lAvsMAN,
        this.uWSStatus,
        this.nOTOCStatus,
        this.manifestStatus,
        this.uLDCount,
        this.trolleyCount,
        this.cargoPieces,
        this.cargoWeight,
        this.mailPieces,
        this.mailWeight,
        this.courierPieces,
        this.courierWeight});

  FlightStatusDetail.fromJson(Map<String, dynamic> json) {
    lAvsMAN = json['LAvsMAN'];
    uWSStatus = json['UWSStatus'];
    nOTOCStatus = json['NOTOCStatus'];
    manifestStatus = json['ManifestStatus'];
    uLDCount = json['ULDCount'];
    trolleyCount = json['TrolleyCount'];
    cargoPieces = json['CargoPieces'];
    cargoWeight = json['CargoWeight'];
    mailPieces = json['MailPieces'];
    mailWeight = json['MailWeight'];
    courierPieces = json['CourierPieces'];
    courierWeight = json['CourierWeight'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['LAvsMAN'] = this.lAvsMAN;
    data['UWSStatus'] = this.uWSStatus;
    data['NOTOCStatus'] = this.nOTOCStatus;
    data['ManifestStatus'] = this.manifestStatus;
    data['ULDCount'] = this.uLDCount;
    data['TrolleyCount'] = this.trolleyCount;
    data['CargoPieces'] = this.cargoPieces;
    data['CargoWeight'] = this.cargoWeight;
    data['MailPieces'] = this.mailPieces;
    data['MailWeight'] = this.mailWeight;
    data['CourierPieces'] = this.courierPieces;
    data['CourierWeight'] = this.courierWeight;
    return data;
  }
}

class FlightAirRouteList {
  String? airportCity;
  int? displayNo;

  FlightAirRouteList({this.airportCity, this.displayNo});

  FlightAirRouteList.fromJson(Map<String, dynamic> json) {
    airportCity = json['AirportCity'];
    displayNo = json['DisplayNo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['AirportCity'] = this.airportCity;
    data['DisplayNo'] = this.displayNo;
    return data;
  }
}
