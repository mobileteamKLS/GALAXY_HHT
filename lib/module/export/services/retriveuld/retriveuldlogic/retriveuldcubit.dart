
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:galaxy/module/export/services/retriveuld/retriveuldlogic/retriveuldstate.dart';

import '../retriveuldrepository.dart';



class RetriveULDCubit extends Cubit<RetriveULDState>{
  RetriveULDCubit() : super( RetriveULDInitialState() );

  RetriveULDRepository retriveULDRepository = RetriveULDRepository();

  // pageLoad api call repo
  Future<void> getDefaultPageLoad(int userId, int companyCode, int menuId) async {
    emit(RetriveULDLoadingState());
    try {
      final retrivepageLoadModelData = await retriveULDRepository.retriveULDPageLoad(userId, companyCode, menuId);
      emit(RetriveULDPageLoadSuccessState(retrivepageLoadModelData));
    } catch (e) {
      emit(RetriveULDPageLoadFailureState(e.toString()));
    }
  }


  // getValidateLocation api call repo
  Future<void> getValidateLocation(String locationCode, int userId, int companyCode, int menuId, String processCode) async {
    emit(RetriveULDLoadingState());
    try {
      final validateLocationModelData = await retriveULDRepository.locationValidate(locationCode, userId, companyCode, menuId, processCode);
      emit(ValidateLocationSuccessState(validateLocationModelData));
    } catch (e) {
      emit(ValidateLocationFailureState(e.toString()));
    }
  }


  // uld detail api call repo
  Future<void> getULDDetailLoad(String uldType, int userId, int companyCode, int menuId) async {
    emit(RetriveULDLoadingState());
    try {
      final uldDetailModelData = await retriveULDRepository.retriveULDDetail(uldType, userId, companyCode, menuId);
      emit(RetriveULDDetailSuccessState(uldDetailModelData));
    } catch (e) {
      emit(RetriveULDDetailFailureState(e.toString()));
    }
  }


  void resetState() {
    emit(RetriveULDInitialState());
  }

}