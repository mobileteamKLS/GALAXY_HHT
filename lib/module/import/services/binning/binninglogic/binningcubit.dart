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
      emit(PageLoadDefaultSuccessState(pageLoadDefaultModelData));
    } catch (e) {
      emit(PageLoadDefaultFailureState(e.toString()));
    }
  }

  // getValidateLocation api call repo
  Future<void> getValidateLocation(String locationCode, int userId, int companyCode, int menuId, String processCode) async {
    // emit(MainLoadingState());
    try {
      final validateLocationModelData = await binningRepository.locationValidate(locationCode, userId, companyCode, menuId, processCode);
      emit(ValidateLocationSuccessState(validateLocationModelData));
    } catch (e) {
      emit(ValidateLocationFailureState(e.toString()));
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



  void resetState() {
    emit(MainInitialState());
  }

}