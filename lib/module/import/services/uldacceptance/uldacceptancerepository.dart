import 'dart:io';

import 'package:dio/dio.dart';
import 'package:galaxy/api/api.dart';
import 'package:galaxy/api/apilist.dart';
import 'package:galaxy/prefrence/savedprefrence.dart';
import 'package:galaxy/utils/commonutils.dart';
import 'package:path_provider/path_provider.dart';

import '../../model/uldacceptance/buttonrolesrightsmodel.dart';
import '../../model/uldacceptance/defaultuldacceptance.dart';
import '../../model/uldacceptance/flightfromuldmodel.dart';
import '../../model/uldacceptance/locationvalidationmodel.dart';
import '../../model/uldacceptance/locationvalidationmodel.dart';
import '../../model/uldacceptance/uldacceptancedetailmodel.dart';
import '../../model/uldacceptance/uldacceptsmodel.dart';
import '../../model/uldacceptance/ulddamagelistmodel.dart';
import '../../model/uldacceptance/ulddamgeupdatemodel.dart';
import '../../model/uldacceptance/ulducrmodel.dart';


class UldAcceptanceRepository{
  Api api = Api();
  SavedPrefrence savedPrefrence = SavedPrefrence();

  // call uld damage getDefaulfUldAcceptance api call
  Future<DefaultUldAcceptanceModel> getDefaulfUldAcceptance(String menuCode, int userId, int companyCode, menuId) async {

    try {
      var payload = {
        "MenuCode": menuCode,
        "AirportCode": CommonUtils.airportCode,
        "CompanyCode": companyCode,
        "CultureCode": CommonUtils.defaultLanguageCode,
        "UserId": userId,
        "MenuId" : menuId
      };

      // Print payload for debugging
      print('getDefaulfUldAcceptance Paylod---------------------: $payload');


      Response response = await api.sendRequest.post(Apilist.getDefaultUldAcceptanceApi, data: payload);

      if (response.statusCode == 200) {
        DefaultUldAcceptanceModel defaultUldAcceptanceModel = DefaultUldAcceptanceModel.fromJson(response.data);
        return defaultUldAcceptanceModel;
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


  Future<ButtonRolesRightsModel> getButtonRolesAndRights(int menuId, int userId, int companyCode) async {

    try {

      var payload = {
        "AirportCode": CommonUtils.airportCode,
        "CompanyCode": companyCode,
        "CultureCode": CommonUtils.defaultLanguageCode,
        "UserId": userId,
        "MenuId" : menuId
      };

      // Print payload for debugging
      print('ButtonRolesRightsModel: $payload --- $payload');


      Response response = await api.sendRequest.get(Apilist.getButtonRolesAndRightsApi,
          queryParameters: payload
      );

      if (response.statusCode == 200) {
        ButtonRolesRightsModel buttonRolesRightsModel = ButtonRolesRightsModel.fromJson(response.data);
        return buttonRolesRightsModel;
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
      print('locationValidate --------------payload --- $payload');


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

// call uld damage getUldAcceptanceList api call
  Future<UldAcceptanceDetail> getUldAcceptanceList(int userId, int companyCode, String flightNo, String flightDate, String scanFlight, int menuId) async {

    try {
      var payload = {
        'UserId' : userId,
        'CompanyCode' : companyCode,
        'CultureCode': CommonUtils.defaultLanguageCode,
        'AirportCode': CommonUtils.airportCode,
        'FlightNo' : flightNo,
        'FlightDate' : flightDate,
        'Scan' : scanFlight,
        "MenuId" : menuId
      };

      // Print payload for debugging
      print('getUldAcceptanceList Paylod --------------------: $payload');


      Response response = await api.sendRequest.post(Apilist.getUldAcceptanceListApi, data: payload);

      if (response.statusCode == 200) {
        UldAcceptanceDetail uldAcceptanceDetailModel = UldAcceptanceDetail.fromJson(response.data);
        return uldAcceptanceDetailModel;
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

  // call uld damage uldAcceptance api call
  Future<UldAcceptModel> uldAcceptance(int flightSeqNo, int ULDSeqNo, String ULDNo, String locationCode, String groupId, int userId, int companyCode, int menuId) async {

    try {
      var payload = {

        "FlightSeqNo": flightSeqNo,
        "ULDSeqNo": ULDSeqNo,
       /* "ULDNo": ULDNo,*/
        "LocationCode": locationCode,
        "GroupId": groupId,
        "AirportCode": CommonUtils.airportCode,
        "CompanyCode": companyCode,
        "CultureCode": CommonUtils.defaultLanguageCode,
        "UserId": userId,
        "MenuId" : menuId
      };

      // Print payload for debugging
      print('uldAcceptance Paylod --------------------: $payload');


      Response response = await api.sendRequest.post(Apilist.uldAcceptApi, data: payload);

      if (response.statusCode == 200) {
        UldAcceptModel uldAcceptModel = UldAcceptModel.fromJson(response.data);
        return uldAcceptModel;
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

  // call uld damage trollyAcceptance api call
  Future<UldAcceptModel> trollyAcceptance(int flightSeqNo, String flightNo, String flightDate, String locationCode, String groupId, String trollyType, String trollyNo, int btnFlag, int userId, int companyCode, int menuId) async {

    try {
      var payload = {
        "FlightSeqNo": flightSeqNo,
        "FlightNo": flightNo,
        "FlightDate": flightDate,
        "LocationCode": locationCode,
        "GroupId": groupId,
        "TrollyType": trollyType,
        "TrollyNo": trollyNo,
        "BTFlag": btnFlag,
        "AirportCode": CommonUtils.airportCode,
        "CompanyCode": companyCode,
        "CultureCode": CommonUtils.defaultLanguageCode,
        "UserId": userId,
        "MenuId" : menuId
      };

      // Print payload for debugging
      print('trollyAcceptance ------------------ : $payload');


      Response response = await api.sendRequest.post(Apilist.trollyAcceptApi, data: payload);

      if (response.statusCode == 200) {
        UldAcceptModel uldAcceptModel = UldAcceptModel.fromJson(response.data);
        return uldAcceptModel;
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

  // call uld damage ServiceList api call
  Future<UldDamageListModel> uldDamageServiceList(int userId, int companyCode, int menuId) async {

    try {
      var payload = {
        "AirportCode": CommonUtils.airportCode,
        "CompanyCode": companyCode,
        "CultureCode": CommonUtils.defaultLanguageCode,
        "UserId": userId,
        "MenuId" : menuId
      };

      // Print payload for debugging
      print('uldDamageServiceList Paylod-----------------: $payload');


      Response response = await api.sendRequest.get(Apilist.getUldDamageListApi, queryParameters: payload);

      if (response.statusCode == 200) {
        UldDamageListModel uldDamageListModel = UldDamageListModel.fromJson(response.data);
        return uldDamageListModel;
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

  // call uld damage api call
  Future<UldAcceptModel> uldDamage(String flightType, String ULDNo, int ULDSeqNo, int flightSeqNo, String groupId, String conditionCode, String typeOfDamage, String images, String remarks, int userId, int companyCode, String menuCode, int menuId) async {

    try {
      var payload = {
        "FlightType" : flightType,
        "ULDSeqNo": ULDSeqNo,
        "FlightSeqNo": flightSeqNo,
        "RefMenuCode" : menuCode,
        "ULDConditionCode": conditionCode,
        "DamageCode" :typeOfDamage,
        "XmlBinaryImage" :images,
        "Remarks" : remarks,
        "AirportCode": CommonUtils.airportCode,
        "CompanyCode": companyCode,
        "CultureCode": CommonUtils.defaultLanguageCode,
        "UserId": userId,
        "MenuId" : menuId
      };

      // Print payload for debugging
      print('uldDamage-------------------: $payload');

      Response response = await api.sendRequest.post(Apilist.uldDamageRecordApi, data: payload);

      if (response.statusCode == 200) {
        UldAcceptModel uldAcceptModel = UldAcceptModel.fromJson(response.data);
        return uldAcceptModel;
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

  // call uld damage update api call
  Future<UldDamageUpdatetModel> uldDamageUpdate(int ULDSeqNo, int userId, int companyCode, int menuId) async {

    try {
      var payload = {
        "ULDSeqNo": ULDSeqNo,
        "AirportCode": CommonUtils.airportCode,
        "CompanyCode": companyCode,
        "CultureCode": CommonUtils.defaultLanguageCode,
        "UserId": userId,
        "MenuId" : menuId
      };

      // Print payload for debugging
      print('uldDamageUpdate ---------------------- : $payload');

      Response response = await api.sendRequest.get(Apilist.uldDamageViewApi, queryParameters: payload);

      if (response.statusCode == 200) {
        UldDamageUpdatetModel uldDamageUpdatetModel = UldDamageUpdatetModel.fromJson(response.data);
        return uldDamageUpdatetModel;
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

  // call get flight from urlNo api call
  Future<FlightFromULDModel> getFlightFromUld(String uldNo, int userId, int companyCode, int menuId) async {

    try {

      var payload = {
        'ULDNo' : uldNo,
        "AirportCode": CommonUtils.airportCode,
        "CompanyCode": companyCode,
        "CultureCode": CommonUtils.defaultLanguageCode,
        "UserId": userId,
        "MenuId" : menuId
      };

      // Print payload for debugging
      print('getFlightFromUld ------------------ $payload');


      Response response = await api.sendRequest.get(Apilist.getFlightFromUldApi,
          queryParameters: payload
      );

      if (response.statusCode == 200) {
        FlightFromULDModel flightFromULDModel = FlightFromULDModel.fromJson(response.data);
        return flightFromULDModel;
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

  // call uld create uld create api call
  Future<UldUCRModel> uldUCR(String UCRNo, String ULDNumber, String curruntULDOwner, String locationCode, String groupId, int userId, int companyCode, int menuId) async {

    try {
      var payload = {

        "UCRNo": UCRNo,
        "ULDNo": ULDNumber,
        "CurrentULDOwner" : curruntULDOwner,
        "LocationCode": locationCode,
        "GroupId": groupId,
        "AirportCode": CommonUtils.airportCode,
        "CompanyCode": companyCode,
        "CultureCode": CommonUtils.defaultLanguageCode,
        "UserId": userId,
        "MenuId" : menuId
      };

      // Print payload for debugging
      print('UCR Paylod ---------------- : $payload');


      Response response = await api.sendRequest.post(Apilist.uldUCRApi, data: payload);

      if (response.statusCode == 200) {
        UldUCRModel uldUCRModel = UldUCRModel.fromJson(response.data);
        return uldUCRModel;
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

  // call uld UCR damage api call
  Future<UldAcceptModel> uldUCRDamage(String flightType, String ULDNo,int ULDSeqNo, int flightSeqNo, String groupId, String conditionCode, String typeOfDamage, String images, String remarks, int userId, int companyCode, String menuCode, int menuId) async {

    try {
      var payload = {
        /* "ULDNo": ULDNo,*/
        "FlightType" : flightType,
        "ULDSeqNo": ULDSeqNo,
        "FlightSeqNo": flightSeqNo,
        "RefMenuCode" : menuCode,
        "ULDConditionCode": conditionCode,
        "DamageCode" :typeOfDamage,
        "XmlBinaryImage" :images,
        "Remarks" : remarks,
        "AirportCode": CommonUtils.airportCode,
        "CompanyCode": companyCode,
        "CultureCode": CommonUtils.defaultLanguageCode,
        "UserId": userId,
        "MenuId" : menuId
      };

      // Print payload for debugging
      print('ULD UCR Damage-------------------: $payload');

      Response response = await api.sendRequest.post(Apilist.uldDamageRecordApi, data: payload);

      if (response.statusCode == 200) {
        UldAcceptModel uldAcceptModel = UldAcceptModel.fromJson(response.data);
        return uldAcceptModel;
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