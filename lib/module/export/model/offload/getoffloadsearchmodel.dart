class GetSearchOffloadModel {
  List<OffloadAWBDetailsList>? offloadAWBDetailsList;
  List<OffloadULDDetailsList>? offloadULDDetailsList;
  String? status;
  String? statusMessage;

  GetSearchOffloadModel(
      {this.offloadAWBDetailsList,
        this.offloadULDDetailsList,
        this.status,
        this.statusMessage});

  GetSearchOffloadModel.fromJson(Map<String, dynamic> json) {
    if (json['OffloadAWBDetailsList'] != null) {
      offloadAWBDetailsList = <OffloadAWBDetailsList>[];
      json['OffloadAWBDetailsList'].forEach((v) {
        offloadAWBDetailsList!.add(new OffloadAWBDetailsList.fromJson(v));
      });
    }
    if (json['OffloadULDDetailsList'] != null) {
      offloadULDDetailsList = <OffloadULDDetailsList>[];
      json['OffloadULDDetailsList'].forEach((v) {
        offloadULDDetailsList!.add(new OffloadULDDetailsList.fromJson(v));
      });
    }
    status = json['Status'];
    statusMessage = json['StatusMessage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.offloadAWBDetailsList != null) {
      data['OffloadAWBDetailsList'] =
          this.offloadAWBDetailsList!.map((v) => v.toJson()).toList();
    }
    if (this.offloadULDDetailsList != null) {
      data['OffloadULDDetailsList'] =
          this.offloadULDDetailsList!.map((v) => v.toJson()).toList();
    }
    data['Status'] = this.status;
    data['StatusMessage'] = this.statusMessage;
    return data;
  }
}

class OffloadAWBDetailsList {
  String? aWBNo;
  String? uLDTrolleyNo;
  String? uLDTrolleyType;
  String? flightNo;
  String? flightDate;
  String? offPoint;
  String? groupId;
  int? nOP;
  double? weightKg;
  String? sHCCode;
  int? expAWBRowId;
  int? expShipRowId;
  int? eMISeqNo;
  int? uLDTrolleySeqNo;
  int? flightSeqNo;
  int? groupSeqNo;
  int? problemSeqNo;

  OffloadAWBDetailsList(
      {this.aWBNo,
        this.uLDTrolleyNo,
        this.uLDTrolleyType,
        this.flightNo,
        this.flightDate,
        this.offPoint,
        this.groupId,
        this.nOP,
        this.weightKg,
        this.sHCCode,
        this.expAWBRowId,
        this.expShipRowId,
        this.eMISeqNo,
        this.uLDTrolleySeqNo,
        this.flightSeqNo,
        this.groupSeqNo,
        this.problemSeqNo});

  OffloadAWBDetailsList.fromJson(Map<String, dynamic> json) {
    aWBNo = json['AWBNo'];
    uLDTrolleyNo = json['ULDTrolleyNo'];
    uLDTrolleyType = json['ULDTrolleyType'];
    flightNo = json['FlightNo'];
    flightDate = json['FlightDate'];
    offPoint = json['OffPoint'];
    groupId = json['GroupId'];
    nOP = json['NOP'];
    weightKg = json['WeightKg'];
    sHCCode = json['SHCCode'];
    expAWBRowId = json['ExpAWBRowId'];
    expShipRowId = json['ExpShipRowId'];
    eMISeqNo = json['EMISeqNo'];
    uLDTrolleySeqNo = json['ULDTrolleySeqNo'];
    flightSeqNo = json['FlightSeqNo'];
    groupSeqNo = json['GroupSeqNo'];
    problemSeqNo = json['ProblemSeqNo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['AWBNo'] = this.aWBNo;
    data['ULDTrolleyNo'] = this.uLDTrolleyNo;
    data['ULDTrolleyType'] = this.uLDTrolleyType;
    data['FlightNo'] = this.flightNo;
    data['FlightDate'] = this.flightDate;
    data['OffPoint'] = this.offPoint;
    data['GroupId'] = this.groupId;
    data['NOP'] = this.nOP;
    data['WeightKg'] = this.weightKg;
    data['SHCCode'] = this.sHCCode;
    data['ExpAWBRowId'] = this.expAWBRowId;
    data['ExpShipRowId'] = this.expShipRowId;
    data['EMISeqNo'] = this.eMISeqNo;
    data['ULDTrolleySeqNo'] = this.uLDTrolleySeqNo;
    data['FlightSeqNo'] = this.flightSeqNo;
    data['GroupSeqNo'] = this.groupSeqNo;
    data['ProblemSeqNo'] = this.problemSeqNo;
    return data;
  }
}

class OffloadULDDetailsList {
  String? uLDNo;
  String? flightNo;
  String? flightDate;
  String? offPoint;
  String? destination;
  int? uLDSeqNo;
  int? flightSeqNo;

  OffloadULDDetailsList(
      {this.uLDNo,
        this.flightNo,
        this.flightDate,
        this.offPoint,
        this.destination,
        this.uLDSeqNo,
        this.flightSeqNo});

  OffloadULDDetailsList.fromJson(Map<String, dynamic> json) {
    uLDNo = json['ULDNo'];
    flightNo = json['FlightNo'];
    flightDate = json['FlightDate'];
    offPoint = json['OffPoint'];
    destination = json['Destination'];
    uLDSeqNo = json['ULDSeqNo'];
    flightSeqNo = json['FlightSeqNo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ULDNo'] = this.uLDNo;
    data['FlightNo'] = this.flightNo;
    data['FlightDate'] = this.flightDate;
    data['OffPoint'] = this.offPoint;
    data['Destination'] = this.destination;
    data['ULDSeqNo'] = this.uLDSeqNo;
    data['FlightSeqNo'] = this.flightSeqNo;
    return data;
  }
}
