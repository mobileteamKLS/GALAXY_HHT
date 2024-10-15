import 'package:dio/dio.dart';
import 'package:galaxy/api/api.dart';
import 'package:galaxy/api/apilist.dart';
import 'package:galaxy/utils/commonutils.dart';

import '../model/submenumodel.dart';

class SubMenuRepository{
  Api api = Api();


  Future<SubMenuModel> subMenuModelData(int userId, String userGroup, String menuId, int companyCode) async {

    try {

      var payload = {

        'UserId' : userId,
        'UserGroup' : userGroup,
        'CultureCode': CommonUtils.defaultLanguageCode,
        'AirportCode': CommonUtils.airportCode,
        'MenuId' : menuId,
        'CompanyCode' : companyCode
      };

      // Print payload for debugging
      print('subMenuModel Paylod: $payload --- $payload');


      Response response = await api.sendRequest.get(Apilist.subMenuNamesApi,
          queryParameters: payload
      );

      if (response.statusCode == 200) {
        SubMenuModel subMenuModel = SubMenuModel.fromJson(response.data);
        return subMenuModel;
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