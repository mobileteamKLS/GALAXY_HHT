class WarehouseBaseStationBranch {
  int organizationId;
  String orgName;
  int organizationBranchId;
  String orgBranchName;

  WarehouseBaseStationBranch({
    required this.organizationId,
    required this.orgName,
    required this.organizationBranchId,
    required this.orgBranchName,
  });

  factory WarehouseBaseStationBranch.fromJson(Map<String, dynamic> json) =>
      WarehouseBaseStationBranch(
        organizationId:
        json["OrganizationId"] == null ? 0 : json["OrganizationId"],
        orgName: json["OrgName"] == null ? "" : json["OrgName"],
        organizationBranchId: json["OrganizationBranchId"] == null
            ? 0
            : json["OrganizationBranchId"],
        orgBranchName:
        json["OrgBranchName"] == null ? "" : json["OrgBranchName"],
      );

  Map<String, dynamic> toMap() => {
    "OrganizationId": organizationId,
    "OrgName": orgName,
    "OrganizationBranchId": organizationBranchId,
    "OrgBranchName": orgBranchName,
  };

  @override
  String toString() {
    return "Data--$organizationId--$orgName--$organizationBranchId--$orgBranchName";
  }
}

class WarehouseTerminals {
  final int custudian;
  final String custodianName;
  final bool iswalkinEnable;

  WarehouseTerminals({
    required this.custudian,
    required this.custodianName,
    required this.iswalkinEnable,
  });

  factory WarehouseTerminals.fromJson(Map<String, dynamic> json) {
    return WarehouseTerminals(
      custodianName: json['CustodianName'] == null ? "" : json['CustodianName'],
      custudian: json['CUSTODIAN'] == null ? 0 : json['CUSTODIAN'],
      iswalkinEnable:
      json['IswalkinEnable'] == null ? false : json['IswalkinEnable'],
    );
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["CUSTODIAN"] = custudian;
    map["CustodianName"] = custodianName;
    map["IswalkinEnable"] = iswalkinEnable;
    return map;
  }

  @override
  String toString() {
    return "-- $custudian -- $custodianName -- $iswalkinEnable --";
  }
}

class WarehouseBaseStation {
  String organizationId;
  String orgName;
  int cityid;
  String airportcode;

  WarehouseBaseStation({
    required this.organizationId,
    required this.orgName,
    required this.cityid,
    required this.airportcode,
  });

  factory WarehouseBaseStation.fromJson(Map<String, dynamic> json) =>
      WarehouseBaseStation(
        organizationId:
        json["OrganizationId"] == null ? "" : json["OrganizationId"].toString(),
        orgName: json["OrgName"] == null ? "" : json["OrgName"],
        cityid: json["cityid"] == null ? 0 : json["cityid"],
        airportcode: json["airportcode"] == null ? "" : json["airportcode"],
      );

  Map<String, dynamic> toMap() => {
    "OrganizationId": organizationId,
    "OrgName": orgName,
    "cityid": cityid,
    "airportcode": airportcode,
  };
}

class VtDetails {
  final String mode;
  final String slotDate;
  final String timeStart;
  final String timeEnd;
  final String tokenNo;
  final String vehicleRegNo;
  final String driverName;
  final String driverNumber;
  bool isChecked;

  VtDetails({
    required this.mode,
    required this.slotDate,
    required this.timeStart,
    required this.timeEnd,
    required this.tokenNo,
    required this.vehicleRegNo,
    required this.driverName,
    required this.driverNumber,
    this.isChecked = false,
  });

  factory VtDetails.fromVTJson(Map<String, dynamic> json) {
    return VtDetails(
      mode: json["Mode"] ?? "",
      slotDate: json["SlotDate"] ?? "",
      timeStart: json["TimeStart"] ?? "",
      timeEnd: json["TimeEnd"] ?? "",
      tokenNo: json["VTNo"] ?? "",
      vehicleRegNo: json["VehicleNo"] ?? "",
      driverName: json["DRIVERNAME"] ?? "",
      driverNumber: json["DRIVERMOBILENO"] ?? "",
    );
  }

