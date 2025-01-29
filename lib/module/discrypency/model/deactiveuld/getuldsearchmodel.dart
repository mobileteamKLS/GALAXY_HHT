class GetULDSearchModel {
  List<ULDDetailsList>? uLDDetailsList;
  String? status;
  String? statusMessage;

  GetULDSearchModel(
      {this.uLDDetailsList, this.status, this.statusMessage});

  GetULDSearchModel.fromJson(Map<String, dynamic> json) {
    if (json['ULDDetailsList'] != null) {
      uLDDetailsList = <ULDDetailsList>[];
      json['ULDDetailsList'].forEach((v) {
        uLDDetailsList!.add(new ULDDetailsList.fromJson(v));
      });
    }
    status = json['Status'];
    statusMessage = json['StatusMessage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.uLDDetailsList != null) {
      data['ULDDetailsList'] =
          this.uLDDetailsList!.map((v) => v.toJson()).toList();
    }
    data['Status'] = this.status;
    data['StatusMessage'] = this.statusMessage;
    return data;
  }
}

class ULDDetailsList {
  int? uLDSeqNo;
  int? flightSeqNo;
  String? flightType;
  String? uLDNo;
  String? flightNo;
  String? flightDate;
  String? status;
  String? intact;
  String? destination;
  String? currentLocation;
  double? scaleWeight;

  ULDDetailsList(
      {this.uLDSeqNo,
        this.flightSeqNo,
        this.flightType,
        this.uLDNo,
        this.flightNo,
        this.flightDate,
        this.status,
        this.intact,
        this.destination,
        this.currentLocation,
        this.scaleWeight});

  ULDDetailsList.fromJson(Map<String, dynamic> json) {
    uLDSeqNo = json['ULDSeqNo'];
    flightSeqNo = json['FlightSeqNo'];
    flightType = json['FlightType'];
    uLDNo = json['ULDNo'];
    flightNo = json['FlightNo'];
    flightDate = json['FlightDate'];
    status = json['Status'];
    intact = json['Intact'];
    destination = json['Destination'];
    currentLocation = json['CurrentLocation'];
    scaleWeight = json['ScaleWeight'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ULDSeqNo'] = this.uLDSeqNo;
    data['FlightSeqNo'] = this.flightSeqNo;
    data['FlightType'] = this.flightType;
    data['ULDNo'] = this.uLDNo;
    data['FlightNo'] = this.flightNo;
    data['FlightDate'] = this.flightDate;
    data['Status'] = this.status;
    data['Intact'] = this.intact;
    data['Destination'] = this.destination;
    data['CurrentLocation'] = this.currentLocation;
    data['ScaleWeight'] = this.scaleWeight;
    return data;
  }
}
