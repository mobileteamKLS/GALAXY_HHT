class CloseTrolleySearchModel {
  List<TrolleyDetail>? trolleyDetail;
  String? status;
  String? statusMessage;

  CloseTrolleySearchModel(
      {this.trolleyDetail, this.status, this.statusMessage});

  CloseTrolleySearchModel.fromJson(Map<String, dynamic> json) {
    if (json['TrolleyDetail'] != null) {
      trolleyDetail = <TrolleyDetail>[];
      json['TrolleyDetail'].forEach((v) {
        trolleyDetail!.add(new TrolleyDetail.fromJson(v));
      });
    }
    status = json['Status'];
    statusMessage = json['StatusMessage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.trolleyDetail != null) {
      data['TrolleyDetail'] =
          this.trolleyDetail!.map((v) => v.toJson()).toList();
    }
    data['Status'] = this.status;
    data['StatusMessage'] = this.statusMessage;
    return data;
  }
}

class TrolleyDetail {
  int? trolleySeqNo;
  int? flightSeqNo;
  String? trolleyNo;
  String? trolleyStatus;
  String? flightNo;
  String? flightDate;
  String? trolleyOffPoint;
  double? tareWeight;
  double? netWeight;
  double? equipmentWeight;
  double? scaleWeight;
  double? deviation;
  double? deviationPer;
  int? equipmentCount;

  TrolleyDetail(
      {this.trolleySeqNo,
        this.flightSeqNo,
        this.trolleyNo,
        this.trolleyStatus,
        this.flightNo,
        this.flightDate,
        this.trolleyOffPoint,
        this.tareWeight,
        this.netWeight,
        this.equipmentWeight,
        this.scaleWeight,
        this.deviation,
        this.deviationPer,
        this.equipmentCount});

  TrolleyDetail.fromJson(Map<String, dynamic> json) {
    trolleySeqNo = json['TrolleySeqNo'];
    flightSeqNo = json['FlightSeqNo'];
    trolleyNo = json['TrolleyNo'];
    trolleyStatus = json['TrolleyStatus'];
    flightNo = json['FlightNo'];
    flightDate = json['FlightDate'];
    trolleyOffPoint = json['TrolleyOffPoint'];
    tareWeight = json['TareWeight'];
    netWeight = json['NetWeight'];
    equipmentWeight = json['EquipmentWeight'];
    scaleWeight = json['ScaleWeight'];
    deviation = json['Deviation'];
    deviationPer = json['DeviationPer'];
    equipmentCount = json['EquipmentCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['TrolleySeqNo'] = this.trolleySeqNo;
    data['FlightSeqNo'] = this.flightSeqNo;
    data['TrolleyNo'] = this.trolleyNo;
    data['TrolleyStatus'] = this.trolleyStatus;
    data['FlightNo'] = this.flightNo;
    data['FlightDate'] = this.flightDate;
    data['TrolleyOffPoint'] = this.trolleyOffPoint;
    data['TareWeight'] = this.tareWeight;
    data['NetWeight'] = this.netWeight;
    data['EquipmentWeight'] = this.equipmentWeight;
    data['ScaleWeight'] = this.scaleWeight;
    data['Deviation'] = this.deviation;
    data['DeviationPer'] = this.deviationPer;
    data['EquipmentCount'] = this.equipmentCount;
    return data;
  }
}
