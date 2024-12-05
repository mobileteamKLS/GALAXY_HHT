import '../../../../import/model/uldacceptance/locationvalidationmodel.dart';
import '../../../model/airsiderelease/airsidereleasedatamodel.dart';
import '../../../model/airsiderelease/airsidereleasesearchmodel.dart';
import '../../../model/airsiderelease/airsideshipmentlistmodel.dart';

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

class AirsideReleaseSuccessState extends AirSideReleaseState {
  final AirSideReleaseSearchModel airSideReleaseSearchModel;
  AirsideReleaseSuccessState(this.airSideReleaseSearchModel);
}

class AirsideReleaseFailureState extends AirSideReleaseState {
  final String error;
  AirsideReleaseFailureState(this.error);
}


class AirsideShipmentListSuccessState extends AirSideReleaseState {
  final AirsideShipmentListModel airsideShipmentListModel;
  AirsideShipmentListSuccessState(this.airsideShipmentListModel);
}

class AirsideShipmentListFailureState extends AirSideReleaseState {
  final String error;
  AirsideShipmentListFailureState(this.error);
}


class AirsideReleaseDataSuccessState extends AirSideReleaseState {
  final AirsideReleaseDataModel airsideReleaseDataModel;
  AirsideReleaseDataSuccessState(this.airsideReleaseDataModel);
}

class AirsideReleaseDataFailureState extends AirSideReleaseState {
  final String error;
  AirsideReleaseDataFailureState(this.error);
}
