


import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:galaxy/module/import/services/flightcheck/flightcheckrepository.dart';

import 'flightcheckstate.dart';

class FlightCheckCubit extends Cubit<FlightCheckState>{
  FlightCheckCubit() : super( MainInitialState() );

  FlightCheckRepository flightCheckRepository = FlightCheckRepository();


// getValidateLocation api call repo
  Future<void> getValidateLocation(String locationCode, int userId, int companyCode, int menuId, String processCode) async {
    // emit(MainLoadingState());
    try {
      final validateLocationModelData = await flightCheckRepository.locationValidate(locationCode, userId, companyCode, menuId, processCode);
      emit(ValidateLocationSuccessState(validateLocationModelData));
    } catch (e) {
      emit(ValidateLocationFailureState(e.toString()));
    }
  }

  // getButtonsRoles & Rights api call repo
  Future<void> getPageLoadDefault(int menuId, int userId, int companyCode) async {
    emit(MainLoadingState());
    try {
      final pageLoadDefaultModelData = await flightCheckRepository.getPageLoadDefault(menuId, userId, companyCode);
      emit(PageLoadDefaultSuccessState(pageLoadDefaultModelData));
    } catch (e) {
      emit(PageLoadDefaultFailureState(e.toString()));
    }
  }

  // getButtonsRoles & Rights api call repo
  Future<void> getButtonRolesAndRights(int menuId, int userId, int companyCode) async {
    emit(MainLoadingState());
    try {
      final getButtonRolesAndRightsModelData = await flightCheckRepository.getButtonRolesAndRights(menuId, userId, companyCode);
      emit(ButtonRolesAndRightsSuccessState(getButtonRolesAndRightsModelData));
    } catch (e) {
      emit(ButtonRolesAndRightsFailureState(e.toString()));
    }
  }


  Future<void> getFlightCheckULDList(String locationCode, String scan, String flightNo, String flightDate, int userId, int companyCode, int menuId, int ULDListFlag) async {
     emit(MainLoadingState());
    try {
      final flightCheckULDListModel = await flightCheckRepository.getFlightCheckULDList(locationCode, scan, flightNo, flightDate, userId, companyCode, menuId, ULDListFlag);

      emit(FlightGetDetailsSuccessState(flightCheckULDListModel));
    } catch (e) {
      emit(FlightGetDetailsFailureState(e.toString()));
    }
  }

  Future<void> getFlightCheckSummaryDetails(int flightSeqNo, int userId, int companyCode, int menuId) async {
    emit(MainLoadingState());
    try {
      final flightCheckSummaryModel = await flightCheckRepository.getFlightCheckSummaryDetails(flightSeqNo, userId, companyCode, menuId);

      emit(GetFlightDetailsSummarySuccessState(flightCheckSummaryModel));
    } catch (e) {
      emit(GetFlightDetailsSummaryFailureState(e.toString()));
    }
  }


  Future<void> bdPriority(int flightSeqNo, int uldSeqNo, int bdPriority, int userId, int companyCode, int menuId) async {
    emit(MainLoadingState());
    try {
      final bdPriorityModelData = await flightCheckRepository.bdPriority(flightSeqNo, uldSeqNo, bdPriority, userId, companyCode, menuId);

      emit(BDPrioritySuccessState(bdPriorityModelData));
    } catch (e) {
      emit(BDPriorityFailureState(e.toString()));
    }
  }

  Future<void> recordATA(int ataHours, int ataMins, String ataDate, int flightSeqNo, int userId, int companyCode, int menuId) async {
    emit(MainLoadingState());
    try {
      final recordAtaModelData = await flightCheckRepository.recordATA(ataHours,ataMins,ataDate,flightSeqNo, userId, companyCode, menuId);

      emit(RecordATASuccessState(recordAtaModelData));
    } catch (e) {
      emit(RecordATAFailureState(e.toString()));
    }
  }

