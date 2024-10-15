class UldAcceptanceDetail {
  FlightDetail? flightDetail;
  List<ULDDetails>? uLDDetails;
  List<TrollyDetails>? trollyDetails;
  String? status;
  String? statusMessage;

  UldAcceptanceDetail(
      {this.flightDetail, this.uLDDetails, this.trollyDetails, this.status, this.statusMessage});

  UldAcceptanceDetail.fromJson(Map<String, dynamic> json) {
    flightDetail = json['FlightDetail'] != null
        ? new FlightDetail.fromJson(json['FlightDetail'])
        : null;
    if (json['ULDDetails'] != null) {
      uLDDetails = <ULDDetails>[];
      json['ULDDetails'].forEach((v) {
        uLDDetails!.add(new ULDDetails.fromJson(v));
      });
    }
    if (json['TrollyDetails'] != null) {
      trollyDetails = <TrollyDetails>[];
      json['TrollyDetails'].forEach((v) {
        trollyDetails!.add(new TrollyDetails.fromJson(v));
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
    if (this.uLDDetails != null) {
      data['ULDDetails'] = this.uLDDetails!.map((v) => v.toJson()).toList();
    }
    if (this.trollyDetails != null) {
      data['TrollyDetails'] =
          this.trollyDetails!.map((v) => v.toJson()).toList();
    }
    data['Status'] = this.status;
    data['StatusMessage'] = this.statusMessage;
    return data;
  }
}

class FlightDetail {
  int? fltSeqNo;
  String? flightNo;
  String? flightDate;
  String? flightStatus;

  FlightDetail({this.fltSeqNo, this.flightNo, this.flightDate});

  FlightDetail.fromJson(Map<String, dynamic> json) {
    fltSeqNo = json['FltSeqNo'];
    flightNo = json['FlightNo'];
    flightDate = json['FlightDate'];
    flightStatus = json['FlightStatus'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['FltSeqNo'] = this.fltSeqNo;
    data['FlightNo'] = this.flightNo;
    data['FlightDate'] = this.flightDate;
    data['FlightStatus'] = this.flightStatus;
    return data;
  }
}

class ULDDetails {
  String? fltULDSeqNo;
  String? uLDNo;
  String? txtColor;
  String? buttonStatus;

  ULDDetails({this.fltULDSeqNo, this.uLDNo, this.txtColor, this.buttonStatus});

  ULDDetails.fromJson(Map<String, dynamic> json) {
    fltULDSeqNo = json['FltULDSeqNo'];
    uLDNo = json['ULDNo'];
    txtColor = json['TxtColor'];
    buttonStatus = json['ButtonStatus'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['FltULDSeqNo'] = this.fltULDSeqNo;
    data['ULDNo'] = this.uLDNo;
    data['TxtColor'] = this.txtColor;
    data['ButtonStatus'] = this.buttonStatus;
    return data;
  }

  static void removeBulkUld(List<ULDDetails> uldList) {
    uldList.removeWhere((uld) => uld.uLDNo == "BULK");
  }
}

class TrollyDetails {
  int? trollySeqNo;
  String? trollyNo;
  String? trollyReceiveTime;

  TrollyDetails({this.trollySeqNo, this.trollyNo, this.trollyReceiveTime});

  TrollyDetails.fromJson(Map<String, dynamic> json) {
    trollySeqNo = json['TrollySeqNo'];
    trollyNo = json['TrollyNo'];
    trollyReceiveTime = json['TrollyReceiveTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['TrollySeqNo'] = this.trollySeqNo;
    data['TrollyNo'] = this.trollyNo;
    data['TrollyReceiveTime'] = this.trollyReceiveTime;
    return data;
  }
}