  factory VtDetails.fromVehicleNoJson(Map<String, dynamic> json) {
    return VtDetails(
      mode: json["Mode"] ?? "",
      slotDate: json["SlotDate"] ?? "",
      timeStart: json["TimeStart"] ?? "",
      timeEnd: json["TimeEnd"] ?? "",
      tokenNo: json["VTNo"] ?? "",
      vehicleRegNo: json["VehicleRegNo"] ?? "",
      driverName: json["DriverName"] ?? "",
      driverNumber: json["DriverNumber"] ?? "",
    );
  }
}


// class VtDetails {
//   String mode;
//   String vtNo;
//   String vehicleNo;
//   String drivername;
//   String drivermobileno;
//   String slotDate;
//   String timeStart;
//   String timeEnd;
//
//   VtDetails({
//     required this.mode,
//     required this.vtNo,
//     required this.vehicleNo,
//     required this.drivername,
//     required this.drivermobileno,
//     required this.slotDate,
//     required this.timeStart,
//     required this.timeEnd,
//   });
//
//   factory VtDetails.fromJson(Map<String, dynamic> json) => VtDetails(
//     mode: json["Mode"],
//     vtNo: json["VTNo"],
//     vehicleNo: json["VehicleNo"],
//     drivername: json["DRIVERNAME"],
//     drivermobileno: json["DRIVERMOBILENO"],
//     slotDate: json["SlotDate"],
//     timeStart: json["TimeStart"],
//     timeEnd: json["TimeEnd"],
//   );
//
//   Map<String, dynamic> toJson() => {
//     "Mode": mode,
//     "VTNo": vtNo,
//     "VehicleNo": vehicleNo,
//     "DRIVERNAME": drivername,
//     "DRIVERMOBILENO": drivermobileno,
//     "SlotDate": slotDate,
//     "TimeStart": timeStart,
//     "TimeEnd": timeEnd,
//   };
// }
//
// class WalInTokenDetails {
//   final String Mode;
//   final String SlotDate;
//   final String TimeStart;
//   final String TimeEnd;
//   final String TokenNo;
//   final String VehicleRegNo;
//   final String DriverName;
//   final String DriverNumber;
//   bool isChecked = false;
//
//   WalInTokenDetails({
//     required this.Mode,
//     required this.SlotDate,
//     required this.TimeStart,
//     required this.TimeEnd,
//     required this.TokenNo,
//     required this.VehicleRegNo,
//     required this.DriverName,
//     required this.DriverNumber,
//   });
//
//   factory WalInTokenDetails.fromJson(Map<String, dynamic> json) {
//     return WalInTokenDetails(
//       Mode: json['Mode'] == null ? "" : json['Mode'],
//       SlotDate: json['SlotDate'] == null ? "" : json['SlotDate'],
//       TimeStart: json['TimeStart'] == null ? "" : json['TimeStart'],
//       TimeEnd: json['TimeEnd'] == null ? "" : json['TimeEnd'],
//       TokenNo: json['VTNo'] == null ? "" : json['VTNo'],
//       VehicleRegNo: json['VehicleRegNo'] == null ? "" : json['VehicleRegNo'],
//       DriverName: json['DRIVERNAME'] == null ? "" : json['DRIVERNAME'],
//       DriverNumber: json['DRIVERMOBILENO'] == null ? "" : json['DRIVERMOBILENO'],
//     );
//   }
//
//   Map toMap() {
//     var map = new Map<String, dynamic>();
//     map["Mode"] = Mode;
//     map["SlotDate"] = SlotDate;
//     map["TimeStart"] = TimeStart;
//     map["TimeEnd"] = TimeEnd;
//     map["VTNo"] = TokenNo;
//     map["VehicleRegNo"] = VehicleRegNo;
//     map["DRIVERNAME"] = DriverName;
//     map["DRIVERMOBILENO"] = DriverNumber;
//     map["isChecked"] = isChecked;
//     return map;
//   }
// }