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