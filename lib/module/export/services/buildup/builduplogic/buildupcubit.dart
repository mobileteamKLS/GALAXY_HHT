import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:galaxy/module/export/services/buildup/builduprepository.dart';

import 'buildupstate.dart';



class BuildUpCubit extends Cubit<BuildUpState>{
  BuildUpCubit() : super( BuildUpInitialState() );

  BuildUpRepository buildUpRepository = BuildUpRepository();

  // getValidateLocation api call repo
  Future<void> getValidateLocation(String locationCode, int userId, int companyCode, int menuId, String processCode) async {
    emit(BuildUpLoadingState());
    try {
      final validateLocationModelData = await buildUpRepository.locationValidate(locationCode, userId, companyCode, menuId, processCode);
      emit(ValidateLocationSuccessState(validateLocationModelData));
    } catch (e) {
      emit(ValidateLocationFailureState(e.toString()));
    }
  }

  Future<void> getFlightSearch(String flightNo, String flightDate, int userId, int companyCode, int menuId) async {
    emit(BuildUpLoadingState());
    try {
      final flightSearchModel = await buildUpRepository.getFlightSearch(flightNo, flightDate, userId, companyCode, menuId);

      emit(FlightSearchSuccessState(flightSearchModel));
    } catch (e) {
      emit(FlightSearchFailureState(e.toString()));
    }
  }

  Future<void> getULDTrolleySearchList(int flightSeqNo, String carrierCode, int userId, int companyCode, int menuId) async {
    emit(BuildUpLoadingState());
    try {
      final getULDTrolleySearchModelData = await buildUpRepository.getULDTrolleySearchList(flightSeqNo, carrierCode, userId, companyCode, menuId);
      emit(GetULDTrolleySearchSuccessState(getULDTrolleySearchModelData));
    } catch (e) {
      emit(GetULDTrolleySearchFailureState(e.toString()));
    }
  }

  Future<void> getULDTrolleyPriorityUpdate(int uldSeqNo, int priority, String uldType, int userId, int companyCode, int menuId) async {
    emit(BuildUpLoadingState());
    try {
      final uldTrolleyPriorityModelData = await buildUpRepository.uldTrolleyPriorityUpdate(uldSeqNo, priority, uldType,  userId, companyCode, menuId);
      emit(ULDTrolleyPrioritySuccessState(uldTrolleyPriorityModelData));
    } catch (e) {
      emit(ULDTrolleyPriorityFailureState(e.toString()));
    }
  }

  Future<void> getAddMailView(int flightSeqNo, int uldSeqNo, int userId, int companyCode, int menuId) async {
    emit(BuildUpLoadingState());
    try {
      final addMailViewModelData = await buildUpRepository.getAddMailView(flightSeqNo, uldSeqNo,  userId, companyCode, menuId);
      emit(AddMailViewSuccessState(addMailViewModelData));
    } catch (e) {
      emit(AddMailViewFailureState(e.toString()));
    }
  }

  Future<void> saveAddMail(
      int flightSeqNo, int uldSeqNo,
      String av7No, String mailType, String modeOfSecurity, String origin, String destination,
      int nop, double weight, String description,
      int userId, int companyCode, int menuId) async {
    emit(BuildUpLoadingState());
    try {
      final saveMailViewModelData = await buildUpRepository.saveMail(
          flightSeqNo, uldSeqNo, av7No, mailType, origin, destination, nop, weight, modeOfSecurity, description, userId, companyCode, menuId);
      emit(SaveMailViewSuccessState(saveMailViewModelData));
    } catch (e) {
      emit(SaveMailViewFailureState(e.toString()));
    }
  }

  Future<void> removeAddMail(int flightSeqNo, int MMSeqNo,
      int userId, int companyCode, int menuId) async {
    emit(BuildUpLoadingState());
    try {
      final saveMailViewModelData = await buildUpRepository.removeMail(
          flightSeqNo, MMSeqNo, userId, companyCode, menuId);
      emit(RemoveMailViewSuccessState(saveMailViewModelData));
    } catch (e) {
      emit(RemoveMailViewFailureState(e.toString()));
    }
  }

  Future<void> checkOAirportCity(String airportCity, int userId, int companyCode, int menuId) async {
    emit(BuildUpLoadingState());
    try {
      final airportCityModel = await buildUpRepository.checkAirportCity(airportCity, userId, companyCode, menuId);

      emit(BuildUpCheckOAirportCitySuccessState(airportCityModel));
    } catch (e) {
      emit(BuildUpCheckOAirportCityFailureState(e.toString()));
    }
  }

  Future<void> checkDAirportCity(String airportCity, int userId, int companyCode, int menuId) async {
    emit(BuildUpLoadingState());
    try {
      final airportCityModel = await buildUpRepository.checkAirportCity(airportCity, userId, companyCode, menuId);

      emit(BuildUpCheckDAirportCitySuccessState(airportCityModel));
    } catch (e) {
      emit(BuildUpCheckDAirportCityFailureState(e.toString()));
    }
  }

