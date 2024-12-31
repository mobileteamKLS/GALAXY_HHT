class CloseULDSearchModel {
  List<ULDDetailList>? uLDDetailList;
  String? status;
  String? statusMessage;

  CloseULDSearchModel({this.uLDDetailList, this.status, this.statusMessage});

  CloseULDSearchModel.fromJson(Map<String, dynamic> json) {
    if (json['ULDDetailList'] != null) {
      uLDDetailList = <ULDDetailList>[];
      json['ULDDetailList'].forEach((v) {
        uLDDetailList!.add(new ULDDetailList.fromJson(v));
      });
    }
    status = json['Status'];
    statusMessage = json['StatusMessage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.uLDDetailList != null) {
      data['ULDDetailList'] =
          this.uLDDetailList!.map((v) => v.toJson()).toList();
    }
    data['Status'] = this.status;
    data['StatusMessage'] = this.statusMessage;
    return data;
  }
}

class ULDDetailList {
  int? uLDSeqNo;
  int? flightSeqNo;
  String? uLDNo;
  String? uLDStatus;
  String? flightNo;
  String? flightDate;
  String? uLDOffPoint;
  double? tareWeight;
  double? netWeight;
  double? equipmentWeight;
  double? scaleWeight;
  double? deviation;
  double? deviationPer;
  String? contour;
  int? equipmentCount;
  String? remarks;

  ULDDetailList(
      {this.uLDSeqNo,
        this.flightSeqNo,
        this.uLDNo,
        this.uLDStatus,
        this.flightNo,
        this.flightDate,
        this.uLDOffPoint,
        this.tareWeight,
        this.netWeight,
        this.equipmentWeight,
        this.scaleWeight,
        this.deviation,
        this.deviationPer,
        this.contour,
        this.equipmentCount,
        this.remarks});

  ULDDetailList.fromJson(Map<String, dynamic> json) {
    uLDSeqNo = json['ULDSeqNo'];
    flightSeqNo = json['FlightSeqNo'];
    uLDNo = json['ULDNo'];
    uLDStatus = json['ULDStatus'];
    flightNo = json['FlightNo'];
    flightDate = json['FlightDate'];
    uLDOffPoint = json['ULDOffPoint'];
    tareWeight = json['TareWeight'];
    netWeight = json['NetWeight'];
    equipmentWeight = json['EquipmentWeight'];
    scaleWeight = json['ScaleWeight'];
    deviation = json['Deviation'];
    deviationPer = json['DeviationPer'];
    contour = json['Contour'];
    equipmentCount = json['EquipmentCount'];
    remarks = json['Remarks'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ULDSeqNo'] = this.uLDSeqNo;
    data['FlightSeqNo'] = this.flightSeqNo;
    data['ULDNo'] = this.uLDNo;
    data['ULDStatus'] = this.uLDStatus;
    data['FlightNo'] = this.flightNo;
    data['FlightDate'] = this.flightDate;
    data['ULDOffPoint'] = this.uLDOffPoint;
    data['TareWeight'] = this.tareWeight;
    data['NetWeight'] = this.netWeight;
    data['EquipmentWeight'] = this.equipmentWeight;
    data['ScaleWeight'] = this.scaleWeight;
    data['Deviation'] = this.deviation;
    data['DeviationPer'] = this.deviationPer;
    data['Contour'] = this.contour;
    data['EquipmentCount'] = this.equipmentCount;
    data['Remarks'] = this.remarks;
    return data;
  }
}
