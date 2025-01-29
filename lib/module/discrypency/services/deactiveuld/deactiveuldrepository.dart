
import 'package:dio/dio.dart';
import 'package:galaxy/api/api.dart';
import 'package:galaxy/api/apilist.dart';
import 'package:galaxy/prefrence/savedprefrence.dart';
import 'package:galaxy/utils/commonutils.dart';
import '../../model/damageduld/getdamageduldsearchmodel.dart';
import '../../model/deactiveuld/getuldsearchmodel.dart';
import '../../model/deactiveuld/ulddeactivatemodel.dart';




class DeactiveULDRepository{
  Api api = Api();

  SavedPrefrence savedPrefrence = SavedPrefrence();


  Future<GetULDSearchModel> getSearchULD(
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
      print('getULDSearchModel: $payload --- $payload');


      Response response = await api.sendRequest.get(Apilist.getULDSearch,
          queryParameters: payload
      );

      if (response.statusCode == 200) {
        GetULDSearchModel getULDSearchModel = GetULDSearchModel.fromJson(response.data);
        return getULDSearchModel;
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


  Future<ULDDeactivateModel> recordDeactivate(
      int uldSeqNo,
      int flightSeqNo,
      int userId,
      int companyCode,
      int menuId) async {

    try {

      var payload = {
        "ULDSeqNo" : uldSeqNo,
        "FlightSeqNo" : flightSeqNo,
        "AirportCode": CommonUtils.airportCode,
        "CompanyCode": companyCode,
        "CultureCode": CommonUtils.defaultLanguageCode,
        "UserId": userId,
        "MenuId" : menuId
      };

      // Print payload for debugging
      print('uldDeactivateModel: $payload --- $payload');


      Response response = await api.sendRequest.post(Apilist.getULDDeactive,
          data: payload
      );

      if (response.statusCode == 200) {
        ULDDeactivateModel uldDeactivateModel = ULDDeactivateModel.fromJson(response.data);
        return uldDeactivateModel;
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
