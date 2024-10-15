import 'package:dio/dio.dart';
import 'package:galaxy/api/api.dart';
import 'package:galaxy/api/apilist.dart';
import 'package:galaxy/language/validationmessageservice/model/validationmessagemodel.dart';
import 'package:galaxy/utils/commonutils.dart';

class ValidationMsgRepository{
  Api api = Api();

  Future<ValidationMessageModel> validationMessage(String menuCode, String languageCode, int companyCode) async {

    try {

      var payload = {
        'CultureCode' : languageCode,
        'MenuCode': menuCode,
        'AirportCode': CommonUtils.airportCode,
        'CompanyCode' : companyCode
      };

      // Print payload for debugging
      print('validationMessage: $payload --- $payload');


      Response response = await api.sendRequest.get(Apilist.cultureMessageApi,
        queryParameters: payload
      );

      if (response.statusCode == 200) {
        ValidationMessageModel validationMessageModel = ValidationMessageModel.fromJson(response.data);
        return validationMessageModel;
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