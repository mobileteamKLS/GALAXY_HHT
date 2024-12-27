import 'package:galaxy/module/export/model/unloaduld/unloaduldawblistmodel.dart';
import '../../../model/unloaduld/unloadpageloadmodel.dart';
import '../../../model/unloaduld/unloadopenuldmodel.dart';
import '../../../model/unloaduld/unloadremoveawbmodel.dart';
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

class UnloadULDAWBListSuccessState extends UnloadULDState {
  final UnloadUldAWBListModel unloadUldAWBListModel;
  UnloadULDAWBListSuccessState(this.unloadUldAWBListModel);
}

class UnloadULDAWBListFailureState extends UnloadULDState {
  final String error;
  UnloadULDAWBListFailureState(this.error);
}

class UnloadOpenULDSuccessState extends UnloadULDState {
  final UnloadOpenULDModel unloadUldCloseModel;
  UnloadOpenULDSuccessState(this.unloadUldCloseModel);
}

class UnloadOpenULDFailureState extends UnloadULDState {
  final String error;
  UnloadOpenULDFailureState(this.error);
}

class UnloadOpenULDSuccessStateA extends UnloadULDState {
  final UnloadOpenULDModel unloadUldCloseModel;
  UnloadOpenULDSuccessStateA(this.unloadUldCloseModel);
}

class UnloadOpenULDFailureStateA extends UnloadULDState {
  final String error;
  UnloadOpenULDFailureStateA(this.error);
}



class UnloadRemoveAWBSuccessState extends UnloadULDState {
  final UnloadRemoveAWBModel unloadRemoveAWBModel;
  UnloadRemoveAWBSuccessState(this.unloadRemoveAWBModel);
}

class UnloadRemoveAWBFailureState extends UnloadULDState {
  final String error;
  UnloadRemoveAWBFailureState(this.error);
}

class UnloadRemoveAWBSuccessStateA extends UnloadULDState {
  final UnloadRemoveAWBModel unloadRemoveAWBModel;
  UnloadRemoveAWBSuccessStateA(this.unloadRemoveAWBModel);
}

class UnloadRemoveAWBFailureStateA extends UnloadULDState {
  final String error;
  UnloadRemoveAWBFailureStateA(this.error);
}