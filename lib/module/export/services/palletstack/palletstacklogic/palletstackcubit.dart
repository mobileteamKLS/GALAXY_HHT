
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:galaxy/module/export/services/palletstack/palletstacklogic/palletstackstate.dart';

import '../palatestackrepository.dart';


class PalletStackCubit extends Cubit<PalletStackState>{
  PalletStackCubit() : super( PalletStackInitialState() );

  PalateStackRepository palateStackRepository = PalateStackRepository();

  // pageLoad api call repo
  Future<void> getDefaultPageLoad(int userId, int companyCode, int menuId) async {
    emit(PalletStackLoadingState());
    try {
      final defaultpageLoadModelData = await palateStackRepository.palletStackDefaultPageLoad(userId, companyCode, menuId);
      emit(PalletStackDefaultPageLoadSuccessState(defaultpageLoadModelData));
    } catch (e) {
      emit(PalletStackDefaultPageLoadFailureState(e.toString()));
    }
  }


  // pageLoad api call repo
  Future<void> getPageLoad(String scan, int userId, int companyCode, int menuId) async {
    emit(PalletStackLoadingState());
    try {
      final pageLoadModelData = await palateStackRepository.palletStackPageLoad(scan, userId, companyCode, menuId);
      emit(PalletStackStatePageLoadSuccessState(pageLoadModelData));
    } catch (e) {
      emit(PalletStackStatePageLoadFailureState(e.toString()));
    }
  }

// getValidateLocation api call repo
  Future<void> getValidateLocation(String locationCode, int userId, int companyCode, int menuId, String processCode) async {
    emit(PalletStackLoadingState());
    try {
      final validateLocationModelData = await palateStackRepository.locationValidate(locationCode, userId, companyCode, menuId, processCode);
      emit(ValidateLocationSuccessState(validateLocationModelData));
    } catch (e) {
      emit(ValidateLocationFailureState(e.toString()));
    }
  }


  Future<void> getPalletListLoad(int uldSeqNo, int userId, int companyCode, int menuId) async {
    emit(PalletStackLoadingState());
    try {
      final palletStackListModel = await palateStackRepository.palletStackListLoad(uldSeqNo, userId, companyCode, menuId);
      emit(PalletStackListSuccessState(palletStackListModel));
    } catch (e) {
      emit(PalletStackListFailureState(e.toString()));
    }
  }


  Future<void> getPalletAssignFlight(int uldSeqNo, String flightNo, String flightDate, int userId, int companyCode, int menuId) async {
    emit(PalletStackLoadingState());
    try {
      final palletStackAssignFlightModel = await palateStackRepository.palletStackAssignFlightLoad(uldSeqNo,flightNo, flightDate, userId, companyCode, menuId);
      emit(PalletStackAssignFlightSuccessState(palletStackAssignFlightModel));
    } catch (e) {
      emit(PalletStackAssignFlightFailureState(e.toString()));
    }
  }

  Future<void> getPalletULDConditionCode(int userId, int companyCode, int menuId) async {
    emit(PalletStackLoadingState());
    try {
      final palletStackULDConditionCodeModel = await palateStackRepository.palletStackULDConditionCodeModel(userId, companyCode, menuId);
      emit(PalletStackULDConditionCodeSuccessState(palletStackULDConditionCodeModel));
    } catch (e) {
      emit(PalletStackULDConditionCodeFailureState(e.toString()));
    }
  }

  Future<void> getPalletULDConditionCodeA(int userId, int companyCode, int menuId) async {
    emit(PalletStackLoadingState());
    try {
      final palletStackULDConditionCodeModel = await palateStackRepository.palletStackULDConditionCodeModel(userId, companyCode, menuId);
      emit(PalletStackULDConditionCodeASuccessState(palletStackULDConditionCodeModel));
    } catch (e) {
      emit(PalletStackULDConditionCodeAFailureState(e.toString()));
    }
  }


  Future<void> getPalletUpdateULDConditionCode(int uldSeqNo, String uldConditionCode, int userId, int companyCode, int menuId) async {
    emit(PalletStackLoadingState());
    try {
      final palletStackUpdateULDConditionCodeModel = await palateStackRepository.palletStackUpdateULDConditionCodeModel(uldSeqNo, uldConditionCode, userId, companyCode, menuId);
      emit(PalletStackUpdateULDConditionCodeSuccessState(palletStackUpdateULDConditionCodeModel));
    } catch (e) {
      emit(PalletStackUpdateULDConditionCodeFailureState(e.toString()));
    }
  }

  Future<void> addPalletStack(int uldSeqNo, String uldNo, String locationCode,  int userId, int companyCode, int menuId) async {
    emit(PalletStackLoadingState());
    try {
      final addPalletStackModel = await palateStackRepository.addPalletStackModel(uldSeqNo, uldNo, locationCode, userId, companyCode, menuId);
      emit(AddPalletStackSuccessState(addPalletStackModel));
    } catch (e) {
      emit(AddPalletStackFailureState(e.toString()));
    }
  }

  Future<void> removePalletStack(int uldSeqNo, int userId, int companyCode, int menuId) async {
    emit(PalletStackLoadingState());
    try {
      final removePalletStackModel = await palateStackRepository.removePalletStackModel(uldSeqNo, userId, companyCode, menuId);
      emit(RemovePalletStackSuccessState(removePalletStackModel));
    } catch (e) {
      emit(RemovePalletStackFailureState(e.toString()));
    }
  }

  Future<void> revokePalletStack(int uldSeqNo, int userId, int companyCode, int menuId) async {
    emit(PalletStackLoadingState());
    try {
      final revokePalletStackModel = await palateStackRepository.revokePalletStackModel(uldSeqNo, userId, companyCode, menuId);
      emit(RevokePalletStackSuccessState(revokePalletStackModel));
    } catch (e) {
      emit(RevokePalletStackFailureState(e.toString()));
    }
  }


  Future<void> reopenClosePalletStack(int uldSeqNo, String uldStatus, int userId, int companyCode, int menuId) async {
    emit(PalletStackLoadingState());
    try {
      final reopenClosePalletStackModel = await palateStackRepository.reopenClosePalletStackModel(uldSeqNo,uldStatus, userId, companyCode, menuId);
      emit(ReopenClosePalletStackSuccessState(reopenClosePalletStackModel));
    } catch (e) {
      emit(ReopenClosePalletStackFailureState(e.toString()));
    }
  }

  Future<void> reopenClosePalletStackA(int uldSeqNo, String uldStatus, int userId, int companyCode, int menuId) async {
    emit(PalletStackLoadingState());
    try {
      final reopenClosePalletStackModel = await palateStackRepository.reopenClosePalletStackModel(uldSeqNo,uldStatus, userId, companyCode, menuId);
      emit(ReopenClosePalletStackASuccessState(reopenClosePalletStackModel));
    } catch (e) {
      emit(ReopenClosePalletStackAFailureState(e.toString()));
    }
  }



  void resetState() {
    emit(PalletStackInitialState());
  }

}