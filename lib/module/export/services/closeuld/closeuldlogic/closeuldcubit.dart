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

  Future<void> saveEquipmentList(int uldSeqNo, String uldType, String saveData, double totalWeight, int userId, int companyCode, int menuId) async {
    emit(CloseULDLoadingState());
    try {
      final saveEquipmentModelData = await closeULDRepository.saveEquipmentModel(uldSeqNo, uldType, saveData, totalWeight, userId, companyCode, menuId);
      emit(SaveEquipmentSuccessState(saveEquipmentModelData));
    } catch (e) {
      emit(SaveEquipmentFailureState(e.toString()));
    }
  }

  Future<void> getContourList(int uldSeqNo, String uldType, int userId, int companyCode, int menuId) async {
    emit(CloseULDLoadingState());
    try {
      final getContourModelData = await closeULDRepository.getContourList(uldSeqNo, uldType, userId, companyCode, menuId);
      emit(GetContourListSuccessState(getContourModelData));
    } catch (e) {
      emit(GetContourListFailureState(e.toString()));
    }
  }

  Future<void> saveContour(int uldSeqNo, String uldType, String saveData, double totalWeight, int userId, int companyCode, int menuId) async {
    emit(CloseULDLoadingState());
    try {
      final saveContourModelData = await closeULDRepository.saveContourModel(uldSeqNo, uldType, saveData, totalWeight, userId, companyCode, menuId);
      emit(SaveContourSuccessState(saveContourModelData));
    } catch (e) {
      emit(SaveContourFailureState(e.toString()));
    }
  }



  Future<void> getScaleList(int uldSeqNo, String uldType, int userId, int companyCode, int menuId) async {
    emit(CloseULDLoadingState());
    try {
      final getScaleModelData = await closeULDRepository.getScaleList(uldSeqNo, uldType, userId, companyCode, menuId);
      emit(GetScaleListSuccessState(getScaleModelData));
    } catch (e) {
      emit(GetScaleListFailureState(e.toString()));
    }
  }

  Future<void> saveScale(int uldSeqNo, String uldType, String saveData, double totalWeight, int userId, int companyCode, int menuId) async {
    emit(CloseULDLoadingState());
    try {
      final saveScaleModelData = await closeULDRepository.saveScaleModel(uldSeqNo, uldType, saveData, totalWeight, userId, companyCode, menuId);
      emit(SaveScaleSuccessState(saveScaleModelData));
    } catch (e) {
      emit(SaveScaleFailureState(e.toString()));
    }
  }



  Future<void> getRemarkList(int uldSeqNo, String uldType, int userId, int companyCode, int menuId) async {
    emit(CloseULDLoadingState());
    try {
      final getRemarkModelData = await closeULDRepository.getRemarkList(uldSeqNo, uldType, userId, companyCode, menuId);
      emit(GetRemarkListSuccessState(getRemarkModelData));
    } catch (e) {
      emit(GetRemarkListFailureState(e.toString()));
    }
  }

  Future<void> saveRemark(int uldSeqNo, String uldType, String saveData, double totalWeight, int userId, int companyCode, int menuId) async {
    emit(CloseULDLoadingState());
    try {
      final saveRemarkModelData = await closeULDRepository.saveRemarkModel(uldSeqNo, uldType, saveData, totalWeight, userId, companyCode, menuId);
      emit(SaveRemarkSuccessState(saveRemarkModelData));
    } catch (e) {
      emit(SaveRemarkFailureState(e.toString()));
    }
  }

  void resetState() {
    emit(CloseULDInitialState());
  }

}