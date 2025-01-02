class GetScaleListModel {
  List<ULDScaleWeightList>? uLDScaleWeightList;
  ULDScaleWeightDetail? uLDScaleWeightDetail;
  String? status;
  String? statusMessage;

  GetScaleListModel(
      {this.uLDScaleWeightList,
        this.uLDScaleWeightDetail,
        this.status,
        this.statusMessage});

  GetScaleListModel.fromJson(Map<String, dynamic> json) {
    if (json['ULDScaleWeightList'] != null) {
      uLDScaleWeightList = <ULDScaleWeightList>[];
      json['ULDScaleWeightList'].forEach((v) {
        uLDScaleWeightList!.add(new ULDScaleWeightList.fromJson(v));
      });
    }
    uLDScaleWeightDetail = json['ULDScaleWeightDetail'] != null
        ? new ULDScaleWeightDetail.fromJson(json['ULDScaleWeightDetail'])
        : null;
    status = json['Status'];
    statusMessage = json['StatusMessage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.uLDScaleWeightList != null) {
      data['ULDScaleWeightList'] =
          this.uLDScaleWeightList!.map((v) => v.toJson()).toList();
    }
    if (this.uLDScaleWeightDetail != null) {
      data['ULDScaleWeightDetail'] = this.uLDScaleWeightDetail!.toJson();
    }
    data['Status'] = this.status;
    data['StatusMessage'] = this.statusMessage;
    return data;
  }
}

class ULDScaleWeightList {
  String? referenceDataIdentifier;
  String? referenceDescription;

  ULDScaleWeightList({this.referenceDataIdentifier, this.referenceDescription});

  ULDScaleWeightList.fromJson(Map<String, dynamic> json) {
    referenceDataIdentifier = json['ReferenceDataIdentifier'];
    referenceDescription = json['ReferenceDescription'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ReferenceDataIdentifier'] = this.referenceDataIdentifier;
    data['ReferenceDescription'] = this.referenceDescription;
    return data;
  }
}

class ULDScaleWeightDetail {
  double? scaleWeight;
  String? machineNo;

  ULDScaleWeightDetail({this.scaleWeight, this.machineNo});

  ULDScaleWeightDetail.fromJson(Map<String, dynamic> json) {
    scaleWeight = json['ScaleWeight'];
    machineNo = json['MachineNo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ScaleWeight'] = this.scaleWeight;
    data['MachineNo'] = this.machineNo;
    return data;
  }
}
