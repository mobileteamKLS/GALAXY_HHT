import 'package:dio/dio.dart';
import '../../../../api/api.dart';
import '../../../../api/apilist.dart';
import '../../../../prefrence/savedprefrence.dart';
import '../../../../utils/commonutils.dart';
import '../../model/unloaduld/unloadpageloadmodel.dart';
import '../../model/unloaduld/unloaduldawblistmodel.dart';
import '../../model/unloaduld/unloaduldclosemodel.dart';
import '../../model/unloaduld/unloaduldlistmodel.dart';


class UnloadULDRepository{
  Api api = Api();
  SavedPrefrence savedPrefrence = SavedPrefrence();

  Future<UnloadUldPageLoadModel> unloadUldPageLoadModel(int userId, int companyCode, int menuId) async {

    try {

      var payload = {
        "AirportCode": CommonUtils.airportCode,
        "CompanyCode": companyCode,
        "CultureCode": CommonUtils.defaultLanguageCode,
        "UserId": userId,
        "MenuId" : menuId
      };

      // Print payload for debugging
      print('uldToUldPageLoad: $payload --- $payload');


      Response response = await api.sendRequest.get(Apilist.unloadULDPageLoadApi,
          queryParameters: payload
      );

      if (response.statusCode == 200) {
        UnloadUldPageLoadModel unloadUldPageLoadModel = UnloadUldPageLoadModel.fromJson(response.data);
        return unloadUldPageLoadModel;
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

  Future<UnloadUldListModel> unloadUldlistModel(String scanNo, int userId, int companyCode, int menuId) async {

    try {

      var payload = {
        "Scan" : scanNo,
        "AirportCode": CommonUtils.airportCode,
        "CompanyCode": companyCode,
        "CultureCode": CommonUtils.defaultLanguageCode,
        "UserId": userId,
        "MenuId" : menuId
      };

      // Print payload for debugging
      print('UnloadUldListModel: $payload --- $payload');


      Response response = await api.sendRequest.get(Apilist.uldListApi,
          queryParameters: payload
      );

      if (response.statusCode == 200) {
        UnloadUldListModel unloadUldListModel = UnloadUldListModel.fromJson(response.data);
        return unloadUldListModel;
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

  Future<UnloadUldAWBListModel> unloadUldAWBlistModel(int uldSeqNo, String uldType, int userId, int companyCode, int menuId) async {

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
      print('UnloadUldAWBListModel: $payload --- $payload');


      Response response = await api.sendRequest.get(Apilist.uldawbListApi,
          queryParameters: payload
      );

      if (response.statusCode == 200) {
        UnloadUldAWBListModel unloadUldAWBListModel = UnloadUldAWBListModel.fromJson(response.data);
        return unloadUldAWBListModel;
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

  Future<UnloadUldCloseModel> unloadUldCloseModel(int uldSeqNo, String uldType, int userId, int companyCode, int menuId) async {

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
      print('UnloadUldCloseModel: $payload --- $payload');


      Response response = await api.sendRequest.post(Apilist.unloadULDcloseApi,
          data: payload
      );

      if (response.statusCode == 200) {
        UnloadUldCloseModel unloadUldCloseModel = UnloadUldCloseModel.fromJson(response.data);
        return unloadUldCloseModel;
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