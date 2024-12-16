class RetriveULDPageLoadModel {
  List<ULDTypeList>? uLDTypeList;
  String? status;
  String? statusMessage;

  RetriveULDPageLoadModel({this.uLDTypeList, this.status, this.statusMessage});

  RetriveULDPageLoadModel.fromJson(Map<String, dynamic> json) {
    if (json['ULDTypeList'] != null) {
      uLDTypeList = <ULDTypeList>[];
      json['ULDTypeList'].forEach((v) {
        uLDTypeList!.add(new ULDTypeList.fromJson(v));
      });
    }
    status = json['Status'];
    statusMessage = json['StatusMessage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.uLDTypeList != null) {
      data['ULDTypeList'] = this.uLDTypeList!.map((v) => v.toJson()).toList();
    }
    data['Status'] = this.status;
    data['StatusMessage'] = this.statusMessage;
    return data;
  }
}

class ULDTypeList {
  String? uLDType;
  int? uLDCount;

  ULDTypeList({this.uLDType, this.uLDCount});

  ULDTypeList.fromJson(Map<String, dynamic> json) {
    uLDType = json['ULDType'];
    uLDCount = json['ULDCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ULDType'] = this.uLDType;
    data['ULDCount'] = this.uLDCount;
    return data;
  }
}
