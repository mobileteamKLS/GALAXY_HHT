import 'package:dio/dio.dart';
import '../../../../api/api.dart';
import '../../../../api/apilist.dart';
import '../../../../prefrence/savedprefrence.dart';
import '../../../../utils/commonutils.dart';
import '../../model/uldtould/moveuldmodel.dart';
import '../../model/uldtould/sourceuldmodel.dart';
import '../../model/uldtould/targetuldmodel.dart';


class ULDToULDRepository{
  Api api = Api();
  SavedPrefrence savedPrefrence = SavedPrefrence();

  Future<SourceULDModel> sourceULDLoad(String scanNo, int userId, int companyCode, int menuId) async {

    try {

      var payload = {
        "Scan" : scanNo,
        "AirportCode": CommonUtils.airportCode,
        "CompanyCode": companyCode,
        "CultureCode": CommonUtils.defaultLanguageCode,
        "UserId": userId,
        "MenuId" : menuId
      };

      // Print payload for debugging
      print('SourceULDModel: $payload --- $payload');


      Response response = await api.sendRequest.get(Apilist.sourceULDApi,
          queryParameters: payload
      );

      if (response.statusCode == 200) {
        SourceULDModel sourceULDModel = SourceULDModel.fromJson(response.data);
        return sourceULDModel;
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

  Future<TargetULDModel> targetULDLoad(String scanNo, int userId, int companyCode, int menuId) async {

    try {

      var payload = {
        "Scan" : scanNo,
        "AirportCode": CommonUtils.airportCode,
        "CompanyCode": companyCode,
        "CultureCode": CommonUtils.defaultLanguageCode,
        "UserId": userId,
        "MenuId" : menuId
      };

      // Print payload for debugging
      print('TagetULDLoad: $payload --- $payload');


      Response response = await api.sendRequest.get(Apilist.targetULDApi,
          queryParameters: payload
      );

      if (response.statusCode == 200) {
        TargetULDModel targetULDModel = TargetULDModel.fromJson(response.data);
        return targetULDModel;
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

  Future<MoveULDModel> moveULDLoad(int sourceFlightSeqNo, int sourceULDSeqNo, String sourceULDType, int targetFlightSeqNo, int targetULDSeqNo, String targetULDType, int userId, int companyCode, int menuId) async {

    try {

      var payload = {
        "SourceFlightSeqNo" : sourceFlightSeqNo,
        "SourceULDSeqNo" : sourceULDSeqNo,
        "SourceULDType" : sourceULDType,
        "TargetFlightSeqNo": targetFlightSeqNo,
        "TargetULDSeqNo": targetULDSeqNo,
        "TargetULDType": targetULDType,
        "AirportCode": CommonUtils.airportCode,
        "CompanyCode": companyCode,
        "CultureCode": CommonUtils.defaultLanguageCode,
        "UserId": userId,
        "MenuId" : menuId
      };

      // Print payload for debugging
      print('moveULDLoad: $payload --- $payload');


      Response response = await api.sendRequest.post(Apilist.moveULDApi,
          data: payload
      );

      if (response.statusCode == 200) {
        MoveULDModel moveULDModel = MoveULDModel.fromJson(response.data);
        return moveULDModel;
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