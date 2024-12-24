class VctDetails {
  int id;
  String vctrowid;
  String tokenNo;
  String status;
  String gateIn;
  String gateOut;
  String dockIn;
  String dockout;
  String door;
  int pieces;
  double weight;
  String driverName;
  String vehicleNo;

  VctDetails({
    required this.id,
    required this.vctrowid,
    required this.tokenNo,
    required this.status,
    required this.gateIn,
    required this.gateOut,
    required this.dockIn,
    required this.dockout,
    required this.door,
    required this.pieces,
    required this.weight,
    required this.driverName,
    required this.vehicleNo,
  });

  factory VctDetails.fromJson(Map<String, dynamic> json) => VctDetails(
    id: json["Id"],
    vctrowid: json["VCTROWID"],
    tokenNo: json["TokenNo"],
    status: json["Status"],
    gateIn: json["GateIn"],
    gateOut: json["GateOut"],
    dockIn: json["DockIn"],
    dockout: json["Dockout"],
    door: json["Door"],
    pieces: json["Pieces"],
    weight: json["Weight"],
    driverName: json["DriverName"],
    vehicleNo: json["VehicleNo"],
  );

  Map<String, dynamic> toJson() => {
    "Id": id,
    "VCTROWID": vctrowid,
    "TokenNo": tokenNo,
    "Status": status,
    "GateIn": gateIn,
    "GateOut": gateOut,
    "DockIn": dockIn,
    "Dockout": dockout,
    "Door": door,
    "Pieces": pieces,
    "Weight": weight,
    "DriverName": driverName,
    "VehicleNo": vehicleNo,
  };
}

class Door {
  String value;
  String door;

  Door({
    required this.value,
    required this.door,
  });

  factory Door.fromJson(Map<String, dynamic> json) => Door(
    value: json["Value"],
    door: json["Door"],
  );

  Map<String, dynamic> toJson() => {
    "Value": value,
    "Door": door,
  };
}