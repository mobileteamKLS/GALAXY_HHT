import 'package:dio/dio.dart';
import '../../../../api/api.dart';
import '../../../../api/apilist.dart';
import '../../../../prefrence/savedprefrence.dart';
import '../../../../utils/commonutils.dart';
import '../../../import/model/uldacceptance/locationvalidationmodel.dart';
import '../../model/palletstock/addpalletstackmodel.dart';
import '../../model/palletstock/palletstackassignflightmodel.dart';
import '../../model/palletstock/palletstackdefaultpageloadmodel.dart';
import '../../model/palletstock/palletstacklistmodel.dart';
import '../../model/palletstock/palletstackpageloadmodel.dart';
import '../../model/palletstock/palletstackuldconditioncodemodel.dart';
import '../../model/palletstock/palletstackupdateuldconditioncodemodel.dart';
import '../../model/palletstock/removepalletstackmodel.dart';
import '../../model/palletstock/reopenClosepalletstackmodel.dart';
import '../../model/palletstock/revokepalletstackmodel.dart';
import '../../model/retriveuld/retriveulddetailmodel.dart';
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


  Future<RetriveULDDetailLoadModel> retriveULDDetail(String uldType, int userId, int companyCode, int menuId) async {

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


}