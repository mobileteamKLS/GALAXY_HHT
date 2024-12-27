import 'package:galaxy/module/export/model/unloaduld/unloaduldawblistmodel.dart';
import '../../../../import/model/uldacceptance/locationvalidationmodel.dart';
import '../../../model/emptyuldtrolley/emptyuldtrolpageloadmodel.dart';
import '../../../model/unloaduld/unloadpageloadmodel.dart';
import '../../../model/unloaduld/unloadopenuldmodel.dart';
import '../../../model/unloaduld/unloadremoveawbmodel.dart';
import '../../../model/unloaduld/unloaduldlistmodel.dart';

class EmptyULDTrolleyState {}

class EmptyULDTrolleyInitialState extends EmptyULDTrolleyState {}
class EmptyULDTrolleyLoadingState extends EmptyULDTrolleyState {}

class EmptyULDTrolleyPageLoadSuccessState extends EmptyULDTrolleyState {
  final EmptyULDtrolPageLoadModel emptyULDtrolPageLoadModel;
  EmptyULDTrolleyPageLoadSuccessState(this.emptyULDtrolPageLoadModel);
}

class EmptyULDTrolleyPageLoadFailureState extends EmptyULDTrolleyState {
  final String error;
  EmptyULDTrolleyPageLoadFailureState(this.error);
}

class ValidateLocationSuccessState extends EmptyULDTrolleyState {
  final LocationValidationModel validateLocationModel;
  ValidateLocationSuccessState(this.validateLocationModel);
}

class ValidateLocationFailureState extends EmptyULDTrolleyState {
  final String error;
  ValidateLocationFailureState(this.error);
}