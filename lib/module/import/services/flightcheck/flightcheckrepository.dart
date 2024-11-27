import 'dart:io';

import 'package:dio/dio.dart';
import 'package:galaxy/api/api.dart';
import 'package:galaxy/api/apilist.dart';
import 'package:galaxy/prefrence/savedprefrence.dart';
import 'package:galaxy/utils/commonutils.dart';
import 'package:path_provider/path_provider.dart';

import '../../model/flightcheck/addMailModel.dart';
import '../../model/flightcheck/airportcitymodel.dart';
import '../../model/flightcheck/awblistmodel.dart';
import '../../model/flightcheck/bdprioritymodel.dart';
import '../../model/flightcheck/breakdownendmodel.dart';
import '../../model/flightcheck/damagebreakdownsavemodel.dart';
import '../../model/flightcheck/damagedetailmodel.dart';
import '../../model/flightcheck/finalizeflightmodel.dart';
import '../../model/flightcheck/flightchecksummarymodel.dart';
import '../../model/flightcheck/flightcheckuldlistmodel.dart';
import '../../model/flightcheck/foundcargosavemodel.dart';
import '../../model/flightcheck/hawblistmodel.dart';
import '../../model/flightcheck/importshipmentmodel.dart';
import '../../model/flightcheck/maildetailmodel.dart';
import '../../model/flightcheck/mailtypemodel.dart';
import '../../model/flightcheck/pageloaddefault.dart';
import '../../model/flightcheck/recordatamodel.dart';
import '../../model/flightcheck/updateawbremarkacknoledge.dart';
import '../../model/uldacceptance/buttonrolesrightsmodel.dart';
import '../../model/uldacceptance/defaultuldacceptance.dart';
import '../../model/uldacceptance/flightfromuldmodel.dart';
import '../../model/uldacceptance/locationvalidationmodel.dart';
import '../../model/uldacceptance/locationvalidationmodel.dart';
import '../../model/uldacceptance/uldacceptancedetailmodel.dart';
import '../../model/uldacceptance/uldacceptsmodel.dart';
import '../../model/uldacceptance/ulddamagelistmodel.dart';
import '../../model/uldacceptance/ulddamgeupdatemodel.dart';


class FlightCheckRepository{
  Api api = Api();
  SavedPrefrence savedPrefrence = SavedPrefrence();

  // call uld damage locationValidate api call
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


  Future<ButtonRolesRightsModel> getButtonRolesAndRights(int menuId, int userId, int companyCode) async {

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
  }



  Future<PageLoadDefaultModel> getPageLoadDefault(int menuId, int userId, int companyCode) async {

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
  }



