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
  String? parameterName;
  String? char;
  String? text;

  DesignationWiseSignatureSettingList(
      {this.parameterName, this.char, this.text});

  DesignationWiseSignatureSettingList.fromJson(Map<String, dynamic> json) {
    parameterName = json['ParameterName'];
    char = json['Char'];
    text = json['Text'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ParameterName'] = this.parameterName;
    data['Char'] = this.char;
    data['Text'] = this.text;
    return data;
  }
}
