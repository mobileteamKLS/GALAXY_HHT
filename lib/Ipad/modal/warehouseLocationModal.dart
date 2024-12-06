class WarehouseLocationShipmentList {
  String impawbrowid;
  String impshiprowid;
  String shipmentNumber;
  String flightNo;
  String sta;
  dynamic rotationNo;
  String shc;
  String commodity;
  double volume;
  int inWhnop;
  int npr;
  double weight;
  String nog;
  String prepareForDelivery;
  int seizeNop;
  double seizeWt;
  int nopPreDel;
  double wtPreDel;
  int nopDel;
  double wtDel;
  String isWdoWoBill;
  String isHold;
  int npx;
  String detentionNo;
  String expectedZone;

  WarehouseLocationShipmentList({
    required this.impawbrowid,
    required this.impshiprowid,
    required this.shipmentNumber,
    required this.flightNo,
    required this.sta,
    required this.rotationNo,
    required this.shc,
    required this.commodity,
    required this.volume,
    required this.inWhnop,
    required this.npr,
    required this.weight,
    required this.nog,
    required this.prepareForDelivery,
    required this.seizeNop,
    required this.seizeWt,
    required this.nopPreDel,
    required this.wtPreDel,
    required this.nopDel,
    required this.wtDel,
    required this.isWdoWoBill,
    required this.isHold,
    required this.npx,
    required this.detentionNo,
    required this.expectedZone,
  });

  factory WarehouseLocationShipmentList.fromJson(Map<String, dynamic> json) => WarehouseLocationShipmentList(
    impawbrowid: json["IMPAWBROWID"],
    impshiprowid: json["IMPSHIPROWID"],
    shipmentNumber: json["SHIPMENT_NUMBER"],
    flightNo: json["FlightNo"],
    sta: json["STA"],
    rotationNo: json["RotationNo"],
    shc: json["SHC"],
    commodity: json["Commodity"],
    volume: json["Volume"],
    inWhnop: json["InWHNOP"],
    npr: json["NPR"],
    weight: json["Weight"],
    nog: json["NOG"],
    prepareForDelivery: json["PrepareForDelivery"],
    seizeNop: json["SeizeNOP"],
    seizeWt: json["SeizeWt"],
    nopPreDel: json["NOPPreDel"],
    wtPreDel: json["WtPreDel"],
    nopDel: json["NOPDel"],
    wtDel: json["WtDel"],
    isWdoWoBill: json["IsWdoWOBill"],
    isHold: json["IsHold"],
    npx: json["NPX"],
    detentionNo: json["DetentionNo"],
    expectedZone: json["ExpectedZone"],
  );

  Map<String, dynamic> toJson() => {
    "IMPAWBROWID": impawbrowid,
    "IMPSHIPROWID": impshiprowid,
    "SHIPMENT_NUMBER": shipmentNumber,
    "FlightNo": flightNo,
    "STA": sta,
    "RotationNo": rotationNo,
    "SHC": shc,
    "Commodity": commodity,
    "Volume": volume,
    "InWHNOP": inWhnop,
    "NPR": npr,
    "Weight": weight,
    "NOG": nog,
    "PrepareForDelivery": prepareForDelivery,
    "SeizeNOP": seizeNop,
    "SeizeWt": seizeWt,
    "NOPPreDel": nopPreDel,
    "WtPreDel": wtPreDel,
    "NOPDel": nopDel,
    "WtDel": wtDel,
    "IsWdoWOBill": isWdoWoBill,
    "IsHold": isHold,
    "NPX": npx,
    "DetentionNo": detentionNo,
    "ExpectedZone": expectedZone,
  };
}

class WarehouseLocationList {
  String sequenceNumber;
  String locCode;
  int nop;
  double weight;
  dynamic whInTime;
  dynamic whOutTime;
  String groupId;
  int isid;
  int iwSeqNo;

  WarehouseLocationList({
    required this.sequenceNumber,
    required this.locCode,
    required this.nop,
    required this.weight,
    required this.whInTime,
    required this.whOutTime,
    required this.groupId,
    required this.isid,
    required this.iwSeqNo,
  });

  factory WarehouseLocationList.fromJson(Map<String, dynamic> json) => WarehouseLocationList(
    sequenceNumber: json["SEQUENCE_NUMBER"],
    locCode: json["LocCode"],
    nop: json["NOP"],
    weight: json["WEIGHT"],
    whInTime: DateTime.parse(json["WHInTime"]),
    whOutTime: json["WHOutTime"],
    groupId: json["GroupId"],
    isid: json["ISID"],
    iwSeqNo: json["IWSeqNo"],
  );

  Map<String, dynamic> toJson() => {
    "SEQUENCE_NUMBER": sequenceNumber,
    "LocCode": locCode,
    "NOP": nop,
    "WEIGHT": weight,
    "WHInTime": whInTime.toIso8601String(),
    "WHOutTime": whOutTime,
    "GroupId": groupId,
    "ISID": isid,
    "IWSeqNo": iwSeqNo,
  };
}