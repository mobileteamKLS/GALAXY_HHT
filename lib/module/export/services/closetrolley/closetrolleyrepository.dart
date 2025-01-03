import 'package:dio/dio.dart';
import '../../../../api/api.dart';
import '../../../../api/apilist.dart';
import '../../../../prefrence/savedprefrence.dart';
import '../../../../utils/commonutils.dart';
import '../../model/closetrolley/closetrolleyreopenmodel.dart';
import '../../model/closetrolley/closetrolleysearchmodel.dart';
import '../../model/closetrolley/gettrolleydocumentlistmodel.dart';
import '../../model/closetrolley/gettrolleyscalelistmodel.dart';
import '../../model/closetrolley/savetrolleyscalemodel.dart';




class CloseTrolleyRepository{
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

  Future<CloseTrolleySearchModel> closeTrolleySearchModel(String scan, int userId, int companyCode, int menuId) async {

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
      print('CloseTrolleySearchModel: $payload --- $payload');


      Response response = await api.sendRequest.get(Apilist.closeTrolleySearchApi,
          queryParameters: payload
      );

      if (response.statusCode == 200) {
        CloseTrolleySearchModel closeTrolleySearchModel = CloseTrolleySearchModel.fromJson(response.data);
        return closeTrolleySearchModel;
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

  Future<GetTrolleyDocumentListModel> getTrolleyDocumentListModel(int trolleySeqNo, int userId, int companyCode, int menuId) async {

    try {

      var payload = {
        "TrolleySeqNo" : trolleySeqNo,
        "AirportCode": CommonUtils.airportCode,
        "CompanyCode": companyCode,
        "CultureCode": CommonUtils.defaultLanguageCode,
        "UserId": userId,
        "MenuId" : menuId
      };

      // Print payload for debugging
      print('getTrolleyDocumentListModel: $payload --- $payload');


      Response response = await api.sendRequest.get(Apilist.closeTrolleyGetDocumentList,
          queryParameters: payload
      );

      if (response.statusCode == 200) {
        GetTrolleyDocumentListModel getTrolleyDocumentListModel = GetTrolleyDocumentListModel.fromJson(response.data);
        return getTrolleyDocumentListModel;
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



  Future<GetTrolleyScaleListModel> getTrolleyScaleList(int trolleySeqNo, int userId, int companyCode, int menuId) async {

    try {

      var payload = {
        "TrolleySeqNo" : trolleySeqNo,
        "AirportCode": CommonUtils.airportCode,
        "CompanyCode": companyCode,
        "CultureCode": CommonUtils.defaultLanguageCode,
        "UserId": userId,
        "MenuId" : menuId
      };

      // Print payload for debugging
      print('getTrolleyScaleList: $payload --- $payload');


      Response response = await api.sendRequest.get(Apilist.closeTrolleyScaleApi,
          queryParameters: payload
      );

      if (response.statusCode == 200) {
        GetTrolleyScaleListModel getTrolleyScaleListModel = GetTrolleyScaleListModel.fromJson(response.data);
        return getTrolleyScaleListModel;
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

  Future<SaveTrolleyScaleModel> saveTrolleyScaleModel(int flightSeqNo, int trolleySeqNo, double scaleWeight, int userId, int companyCode, int menuId) async {

    try {

      var payload = {
        "FlightSeqNo" : flightSeqNo,
        "TrolleySeqNo" : trolleySeqNo,
        "ScaleWeight" : scaleWeight,
        "AirportCode": CommonUtils.airportCode,
        "CompanyCode": companyCode,
        "CultureCode": CommonUtils.defaultLanguageCode,
        "UserId": userId,
        "MenuId" : menuId
      };

      // Print payload for debugging
      print('SaveScaleModel: $payload --- $payload');


      Response response = await api.sendRequest.post(Apilist.closeTrolleySaveScaleApi,
          data: payload
      );

      if (response.statusCode == 200) {
        SaveTrolleyScaleModel saveTrolleyScaleModel = SaveTrolleyScaleModel.fromJson(response.data);
        return saveTrolleyScaleModel;
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




  Future<CloseTrolleyReopenModel> closeReopenTrolleyModel(int flightSeqNo, int trolleySeqNo, String trolleyStatus,  int userId, int companyCode, int menuId) async {

    try {

      var payload = {
        "FlightSeqNo" : flightSeqNo,
        "TrolleySeqNo" : trolleySeqNo,
        "TrolleyStatus" : trolleyStatus,
        "AirportCode": CommonUtils.airportCode,
        "CompanyCode": companyCode,
        "CultureCode": CommonUtils.defaultLanguageCode,
        "UserId": userId,
        "MenuId" : menuId
      };

      // Print payload for debugging
      print('closeReopenTrolleyModel: $payload --- $payload');


      Response response = await api.sendRequest.post(Apilist.closeTrolleyStatusUpdate,
          data: payload
      );

      if (response.statusCode == 200) {
        CloseTrolleyReopenModel closeTrolleyReopenModel = CloseTrolleyReopenModel.fromJson(response.data);
        return closeTrolleyReopenModel;
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