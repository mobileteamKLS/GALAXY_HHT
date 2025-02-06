class ShipmentDamageGetPageLoad {
  int? isGroupBasedAcceptNumber;
  String? isGroupBasedAcceptChar;
  String? status;
  String? statusMessage;

  ShipmentDamageGetPageLoad(
      {
        this.isGroupBasedAcceptNumber,
        this.isGroupBasedAcceptChar,
        this.status,
        this.statusMessage});

  ShipmentDamageGetPageLoad.fromJson(Map<String, dynamic> json) {

    isGroupBasedAcceptNumber = json['IsGroupBasedAcceptNumber'];
    isGroupBasedAcceptChar = json['IsGroupBasedAcceptChar'];
    status = json['Status'];
    statusMessage = json['StatusMessage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['IsGroupBasedAcceptNumber'] = this.isGroupBasedAcceptNumber;
    data['IsGroupBasedAcceptChar'] = this.isGroupBasedAcceptChar;
    data['Status'] = this.status;
    data['StatusMessage'] = this.statusMessage;
    return data;
  }
}

