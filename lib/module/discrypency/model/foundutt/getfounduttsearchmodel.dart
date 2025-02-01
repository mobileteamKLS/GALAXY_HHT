class GetFoundUTTSearchModel {
  List<FoundUTTAWBDetailList>? foundUTTAWBDetailList;
  List<FoundUTTULDDetailList>? foundUTTULDDetailList;
  String? status;
  String? statusMessage;

  GetFoundUTTSearchModel(
      {this.foundUTTAWBDetailList,
        this.foundUTTULDDetailList,
        this.status,
        this.statusMessage});

  GetFoundUTTSearchModel.fromJson(Map<String, dynamic> json) {
    if (json['FoundUTTAWBDetailList'] != null) {
      foundUTTAWBDetailList = <FoundUTTAWBDetailList>[];
      json['FoundUTTAWBDetailList'].forEach((v) {
        foundUTTAWBDetailList!.add(new FoundUTTAWBDetailList.fromJson(v));
      });
    }
    if (json['FoundUTTULDDetailList'] != null) {
      foundUTTULDDetailList = <FoundUTTULDDetailList>[];
      json['FoundUTTULDDetailList'].forEach((v) {
        foundUTTULDDetailList!.add(new FoundUTTULDDetailList.fromJson(v));
      });
    }
    status = json['Status'];
    statusMessage = json['StatusMessage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.foundUTTAWBDetailList != null) {
      data['FoundUTTAWBDetailList'] =
          this.foundUTTAWBDetailList!.map((v) => v.toJson()).toList();
    }
    if (this.foundUTTULDDetailList != null) {
      data['FoundUTTULDDetailList'] =
          this.foundUTTULDDetailList!.map((v) => v.toJson()).toList();
    }
    data['Status'] = this.status;
    data['StatusMessage'] = this.statusMessage;
    return data;
  }
}

class FoundUTTAWBDetailList {
  String? aWBNo;
  String? houseNo;
  String? groupId;
  int? nOP;
  double? weightKg;
  String? location;
  int? expAWBRowId;
  int? expShipRowId;
  int? eMISeqNo;
  int? groupSeqNo;
  String? moduleType;
  int? uTTDays;
  int? uTTHour;

  FoundUTTAWBDetailList(
      {this.aWBNo,
        this.houseNo,
        this.groupId,
        this.nOP,
        this.weightKg,
        this.location,
        this.expAWBRowId,
        this.expShipRowId,
        this.eMISeqNo,
        this.groupSeqNo,
        this.moduleType,
        this.uTTDays,
        this.uTTHour});

  FoundUTTAWBDetailList.fromJson(Map<String, dynamic> json) {
    aWBNo = json['AWBNo'];
    houseNo = json['HouseNo'];
    groupId = json['GroupId'];
    nOP = json['NOP'];
    weightKg = json['WeightKg'];
    location = json['Location'];
    expAWBRowId = json['ExpAWBRowId'];
    expShipRowId = json['ExpShipRowId'];
    eMISeqNo = json['EMISeqNo'];
    groupSeqNo = json['GroupSeqNo'];
    moduleType = json['ModuleType'];
    uTTDays = json['UTTDays'];
    uTTHour = json['UTTHour'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['AWBNo'] = this.aWBNo;
    data['HouseNo'] = this.houseNo;
    data['GroupId'] = this.groupId;
    data['NOP'] = this.nOP;
    data['WeightKg'] = this.weightKg;
    data['Location'] = this.location;
    data['ExpAWBRowId'] = this.expAWBRowId;
    data['ExpShipRowId'] = this.expShipRowId;
    data['EMISeqNo'] = this.eMISeqNo;
    data['GroupSeqNo'] = this.groupSeqNo;
    data['ModuleType'] = this.moduleType;
    data['UTTDays'] = this.uTTDays;
    data['UTTHour'] = this.uTTHour;
    return data;
  }
}

class FoundUTTULDDetailList {
  String? uLDNo;
  String? uLDOwner;
  String? location;
  String? groupId;
  int? uLDSeqNo;
  int? uTTDays;
  int? uTTHour;

  FoundUTTULDDetailList(
      {this.uLDNo,
        this.uLDOwner,
        this.location,
        this.groupId,
        this.uLDSeqNo,
        this.uTTDays,
        this.uTTHour});

  FoundUTTULDDetailList.fromJson(Map<String, dynamic> json) {
    uLDNo = json['ULDNo'];
    uLDOwner = json['ULDOwner'];
    location = json['Location'];
    groupId = json['GroupId'];
    uLDSeqNo = json['ULDSeqNo'];
    uTTDays = json['UTTDays'];
    uTTHour = json['UTTHour'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ULDNo'] = this.uLDNo;
    data['ULDOwner'] = this.uLDOwner;
    data['Location'] = this.location;
    data['GroupId'] = this.groupId;
    data['ULDSeqNo'] = this.uLDSeqNo;
    data['UTTDays'] = this.uTTDays;
    data['UTTHour'] = this.uTTHour;
    return data;
  }
}
