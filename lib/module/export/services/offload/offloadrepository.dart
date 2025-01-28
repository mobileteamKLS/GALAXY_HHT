
import 'package:dio/dio.dart';
import 'package:galaxy/api/api.dart';
import 'package:galaxy/api/apilist.dart';
import 'package:galaxy/module/export/model/buildup/shcvalidatemodel.dart';
import 'package:galaxy/module/export/pages/offload/offloaduldpage.dart';
import 'package:galaxy/prefrence/savedprefrence.dart';
import 'package:galaxy/utils/commonutils.dart';
import '../../../import/model/flightcheck/airportcitymodel.dart';
import '../../../import/model/uldacceptance/locationvalidationmodel.dart';
import '../../model/buildup/addmailviewmodel.dart';
import '../../model/buildup/addshipmentmodel.dart';
import '../../model/buildup/awbacknowledgemodel.dart';
import '../../model/buildup/awbprioritymodel.dart';
import '../../model/buildup/buildupawblistmodel.dart';
import '../../model/buildup/buildupdefaultpageloadmodel.dart';
import '../../model/buildup/buildupgrouplistmodel.dart';
import '../../model/buildup/flightsearchmodel.dart';
import '../../model/buildup/getuldtrolleysavemodel.dart';
import '../../model/buildup/getuldtrolleysearchmodel.dart';
import '../../model/buildup/removemailmodel.dart';
import '../../model/buildup/savemailmodel.dart';
import '../../model/buildup/ulddamagemodel.dart';
import '../../model/buildup/uldtrolleyprioritymodel.dart';
import '../../model/closeuld/getcontourlistmodel.dart';
import '../../model/move/getmovesearch.dart';
import '../../model/move/movelocationmodel.dart';
import '../../model/move/removemovementmodel.dart';
import '../../model/offload/getoffloadsearchmodel.dart';
import '../../model/offload/offloadShipmentmodel.dart';
import '../../model/offload/offloadULDmodel.dart';
import '../../model/offload/offloadgetpageload.dart';
import '../../model/splitgroup/splitgroupdefaultpageloadmodel.dart';
import '../../model/splitgroup/splitgroupdetailsearchmodel.dart';
import '../../model/splitgroup/splitgroupsavemodel.dart';



class OffloadRepository{
  Api api = Api();

  SavedPrefrence savedPrefrence = SavedPrefrence();


  Future<OffloadGetPageLoad> getPageLoad(
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
      print('OffloadGetPageLoad: $payload --- $payload');


      Response response = await api.sendRequest.get(Apilist.getPageLoad,
          queryParameters: payload
      );

      if (response.statusCode == 200) {
        OffloadGetPageLoad offloadGetPageLoad = OffloadGetPageLoad.fromJson(response.data);
        return offloadGetPageLoad;
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


  Future<GetSearchOffloadModel> getSearchOffload(
      String scan,
      String scanType,
      int userId,
      int companyCode,
      int menuId) async {

    try {

      var payload = {
        "Scan" : scan,
        "ScanType" : scanType,
        "AirportCode": CommonUtils.airportCode,
        "CompanyCode": companyCode,
        "CultureCode": CommonUtils.defaultLanguageCode,
        "UserId": userId,
        "MenuId" : menuId
      };

      // Print payload for debugging
      print('GetSearchOffloadModel: $payload --- $payload');


      Response response = await api.sendRequest.get(Apilist.getOffloadSearch,
          queryParameters: payload
      );

      if (response.statusCode == 200) {
        GetSearchOffloadModel getSearchOffloadModel = GetSearchOffloadModel.fromJson(response.data);
        return getSearchOffloadModel;
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


  Future<OffloadShipmentModel> offloadAWBSave(
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
      print('OffloadShipmentModel: $payload --- $payload');


      Response response = await api.sendRequest.post(Apilist.offloadAWBSave,
          data: payload
      );

      if (response.statusCode == 200) {
        OffloadShipmentModel offloadShipmentModel = OffloadShipmentModel.fromJson(response.data);
        return offloadShipmentModel;
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

  Future<OffloadULDModel> offloadULDSave(
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
      print('OffloadULDPage: $payload --- $payload');


      Response response = await api.sendRequest.post(Apilist.offloadULDSave,
          data: payload
      );

      if (response.statusCode == 200) {
        OffloadULDModel offloadULDModel = OffloadULDModel.fromJson(response.data);
        return offloadULDModel;
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
