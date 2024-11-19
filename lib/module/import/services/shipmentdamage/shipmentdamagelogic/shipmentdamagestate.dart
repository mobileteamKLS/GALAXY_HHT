import '../../../model/uldacceptance/locationvalidationmodel.dart';

class ShipmentDamageState {}


class MainInitialState extends ShipmentDamageState {}
class MainLoadingState extends ShipmentDamageState {}

class DamageValidateLocationSuccessState extends ShipmentDamageState {
  final LocationValidationModel validateLocationModel;
  DamageValidateLocationSuccessState(this.validateLocationModel);
}

class DamageValidateLocationFailureState extends ShipmentDamageState {
  final String error;
  DamageValidateLocationFailureState(this.error);
}



