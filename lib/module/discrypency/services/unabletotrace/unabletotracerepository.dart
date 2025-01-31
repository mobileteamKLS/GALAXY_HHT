import 'package:dio/dio.dart';
import 'package:galaxy/api/api.dart';
import 'package:galaxy/api/apilist.dart';
import 'package:galaxy/prefrence/savedprefrence.dart';
import 'package:galaxy/utils/commonutils.dart';

import '../../../discrypency/model/unabletotrace/getuttsearchmodel.dart';
import '../../model/unabletotrace/uttrecordupdatemodel.dart';




class UnableToTraceRepository{
  Api api = Api();

  SavedPrefrence savedPrefrence = SavedPrefrence();


  Future<GetUTTSearchModel> getUTTSearchRecord(
      String scan,
      String scanType,
      String moduleType,
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
      print('GetUTTSearchModel: $payload --- $payload');


      Response response = await api.sendRequest.get(Apilist.getUTTSearch,
          queryParameters: payload
      );

      if (response.statusCode == 200) {
        GetUTTSearchModel getUTTSearchModel = GetUTTSearchModel.fromJson(response.data);
        return getUTTSearchModel;
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


  Future<UTTRecordUpdateModel> UTTRecordUpdate(
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
      print('UTTRecordUpdateModel: $payload --- $payload');


      Response response = await api.sendRequest.post(Apilist.recordUTTUpdate,
          data: payload
      );

      if (response.statusCode == 200) {
        UTTRecordUpdateModel uttRecordUpdateModel = UTTRecordUpdateModel.fromJson(response.data);
        return uttRecordUpdateModel;
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
