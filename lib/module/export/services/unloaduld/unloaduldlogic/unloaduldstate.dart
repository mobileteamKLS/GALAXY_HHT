import '../../../model/uldtould/moveuldmodel.dart';
import '../../../model/uldtould/sourceuldmodel.dart';
import '../../../model/uldtould/targetuldmodel.dart';
import '../../../model/unloaduld/unloadpageloadmodel.dart';
import '../../../model/unloaduld/unloaduldlistmodel.dart';

class UnloadULDState {}

class UnloadULDInitialState extends UnloadULDState {}
class UnloadULDLoadingState extends UnloadULDState {}

class UnloadULDPageLoadSuccessState extends UnloadULDState {
  final UnloadUldPageLoadModel unloadUldPageLoadModel;
  UnloadULDPageLoadSuccessState(this.unloadUldPageLoadModel);
}

class UnloadULDPageLoadFailureState extends UnloadULDState {
  final String error;
  UnloadULDPageLoadFailureState(this.error);
}

class UnloadULDListSuccessState extends UnloadULDState {
  final UnloadUldListModel unloadUldListModel;
  UnloadULDListSuccessState(this.unloadUldListModel);
}

class UnloadULDListFailureState extends UnloadULDState {
  final String error;
  UnloadULDListFailureState(this.error);
}