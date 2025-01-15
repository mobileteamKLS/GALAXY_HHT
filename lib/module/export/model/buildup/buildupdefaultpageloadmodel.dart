class BuildUpDefaultPageLoadModel {
  String? status;
  String? statusMessage;
  String? IsBulkLoad;

  BuildUpDefaultPageLoadModel(
      {this.status, this.statusMessage, this.IsBulkLoad});

  BuildUpDefaultPageLoadModel.fromJson(Map<String, dynamic> json) {
    status = json['Status'];
    statusMessage = json['StatusMessage'];
    IsBulkLoad = json['IsBulkLoad'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Status'] = this.status;
    data['StatusMessage'] = this.statusMessage;
    data['IsBulkLoad'] = this.IsBulkLoad;
    return data;
  }
}

