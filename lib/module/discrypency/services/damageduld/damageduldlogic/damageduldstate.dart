
import '../../../model/damageduld/getdamageduldsearchmodel.dart';

class DamagedULDState {}

class DamagedULDInitialState extends DamagedULDState {}
class DamagedULDLoadingState extends DamagedULDState {}


class GetDamagedULDSearchSuccessState extends DamagedULDState {
  final GetDamagedULDSearchModel getDamagedULDSearchModel;
  GetDamagedULDSearchSuccessState(this.getDamagedULDSearchModel);
}

class GetDamagedULDSearchFailureState extends DamagedULDState {
  final String error;
  GetDamagedULDSearchFailureState(this.error);
}
