import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:galaxy/module/export/services/buildup/builduprepository.dart';

import 'buildupstate.dart';



class BuildUpCubit extends Cubit<BuildUpState>{
  BuildUpCubit() : super( BuildUpInitialState() );

  BuildUpRepository buildUpRepository = BuildUpRepository();



  Future<void> getFlightSearch(String flightNo, String flightDate, int userId, int companyCode, int menuId) async {
    emit(BuildUpLoadingState());
    try {
      final flightSearchModel = await buildUpRepository.getFlightSearch(flightNo, flightDate, userId, companyCode, menuId);

      emit(FlightSearchSuccessState(flightSearchModel));
    } catch (e) {
      emit(FlightSearchFailureState(e.toString()));
    }
  }

  // getButtonsRoles & Rights api call repo
/*
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


  Future<void> bdPriority(int flightSeqNo, int uldSeqNo, int bdPriority, int userId, int companyCode, int menuId) async {
    emit(MainLoadingState());
    try {
      final bdPriorityModelData = await flightCheckRepository.bdPriority(flightSeqNo, uldSeqNo, bdPriority, userId, companyCode, menuId);

      emit(BDPrioritySuccessState(bdPriorityModelData));
    } catch (e) {
      emit(BDPriorityFailureState(e.toString()));
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


  Future<void> aWBRemarkUpdateAcknoledge(int iMPAWBRowId, int iMPShipRowId, int userId, int companyCode, int menuId) async {
    emit(MainLoadingState());
    try {
      final aWBAcknoledgeModel = await flightCheckRepository.getAWBAcknoledge(iMPAWBRowId, iMPShipRowId, userId, companyCode, menuId);

      emit(AWBAcknoledgeSuccessState(aWBAcknoledgeModel));
    } catch (e) {
      emit(AWBAcknoledgeFailureState(e.toString()));
    }
  }


*/


  void resetState() {
    emit(BuildUpInitialState());
  }

}