import 'package:galaxy/module/export/model/unloaduld/unloaduldawblistmodel.dart';
import '../../../../import/model/uldacceptance/locationvalidationmodel.dart';
import '../../../model/emptyuldtrolley/createuldtrolleymodel.dart';
import '../../../model/emptyuldtrolley/emptyuldtrolpageloadmodel.dart';
import '../../../model/emptyuldtrolley/searchuldtrolleymodel.dart';
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

class SearchULDTrolleySuccessState extends EmptyULDTrolleyState {
  final SearchULDTrolleyModel searchULDTrolleyModel;
  SearchULDTrolleySuccessState(this.searchULDTrolleyModel);
}

class SearchULDTrolleyFailureState extends EmptyULDTrolleyState {
  final String error;
  SearchULDTrolleyFailureState(this.error);
}

class CreateULDTrolleySuccessState extends EmptyULDTrolleyState {
  final CreateULDTrolleyModel createULDTrolleyModel;
  CreateULDTrolleySuccessState(this.createULDTrolleyModel);
}

class CreateULDTrolleyFailureState extends EmptyULDTrolleyState {
  final String error;
  CreateULDTrolleyFailureState(this.error);
}