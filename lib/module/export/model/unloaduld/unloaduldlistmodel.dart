class UnloadUldListModel {
  List<UnloadULDDetailList>? unloadULDDetailList;
  String? status;
  String? statusMessage;

  UnloadUldListModel(
      {this.unloadULDDetailList, this.status, this.statusMessage});

  UnloadUldListModel.fromJson(Map<String, dynamic> json) {
    if (json['UnloadULDDetailList'] != null) {
      unloadULDDetailList = <UnloadULDDetailList>[];
      json['UnloadULDDetailList'].forEach((v) {
        unloadULDDetailList!.add(new UnloadULDDetailList.fromJson(v));
      });
    }
    status = json['Status'];
    statusMessage = json['StatusMessage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.unloadULDDetailList != null) {
      data['UnloadULDDetailList'] =
          this.unloadULDDetailList!.map((v) => v.toJson()).toList();
    }
    data['Status'] = this.status;
    data['StatusMessage'] = this.statusMessage;
    return data;
  }
}

class UnloadULDDetailList {
  int? uLDSeqNo;
  int? flightSeqNo;
  String? uLDNo;
  String? uLDStatus;
  String? flightNo;
  String? flightDate;
  String? uLDLocation;
  String? uLDType;

  UnloadULDDetailList(
      {this.uLDSeqNo,
        this.flightSeqNo,
        this.uLDNo,
        this.uLDStatus,
        this.flightNo,
        this.flightDate,
        this.uLDLocation,
        this.uLDType});

  UnloadULDDetailList.fromJson(Map<String, dynamic> json) {
    uLDSeqNo = json['ULDSeqNo'];
    flightSeqNo = json['FlightSeqNo'];
    uLDNo = json['ULDNo'];
    uLDStatus = json['ULDStatus'];
    flightNo = json['FlightNo'];
    flightDate = json['FlightDate'];
    uLDLocation = json['ULDLocation'];
    uLDType = json['ULDType'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ULDSeqNo'] = this.uLDSeqNo;
    data['FlightSeqNo'] = this.flightSeqNo;
    data['ULDNo'] = this.uLDNo;
    data['ULDStatus'] = this.uLDStatus;
    data['FlightNo'] = this.flightNo;
    data['FlightDate'] = this.flightDate;
    data['ULDLocation'] = this.uLDLocation;
    data['ULDType'] = this.uLDType;
    return data;
  }
}
