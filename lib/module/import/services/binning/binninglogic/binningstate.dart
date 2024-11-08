
import '../../../model/binning/binningdetaillistmodel.dart';

class BinningState {}


class MainInitialState extends BinningState {}
class MainLoadingState extends BinningState {}



class BinningDetailListSuccessState extends BinningState {
  final BinningDetailListModel binningDetailListModel;
  BinningDetailListSuccessState(this.binningDetailListModel);
}

class BinningDetailListFailureState extends BinningState {
  final String error;
  BinningDetailListFailureState(this.error);
}

