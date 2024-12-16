import '../../../../import/model/uldacceptance/locationvalidationmodel.dart';
import '../../../model/palletstock/addpalletstackmodel.dart';
import '../../../model/palletstock/palletstackassignflightmodel.dart';
import '../../../model/palletstock/palletstackdefaultpageloadmodel.dart';
import '../../../model/palletstock/palletstacklistmodel.dart';
import '../../../model/palletstock/palletstackpageloadmodel.dart';
import '../../../model/palletstock/palletstackuldconditioncodemodel.dart';
import '../../../model/palletstock/palletstackupdateuldconditioncodemodel.dart';
import '../../../model/palletstock/removepalletstackmodel.dart';
import '../../../model/palletstock/reopenClosepalletstackmodel.dart';
import '../../../model/palletstock/revokepalletstackmodel.dart';
import '../../../model/retriveuld/retriveulddetailmodel.dart';
import '../../../model/retriveuld/retriveuldloadmodel.dart';



class RetriveULDState {}


class RetriveULDInitialState extends RetriveULDState {}
class RetriveULDLoadingState extends RetriveULDState {}

class RetriveULDPageLoadSuccessState extends RetriveULDState {
  final RetriveULDPageLoadModel retriveULDPageLoadModel;
  RetriveULDPageLoadSuccessState(this.retriveULDPageLoadModel);
}

class RetriveULDPageLoadFailureState extends RetriveULDState {
  final String error;
  RetriveULDPageLoadFailureState(this.error);
}

class ValidateLocationSuccessState extends RetriveULDState {
  final LocationValidationModel validateLocationModel;
  ValidateLocationSuccessState(this.validateLocationModel);
}

class ValidateLocationFailureState extends RetriveULDState {
  final String error;
  ValidateLocationFailureState(this.error);
}

class RetriveULDDetailSuccessState extends RetriveULDState {
  final RetriveULDDetailLoadModel retriveULDDetailLoadModel;
  RetriveULDDetailSuccessState(this.retriveULDDetailLoadModel);
}

class RetriveULDDetailFailureState extends RetriveULDState {
  final String error;
  RetriveULDDetailFailureState(this.error);
}


