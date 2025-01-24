
import 'package:dio/dio.dart';
import 'package:galaxy/api/api.dart';
import 'package:galaxy/api/apilist.dart';
import 'package:galaxy/module/export/model/buildup/shcvalidatemodel.dart';
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
import '../../model/splitgroup/splitgroupdefaultpageloadmodel.dart';
import '../../model/splitgroup/splitgroupdetailsearchmodel.dart';
import '../../model/splitgroup/splitgroupsavemodel.dart';



class MoveRepository{
  Api api = Api();

  SavedPrefrence savedPrefrence = SavedPrefrence();


  Future<MoveLocationModel> moveLocationUpdate(
      String selectedType,
      String locationCode,
      String moveXml,
      int userId,
      int companyCode,
      int menuId) async {

    try {

      var payload = {
        "Type" : selectedType,
        "LocationCode" : locationCode,
        "MoveXML" : moveXml,
        "AirportCode": CommonUtils.airportCode,
        "CompanyCode": companyCode,
        "CultureCode": CommonUtils.defaultLanguageCode,
        "UserId": userId,
        "MenuId" : menuId
      };

      // Print payload for debugging
      print('MoveLocationModel: $payload --- $payload');


      Response response = await api.sendRequest.post(Apilist.moveLocation,
          data: payload
      );

      if (response.statusCode == 200) {
        MoveLocationModel moveLocationModel = MoveLocationModel.fromJson(response.data);
        return moveLocationModel;
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

  Future<GetMoveSearchModel> getMoveSearch(
      String scanNo,
      String scanType,
      int containerItemCount,
      String containerItemType, int userId, int companyCode, int menuId) async {

    try {

      var payload = {
        "Scan" : scanNo,
        "ScanType" : scanType,
        "ContainerItemCount" : containerItemCount,
        "ContainerItemType" : containerItemType,
        "AirportCode": CommonUtils.airportCode,
        "CompanyCode": companyCode,
        "CultureCode": CommonUtils.defaultLanguageCode,
        "UserId": userId,
        "MenuId" : menuId
      };

      // Print payload for debugging
      print('getMoveSearchModel: $payload --- $payload');


      Response response = await api.sendRequest.get(Apilist.getMoveSearch,
          queryParameters: payload
      );

      if (response.statusCode == 200) {
        GetMoveSearchModel getMoveSearchModel = GetMoveSearchModel.fromJson(response.data);
        return getMoveSearchModel;
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

  Future<AddShipmentModel> addShipment(
      int flightSeqNo, int awbRowID, int awbShipmentId, int ULDSeqNo,
      String awbPrefix, String aWBNumber,
      int nop, double weight, String offPoint, String SHC,
      String IsPartShipment, String DGIndicator, String ULDTrolleyType,
      String dgType, int dgSeqNo, String dgReference, int groupId, String warningInd, String shcWarning,
      String carrierCode,
      int userId, int companyCode, int menuId) async {

    try {

      var payload = {
        "FlightSeqNo" : flightSeqNo,
        "AWBId" : awbRowID,
        "ShipmentId" : awbShipmentId,
        "AWBPrefix" : awbPrefix,
        "AWBNumber" : aWBNumber,
        "NOP" : nop,
        "Weight" : weight,
        "OffPoint" : offPoint,
        "ULDSeqNo" : ULDSeqNo,
        "SHC" : SHC,
        "IsPartShipment" : IsPartShipment,
        "DGIndicator" : DGIndicator,
        "ULDTrolleyType" : ULDTrolleyType,
        "WarningInd" : warningInd,
        "DGType" : dgType,
        "DGSeqNo" : dgSeqNo,
        "DGReference" : dgReference,
        "GroupId" : groupId,
        "SHCWarning" : shcWarning,
        "CarrierCode" : carrierCode,
        "AirportCode": CommonUtils.airportCode,
        "CompanyCode": companyCode,
        "CultureCode": CommonUtils.defaultLanguageCode,
        "UserId": userId,
        "MenuId" : menuId
      };

      // Print payload for debugging
      print('AddShipmentModel: $payload --- $payload');

      Response response = await api.sendRequest.post(Apilist.addShipment,
          data: payload
      );

      if (response.statusCode == 200) {
        AddShipmentModel addShipmentModel = AddShipmentModel.fromJson(response.data);
        return addShipmentModel;
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


  Future<RemoveMovementModel> removeMovement(
      int sequenceNo,
      String type,
      int userId,
      int companyCode,
      int menuId) async {

    try {

      var payload = {
        "SeqNo" : sequenceNo,
        "Type" : type,
        "AirportCode": CommonUtils.airportCode,
        "CompanyCode": companyCode,
        "CultureCode": CommonUtils.defaultLanguageCode,
        "UserId": userId,
        "MenuId" : menuId
      };

      // Print payload for debugging
      print('RemoveMovementModel: $payload --- $payload');


      Response response = await api.sendRequest.post(Apilist.removeMovement,
          data: payload
      );

      if (response.statusCode == 200) {
        RemoveMovementModel removeMovementModel = RemoveMovementModel.fromJson(response.data);
        return removeMovementModel;
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


/*  Future<SplitGroupDefaultPageLoadModel> splitgroupDefaultPageLoad(int userId, int companyCode, int menuId) async {

    try {

      var payload = {
        "AirportCode": CommonUtils.airportCode,
        "CompanyCode": companyCode,
        "CultureCode": CommonUtils.defaultLanguageCode,
        "UserId": userId,
        "MenuId" : menuId
      };

      // Print payload for debugging
      print('SplitGroupDefaultPageLoadModel: $payload --- $payload');


      Response response = await api.sendRequest.get(Apilist.splitGroupPageLoad,
          queryParameters: payload
      );

      if (response.statusCode == 200) {
        SplitGroupDefaultPageLoadModel splitGroupDefaultPageLoadModel = SplitGroupDefaultPageLoadModel.fromJson(response.data);
        return splitGroupDefaultPageLoadModel;
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


  Future<GetSplitGroupDetailSearchModel> getSplitGroupDetailSearchList(
      String scan, int userId, int companyCode, int menuId) async {

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
      print('getSplitGroupDetailSearchModel: $payload --- $payload');


      Response response = await api.sendRequest.get(Apilist.splitGroupDetailSearch,
          queryParameters: payload
      );

      if (response.statusCode == 200) {
        GetSplitGroupDetailSearchModel getSplitGroupDetailSearchModel = GetSplitGroupDetailSearchModel.fromJson(response.data);
        return getSplitGroupDetailSearchModel;
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


  Future<SplitGroupSaveModel> splitGroupSave(
      int expAWBRowId,
      int expShipRowId,
      int stockRowId,
      int nop,
      double weight,
      String groupId,
      String locationCode,
      int userId,
      int companyCode,
      int menuId) async {

    try {

      var payload = {
        "ExpAWBRowId" : expAWBRowId,
        "ExpShipRowId" : expShipRowId,
        "StockRowId" : stockRowId,
        "NOP" : nop,
        "Weight" : weight,
        "GroupId" : groupId,
        "LocationCode" : locationCode,
        "AirportCode": CommonUtils.airportCode,
        "CompanyCode": companyCode,
        "CultureCode": CommonUtils.defaultLanguageCode,
        "UserId": userId,
        "MenuId" : menuId
      };

      // Print payload for debugging
      print('splitGroupSaveModel: $payload --- $payload');


      Response response = await api.sendRequest.post(Apilist.splitGroupSave,
          data: payload
      );

      if (response.statusCode == 200) {
        SplitGroupSaveModel splitGroupSaveModel = SplitGroupSaveModel.fromJson(response.data);
        return splitGroupSaveModel;
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
  }*/

}
