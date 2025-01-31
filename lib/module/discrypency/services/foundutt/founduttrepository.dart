import 'package:dio/dio.dart';
import 'package:galaxy/api/api.dart';
import 'package:galaxy/api/apilist.dart';
import 'package:galaxy/module/discrypency/model/foundutt/founduttrecordupdatemodel.dart';
import 'package:galaxy/module/discrypency/model/foundutt/getfounduttsearchmodel.dart';
import 'package:galaxy/prefrence/savedprefrence.dart';
import 'package:galaxy/utils/commonutils.dart';

import '../../../discrypency/model/unabletotrace/getuttsearchmodel.dart';
import '../../model/foundutt/getfounduttgroupidmodel.dart';
import '../../model/foundutt/getfounduttpageloadmodel.dart';
import '../../model/unabletotrace/uttrecordupdatemodel.dart';




class FoundUTTRepository{
  Api api = Api();

  SavedPrefrence savedPrefrence = SavedPrefrence();


  Future<GetFoundUTTPageLoadModel> getPageLoadFoundUTT(
      int userId,
      int companyCode,
      int menuId) async {

    try {

      var payload = {
        "AirportCode": CommonUtils.airportCode,
        "CompanyCode": companyCode,
        "CultureCode": CommonUtils.defaultLanguageCode,
        "UserId": userId,
        "MenuId" : menuId
      };

      // Print payload for debugging
      print('GetFoundUTTPageLoadModel: $payload --- $payload');


      Response response = await api.sendRequest.get(Apilist.getPageLoadFoundUTT,
          queryParameters: payload
      );

      if (response.statusCode == 200) {
        GetFoundUTTPageLoadModel getFoundUTTPageLoadModel = GetFoundUTTPageLoadModel.fromJson(response.data);
        return getFoundUTTPageLoadModel;
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

  Future<GetFoundUTTSearchModel> getFoundUTTSearchRecord(
      String scan,
      int userId,
      int companyCode,
      int menuId) async {

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
      print('GetFoundUTTSearchModel: $payload --- $payload');


      Response response = await api.sendRequest.get(Apilist.getFoundUTTSearch,
          queryParameters: payload
      );

      if (response.statusCode == 200) {
        GetFoundUTTSearchModel getFoundUTTSearchModel = GetFoundUTTSearchModel.fromJson(response.data);
        return getFoundUTTSearchModel;
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


  Future<GetFoundUTTGroupIdModel> getFoundUTTGroupId(
      String scan,
      int userId,
      int companyCode,
      int menuId) async {

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
      print('GetFoundUTTGroupIdModel: $payload --- $payload');


      Response response = await api.sendRequest.get(Apilist.getGroupIdFoundUTT,
          queryParameters: payload
      );

      if (response.statusCode == 200) {
        GetFoundUTTGroupIdModel getFoundUTTGroupIdModel = GetFoundUTTGroupIdModel.fromJson(response.data);
        return getFoundUTTGroupIdModel;
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



  Future<FoundUTTRecordUpdateModel> foundUTTRecordUpdate(
      String uttType,
      int seqNo,
      int nop,
      double weight,
      String moduleType,
      int userId,
      int companyCode,
      int menuId) async {

    try {

      var payload = {
        "UTTType" : uttType,
        "SeqNo" : seqNo,
        "Nop" : nop,
        "Weight" : weight,
        "ModuleType" : moduleType,
        "AirportCode": CommonUtils.airportCode,
        "CompanyCode": companyCode,
        "CultureCode": CommonUtils.defaultLanguageCode,
        "UserId": userId,
        "MenuId" : menuId
      };

      // Print payload for debugging
      print('FoundUTTRecordUpdateModel: $payload --- $payload');


      Response response = await api.sendRequest.post(Apilist.recordFoundUTTUpdate,
          data: payload
      );

      if (response.statusCode == 200) {
        FoundUTTRecordUpdateModel foundUTTRecordUpdateModel = FoundUTTRecordUpdateModel.fromJson(response.data);
        return foundUTTRecordUpdateModel;
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
