class GetTrolleyDocumentListModel {
  List<TrolleyDetails>? trolleyDetails;
  List<AirWaybillDetail>? airWaybillDetail;
  List<MailDetail>? mailDetail;
  List<CourierDetail>? courierDetail;
  String? status;
  String? statusMessage;

  GetTrolleyDocumentListModel(
      {this.trolleyDetails,
        this.airWaybillDetail,
        this.mailDetail,
        this.courierDetail,
        this.status,
        this.statusMessage});

  GetTrolleyDocumentListModel.fromJson(Map<String, dynamic> json) {
    if (json['TrolleyDetails'] != null) {
      trolleyDetails = <TrolleyDetails>[];
      json['TrolleyDetails'].forEach((v) {
        trolleyDetails!.add(new TrolleyDetails.fromJson(v));
      });
    }
    if (json['AirWaybillDetails'] != null) {
      airWaybillDetail = <AirWaybillDetail>[];
      json['AirWaybillDetails'].forEach((v) {
        airWaybillDetail!.add(new AirWaybillDetail.fromJson(v));
      });
    }
    if (json['MailDetails'] != null) {
      mailDetail = <MailDetail>[];
      json['MailDetails'].forEach((v) {
        mailDetail!.add(new MailDetail.fromJson(v));
      });
    }
    if (json['CourierDetails'] != null) {
      courierDetail = <CourierDetail>[];
      json['CourierDetails'].forEach((v) {
        courierDetail!.add(new CourierDetail.fromJson(v));
      });
    }
    status = json['Status'];
    statusMessage = json['StatusMessage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.trolleyDetails != null) {
      data['TrolleyDetails'] = this.trolleyDetails!.map((v) => v.toJson()).toList();
    }
    if (this.airWaybillDetail != null) {
      data['AirWaybillDetails'] =
          this.airWaybillDetail!.map((v) => v.toJson()).toList();
    }
    if (this.mailDetail != null) {
      data['MailDetails'] = this.mailDetail!.map((v) => v.toJson()).toList();
    }
    if (this.courierDetail != null) {
      data['CourierDetails'] =
          this.courierDetail!.map((v) => v.toJson()).toList();
    }
    data['Status'] = this.status;
    data['StatusMessage'] = this.statusMessage;
    return data;
  }
}

class TrolleyDetails {
  double? trolleyTareWeight;
  String? trolleyType;
  String? trolleyNo;
  int? flightSeqNo;

  TrolleyDetails({this.trolleyTareWeight, this.trolleyType, this.trolleyNo, this.flightSeqNo});

  TrolleyDetails.fromJson(Map<String, dynamic> json) {
    trolleyTareWeight = json['TrolleyTareWeight'];
    trolleyType = json['TrolleyType'];
    trolleyNo = json['TrolleyNo'];
    flightSeqNo = json['FlightSeqNo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['TrolleyTareWeight'] = this.trolleyTareWeight;
    data['TrolleyType'] = this.trolleyType;
    data['TrolleyNo'] = this.trolleyNo;
    data['FlightSeqNo'] = this.flightSeqNo;
    return data;
  }
}

class AirWaybillDetail {
  String? aWBNo;
  double? weight;
  double? volume;
  String? type;

  AirWaybillDetail({this.aWBNo, this.weight, this.volume, this.type});

  AirWaybillDetail.fromJson(Map<String, dynamic> json) {
    aWBNo = json['AWBNo'];
    weight = json['Weight'];
    volume = json['Volume'];
    type = json['Type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['AWBNo'] = this.aWBNo;
    data['Weight'] = this.weight;
    data['Volume'] = this.volume;
    data['Type'] = this.type;
    return data;
  }
}

class MailDetail {
  String? docNo;
  double? weight;
  double? volume;
  String? type;

  MailDetail({this.docNo, this.weight, this.volume, this.type});

  MailDetail.fromJson(Map<String, dynamic> json) {
    docNo = json['DocNo'];
    weight = json['Weight'];
    volume = json['Volume'];
    type = json['Type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['DocNo'] = this.docNo;
    data['Weight'] = this.weight;
    data['Volume'] = this.volume;
    data['Type'] = this.type;
    return data;
  }
}

class CourierDetail {
  String? docNo;
  double? weight;
  double? volume;
  String? type;

  CourierDetail({this.docNo, this.weight, this.volume, this.type});

  CourierDetail.fromJson(Map<String, dynamic> json) {
    docNo = json['DocNo'];
    weight = json['Weight'];
    volume = json['Volume'];
    type = json['Type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['DocNo'] = this.docNo;
    data['Weight'] = this.weight;
    data['Volume'] = this.volume;
    data['Type'] = this.type;
    return data;
  }
}
