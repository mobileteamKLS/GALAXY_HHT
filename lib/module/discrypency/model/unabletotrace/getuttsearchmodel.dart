class GetUTTSearchModel {
  List<AWBDetailsList>? aWBDetailsList;
  List<ULDDetailsList>? uLDDetailsList;
  String? status;
  String? statusMessage;

  GetUTTSearchModel(
      {this.aWBDetailsList,
        this.uLDDetailsList,
        this.status,
        this.statusMessage});

  GetUTTSearchModel.fromJson(Map<String, dynamic> json) {
    if (json['AWBDetailsList'] != null) {
      aWBDetailsList = <AWBDetailsList>[];
      json['AWBDetailsList'].forEach((v) {
        aWBDetailsList!.add(new AWBDetailsList.fromJson(v));
      });
    }
    if (json['ULDDetailsList'] != null) {
      uLDDetailsList = <ULDDetailsList>[];
      json['ULDDetailsList'].forEach((v) {
        uLDDetailsList!.add(new ULDDetailsList.fromJson(v));
      });
    }
    status = json['Status'];
    statusMessage = json['StatusMessage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.aWBDetailsList != null) {
      data['AWBDetailsList'] =
          this.aWBDetailsList!.map((v) => v.toJson()).toList();
    }
    if (this.uLDDetailsList != null) {
      data['ULDDetailsList'] =
          this.uLDDetailsList!.map((v) => v.toJson()).toList();
    }
    data['Status'] = this.status;
    data['StatusMessage'] = this.statusMessage;
    return data;
  }
}

class AWBDetailsList {
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

  AWBDetailsList(
      {this.aWBNo,
        this.houseNo,
        this.groupId,
        this.nOP,
        this.weightKg,
        this.location,
        this.expAWBRowId,
        this.expShipRowId,
        this.eMISeqNo,
        this.groupSeqNo});

  AWBDetailsList.fromJson(Map<String, dynamic> json) {
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
    return data;
  }
}

class ULDDetailsList {
  String? uLDNo;
  String? uLDOwner;
  String? location;
  String? groupId;
  int? uLDSeqNo;

  ULDDetailsList(
      {this.uLDNo, this.uLDOwner, this.location, this.groupId, this.uLDSeqNo});

  ULDDetailsList.fromJson(Map<String, dynamic> json) {
    uLDNo = json['ULDNo'];
    uLDOwner = json['ULDOwner'];
    location = json['Location'];
    groupId = json['GroupId'];
    uLDSeqNo = json['ULDSeqNo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ULDNo'] = this.uLDNo;
    data['ULDOwner'] = this.uLDOwner;
    data['Location'] = this.location;
    data['GroupId'] = this.groupId;
    data['ULDSeqNo'] = this.uLDSeqNo;
    return data;
  }
}
