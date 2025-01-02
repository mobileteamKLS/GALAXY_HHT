class GetDocumentListModel {
  List<ULDDetails>? uLDDetails;
  List<AirWaybillDetail>? airWaybillDetail;
  List<MailDetail>? mailDetail;
  List<CourierDetail>? courierDetail;
  String? status;
  String? statusMessage;

  GetDocumentListModel(
      {this.uLDDetails,
        this.airWaybillDetail,
        this.mailDetail,
        this.courierDetail,
        this.status,
        this.statusMessage});

  GetDocumentListModel.fromJson(Map<String, dynamic> json) {
    if (json['ULDDetails'] != null) {
      uLDDetails = <ULDDetails>[];
      json['ULDDetails'].forEach((v) {
        uLDDetails!.add(new ULDDetails.fromJson(v));
      });
    }
    if (json['AirWaybillDetail'] != null) {
      airWaybillDetail = <AirWaybillDetail>[];
      json['AirWaybillDetail'].forEach((v) {
        airWaybillDetail!.add(new AirWaybillDetail.fromJson(v));
      });
    }
    if (json['MailDetail'] != null) {
      mailDetail = <MailDetail>[];
      json['MailDetail'].forEach((v) {
        mailDetail!.add(new MailDetail.fromJson(v));
      });
    }
    if (json['CourierDetail'] != null) {
      courierDetail = <CourierDetail>[];
      json['CourierDetail'].forEach((v) {
        courierDetail!.add(new CourierDetail.fromJson(v));
      });
    }
    status = json['Status'];
    statusMessage = json['StatusMessage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.uLDDetails != null) {
      data['ULDDetails'] = this.uLDDetails!.map((v) => v.toJson()).toList();
    }
    if (this.airWaybillDetail != null) {
      data['AirWaybillDetail'] =
          this.airWaybillDetail!.map((v) => v.toJson()).toList();
    }
    if (this.mailDetail != null) {
      data['MailDetail'] = this.mailDetail!.map((v) => v.toJson()).toList();
    }
    if (this.courierDetail != null) {
      data['CourierDetail'] =
          this.courierDetail!.map((v) => v.toJson()).toList();
    }
    data['Status'] = this.status;
    data['StatusMessage'] = this.statusMessage;
    return data;
  }
}

class ULDDetails {
  String? uLDTareWeight;
  String? uLDType;
  String? uLDNumber;
  String? uLDOwner;

  ULDDetails({this.uLDTareWeight, this.uLDType, this.uLDNumber, this.uLDOwner});

  ULDDetails.fromJson(Map<String, dynamic> json) {
    uLDTareWeight = json['ULDTareWeight'];
    uLDType = json['ULDType'];
    uLDNumber = json['ULDNumber'];
    uLDOwner = json['ULDOwner'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ULDTareWeight'] = this.uLDTareWeight;
    data['ULDType'] = this.uLDType;
    data['ULDNumber'] = this.uLDNumber;
    data['ULDOwner'] = this.uLDOwner;
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
