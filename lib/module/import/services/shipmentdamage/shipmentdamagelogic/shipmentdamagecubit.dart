import 'package:flutter_bloc/flutter_bloc.dart';

import '../shipmentdamagerepository.dart';
import 'shipmentdamagestate.dart';



class ShipmentDamageCubit extends Cubit<ShipmentDamageState>{
  ShipmentDamageCubit() : super( MainInitialState() );

  ShipmentDamageRepository shipmentDamageRepository = ShipmentDamageRepository();

// getButtonsRoles & Rights api call repo
/*
  Future<void> getPageLoadDefault(int menuId, int userId, int companyCode) async {
    emit(MainLoadingState());
    try {
      final pageLoadDefaultModelData = await binningRepository.getPageLoadDefault(menuId, userId, companyCode);
      emit(BinningPageLoadDefaultSuccessState(pageLoadDefaultModelData));
    } catch (e) {
      emit(BinningPageLoadDefaultFailureState(e.toString()));
    }
  }
*/



/*// binning api call repo
  Future<void> getDamageDetailListApi(String groupId, int userId, int companyCode, int menuId) async {
     emit(MainLoadingState());
    try {
      final binningDetailListModel = await damageRepository.getBinningDetailListModel(groupId, userId, companyCode, menuId);
      emit(Dama(binningDetailListModel));
    } catch (e) {
      emit(BinningDetailListFailureState(e.toString()));
    }
  }*/




  void resetState() {
    emit(MainInitialState());
  }

}