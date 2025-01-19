import 'package:galaxy/module/export/model/splitgroup/splitgroupdetailsearchmodel.dart';
import '../../../../import/model/uldacceptance/locationvalidationmodel.dart';
import '../../../model/splitgroup/splitgroupdefaultpageloadmodel.dart';
import '../../../model/splitgroup/splitgroupsavemodel.dart';


class SplitGroupState {}

class SplitGroupInitialState extends SplitGroupState {}
class SplitGroupLoadingState extends SplitGroupState {}

class SplitGroupDefaultPageLoadSuccessState extends SplitGroupState {
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
}