  Future<void> getContourList(int uldSeqNo, int userId, int companyCode, int menuId) async {
    emit(BuildUpLoadingState());
    try {
      final getContourModelData = await buildUpRepository.getContourList(uldSeqNo, userId, companyCode, menuId);
      emit(BuildUpGetContourListSuccessState(getContourModelData));
    } catch (e) {
      emit(BuildUpGetContourListFailureState(e.toString()));
    }
  }

  Future<void> getULDTrolleySave(
      int flightSeqNo,
      String uldType,
      String uldNumber,
      String uldOwner,
      String uldSpecification,
      String trolleyType,
      String trolleyNumber,
      double tareWeight,
      String contourCode,
      int contourHeight,
      int priority,
      String offPoint,
      String uldTrolleyType,
      int userId,
      int companyCode,
      int menuId) async {
    emit(BuildUpLoadingState());
    try {
      final getULDTrolleySaveModelData = await buildUpRepository.getULDTrolleySave(
          flightSeqNo,
          uldType,
          uldNumber,
          uldOwner,
          uldSpecification,
          trolleyType,
          trolleyNumber,
          tareWeight,
          contourCode,
          contourHeight,
          priority,
          offPoint,
          uldTrolleyType,
          userId, companyCode, menuId);
      emit(GetULDTrolleySaveSuccessState(getULDTrolleySaveModelData));
    } catch (e) {
      emit(GetULDTrolleySaveFailureState(e.toString()));
    }
  }


  Future<void> getAwbList(String carrierCode, int flightSeqNo, int userId, int companyCode, int menuId) async {
    emit(BuildUpLoadingState());
    try {
      final getAwbModelData = await buildUpRepository.getAwbDetailList(carrierCode, flightSeqNo, userId, companyCode, menuId);
      emit(BuildUpAWBDetailSuccessState(getAwbModelData));
    } catch (e) {
      emit(BuildUpAWBDetailFailureState(e.toString()));
    }
  }

  Future<void> getAWBPriorityUpdate(int expRowId, int priority, int userId, int companyCode, int menuId) async {
    emit(BuildUpLoadingState());
    try {
      final awbPriorityModelData = await buildUpRepository.awbPriorityUpdate(expRowId, priority, userId, companyCode, menuId);
      emit(AWBPrioritySuccessState(awbPriorityModelData));
    } catch (e) {
      emit(AWBPriorityFailureState(e.toString()));
    }
  }

  Future<void> getAWBAcknowledge(int expRowId, int expShipRowId, int userId, int companyCode, int menuId) async {
    emit(BuildUpLoadingState());
    try {
      final awbAcknowledgeModelData = await buildUpRepository.awbAcknowledgeUpdate(expRowId, expShipRowId, userId, companyCode, menuId);
      emit(AWBAcknowledgeSuccessState(awbAcknowledgeModelData));
    } catch (e) {
      emit(AWBAcknowledgeFailureState(e.toString()));
    }
  }


  Future<void> getGroupList(String awbNumber, String awbprefix, int awbExpAwbRowId, int userId, int companyCode, int menuId) async {
    emit(BuildUpLoadingState());
    try {
      final getGroupModelData = await buildUpRepository.getGroupDetailList(awbNumber, awbprefix, awbExpAwbRowId, userId, companyCode, menuId);
      emit(BuildUpGroupDetailSuccessState(getGroupModelData));
    } catch (e) {
      emit(BuildUpGroupDetailFailureState(e.toString()));
    }
  }


  Future<void> shcCodeValidate(String shcCode, int userId, int companyCode, int menuId) async {
    emit(BuildUpLoadingState());
    try {
      final shcCodeValidate = await buildUpRepository.shcValidateCode(shcCode, userId, companyCode, menuId);
      emit(SHCValidateSuccessState(shcCodeValidate));
    } catch (e) {
      emit(SHCValidateFailureState(e.toString()));
    }
  }

  Future<void> addShipment(
      int flightSeqNo, int awbRowID, int awbShipmentId, int ULDSeqNo,
      String awbPrefix, String aWBNumber,
      int nop, double weight, String offPoint, String SHC,
      String IsPartShipment, String DGIndicator, String ULDTrolleyType,
      String dgType, int dgSeqNo, String dgReference, int groupId, String warningInd, String shcWarning,
      int userId, int companyCode, int menuId) async {
    emit(BuildUpLoadingState());
    try {
      final addShipment = await buildUpRepository.addShipment(
          flightSeqNo, awbRowID, awbShipmentId, ULDSeqNo,
          awbPrefix, aWBNumber,
          nop, weight, offPoint, SHC,
          IsPartShipment, DGIndicator, ULDTrolleyType,
          dgType, dgSeqNo, dgReference, groupId, warningInd, shcWarning,
          userId, companyCode, menuId);
      emit(AddShipmentSuccessState(addShipment));
    } catch (e) {
      emit(AddShipmentFailureState(e.toString()));
    }
  }



  void resetState() {
    emit(BuildUpInitialState());
  }

}