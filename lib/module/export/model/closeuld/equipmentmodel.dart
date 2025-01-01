class CloseULDEquipmentModel {
  List<EequipmentList>? eequipmentList;
  String? status;
  String? statusMessage;

  CloseULDEquipmentModel(
      {this.eequipmentList, this.status, this.statusMessage});

  CloseULDEquipmentModel.fromJson(Map<String, dynamic> json) {
    if (json['ULDEquipmentList'] != null) {
      eequipmentList = <EequipmentList>[];
      json['ULDEquipmentList'].forEach((v) {
        eequipmentList!.add(new EequipmentList.fromJson(v));
      });
    }
    status = json['Status'];
    statusMessage = json['StatusMessage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.eequipmentList != null) {
      data['ULDEquipmentList'] =
          this.eequipmentList!.map((v) => v.toJson()).toList();
    }
    data['Status'] = this.status;
    data['StatusMessage'] = this.statusMessage;
    return data;
  }
}

class EequipmentList {
  String? referenceDataIdentifier;
  String? referenceDescription;
  String? quantity;
  double? weight;

  EequipmentList(
      {this.referenceDataIdentifier,
        this.referenceDescription,
        this.quantity,
        this.weight});

  EequipmentList.fromJson(Map<String, dynamic> json) {
    referenceDataIdentifier = json['ReferenceDataIdentifier'];
    referenceDescription = json['ReferenceDescription'];
    quantity = json['Quantity'];
    weight = json['Weight'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ReferenceDataIdentifier'] = this.referenceDataIdentifier;
    data['ReferenceDescription'] = this.referenceDescription;
    data['Quantity'] = this.quantity;
    data['Weight'] = this.weight;
    return data;
  }
}
