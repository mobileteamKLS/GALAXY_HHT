class AWBModel {
  List<AWBItem>? awbItemList;
  String? status;
  String? statusMessage;

  AWBModel(
      {
        this.awbItemList,
        this.status,
        this.statusMessage});

  AWBModel.fromJson(Map<String, dynamic> json) {
    if (json['AWBItem'] != null) {
      awbItemList = <AWBItem>[];
      json['AWBItem'].forEach((v) {
        awbItemList!.add(new AWBItem.fromJson(v));
      });
    }
    status = json['Status'];
    statusMessage = json['StatusMessage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.awbItemList != null) {
      data['AWBItem'] = this.awbItemList!.map((v) => v.toJson()).toList();
    }
    data['Status'] = this.status;
    data['StatusMessage'] = this.statusMessage;
    return data;
  }
}

class AWBItem {
  int? id;
  String? awbNo;
  String? SHCCode;
  String? agentName;
  String? remark;
  int? manifestedPices;
  int? receivedPices;
  int? weightManifest;
  int? weightReceived;
  int? damge;
  int? short;
  int? excess;
  int? progress;
  String? HAWB;


  AWBItem(
      {this.id,
        this.awbNo,
        this.SHCCode,
        this.agentName,
        this.remark,
        this.manifestedPices,
        this.receivedPices,
        this.weightManifest,
        this.weightReceived,
        this.damge,
        this.short,
        this.excess,
        this.progress,
        this.HAWB});

  AWBItem.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    awbNo = json['awbNo'];
    SHCCode = json['SHCCode'];
    agentName = json['agentName'];
    remark = json['remark'];
    manifestedPices = json['manifestedPices'];
    receivedPices = json['receivedPices'];
    weightManifest = json['weightManifest'];
    weightReceived = json['weightReceived'];
    damge = json['damge'];
    short = json['short'];
    excess = json['excess'];
    progress = json['progress'];
    HAWB = json['HAWB'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['awbNo'] = this.awbNo;
    data['SHCCode'] = this.SHCCode;
    data['agentName'] = this.agentName;
    data['remark'] = this.remark;
    data['manifestedPices'] = this.manifestedPices;
    data['receivedPices'] = this.receivedPices;
    data['weightManifest'] = this.weightManifest;
    data['weightReceived'] = this.weightReceived;
    data['damge'] = this.damge;
    data['short'] = this.short;
    data['excess'] = this.excess;
    data['progress'] = this.progress;
    data['HAWB'] = this.HAWB;
    return data;
  }
}

