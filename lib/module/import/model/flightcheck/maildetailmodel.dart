class MailDetailModel {
  List<AddMailDetailsList>? addMailDetailsList;
  String? status;
  String? statusMessage;

  MailDetailModel({this.addMailDetailsList, this.status, this.statusMessage});

  MailDetailModel.fromJson(Map<String, dynamic> json) {
    if (json['AddMailDetailsList'] != null) {
      addMailDetailsList = <AddMailDetailsList>[];
      json['AddMailDetailsList'].forEach((v) {
        addMailDetailsList!.add(new AddMailDetailsList.fromJson(v));
      });
    }
    status = json['Status'];
    statusMessage = json['StatusMessage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.addMailDetailsList != null) {
      data['AddMailDetailsList'] =
          this.addMailDetailsList!.map((v) => v.toJson()).toList();
    }
    data['Status'] = this.status;
    data['StatusMessage'] = this.statusMessage;
    return data;
  }
}

class AddMailDetailsList {
  int? seqNo;
  String? aV7No;
  String? mailType;
  String? origin;
  String? destination;
  int? nOP;
  double? weightKg;
  String? description;

  AddMailDetailsList(
      {this.seqNo,
        this.aV7No,
        this.mailType,
        this.origin,
        this.destination,
        this.nOP,
        this.weightKg,
        this.description});

  AddMailDetailsList.fromJson(Map<String, dynamic> json) {
    seqNo = json['SeqNo'];
    aV7No = json['AV7No'];
    mailType = json['MailType'];
    origin = json['Origin'];
    destination = json['Destination'];
    nOP = json['NOP'];
    weightKg = json['WeightKg'];
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
    data['Description'] = this.description;
    return data;
  }
}
