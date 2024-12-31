import 'package:dio/dio.dart';
import '../../../../api/api.dart';
import '../../../../api/apilist.dart';
import '../../../../prefrence/savedprefrence.dart';
import '../../../../utils/commonutils.dart';
import '../../model/closeuld/closeuldsearchmodel.dart';
import '../../model/closeuld/equipmentmodel.dart';



class CloseULDRepository{
  Api api = Api();
  SavedPrefrence savedPrefrence = SavedPrefrence();

  /*Future<SearchULDTrolleyModel> scanCloseULDModel(String scan, int userId, int companyCode, int menuId) async {

    try {

      var payload = {
        "Scan" : scan,
        "AirportCode": CommonUtils.airportCode,
        "CompanyCode": companyCode,
        "CultureCode": CommonUtils.defaultLanguageCode,
        "UserId": userId,
        "MenuId" : menuId
      };

      // Print payload for debugging
      print('scanCloseULDModel: $payload --- $payload');


      Response response = await api.sendRequest.get(Apilist.searchULDTrollPageLoadApi,
          queryParameters: payload
      );

      if (response.statusCode == 200) {
        SearchULDTrolleyModel searchULDTrolleyModel = SearchULDTrolleyModel.fromJson(response.data);
        return searchULDTrolleyModel;
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
*/

  Future<CloseULDSearchModel> closeULDSearchModel(String scan, int userId, int companyCode, int menuId) async {

    try {

      var payload = {
        "Scan" : scan,
        "AirportCode": CommonUtils.airportCode,
        "CompanyCode": companyCode,
        "CultureCode": CommonUtils.defaultLanguageCode,
        "UserId": userId,
        "MenuId" : menuId
      };

      // Print payload for debugging
      print('closeULDSearchModel: $payload --- $payload');


      Response response = await api.sendRequest.get(Apilist.closeULDSearchApi,
          queryParameters: payload
      );

      if (response.statusCode == 200) {
        CloseULDSearchModel closeULDSearchModel = CloseULDSearchModel.fromJson(response.data);
        return closeULDSearchModel;
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

  Future<CloseULDEquipmentModel> closeULDEquipmentModel(int uldSeqNo, String uldType, int userId, int companyCode, int menuId) async {

    try {

      var payload = {
        "ULDSeqNo" : uldSeqNo,
        "ULDType" : uldType,
        "AirportCode": CommonUtils.airportCode,
        "CompanyCode": companyCode,
        "CultureCode": CommonUtils.defaultLanguageCode,
        "UserId": userId,
        "MenuId" : menuId
      };

      // Print payload for debugging
      print('closeULDEquipmentModel: $payload --- $payload');


      Response response = await api.sendRequest.get(Apilist.closeULDEquipmentApi,
          queryParameters: payload
      );

      if (response.statusCode == 200) {
        CloseULDEquipmentModel searchULDTrolleyModel = CloseULDEquipmentModel.fromJson(response.data);
        return searchULDTrolleyModel;
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