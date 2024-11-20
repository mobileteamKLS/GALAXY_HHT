import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:galaxy/module/import/services/shipmentdamage/shipmentdamagelogic/shipmentdamagestate.dart';

import '../shipmentdamagerepository.dart';





class ShipmentDamageCubit extends Cubit<ShipmentDamageState>{
  ShipmentDamageCubit() : super( ShipmentDamageInitialState() );

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



// ShipmentDamage api call repo
  Future<void> getShipmentDamageDetailListApi(String scan, String flag, int userId, int companyCode, int menuId) async {
     emit(ShipmentDamageLoadingState());
    try {
      final shipmentDamageListModel = await shipmentDamageRepository.getDamageDetailListModel(scan, flag, userId, companyCode, menuId);
      emit(ShipmentDamageListSuccessState(shipmentDamageListModel));
    } catch (e) {
      emit(ShipmentDamageListFailureState(e.toString()));
    }
  }




  void resetState() {
    emit(ShipmentDamageInitialState());
  }

}