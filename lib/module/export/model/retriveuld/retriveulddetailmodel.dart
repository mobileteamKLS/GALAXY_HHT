class RetriveULDDetailLoadModel {
  List<ULDDetailList>? uLDDetailList;
  String? status;
  String? statusMessage;

  RetriveULDDetailLoadModel(
      {this.uLDDetailList, this.status, this.statusMessage});

  RetriveULDDetailLoadModel.fromJson(Map<String, dynamic> json) {
    if (json['ULDDetailList'] != null) {
      uLDDetailList = <ULDDetailList>[];
      json['ULDDetailList'].forEach((v) {
        uLDDetailList!.add(new ULDDetailList.fromJson(v));
      });
    }
    status = json['Status'];
    statusMessage = json['StatusMessage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.uLDDetailList != null) {
      data['ULDDetailList'] =
          this.uLDDetailList!.map((v) => v.toJson()).toList();
    }
    data['Status'] = this.status;
    data['StatusMessage'] = this.statusMessage;
    return data;
  }
}

class ULDDetailList {
  String? uLDNo;
  int? uLDSeqNo;
  String? intact;
  int? stackSize;
  String? uLDLocation;
  String? uLDStatus;

  ULDDetailList(
      {this.uLDNo,
        this.uLDSeqNo,
        this.intact,
        this.stackSize,
        this.uLDLocation,
        this.uLDStatus});

  ULDDetailList.fromJson(Map<String, dynamic> json) {
    uLDNo = json['ULDNo'];
    uLDSeqNo = json['ULDSeqNo'];
    intact = json['Intact'];
    stackSize = json['StackSize'];
    uLDLocation = json['ULDLocation'];
    uLDStatus = json['ULDStatus'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ULDNo'] = this.uLDNo;
    data['ULDSeqNo'] = this.uLDSeqNo;
    data['Intact'] = this.intact;
    data['StackSize'] = this.stackSize;
    data['ULDLocation'] = this.uLDLocation;
    data['ULDStatus'] = this.uLDStatus;
    return data;
  }
}
