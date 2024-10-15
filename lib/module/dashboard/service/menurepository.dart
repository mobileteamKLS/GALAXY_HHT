import 'package:dio/dio.dart';
import 'package:galaxy/api/api.dart';
import 'package:galaxy/api/apilist.dart';
import 'package:galaxy/language/validationmessageservice/model/validationmessagemodel.dart';
import 'package:galaxy/module/dashboard/model/menumodel.dart';
import 'package:galaxy/utils/commonutils.dart';

class MenuRepository{
  Api api = Api();


  Future<MenuModel> menuModelData(int userId, String userGroup, int companyCode) async {

    try {

      var payload = {

        'UserId' : userId,
        'UserGroup' : userGroup,
        'CultureCode': CommonUtils.defaultLanguageCode,
        'AirportCode': CommonUtils.airportCode,
        'CompanyCode' : companyCode
      };

      // Print payload for debugging
      print('menuModel Paylod: $payload --- $payload');


      Response response = await api.sendRequest.get(Apilist.menuNamesApi,
          queryParameters: payload
      );

      if (response.statusCode == 200) {
        MenuModel menuModel = MenuModel.fromJson(response.data);
        return menuModel;
      } else {
        // Handle non-200 response
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          error: response.data['StatusMessage'] ?? 'Failed Responce',
        );
      }
    } catch (e) {
      if (e is DioError) {
        throw e.response?.data['StatusMessage'] ?? 'Failed to Responce';
      } else {
        throw 'An unexpected error occurred';
      }
    }
  }
}