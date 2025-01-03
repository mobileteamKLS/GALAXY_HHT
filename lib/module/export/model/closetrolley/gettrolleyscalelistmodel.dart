class GetTrolleyScaleListModel {
  TrolleyScaleWeightDetail? trolleyScaleWeightDetail;
  String? status;
  String? statusMessage;

  GetTrolleyScaleListModel(
      {this.trolleyScaleWeightDetail, this.status, this.statusMessage});

  GetTrolleyScaleListModel.fromJson(Map<String, dynamic> json) {
    trolleyScaleWeightDetail = json['TrolleyScaleWeightDetail'] != null
        ? new TrolleyScaleWeightDetail.fromJson(
        json['TrolleyScaleWeightDetail'])
        : null;
    status = json['Status'];
    statusMessage = json['StatusMessage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.trolleyScaleWeightDetail != null) {
      data['TrolleyScaleWeightDetail'] =
          this.trolleyScaleWeightDetail!.toJson();
    }
    data['Status'] = this.status;
    data['StatusMessage'] = this.statusMessage;
    return data;
  }
}

class TrolleyScaleWeightDetail {
  double? scaleWeight;

  TrolleyScaleWeightDetail({this.scaleWeight});

  TrolleyScaleWeightDetail.fromJson(Map<String, dynamic> json) {
    scaleWeight = json['ScaleWeight'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ScaleWeight'] = this.scaleWeight;
    return data;
  }
}
