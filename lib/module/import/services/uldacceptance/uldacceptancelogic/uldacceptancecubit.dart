
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:galaxy/module/import/services/uldacceptance/uldacceptancelogic/uldacceptancestate.dart';

import '../uldacceptancerepository.dart';

class UldAcceptanceCubit extends Cubit<UldAcceptanceState>{
  UldAcceptanceCubit() : super( MainInitialState() );

  UldAcceptanceRepository uldAcceptanceRepository = UldAcceptanceRepository();

// getDefaultUldAcceptance api call repo
  Future<void> getDefaultUldAcceptance(String menuCode, int userId, int companyCode, int menuId) async {
    emit(MainLoadingState());
    try {
      final defaultUldAcceptanceModelData = await uldAcceptanceRepository.getDefaulfUldAcceptance(menuCode, userId, companyCode, menuId);
      emit(DefaultUldAcceptanceSuccessState(defaultUldAcceptanceModelData));
    } catch (e) {
      emit(DefaultUldAcceptanceFailureState(e.toString()));
    }
  }

  // getButtonsRoles & Rights api call repo
  Future<void> getButtonRolesAndRights(int menuId, int userId, int companyCode) async {
    emit(MainLoadingState());
    try {
      final getButtonRolesAndRightsModelData = await uldAcceptanceRepository.getButtonRolesAndRights(menuId, userId, companyCode);
      emit(ButtonRolesAndRightsSuccessState(getButtonRolesAndRightsModelData));
    } catch (e) {
      emit(ButtonRolesAndRightsFailureState(e.toString()));
    }
  }



// getValidateLocation api call repo
  Future<void> getValidateLocation(String locationCode, int userId, int companyCode, int menuId, String processCode) async {
   // emit(MainLoadingState());
    try {
      final validateLocationModelData = await uldAcceptanceRepository.locationValidate(locationCode, userId, companyCode, menuId, processCode);
      emit(ValidateLocationSuccessState(validateLocationModelData));
    } catch (e) {
      emit(ValidateLocationFailureState(e.toString()));
    }
  }

// getUldAcceptanceList api call repo
  Future<void> getUldAcceptanceList(int userId, int companyCode, String flightNo, String flightDate, String scanFlight, int menuId) async {
    emit(MainLoadingState());
    try {
      final UldAcceptanceDetailModelData = await uldAcceptanceRepository.getUldAcceptanceList(userId, companyCode, flightNo, flightDate, scanFlight, menuId);

      emit(UldacceptanceListSuccessState(UldAcceptanceDetailModelData));
    } catch (e) {
      emit(UldacceptanceListFailureState(e.toString()));
    }
  }

  // uldAccept api call repo
  Future<void> uldAccept(int flightSeqNo, int ULDSeqNo, String ULDNo, String locationCode, String groupId, int userId, int companyCode, int menuId) async {
    emit(MainLoadingState());
    try {
      final uldAcceptModelData = await uldAcceptanceRepository.uldAcceptance(flightSeqNo, ULDSeqNo, ULDNo, locationCode, groupId, userId, companyCode, menuId);

      emit(UldAcceptSuccessState(uldAcceptModelData));
    } catch (e) {
      emit(UldAcceptFailureState(e.toString()));
    }
  }


// trollyAccept api call repo
  Future<void> trollyAccept(int flightSeqNo, String flightNo, String flightDate, String locationCode, String groupId, String trollyType, String trollyNo, int btnFlag, int userId, int companyCode, int menuId) async {
    emit(MainLoadingState());
    try {
      final uldAcceptModelData = await uldAcceptanceRepository.trollyAcceptance(flightSeqNo, flightNo, flightDate, locationCode, groupId, trollyType, trollyNo, btnFlag, userId, companyCode, menuId );

      emit(TrollyAcceptSuccessState(uldAcceptModelData));
    } catch (e) {
      emit(TrollyAcceptFailureState(e.toString()));
    }
  }


