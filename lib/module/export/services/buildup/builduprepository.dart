
import 'package:dio/dio.dart';
import 'package:galaxy/api/api.dart';
import 'package:galaxy/api/apilist.dart';
import 'package:galaxy/module/export/model/buildup/shcvalidatemodel.dart';
import 'package:galaxy/prefrence/savedprefrence.dart';
import 'package:galaxy/utils/commonutils.dart';
import '../../../import/model/uldacceptance/locationvalidationmodel.dart';
import '../../model/buildup/awbacknowledgemodel.dart';
import '../../model/buildup/awbprioritymodel.dart';
import '../../model/buildup/buildupawblistmodel.dart';
import '../../model/buildup/buildupgrouplistmodel.dart';
import '../../model/buildup/flightsearchmodel.dart';
import '../../model/buildup/getuldtrolleysavemodel.dart';
import '../../model/buildup/getuldtrolleysearchmodel.dart';
import '../../model/buildup/uldtrolleyprioritymodel.dart';
import '../../model/closeuld/getcontourlistmodel.dart';



class BuildUpRepository{
  Api api = Api();
  SavedPrefrence savedPrefrence = SavedPrefrence();

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



  Future<FlightSearchModel> getFlightSearch(
      String flightNo, String flightDate, int userId, int companyCode, int menuId) async {

    try {

      var payload = {
        "FlightNo" : flightNo,
        "FlightDate" : flightDate,
        "AirportCode": CommonUtils.airportCode,
        "CompanyCode": companyCode,
        "CultureCode": CommonUtils.defaultLanguageCode,
        "UserId": userId,
        "MenuId" : menuId
      };

      // Print payload for debugging
      print('FlightSearchModel: $payload --- $payload');


      Response response = await api.sendRequest.get(Apilist.buildUpFlightSearch,
          queryParameters: payload
      );

      if (response.statusCode == 200) {
        FlightSearchModel flightSearchModel = FlightSearchModel.fromJson(response.data);
        return flightSearchModel;
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

  Future<GetULDTrolleySearchModel> getULDTrolleySearchList(int flightSeqNo, int userId, int companyCode, int menuId) async {

    try {

      var payload = {
        "FlightSeqNo" : flightSeqNo,
        "AirportCode": CommonUtils.airportCode,
        "CompanyCode": companyCode,
        "CultureCode": CommonUtils.defaultLanguageCode,
        "UserId": userId,
        "MenuId" : menuId
      };

      // Print payload for debugging
      print('getULDTrolleySearchModel: $payload --- $payload');


      Response response = await api.sendRequest.get(Apilist.buildUpULDTrolleySearch,
          queryParameters: payload
      );

      if (response.statusCode == 200) {
        GetULDTrolleySearchModel getULDTrolleySearchModel = GetULDTrolleySearchModel.fromJson(response.data);
        return getULDTrolleySearchModel;
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


  Future<GetULDTrolleySaveModel> getULDTrolleySave(
      int flightSeqNo,
      String uldType,
      String uldNumber,
      String uldOwner,
      String uldSpecification,
      String trolleyType,
      String trolleyNumber,
      double tareWeight,
      String contourCode,
      int contourHeight,
      int priority,
      String offPoint,
      String uldTrolleyType,
      int userId,
      int companyCode,
      int menuId) async {

    try {

      var payload = {
        "FlightSeqNo" : flightSeqNo,
        "ULDType" : uldType,
        "ULDNumber" : uldNumber,
        "ULDOwner" : uldOwner,
        "ULDSpecification" : uldSpecification,
        "TrolleyType" : trolleyType,
        "TrolleyNumber" : trolleyNumber,
        "TareWt" : tareWeight,
        "ContourCode" : contourCode,
        "ContourHeight" : contourHeight,
        "Priority" : priority,
        "OffPoint" : offPoint,
        "ULDTrolleyType" : uldTrolleyType,
        "AirportCode": CommonUtils.airportCode,
        "CompanyCode": companyCode,
        "CultureCode": CommonUtils.defaultLanguageCode,
        "UserId": userId,
        "MenuId" : menuId
      };

      // Print payload for debugging
      print('GetULDTrolleySaveModel: $payload --- $payload');


      Response response = await api.sendRequest.post(Apilist.buildUpULDTrolleySave,
          data: payload
      );

      if (response.statusCode == 200) {
        GetULDTrolleySaveModel getULDTrolleySaveModel = GetULDTrolleySaveModel.fromJson(response.data);
        return getULDTrolleySaveModel;
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

  Future<ULDTrolleyPriorityUpdateModel> uldTrolleyPriorityUpdate(int uldSeqNo, int priority, String uldType, int userId, int companyCode, int menuId) async {

    try {

      var payload = {
        "SeqNo" : uldSeqNo,
        "Priority" : priority,
        "ULDType" : uldType,
        "AirportCode": CommonUtils.airportCode,
        "CompanyCode": companyCode,
        "CultureCode": CommonUtils.defaultLanguageCode,
        "UserId": userId,
        "MenuId": menuId
      };

      // Print payload for debugging
      print('uldTrolleyPriorityUpdate: $payload --- $payload');


      Response response = await api.sendRequest.post(Apilist.buildUpULDTrolleypriorityUpdate,
          data: payload
      );

      if (response.statusCode == 200) {
        ULDTrolleyPriorityUpdateModel uLDTrolleyPriorityUpdateModel = ULDTrolleyPriorityUpdateModel.fromJson(response.data);
        return uLDTrolleyPriorityUpdateModel;
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

  Future<AWBPriorityUpdateModel> awbPriorityUpdate(int expRowId, int priority, int userId, int companyCode, int menuId) async {

    try {

      var payload = {
        "EXPAWBRowId" : expRowId,
        "Priority" : priority,
        "AirportCode": CommonUtils.airportCode,
        "CompanyCode": companyCode,
        "CultureCode": CommonUtils.defaultLanguageCode,
        "UserId": userId,
        "MenuId": menuId
      };

      // Print payload for debugging
      print('AWBPriorityUpdateModel: $payload --- $payload');


      Response response = await api.sendRequest.post(Apilist.buildUpAWBPriorityUpdate,
          data: payload
      );

      if (response.statusCode == 200) {
        AWBPriorityUpdateModel awbPriorityUpdateModel = AWBPriorityUpdateModel.fromJson(response.data);
        return awbPriorityUpdateModel;
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

  Future<AWBAcknowledgeUpdateModel> awbAcknowledgeUpdate(int expRowId, int expShipRowId, int userId, int companyCode, int menuId) async {

    try {

      var payload = {
        "EXPAWBRowId" : expRowId,
        "EXPShipRowId" : expShipRowId,
        "AirportCode": CommonUtils.airportCode,
        "CompanyCode": companyCode,
        "CultureCode": CommonUtils.defaultLanguageCode,
        "UserId": userId,
        "MenuId": menuId
      };

      // Print payload for debugging
      print('AWBAcknowledgeUpdateModel: $payload --- $payload');


      Response response = await api.sendRequest.post(Apilist.buildUpAWBRemarkAcknoledge,
          data: payload
      );

      if (response.statusCode == 200) {
        AWBAcknowledgeUpdateModel awbAcknowledgeUpdateModel = AWBAcknowledgeUpdateModel.fromJson(response.data);
        return awbAcknowledgeUpdateModel;
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


  Future<GetContourListModel> getContourList(int uldSeqNo, int userId, int companyCode, int menuId) async {

    try {

      var payload = {
        "ULDSeqNo" : uldSeqNo,
        "AirportCode": CommonUtils.airportCode,
        "CompanyCode": companyCode,
        "CultureCode": CommonUtils.defaultLanguageCode,
        "UserId": userId,
        "MenuId" : menuId
      };

      // Print payload for debugging
      print('closeULDEquipmentModel: $payload --- $payload');


      Response response = await api.sendRequest.get(Apilist.closeULDContourApi,
          queryParameters: payload
      );

      if (response.statusCode == 200) {
        GetContourListModel getContourListModel = GetContourListModel.fromJson(response.data);
        return getContourListModel;
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



  Future<BuildUpAWBModel> getAwbDetailList(int flightSeqNo, int userId, int companyCode, int menuId) async {

    try {

      var payload = {
        "FlightSeqNo" : flightSeqNo,
        "AirportCode": CommonUtils.airportCode,
        "CompanyCode": companyCode,
        "CultureCode": CommonUtils.defaultLanguageCode,
        "UserId": userId,
        "MenuId": menuId
      };

      // Print payload for debugging
      print('BuildUpAWBModel: $payload --- $payload');


      Response response = await api.sendRequest.get(Apilist.buildUpGetAWBDetails,
          queryParameters: payload
      );

      if (response.statusCode == 200) {
        BuildUpAWBModel buildUpAWBModel = BuildUpAWBModel.fromJson(response.data);
        return buildUpAWBModel;
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

  Future<BuildUpGroupModel> getGroupDetailList(int flightSeqNo, int userId, int companyCode, int menuId) async {

    try {

      var payload = {
        "FlightSeqNo" : flightSeqNo,
        "AirportCode": CommonUtils.airportCode,
        "CompanyCode": companyCode,
        "CultureCode": CommonUtils.defaultLanguageCode,
        "UserId": userId,
        "MenuId": menuId
      };

      // Print payload for debugging
      print('BuildUpGroupModel: $payload --- $payload');


      Response response = await api.sendRequest.get(Apilist.buildUpGetGroupDetails,
          queryParameters: payload
      );

      if (response.statusCode == 200) {
        BuildUpGroupModel buildUpGroupModel = BuildUpGroupModel.fromJson(response.data);
        return buildUpGroupModel;
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



  Future<SHCValidateModel> shcValidateCode(String shcCode, int userId, int companyCode, int menuId) async {

    try {

      var payload = {
        "ShcCode" : shcCode,
        "AirportCode": CommonUtils.airportCode,
        "CompanyCode": companyCode,
        "CultureCode": CommonUtils.defaultLanguageCode,
        "UserId": userId,
        "MenuId": menuId
      };

      // Print payload for debugging
      print('shcValidateModel: $payload --- $payload');


      Response response = await api.sendRequest.get(Apilist.shcValidate,
          queryParameters: payload
      );

      if (response.statusCode == 200) {
        SHCValidateModel shcValidateModel = SHCValidateModel.fromJson(response.data);
        return shcValidateModel;
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
