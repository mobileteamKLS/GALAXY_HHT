
import '../../../model/binning/binningdetaillistmodel.dart';
import '../../../model/binning/binningpageloaddefault.dart';
import '../../../model/uldacceptance/locationvalidationmodel.dart';

class BinningState {}


class MainInitialState extends BinningState {}
class MainLoadingState extends BinningState {}

class ValidateLocationSuccessState extends BinningState {
  final LocationValidationModel validateLocationModel;
  ValidateLocationSuccessState(this.validateLocationModel);
}

class ValidateLocationFailureState extends BinningState {
  final String error;
  ValidateLocationFailureState(this.error);
}


class PageLoadDefaultSuccessState extends BinningState{
  final BinningPageLoadDefaultModel binningPageLoadDefaultModel;
  PageLoadDefaultSuccessState(this.binningPageLoadDefaultModel);
}

class PageLoadDefaultFailureState extends BinningState{
  final String error;
  PageLoadDefaultFailureState(this.error);
}




class BinningDetailListSuccessState extends BinningState {
  final BinningDetailListModel binningDetailListModel;
  BinningDetailListSuccessState(this.binningDetailListModel);
}

class BinningDetailListFailureState extends BinningState {
  final String error;
  BinningDetailListFailureState(this.error);
}

