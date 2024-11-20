import 'package:dio/dio.dart';
import 'package:galaxy/api/api.dart';
import 'package:galaxy/api/apilist.dart';
import 'package:galaxy/module/import/model/binning/binningdetaillistmodel.dart';
import 'package:galaxy/module/import/model/shipmentdamage/shipmentdamagelistmodel.dart';
import 'package:galaxy/prefrence/savedprefrence.dart';
import 'package:galaxy/utils/commonutils.dart';

import '../../model/binning/binningpageloaddefault.dart';
import '../../model/binning/binningsavemodel.dart';
import '../../model/uldacceptance/locationvalidationmodel.dart';


class ShipmentDamageRepository{
  Api api = Api();
  SavedPrefrence savedPrefrence = SavedPrefrence();



  // shipment damage detail list api
  Future<ShipmentDamageListModel> getDamageDetailListModel(String scan, String flag, int userId, int companyCode, int menuId) async {

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
      print('BinningDetailListModel: $payload --- $payload');


      Response response = await api.sendRequest.get(Apilist.getShipmentDamageDetailListApi,
          queryParameters: payload
      );

      if (response.statusCode == 200) {
        ShipmentDamageListModel shipmentDamageListModel = ShipmentDamageListModel.fromJson(response.data);
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




}