  // uldDamageServiceList api call repo
  Future<void> uldDamageServiceList(int userId, int companyCode, int menuId) async {
    emit(MainLoadingState());
    try {
      final uldDamageListModel = await uldAcceptanceRepository.uldDamageServiceList(userId, companyCode, menuId);

      emit(UldDamageListSuccessState(uldDamageListModel));
    } catch (e) {
      emit(UldDamageListFailureState(e.toString()));
    }
  }


  // uldDamage api call repo
  Future<void> uldDamage(String flightType, String ULDNo,int ULDSeqNo, int flightSeqNo, String groupId, String conditionCode, String typeOfDamage, String images, String remarks, int userId, int companyCode, String menuCode, int menuId) async {
    emit(MainLoadingState());
    try {
      final uldAcceptModelData = await uldAcceptanceRepository.uldDamage(flightType, ULDNo, ULDSeqNo, flightSeqNo, groupId, conditionCode, typeOfDamage, images, remarks, userId, companyCode, menuCode, menuId);

      emit(UldDamageSuccessState(uldAcceptModelData));
    } catch (e) {
      emit(UldDamageFailureState(e.toString()));
    }
  }

  Future<void> uldDamageAccept(int flightSeqNo, int ULDSeqNo, String ULDNo, String locationCode, String groupId, int userId, int companyCode, int menuId) async {
    emit(MainLoadingState());
    try {
      final uldAcceptModelData = await uldAcceptanceRepository.uldAcceptance(flightSeqNo, ULDSeqNo, ULDNo, locationCode, groupId, userId, companyCode , menuId);

      emit(UldDamageAcceptSuccessState(uldAcceptModelData));
    } catch (e) {
      emit(UldDamageAcceptFailureState(e.toString()));
    }
  }

  Future<void> uldDamageUpdate(int ULDSeqNo, int userId, int companyCode, int menuId) async {
    emit(MainLoadingState());
    try {
      final uldDamageUpdateModelData = await uldAcceptanceRepository.uldDamageUpdate(ULDSeqNo, userId, companyCode, menuId);
      emit(UldDamageUpdateSuccessState(uldDamageUpdateModelData));
    } catch (e) {
      emit(UldDamageUpdateFailureState(e.toString()));
    }
  }

  Future<void> getFlightFromULD(String uldNo, int userId, int companyCode, int menuId) async {
    emit(MainLoadingState());
    try {
      final flightFromULDModel = await uldAcceptanceRepository.getFlightFromUld(uldNo, userId, companyCode, menuId);
      emit(FlightFromULDSuccessState(flightFromULDModel));
    } catch (e) {
      emit(FlightFromULDFailureState(e.toString()));
    }
  }


  // uld create api call repo
  Future<void> uldUCR(String UCRNo, String ULDNumber, String curruntULDOwner, String locationCode, String groupId, int userId, int companyCode, int menuId) async {
    emit(MainLoadingState());
    try {
      final uldUCRModelData = await uldAcceptanceRepository.uldUCR(UCRNo, ULDNumber, curruntULDOwner, locationCode, groupId, userId, companyCode, menuId);

      emit(UldUCRSuccessState(uldUCRModelData));
    } catch (e) {
      emit(UldUCRFailureState(e.toString()));
    }
  }


  // uldDamage api call repo
  Future<void> uldUCRDamage(String flightType, String ULDNo,int ULDSeqNo, int flightSeqNo, String groupId, String conditionCode, String typeOfDamage, String images, String remarks, int userId, int companyCode, String menuCode, int menuId) async {
    emit(MainLoadingState());
    try {
      final uldAcceptModelData = await uldAcceptanceRepository.uldUCRDamage(flightType, ULDNo, ULDSeqNo, flightSeqNo, groupId, conditionCode, typeOfDamage, images, remarks, userId, companyCode, menuCode, menuId);
      emit(UldUCRDamageSuccessState(uldAcceptModelData));
    } catch (e) {
      emit(UldUCRDamageFailureState(e.toString()));
    }
  }

  void resetState() {
    emit(MainInitialState());
  }

}