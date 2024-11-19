import 'package:dio/dio.dart';
import 'package:galaxy/api/api.dart';
import 'package:galaxy/api/apilist.dart';
import 'package:galaxy/module/import/model/binning/binningdetaillistmodel.dart';
import 'package:galaxy/prefrence/savedprefrence.dart';
import 'package:galaxy/utils/commonutils.dart';

import '../../model/binning/binningpageloaddefault.dart';
import '../../model/binning/binningsavemodel.dart';
import '../../model/uldacceptance/locationvalidationmodel.dart';


class ShipmentDamageRepository{
  Api api = Api();
  SavedPrefrence savedPrefrence = SavedPrefrence();



  // page load api
  Future<BinningPageLoadDefaultModel> getPageLoadDefault(int menuId, int userId, int companyCode) async {

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


      Response response = await api.sendRequest.get(Apilist.getBinningPageLoadApi,
          queryParameters: payload
      );

      if (response.statusCode == 200) {
        BinningPageLoadDefaultModel binningPageLoadDefaultModel = BinningPageLoadDefaultModel.fromJson(response.data);
        return binningPageLoadDefaultModel;
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


  // binning detail list api
  Future<BinningDetailListModel> getBinningDetailListModel(String groupId, int userId, int companyCode, int menuId) async {

    try {

      var payload = {
        "GroupId": groupId,
        "AirportCode": CommonUtils.airportCode,
        "CompanyCode": companyCode,
        "CultureCode": CommonUtils.defaultLanguageCode,
        "UserId": userId,
        "MenuId": menuId
      };

      // Print payload for debugging
      print('BinningDetailListModel: $payload --- $payload');


      Response response = await api.sendRequest.get(Apilist.binningDetailListApi,
          queryParameters: payload
      );

      if (response.statusCode == 200) {
        BinningDetailListModel binningDetailListModel = BinningDetailListModel.fromJson(response.data);
        return binningDetailListModel;
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

  // binning save api
  Future<BinningSaveModel> getBinningDetailSave(String groupId, String awbNo, String houseNo, int flightSeqNo, String igmNo, String locationCode, int locId, int nop, int userId, int companyCode, int menuId) async {

    try {

      var payload = {
        "GroupId": groupId,
        "AWBNo": awbNo,
        "HouseNo": houseNo,
        "IGMNo": "$igmNo~$flightSeqNo",
        "LocCode": locationCode,
        "LocId": locId,
        "NOP": nop,
        "AirportCode": CommonUtils.airportCode,
        "CompanyCode": companyCode,
        "CultureCode": CommonUtils.defaultLanguageCode,
        "UserId": userId,
        "MenuId": menuId
      };

      // Print payload for debugging
      print('binningSaveModel: $payload --- $payload');


      Response response = await api.sendRequest.post(Apilist.binningSaveApi,
          data: payload
      );

      if (response.statusCode == 200) {
        BinningSaveModel binningSaveModel = BinningSaveModel.fromJson(response.data);
        return binningSaveModel;
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