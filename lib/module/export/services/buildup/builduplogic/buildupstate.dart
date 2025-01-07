import 'package:galaxy/module/export/model/buildup/flightsearchmodel.dart';
import 'package:galaxy/module/export/model/closetrolley/gettrolleydocumentlistmodel.dart';
import '../../../../import/model/uldacceptance/locationvalidationmodel.dart';
import '../../../model/closetrolley/closetrolleyreopenmodel.dart';
import '../../../model/closetrolley/closetrolleysearchmodel.dart';
import '../../../model/closetrolley/gettrolleyscalelistmodel.dart';
import '../../../model/closetrolley/savetrolleyscalemodel.dart';


class BuildUpState {}

class BuildUpInitialState extends BuildUpState {}
class BuildUpLoadingState extends BuildUpState {}



class ValidateLocationSuccessState extends BuildUpState {
  final LocationValidationModel validateLocationModel;
  ValidateLocationSuccessState(this.validateLocationModel);
}

class ValidateLocationFailureState extends BuildUpState {
  final String error;
  ValidateLocationFailureState(this.error);
}

class FlightSearchSuccessState extends BuildUpState {
  final FlightSearchModel flightSearchModel;
  FlightSearchSuccessState(this.flightSearchModel);
}

class FlightSearchFailureState extends BuildUpState {
  final String error;
  FlightSearchFailureState(this.error);
}

/*
class ButtonRolesAndRightsSuccessState extends BuildUpState{
  final ButtonRolesRightsModel buttonRolesRightsModel;
  ButtonRolesAndRightsSuccessState(this.buttonRolesRightsModel);
}

class ButtonRolesAndRightsFailureState extends BuildUpState{
  final String error;
  ButtonRolesAndRightsFailureState(this.error);
}
*/






/*
class GetULDSuccessState extends BuildUpState {
  final FlightCheckULDListModel flightCheckULDListModel;
  FlightGetDetailsSuccessState(this.flightCheckULDListModel);
}

class FlightGetDetailsFailureState extends BuildUpState {
  final String error;
  FlightGetDetailsFailureState(this.error);
}

class GetFlightDetailsSummarySuccessState extends FlightCheckState {
  final FlightCheckSummaryModel flightCheckSummaryModel;
  GetFlightDetailsSummarySuccessState(this.flightCheckSummaryModel);
}

class GetFlightDetailsSummaryFailureState extends FlightCheckState {
  final String error;
  GetFlightDetailsSummaryFailureState(this.error);
}


class BDPrioritySuccessState extends FlightCheckState {
  final BdPriorityModel bdPriorityModel;
  BDPrioritySuccessState(this.bdPriorityModel);
}

class BDPriorityFailureState extends FlightCheckState {
  final String error;
  BDPriorityFailureState(this.error);
}




class AWBListSuccessState extends FlightCheckState {
  final AWBModel aWBModel;
  AWBListSuccessState(this.aWBModel);
}

class AWBListFailureState extends FlightCheckState {
  final String error;
  AWBListFailureState(this.error);
}


class AWBAcknoledgeSuccessState extends FlightCheckState {
  final AWBRemarkAcknoledgeModel awbRemarkAcknoledgeModel;
  AWBAcknoledgeSuccessState(this.awbRemarkAcknoledgeModel);
}

class AWBAcknoledgeFailureState extends FlightCheckState {
  final String error;
  AWBAcknoledgeFailureState(this.error);
}


*/