  Future<void> finalizeFlight(int flightSeqNo, int userId, int companyCode, int menuId) async {
    emit(MainLoadingState());
    try {
      final finalizeFlightModelData = await flightCheckRepository.finalizeFlight(flightSeqNo, userId, companyCode, menuId);

      emit(FinalizeFlightSuccessState(finalizeFlightModelData));
    } catch (e) {
      emit(FinalizeFlightFailureState(e.toString()));
    }
  }

  Future<void> getAWBList(int flightSeqNo, int uldSeqNo, int userId, int companyCode, int menuId, int showAll) async {
    emit(MainLoadingState());
    try {
      final awbModelData = await flightCheckRepository.getListOfAwb(flightSeqNo, uldSeqNo, userId, companyCode, menuId, showAll);

      emit(AWBListSuccessState(awbModelData));
    } catch (e) {
      emit(AWBListFailureState(e.toString()));
    }
  }

  Future<void> bdPriorityAWB(int iMPShipRowId, int bdPriority, int userId, int companyCode, int menuId) async {
    emit(MainLoadingState());
    try {
      final bdPriorityAWBModelData = await flightCheckRepository.bdPriorityAWB(iMPShipRowId, bdPriority, userId, companyCode, menuId);

      emit(BDPriorityAWBSuccessState(bdPriorityAWBModelData));
    } catch (e) {
      emit(BDPriorityAWBFailureState(e.toString()));
    }
  }

  Future<void> aWBRemarkUpdateAcknoledge(int iMPAWBRowId, int iMPShipRowId, int userId, int companyCode, int menuId) async {
    emit(MainLoadingState());
    try {
      final aWBAcknoledgeModel = await flightCheckRepository.getAWBAcknoledge(iMPAWBRowId, iMPShipRowId, userId, companyCode, menuId);

      emit(AWBAcknoledgeSuccessState(aWBAcknoledgeModel));
    } catch (e) {
      emit(AWBAcknoledgeFailureState(e.toString()));
    }
  }

  Future<void> getMailType(int userId, int companyCode, int menuId) async {
    emit(MainLoadingState());
    try {
      final getMailTypeModel = await flightCheckRepository.getMailTypeList(userId, companyCode, menuId);

      emit(GetMailTypeSuccessState(getMailTypeModel));
    } catch (e) {
      emit(GetMailTypeFailureState(e.toString()));
    }
  }

  Future<void> getMailDetail(int flightSeqNo, int uldSeqNo, int userId, int companyCode, int menuId) async {
    emit(MainLoadingState());
    try {
      final getMailDetailModel = await flightCheckRepository.getMailDetail(flightSeqNo, uldSeqNo, userId, companyCode, menuId);

      emit(GetMailDetailSuccessState(getMailDetailModel));
    } catch (e) {
      emit(GetMailDetailFailureState(e.toString()));
    }
  }

  Future<void> addMail(int flightSeqNo, int uldSeqNo, String av7No, String mailType, String origin, String destination, int nOP, double weight, String description, int userId, int companyCode, int menuId) async {
    emit(MainLoadingState());
    try {
      final addMailModel = await flightCheckRepository.addMail(flightSeqNo, uldSeqNo, av7No, mailType, origin, destination, nOP, weight, description, userId, companyCode, menuId);

      emit(AddMailSuccessState(addMailModel));
    } catch (e) {
      emit(AddMAilFailureState(e.toString()));
    }
  }

  Future<void> checkOAirportCity(String airportCity, int userId, int companyCode, int menuId) async {
    emit(MainLoadingState());
    try {
      final airportCityModel = await flightCheckRepository.checkAirportCity(airportCity, userId, companyCode, menuId);

      emit(CheckOAirportCitySuccessState(airportCityModel));
    } catch (e) {
      emit(CheckOAirportCityFailureState(e.toString()));
    }
  }

