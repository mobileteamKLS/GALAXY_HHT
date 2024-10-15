import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../module/splash/model/splashdefaultmodel.dart';
import '../module/login/model/accesstokenmodel.dart';
import '../module/login/model/userlogindatamodel.dart';

class SavedPrefrence{
  Future<void> saveSplashDefaultData(SplashDefaultModel comapnyModel) async{
    final prefs = await SharedPreferences.getInstance();
    final splashDefaultData = jsonEncode(comapnyModel.toJson());
    await prefs.setString('splashDefault', splashDefaultData);
  }

  Future<SplashDefaultModel?> getSplashDefaultData() async {
    final prefs = await SharedPreferences.getInstance();
    final splashDefaultData = prefs.getString('splashDefault');
    if (splashDefaultData != null) {
      final splashDefaultDataJson = jsonDecode(splashDefaultData);
      return SplashDefaultModel.fromJson(splashDefaultDataJson);
    }
    return null;
  }

  Future<void> saveAccessTokenData(AccessTokenModel accessTokenModel) async{
    final prefs = await SharedPreferences.getInstance();
    final accessTokenData = jsonEncode(accessTokenModel.toJson());
    await prefs.setString('accessTokenData', accessTokenData);
  }

  Future<AccessTokenModel?> getAccessTokenData() async {
    final prefs = await SharedPreferences.getInstance();
    final accessTokenData = prefs.getString('accessTokenData');

    if (accessTokenData != null) {
      final accessTokenDataJson = jsonDecode(accessTokenData);
      return AccessTokenModel.fromJson(accessTokenDataJson);
    }

    return null;
  }



  Future<void> saveUserData(UserDataModel userDataModel) async {
    final prefs = await SharedPreferences.getInstance();
    final userData = jsonEncode(userDataModel.toJson());
    await prefs.setString('user', userData);
  }

  Future<UserDataModel?> getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final userDataString = prefs.getString('user');

    if (userDataString != null) {
      final userDataJson = jsonDecode(userDataString);
      return UserDataModel.fromJson(userDataJson);
    }

    return null;
  }

/*  Future<bool> isTokenValid() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      return false;
    }

    return !JwtDecoder.isExpired(token);
  }*/

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user');
    await prefs.remove('accessTokenData');
  }
}