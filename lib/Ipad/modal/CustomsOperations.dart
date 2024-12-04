
class CustomExamination {
  int rowId;
  int messageRowId;
  int queueRowId;
  int elementRowId;
  String elementGuid;
  String col1;
  String col2;
  String col3;
  String col4;
  String col5;
  String col6;
  String col7;
  String col8;

  CustomExamination({
    required this.rowId,
    required this.messageRowId,
    required this.queueRowId,
    required this.elementRowId,
    required this.elementGuid,
    required this.col1,
    required this.col2,
    required this.col3,
    required this.col4,
    required this.col5,
    required this.col6,
    required this.col7,
    required this.col8,
  });

  factory CustomExamination.fromJSON(Map<String, dynamic> json) => CustomExamination(
    rowId: json["ROWId"],
    messageRowId: json["MessageRowID"],
    queueRowId: json["QueueRowId"],
    elementRowId: json["ElementRowID"],
    elementGuid: json["ElementGUID"],
    col1: json["Col1"],
    col2: json["Col2"],
    col3: json["Col3"],
    col4: json["Col4"],
    col5: json["Col5"],
    col6: json["Col6"],
    col7: json["Col7"],
    col8: json["Col8"],
  );

  Map<String, dynamic> toJson() => {
    "ROWId": rowId,
    "MessageRowID": messageRowId,
    "QueueRowId": queueRowId,
    "ElementRowID": elementRowId,
    "ElementGUID": elementGuid,
    "Col1": col1,
    "Col2": col2,
    "Col3": col3,
    "Col4": col4,
    "Col5": col5,
    "Col6": col6,
    "Col7": col7,
    "Col8": col8,
  };
}