import 'package:dio/dio.dart';
import '../../../../api/api.dart';
import '../../../../api/apilist.dart';
import '../../../../prefrence/savedprefrence.dart';
import '../../../../utils/commonutils.dart';
import '../../../import/model/uldacceptance/locationvalidationmodel.dart';
import '../../model/retriveuld/addtolistmodel.dart';
import '../../model/retriveuld/retriveulddetailmodel.dart';
import '../../model/retriveuld/retriveuldlistmodel.dart';
import '../../model/retriveuld/retriveuldloadmodel.dart';


class RetriveULDRepository{
  Api api = Api();
  SavedPrefrence savedPrefrence = SavedPrefrence();

  Future<RetriveULDPageLoadModel> retriveULDPageLoad(int userId, int companyCode, int menuId) async {

    try {

      var payload = {
        "AirportCode": CommonUtils.airportCode,
        "CompanyCode": companyCode,
        "CultureCode": CommonUtils.defaultLanguageCode,
        "UserId": userId,
        "MenuId" : menuId
      };

      // Print payload for debugging
      print('RetriveULDPageLoadModel: $payload --- $payload');


      Response response = await api.sendRequest.get(Apilist.retriveULDTypeList,
          queryParameters: payload
      );

      if (response.statusCode == 200) {
        RetriveULDPageLoadModel palletStackDefaultPageLoadModel = RetriveULDPageLoadModel.fromJson(response.data);
        return palletStackDefaultPageLoadModel;
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

  // call uld locationValidate api call
  Future<LocationValidationModel> locationValidate(String locationCode, int userId, int companyCode, int menuId, String processCode) async {

    try {

      var payload = {
        'LocationCode' : locationCode,
        "AirportCode": CommonUtils.airportCode,
        "CompanyCode": companyCode,
        "CultureCode": CommonUtils.defaultLanguageCode,
        "UserId": userId,
        "ProcessCode" : processCode,
        "MenuId" : menuId
      };

      // Print payload for debugging
      print('locationValidationModel: $payload --- $payload');


      Response response = await api.sendRequest.get(Apilist.validateLocationsApi,
          queryParameters: payload
      );

      if (response.statusCode == 200) {
        LocationValidationModel locationValidationModel = LocationValidationModel.fromJson(response.data);
        return locationValidationModel;
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

  Future<RetriveULDDetailLoadModel> retriveULDDetailList(String uldType, int userId, int companyCode, int menuId) async {

    try {

      var payload = {
        "ULDType" : uldType,
        "AirportCode": CommonUtils.airportCode,
        "CompanyCode": companyCode,
        "CultureCode": CommonUtils.defaultLanguageCode,
        "UserId": userId,
        "MenuId" : menuId
      };

      // Print payload for debugging
      print('RetriveULDDetailLoadModel: $payload --- $payload');


      Response response = await api.sendRequest.get(Apilist.retriveULDDetailList,
          queryParameters: payload
      );

      if (response.statusCode == 200) {
        RetriveULDDetailLoadModel retriveULDDetailLoadModel = RetriveULDDetailLoadModel.fromJson(response.data);
        return retriveULDDetailLoadModel;
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

  Future<RetriveULDDetailLoadModel> retriveULDSearch(String scan, int userId, int companyCode, int menuId) async {

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
      print('RetriveULDDetailModel: $payload --- $payload');


      Response response = await api.sendRequest.get(Apilist.retriveULDSearch,
          queryParameters: payload
      );

      if (response.statusCode == 200) {
        RetriveULDDetailLoadModel retriveULDDetailLoadModel = RetriveULDDetailLoadModel.fromJson(response.data);
        return retriveULDDetailLoadModel;
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

  Future<RetriveULDDetailLoadModel> retriveULDList(int userId, int companyCode, int menuId) async {

    try {

      var payload = {
        "AirportCode": CommonUtils.airportCode,
        "CompanyCode": companyCode,
        "CultureCode": CommonUtils.defaultLanguageCode,
        "UserId": userId,
        "MenuId" : menuId
      };

      // Print payload for debugging
      print('RetriveULDListModel: $payload --- $payload');


      Response response = await api.sendRequest.get(Apilist.retriveULDList,
          queryParameters: payload
      );

      if (response.statusCode == 200) {
        RetriveULDDetailLoadModel retriveULDListModel = RetriveULDDetailLoadModel.fromJson(response.data);
        return retriveULDListModel;
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

  Future<AddToListModel> addToList(int uldSeqNo, int userId, int companyCode, int menuId) async {

    try {

      var payload = {
        "ULDSeqNo" : uldSeqNo,
        "AirportCode": CommonUtils.airportCode,
        "CompanyCode": companyCode,
        "CultureCode": CommonUtils.defaultLanguageCode,
        "UserId": userId,
        "MenuId" : menuId
      };

      // Print payload for debugging
      print('AddToListModel: $payload --- $payload');


      Response response = await api.sendRequest.get(Apilist.addToListApi,
          queryParameters: payload
      );

      if (response.statusCode == 200) {
        AddToListModel addToListModel = AddToListModel.fromJson(response.data);
        return addToListModel;
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