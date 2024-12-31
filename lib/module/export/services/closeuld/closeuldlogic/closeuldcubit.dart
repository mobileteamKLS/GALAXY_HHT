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

  void resetState() {
    emit(CloseULDInitialState());
  }

}