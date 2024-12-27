import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:galaxy/module/export/services/emptyuldtrolley/emptyuldtrolleylogic/emptyuldtrolleystate.dart';
import 'package:galaxy/module/export/services/emptyuldtrolley/emptyuldtrolleyrepository.dart';
import 'package:galaxy/module/export/services/unloaduld/unloaduldlogic/unloaduldstate.dart';
import 'package:galaxy/module/export/services/unloaduld/unloaduldrepository.dart';


class EmptyULDTrolleyCubit extends Cubit<EmptyULDTrolleyState>{
  EmptyULDTrolleyCubit() : super( EmptyULDTrolleyInitialState() );

  EmptyULDTrolleyRepository emptyULDTrolleyRepository = EmptyULDTrolleyRepository();

  Future<void> emptyULDTrolleyPageLoad(int userId, int companyCode, int menuId) async {
    emit(EmptyULDTrolleyLoadingState());
    try {
      final emptyULDTrolleyModelData = await emptyULDTrolleyRepository.emptyULDtrolPageLoadModel(userId, companyCode, menuId);
      emit(EmptyULDTrolleyPageLoadSuccessState(emptyULDTrolleyModelData));
    } catch (e) {
      emit(EmptyULDTrolleyPageLoadFailureState(e.toString()));
    }
  }

  // getValidateLocation api call repo
  Future<void> getValidateLocation(String locationCode, int userId, int companyCode, int menuId, String processCode) async {
    emit(EmptyULDTrolleyLoadingState());
    try {
      final validateLocationModelData = await emptyULDTrolleyRepository.locationValidate(locationCode, userId, companyCode, menuId, processCode);
      emit(ValidateLocationSuccessState(validateLocationModelData));
    } catch (e) {
      emit(ValidateLocationFailureState(e.toString()));
    }
  }


  void resetState() {
    emit(EmptyULDTrolleyInitialState());
  }

}