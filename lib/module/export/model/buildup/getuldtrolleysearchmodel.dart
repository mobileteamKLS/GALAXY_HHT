class GetULDTrolleySearchModel {
  List<ULDTrolleyDetailList>? uLDTrolleyDetailList;
  String? status;
  String? statusMessage;

  GetULDTrolleySearchModel(
      {this.uLDTrolleyDetailList, this.status, this.statusMessage});

  GetULDTrolleySearchModel.fromJson(Map<String, dynamic> json) {
    if (json['ULDTrolleyDetailList'] != null) {
      uLDTrolleyDetailList = <ULDTrolleyDetailList>[];
      json['ULDTrolleyDetailList'].forEach((v) {
        uLDTrolleyDetailList!.add(new ULDTrolleyDetailList.fromJson(v));
      });
    }
    status = json['Status'];
    statusMessage = json['StatusMessage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.uLDTrolleyDetailList != null) {
      data['ULDTrolleyDetailList'] =
          this.uLDTrolleyDetailList!.map((v) => v.toJson()).toList();
    }
    data['Status'] = this.status;
    data['StatusMessage'] = this.statusMessage;
    return data;
  }
}

class ULDTrolleyDetailList {
  String? type;
  int? uLDSeqNo;
  String? uLDTrolleyType;
  String? uLDTrolleyNo;
  String? uLDOwner;
  double? scaleWt;
  String? status;
  int? cargoNOP;
  double? cargoWt;
  int? courierNOP;
  double? courierWt;
  int? mailNOP;
  double? mailWt;
  int? nOP;
  int? grossWt;
  double? totalWt;
  String? sHCCode;
  String? contourCode;
  String? remark;
  int? priority;
  String? dgType;
  int? dgSeqNo;
  String? dgReference;

  ULDTrolleyDetailList(
      {this.type,
        this.uLDSeqNo,
        this.uLDTrolleyType,
        this.uLDTrolleyNo,
        this.uLDOwner,
        this.scaleWt,
        this.status,
        this.cargoNOP,
        this.cargoWt,
        this.courierNOP,
        this.courierWt,
        this.mailNOP,
        this.mailWt,
        this.nOP,
        this.grossWt,
        this.totalWt,
        this.sHCCode,
        this.contourCode,
        this.remark,
        this.priority,
        this.dgType,
        this.dgSeqNo,
        this.dgReference,
      });

  ULDTrolleyDetailList.fromJson(Map<String, dynamic> json) {
    type = json['Type'];
    uLDSeqNo = json['ULDSeqNo'];
    uLDTrolleyType = json['ULDTrolleyType'];
    uLDTrolleyNo = json['ULDTrolleyNo'];
    uLDOwner = json['ULDOwner'];
    scaleWt = json['ScaleWt'];
    status = json['Status'];
    cargoNOP = json['CargoNOP'];
    cargoWt = json['CargoWt'];
    courierNOP = json['CourierNOP'];
    courierWt = json['CourierWt'];
    mailNOP = json['MailNOP'];
    mailWt = json['MailWt'];
    nOP = json['NOP'];
    grossWt = json['GrossWt'];
    totalWt = json['TotalWt'];
    sHCCode = json['SHCCode'];
    contourCode = json['ContourCode'];
    remark = json['Remark'];
    priority = json['Priority'];
    dgReference = json['DGReferenceType'];
    dgSeqNo = json['DGSeqNo'];
    dgType = json['DGType'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Type'] = this.type;
    data['ULDSeqNo'] = this.uLDSeqNo;
    data['ULDTrolleyType'] = this.uLDTrolleyType;
    data['ULDTrolleyNo'] = this.uLDTrolleyNo;
    data['ULDOwner'] = this.uLDOwner;
    data['ScaleWt'] = this.scaleWt;
    data['Status'] = this.status;
    data['CargoNOP'] = this.cargoNOP;
    data['CargoWt'] = this.cargoWt;
    data['CourierNOP'] = this.courierNOP;
    data['CourierWt'] = this.courierWt;
    data['MailNOP'] = this.mailNOP;
    data['MailWt'] = this.mailWt;
    data['NOP'] = this.nOP;
    data['GrossWt'] = this.grossWt;
    data['TotalWt'] = this.totalWt;
    data['SHCCode'] = this.sHCCode;
    data['ContourCode'] = this.contourCode;
    data['Remark'] = this.remark;
    data['Priority'] = this.priority;
    data['DGReferenceType'] = this.dgReference;
    data['DGSeqNo'] = this.dgSeqNo;
    data['DGType'] = this.dgType;
    return data;
  }
}
