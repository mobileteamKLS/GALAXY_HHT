import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:galaxy/module/discrypency/services/shipmentdamageexport/shipmentdamageexportlogic/shipmentdamageexportlogic/shipmentdamageexpstate.dart';

import '../shipmentdamageexprepository.dart';





class ShipmentDamageExpCubit extends Cubit<ShipmentDamageExpState>{
  ShipmentDamageExpCubit() : super( ShipmentDamageExpInitialState() );

  ShipmentDamageExpRepository shipmentDamageExpRepository = ShipmentDamageExpRepository();

  Future<void> getPageLoad(
      int userId,
      int companyCode,
      int menuId) async {
    emit(ShipmentDamageExpLoadingState());
    try {
      final getPageModelData = await shipmentDamageExpRepository.getPageLoad(
          userId,
          companyCode,
          menuId);
      emit(GetShipmentDamagePageLoadSuccessState(getPageModelData));
    } catch (e) {
      emit(GetShipmentDamagePageLoadFailureState(e.toString()));
    }
  }

// ShipmentDamage api call repo
  Future<void> getExpShipmentDamageDetailListApi(String scan, String flag, int userId, int companyCode, int menuId) async {
     emit(ShipmentDamageExpLoadingState());
    try {
      final shipmentDamageListModel = await shipmentDamageExpRepository.getExpAWBDetailListModel(scan, flag, userId, companyCode, menuId);
      emit(ShipmentDamageListExpSuccessState(shipmentDamageListModel));
    } catch (e) {
      emit(ShipmentDamageListExpFailureState(e.toString()));
    }
  }

// Revoke Damage api call repo
  Future<void> revokeExpDamageApi(int expAWBRowId, int expShipRowId, int problemSeqNo, int flighSeqNo, int userId, int companyCode, int menuId) async {
    emit(ShipmentDamageExpLoadingState());
    try {
      final revokeDamageModel = await shipmentDamageExpRepository.revokeDamageExpDetailModel(expAWBRowId, expShipRowId, problemSeqNo, flighSeqNo, userId, companyCode, menuId);
      emit(RevokeDamageExpSuccessState(revokeDamageModel));
    } catch (e) {
      emit(RevokeDamageExpFailureState(e.toString()));
    }
  }



  void resetState() {
    emit(ShipmentDamageExpInitialState());
  }

}