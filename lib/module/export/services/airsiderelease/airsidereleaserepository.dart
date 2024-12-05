import 'package:dio/dio.dart';
import 'package:galaxy/module/export/model/airsiderelease/airsidereleasesearchmodel.dart';

import '../../../../api/api.dart';
import '../../../../api/apilist.dart';
import '../../../../prefrence/savedprefrence.dart';
import '../../../../utils/commonutils.dart';
import '../../../import/model/uldacceptance/locationvalidationmodel.dart';
import '../../model/airsiderelease/airsidereleasedatamodel.dart';
import '../../model/airsiderelease/airsideshipmentlistmodel.dart';

class AirSideReleaseRepository{
  Api api = Api();
  SavedPrefrence savedPrefrence = SavedPrefrence();

  // call uld damage locationValidate api call
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

// call uld damage AirSideReleaseSearchModel api call
  Future<AirSideReleaseSearchModel> getAirsideRelease(String locationCode, String scanNumber, int userId, int companyCode, int menuId) async {

    try {

      var payload = {
       /* 'LocationCode' : locationCode,*/
        'Scan' : scanNumber,
        "AirportCode": CommonUtils.airportCode,
        "CompanyCode": companyCode,
        "CultureCode": CommonUtils.defaultLanguageCode,
        "UserId": userId,
        "MenuId" : menuId
      };

      // Print payload for debugging
      print('AirSideReleaseSearchModel: $payload --- $payload');


      Response response = await api.sendRequest.get(Apilist.getAirsideReleaseListApi,
          queryParameters: payload
      );

      if (response.statusCode == 200) {
        AirSideReleaseSearchModel airSideReleaseSearchModel = AirSideReleaseSearchModel.fromJson(response.data);
        return airSideReleaseSearchModel;
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

  // list AWB api call
  Future<AirsideShipmentListModel> getListOfAirsideAwb(int flightSeqNo, int uldSeqNo, String ULDType, int userId, int companyCode, int menuId) async {

    try {

      var payload = {
        "FlightSeqNo": flightSeqNo,
        "ULDSeqNo": uldSeqNo,
        "ULDType": ULDType,
        "AirportCode": CommonUtils.airportCode,
        "CompanyCode": companyCode,
        "CultureCode": CommonUtils.defaultLanguageCode,
        "UserId": userId,
        "MenuId": menuId
      };

      // Print payload for debugging
      print('getListOfAwb: $payload --- $payload');


      Response response = await api.sendRequest.get(Apilist.getAirsideShipmentListApi,
          queryParameters: payload
      );

      if (response.statusCode == 200) {
        AirsideShipmentListModel airsideShipmentListModel = AirsideShipmentListModel.fromJson(response.data);
        return airsideShipmentListModel;
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

  Future<AirsideReleaseDataModel> releaseULDorTrolley(String doorNo, String gatePassNo, int flightSeqNo, int uldSeqNo, String ULDType, int userId, int companyCode, int menuId) async {

    try {

      var payload = {
        "DoorNo" : doorNo,
        "GatePassNo" : gatePassNo,
        "ULDSeqNo": uldSeqNo,
        "ULDType": ULDType,
        "AirportCode": CommonUtils.airportCode,
        "CompanyCode": companyCode,
        "CultureCode": CommonUtils.defaultLanguageCode,
        "UserId": userId,
        "MenuId": menuId
      };

      // Print payload for debugging
      print('getListOfAwb: $payload --- $payload');


      Response response = await api.sendRequest.get(Apilist.getreleaseULDOrTrollyApi,
          queryParameters: payload
      );

      if (response.statusCode == 200) {
        AirsideReleaseDataModel airsideReleaseDataModel = AirsideReleaseDataModel.fromJson(response.data);
        return airsideReleaseDataModel;
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