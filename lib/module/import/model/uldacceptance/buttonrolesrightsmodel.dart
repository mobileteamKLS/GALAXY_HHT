class ButtonRolesRightsModel {
  List<ButtonRight>? buttonRight;
  String? status;
  String? statusMessage;

  ButtonRolesRightsModel({this.buttonRight, this.status, this.statusMessage});

  ButtonRolesRightsModel.fromJson(Map<String, dynamic> json) {
    if (json['ButtonRight'] != null) {
      buttonRight = <ButtonRight>[];
      json['ButtonRight'].forEach((v) {
        buttonRight!.add(new ButtonRight.fromJson(v));
      });
    }
    status = json['Status'];
    statusMessage = json['StatusMessage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.buttonRight != null) {
      data['ButtonRight'] = this.buttonRight!.map((v) => v.toJson()).toList();
    }
    data['Status'] = this.status;
    data['StatusMessage'] = this.statusMessage;
    return data;
  }
}

class ButtonRight {
  String? buttonId;
  String? buttonName;
  String? isEnable;

  ButtonRight({this.buttonId, this.buttonName, this.isEnable});

  ButtonRight.fromJson(Map<String, dynamic> json) {
    buttonId = json['ButtonId'];
    buttonName = json['ButtonName'];
    isEnable = json['IsEnable'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ButtonId'] = this.buttonId;
    data['ButtonName'] = this.buttonName;
    data['IsEnable'] = this.isEnable;
    return data;
  }
}
