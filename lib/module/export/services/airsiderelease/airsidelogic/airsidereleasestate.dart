import '../../../../import/model/uldacceptance/locationvalidationmodel.dart';
import '../../../model/airsiderelease/airsidereleasebatteryupdatemodel.dart';
import '../../../model/airsiderelease/airsidereleasedatamodel.dart';
import '../../../model/airsiderelease/airsidereleasepageloadmodel.dart';
import '../../../model/airsiderelease/airsidereleasepriorityupdatemodel.dart';
import '../../../model/airsiderelease/airsidereleasesearchmodel.dart';
import '../../../model/airsiderelease/airsidereleasetempupdatemodel.dart';
import '../../../model/airsiderelease/airsideshipmentlistmodel.dart';
import '../../../model/airsiderelease/airsidesignuploadmodel.dart';

class AirSideReleaseState {}


class AirSideMainInitialState extends AirSideReleaseState {}
class AirSideMainLoadingState extends AirSideReleaseState {}

class AirsideReleasePageLoadSuccessState extends AirSideReleaseState {
  final AirsidePageLoadModel airsidePageLoadModel;
  AirsideReleasePageLoadSuccessState(this.airsidePageLoadModel);
}

class AirsideReleasePageLoadFailureState extends AirSideReleaseState {
  final String error;
  AirsideReleasePageLoadFailureState(this.error);
}

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


class AirsideReleasePriorityUpdateSuccessState extends AirSideReleaseState {
  final AirsideReleasePriorityUpdateModel airsideReleasePriorityUpdateModel;
  AirsideReleasePriorityUpdateSuccessState(this.airsideReleasePriorityUpdateModel);
}

class AirsideReleasePriorityUpdateFailureState extends AirSideReleaseState {
  final String error;
  AirsideReleasePriorityUpdateFailureState(this.error);
}

class AirsideSignUploadSuccesState extends AirSideReleaseState {
  final AirsideSignUploadModel airsideSignUploadModel;
  AirsideSignUploadSuccesState(this.airsideSignUploadModel);
}

class AirsideSignUploadFailureState extends AirSideReleaseState {
  final String error;
  AirsideSignUploadFailureState(this.error);
}


class AirsideReleaseBatteryUpdateSuccessState extends AirSideReleaseState {
  final AirsideReleaseBatteryUpdateModel airsideReleaseBatteryUpdateModel;
  AirsideReleaseBatteryUpdateSuccessState(this.airsideReleaseBatteryUpdateModel);
}

class AirsideReleaseBatteryUpdateFailureState extends AirSideReleaseState {
  final String error;
  AirsideReleaseBatteryUpdateFailureState(this.error);
}


class AirsideReleaseTempUpdateSuccessState extends AirSideReleaseState {
  final AirsideReleaseTempUpdateModel airsideReleaseTempUpdateModel;
  AirsideReleaseTempUpdateSuccessState(this.airsideReleaseTempUpdateModel);
}

class AirsideReleaseTempUpdateFailureState extends AirSideReleaseState {
  final String error;
  AirsideReleaseTempUpdateFailureState(this.error);
}


