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