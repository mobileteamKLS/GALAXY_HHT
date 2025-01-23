import 'package:flutter_bloc/flutter_bloc.dart';

import '../moverepository.dart';
import 'movestate.dart';


class MoveCubit extends Cubit<MoveState>{
  MoveCubit() : super( MoveInitialState() );

  MoveRepository moveRepository = MoveRepository();


  Future<void> moveLocation(
      String selectedType,
      String locationCode,
      String moveXml,
      int userId,
      int companyCode,
      int menuId) async {
    emit(MoveLoadingState());
    try {
      final getULDTrolleySaveModelData = await moveRepository.moveLocationUpdate(
          selectedType,
          locationCode,
          moveXml,
          userId,
          companyCode,
          menuId);
      emit(MoveLocationSuccessState(getULDTrolleySaveModelData));
    } catch (e) {
      emit(MoveLocationFailureState(e.toString()));
    }
  }



/*  Future<void> getDefaultPageLoad(int userId, int companyCode, int menuId) async {
    emit(SplitGroupLoadingState());
    try {
      final defaultpageLoadModelData = await splitGroupRepository.splitgroupDefaultPageLoad(userId, companyCode, menuId);
      emit(SplitGroupDefaultPageLoadSuccessState(defaultpageLoadModelData));
    } catch (e) {
      emit(SplitGroupDefaultPageLoadFailureState(e.toString()));
    }
  }

  Future<void> getValidateLocation(String locationCode, int userId, int companyCode, int menuId, String processCode) async {
    emit(SplitGroupLoadingState());
    try {
      final validateLocationModelData = await splitGroupRepository.locationValidate(locationCode, userId, companyCode, menuId, processCode);
      emit(ValidateLocationSuccessState(validateLocationModelData));
    } catch (e) {
      emit(ValidateLocationFailureState(e.toString()));
    }
  }

  Future<void> getSplitGroupSearchList(String scan, int userId, int companyCode, int menuId) async {
    emit(SplitGroupLoadingState());
    try {
      final getSplitGroupSearchModelData = await splitGroupRepository.getSplitGroupDetailSearchList(scan, userId, companyCode, menuId);
      emit(SplitGroupDetailSearchSuccessState(getSplitGroupSearchModelData));
    } catch (e) {
      emit(SplitGroupDetailSearchFailureState(e.toString()));
    }
  }

  Future<void> splitGroupSave(
      int expAWBRowId,
      int expShipRowId,
      int stockRowId,
      int nop,
      double weight,
      String groupId,
      String locationCode,
      int userId,
      int companyCode,
      int menuId) async {
    emit(SplitGroupLoadingState());
    try {
      final getULDTrolleySaveModelData = await splitGroupRepository.splitGroupSave(
          expAWBRowId,
          expShipRowId,
          stockRowId,
          nop,
          weight,
          groupId,
          locationCode,
          userId, companyCode, menuId);
      emit(SplitGroupSaveSuccessState(getULDTrolleySaveModelData));
    } catch (e) {
      emit(SplitGroupSaveFailureState(e.toString()));
    }
  }*/




  void resetState() {
    emit(MoveInitialState());
  }

}