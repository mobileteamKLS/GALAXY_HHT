
import 'package:galaxy/module/import/model/flightcheck/addMailModel.dart';
import 'package:galaxy/module/import/model/flightcheck/airportcitymodel.dart';
import 'package:galaxy/module/import/model/flightcheck/bdprioritymodel.dart';
import 'package:galaxy/module/import/model/flightcheck/finalizeflightmodel.dart';
import 'package:galaxy/module/import/model/flightcheck/maildetailmodel.dart';
import 'package:galaxy/module/import/model/flightcheck/recordatamodel.dart';

import '../../../model/flightcheck/awblistmodel.dart';
import '../../../model/flightcheck/flightchecksummarymodel.dart';
import '../../../model/flightcheck/flightcheckuldlistmodel.dart';
import '../../../model/flightcheck/mailtypemodel.dart';
import '../../../model/flightcheck/updateawbremarkacknoledge.dart';
import '../../../model/uldacceptance/buttonrolesrightsmodel.dart';
import '../../../model/uldacceptance/locationvalidationmodel.dart';



class FlightCheckState {}


class MainInitialState extends FlightCheckState {}
class MainLoadingState extends FlightCheckState {}



class ValidateLocationSuccessState extends FlightCheckState {
  final LocationValidationModel validateLocationModel;
  ValidateLocationSuccessState(this.validateLocationModel);
}

class ValidateLocationFailureState extends FlightCheckState {
  final String error;
  ValidateLocationFailureState(this.error);
}


class ButtonRolesAndRightsSuccessState extends FlightCheckState{
  final ButtonRolesRightsModel buttonRolesRightsModel;
  ButtonRolesAndRightsSuccessState(this.buttonRolesRightsModel);
}

class ButtonRolesAndRightsFailureState extends FlightCheckState{
  final String error;
  ButtonRolesAndRightsFailureState(this.error);
}



class FlightGetDetailsSuccessState extends FlightCheckState {
  final FlightCheckULDListModel flightCheckULDListModel;
  FlightGetDetailsSuccessState(this.flightCheckULDListModel);
}

class FlightGetDetailsFailureState extends FlightCheckState {
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

class RecordATASuccessState extends FlightCheckState {
  final RecordATAModel recordATAModel;
  RecordATASuccessState(this.recordATAModel);
}

class RecordATAFailureState extends FlightCheckState {
  final String error;
  RecordATAFailureState(this.error);
}

class FinalizeFlightSuccessState extends FlightCheckState {
  final FinalizeFlightModel finalizeFlightModel;
  FinalizeFlightSuccessState(this.finalizeFlightModel);
}

class FinalizeFlightFailureState extends FlightCheckState {
  final String error;
  FinalizeFlightFailureState(this.error);
}


class AWBListSuccessState extends FlightCheckState {
  final AWBModel aWBModel;
  AWBListSuccessState(this.aWBModel);
}

class AWBListFailureState extends FlightCheckState {
  final String error;
  AWBListFailureState(this.error);
}

class BDPriorityAWBSuccessState extends FlightCheckState {
  final BdPriorityModel bdPriorityModel;
  BDPriorityAWBSuccessState(this.bdPriorityModel);
}

class BDPriorityAWBFailureState extends FlightCheckState {
  final String error;
  BDPriorityAWBFailureState(this.error);
}

class AWBAcknoledgeSuccessState extends FlightCheckState {
  final AWBRemarkAcknoledgeModel awbRemarkAcknoledgeModel;
  AWBAcknoledgeSuccessState(this.awbRemarkAcknoledgeModel);
}

class AWBAcknoledgeFailureState extends FlightCheckState {
  final String error;
  AWBAcknoledgeFailureState(this.error);
}

class GetMailTypeSuccessState extends FlightCheckState {
  final MailTypeModel mailTypeModel;
  GetMailTypeSuccessState(this.mailTypeModel);
}

class GetMailTypeFailureState extends FlightCheckState {
  final String error;
  GetMailTypeFailureState(this.error);
}



class GetMailDetailSuccessState extends FlightCheckState {
  final MailDetailModel mailDetailModel;
  GetMailDetailSuccessState(this.mailDetailModel);
}

class GetMailDetailFailureState extends FlightCheckState {
  final String error;
  GetMailDetailFailureState(this.error);
}


class AddMailSuccessState extends FlightCheckState {
  final AddMailModel addMailModel;
  AddMailSuccessState(this.addMailModel);
}

class AddMAilFailureState extends FlightCheckState {
  final String error;
  AddMAilFailureState(this.error);
}


class CheckOAirportCitySuccessState extends FlightCheckState {
  final AirportCityModel airportCityModel;
  CheckOAirportCitySuccessState(this.airportCityModel);
}

class CheckOAirportCityFailureState extends FlightCheckState {
  final String error;
  CheckOAirportCityFailureState(this.error);
}

class CheckDAirportCitySuccessState extends FlightCheckState {
  final AirportCityModel airportCityModel;
  CheckDAirportCitySuccessState(this.airportCityModel);
}

class CheckDAirportCityFailureState extends FlightCheckState {
  final String error;
  CheckDAirportCityFailureState(this.error);
}