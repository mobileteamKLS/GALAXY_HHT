


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



  void resetState() {
    emit(MainInitialState());
  }

}