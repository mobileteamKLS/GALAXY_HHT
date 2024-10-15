class SplashDefaultModel {

  String? clientLogo;
  String? appVersion;
  int? companyCode;
  List<Language>? language;
  String? status;
  String? statusMessage;
  int? activeLoginTime;

  SplashDefaultModel(
      {
        this.clientLogo,
        this.appVersion,
        this.companyCode,
        this.language,
        this.status,
        this.statusMessage,
        this.activeLoginTime});

  SplashDefaultModel.fromJson(Map<String, dynamic> json) {

    clientLogo = json['ClientLogo'];
    appVersion = json['AppVersion'];
    companyCode = json['CompanyCode'];
    activeLoginTime = json['ActiveLoginTime'];
    if (json['Language'] != null) {
      language = <Language>[];
      json['Language'].forEach((v) {
        language!.add(new Language.fromJson(v));
      });
    }
    status = json['Status'];
    statusMessage = json['StatusMessage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ClientLogo'] = this.clientLogo;
    data['AppVersion'] = this.appVersion;
    data['CompanyCode'] = this.companyCode;
    data['ActiveLoginTime'] = this.activeLoginTime;
    if (this.language != null) {
      data['Language'] = this.language!.map((v) => v.toJson()).toList();
    }
    data['Status'] = this.status;
    data['StatusMessage'] = this.statusMessage;
    return data;
  }
}

class Language {
  String? iSOLanguage;
  String? iSOLanguageCode;
  String? iSOCultureInfoCode;
  String? iSOCountryCode;

  Language(
      {this.iSOLanguage,
        this.iSOLanguageCode,
        this.iSOCultureInfoCode,
        this.iSOCountryCode});

  Language.fromJson(Map<String, dynamic> json) {
    iSOLanguage = json['ISOLanguage'];
    iSOLanguageCode = json['ISOLanguageCode'];
    iSOCultureInfoCode = json['ISOCultureInfoCode'];
    iSOCountryCode = json['ISOCountryCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ISOLanguage'] = this.iSOLanguage;
    data['ISOLanguageCode'] = this.iSOLanguageCode;
    data['ISOCultureInfoCode'] = this.iSOCultureInfoCode;
    data['ISOCountryCode'] = this.iSOCountryCode;
    return data;
  }
}
