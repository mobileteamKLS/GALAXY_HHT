import 'dart:io';

import 'package:dio/dio.dart';
import 'package:galaxy/api/api.dart';
import 'package:galaxy/api/apilist.dart';
import 'package:galaxy/module/import/model/binning/binningdetaillistmodel.dart';
import 'package:galaxy/prefrence/savedprefrence.dart';
import 'package:galaxy/utils/commonutils.dart';
import 'package:path_provider/path_provider.dart';

import '../../model/binning/binningpageloaddefault.dart';
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


class BinningRepository{
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


}