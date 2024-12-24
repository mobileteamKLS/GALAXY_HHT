import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:galaxy/module/export/services/unloaduld/unloaduldlogic/unloaduldstate.dart';
import 'package:galaxy/module/export/services/unloaduld/unloaduldrepository.dart';


class UnloadULDCubit extends Cubit<UnloadULDState>{
  UnloadULDCubit() : super( UnloadULDInitialState() );

  UnloadULDRepository unloadULDRepository = UnloadULDRepository();

  Future<void> unloadULDPageLoad(int userId, int companyCode, int menuId) async {
    emit(UnloadULDLoadingState());
    try {
      final unloadULDModelData = await unloadULDRepository.unloadUldPageLoadModel(userId, companyCode, menuId);
      emit(UnloadULDPageLoadSuccessState(unloadULDModelData));
    } catch (e) {
      emit(UnloadULDPageLoadFailureState(e.toString()));
    }
  }

  Future<void> unloadULDlistLoad(String scanNo, int userId, int companyCode, int menuId) async {
    emit(UnloadULDLoadingState());
    try {
      final unloadULDModelData = await unloadULDRepository.unloadUldlistModel(scanNo, userId, companyCode, menuId);
      emit(UnloadULDListSuccessState(unloadULDModelData));
    } catch (e) {
      emit(UnloadULDListFailureState(e.toString()));
    }
  }

  Future<void> unloadULDAWBlistLoad(int uldSeqNo, String uldType, int userId, int companyCode, int menuId) async {
    emit(UnloadULDLoadingState());
    try {
      final unloadULDModelData = await unloadULDRepository.unloadUldAWBlistModel(uldSeqNo, uldType ,userId, companyCode, menuId);
      emit(UnloadULDAWBListSuccessState(unloadULDModelData));
    } catch (e) {
      emit(UnloadULDAWBListFailureState(e.toString()));
    }
  }


  Future<void> unloadOpenULDLoad(int uldSeqNo, String uldType, int userId, int companyCode, int menuId) async {
    emit(UnloadULDLoadingState());
    try {
      final unloadUldCloseModelData = await unloadULDRepository.unloadOpenULDModel(uldSeqNo, uldType ,userId, companyCode, menuId);
      emit(UnloadOpenULDSuccessState(unloadUldCloseModelData));
    } catch (e) {
      emit(UnloadOpenULDFailureState(e.toString()));
    }
  }

  void resetState() {
    emit(UnloadULDInitialState());
  }

}