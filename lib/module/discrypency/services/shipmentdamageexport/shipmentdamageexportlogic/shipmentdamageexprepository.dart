import 'package:dio/dio.dart';
import 'package:galaxy/api/api.dart';
import 'package:galaxy/api/apilist.dart';
import 'package:galaxy/module/discrypency/model/shipmentdamageexportmodel/shipmentdamagegetpageload.dart';
import 'package:galaxy/prefrence/savedprefrence.dart';
import 'package:galaxy/utils/commonutils.dart';

import '../../../model/shipmentdamageexportmodel/revokedamageexpmodel.dart';
import '../../../model/shipmentdamageexportmodel/shipmentdamageexportmodel.dart';




class ShipmentDamageExpRepository{
  Api api = Api();
  SavedPrefrence savedPrefrence = SavedPrefrence();

  Future<ShipmentDamageGetPageLoad> getPageLoad(
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
      print('shipmentDamageGetPageLoad: $payload --- $payload');


      Response response = await api.sendRequest.get(Apilist.getPageLoad,
          queryParameters: payload
      );

      if (response.statusCode == 200) {
        ShipmentDamageGetPageLoad shipmentDamageGetPageLoad = ShipmentDamageGetPageLoad.fromJson(response.data);
        return shipmentDamageGetPageLoad;
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

  // shipment damage detail list api
  Future<ShipmentDamageExportModel> getExpAWBDetailListModel(String scan, String flag, int userId, int companyCode, int menuId) async {

    try {

      var payload = {
        "Scan": scan,
        "Flag" : flag,
        "AirportCode": CommonUtils.airportCode,
        "CompanyCode": companyCode,
        "CultureCode": CommonUtils.defaultLanguageCode,
        "UserId": userId,
        "MenuId": menuId
      };

      // Print payload for debugging
      print('ShipmentDamageExportModel: $payload --- $payload');


      Response response = await api.sendRequest.get(Apilist.getShipmentDamageDetailListApiExp,
          queryParameters: payload
      );

      if (response.statusCode == 200) {
        ShipmentDamageExportModel shipmentDamageListModel = ShipmentDamageExportModel.fromJson(response.data);
        return shipmentDamageListModel;
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

// shipment damage detail list api
  Future<RevokeDamageExpModel> revokeDamageExpDetailModel(int expAWBRowId, int expShipRowId, int problemSeqNo, int flighSeqNo, int userId, int companyCode, int menuId) async {

    try {

      var payload = {
        "EAID": expAWBRowId,
        "ESID" : expShipRowId,
        "ProblemSeqId" : problemSeqNo,
        "FlightSeqNo" : flighSeqNo,
        "AirportCode": CommonUtils.airportCode,
        "CompanyCode": companyCode,
        "CultureCode": CommonUtils.defaultLanguageCode,
        "UserId": userId,
        "MenuId": menuId
      };

      // Print payload for debugging
      print('RevokeDamageExpModel: $payload --- $payload');


      Response response = await api.sendRequest.post(Apilist.revokeDamageApiExp,
          data: payload
      );

      if (response.statusCode == 200) {
        RevokeDamageExpModel revokeDamageModel = RevokeDamageExpModel.fromJson(response.data);
        return revokeDamageModel;
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