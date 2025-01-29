
import 'package:dio/dio.dart';
import 'package:galaxy/api/api.dart';
import 'package:galaxy/api/apilist.dart';
import 'package:galaxy/prefrence/savedprefrence.dart';
import 'package:galaxy/utils/commonutils.dart';
import '../../model/damageduld/getdamageduldsearchmodel.dart';




class DamagedULDRepository{
  Api api = Api();

  SavedPrefrence savedPrefrence = SavedPrefrence();


  Future<GetDamagedULDSearchModel> getSearchDamagedULD(
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
      print('getSearchDamagedULD: $payload --- $payload');


      Response response = await api.sendRequest.get(Apilist.getULDSearch,
          queryParameters: payload
      );

      if (response.statusCode == 200) {
        GetDamagedULDSearchModel getDamagedULDSearchModel = GetDamagedULDSearchModel.fromJson(response.data);
        return getDamagedULDSearchModel;
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
