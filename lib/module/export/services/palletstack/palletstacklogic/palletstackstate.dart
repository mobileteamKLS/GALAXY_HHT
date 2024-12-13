import '../../../../import/model/uldacceptance/locationvalidationmodel.dart';
import '../../../model/palletstock/addpalletstackmodel.dart';
import '../../../model/palletstock/palletstackassignflightmodel.dart';
import '../../../model/palletstock/palletstackdefaultpageloadmodel.dart';
import '../../../model/palletstock/palletstacklistmodel.dart';
import '../../../model/palletstock/palletstackpageloadmodel.dart';
import '../../../model/palletstock/palletstackuldconditioncodemodel.dart';
import '../../../model/palletstock/palletstackupdateuldconditioncodemodel.dart';
import '../../../model/palletstock/removepalletstackmodel.dart';
import '../../../model/palletstock/reopenClosepalletstackmodel.dart';
import '../../../model/palletstock/revokepalletstackmodel.dart';



class PalletStackState {}


class PalletStackInitialState extends PalletStackState {}
class PalletStackLoadingState extends PalletStackState {}

class PalletStackDefaultPageLoadSuccessState extends PalletStackState {
  final PalletStackDefaultPageLoadModel palletStackDefaultPageLoadModel;
  PalletStackDefaultPageLoadSuccessState(this.palletStackDefaultPageLoadModel);
}

class PalletStackDefaultPageLoadFailureState extends PalletStackState {
  final String error;
  PalletStackDefaultPageLoadFailureState(this.error);
}


class PalletStackStatePageLoadSuccessState extends PalletStackState {
  final PalletStackPageLoadModel palletStackPageLoadModel;
  PalletStackStatePageLoadSuccessState(this.palletStackPageLoadModel);
}

class PalletStackStatePageLoadFailureState extends PalletStackState {
  final String error;
  PalletStackStatePageLoadFailureState(this.error);
}

class ValidateLocationSuccessState extends PalletStackState {
  final LocationValidationModel validateLocationModel;
  ValidateLocationSuccessState(this.validateLocationModel);
}

class ValidateLocationFailureState extends PalletStackState {
  final String error;
  ValidateLocationFailureState(this.error);
}

class PalletStackListSuccessState extends PalletStackState {
  final PalletStackListModel palletStackListModel;
  PalletStackListSuccessState(this.palletStackListModel);
}

class PalletStackListFailureState extends PalletStackState {
  final String error;
  PalletStackListFailureState(this.error);
}

class PalletStackAssignFlightSuccessState extends PalletStackState {
  final PalletStackAssignFlightModel palletStackAssignFlightModel;
  PalletStackAssignFlightSuccessState(this.palletStackAssignFlightModel);
}

class PalletStackAssignFlightFailureState extends PalletStackState {
  final String error;
  PalletStackAssignFlightFailureState(this.error);
}

class PalletStackULDConditionCodeSuccessState extends PalletStackState {
  final PalletStackULDConditionCodeModel palletStackULDConditionCodeModel;
  PalletStackULDConditionCodeSuccessState(this.palletStackULDConditionCodeModel);
}

class PalletStackULDConditionCodeFailureState extends PalletStackState {
  final String error;
  PalletStackULDConditionCodeFailureState(this.error);
}

class PalletStackULDConditionCodeASuccessState extends PalletStackState {
  final PalletStackULDConditionCodeModel palletStackULDConditionCodeModel;
  PalletStackULDConditionCodeASuccessState(this.palletStackULDConditionCodeModel);
}

class PalletStackULDConditionCodeAFailureState extends PalletStackState {
  final String error;
  PalletStackULDConditionCodeAFailureState(this.error);
}



class PalletStackUpdateULDConditionCodeSuccessState extends PalletStackState {
  final PalletStackUpdateULDConditionCodeModel palletStackUpdateULDConditionCodeModel;
  PalletStackUpdateULDConditionCodeSuccessState(this.palletStackUpdateULDConditionCodeModel);
}

class PalletStackUpdateULDConditionCodeFailureState extends PalletStackState {
  final String error;
  PalletStackUpdateULDConditionCodeFailureState(this.error);
}

class AddPalletStackSuccessState extends PalletStackState {
  final AddPalletStackModel removePalletStackModel;
  AddPalletStackSuccessState(this.removePalletStackModel);
}

class AddPalletStackFailureState extends PalletStackState {
  final String error;
  AddPalletStackFailureState(this.error);
}

class RemovePalletStackSuccessState extends PalletStackState {
  final RemovePalletStackModel removePalletStackModel;
  RemovePalletStackSuccessState(this.removePalletStackModel);
}

class RemovePalletStackFailureState extends PalletStackState {
  final String error;
  RemovePalletStackFailureState(this.error);
}



class RevokePalletStackSuccessState extends PalletStackState {
  final RevokePalletStackModel revokePalletStackModel;
  RevokePalletStackSuccessState(this.revokePalletStackModel);
}

class RevokePalletStackFailureState extends PalletStackState {
  final String error;
  RevokePalletStackFailureState(this.error);
}


class ReopenClosePalletStackSuccessState extends PalletStackState {
  final ReopenClosePalletStackModel reopenClosePalletStackModel;
  ReopenClosePalletStackSuccessState(this.reopenClosePalletStackModel);
}

class ReopenClosePalletStackFailureState extends PalletStackState {
  final String error;
  ReopenClosePalletStackFailureState(this.error);
}

class ReopenClosePalletStackASuccessState extends PalletStackState {
  final ReopenClosePalletStackModel reopenClosePalletStackModel;
  ReopenClosePalletStackASuccessState(this.reopenClosePalletStackModel);
}

class ReopenClosePalletStackAFailureState extends PalletStackState {
  final String error;
  ReopenClosePalletStackAFailureState(this.error);
}