  // call uld damage locationValidate api call
  Future<FlightCheckULDListModel> getFlightCheckULDList(String locationCode, String scan, String flightNo, String flightDate, int userId, int companyCode, int menuId, int ULDListFlag) async {

    try {

      var payload = {
        "Scan" : scan,
        "FlightNo" : flightNo,
        "FlightDate" : flightDate,
        "ULDListFlag": ULDListFlag,
        "AirportCode": CommonUtils.airportCode,
        "CompanyCode": companyCode,
        "CultureCode": CommonUtils.defaultLanguageCode,
        "UserId": userId,
        "MenuId" : menuId
      };

      // Print payload for debugging
      print('FlightCheckULDListModel: $payload --- $payload');


      Response response = await api.sendRequest.post(Apilist.getFlightCheckULDListApi,
          data: payload
      );

      if (response.statusCode == 200) {
        FlightCheckULDListModel flightCheckSummaryModel = FlightCheckULDListModel.fromJson(response.data);
        return flightCheckSummaryModel;
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

// call uld damage locationValidate api call
  Future<FlightCheckSummaryModel> getFlightCheckSummaryDetails(int flightSeqNo, int userId, int companyCode, int menuId) async {

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
      print('locationValidationModel: $payload --- $payload');


      Response response = await api.sendRequest.post(Apilist.getFlightSummarysApi,
          data: payload
      );

      if (response.statusCode == 200) {
        FlightCheckSummaryModel flightCheckSummaryModel = FlightCheckSummaryModel.fromJson(response.data);
        return flightCheckSummaryModel;
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



  // call Bd Priority api call
  Future<BdPriorityModel> bdPriority(int flightSeqNo, int uldSeqNo, int bdPriority, int userId, int companyCode, int menuId) async {

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

  // call Record ATA api call
  Future<RecordATAModel> recordATA(int ataHours, int ataMins, String ataDate, int flightSeqNo, int userId, int companyCode, int menuId) async {

    try {

      var payload = {
        "ATAHours" : ataHours,
        "ATAMins" : ataMins,
        "ATA" : ataDate,
        "FlightSeqNo": flightSeqNo,
        "AirportCode": CommonUtils.airportCode,
        "CompanyCode": companyCode,
        "CultureCode": CommonUtils.defaultLanguageCode,
        "UserId": userId,
        "MenuId" : menuId
      };

      // Print payload for debugging
      print('Record ATA : $payload --- $payload');


      Response response = await api.sendRequest.post(Apilist.recordAtaApi,
          data: payload
      );

      if (response.statusCode == 200) {
        RecordATAModel bdPriorityModel = RecordATAModel.fromJson(response.data);
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

  // call FinalizeFlight api call
  Future<FinalizeFlightModel> finalizeFlight(int flightSeqNo, int userId, int companyCode, int menuId) async {

    try {

      var payload = {
        "FlightSeqNo": flightSeqNo,
        "AirportCode": CommonUtils.airportCode,
        "CompanyCode": companyCode,
        "CultureCode": CommonUtils.defaultLanguageCode,
        "UserId": userId,
        "MenuId" : menuId
      };

      // Print payload for debugging
      print('Record ATA : $payload --- $payload');


      Response response = await api.sendRequest.post(Apilist.finalizeFlightApi,
          data: payload
      );

      if (response.statusCode == 200) {
        FinalizeFlightModel finalizeFlightModel = FinalizeFlightModel.fromJson(response.data);
        return finalizeFlightModel;
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

  // list AWB api call
  Future<AWBModel> getListOfAwb(int flightSeqNo, int uldSeqNo, int userId, int companyCode, int menuId, int showAll) async {

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


  // call AWB Bd Priority api call
  Future<BdPriorityModel> bdPriorityAWB(int iMPShipRowId, int bdPriority, int userId, int companyCode, int menuId) async {

    try {

      var payload = {
        "IMPShipRowId": iMPShipRowId,
        "BDPriority": bdPriority,
        "AirportCode": CommonUtils.airportCode,
        "CompanyCode": companyCode,
        "CultureCode": CommonUtils.defaultLanguageCode,
        "UserId": userId,
        "MenuId": menuId
      };

      // Print payload for debugging
      print('locationValidationModel: $payload --- $payload');


      Response response = await api.sendRequest.post(Apilist.updateBDPriorityAWB,
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


  Future<AWBRemarkAcknoledgeModel> getAWBAcknoledge(int iMPAWBRowId, int iMPShipRowId, int userId, int companyCode, int menuId) async {

    try {

      var payload = {
        "IMPAWBRowId": iMPAWBRowId,
        "IMPShipRowId": iMPShipRowId,
        "AirportCode": CommonUtils.airportCode,
        "CompanyCode": companyCode,
        "CultureCode": CommonUtils.defaultLanguageCode,
        "UserId": userId,
        "MenuId": menuId
      };

      // Print payload for debugging
      print('aWBRemarkAcknoledgeModel: $payload --- $payload');


      Response response = await api.sendRequest.post(Apilist.updateAWBRemarksAcknowledge,
          data: payload
      );

      if (response.statusCode == 200) {
        AWBRemarkAcknoledgeModel aWBRemarkAcknoledgeModel = AWBRemarkAcknoledgeModel.fromJson(response.data);
        return aWBRemarkAcknoledgeModel;
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



  Future<MailTypeModel> getMailTypeList(int userId, int companyCode, int menuId) async {

    try {

      var payload = {
        "AirportCode": CommonUtils.airportCode,
        "CompanyCode": companyCode,
        "CultureCode": CommonUtils.defaultLanguageCode,
        "UserId": userId,
        "MenuId": menuId
      };

      // Print payload for debugging
      print('addMailModel: $payload --- $payload');


      Response response = await api.sendRequest.post(Apilist.getMailTypeApi,
          data: payload
      );

      if (response.statusCode == 200) {
        MailTypeModel mailTypeModel = MailTypeModel.fromJson(response.data);
        return mailTypeModel;
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


  Future<MailDetailModel> getMailDetail(int flightSeqNo, int uldSeqNo, int userId, int companyCode, int menuId) async {

    try {

      var payload = {
        "FlightSeqNo": flightSeqNo,
        "ULDSeqNo": uldSeqNo,
        "AirportCode": CommonUtils.airportCode,
        "CompanyCode": companyCode,
        "CultureCode": CommonUtils.defaultLanguageCode,
        "UserId": userId,
        "MenuId": menuId
      };

      // Print payload for debugging
      print('addMailModel: $payload --- $payload');


      Response response = await api.sendRequest.post(Apilist.getAddMailDetailsApi,
          data: payload
      );

      if (response.statusCode == 200) {
        MailDetailModel mailDetailModel = MailDetailModel.fromJson(response.data);
        return mailDetailModel;
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




  Future<AddMailModel> addMail(int flightSeqNo, int uldSeqNo, String av7No, String mailType, String origin, String destination, int nOP, double weight, String description, int userId, int companyCode, int menuId) async {

    try {

      var payload = {
        "FlightSeqNo": flightSeqNo,
        "ULDSeqNo": uldSeqNo,
        "AV7No": av7No,
        "MailType": mailType,
        "Origin": origin,
        "Destination": destination,
        "NOP": nOP,
        "WeightKg": weight,
        "Description": description,
        "AirportCode": CommonUtils.airportCode,
        "CompanyCode": companyCode,
        "CultureCode": CommonUtils.defaultLanguageCode,
        "UserId": userId,
        "MenuId": menuId
      };

      // Print payload for debugging
      print('addMailModel: $payload --- $payload');


      Response response = await api.sendRequest.post(Apilist.addMailApi,
          data: payload
      );

      if (response.statusCode == 200) {
        AddMailModel addMailModel = AddMailModel.fromJson(response.data);
        return addMailModel;
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

  Future<AirportCityModel> checkAirportCity(String airportcity, int userId, int companyCode, int menuId) async {

    try {

      var payload = {

        "AirportCodeInput": airportcity,
        "AirportCode": CommonUtils.airportCode,
        "CompanyCode": companyCode,
        "CultureCode": CommonUtils.defaultLanguageCode,
        "UserId": userId,
        "MenuId": menuId
      };

      // Print payload for debugging
      print('checkAirportCity: $payload --- $payload');


      Response response = await api.sendRequest.get(Apilist.checkAirportApi,
          queryParameters: payload
      );

      if (response.statusCode == 200) {
        AirportCityModel airportCityModel = AirportCityModel.fromJson(response.data);
        return airportCityModel;
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

  Future<ImportShipmentModel> importManifestSave(String locationCode, int flightSeqNo, int uLDSeqNo, String groupId, String awbId, String hawbid, int nopInput, String wtInput, int userId, int companyCode, int menuId) async {

    try {

      var payload = {
        "LocationCode" : locationCode,
        "FlightSeqNo" : flightSeqNo,
        "ULDSeqNo" : uLDSeqNo,
        "GroupId" : groupId,
        "AWBId" : awbId,
        "HAWBId": hawbid,
        "IsOverride": "N",
        "NOPInput": nopInput,
        "WtInput": wtInput,
        "AirportCode": CommonUtils.airportCode,
        "CompanyCode": companyCode,
        "CultureCode": CommonUtils.defaultLanguageCode,
        "UserId": userId,
        "MenuId": menuId
      };

      // Print payload for debugging
      print('checkAirportCity: $payload --- $payload');


      Response response = await api.sendRequest.post(Apilist.importManifestSaveApi,
          data: payload
      );

      if (response.statusCode == 200) {
        ImportShipmentModel importShipmentModel = ImportShipmentModel.fromJson(response.data);
        return importShipmentModel;
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

  Future<BreakDownEndModel> breakDownEnd(int flightSeqNo, int uLDSeqNo, String isConfirm, int userId, int companyCode, int menuId) async {

    try {

      var payload = {
        "FlightSeqNo" : flightSeqNo,
        "ULDSeqNo" : uLDSeqNo,
        "IsConfirm": isConfirm,
        "AirportCode": CommonUtils.airportCode,
        "CompanyCode": companyCode,
        "CultureCode": CommonUtils.defaultLanguageCode,
        "UserId": userId,
        "MenuId": menuId
      };

      // Print payload for debugging
      print('checkAirportCity: $payload --- $payload');


      Response response = await api.sendRequest.post(Apilist.breakDownEndApi,
          data: payload
      );

      if (response.statusCode == 200) {
        BreakDownEndModel breakDownEndModel = BreakDownEndModel.fromJson(response.data);
        return breakDownEndModel;
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

  Future<DamageDetailsModel> getDamageDetails(
      int flightSeqNo,
      String AWBId,
      String SHIPId,
      int problemSeqId,
      String groupId,
      int userId,
      int companyCode, int menuId) async {

    try {

      var payload = {
        "FlightSeqNo" : flightSeqNo,
        "AWBId" : AWBId,
        "SHIPId": SHIPId,
        "GroupId" : groupId,
        "ProblemSeqId" : problemSeqId,
        "AirportCode": CommonUtils.airportCode,
        "CompanyCode": companyCode,
        "CultureCode": CommonUtils.defaultLanguageCode,
        "UserId": userId,
        "MenuId": menuId
      };

      // Print payload for debugging
      print('checkAirportCity: $payload --- $payload');


      Response response = await api.sendRequest.post(Apilist.getDamageDetailsApi,
          data: payload
      );

      if (response.statusCode == 200) {
        DamageDetailsModel damageDetailsModel = DamageDetailsModel.fromJson(response.data);
        return damageDetailsModel;
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

  Future<DamageBreakDownSaveModel> damageBreakDownSave(
      String awbPrefix, String awbNumber,
      int AWBId, int SHIPId, int flightSeqNo,
      String typeOfDiscrepancy,
      int shipTotalPcs, String ShipTotalWt, int shipDamagePcs, String ShipDamageWt, int shipDifferencePcs, String shipDifferenceWt,
      String individualWTPerDoc, String individualWTActChk, String individualWTDifference,
      String containerMaterial, String containerType,
      String marksLabels,
      String outerPacking,
      String innerPacking,
      String damageObserContent,
      String damageObserContainers,
      String damageDiscovered,
      String spaceForMissing,
      String verifiedInvoice,
      String isSufficient,
      String evidenceOfPilerage,
      String remarks,
      String aparentCause,
      String salvageAction,
      String disposition,
      String damageRemarked,
      String weatherCondition,
      String GHARepresent,
      String AirlineRepresent,
      String SecurityRepresent,
      int problemSeqId,
      String XmlBinaryImage,
      String groupid,
      int userId, int companyCode, int menuId) async {

    try {
      var payload = {
        "AwbPrefix" : awbPrefix,
        "AwbNumber" : awbNumber,
        "AWBId" : AWBId,
        "SHIPId": SHIPId,
        "FlightSeqNo" : flightSeqNo,
        "HouseSeqNo": 0,
        "TypeOfDiscrepancy": typeOfDiscrepancy,
        "ShipTotalPcs": shipTotalPcs,
        "ShipTotalWt": ShipTotalWt,
        "ShipDamagePcs": shipDamagePcs,
        "ShipDamageWt": ShipDamageWt,
        "ShipDifferencePcs": shipDifferencePcs,
        "ShipDifferenceWt": shipDifferenceWt,
        "IndividualWTPerDoc": individualWTPerDoc,
        "IndividualWTActChk": individualWTActChk,
        "IndividualWTDifference": individualWTDifference,
        "ContainerMaterial": containerMaterial,
        "ContainerType": containerType,
        "MarksLabels": marksLabels,
        "OuterPacking": outerPacking,
        "InnerPacking": innerPacking,
        "DamageObserContent": damageObserContent,
        "DamageObserContainers": damageObserContainers,
        "DamageDiscovered": damageDiscovered,
        "SpaceForMissing": spaceForMissing,
        "VerifiedInvoice": verifiedInvoice,
        "IsSufficient": isSufficient,
        "EvidenceOfPilerage": evidenceOfPilerage,
        "Remarks": remarks,
        "AparentCause": aparentCause,
        "SalvageAction": salvageAction,
        "Disposition": disposition,

        "DamageRemarked": damageRemarked,
        "WeatherCondition": weatherCondition,
        "GHARepresent": GHARepresent,
        "AirlineRepresent": AirlineRepresent,
        "SecurityRepresent": SecurityRepresent,
        "ProblemSeqId" : problemSeqId,
        "XmlBinaryImage": XmlBinaryImage,
        "GroupId" : groupid,
        "AirportCode": CommonUtils.airportCode,
        "CompanyCode": companyCode,
        "CultureCode": CommonUtils.defaultLanguageCode,
        "UserId": userId,
        "MenuId": menuId
      };

      // Print payload for debugging
      print('damageBreakDownSave: $payload --- $payload');


      Response response = await api.sendRequest.post(Apilist.damageDetailsSaveApi,
          data: payload
      );


      if (response.statusCode == 200) {
        DamageBreakDownSaveModel damageBreakDownSaveModel = DamageBreakDownSaveModel.fromJson(response.data);
        return damageBreakDownSaveModel;
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

  // list HOUSE api call
  Future<HAWBModel> getListOfHouses(int flightSeqNo, int uldSeqNo, int IMPAWBRowId, int userId, int companyCode, int menuId, int showAll) async {

    try {

      var payload = {
        "FlightSeqNo": flightSeqNo,
        "ULDSeqNo": uldSeqNo,
        "IMPAWBRowId": IMPAWBRowId,
        "ShowAll": showAll,
        "AirportCode": CommonUtils.airportCode,
        "CompanyCode": companyCode,
        "CultureCode": CommonUtils.defaultLanguageCode,
        "UserId": userId,
        "MenuId": menuId
      };

      // Print payload for debugging
      print('getListOfAwb: $payload --- $payload');


      Response response = await api.sendRequest.post(Apilist.houseListApi,
          data: payload
      );

      if (response.statusCode == 200) {
        HAWBModel hAWBModel = HAWBModel.fromJson(response.data);
        return hAWBModel;
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


  // Found Cargo save api call
  Future<FoundCargoSaveModel> addFoundCargoSave(
      int flightSeqNo,
      int uldSeqNo,
      String awbNo,
      int npr,
      double wtRec,
      String groupId,
      String locationCode,
      String origin,
      String destination,
      int userId,
      int companyCode,
      int menuId) async {

    try {

      var payload = {
        "FlightSeqNo": flightSeqNo,
        "ULDSeqNo": uldSeqNo,
        "AWBNo": awbNo,
        "HouseNo": "",
        "NPR": npr,
        "WtRec": wtRec,
        "DMGPsc": 0,
        "DMGWt": 0.0,
        "DMGCode": "",
        "GroupId": groupId,
        "LocationCode": locationCode,
        "Origin": origin,
        "Destination": destination,
        "AirportCode": CommonUtils.airportCode,
        "CompanyCode": companyCode,
        "CultureCode": CommonUtils.defaultLanguageCode,
        "UserId": userId,
        "MenuId": menuId
      };

      // Print payload for debugging
      print('foundCargoSaveModel: $payload --- $payload');


      Response response = await api.sendRequest.post(Apilist.foundCargoSaveApi,
          data: payload
      );

      if (response.statusCode == 200) {
        FoundCargoSaveModel foundCargoSaveModel = FoundCargoSaveModel.fromJson(response.data);
        return foundCargoSaveModel;
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