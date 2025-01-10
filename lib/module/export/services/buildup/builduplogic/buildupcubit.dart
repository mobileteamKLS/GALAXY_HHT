import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:galaxy/module/export/services/buildup/builduprepository.dart';

import 'buildupstate.dart';



class BuildUpCubit extends Cubit<BuildUpState>{
  BuildUpCubit() : super( BuildUpInitialState() );

  BuildUpRepository buildUpRepository = BuildUpRepository();

  // getValidateLocation api call repo
  Future<void> getValidateLocation(String locationCode, int userId, int companyCode, int menuId, String processCode) async {
    emit(BuildUpLoadingState());
    try {
      final validateLocationModelData = await buildUpRepository.locationValidate(locationCode, userId, companyCode, menuId, processCode);
      emit(ValidateLocationSuccessState(validateLocationModelData));
    } catch (e) {
      emit(ValidateLocationFailureState(e.toString()));
    }
  }

  Future<void> getFlightSearch(String flightNo, String flightDate, int userId, int companyCode, int menuId) async {
    emit(BuildUpLoadingState());
    try {
      final flightSearchModel = await buildUpRepository.getFlightSearch(flightNo, flightDate, userId, companyCode, menuId);

      emit(FlightSearchSuccessState(flightSearchModel));
    } catch (e) {
      emit(FlightSearchFailureState(e.toString()));
    }
  }

  Future<void> getULDTrolleySearchList(int flightSeqNo, int userId, int companyCode, int menuId) async {
    emit(BuildUpLoadingState());
    try {
      final getULDTrolleySearchModelData = await buildUpRepository.getULDTrolleySearchList(flightSeqNo, userId, companyCode, menuId);
      emit(GetULDTrolleySearchSuccessState(getULDTrolleySearchModelData));
    } catch (e) {
      emit(GetULDTrolleySearchFailureState(e.toString()));
    }
  }

  Future<void> getULDTrolleyPriorityUpdate(int uldSeqNo, int priority, String uldType, int userId, int companyCode, int menuId) async {
    emit(BuildUpLoadingState());
    try {
      final uldTrolleyPriorityModelData = await buildUpRepository.uldTrolleyPriorityUpdate(uldSeqNo, priority, uldType,  userId, companyCode, menuId);
      emit(ULDTrolleyPrioritySuccessState(uldTrolleyPriorityModelData));
    } catch (e) {
      emit(ULDTrolleyPriorityFailureState(e.toString()));
    }
  }

  Future<void> getContourList(int uldSeqNo, int userId, int companyCode, int menuId) async {
    emit(BuildUpLoadingState());
    try {
      final getContourModelData = await buildUpRepository.getContourList(uldSeqNo, userId, companyCode, menuId);
      emit(BuildUpGetContourListSuccessState(getContourModelData));
    } catch (e) {
      emit(BuildUpGetContourListFailureState(e.toString()));
    }
  }

  Future<void> getULDTrolleySave(
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
    emit(BuildUpLoadingState());
    try {
      final getULDTrolleySaveModelData = await buildUpRepository.getULDTrolleySave(
          flightSeqNo,
          uldType,
          uldNumber,
          uldOwner,
          uldSpecification,
          trolleyType,
          trolleyNumber,
          tareWeight,
          contourCode,
          contourHeight,
          priority,
          offPoint,
          uldTrolleyType,
          userId, companyCode, menuId);
      emit(GetULDTrolleySaveSuccessState(getULDTrolleySaveModelData));
    } catch (e) {
      emit(GetULDTrolleySaveFailureState(e.toString()));
    }
  }


  Future<void> getAwbList(int flightSeqNo, int userId, int companyCode, int menuId) async {
    emit(BuildUpLoadingState());
    try {
      final getAwbModelData = await buildUpRepository.getAwbDetailList(flightSeqNo, userId, companyCode, menuId);
      emit(BuildUpAWBDetailSuccessState(getAwbModelData));
    } catch (e) {
      emit(BuildUpAWBDetailFailureState(e.toString()));
    }
  }

  Future<void> getAWBPriorityUpdate(int expRowId, int priority, int userId, int companyCode, int menuId) async {
    emit(BuildUpLoadingState());
    try {
      final awbPriorityModelData = await buildUpRepository.awbPriorityUpdate(expRowId, priority, userId, companyCode, menuId);
      emit(AWBPrioritySuccessState(awbPriorityModelData));
    } catch (e) {
      emit(AWBPriorityFailureState(e.toString()));
    }
  }

  Future<void> getAWBAcknowledge(int expRowId, int expShipRowId, int userId, int companyCode, int menuId) async {
    emit(BuildUpLoadingState());
    try {
      final awbAcknowledgeModelData = await buildUpRepository.awbAcknowledgeUpdate(expRowId, expShipRowId, userId, companyCode, menuId);
      emit(AWBAcknowledgeSuccessState(awbAcknowledgeModelData));
    } catch (e) {
      emit(AWBAcknowledgeFailureState(e.toString()));
    }
  }


  Future<void> getGroupList(int flightSeqNo, int userId, int companyCode, int menuId) async {
    emit(BuildUpLoadingState());
    try {
      final getGroupModelData = await buildUpRepository.getGroupDetailList(flightSeqNo, userId, companyCode, menuId);
      emit(BuildUpGroupDetailSuccessState(getGroupModelData));
    } catch (e) {
      emit(BuildUpGroupDetailFailureState(e.toString()));
    }
  }


  Future<void> shcCodeValidate(String shcCode, int userId, int companyCode, int menuId) async {
    emit(BuildUpLoadingState());
    try {
      final shcCodeValidate = await buildUpRepository.shcValidateCode(shcCode, userId, companyCode, menuId);
      emit(SHCValidateSuccessState(shcCodeValidate));
    } catch (e) {
      emit(SHCValidateFailureState(e.toString()));
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