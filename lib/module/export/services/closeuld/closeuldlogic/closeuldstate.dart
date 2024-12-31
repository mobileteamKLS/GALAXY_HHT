import '../../../model/closeuld/closeuldsearchmodel.dart';
import '../../../model/closeuld/equipmentmodel.dart';

class CloseULDState {}

class CloseULDInitialState extends CloseULDState {}
class CloseULDLoadingState extends CloseULDState {}

/*
class CloseULDPageLoadSuccessState extends CloseULDState {
  final EmptyULDtrolPageLoadModel emptyULDtrolPageLoadModel;
  CloseULDPageLoadSuccessState(this.emptyULDtrolPageLoadModel);
}

class CloseULDPageLoadFailureState extends CloseULDState {
  final String error;
  CloseULDPageLoadFailureState(this.error);
}
*/

class CloseULDSearchSuccessState extends CloseULDState {
  final CloseULDSearchModel closeULDSearchModel;
  CloseULDSearchSuccessState(this.closeULDSearchModel);
}

class CloseULDSearchFailureState extends CloseULDState {
  final String error;
  CloseULDSearchFailureState(this.error);
}


class CloseULDEquipmentSuccessState extends CloseULDState {
  final CloseULDEquipmentModel closeULDEquipmentModel;
  CloseULDEquipmentSuccessState(this.closeULDEquipmentModel);
}

class CloseULDEquipmentFailureState extends CloseULDState {
  final String error;
  CloseULDEquipmentFailureState(this.error);
}
