class DashboardModel {
  String? welcome;
  String? dashBoard;
  String? lastUpdate;
  String? profile;
  String? feedback;
  String? helpCenter;
  String? logout;
  String? cancel;
  String? ok;
  String? logoutMsg;
  String? exit;
  String? exitMsg;
  String? loading;
  String? HHT001;
  String? HHT002;
  String? HHT003;



  DashboardModel(
      {

        this.welcome,
        this.dashBoard,
        this.lastUpdate,
        this.profile,
        this.feedback,
        this.helpCenter,
        this.logout,
        this.cancel,
        this.ok,
        this.logoutMsg,
        this.exit,
        this.exitMsg,
        this.loading,
        this.HHT001,
        this.HHT002,
        this.HHT003

      });

  DashboardModel.fromJson(Map<String, dynamic> json) {
    welcome = json['welcome'];
    dashBoard = json['dashBoard'];
    lastUpdate = json['lastUpdate'];

    profile = json['profile'];
    feedback = json['feedback'];
    helpCenter = json['helpCenter'];
    logout = json['logout'];

    cancel = json['cancel'];
    ok = json['ok'];
    logoutMsg = json['logoutMsg'];
    exit = json['exit'];
    exitMsg = json['exitMsg'];
    loading = json['loading'];
    HHT001 = json['HHT001'];
    HHT002 = json['HHT002'];
    HHT003 = json['HHT003'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['welcome'] = this.welcome;
    data['dashBoard'] = this.dashBoard;
    data['lastUpdate'] = this.lastUpdate;

    data['profile'] = this.profile;
    data['feedback'] = this.feedback;
    data['helpCenter'] = this.helpCenter;
    data['logout'] = this.logout;

    data['cancel'] = this.cancel;
    data['ok'] = this.ok;
    data['logoutMsg'] = this.logoutMsg;
    data['exit'] = this.exit;
    data['exitMsg'] = this.exitMsg;
    data['loading'] = this.loading;
    data['HHT001'] = this.HHT001;
    data['HHT002'] = this.HHT002;
    data['HHT003'] = this.HHT003;


    return data;
  }


  String? getValueFromKey(String key){
    switch(key){
      case 'HHT001':
        return HHT001;
      case 'HHT002':
        return HHT002;
      case 'HHT003':
        return HHT003;
      default:
        return null;
    }
  }

}
