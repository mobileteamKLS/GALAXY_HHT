class SubMenuModel {
  String? messageCode;
  List<SubMenuName>? subMenuName;
  String? status;
  String? statusMessage;

  SubMenuModel({this.messageCode, this.subMenuName, this.status, this.statusMessage});

  SubMenuModel.fromJson(Map<String, dynamic> json) {
    messageCode = json['MessageCode'];
    if (json['SubMenuName'] != null) {
      subMenuName = <SubMenuName>[];
      json['SubMenuName'].forEach((v) {
        subMenuName!.add(new SubMenuName.fromJson(v));
      });
    }
    status = json['Status'];
    statusMessage = json['StatusMessage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['MessageCode'] = this.messageCode;
    if (this.subMenuName != null) {
      data['SubMenuName'] = this.subMenuName!.map((v) => v.toJson()).toList();
    }
    data['Status'] = this.status;
    data['StatusMessage'] = this.statusMessage;
    return data;
  }
}

class SubMenuName {
  String? menuId;
  String? menuName;
  int? sNo;
  String? imageIcon;
  String? refMenuCode;
  String? IsEnable;

  SubMenuName({this.menuId, this.menuName, this.sNo, this.imageIcon, this.refMenuCode, this.IsEnable});

  SubMenuName.fromJson(Map<String, dynamic> json) {
    menuId = json['MenuId'];
    menuName = json['MenuName'];
    sNo = json['SNo'];
    imageIcon = json['ImageIcon'];
    refMenuCode = json['RefMenuCode'];
    IsEnable = json['IsEnable'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['MenuId'] = this.menuId;
    data['MenuName'] = this.menuName;
    data['SNo'] = this.sNo;
    data['ImageIcon'] = this.imageIcon;
    data['RefMenuCode'] = this.refMenuCode;
    data['IsEnable'] = this.IsEnable;
    return data;
  }
}
