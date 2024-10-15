class SubMenuModelLang {
  String? loading;
  String? HHT004;
  String? HHT005;
  String? HHT006;
  String? HHT007;
  String? HHT008;
  String? HHT009;
  String? HHT010;
  String? HHT011;
  String? HHT012;

  SubMenuModelLang(
      {
        this.loading,
        this.HHT004,
        this.HHT005,
        this.HHT006,
        this.HHT007,
        this.HHT008,
        this.HHT009,
        this.HHT010,
        this.HHT011,
        this.HHT012,

      });

  SubMenuModelLang.fromJson(Map<String, dynamic> json) {
    loading = json['loading'];
    HHT004 = json['HHT004'];
    HHT005 = json['HHT005'];
    HHT006 = json['HHT006'];
    HHT007 = json['HHT007'];
    HHT008 = json['HHT008'];
    HHT009 = json['HHT009'];
    HHT010 = json['HHT010'];
    HHT011 = json['HHT011'];
    HHT012 = json['HHT012'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['loading'] = this.loading;
    data['HHT004'] = this.HHT004;
    data['HHT005'] = this.HHT005;
    data['HHT006'] = this.HHT006;
    data['HHT007'] = this.HHT007;
    data['HHT008'] = this.HHT008;
    data['HHT009'] = this.HHT009;
    data['HHT010'] = this.HHT010;
    data['HHT011'] = this.HHT011;
    data['HHT012'] = this.HHT012;


    return data;
  }


  String? getValueFromKey(String key){
    switch(key){
      case 'HHT004':
        return HHT004;
      case 'HHT005':
        return HHT005;
      case 'HHT006':
        return HHT006;
      case 'HHT007':
        return HHT007;
      case 'HHT008':
        return HHT008;
      case 'HHT009':
        return HHT009;
      case 'HHT010':
        return HHT010;
      case 'HHT011':
        return HHT011;
      case 'HHT012':
        return HHT012;
      default:
        return null;
    }
  }

}
