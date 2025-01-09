
import 'package:dio/dio.dart';
import 'package:galaxy/api/api.dart';
import 'package:galaxy/api/apilist.dart';
import 'package:galaxy/prefrence/savedprefrence.dart';
import 'package:galaxy/utils/commonutils.dart';
import '../../../import/model/uldacceptance/locationvalidationmodel.dart';
import '../../model/buildup/buildupawblistmodel.dart';
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

  Future<GetULDTrolleySearchModel> getULDTrolleySearchList(int userId, int companyCode, int menuId) async {

    try {

      var payload = {

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


      Response response = await api.sendRequest.get(Apilist.buildUpULDTrolleySave,
          queryParameters: payload
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

  Future<ULDTrolleyPriorityUpdateModel> uldTrolleyPriorityUpdate(int flightSeqNo, int uldSeqNo, int priority, int userId, int companyCode, int menuId) async {

    try {

      var payload = {
        "FlightSeqNo" : flightSeqNo,
        "uldSeqNo" : uldSeqNo,
        "Priority" : priority,
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





/* Future<ButtonRolesRightsModel> getButtonRolesAndRights(int menuId, int userId, int companyCode) async {

    try {

      var payload = {
        "AirportCode": CommonUtils.airportCode,
        "CompanyCode": companyCode,
        "CultureCode": CommonUtils.defaultLanguageCode,
        "UserId": userId,
        "MenuId" : menuId
      };

      // Print payload for debugging
      print('ButtonRolesRightsModel: $payload --- $payload');


      Response response = await api.sendRequest.get(Apilist.getButtonRolesAndRightsApi,
          queryParameters: payload
      );

      if (response.statusCode == 200) {
        ButtonRolesRightsModel buttonRolesRightsModel = ButtonRolesRightsModel.fromJson(response.data);
        return buttonRolesRightsModel;
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



  /*Future<PageLoadDefaultModel> getPageLoadDefault(int menuId, int userId, int companyCode) async {

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


      Response response = await api.sendRequest.get(Apilist.getPageLoadApi,
          queryParameters: payload
      );

      if (response.statusCode == 200) {
        PageLoadDefaultModel pageLoadDefaultModel = PageLoadDefaultModel.fromJson(response.data);
        return pageLoadDefaultModel;
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





  // call Bd Priority api call
 /* Future<BdPriorityModel> bdPriority(int flightSeqNo, int uldSeqNo, int bdPriority, int userId, int companyCode, int menuId) async {

    try {

      var payload = {
        "FlightSeqNo": flightSeqNo,
        "ULDSeqNo": uldSeqNo,
        "BDPriority": bdPriority,
        "AirportCode": CommonUtils.airportCode,
        "CompanyCode": companyCode,
        "CultureCode": CommonUtils.defaultLanguageCode,
        "UserId": userId,
        "MenuId": menuId
      };

      // Print payload for debugging
      print('locationValidationModel: $payload --- $payload');


      Response response = await api.sendRequest.post(Apilist.updateBDPriority,
          data: payload
      );

      if (response.statusCode == 200) {
        BdPriorityModel bdPriorityModel = BdPriorityModel.fromJson(response.data);
        return bdPriorityModel;
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
*/

  // list AWB api call
 /* Future<AWBModel> getListOfAwb(int flightSeqNo, int uldSeqNo, int userId, int companyCode, int menuId, int showAll) async {

    try {

      var payload = {
        "FlightSeqNo": flightSeqNo,
        "ULDSeqNo": uldSeqNo,
        "ShowAll": showAll,
        "AirportCode": CommonUtils.airportCode,
        "CompanyCode": companyCode,
        "CultureCode": CommonUtils.defaultLanguageCode,
        "UserId": userId,
        "MenuId": menuId
      };

      // Print payload for debugging
      print('getListOfAwb: $payload --- $payload');


      Response response = await api.sendRequest.post(Apilist.awbListApi,
          data: payload
      );

      if (response.statusCode == 200) {
        AWBModel aWBModel = AWBModel.fromJson(response.data);
        return aWBModel;
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
*/













}
