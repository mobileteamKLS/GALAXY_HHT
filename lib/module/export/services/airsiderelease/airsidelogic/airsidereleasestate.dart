import '../../../../import/model/uldacceptance/locationvalidationmodel.dart';

class AirSideReleaseState {}


class AirSideMainInitialState extends AirSideReleaseState {}
class AirSideMainLoadingState extends AirSideReleaseState {}



class ValidateLocationSuccessState extends AirSideReleaseState {
  final LocationValidationModel validateLocationModel;
  ValidateLocationSuccessState(this.validateLocationModel);
}

class ValidateLocationFailureState extends AirSideReleaseState {
  final String error;
  ValidateLocationFailureState(this.error);
}
