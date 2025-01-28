import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:galaxy/module/export/services/offload/offloadlogic/offloadstate.dart';
import 'package:galaxy/module/export/services/offload/offloadrepository.dart';



class OffloadCubit extends Cubit<OffloadState>{
  OffloadCubit() : super( OffloadInitialState() );

  OffloadRepository offloadRepository = OffloadRepository();

  Future<void> getPageLoad(
      int userId,
      int companyCode,
      int menuId) async {
    emit(OffloadLoadingState());
    try {
      final offloadModelData = await offloadRepository.getPageLoad(
          userId,
          companyCode,
          menuId);
      emit(GetOffloadPageLoadSuccessState(offloadModelData));
    } catch (e) {
      emit(GetOffloadPageLoadFailureState(e.toString()));
    }
  }


  Future<void> getValidateLocation(String locationCode, int userId, int companyCode, int menuId, String processCode) async {
    emit(OffloadLoadingState());
    try {
      final validateLocationModelData = await offloadRepository.locationValidate(locationCode, userId, companyCode, menuId, processCode);
      emit(OffloadValidateLocationSuccessState(validateLocationModelData));
    } catch (e) {
      emit(OffloadValidateLocationFailureState(e.toString()));
    }
  }


  Future<void> getSearchOffload(String scan, String scanType, int userId, int companyCode, int menuId) async {
    emit(OffloadLoadingState());
    try {
      final offloadSearchModelData = await offloadRepository.getSearchOffload(scan, scanType, userId, companyCode, menuId);
      emit(GetOffloadSearchSuccessState(offloadSearchModelData));
    } catch (e) {
      emit(GetOffloadSearchFailureState(e.toString()));
    }
  }


  Future<void> offloadAWBSave(int userId, int companyCode, int menuId) async {
    emit(OffloadLoadingState());
    try {
      final offloadSaveAWBModelData = await offloadRepository.offloadAWBSave(userId, companyCode, menuId);
      emit(OffloadAWBSaveSuccessState(offloadSaveAWBModelData));
    } catch (e) {
      emit(OffloadAWBSaveFailureState(e.toString()));
    }
  }

  Future<void> offloadULDSave(int userId, int companyCode, int menuId) async {
    emit(OffloadLoadingState());
    try {
      final offloadSaveULDModelData = await offloadRepository.offloadULDSave(userId, companyCode, menuId);
      emit(OffloadULDSaveSuccessState(offloadSaveULDModelData));
    } catch (e) {
      emit(OffloadULDSaveFailureState(e.toString()));
    }
  }










  void resetState() {
    emit(OffloadInitialState());
  }

}