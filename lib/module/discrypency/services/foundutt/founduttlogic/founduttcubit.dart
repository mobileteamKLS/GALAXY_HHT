import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:galaxy/module/discrypency/services/foundutt/founduttrepository.dart';
import 'founduttstate.dart';



class FoundUTTCubit extends Cubit<FoundUTTState>{
  FoundUTTCubit() : super( FoundUTTInitialState() );

  FoundUTTRepository foundUTTRepository = FoundUTTRepository();


  Future<void> getFoundUTTPageLoad(int userId, int companyCode, int menuId) async {
    emit(FoundUTTLoadingState());
    try {
      final getFoundUTTPageLoadModelData = await foundUTTRepository.getPageLoadFoundUTT(userId, companyCode, menuId);
      emit(GetFoundUTTPageLoadSuccessState(getFoundUTTPageLoadModelData));
    } catch (e) {
      emit(GetFoundUTTPageLoadFailureState(e.toString()));
    }
  }


  Future<void> getFoundUTTSearchRecord(int userId, int companyCode, int menuId) async {
    emit(FoundUTTLoadingState());
    try {
      final uTTSearchModelData = await foundUTTRepository.getFoundUTTSearchRecord(userId, companyCode, menuId);
      emit(GetFoundUTTSearchSuccessState(uTTSearchModelData));
    } catch (e) {
      emit(GetFoundUTTSearchFailureState(e.toString()));
    }
  }

  Future<void> getFoundUTTGroupIdRecord(int shipRowId, String groupId, String locationCode,
      String moduleType, int userId, int companyCode, int menuId) async {
    emit(FoundUTTLoadingState());
    try {
      final foundUTTGroupIdModelData = await foundUTTRepository.getFoundUTTGroupId(shipRowId, groupId, locationCode, moduleType, userId, companyCode, menuId);
      emit(GetFoundUTTGroupIdSuccessState(foundUTTGroupIdModelData));
    } catch (e) {
      emit(GetFoundUTTGroupIdFailureState(e.toString()));
    }
  }

  // getValidateLocation api call repo
  Future<void> getValidateLocation(String locationCode, int userId, int companyCode, int menuId, String processCode) async {
    emit(FoundUTTLoadingState());
    try {
      final validateLocationModelData = await foundUTTRepository.locationValidate(locationCode, userId, companyCode, menuId, processCode);
      emit(ValidateLocationSuccessState(validateLocationModelData));
    } catch (e) {
      emit(ValidateLocationFailureState(e.toString()));
    }
  }

  Future<void> foundUTTRecordUpdate(
      String uttType,
      int seqNo,
      int nop,
      double weight,
      String moduleType, int userId, int companyCode, int menuId) async {
    emit(FoundUTTLoadingState());
    try {
      final recordUpdate = await foundUTTRepository.foundUTTRecordUpdate(uttType, seqNo, nop, weight, moduleType, userId, companyCode, menuId);
      emit(RecordFoundUTTUpdateSuccessState(recordUpdate));
    } catch (e) {
      emit(RecordFoundUTTUpdateFailureState(e.toString()));
    }
  }



  void resetState() {
    emit(FoundUTTInitialState());
  }

}