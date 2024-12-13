class PalletStackULDConditionCodeModel {
  List<ULDConditionCodeList>? uLDConditionCodeList;
  String? status;
  String? statusMessage;

  PalletStackULDConditionCodeModel(
      {this.uLDConditionCodeList, this.status, this.statusMessage});

  PalletStackULDConditionCodeModel.fromJson(Map<String, dynamic> json) {
    if (json['ULDConditionCodeList'] != null) {
      uLDConditionCodeList = <ULDConditionCodeList>[];
      json['ULDConditionCodeList'].forEach((v) {
        uLDConditionCodeList!.add(new ULDConditionCodeList.fromJson(v));
      });
    }
    status = json['Status'];
    statusMessage = json['StatusMessage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.uLDConditionCodeList != null) {
      data['ULDConditionCodeList'] =
          this.uLDConditionCodeList!.map((v) => v.toJson()).toList();
    }
    data['Status'] = this.status;
    data['StatusMessage'] = this.statusMessage;
    return data;
  }
}

class ULDConditionCodeList {
  String? referenceDataIdentifier;
  String? referenceDescription;

  ULDConditionCodeList(
      {this.referenceDataIdentifier, this.referenceDescription});

  ULDConditionCodeList.fromJson(Map<String, dynamic> json) {
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
