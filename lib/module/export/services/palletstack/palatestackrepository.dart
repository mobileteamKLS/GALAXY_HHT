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


class PalateStackRepository{
  Api api = Api();
  SavedPrefrence savedPrefrence = SavedPrefrence();


  Future<PalletStackDefaultPageLoadModel> palletStackDefaultPageLoad(int userId, int companyCode, int menuId) async {

    try {

      var payload = {
        "AirportCode": CommonUtils.airportCode,
        "CompanyCode": companyCode,
        "CultureCode": CommonUtils.defaultLanguageCode,
        "UserId": userId,
        "MenuId" : menuId
      };

      // Print payload for debugging
      print('PalletStackPageLoadModel: $payload --- $payload');


      Response response = await api.sendRequest.get(Apilist.getPalletStackDefaultPageLoadApi,
          queryParameters: payload
      );

      if (response.statusCode == 200) {
        PalletStackDefaultPageLoadModel palletStackDefaultPageLoadModel = PalletStackDefaultPageLoadModel.fromJson(response.data);
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



  Future<PalletStackPageLoadModel> palletStackPageLoad(String scan, int userId, int companyCode, int menuId) async {

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
      print('PalletStackPageLoadModel: $payload --- $payload');


      Response response = await api.sendRequest.get(Apilist.getPalletStackPageLoadApi,
          queryParameters: payload
      );

      if (response.statusCode == 200) {
        PalletStackPageLoadModel palletStackPageLoadModel = PalletStackPageLoadModel.fromJson(response.data);
        return palletStackPageLoadModel;
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



  Future<PalletStackListModel> palletStackListLoad(int uldSeqNo, int userId, int companyCode, int menuId) async {

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
      print('PalletStackPageLoadModel: $payload --- $payload');


      Response response = await api.sendRequest.get(Apilist.getPalletStacklistApi,
          queryParameters: payload
      );

      if (response.statusCode == 200) {
        PalletStackListModel palletStackListModel = PalletStackListModel.fromJson(response.data);
        return palletStackListModel;
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

  Future<PalletStackAssignFlightModel> palletStackAssignFlightLoad(int uldSeqNo, String flightNo, String flightDate, int userId, int companyCode, int menuId) async {

    try {

      var payload = {
        "ULDSeqNo" : uldSeqNo,
        "FlightNo" : flightNo,
        "FlightDate" : flightDate,
        "AirportCode": CommonUtils.airportCode,
        "CompanyCode": companyCode,
        "CultureCode": CommonUtils.defaultLanguageCode,
        "UserId": userId,
        "MenuId" : menuId
      };

      // Print payload for debugging
      print('palletStackAssignFlightModel: $payload --- $payload');


      Response response = await api.sendRequest.post(Apilist.getPalletStackAssignFlightApi,
          data: payload
      );

      if (response.statusCode == 200) {
        PalletStackAssignFlightModel palletStackAssignFlightModel = PalletStackAssignFlightModel.fromJson(response.data);
        return palletStackAssignFlightModel;
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


  Future<PalletStackULDConditionCodeModel> palletStackULDConditionCodeModel(int userId, int companyCode, int menuId) async {

    try {

      var payload = {
        "AirportCode": CommonUtils.airportCode,
        "CompanyCode": companyCode,
        "CultureCode": CommonUtils.defaultLanguageCode,
        "UserId": userId,
        "MenuId" : menuId
      };

      // Print payload for debugging
      print('PalletStackULDConditionCodeModel: $payload --- $payload');


      Response response = await api.sendRequest.get(Apilist.getPalletStackULDConditionCodeApi,
          queryParameters: payload
      );

      if (response.statusCode == 200) {
        PalletStackULDConditionCodeModel palletStackULDConditionCodeModel = PalletStackULDConditionCodeModel.fromJson(response.data);
        return palletStackULDConditionCodeModel;
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

  Future<PalletStackUpdateULDConditionCodeModel> palletStackUpdateULDConditionCodeModel(int uldSeqNo, String uldConditionCode, int userId, int companyCode, int menuId) async {

    try {

      var payload = {
        "ULDSeqNo" : uldSeqNo,
        "ConditionCode" : uldConditionCode,
        "AirportCode": CommonUtils.airportCode,
        "CompanyCode": companyCode,
        "CultureCode": CommonUtils.defaultLanguageCode,
        "UserId": userId,
        "MenuId" : menuId
      };

      // Print payload for debugging
      print('PalletStackUpdateULDConditionCodeModel: $payload --- $payload');


      Response response = await api.sendRequest.post(Apilist.getPalletStackUpdateULDConditionCodeApi,
          data: payload
      );

      if (response.statusCode == 200) {
        PalletStackUpdateULDConditionCodeModel palletStackUpdateULDConditionCodeModel = PalletStackUpdateULDConditionCodeModel.fromJson(response.data);
        return palletStackUpdateULDConditionCodeModel;
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



  Future<AddPalletStackModel> addPalletStackModel(int uldSeqNo, String uldNo, String locationCode, int userId, int companyCode, int menuId) async {

    try {

      var payload = {
        "ULDSeqNo": uldSeqNo,
        "PalletNo": uldNo,
        "LocationCode": locationCode,
        "AirportCode": CommonUtils.airportCode,
        "CompanyCode": companyCode,
        "CultureCode": CommonUtils.defaultLanguageCode,
        "UserId": userId,
        "MenuId" : menuId
      };

      // Print payload for debugging
      print('AddPalletStackModel: $payload --- $payload');


      Response response = await api.sendRequest.post(Apilist.addPalletStackApi,
          data: payload
      );

      if (response.statusCode == 200) {
        AddPalletStackModel addPalletStackModel = AddPalletStackModel.fromJson(response.data);
        return addPalletStackModel;
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

  Future<RemovePalletStackModel> removePalletStackModel(int uldSeqNo, int userId, int companyCode, int menuId) async {

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
      print('RemovePalletStackModel: $payload --- $payload');


      Response response = await api.sendRequest.post(Apilist.removePalletStackApi,
          data: payload
      );

      if (response.statusCode == 200) {
        RemovePalletStackModel removePalletStackModel = RemovePalletStackModel.fromJson(response.data);
        return removePalletStackModel;
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

  Future<RevokePalletStackModel> revokePalletStackModel(int uldSeqNo, int userId, int companyCode, int menuId) async {

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
      print('RevokePalletStackModel: $payload --- $payload');


      Response response = await api.sendRequest.post(Apilist.revokePalletStackApi,
          data: payload
      );

      if (response.statusCode == 200) {
        RevokePalletStackModel removePalletStackModel = RevokePalletStackModel.fromJson(response.data);
        return removePalletStackModel;
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

  Future<ReopenClosePalletStackModel> reopenClosePalletStackModel(int uldSeqNo, String uldStatus, int userId, int companyCode, int menuId) async {

    try {

      var payload = {
        "ULDSeqNo" : uldSeqNo,
        "ULDStatus" : uldStatus,
        "AirportCode": CommonUtils.airportCode,
        "CompanyCode": companyCode,
        "CultureCode": CommonUtils.defaultLanguageCode,
        "UserId": userId,
        "MenuId" : menuId
      };

      // Print payload for debugging
      print('ReopenClosePalletStackModel: $payload --- $payload');


      Response response = await api.sendRequest.post(Apilist.reopenClosePalletStackApi,
          data: payload
      );

      if (response.statusCode == 200) {
        ReopenClosePalletStackModel reopenClosePalletStackModel = ReopenClosePalletStackModel.fromJson(response.data);
        return reopenClosePalletStackModel;
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