import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:galaxy/module/export/services/closeuld/closeuldlogic/closeuldstate.dart';
import 'package:galaxy/module/export/services/closeuld/closeuldrepository.dart';


class CloseULDCubit extends Cubit<CloseULDState>{
  CloseULDCubit() : super( CloseULDInitialState() );

  CloseULDRepository closeULDRepository = CloseULDRepository();

 /* Future<void> emptyULDTrolleyPageLoad(int userId, int companyCode, int menuId) async {
    emit(EmptyULDTrolleyLoadingState());
    try {
      final emptyULDTrolleyModelData = await emptyULDTrolleyRepository.emptyULDtrolPageLoadModel(userId, companyCode, menuId);
      emit(EmptyULDTrolleyPageLoadSuccessState(emptyULDTrolleyModelData));
    } catch (e) {
      emit(EmptyULDTrolleyPageLoadFailureState(e.toString()));
    }
  }
*/

  Future<void> closeULDSearchModel(String scan, int userId, int companyCode, int menuId) async {
    emit(CloseULDLoadingState());
    try {
      final closeULDSearchModelData = await closeULDRepository.closeULDSearchModel(scan, userId, companyCode, menuId);
      emit(CloseULDSearchSuccessState(closeULDSearchModelData));
    } catch (e) {
      emit(CloseULDSearchFailureState(e.toString()));
    }
  }

  Future<void> closeULDEquipmentList(int uldSeqNo, String uldType, int userId, int companyCode, int menuId) async {
    emit(CloseULDLoadingState());
    try {
      final closeULDEquipmentModelData = await closeULDRepository.closeULDEquipmentModel(uldSeqNo, uldType, userId, companyCode, menuId);
      emit(CloseULDEquipmentSuccessState(closeULDEquipmentModelData));
    } catch (e) {
      emit(CloseULDEquipmentFailureState(e.toString()));
    }
  }

  Future<void> saveEquipmentList(int flightSeqNo, int uldSeqNo, String uldType, String equipXML, int userId, int companyCode, int menuId) async {
    emit(CloseULDLoadingState());
    try {
      final saveEquipmentModelData = await closeULDRepository.saveEquipmentModel(flightSeqNo, uldSeqNo, uldType, equipXML, userId, companyCode, menuId);
      emit(SaveEquipmentSuccessState(saveEquipmentModelData));
    } catch (e) {
      emit(SaveEquipmentFailureState(e.toString()));
    }
  }

  Future<void> getContourList(int uldSeqNo, int userId, int companyCode, int menuId) async {
    emit(CloseULDLoadingState());
    try {
      final getContourModelData = await closeULDRepository.getContourList(uldSeqNo, userId, companyCode, menuId);
      emit(GetContourListSuccessState(getContourModelData));
    } catch (e) {
      emit(GetContourListFailureState(e.toString()));
    }
  }

  Future<void> saveContour(int flightSeqNo, int uldSeqNo, String contourCode, double height, int userId, int companyCode, int menuId) async {
    emit(CloseULDLoadingState());
    try {
      final saveContourModelData = await closeULDRepository.saveContourModel(flightSeqNo, uldSeqNo, contourCode, height, userId, companyCode, menuId);
      emit(SaveContourSuccessState(saveContourModelData));
    } catch (e) {
      emit(SaveContourFailureState(e.toString()));
    }
  }



  Future<void> getScaleList(int flightSeqNo, int uldSeqNo, int userId, int companyCode, int menuId) async {
    emit(CloseULDLoadingState());
    try {
      final getScaleModelData = await closeULDRepository.getScaleList(flightSeqNo, uldSeqNo, userId, companyCode, menuId);
      emit(GetScaleListSuccessState(getScaleModelData));
    } catch (e) {
      emit(GetScaleListFailureState(e.toString()));
    }
  }

  Future<void> saveScale(int flightSeqNo, int uldSeqNo, double scaleWeight, String machineNo, int userId, int companyCode, int menuId) async {
    emit(CloseULDLoadingState());
    try {
      final saveScaleModelData = await closeULDRepository.saveScaleModel(flightSeqNo, uldSeqNo, scaleWeight, machineNo, userId, companyCode, menuId);
      emit(SaveScaleSuccessState(saveScaleModelData));
    } catch (e) {
      emit(SaveScaleFailureState(e.toString()));
    }
  }



  Future<void> getRemarkList(int uldSeqNo, int userId, int companyCode, int menuId) async {
    emit(CloseULDLoadingState());
    try {
      final getRemarkModelData = await closeULDRepository.getRemarkList(uldSeqNo, userId, companyCode, menuId);
      emit(GetRemarkListSuccessState(getRemarkModelData));
    } catch (e) {
      emit(GetRemarkListFailureState(e.toString()));
    }
  }

  Future<void> saveRemark(int flightSeqNo, int uldSeqNo, String remarks, int userId, int companyCode, int menuId) async {
    emit(CloseULDLoadingState());
    try {
      final saveRemarkModelData = await closeULDRepository.saveRemarkModel(flightSeqNo, uldSeqNo, remarks, userId, companyCode, menuId);
      emit(SaveRemarkSuccessState(saveRemarkModelData));
    } catch (e) {
      emit(SaveRemarkFailureState(e.toString()));
    }
  }

  Future<void> saveTareWeight(int uldSeqNo, double tareWeight, int userId, int companyCode, int menuId) async {
    emit(CloseULDLoadingState());
    try {
      final saveTareWeightModelData = await closeULDRepository.saveTareWeightModel(uldSeqNo, tareWeight, userId, companyCode, menuId);
      emit(SaveTareWeightSuccessState(saveTareWeightModelData));
    } catch (e) {
      emit(SaveTareWeightFailureState(e.toString()));
    }
  }

  Future<void> getDocumentList(int uldSeqNo, int userId, int companyCode, int menuId) async {
    emit(CloseULDLoadingState());
    try {
      final getDocumentModelData = await closeULDRepository.getDocumentList(uldSeqNo, userId, companyCode, menuId);
      emit(GetDocumentListSuccessState(getDocumentModelData));
    } catch (e) {
      emit(GetDocumentListFailureState(e.toString()));
    }
  }



  Future<void> closeReopenULDModel(int flightSeqNo, int uldSeqNo, String uldStatus, int userId, int companyCode, int menuId) async {
    emit(CloseULDLoadingState());
    try {
      final closeReopenULDModelData = await closeULDRepository.closeReopenULDModel(flightSeqNo, uldSeqNo, uldStatus, userId, companyCode, menuId);
      emit(CloseReopenSuccessState(closeReopenULDModelData));
    } catch (e) {
      emit(CloseReopenFailureState(e.toString()));
    }
  }

  void resetState() {
    emit(CloseULDInitialState());
  }

}