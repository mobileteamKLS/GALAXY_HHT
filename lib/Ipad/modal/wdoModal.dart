
class WdoSearchResult {
  String wdoNo;
  String wdoSeqNo;
  String rNo;
  String awbNumber;
  String houseNumber;
  String flightDetails;
  int npr;
  double wtRec;
  int totWdonop;
  int totSeizeNop;
  int locatedNop;
  String customRefNo;
  String pfdDateTime;
  String outWhDateTime;
  String reWhDateTime;
  String releasedDateTime;
  int deliveredWdonop;
  String invoiceNo;
  String customInfoStatus;
  String isTransit;
  String status;
  int isActive;
  String impShipRowId;

  WdoSearchResult({
    required this.wdoNo,
    required this.wdoSeqNo,
    required this.rNo,
    required this.awbNumber,
    required this.houseNumber,
    required this.flightDetails,
    required this.npr,
    required this.wtRec,
    required this.totWdonop,
    required this.totSeizeNop,
    required this.locatedNop,
    required this.customRefNo,
    required this.pfdDateTime,
    required this.outWhDateTime,
    required this.reWhDateTime,
    required this.releasedDateTime,
    required this.deliveredWdonop,
    required this.invoiceNo,
    required this.customInfoStatus,
    required this.isTransit,
    required this.status,
    required this.isActive,
    required this.impShipRowId,
  });

  factory WdoSearchResult.fromJSON(Map<String, dynamic> json) => WdoSearchResult(
    wdoNo: json["WDO_NO"],
    wdoSeqNo: json["WdSeqno"],
    rNo: json["RNo"],
    awbNumber: json["AWB_NUMBER"],
    houseNumber: json["HOUSE_NUMBER"],
    flightDetails: json["FlightDetails"],
    npr: json["NPR"],
    wtRec: json["WtRec"],
    totWdonop: json["TotWDONOP"],
    totSeizeNop: json["TotSeizeNOP"],
    locatedNop: json["LocatedNOP"],
    customRefNo: json["CustomRefNo"],
    pfdDateTime: json["PFDDateTime"],
    outWhDateTime: json["OutWHDateTime"],
    reWhDateTime: json["ReWHDateTime"],
    releasedDateTime: json["ReleasedDateTime"],
    deliveredWdonop: json["DeliveredWDONOP"],
    invoiceNo: json["InvoiceNo"],
    customInfoStatus: json["CustomInfoStatus"],
    isTransit: json["IsTransit"],
    status: json["Status"],
    isActive: json["IsActive"],
    impShipRowId: json["IMPSHIPROWID"],
  );

  Map<String, dynamic> toJson() => {
    "WDO_NO": wdoNo,
    "RNo": rNo,
    "AWB_NUMBER": awbNumber,
    "HOUSE_NUMBER": houseNumber,
    "FlightDetails": flightDetails,
    "NPR": npr,
    "WtRec": wtRec,
    "TotWDONOP": totWdonop,
    "TotSeizeNOP": totSeizeNop,
    "LocatedNOP": locatedNop,
    "CustomRefNo": customRefNo,
    "PFDDateTime": pfdDateTime,
    "OutWHDateTime": outWhDateTime,
    "ReWHDateTime": reWhDateTime,
    "ReleasedDateTime": releasedDateTime,
    "DeliveredWDONOP": deliveredWdonop,
    "InvoiceNo": invoiceNo,
    "CustomInfoStatus": customInfoStatus,
    "IsTransit": isTransit,
    "Status": status,
    "IsActive": isActive,
  };
}