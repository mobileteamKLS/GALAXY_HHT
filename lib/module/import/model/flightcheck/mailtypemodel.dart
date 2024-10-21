class MailTypeModel {
  List<MailTypeList>? mailTypeList;
  String? status;
  String? statusMessage;

  MailTypeModel({this.mailTypeList, this.status, this.statusMessage});

  MailTypeModel.fromJson(Map<String, dynamic> json) {
    if (json['MailTypeList'] != null) {
      mailTypeList = <MailTypeList>[];
      json['MailTypeList'].forEach((v) {
        mailTypeList!.add(new MailTypeList.fromJson(v));
      });
    }
    status = json['Status'];
    statusMessage = json['StatusMessage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.mailTypeList != null) {
      data['MailTypeList'] =
          this.mailTypeList!.map((v) => v.toJson()).toList();
    }
    data['Status'] = this.status;
    data['StatusMessage'] = this.statusMessage;
    return data;
  }
}

class MailTypeList {

  String? referenceDataIdentifier;
  String? referenceDescription;


  MailTypeList(
      {
        this.referenceDataIdentifier,
        this.referenceDescription,
        });

  MailTypeList.fromJson(Map<String, dynamic> json) {

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
