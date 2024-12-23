class UnloadUldListModel {
  List<UldList>? uldList;
  String? status;
  String? statusMessage;

  UnloadUldListModel({this.uldList, this.status, this.statusMessage});

  UnloadUldListModel.fromJson(Map<String, dynamic> json) {
    if (json['uldList'] != null) {
      uldList = <UldList>[];
      json['uldList'].forEach((v) {
        uldList!.add(new UldList.fromJson(v));
      });
    }
    status = json['Status'];
    statusMessage = json['StatusMessage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.uldList != null) {
      data['uldList'] = this.uldList!.map((v) => v.toJson()).toList();
    }
    data['Status'] = this.status;
    data['StatusMessage'] = this.statusMessage;
    return data;
  }
}

class UldList {
  String? uLDNo;
  String? status;
  String? flightNo;
  String? flightDate;
  String? location;

  UldList(
      {this.uLDNo, this.status, this.flightNo, this.flightDate, this.location});

  UldList.fromJson(Map<String, dynamic> json) {
    uLDNo = json['ULDNo'];
    status = json['status'];
    flightNo = json['flightNo'];
    flightDate = json['flightDate'];
    location = json['location'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ULDNo'] = this.uLDNo;
    data['status'] = this.status;
    data['flightNo'] = this.flightNo;
    data['flightDate'] = this.flightDate;
    data['location'] = this.location;
    return data;
  }
}
