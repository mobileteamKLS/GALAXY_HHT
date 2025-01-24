class GetMoveSearchModel {
  List<GroupDetailList>? groupDetailList;
  List<ULDTrolleyDetailsList>? uLDTrolleyDetailsList;
  String? status;
  String? statusMessage;

  GetMoveSearchModel(
      {this.groupDetailList,
        this.uLDTrolleyDetailsList,
        this.status,
        this.statusMessage});

  GetMoveSearchModel.fromJson(Map<String, dynamic> json) {
    if (json['GroupDetailList'] != null) {
      groupDetailList = <GroupDetailList>[];
      json['GroupDetailList'].forEach((v) {
        groupDetailList!.add(new GroupDetailList.fromJson(v));
      });
    }
    if (json['ULDTrolleyDetailsList'] != null) {
      uLDTrolleyDetailsList = <ULDTrolleyDetailsList>[];
      json['ULDTrolleyDetailsList'].forEach((v) {
        uLDTrolleyDetailsList!.add(new ULDTrolleyDetailsList.fromJson(v));
      });
    }
    status = json['Status'];
    statusMessage = json['StatusMessage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.groupDetailList != null) {
      data['GroupDetailList'] =
          this.groupDetailList!.map((v) => v.toJson()).toList();
    }
    if (this.uLDTrolleyDetailsList != null) {
      data['ULDTrolleyDetailsList'] =
          this.uLDTrolleyDetailsList!.map((v) => v.toJson()).toList();
    }
    data['Status'] = this.status;
    data['StatusMessage'] = this.statusMessage;
    return data;
  }
}

class GroupDetailList {
  String? groupId;
  int? eXPShipRowId;
  int? eXPAWBRowId;
  String? aWBPrefix;
  String? aWBNo;
  int? nOP;
  double? weight;
  String? curentLocation;
  int? groupSeqNo;
  String? dropLocation;
  String? dropType;

  GroupDetailList(
      {this.groupId,
        this.eXPShipRowId,
        this.eXPAWBRowId,
        this.aWBPrefix,
        this.aWBNo,
        this.nOP,
        this.weight,
        this.curentLocation,
        this.groupSeqNo,
        this.dropLocation,
        this.dropType});

  GroupDetailList.fromJson(Map<String, dynamic> json) {
    groupId = json['GroupId'];
    eXPShipRowId = json['EXPShipRowId'];
    eXPAWBRowId = json['EXPAWBRowId'];
    aWBPrefix = json['AWBPrefix'];
    aWBNo = json['AWBNo'];
    nOP = json['NOP'];
    weight = json['Weight'];
    curentLocation = json['CurentLocation'];
    groupSeqNo = json['GroupSeqNo'];
    dropLocation = json['DropLocation'];
    dropType = json['DropType'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['GroupId'] = this.groupId;
    data['EXPShipRowId'] = this.eXPShipRowId;
    data['EXPAWBRowId'] = this.eXPAWBRowId;
    data['AWBPrefix'] = this.aWBPrefix;
    data['AWBNo'] = this.aWBNo;
    data['NOP'] = this.nOP;
    data['Weight'] = this.weight;
    data['CurentLocation'] = this.curentLocation;
    data['GroupSeqNo'] = this.groupSeqNo;
    data['DropLocation'] = this.dropLocation;
    data['DropType'] = this.dropType;
    return data;
  }
}

class ULDTrolleyDetailsList {
  int? uLDTrolleySeqNo;
  String? uLDTrolleyType;
  String? uLDTrolleyNo;
  String? uLDOwner;
  double? scaleWeight;
  String? uLDTrolleyStatus;
  String? dGInd;
  String? sHCCode;
  int? flightSeqNo;
  String? curentLocation;
  String? offPoint;
  String? carriarCode;
  String? dropLocation;
  String? dropType;

  ULDTrolleyDetailsList(
      {this.uLDTrolleySeqNo,
        this.uLDTrolleyType,
        this.uLDTrolleyNo,
        this.uLDOwner,
        this.scaleWeight,
        this.uLDTrolleyStatus,
        this.dGInd,
        this.sHCCode,
        this.flightSeqNo,
        this.curentLocation,
        this.offPoint,
        this.carriarCode,
        this.dropLocation,
        this.dropType});

  ULDTrolleyDetailsList.fromJson(Map<String, dynamic> json) {
    uLDTrolleySeqNo = json['ULDTrolleySeqNo'];
    uLDTrolleyType = json['ULDTrolleyType'];
    uLDTrolleyNo = json['ULDTrolleyNo'];
    uLDOwner = json['ULDOwner'];
    scaleWeight = json['ScaleWeight'];
    uLDTrolleyStatus = json['ULDTrolleyStatus'];
    dGInd = json['DGInd'];
    sHCCode = json['SHCCode'];
    flightSeqNo = json['FlightSeqNo'];
    curentLocation = json['CurentLocation'];
    offPoint = json['OffPoint'];
    carriarCode = json['CarriarCode'];
    dropLocation = json['DropLocation'];
    dropType = json['DropType'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ULDTrolleySeqNo'] = this.uLDTrolleySeqNo;
    data['ULDTrolleyType'] = this.uLDTrolleyType;
    data['ULDTrolleyNo'] = this.uLDTrolleyNo;
    data['ULDOwner'] = this.uLDOwner;
    data['ScaleWeight'] = this.scaleWeight;
    data['ULDTrolleyStatus'] = this.uLDTrolleyStatus;
    data['DGInd'] = this.dGInd;
    data['SHCCode'] = this.sHCCode;
    data['FlightSeqNo'] = this.flightSeqNo;
    data['CurentLocation'] = this.curentLocation;
    data['OffPoint'] = this.offPoint;
    data['CarriarCode'] = this.carriarCode;
    data['DropLocation'] = this.dropLocation;
    data['DropType'] = this.dropType;
    return data;
  }
}
