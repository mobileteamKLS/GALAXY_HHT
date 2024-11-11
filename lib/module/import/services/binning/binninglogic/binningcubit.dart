import 'package:flutter_bloc/flutter_bloc.dart';

import '../binningrepository.dart';
import 'binningstate.dart';

class BinningCubit extends Cubit<BinningState>{
  BinningCubit() : super( MainInitialState() );

  BinningRepository binningRepository = BinningRepository();

// getButtonsRoles & Rights api call repo
  Future<void> getPageLoadDefault(int menuId, int userId, int companyCode) async {
    emit(MainLoadingState());
    try {
      final pageLoadDefaultModelData = await binningRepository.getPageLoadDefault(menuId, userId, companyCode);
      emit(BinningPageLoadDefaultSuccessState(pageLoadDefaultModelData));
    } catch (e) {
      emit(BinningPageLoadDefaultFailureState(e.toString()));
    }
  }

  // getValidateLocation api call repo
  Future<void> getValidateLocation(String locationCode, int userId, int companyCode, int menuId, String processCode) async {
     emit(MainLoadingState());
    try {
      final validateLocationModelData = await binningRepository.locationValidate(locationCode, userId, companyCode, menuId, processCode);
      emit(BinningValidateLocationSuccessState(validateLocationModelData));
    } catch (e) {
      emit(BinningValidateLocationFailureState(e.toString()));
    }
  }


// binning api call repo
  Future<void> getBinningDetailListApi(String groupId, int userId, int companyCode, int menuId) async {
     emit(MainLoadingState());
    try {
      final binningDetailListModel = await binningRepository.getBinningDetailListModel(groupId, userId, companyCode, menuId);
      emit(BinningDetailListSuccessState(binningDetailListModel));
    } catch (e) {
      emit(BinningDetailListFailureState(e.toString()));
    }
  }

  // binning api call repo
  Future<void> getBinningSaveApi(String groupId, String awbNo, String houseNo, int flightSeqNo, int igmNo, String locationCode, int locId, int nop, int userId, int companyCode, int menuId) async {
    emit(MainLoadingState());
    try {
      final binningDetailListModel = await binningRepository.getBinningDetailSave(groupId, awbNo, houseNo, flightSeqNo, igmNo, locationCode, locId, nop, userId, companyCode, menuId);
      emit(BinningSaveSuccessState(binningDetailListModel));
    } catch (e) {
      emit(BinningSaveFailureState(e.toString()));
    }
  }



  void resetState() {
    emit(MainInitialState());
  }

}