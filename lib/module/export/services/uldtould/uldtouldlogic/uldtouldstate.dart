import 'package:galaxy/module/export/model/uldtould/removeflightmodel.dart';

import '../../../model/uldtould/moveuldmodel.dart';
import '../../../model/uldtould/sourceuldmodel.dart';
import '../../../model/uldtould/targetuldmodel.dart';

class ULDToULDState {}

class ULDToULDStateInitialState extends ULDToULDState {}
class ULDToULDStateLoadingState extends ULDToULDState {}

class SourceULDLoadSuccessState extends ULDToULDState {
  final SourceULDModel sourceULDModel;
  SourceULDLoadSuccessState(this.sourceULDModel);
}

class SourceULDLoadFailureState extends ULDToULDState {
  final String error;
  SourceULDLoadFailureState(this.error);
}

class TargetULDLoadSuccessState extends ULDToULDState {
  final TargetULDModel targetULDModel;
  TargetULDLoadSuccessState(this.targetULDModel);
}

class TargetULDLoadFailureState extends ULDToULDState {
  final String error;
  TargetULDLoadFailureState(this.error);
}

class MoveULDLoadSuccessState extends ULDToULDState {
  final MoveULDModel moveULDModel;
  MoveULDLoadSuccessState(this.moveULDModel);
}

class MoveULDLoadFailureState extends ULDToULDState {
  final String error;
  MoveULDLoadFailureState(this.error);
}

class RemoveFlightLoadSuccessState extends ULDToULDState {
  final RemoveFlightModel removeFlightModel;
  RemoveFlightLoadSuccessState(this.removeFlightModel);
}

class RemoveFlightLoadFailureState extends ULDToULDState {
  final String error;
  RemoveFlightLoadFailureState(this.error);
}