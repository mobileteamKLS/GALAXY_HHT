import 'package:dio/dio.dart';
import '../../../../api/api.dart';
import '../../../../api/apilist.dart';
import '../../../../prefrence/savedprefrence.dart';
import '../../../../utils/commonutils.dart';
import '../../../import/model/uldacceptance/locationvalidationmodel.dart';
import '../../model/emptyuldtrolley/createuldtrolleymodel.dart';
import '../../model/emptyuldtrolley/emptyuldtrolpageloadmodel.dart';
import '../../model/emptyuldtrolley/searchuldtrolleymodel.dart';
import '../../model/unloaduld/unloadpageloadmodel.dart';
import '../../model/unloaduld/unloadremoveawbmodel.dart';
import '../../model/unloaduld/unloaduldawblistmodel.dart';
import '../../model/unloaduld/unloadopenuldmodel.dart';
import '../../model/unloaduld/unloaduldlistmodel.dart';


class EmptyULDTrolleyRepository{
  Api api = Api();
  SavedPrefrence savedPrefrence = SavedPrefrence();

  Future<EmptyULDtrolPageLoadModel> emptyULDtrolPageLoadModel(int userId, int companyCode, int menuId) async {

    try {

      var payload = {
        "AirportCode": CommonUtils.airportCode,
        "CompanyCode": companyCode,
        "CultureCode": CommonUtils.defaultLanguageCode,
        "UserId": userId,
        "MenuId" : menuId
      };

      // Print payload for debugging
      print('emptyULDtrolPageLoadModel: $payload --- $payload');


      Response response = await api.sendRequest.get(Apilist.emptyULDTrollPageLoadApi,
          queryParameters: payload
      );

      if (response.statusCode == 200) {
        EmptyULDtrolPageLoadModel emptyULDtrolPageLoadModel = EmptyULDtrolPageLoadModel.fromJson(response.data);
        return emptyULDtrolPageLoadModel;
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

  Future<SearchULDTrolleyModel> searchULDTrolleyModel(String uldType, String scan, int userId, int companyCode, int menuId) async {

    try {

      var payload = {
        "Scan" : scan,
        "ULDType" : uldType,
        "AirportCode": CommonUtils.airportCode,
        "CompanyCode": companyCode,
        "CultureCode": CommonUtils.defaultLanguageCode,
        "UserId": userId,
        "MenuId" : menuId
      };

      // Print payload for debugging
      print('searchULDTrolleyModel: $payload --- $payload');


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

  Future<CreateULDTrolleyModel> createULDTrolleyModel(String uldNo, String uldType, String uldOwner, String locationCode, String groupID, int userId, int companyCode, int menuId) async {

    try {

      var payload = {
        "ULDNo" : uldNo,
        "ULDType" : uldType,
        "CurrentULDOwner" : uldOwner,
        "LocationCode" : locationCode,
        "GroupId" : groupID,
        "AirportCode": CommonUtils.airportCode,
        "CompanyCode": companyCode,
        "CultureCode": CommonUtils.defaultLanguageCode,
        "UserId": userId,
        "MenuId" : menuId
      };

      // Print payload for debugging
      print('searchULDTrolleyModel: $payload --- $payload');


      Response response = await api.sendRequest.post(Apilist.createULDTrolleyApi,
          data: payload
      );

      if (response.statusCode == 200) {
        CreateULDTrolleyModel createULDTrolleyModel = CreateULDTrolleyModel.fromJson(response.data);
        return createULDTrolleyModel;
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