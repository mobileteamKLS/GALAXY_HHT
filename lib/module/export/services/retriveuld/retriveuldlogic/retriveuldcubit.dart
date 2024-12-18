
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
      final uldDetailModelData = await retriveULDRepository.retriveULDDetailList(uldType, userId, companyCode, menuId);
      emit(RetriveULDDetailSuccessState(uldDetailModelData));
    } catch (e) {
      emit(RetriveULDDetailFailureState(e.toString()));
    }
  }


  // uld search api call repo
  Future<void> getULDSearch(String scan, int userId, int companyCode, int menuId) async {
    emit(RetriveULDLoadingState());
    try {
      final uldDetailModelData = await retriveULDRepository.retriveULDSearch(scan, userId, companyCode, menuId);
      emit(RetriveULDSearchSuccessState(uldDetailModelData));
    } catch (e) {
      emit(RetriveULDSearchFailureState(e.toString()));
    }
  }

  // uld list api call repo
  Future<void> getULDList(int userId, int companyCode, int menuId) async {
    emit(RetriveULDLoadingState());
    try {
      final retrieveULDListData = await retriveULDRepository.retriveULDList(userId, companyCode, menuId);
      emit(RetriveULDListSuccessState(retrieveULDListData));
    } catch (e) {
      emit(RetriveULDListFailureState(e.toString()));
    }
  }


  // add to list api call repo
  Future<void> addToList(int uldSeqNo, int userId, int companyCode, int menuId) async {
    emit(RetriveULDLoadingState());
    try {
      final addToListData = await retriveULDRepository.addToList(uldSeqNo, userId, companyCode, menuId);
      emit(AddToListSuccessState(addToListData));
    } catch (e) {
      emit(AddToListFailureState(e.toString()));
    }
  }

  // add to list api call repo
  Future<void> retrieveULDBtn(String uldSeqNo, String locationCode, int userId, int companyCode, int menuId) async {
    emit(RetriveULDLoadingState());
    try {
      final retrieveULDModel = await retriveULDRepository.retrieveULDBtn(uldSeqNo, locationCode, userId, companyCode, menuId);
      emit(RetrieveULDBtnSuccessState(retrieveULDModel));
    } catch (e) {
      emit(RetrieveULDBtnFailureState(e.toString()));
    }
  }

  // add to list api call repo
  Future<void> cancelULD(int uldSeqNo, int userId, int companyCode, int menuId) async {
    emit(RetriveULDLoadingState());
    try {
      final cancelULDModel = await retriveULDRepository.cancelULD(uldSeqNo, userId, companyCode, menuId);
      emit(CancelULDSuccessState(cancelULDModel));
    } catch (e) {
      emit(CancelULDFailureState(e.toString()));
    }
  }


  void resetState() {
    emit(RetriveULDInitialState());
  }

}