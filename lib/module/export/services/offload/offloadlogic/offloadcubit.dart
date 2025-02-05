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


  Future<void> offloadAWBSave(
      int flightSeqNo,
      int expAWBRowId,
      int expShipRowId,
      int uLDTrolleySeqNo,
      int manifestSeqNo,
      String uLDTrolleyType,
      int nop,
      double weight,
      String groupId,
      int stockRowId,
      String offPoint,
      String reason,
      String reasonDiscription,
      String locationCode,
      int userId, int companyCode, int menuId) async {
    emit(OffloadLoadingState());
    try {
      final offloadSaveAWBModelData = await offloadRepository.offloadAWBSave(
          flightSeqNo,
          expAWBRowId,
          expShipRowId,
          uLDTrolleySeqNo,
          manifestSeqNo,
          uLDTrolleyType,
          nop,
          weight,
          groupId,
          stockRowId,
          offPoint,
          reason,
          reasonDiscription,
          locationCode,
          userId, companyCode, menuId);
      emit(OffloadAWBSaveSuccessState(offloadSaveAWBModelData));
    } catch (e) {
      emit(OffloadAWBSaveFailureState(e.toString()));
    }
  }

  Future<void> offloadULDSave(
      int uLDSeqNo,
      int flightSeqNo,
      String temp,
      String tUnit,
      int batteryStrength,
      String groupId,
      String reason,
      String reasonDiscription,
      String offPoint,
      String locationCode,
      int userId, int companyCode, int menuId) async {
    emit(OffloadLoadingState());
    try {
      final offloadSaveULDModelData = await offloadRepository.offloadULDSave(
          uLDSeqNo,flightSeqNo,temp, tUnit, batteryStrength, groupId, reason, reasonDiscription, offPoint, locationCode,
          userId, companyCode, menuId);
      emit(OffloadULDSaveSuccessState(offloadSaveULDModelData));
    } catch (e) {
      emit(OffloadULDSaveFailureState(e.toString()));
    }
  }










  void resetState() {
    emit(OffloadInitialState());
  }

}