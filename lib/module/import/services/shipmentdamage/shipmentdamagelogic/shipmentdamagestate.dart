import '../../../model/shipmentdamage/shipmentdamagelistmodel.dart';


class ShipmentDamageState {}


class ShipmentDamageInitialState extends ShipmentDamageState {}
class ShipmentDamageLoadingState extends ShipmentDamageState {}


class ShipmentDamageListSuccessState extends ShipmentDamageState {
  final ShipmentDamageListModel shipmentDamageListModel;
  ShipmentDamageListSuccessState(this.shipmentDamageListModel);
}

class ShipmentDamageListFailureState extends ShipmentDamageState {
  final String error;
  ShipmentDamageListFailureState(this.error);
}

