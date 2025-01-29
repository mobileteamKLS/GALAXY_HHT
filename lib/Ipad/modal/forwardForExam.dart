class ForwardForExamData {
  String sequenceNumber;
  String loc;
  int nop;
  double weight;
  String status;
  String groupId;
  int examinationNop;
  int remainExaminationNop;

  ForwardForExamData({
    required this.sequenceNumber,
    required this.loc,
    required this.nop,
    required this.weight,
    required this.status,
    required this.groupId,
    required this.examinationNop,
    required this.remainExaminationNop,
  });

  factory ForwardForExamData.fromJson(Map<String, dynamic> json) => ForwardForExamData(
    sequenceNumber: json["SEQUENCE_NUMBER"],
    loc: json["LOC"],
    nop: json["NOP"],
    weight: json["WEIGHT"],
    status: json["Status"],
    groupId: json["GroupId"],
    examinationNop: json["ExaminationNOP"],
    remainExaminationNop: json["RemainExaminationNOP"],
  );

  Map<String, dynamic> toJson() => {
    "SEQUENCE_NUMBER": sequenceNumber,
    "LOC": loc,
    "NOP": nop,
    "WEIGHT": weight,
    "Status": status,
    "GroupId": groupId,
    "ExaminationNOP": examinationNop,
    "RemainExaminationNOP": remainExaminationNop,
  };
}

class OnHandShipReq {
  String awb;
  String hawb;
  int pieces;
  double weight;
  String commodity;
  int rfePieces;
  String remarks;
  int impShipRowId;

  OnHandShipReq({
    required this.awb,
    required this.hawb,
    required this.pieces,
    required this.weight,
    required this.commodity,
    required this.rfePieces,
    required this.remarks,
    required this.impShipRowId,
  });

  factory OnHandShipReq.fromJson(Map<String, dynamic> json) => OnHandShipReq(
    awb: json["AWB"],
    hawb: json["HAWB"],
    pieces: json["Pieces"],
    weight: json["Weight"],
    commodity: json["Commodity"],
    rfePieces: json["RFEPieces"],
    remarks: json["Remarks"],
    impShipRowId: json["IMPSHIPROWID"],
  );

  Map<String, dynamic> toJson() => {
    "AWB": awb,
    "HAWB": hawb,
    "Pieces": pieces,
    "Weight": weight,
    "Commodity": commodity,
    "RFEPieces": rfePieces,
    "Remarks": remarks,
    "IMPSHIPROWID": impShipRowId,
  };
}

class RemarksData {
  String keyValue;
  String description;

  RemarksData({
    required this.keyValue,
    required this.description,
  });

  factory RemarksData.fromJson(Map<String, dynamic> json) => RemarksData(
    keyValue: json["KeyValue"],
    description: json["DESCRIPTION"],
  );

  Map<String, dynamic> toJson() => {
    "KeyValue": keyValue,
    "DESCRIPTION": description,
  };
}