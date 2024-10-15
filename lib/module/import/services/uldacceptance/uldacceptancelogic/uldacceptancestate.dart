import '../../../model/uldacceptance/buttonrolesrightsmodel.dart';
import '../../../model/uldacceptance/defaultuldacceptance.dart';
import '../../../model/uldacceptance/flightfromuldmodel.dart';
import '../../../model/uldacceptance/locationvalidationmodel.dart';
import '../../../model/uldacceptance/uldacceptancedetailmodel.dart';
import '../../../model/uldacceptance/uldacceptsmodel.dart';
import '../../../model/uldacceptance/ulddamagelistmodel.dart';
import '../../../model/uldacceptance/ulddamgeupdatemodel.dart';
import '../../../model/uldacceptance/ulducrmodel.dart';


class UldAcceptanceState {}


class MainInitialState extends UldAcceptanceState {}
class MainLoadingState extends UldAcceptanceState {}


class DefaultUldAcceptanceSuccessState extends UldAcceptanceState{
  final DefaultUldAcceptanceModel defaultUldAcceptanceModel;
  DefaultUldAcceptanceSuccessState(this.defaultUldAcceptanceModel);
}

class DefaultUldAcceptanceFailureState extends UldAcceptanceState{
  final String error;
  DefaultUldAcceptanceFailureState(this.error);
}


class ButtonRolesAndRightsSuccessState extends UldAcceptanceState{
  final ButtonRolesRightsModel buttonRolesRightsModel;
  ButtonRolesAndRightsSuccessState(this.buttonRolesRightsModel);
}

class ButtonRolesAndRightsFailureState extends UldAcceptanceState{
  final String error;
  ButtonRolesAndRightsFailureState(this.error);
}




class ValidateLocationSuccessState extends UldAcceptanceState {
  final LocationValidationModel validateLocationModel;
  ValidateLocationSuccessState(this.validateLocationModel);
}

class ValidateLocationFailureState extends UldAcceptanceState {
  final String error;
  ValidateLocationFailureState(this.error);
}

class UldacceptanceListSuccessState extends UldAcceptanceState{
  final UldAcceptanceDetail uldacceptanceSuccessState;
  UldacceptanceListSuccessState(this.uldacceptanceSuccessState);
}
class UldacceptanceListFailureState extends UldAcceptanceState{
  final String error;
  UldacceptanceListFailureState(this.error);
}

class UldAcceptSuccessState extends UldAcceptanceState{
  final UldAcceptModel uldAcceptModel;
  UldAcceptSuccessState(this.uldAcceptModel);
}
class UldAcceptFailureState extends UldAcceptanceState{
  final String error;
  UldAcceptFailureState(this.error);
}

class TrollyAcceptSuccessState extends UldAcceptanceState{
  final UldAcceptModel uldAcceptModel;
  TrollyAcceptSuccessState(this.uldAcceptModel);
}
class TrollyAcceptFailureState extends UldAcceptanceState{
  final String error;
  TrollyAcceptFailureState(this.error);
}

class UldDamageListSuccessState extends UldAcceptanceState{
  final UldDamageListModel uldDamageListModel;
  UldDamageListSuccessState(this.uldDamageListModel);
}
class UldDamageListFailureState extends UldAcceptanceState{
  final String error;
  UldDamageListFailureState(this.error);
}

class UldDamageSuccessState extends UldAcceptanceState{
  final UldAcceptModel uldAcceptModel;
  UldDamageSuccessState(this.uldAcceptModel);
}
class UldDamageFailureState extends UldAcceptanceState{
  final String error;
  UldDamageFailureState(this.error);
}

class UldDamageAcceptSuccessState extends UldAcceptanceState{
  final UldAcceptModel uldAcceptModel;
  UldDamageAcceptSuccessState(this.uldAcceptModel);
}
class UldDamageAcceptFailureState extends UldAcceptanceState{
  final String error;
  UldDamageAcceptFailureState(this.error);
}

class UldDamageUpdateSuccessState extends UldAcceptanceState{
  final UldDamageUpdatetModel uldDamageUpdateModel;
  UldDamageUpdateSuccessState(this.uldDamageUpdateModel);
}
class UldDamageUpdateFailureState extends UldAcceptanceState{
  final String error;
  UldDamageUpdateFailureState(this.error);
}

class FlightFromULDSuccessState extends UldAcceptanceState{
  final FlightFromULDModel flightFromULDModel;
  FlightFromULDSuccessState(this.flightFromULDModel);
}
class FlightFromULDFailureState extends UldAcceptanceState{
  final String error;
  FlightFromULDFailureState(this.error);
}

class UldUCRSuccessState extends UldAcceptanceState{
  final UldUCRModel uldUCRModel;
  UldUCRSuccessState(this.uldUCRModel);
}
class UldUCRFailureState extends UldAcceptanceState{
  final String error;
  UldUCRFailureState(this.error);
}

class UldUCRDamageSuccessState extends UldAcceptanceState{
  final UldAcceptModel uldAcceptModel;
  UldUCRDamageSuccessState(this.uldAcceptModel);
}
class UldUCRDamageFailureState extends UldAcceptanceState{
  final String error;
  UldUCRDamageFailureState(this.error);
}
