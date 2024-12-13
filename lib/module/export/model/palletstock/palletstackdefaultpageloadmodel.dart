class PalletStackDefaultPageLoadModel {
  String? status;
  String? statusMessage;
  String? isPalletStackLocationRequired;

  PalletStackDefaultPageLoadModel(
      {this.status, this.statusMessage, this.isPalletStackLocationRequired});

  PalletStackDefaultPageLoadModel.fromJson(Map<String, dynamic> json) {
    status = json['Status'];
    statusMessage = json['StatusMessage'];
    isPalletStackLocationRequired = json['IsPalletStackLocationRequired'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Status'] = this.status;
    data['StatusMessage'] = this.statusMessage;
    data['IsPalletStackLocationRequired'] = this.isPalletStackLocationRequired;
    return data;
  }
}

