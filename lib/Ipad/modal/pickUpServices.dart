class PickUpRequestMasterData {
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

  PickUpRequestMasterData({
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

  factory PickUpRequestMasterData.fromJson(Map<String, dynamic> json) => PickUpRequestMasterData(
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

class PickUpRequestData {
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
  String? slot;
  String? assignTo;

  PickUpRequestData({
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
    this.slot,
    this.assignTo,
  });

  factory PickUpRequestData.fromJSON(Map<String, dynamic> json) => PickUpRequestData(
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

class SchedulePickUpMasterData {
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
  String col9;

  SchedulePickUpMasterData({
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
    required this.col9,
  });

  factory SchedulePickUpMasterData.fromJson(Map<String, dynamic> json) => SchedulePickUpMasterData(
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
    col9: json["Col9"],
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
    "Col9": col9,
  };
}

class SchedulePickUpData {
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
  String col9;
  String? slot;

  SchedulePickUpData({
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
    required this.col9,
    this.slot,
  });

  factory SchedulePickUpData.fromJSON(Map<String, dynamic> json) => SchedulePickUpData(
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
    col9: json["Col9"],
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
    "Col9": col9,
  };
}

class PickUpData {
  int rowId;
  String awbNumber;
  String houseNo;
  int pieces;
  double weight;
  String agent;
  int queueRowId;
  int messageRowId;
  int elementRowId;
  String status;
  String pickedUpStatus;

  PickUpData({
    required this.rowId,
    required this.awbNumber,
    required this.houseNo,
    required this.pieces,
    required this.weight,
    required this.agent,
    required this.queueRowId,
    required this.messageRowId,
    required this.elementRowId,
    required this.status,
    required this.pickedUpStatus,
  });

  factory PickUpData.fromJson(Map<String, dynamic> json) => PickUpData(
    rowId: json["RowId"],
    awbNumber: json["AWBNumber"],
    houseNo: json["HouseNo"],
    pieces: json["Pieces"],
    weight: json["Weight"],
    agent: json["Agent"],
    queueRowId: json["QueueRowID"],
    messageRowId: json["MessageRowID"],
    elementRowId: json["ElementRowID"],
    status: json["Status"],
    pickedUpStatus: json["PickedUpStatus"],
  );

  Map<String, dynamic> toJson() => {
    "RowId": rowId,
    "AWBNumber": awbNumber,
    "HouseNo": houseNo,
    "Pieces": pieces,
    "Weight": weight,
    "Agent": agent,
    "QueueRowID": queueRowId,
    "MessageRowID": messageRowId,
    "ElementRowID": elementRowId,
    "Status": status,
    "PickedUpStatus": pickedUpStatus,
  };
}
