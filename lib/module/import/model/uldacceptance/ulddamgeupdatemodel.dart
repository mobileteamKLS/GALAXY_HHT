
class UldDamageUpdatetModel {
  String? status;
  String? statusMessage;
  ULDProblem? uLDProblem;
  List<EdocketMaster>? edocketMaster;

  UldDamageUpdatetModel(
      {this.status, this.statusMessage, this.uLDProblem, this.edocketMaster});

  UldDamageUpdatetModel.fromJson(Map<String, dynamic> json) {
    status = json['Status'];
    statusMessage = json['StatusMessage'];
    uLDProblem = json['ULDProblem'] != null
        ? new ULDProblem.fromJson(json['ULDProblem'])
        : null;
    if (json['EdocketMaster'] != null) {
      edocketMaster = <EdocketMaster>[];
      json['EdocketMaster'].forEach((v) {
        edocketMaster!.add(new EdocketMaster.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Status'] = this.status;
    data['StatusMessage'] = this.statusMessage;
    if (this.uLDProblem != null) {
      data['ULDProblem'] = this.uLDProblem!.toJson();
    }
    if (this.edocketMaster != null) {
      data['EdocketMaster'] =
          this.edocketMaster!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ULDProblem {
  int? rowId;
  int? uLDSeqNo;
  String? uLDConditionCode;
  String? damageCode;
  String? remarks;

  ULDProblem(
      {this.rowId,
        this.uLDSeqNo,
        this.uLDConditionCode,
        this.damageCode,
        this.remarks});

  ULDProblem.fromJson(Map<String, dynamic> json) {
    rowId = json['RowId'];
    uLDSeqNo = json['ULDSeqNo'];
    uLDConditionCode = json['ULDConditionCode'];
    damageCode = json['DamageCode'];
    remarks = json['Remarks'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['RowId'] = this.rowId;
    data['ULDSeqNo'] = this.uLDSeqNo;
    data['ULDConditionCode'] = this.uLDConditionCode;
    data['DamageCode'] = this.damageCode;
    data['Remarks'] = this.remarks;
    return data;
  }
}

class EdocketMaster {
  String? fileName;
 // Uint8List? binaryFile;
  String? binaryFile;
  String? base64Image;

  EdocketMaster({this.fileName, this.binaryFile, this.base64Image});

  EdocketMaster.fromJson(Map<String, dynamic> json) {
    fileName = json['FileName'];
    // Decode base64 string to Uint8List if the binaryFile is encoded
   // binaryFile = json['BinaryFile'] != null ? base64Decode(json['BinaryFile']) : null;
    binaryFile = json['BinaryFile'];
    base64Image = json['Base64Image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['FileName'] = this.fileName;
    // Encode Uint8List to base64 string for json
   // data['BinaryFile'] = this.binaryFile != null ? base64Encode(this.binaryFile!) : null;
    data['BinaryFile'] = this.binaryFile;
    data['Base64Image'] = this.base64Image;
    return data;
  }
}
