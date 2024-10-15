import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:galaxy/language/model/dashboardModel.dart';
import 'package:galaxy/language/model/subMenuModel.dart';
import 'package:galaxy/utils/commonutils.dart';
import '../utils/langfilenameutils.dart';
import 'model/lableModel.dart';
import 'model/loginModel.dart';


class AppLocalizations {
  final Locale locale;
 // LangModel? _localizeLangModel;
  LoginModel? _loginModel;
  DashboardModel? _dashboardModel;
  SubMenuModelLang? _subMenuModel;
  LableModel? _lableModel;
  AppLocalizations(this.locale);



  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();


  Future<bool> load() async {

    String languageCode = locale.languageCode;



   // String assetPath = 'assets/langfile/${CommonUtils.defaultLanguageCode}.json';
    String loginAssetPath = 'assets/langfile/${languageCode}/${LangFileNameUtils.loginFileName}.json';
    String jsonString = await rootBundle.loadString(loginAssetPath);
    Map<String, dynamic> jsonMap = json.decode(jsonString);
    _loginModel = LoginModel.fromJson(jsonMap[locale.languageCode]);


    String dashboardAssetPath = 'assets/langfile/${languageCode}/${LangFileNameUtils.dashboardFileName}.json';
    String dashboardjsonString = await rootBundle.loadString(dashboardAssetPath);
    Map<String, dynamic> dashboardjsonMap = json.decode(dashboardjsonString);
    _dashboardModel = DashboardModel.fromJson(dashboardjsonMap[locale.languageCode]);


    String subMenuAssetPath = 'assets/langfile/${languageCode}/${LangFileNameUtils.submenuFileName}.json';
    String subMenujsonString = await rootBundle.loadString(subMenuAssetPath);
    Map<String, dynamic> subMenujsonMap = json.decode(subMenujsonString);
    _subMenuModel = SubMenuModelLang.fromJson(subMenujsonMap[locale.languageCode]);


    String lableAssetPath = 'assets/langfile/${languageCode}/${LangFileNameUtils.lableFileName}.json';
    String lablejsonString = await rootBundle.loadString(lableAssetPath);
    Map<String, dynamic> lablejsonMap = json.decode(lablejsonString);
    _lableModel = LableModel.fromJson(lablejsonMap[locale.languageCode]);

    return true;
  }

 // LangModel? get localizeLangModel => _localizeLangModel;

  LoginModel? get loginModel => _loginModel;
  DashboardModel? get dashboardModel => _dashboardModel;
  SubMenuModelLang? get submenuModel => _subMenuModel;
  LableModel? get lableModel => _lableModel;



}



class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'hi', 'ar'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    AppLocalizations localizations = new AppLocalizations(locale);
    await localizations.load();
    return localizations;
  }

  @override
  bool shouldReload(LocalizationsDelegate<AppLocalizations> old) => false;
}