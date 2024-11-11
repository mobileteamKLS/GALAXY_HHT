
import 'package:galaxy/module/import/model/binning/binningsavemodel.dart';

import '../../../model/binning/binningdetaillistmodel.dart';
import '../../../model/binning/binningpageloaddefault.dart';
import '../../../model/uldacceptance/locationvalidationmodel.dart';

class BinningState {}


class MainInitialState extends BinningState {}
class MainLoadingState extends BinningState {}

class BinningValidateLocationSuccessState extends BinningState {
  final LocationValidationModel validateLocationModel;
  BinningValidateLocationSuccessState(this.validateLocationModel);
}

class BinningValidateLocationFailureState extends BinningState {
  final String error;
  BinningValidateLocationFailureState(this.error);
}


class BinningPageLoadDefaultSuccessState extends BinningState{
  final BinningPageLoadDefaultModel binningPageLoadDefaultModel;
  BinningPageLoadDefaultSuccessState(this.binningPageLoadDefaultModel);
}

class BinningPageLoadDefaultFailureState extends BinningState{
  final String error;
  BinningPageLoadDefaultFailureState(this.error);
}



class BinningDetailListSuccessState extends BinningState {
  final BinningDetailListModel binningDetailListModel;
  BinningDetailListSuccessState(this.binningDetailListModel);
}

class BinningDetailListFailureState extends BinningState {
  final String error;
  BinningDetailListFailureState(this.error);
}

class BinningSaveSuccessState extends BinningState {
  final BinningSaveModel binningSaveModel;
  BinningSaveSuccessState(this.binningSaveModel);
}

class BinningSaveFailureState extends BinningState {
  final String error;
  BinningSaveFailureState(this.error);
}

