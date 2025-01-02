class GetRemarkListModel {
  List<ULDRemarksList>? uLDRemarksList;
  ULDRemarksDetail? uLDRemarksDetail;
  String? status;
  String? statusMessage;

  GetRemarkListModel(
      {this.uLDRemarksList,
        this.uLDRemarksDetail,
        this.status,
        this.statusMessage});

  GetRemarkListModel.fromJson(Map<String, dynamic> json) {
    if (json['ULDRemarksList'] != null) {
      uLDRemarksList = <ULDRemarksList>[];
      json['ULDRemarksList'].forEach((v) {
        uLDRemarksList!.add(new ULDRemarksList.fromJson(v));
      });
    }
    uLDRemarksDetail = json['ULDRemarksDetail'] != null
        ? new ULDRemarksDetail.fromJson(json['ULDRemarksDetail'])
        : null;
    status = json['Status'];
    statusMessage = json['StatusMessage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.uLDRemarksList != null) {
      data['ULDRemarksList'] =
          this.uLDRemarksList!.map((v) => v.toJson()).toList();
    }
    if (this.uLDRemarksDetail != null) {
      data['ULDRemarksDetail'] = this.uLDRemarksDetail!.toJson();
    }
    data['Status'] = this.status;
    data['StatusMessage'] = this.statusMessage;
    return data;
  }
}

class ULDRemarksList {
  String? referenceDataIdentifier;
  String? referenceDescription;

  ULDRemarksList({this.referenceDataIdentifier, this.referenceDescription});

  ULDRemarksList.fromJson(Map<String, dynamic> json) {
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

class ULDRemarksDetail {
  String? remarks;

  ULDRemarksDetail({this.remarks});

  ULDRemarksDetail.fromJson(Map<String, dynamic> json) {
    remarks = json['Remarks'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Remarks'] = this.remarks;
    return data;
  }
}
