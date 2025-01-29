
import '../../../model/deactiveuld/getuldsearchmodel.dart';
import '../../../model/deactiveuld/ulddeactivatemodel.dart';

class DeactiveULDState {}

class DeactiveULDInitialState extends DeactiveULDState {}
class DeactiveULDLoadingState extends DeactiveULDState {}


class GetDeactiveULDSearchSuccessState extends DeactiveULDState {
  final GetULDSearchModel getULDSearchModel;
  GetDeactiveULDSearchSuccessState(this.getULDSearchModel);
}

class GetDeactiveULDSearchFailureState extends DeactiveULDState {
  final String error;
  GetDeactiveULDSearchFailureState(this.error);
}

class GetDeactiveSuccessState extends DeactiveULDState {
  final ULDDeactivateModel uldDeactivateModel;
  GetDeactiveSuccessState(this.uldDeactivateModel);
}

class GetDeactiveFailureState extends DeactiveULDState {
  final String error;
  GetDeactiveFailureState(this.error);
}
