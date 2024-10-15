
import 'package:dio/dio.dart';
import 'package:galaxy/api/api.dart';
import 'package:galaxy/api/apilist.dart';
import 'package:galaxy/module/login/model/accesstokenmodel.dart';
import 'package:galaxy/module/login/model/userlogindatamodel.dart';
import 'package:galaxy/utils/commonutils.dart';

import '../../../prefrence/savedprefrence.dart';

class LoginRepository{
  Api api = Api();
  final SavedPrefrence savedPrefrence = SavedPrefrence();
  String? _accessToken;

  Future<AccessTokenModel> accessToken() async{

    try{
      Response response = await api.sendRequest.post(Apilist.generateTokenApi,
          queryParameters: {
              'Username': 'WFS_User',
              'Password' : 'WFS_Pwd'});

      if (response.statusCode == 200) {
        AccessTokenModel accessTokenModel = AccessTokenModel.fromJson(response.data);
        await savedPrefrence.saveAccessTokenData(accessTokenModel);
        _accessToken = accessTokenModel.accessToken;
        return accessTokenModel;
      } else {
        // Handle non-200 response
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          error: response.data['ErrorMessage'] ?? 'User not matched',
        );
      }

    }catch (e) {
      if (e is DioError) {
        throw e.response?.data['ErrorMessage'] ?? 'Failed to Responce';
      } else {
        throw 'An unexpected error occurred';
      }
    }

  }




  Future<UserDataModel> login(String userId, String password, String authFlg, int companyCode) async {
    /*if (_accessToken == null) {
      throw 'Access token is null';
    }*/
    try {

      var payload = {
        'UserId': userId,
        'Password': authFlg == 'P' ? password : '',
        'MPIN': authFlg == 'M' ? password : '',
        'CultureCode': CommonUtils.defaultLanguageCode,
        'AirportCode': CommonUtils.airportCode,
        'CompanyCode' : companyCode
      };

      // Print payload for debugging
      print('Login Payload: $payload --- $authFlg');


      Response response = await api.sendRequest.post(Apilist.loginApi,
        data: payload,
       /* options: Options(
          headers: {
            'Authorization': 'Bearer $_accessToken',
          },
        ),*/
      );

      if (response.statusCode == 200) {
        UserDataModel userDataModel = UserDataModel.fromJson(response.data);
        await savedPrefrence.saveUserData(userDataModel);
        return userDataModel;
      }else {
        // Handle non-200 response
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          error:  response.data['StatusMessage'] ?? 'Failed Response',
        );
      }
    } catch (e) {
      if (e is DioError) {
        throw e.response?.data['StatusMessage'] ?? 'Failed to login';
      } else {
        throw 'An unexpected error occurred';
      }
    }
  }



}