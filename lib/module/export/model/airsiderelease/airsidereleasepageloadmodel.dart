class AirsidePageLoadModel {
  String? isAirsideReleaseSignRequired;
  List<DesignationWiseSignatureSettingList>?
  designationWiseSignatureSettingList;
  String? status;
  String? statusMessage;

  AirsidePageLoadModel(
      {this.isAirsideReleaseSignRequired,
        this.designationWiseSignatureSettingList,
        this.status,
        this.statusMessage});

  AirsidePageLoadModel.fromJson(Map<String, dynamic> json) {
    isAirsideReleaseSignRequired = json['IsAirsideReleaseSignRequired'];
    if (json['DesignationWiseSignatureSettingList'] != null) {
      designationWiseSignatureSettingList =
      <DesignationWiseSignatureSettingList>[];
      json['DesignationWiseSignatureSettingList'].forEach((v) {
        designationWiseSignatureSettingList!
            .add(new DesignationWiseSignatureSettingList.fromJson(v));
      });
    }
    status = json['Status'];
    statusMessage = json['StatusMessage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['IsAirsideReleaseSignRequired'] = this.isAirsideReleaseSignRequired;
    if (this.designationWiseSignatureSettingList != null) {
      data['DesignationWiseSignatureSettingList'] = this
          .designationWiseSignatureSettingList!
          .map((v) => v.toJson())
          .toList();
    }
    data['Status'] = this.status;
    data['StatusMessage'] = this.statusMessage;
    return data;
  }
}

class DesignationWiseSignatureSettingList {
  String? description;
  String? code;
  int? priority;

  DesignationWiseSignatureSettingList(
      {this.description, this.code, this.priority});

  DesignationWiseSignatureSettingList.fromJson(Map<String, dynamic> json) {
    description = json['Description'];
    code = json['Code'];
    priority = json['Priority'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Description'] = this.description;
    data['Code'] = this.code;
    data['Priority'] = this.priority;
    return data;
  }
}
