class MenuModel {
  String? messageCode;
  List<MenuName>? menuName;
  String? status;
  String? statusMessage;

  MenuModel({this.messageCode, this.menuName, this.status, this.statusMessage});

  MenuModel.fromJson(Map<String, dynamic> json) {
    messageCode = json['MessageCode'];
    if (json['MenuName'] != null) {
      menuName = <MenuName>[];
      json['MenuName'].forEach((v) {
        menuName!.add(new MenuName.fromJson(v));
      });
    }
    status = json['Status'];
    statusMessage = json['StatusMessage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['MessageCode'] = this.messageCode;
    if (this.menuName != null) {
      data['MenuName'] = this.menuName!.map((v) => v.toJson()).toList();
    }
    data['Status'] = this.status;
    data['StatusMessage'] = this.statusMessage;
    return data;
  }
}

class MenuName {
  String? menuId;
  String? menuName;
  int? sNo;
  String? imageIcon;
  String? refMenuCode;
  String? IsEnable;

  MenuName({this.menuId, this.menuName, this.sNo, this.imageIcon, this.refMenuCode, this.IsEnable});

  MenuName.fromJson(Map<String, dynamic> json) {
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
