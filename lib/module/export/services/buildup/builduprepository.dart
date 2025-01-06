/*
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:galaxy/api/api.dart';
import 'package:galaxy/api/apilist.dart';
import 'package:galaxy/prefrence/savedprefrence.dart';
import 'package:galaxy/utils/commonutils.dart';
import 'package:path_provider/path_provider.dart';

import '../../../import/model/uldacceptance/locationvalidationmodel.dart';
import '../../model/flightcheck/addMailModel.dart';
import '../../model/flightcheck/airportcitymodel.dart';
import '../../model/flightcheck/awblistmodel.dart';
import '../../model/flightcheck/bdprioritymodel.dart';
import '../../model/flightcheck/breakdownendmodel.dart';
import '../../model/flightcheck/damagebreakdownsavemodel.dart';
import '../../model/flightcheck/damagedetailmodel.dart';
import '../../model/flightcheck/finalizeflightmodel.dart';
import '../../model/flightcheck/flightchecksummarymodel.dart';
import '../../model/flightcheck/flightcheckuldlistmodel.dart';
import '../../model/flightcheck/foundcargosavemodel.dart';
import '../../model/flightcheck/hawblistmodel.dart';
import '../../model/flightcheck/importshipmentmodel.dart';
import '../../model/flightcheck/maildetailmodel.dart';
import '../../model/flightcheck/mailtypemodel.dart';
import '../../model/flightcheck/pageloaddefault.dart';
import '../../model/flightcheck/recordatamodel.dart';
import '../../model/flightcheck/updateawbremarkacknoledge.dart';
import '../../model/uldacceptance/buttonrolesrightsmodel.dart';
import '../../model/uldacceptance/defaultuldacceptance.dart';
import '../../model/uldacceptance/flightfromuldmodel.dart';
import '../../model/uldacceptance/locationvalidationmodel.dart';
import '../../model/uldacceptance/locationvalidationmodel.dart';
import '../../model/uldacceptance/uldacceptancedetailmodel.dart';
import '../../model/uldacceptance/uldacceptsmodel.dart';
import '../../model/uldacceptance/ulddamagelistmodel.dart';
import '../../model/uldacceptance/ulddamgeupdatemodel.dart';


class BuildUpRepository{
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



  Future<PageLoadDefaultModel> getPageLoadDefault(int menuId, int userId, int companyCode) async {

    try {

      var payload = {
        "AirportCode": CommonUtils.airportCode,
        "CompanyCode": companyCode,
        "CultureCode": CommonUtils.defaultLanguageCode,
        "UserId": userId,
        "MenuId" : menuId
      };

      // Print payload for debugging
      print('pageLoadDefaultModel: $payload --- $payload');


      Response response = await api.sendRequest.get(Apilist.getPageLoadApi,
          queryParameters: payload
      );

      if (response.statusCode == 200) {
        PageLoadDefaultModel pageLoadDefaultModel = PageLoadDefaultModel.fromJson(response.data);
        return pageLoadDefaultModel;
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
  Future<FlightCheckULDListModel> getFlightCheckULDList(String locationCode, String scan, String flightNo, String flightDate, int userId, int companyCode, int menuId, int ULDListFlag) async {

    try {

      var payload = {
        "Scan" : scan,
        "FlightNo" : flightNo,
        "FlightDate" : flightDate,
        "ULDListFlag": ULDListFlag,
        "AirportCode": CommonUtils.airportCode,
        "CompanyCode": companyCode,
        "CultureCode": CommonUtils.defaultLanguageCode,
        "UserId": userId,
        "MenuId" : menuId
      };

      // Print payload for debugging
      print('FlightCheckULDListModel: $payload --- $payload');


      Response response = await api.sendRequest.post(Apilist.getFlightCheckULDListApi,
          data: payload
      );

      if (response.statusCode == 200) {
        FlightCheckULDListModel flightCheckSummaryModel = FlightCheckULDListModel.fromJson(response.data);
        return flightCheckSummaryModel;
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


  // call Bd Priority api call
  Future<BdPriorityModel> bdPriority(int flightSeqNo, int uldSeqNo, int bdPriority, int userId, int companyCode, int menuId) async {

    try {

      var payload = {
        "FlightSeqNo": flightSeqNo,
        "ULDSeqNo": uldSeqNo,
        "BDPriority": bdPriority,
        "AirportCode": CommonUtils.airportCode,
        "CompanyCode": companyCode,
        "CultureCode": CommonUtils.defaultLanguageCode,
        "UserId": userId,
        "MenuId": menuId
      };

      // Print payload for debugging
      print('locationValidationModel: $payload --- $payload');


      Response response = await api.sendRequest.post(Apilist.updateBDPriority,
          data: payload
      );

      if (response.statusCode == 200) {
        BdPriorityModel bdPriorityModel = BdPriorityModel.fromJson(response.data);
        return bdPriorityModel;
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
  Future<AWBModel> getListOfAwb(int flightSeqNo, int uldSeqNo, int userId, int companyCode, int menuId, int showAll) async {

    try {

      var payload = {
        "FlightSeqNo": flightSeqNo,
        "ULDSeqNo": uldSeqNo,
        "ShowAll": showAll,
        "AirportCode": CommonUtils.airportCode,
        "CompanyCode": companyCode,
        "CultureCode": CommonUtils.defaultLanguageCode,
        "UserId": userId,
        "MenuId": menuId
      };

      // Print payload for debugging
      print('getListOfAwb: $payload --- $payload');


      Response response = await api.sendRequest.post(Apilist.awbListApi,
          data: payload
      );

      if (response.statusCode == 200) {
        AWBModel aWBModel = AWBModel.fromJson(response.data);
        return aWBModel;
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














}*/
