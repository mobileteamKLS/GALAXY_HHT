import 'package:dio/dio.dart';
import 'package:galaxy/api/apilist.dart';

import '../../../api/api.dart';

import '../../../prefrence/savedprefrence.dart';
import '../../../utils/commonutils.dart';
import '../model/splashdefaultmodel.dart';

class SplashRepository{

  Api api = Api();
  final SavedPrefrence savedPrefrence = SavedPrefrence();
  Future<SplashDefaultModel> getDefaultPageLoad(String airportCode) async {
    try {

      var payload = {
        'AirportCode': CommonUtils.airportCode,
        'CompanyCode' : CommonUtils.defaultComapnyCode,
        'CultureCode' : CommonUtils.defaultLanguageCode
      };

      Response response = await api.sendRequest.get(Apilist.defaulApi,  queryParameters: payload,);

      if (response.statusCode == 200) {
        SplashDefaultModel comapnyModel = SplashDefaultModel.fromJson(response.data);
        savedPrefrence.saveSplashDefaultData(comapnyModel);
        return comapnyModel;
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