  Future<void> checkDAirportCity(String airportCity, int userId, int companyCode, int menuId) async {
    emit(MainLoadingState());
    try {
      final airportCityModel = await flightCheckRepository.checkAirportCity(airportCity, userId, companyCode, menuId);

      emit(CheckDAirportCitySuccessState(airportCityModel));
    } catch (e) {
      emit(CheckDAirportCityFailureState(e.toString()));
    }
  }

  Future<void> importShipmentSave(int flightSeqNo, int uLDSeqNo, String groupId, String awbId, String hawbid, int nopInput, String wtInput,  int userId, int companyCode, int menuId) async {
    emit(MainLoadingState());
    try {
      final importManifestModel = await flightCheckRepository.importManifestSave(flightSeqNo,uLDSeqNo, groupId, awbId, hawbid, nopInput, wtInput, userId, companyCode, menuId);

      emit(ImportShipmentSaveSuccessState(importManifestModel));
    } catch (e) {
      emit(ImportShipmentSaveFailureState(e.toString()));
    }
  }

  Future<void> breakDownEnd(int flightSeqNo, int uLDSeqNo, String isConfirm, int userId, int companyCode, int menuId) async {
    emit(MainLoadingState());
    try {
      final breakDownEndModel = await flightCheckRepository.breakDownEnd(flightSeqNo,uLDSeqNo, isConfirm, userId, companyCode, menuId);

      emit(BreakDownEndSaveSuccessState(breakDownEndModel));
    } catch (e) {
      emit(BreakDownEndFailureState(e.toString()));
    }
  }

  Future<void> getDamageDetails(int flightSeqNo, String AWBId, String SHIPId, int userId, int companyCode, int menuId) async {
    emit(MainLoadingState());
    try {
      final damageDetailsModel = await flightCheckRepository.getDamageDetails(flightSeqNo,AWBId, SHIPId, userId, companyCode, menuId);

      emit(GetDamageDetailSuccessState(damageDetailsModel));
    } catch (e) {
      emit(GetDamageDetailFailureState(e.toString()));
    }
  }

  Future<void> damageBreakDownSave(
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

    emit(MainLoadingState());
    try {
      final damageBreakDownSaveModel = await flightCheckRepository.damageBreakDownSave(
          awbPrefix,awbNumber, AWBId, SHIPId, flightSeqNo,
          typeOfDiscrepancy,
          shipTotalPcs, ShipTotalWt, shipDamagePcs, ShipDamageWt, shipDifferencePcs, shipDifferenceWt,
          individualWTPerDoc, individualWTActChk, individualWTDifference,
          containerMaterial, containerType,
          marksLabels,
          outerPacking,
          innerPacking,
          damageObserContent,
          damageObserContainers,
          damageDiscovered,
          spaceForMissing,
          verifiedInvoice,
          isSufficient,
          evidenceOfPilerage,
          remarks,
          aparentCause,
          salvageAction,
          disposition,
          damageRemarked,
          weatherCondition,
          GHARepresent,
          AirlineRepresent,
          SecurityRepresent,
          problemSeqId,
          XmlBinaryImage,
          groupid,
          userId, companyCode, menuId
      );

      emit(DamageBreakDownSaveSuccessState(damageBreakDownSaveModel));
    } catch (e) {
      emit(GetDamageDetailFailureState(e.toString()));
    }
  }


  Future<void> getHouseList(int flightSeqNo, int uldSeqNo, int iMPAWBRowId, int userId, int companyCode, int menuId, int showAll) async {
    emit(MainLoadingState());
    try {
      final awbModelData = await flightCheckRepository.getListOfHouses(flightSeqNo, uldSeqNo, iMPAWBRowId, userId, companyCode, menuId, showAll);

      emit(HouseListSuccessState(awbModelData));
    } catch (e) {
      emit(HouseListFailureState(e.toString()));
    }
  }




  void resetState() {
    emit(MainInitialState());
  }

}