class BuildUpGroupModel {
  List<BuildUpAWBGroupList>? buildUpAWBGroupList;
  String? status;
  String? statusMessage;

  BuildUpGroupModel(
      {this.buildUpAWBGroupList, this.status, this.statusMessage});

  BuildUpGroupModel.fromJson(Map<String, dynamic> json) {
    if (json['BuildUpAWBGroupList'] != null) {
      buildUpAWBGroupList = <BuildUpAWBGroupList>[];
      json['BuildUpAWBGroupList'].forEach((v) {
        buildUpAWBGroupList!.add(new BuildUpAWBGroupList.fromJson(v));
      });
    }
    status = json['Status'];
    statusMessage = json['StatusMessage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.buildUpAWBGroupList != null) {
      data['BuildUpAWBGroupList'] =
          this.buildUpAWBGroupList!.map((v) => v.toJson()).toList();
    }
    data['Status'] = this.status;
    data['StatusMessage'] = this.statusMessage;
    return data;
  }
}

class BuildUpAWBGroupList {
  int? grpSeqNo;
  String? groupId;
  int? nop;
  double? weight;

  BuildUpAWBGroupList({this.grpSeqNo, this.groupId, this.nop, this.weight});

  BuildUpAWBGroupList.fromJson(Map<String, dynamic> json) {
    grpSeqNo = json['GroupSeqNo'];
    groupId = json['GroupId'];
    nop = json['Nop'];
    weight = json['Weight'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['GroupSeqNo'] = this.grpSeqNo;
    data['GroupId'] = this.groupId;
    data['Nop'] = this.nop;
    data['Weight'] = this.weight;
    return data;
  }
}
