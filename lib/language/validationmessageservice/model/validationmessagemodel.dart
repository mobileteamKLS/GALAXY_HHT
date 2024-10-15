class ValidationMessageModel {
  List<CultureMessage>? cultureMessage;
  String? status;
  String? statusMessage;

  ValidationMessageModel(
      {
        this.cultureMessage,
        this.status,
        this.statusMessage});

  ValidationMessageModel.fromJson(Map<String, dynamic> json) {
    if (json['CultureMessage'] != null) {
      cultureMessage = <CultureMessage>[];
      json['CultureMessage'].forEach((v) {
        cultureMessage!.add(new CultureMessage.fromJson(v));
      });
    }
    status = json['Status'];
    statusMessage = json['StatusMessage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.cultureMessage != null) {
      data['CultureMessage'] =
          this.cultureMessage!.map((v) => v.toJson()).toList();
    }
    data['Status'] = this.status;
    data['StatusMessage'] = this.statusMessage;
    return data;
  }
}

class CultureMessage {
  String? messageCode;
  String? message;

  CultureMessage({this.messageCode, this.message});

  CultureMessage.fromJson(Map<String, dynamic> json) {
    messageCode = json['MessageCode'];
    message = json['Message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['MessageCode'] = this.messageCode;
    data['Message'] = this.message;
    return data;
  }
}
