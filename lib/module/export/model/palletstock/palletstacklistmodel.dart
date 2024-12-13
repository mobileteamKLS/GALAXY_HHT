class PalletStackListModel {
  List<PalletDetailList>? palletDetailList;
  String? status;
  String? statusMessage;

  PalletStackListModel(
      {this.palletDetailList, this.status, this.statusMessage});

  PalletStackListModel.fromJson(Map<String, dynamic> json) {
    if (json['PalletDetailList'] != null) {
      palletDetailList = <PalletDetailList>[];
      json['PalletDetailList'].forEach((v) {
        palletDetailList!.add(new PalletDetailList.fromJson(v));
      });
    }
    status = json['Status'];
    statusMessage = json['StatusMessage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.palletDetailList != null) {
      data['PalletDetailList'] =
          this.palletDetailList!.map((v) => v.toJson()).toList();
    }
    data['Status'] = this.status;
    data['StatusMessage'] = this.statusMessage;
    return data;
  }
}

class PalletDetailList {
  String? uLDNo;
  int? uLDSeqNo;
  String? uldConditionCode;
  String? groupId;

  PalletDetailList({this.uLDNo, this.uLDSeqNo, this.uldConditionCode, this.groupId});

  PalletDetailList.fromJson(Map<String, dynamic> json) {
    uLDNo = json['ULDNo'];
    uLDSeqNo = json['ULDSeqNo'];
    uldConditionCode = json['ULDConditionCode'];
    groupId = json['GroupId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ULDNo'] = this.uLDNo;
    data['ULDSeqNo'] = this.uLDSeqNo;
    data['ULDConditionCode'] = this.uldConditionCode;
    data['GroupId'] = this.groupId;
    return data;
  }
}
