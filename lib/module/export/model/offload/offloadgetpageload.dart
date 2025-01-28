class OffloadGetPageLoad {
  List<OffloadReasonList>? offloadReasonList;
  int? isGroupBasedAcceptNumber;
  String? isGroupBasedAcceptChar;
  String? uLDGroupIdIsMandatory;
  String? defaultScanForExportOffloadChar;
  String? defaultScanForExportOffloadText;
  String? status;
  String? statusMessage;

  OffloadGetPageLoad(
      {this.offloadReasonList,
        this.isGroupBasedAcceptNumber,
        this.isGroupBasedAcceptChar,
        this.uLDGroupIdIsMandatory,
        this.defaultScanForExportOffloadChar,
        this.defaultScanForExportOffloadText,
        this.status,
        this.statusMessage});

  OffloadGetPageLoad.fromJson(Map<String, dynamic> json) {
    if (json['OffloadReasonList'] != null) {
      offloadReasonList = <OffloadReasonList>[];
      json['OffloadReasonList'].forEach((v) {
        offloadReasonList!.add(new OffloadReasonList.fromJson(v));
      });
    }
    isGroupBasedAcceptNumber = json['IsGroupBasedAcceptNumber'];
    isGroupBasedAcceptChar = json['IsGroupBasedAcceptChar'];
    uLDGroupIdIsMandatory = json['ULDGroupIdIsMandatory'];
    defaultScanForExportOffloadChar = json['DefaultScanForExportOffloadChar'];
    defaultScanForExportOffloadText = json['DefaultScanForExportOffloadText'];
    status = json['Status'];
    statusMessage = json['StatusMessage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.offloadReasonList != null) {
      data['OffloadReasonList'] =
          this.offloadReasonList!.map((v) => v.toJson()).toList();
    }
    data['IsGroupBasedAcceptNumber'] = this.isGroupBasedAcceptNumber;
    data['IsGroupBasedAcceptChar'] = this.isGroupBasedAcceptChar;
    data['ULDGroupIdIsMandatory'] = this.uLDGroupIdIsMandatory;
    data['DefaultScanForExportOffloadChar'] =
        this.defaultScanForExportOffloadChar;
    data['DefaultScanForExportOffloadText'] =
        this.defaultScanForExportOffloadText;
    data['Status'] = this.status;
    data['StatusMessage'] = this.statusMessage;
    return data;
  }
}

class OffloadReasonList {
  String? referenceDataIdentifier;
  String? referenceDescription;

  OffloadReasonList({this.referenceDataIdentifier, this.referenceDescription});

  OffloadReasonList.fromJson(Map<String, dynamic> json) {
    referenceDataIdentifier = json['ReferenceDataIdentifier'];
    referenceDescription = json['ReferenceDescription'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ReferenceDataIdentifier'] = this.referenceDataIdentifier;
    data['ReferenceDescription'] = this.referenceDescription;
    return data;
  }
}
