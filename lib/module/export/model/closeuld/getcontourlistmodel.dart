class GetContourListModel {
  List<ULDContourList>? uLDContourList;
  ULDContourDetail? uLDContourDetail;
  String? status;
  String? statusMessage;

  GetContourListModel(
      {this.uLDContourList,
        this.uLDContourDetail,
        this.status,
        this.statusMessage});

  GetContourListModel.fromJson(Map<String, dynamic> json) {
    if (json['ULDContourList'] != null) {
      uLDContourList = <ULDContourList>[];
      json['ULDContourList'].forEach((v) {
        uLDContourList!.add(new ULDContourList.fromJson(v));
      });
    }
    uLDContourDetail = json['ULDContourDetail'] != null
        ? new ULDContourDetail.fromJson(json['ULDContourDetail'])
        : null;
    status = json['Status'];
    statusMessage = json['StatusMessage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.uLDContourList != null) {
      data['ULDContourList'] =
          this.uLDContourList!.map((v) => v.toJson()).toList();
    }
    if (this.uLDContourDetail != null) {
      data['ULDContourDetail'] = this.uLDContourDetail!.toJson();
    }
    data['Status'] = this.status;
    data['StatusMessage'] = this.statusMessage;
    return data;
  }
}

class ULDContourList {
  String? referenceDataIdentifier;
  String? referenceDescription;

  ULDContourList({this.referenceDataIdentifier, this.referenceDescription});

  ULDContourList.fromJson(Map<String, dynamic> json) {
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

class ULDContourDetail {
  String? contourCode;
  double? height;

  ULDContourDetail({this.contourCode, this.height});

  ULDContourDetail.fromJson(Map<String, dynamic> json) {
    contourCode = json['ContourCode'];
    height = json['Height'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ContourCode'] = this.contourCode;
    data['Height'] = this.height;
    return data;
  }
}
