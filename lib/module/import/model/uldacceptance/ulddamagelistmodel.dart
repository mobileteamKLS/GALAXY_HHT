class UldDamageListModel {
  String? messageCode;
  List<ULDDamage>? uLDDamage;
  String? status;
  String? statusMessage;

  UldDamageListModel(
      {this.messageCode, this.uLDDamage, this.status, this.statusMessage});

  UldDamageListModel.fromJson(Map<String, dynamic> json) {
    messageCode = json['MessageCode'];
    if (json['ULDDamage'] != null) {
      uLDDamage = <ULDDamage>[];
      json['ULDDamage'].forEach((v) {
        uLDDamage!.add(new ULDDamage.fromJson(v));
      });
    }
    status = json['Status'];
    statusMessage = json['StatusMessage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['MessageCode'] = this.messageCode;
    if (this.uLDDamage != null) {
      data['ULDDamage'] = this.uLDDamage!.map((v) => v.toJson()).toList();
    }
    data['Status'] = this.status;
    data['StatusMessage'] = this.statusMessage;
    return data;
  }
}

class ULDDamage {
  int? rowId;
  String? referenceDataIdentifier;
  String? referenceDescription;

  ULDDamage(
      {this.rowId, this.referenceDataIdentifier, this.referenceDescription});

  ULDDamage.fromJson(Map<String, dynamic> json) {
    rowId = json['RowId'];
    referenceDataIdentifier = json['ReferenceDataIdentifier'];
    referenceDescription = json['ReferenceDescription'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['RowId'] = this.rowId;
    data['ReferenceDataIdentifier'] = this.referenceDataIdentifier;
    data['ReferenceDescription'] = this.referenceDescription;
    return data;
  }
}
