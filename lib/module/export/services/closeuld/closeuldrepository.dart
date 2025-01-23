import 'package:dio/dio.dart';
import '../../../../api/api.dart';
import '../../../../api/apilist.dart';
import '../../../../prefrence/savedprefrence.dart';
import '../../../../utils/commonutils.dart';
import '../../model/closeuld/closereopenmodel.dart';
import '../../model/closeuld/closeuldsearchmodel.dart';
import '../../model/closeuld/equipmentmodel.dart';
import '../../model/closeuld/getcontourlistmodel.dart';
import '../../model/closeuld/getdocumentlistmodel.dart';
import '../../model/closeuld/getremarklistmodel.dart';
import '../../model/closeuld/getscaleistmodel.dart';
import '../../model/closeuld/savecontourmodel.dart';
import '../../model/closeuld/saveequipmentmodel.dart';
import '../../model/closeuld/saveremarkmodel.dart';
import '../../model/closeuld/savescalemodel.dart';
import '../../model/closeuld/savetareweightmodel.dart';



class CloseULDRepository{
  Api api = Api();
  SavedPrefrence savedPrefrence = SavedPrefrence();

  /*Future<SearchULDTrolleyModel> scanCloseULDModel(String scan, int userId, int companyCode, int menuId) async {

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
      print('scanCloseULDModel: $payload --- $payload');


      Response response = await api.sendRequest.get(Apilist.searchULDTrollPageLoadApi,
          queryParameters: payload
      );

      if (response.statusCode == 200) {
        SearchULDTrolleyModel searchULDTrolleyModel = SearchULDTrolleyModel.fromJson(response.data);
        return searchULDTrolleyModel;
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

  Future<CloseULDSearchModel> closeULDSearchModel(String scan, int flightSeqNo, int userId, int companyCode, int menuId) async {

    try {

      var payload = {
        "Scan" : scan,
        "FlightSeqNo" : flightSeqNo,
        "AirportCode": CommonUtils.airportCode,
        "CompanyCode": companyCode,
        "CultureCode": CommonUtils.defaultLanguageCode,
        "UserId": userId,
        "MenuId" : menuId
      };

      // Print payload for debugging
      print('closeULDSearchModel: $payload --- $payload');


      Response response = await api.sendRequest.get(Apilist.closeULDSearchApi,
          queryParameters: payload
      );

      if (response.statusCode == 200) {
        CloseULDSearchModel closeULDSearchModel = CloseULDSearchModel.fromJson(response.data);
        return closeULDSearchModel;
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

  Future<CloseULDEquipmentModel> closeULDEquipmentModel(int uldSeqNo, String uldType, int userId, int companyCode, int menuId) async {

    try {

      var payload = {
        "ULDSeqNo" : uldSeqNo,
        "ULDType" : uldType,
        "AirportCode": CommonUtils.airportCode,
        "CompanyCode": companyCode,
        "CultureCode": CommonUtils.defaultLanguageCode,
        "UserId": userId,
        "MenuId" : menuId
      };

      // Print payload for debugging
      print('closeULDEquipmentModel: $payload --- $payload');


      Response response = await api.sendRequest.get(Apilist.closeULDEquipmentApi,
          queryParameters: payload
      );

      if (response.statusCode == 200) {
        CloseULDEquipmentModel searchULDTrolleyModel = CloseULDEquipmentModel.fromJson(response.data);
        return searchULDTrolleyModel;
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

  Future<SaveEquipmentModel> saveEquipmentModel(int flightSeqNo, int uldSeqNo, String uldType, String equipXML,  int userId, int companyCode, int menuId) async {

    try {

      var payload = {
        "FlightSeqNo" : flightSeqNo,
        "ULDSeqNo" : uldSeqNo,
        "ULDType" : uldType,
        "EquipXML" : equipXML,
        "AirportCode": CommonUtils.airportCode,
        "CompanyCode": companyCode,
        "CultureCode": CommonUtils.defaultLanguageCode,
        "UserId": userId,
        "MenuId" : menuId
      };

      // Print payload for debugging
      print('saveEquipmentModel: $payload --- $payload');


      Response response = await api.sendRequest.post(Apilist.saveEquipmentApi,
          data: payload
      );

      if (response.statusCode == 200) {
        SaveEquipmentModel saveEquipmentModel = SaveEquipmentModel.fromJson(response.data);
        return saveEquipmentModel;
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

  Future<SaveContourModel> saveContourModel(int flightSeqNo, int uldSeqNo, String contourCode, double height,  int userId, int companyCode, int menuId) async {

    try {

      var payload = {
        "FlightSeqNo" : flightSeqNo,
        "ULDSeqNo" : uldSeqNo,
        "ContourCode" : contourCode,
        "Height" : height,
        "AirportCode": CommonUtils.airportCode,
        "CompanyCode": companyCode,
        "CultureCode": CommonUtils.defaultLanguageCode,
        "UserId": userId,
        "MenuId" : menuId
      };

      // Print payload for debugging
      print('SaveContourModel: $payload --- $payload');


      Response response = await api.sendRequest.post(Apilist.saveContourApi,
          data: payload
      );

      if (response.statusCode == 200) {
        SaveContourModel saveContourModel = SaveContourModel.fromJson(response.data);
        return saveContourModel;
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


  Future<GetScaleListModel> getScaleList(int flightSeqNo, int uldSeqNo, int userId, int companyCode, int menuId) async {

    try {

      var payload = {
        "FlightSeqNo" : flightSeqNo,
        "ULDSeqNo" : uldSeqNo,
        "AirportCode": CommonUtils.airportCode,
        "CompanyCode": companyCode,
        "CultureCode": CommonUtils.defaultLanguageCode,
        "UserId": userId,
        "MenuId" : menuId
      };

      // Print payload for debugging
      print('GetScaleListModel: $payload --- $payload');


      Response response = await api.sendRequest.get(Apilist.closeULDScaleApi,
          queryParameters: payload
      );

      if (response.statusCode == 200) {
        GetScaleListModel getScaleListModel = GetScaleListModel.fromJson(response.data);
        return getScaleListModel;
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

  Future<SaveScaleModel> saveScaleModel(int flightSeqNo, int uldSeqNo, double scaleWeight, String machineNo, int userId, int companyCode, int menuId) async {

    try {

      var payload = {
        "FlightSeqNo" : flightSeqNo,
        "ULDSeqNo" : uldSeqNo,
        "ScaleWeight" : scaleWeight,
        "MachineNo" : machineNo,
        "AirportCode": CommonUtils.airportCode,
        "CompanyCode": companyCode,
        "CultureCode": CommonUtils.defaultLanguageCode,
        "UserId": userId,
        "MenuId" : menuId
      };

      // Print payload for debugging
      print('SaveScaleModel: $payload --- $payload');


      Response response = await api.sendRequest.post(Apilist.saveScaleApi,
          data: payload
      );

      if (response.statusCode == 200) {
        SaveScaleModel saveScaleModel = SaveScaleModel.fromJson(response.data);
        return saveScaleModel;
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



  Future<GetRemarkListModel> getRemarkList(int uldSeqNo, int userId, int companyCode, int menuId) async {

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
      print('GetRemarkListModel: $payload --- $payload');


      Response response = await api.sendRequest.get(Apilist.closeULDRemarkApi,
          queryParameters: payload
      );

      if (response.statusCode == 200) {
        GetRemarkListModel getRemarkListModel = GetRemarkListModel.fromJson(response.data);
        return getRemarkListModel;
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

  Future<SaveRemarkModel> saveRemarkModel(int flightSeqNo, int uldSeqNo, String remarks, int userId, int companyCode, int menuId) async {

    try {

      var payload = {
        "FlightSeqNo" : flightSeqNo,
        "ULDSeqNo" : uldSeqNo,
        "Remarks" : remarks,
        "AirportCode": CommonUtils.airportCode,
        "CompanyCode": companyCode,
        "CultureCode": CommonUtils.defaultLanguageCode,
        "UserId": userId,
        "MenuId" : menuId
      };

      // Print payload for debugging
      print('SaveRemarkModel: $payload --- $payload');


      Response response = await api.sendRequest.post(Apilist.saveemarkApi,
          data: payload
      );

      if (response.statusCode == 200) {
        SaveRemarkModel saveRemarkModel = SaveRemarkModel.fromJson(response.data);
        return saveRemarkModel;
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

  Future<SaveTareWeightModel> saveTareWeightModel(int uldSeqNo, double tareWeight, int userId, int companyCode, int menuId) async {

    try {

      var payload = {
        "ULDSeqNo" : uldSeqNo,
        "TareWeight" : tareWeight,
        "AirportCode": CommonUtils.airportCode,
        "CompanyCode": companyCode,
        "CultureCode": CommonUtils.defaultLanguageCode,
        "UserId": userId,
        "MenuId" : menuId
      };

      // Print payload for debugging
      print('saveTareWeightModel: $payload --- $payload');


      Response response = await api.sendRequest.post(Apilist.saveTareWeightApi,
          data: payload
      );

      if (response.statusCode == 200) {
        SaveTareWeightModel saveTareWeightModel = SaveTareWeightModel.fromJson(response.data);
        return saveTareWeightModel;
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


  Future<GetDocumentListModel> getDocumentList(int uldSeqNo, int flightSeqNo, int userId, int companyCode, int menuId) async {

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
      print('GetDocumentListModel: $payload --- $payload');


      Response response = await api.sendRequest.get(Apilist.closeULDGetDocumentList,
          queryParameters: payload
      );

      if (response.statusCode == 200) {
        GetDocumentListModel getDocumentListModel = GetDocumentListModel.fromJson(response.data);
        return getDocumentListModel;
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



  Future<CloseReopenModel> closeReopenULDModel(int flightSeqNo, int uldSeqNo, String uldStatus,  int userId, int companyCode, int menuId) async {

    try {

      var payload = {
        "FlightSeqNo" : flightSeqNo,
        "ULDSeqNo" : uldSeqNo,
        "ULDStatus" : uldStatus,
        "AirportCode": CommonUtils.airportCode,
        "CompanyCode": companyCode,
        "CultureCode": CommonUtils.defaultLanguageCode,
        "UserId": userId,
        "MenuId" : menuId
      };

      // Print payload for debugging
      print('SaveRemarkModel: $payload --- $payload');


      Response response = await api.sendRequest.post(Apilist.closeULDStatusUpdate,
          data: payload
      );

      if (response.statusCode == 200) {
        CloseReopenModel closeReopenModel = CloseReopenModel.fromJson(response.data);
        return closeReopenModel;
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