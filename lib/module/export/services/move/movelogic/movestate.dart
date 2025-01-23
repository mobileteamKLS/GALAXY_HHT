import 'package:galaxy/module/export/model/splitgroup/splitgroupdetailsearchmodel.dart';
import '../../../../import/model/uldacceptance/locationvalidationmodel.dart';
import '../../../model/move/movelocationmodel.dart';
import '../../../model/splitgroup/splitgroupdefaultpageloadmodel.dart';
import '../../../model/splitgroup/splitgroupsavemodel.dart';


class MoveState {}

class MoveInitialState extends MoveState {}
class MoveLoadingState extends MoveState {}


class MoveLocationSuccessState extends MoveState {
  final MoveLocationModel moveLocationModel;
  MoveLocationSuccessState(this.moveLocationModel);
}

class MoveLocationFailureState extends MoveState {
  final String error;
  MoveLocationFailureState(this.error);
}

/*class SplitGroupDefaultPageLoadSuccessState extends SplitGroupState {
  final SplitGroupDefaultPageLoadModel splitGroupDefaultPageLoadModel;
  SplitGroupDefaultPageLoadSuccessState(this.splitGroupDefaultPageLoadModel);
}

class SplitGroupDefaultPageLoadFailureState extends SplitGroupState {
  final String error;
  SplitGroupDefaultPageLoadFailureState(this.error);
}


class ValidateLocationSuccessState extends SplitGroupState {
  final LocationValidationModel validateLocationModel;
  ValidateLocationSuccessState(this.validateLocationModel);
}

class ValidateLocationFailureState extends SplitGroupState {
  final String error;
  ValidateLocationFailureState(this.error);
}


class SplitGroupDetailSearchSuccessState extends SplitGroupState {
  final GetSplitGroupDetailSearchModel getSplitGroupDetailSearchModel;
  SplitGroupDetailSearchSuccessState(this.getSplitGroupDetailSearchModel);
}

class SplitGroupDetailSearchFailureState extends SplitGroupState {
  final String error;
  SplitGroupDetailSearchFailureState(this.error);
}


class SplitGroupSaveSuccessState extends SplitGroupState {
  final SplitGroupSaveModel splitGroupSaveModel;
  SplitGroupSaveSuccessState(this.splitGroupSaveModel);
}

class SplitGroupSaveFailureState extends SplitGroupState {
  final String error;
  SplitGroupSaveFailureState(this.error);
}*/

