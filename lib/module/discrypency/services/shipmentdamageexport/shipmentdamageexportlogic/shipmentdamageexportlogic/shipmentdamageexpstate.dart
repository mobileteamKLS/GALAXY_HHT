

import '../../../../model/shipmentdamageexportmodel/revokedamageexpmodel.dart';
import '../../../../model/shipmentdamageexportmodel/shipmentdamageexportmodel.dart';
import '../../../../model/shipmentdamageexportmodel/shipmentdamagegetpageload.dart';

class ShipmentDamageExpState {}


class ShipmentDamageExpInitialState extends ShipmentDamageExpState {}
class ShipmentDamageExpLoadingState extends ShipmentDamageExpState {}


class GetShipmentDamagePageLoadSuccessState extends ShipmentDamageExpState {
  final ShipmentDamageGetPageLoad shipmentDamageGetPageLoad;
  GetShipmentDamagePageLoadSuccessState(this.shipmentDamageGetPageLoad);
}

class GetShipmentDamagePageLoadFailureState extends ShipmentDamageExpState {
  final String error;
  GetShipmentDamagePageLoadFailureState(this.error);
}



class ShipmentDamageListExpSuccessState extends ShipmentDamageExpState {
  final ShipmentDamageExportModel shipmentDamageExportModel;
  ShipmentDamageListExpSuccessState(this.shipmentDamageExportModel);
}

class ShipmentDamageListExpFailureState extends ShipmentDamageExpState {
  final String error;
  ShipmentDamageListExpFailureState(this.error);
}

class RevokeDamageExpSuccessState extends ShipmentDamageExpState {
  final RevokeDamageExpModel revokeDamageExpModel;
  RevokeDamageExpSuccessState(this.revokeDamageExpModel);
}

class RevokeDamageExpFailureState extends ShipmentDamageExpState {
  final String error;
  RevokeDamageExpFailureState(this.error);
}

