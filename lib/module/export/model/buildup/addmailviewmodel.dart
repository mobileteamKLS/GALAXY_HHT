class AddMailViewModel {
  List<AddMailViewList>? addMailViewList;
  List<MailTypeList>? mailTypeList;
  List<ModeOfSecurityList>? modeOfSecurityList;
  String? status;
  String? statusMessage;

  AddMailViewModel(
      {this.addMailViewList,
        this.mailTypeList,
        this.modeOfSecurityList,
        this.status,
        this.statusMessage});

  AddMailViewModel.fromJson(Map<String, dynamic> json) {
    if (json['AddMailViewList'] != null) {
      addMailViewList = <AddMailViewList>[];
      json['AddMailViewList'].forEach((v) {
        addMailViewList!.add(new AddMailViewList.fromJson(v));
      });
    }
    if (json['MailTypeList'] != null) {
      mailTypeList = <MailTypeList>[];
      json['MailTypeList'].forEach((v) {
        mailTypeList!.add(new MailTypeList.fromJson(v));
      });
    }
    if (json['ModeOfSecurityList'] != null) {
      modeOfSecurityList = <ModeOfSecurityList>[];
      json['ModeOfSecurityList'].forEach((v) {
        modeOfSecurityList!.add(new ModeOfSecurityList.fromJson(v));
      });
    }
    status = json['Status'];
    statusMessage = json['StatusMessage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.addMailViewList != null) {
      data['AddMailViewList'] =
          this.addMailViewList!.map((v) => v.toJson()).toList();
    }
    if (this.mailTypeList != null) {
      data['MailTypeList'] = this.mailTypeList!.map((v) => v.toJson()).toList();
    }
    if (this.modeOfSecurityList != null) {
      data['ModeOfSecurityList'] =
          this.modeOfSecurityList!.map((v) => v.toJson()).toList();
    }
    data['Status'] = this.status;
    data['StatusMessage'] = this.statusMessage;
    return data;
  }
}

class AddMailViewList {
  int? seqNo;
  String? aV7No;
  String? mailType;
  String? origin;
  String? destination;
  int? nOP;
  double? weightKg;
  String? modeOfSecurity;
  String? description;

  AddMailViewList(
      {this.seqNo,
        this.aV7No,
        this.mailType,
        this.origin,
        this.destination,
        this.nOP,
        this.weightKg,
        this.modeOfSecurity,
        this.description});

  AddMailViewList.fromJson(Map<String, dynamic> json) {
    seqNo = json['SeqNo'];
    aV7No = json['AV7No'];
    mailType = json['MailType'];
    origin = json['Origin'];
    destination = json['Destination'];
    nOP = json['NOP'];
    weightKg = json['WeightKg'];
    modeOfSecurity = json['ModeOfSecurity'];
    description = json['Description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['SeqNo'] = this.seqNo;
    data['AV7No'] = this.aV7No;
    data['MailType'] = this.mailType;
    data['Origin'] = this.origin;
    data['Destination'] = this.destination;
    data['NOP'] = this.nOP;
    data['WeightKg'] = this.weightKg;
    data['ModeOfSecurity'] = this.modeOfSecurity;
    data['Description'] = this.description;
    return data;
  }
}

class MailTypeList {
  String? referenceDataIdentifier;
  String? referenceDescription;

  MailTypeList({this.referenceDataIdentifier, this.referenceDescription});

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

class ModeOfSecurityList {
  String? referenceDataIdentifier;
  String? referenceDescription;

  ModeOfSecurityList({this.referenceDataIdentifier, this.referenceDescription});

  ModeOfSecurityList.fromJson(Map<String, dynamic> json) {
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
