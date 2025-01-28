import 'package:galaxy/module/export/model/offload/offloadShipmentmodel.dart';

import '../../../../import/model/uldacceptance/locationvalidationmodel.dart';
import '../../../model/offload/getoffloadsearchmodel.dart';
import '../../../model/offload/offloadULDmodel.dart';
import '../../../model/offload/offloadgetpageload.dart';

class OffloadState {}

class OffloadInitialState extends OffloadState {}
class OffloadLoadingState extends OffloadState {}

class GetOffloadPageLoadSuccessState extends OffloadState {
  final OffloadGetPageLoad offloadGetPageLoad;
  GetOffloadPageLoadSuccessState(this.offloadGetPageLoad);
}

class GetOffloadPageLoadFailureState extends OffloadState {
  final String error;
  GetOffloadPageLoadFailureState(this.error);
}


class OffloadValidateLocationSuccessState extends OffloadState {
  final LocationValidationModel locationValidationModel;
  OffloadValidateLocationSuccessState(this.locationValidationModel);
}

class OffloadValidateLocationFailureState extends OffloadState {
  final String error;
  OffloadValidateLocationFailureState(this.error);
}


class GetOffloadSearchSuccessState extends OffloadState {
  final GetSearchOffloadModel getSearchOffloadModel;
  GetOffloadSearchSuccessState(this.getSearchOffloadModel);
}

class GetOffloadSearchFailureState extends OffloadState {
  final String error;
  GetOffloadSearchFailureState(this.error);
}

class OffloadAWBSaveSuccessState extends OffloadState {
  final OffloadShipmentModel offloadShipmentModel;
  OffloadAWBSaveSuccessState(this.offloadShipmentModel);
}

class OffloadAWBSaveFailureState extends OffloadState {
  final String error;
  OffloadAWBSaveFailureState(this.error);
}

class OffloadULDSaveSuccessState extends OffloadState {
  final OffloadULDModel offloadULDModel;
  OffloadULDSaveSuccessState(this.offloadULDModel);
}

class OffloadULDSaveFailureState extends OffloadState {
  final String error;
  OffloadULDSaveFailureState(this.error);
}



