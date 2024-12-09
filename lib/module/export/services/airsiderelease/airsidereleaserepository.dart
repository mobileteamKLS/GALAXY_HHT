import 'package:dio/dio.dart';
import 'package:galaxy/module/export/model/airsiderelease/airsidereleasepageloadmodel.dart';
import 'package:galaxy/module/export/model/airsiderelease/airsidereleasesearchmodel.dart';
import 'package:galaxy/module/export/model/airsiderelease/airsidesignuploadmodel.dart';

import '../../../../api/api.dart';
import '../../../../api/apilist.dart';
import '../../../../prefrence/savedprefrence.dart';
import '../../../../utils/commonutils.dart';
import '../../../import/model/uldacceptance/locationvalidationmodel.dart';
import '../../model/airsiderelease/airsidereleasebatteryupdatemodel.dart';
import '../../model/airsiderelease/airsidereleasedatamodel.dart';
import '../../model/airsiderelease/airsidereleasepriorityupdatemodel.dart';
import '../../model/airsiderelease/airsidereleasetempupdatemodel.dart';
import '../../model/airsiderelease/airsideshipmentlistmodel.dart';

class AirSideReleaseRepository{
  Api api = Api();
  SavedPrefrence savedPrefrence = SavedPrefrence();


  Future<AirsidePageLoadModel> airsidePageLoad(int userId, int companyCode, int menuId) async {

    try {

      var payload = {
        "AirportCode": CommonUtils.airportCode,
        "CompanyCode": companyCode,
        "CultureCode": CommonUtils.defaultLanguageCode,
        "UserId": userId,
        "MenuId" : menuId
      };

      // Print payload for debugging
      print('locationValidationModel: $payload --- $payload');


      Response response = await api.sendRequest.get(Apilist.getAirsideReleasePageLoadApi,
          queryParameters: payload
      );

      if (response.statusCode == 200) {
        AirsidePageLoadModel airsidePageLoadModel = AirsidePageLoadModel.fromJson(response.data);
        return airsidePageLoadModel;
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
        "GPNo" : gatePassNo,
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


      Response response = await api.sendRequest.post(Apilist.getreleaseULDOrTrollyApi,
          data: payload
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

  Future<AirsideReleasePriorityUpdateModel> airsideReleasePriorityUpdate(int SeqNo, int priority, String Mode, int userId, int companyCode, int menuId) async {

    try {

      var payload = {
        "SeqNo" : SeqNo,
        "Priority" : priority,
        "Mode": Mode,
        "AirportCode": CommonUtils.airportCode,
        "CompanyCode": companyCode,
        "CultureCode": CommonUtils.defaultLanguageCode,
        "UserId": userId,
        "MenuId": menuId
      };

      // Print payload for debugging
      print('airsideReleasePriorityUpdateModel: $payload --- $payload');


      Response response = await api.sendRequest.post(Apilist.getreleasePriorityUpdateApi,
          data: payload
      );

      if (response.statusCode == 200) {
        AirsideReleasePriorityUpdateModel airsideReleasePriorityUpdateModel = AirsideReleasePriorityUpdateModel.fromJson(response.data);
        return airsideReleasePriorityUpdateModel;
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

  Future<AirsideSignUploadModel> airsideSignUpload(int flightSeqNo, int uldSeqNo, String gatePassNo, String desigType, String image, int userId, int companyCode, int menuId) async {

    try {

      var payload = {
        "FlightSeqNo" : flightSeqNo,
        "ULDSeqNo" : uldSeqNo,
        "GPNo": gatePassNo,
        "DesigType": desigType,
        "XmlBinaryImage": image,
        "AirportCode": CommonUtils.airportCode,
        "CompanyCode": companyCode,
        "CultureCode": CommonUtils.defaultLanguageCode,
        "UserId": userId,
        "MenuId": menuId
      };

      // Print payload for debugging
      print('AirsideSignUploadModel: $payload --- $payload');


      Response response = await api.sendRequest.post(Apilist.getSignUploadApi,
          data: payload
      );

      if (response.statusCode == 200) {
        AirsideSignUploadModel airsideSignUploadModel = AirsideSignUploadModel.fromJson(response.data);
        return airsideSignUploadModel;
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



  Future<AirsideReleaseBatteryUpdateModel> airsideReleaseBatteryUpdate(int uldSeqNo, int batteryStrength, int userId, int companyCode, int menuId) async {

    try {

      var payload = {
        "ULDSeqNo" : uldSeqNo,
        "BatteryStrength" : batteryStrength,
        "AirportCode": CommonUtils.airportCode,
        "CompanyCode": companyCode,
        "CultureCode": CommonUtils.defaultLanguageCode,
        "UserId": userId,
        "MenuId": menuId
      };

      // Print payload for debugging
      print('airsideReleaseBatteryUpdateModel: $payload --- $payload');


      Response response = await api.sendRequest.post(Apilist.getBatteryUpdateApi,
          data: payload
      );

      if (response.statusCode == 200) {
        AirsideReleaseBatteryUpdateModel airsideReleaseBatteryUpdateModel = AirsideReleaseBatteryUpdateModel.fromJson(response.data);
        return airsideReleaseBatteryUpdateModel;
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
  Future<AirsideReleaseTempUpdateModel> airsideReleaseTempUpdate(int uldSeqNo, int tempreatur, String tempUnit, int userId, int companyCode, int menuId) async {

    try {

      var payload = {
        "ULDSeqNo" : uldSeqNo,
        "Temp" : tempreatur,
        "TUnit" : tempUnit,
        "AirportCode": CommonUtils.airportCode,
        "CompanyCode": companyCode,
        "CultureCode": CommonUtils.defaultLanguageCode,
        "UserId": userId,
        "MenuId": menuId
      };

      // Print payload for debugging
      print('airsideReleaseBatteryUpdateModel: $payload --- $payload');


      Response response = await api.sendRequest.post(Apilist.getTempratureUpdateApi,
          data: payload
      );

      if (response.statusCode == 200) {
        AirsideReleaseTempUpdateModel airsideReleaseTempUpdateModel = AirsideReleaseTempUpdateModel.fromJson(response.data);
        return airsideReleaseTempUpdateModel;
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