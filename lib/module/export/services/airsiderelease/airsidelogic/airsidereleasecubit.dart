
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:galaxy/module/export/services/airsiderelease/airsidereleaserepository.dart';

import 'airsidereleasestate.dart';


class AirSideReleaseCubit extends Cubit<AirSideReleaseState>{
  AirSideReleaseCubit() : super( AirSideMainInitialState() );

  AirSideReleaseRepository airSideReleaseRepository = AirSideReleaseRepository();


// getValidateLocation api call repo
  Future<void> getValidateLocation(String locationCode, int userId, int companyCode, int menuId, String processCode) async {
    emit(AirSideMainLoadingState());
    try {
      final validateLocationModelData = await airSideReleaseRepository.locationValidate(locationCode, userId, companyCode, menuId, processCode);
      emit(ValidateLocationSuccessState(validateLocationModelData));
    } catch (e) {
      emit(ValidateLocationFailureState(e.toString()));
    }
  }

  // getAirsideRelease api call repo
  Future<void> getAirsideRelease(String locationCode, String scanNumber, int userId, int companyCode, int menuId) async {
    emit(AirSideMainLoadingState());
    try {
      final airSideReleaseSearchModel = await airSideReleaseRepository.getAirsideRelease(locationCode, scanNumber, userId, companyCode, menuId);
      emit(AirsideReleaseSuccessState(airSideReleaseSearchModel));
    } catch (e) {
      emit(AirsideReleaseFailureState(e.toString()));
    }
  }

  Future<void> getAirsideShipmentList(int flightSeqNo, int uldSeqNo, String ULDType, int userId, int companyCode, int menuId) async {
    emit(AirSideMainLoadingState());
    try {
      final airsideShipmentListModelData = await airSideReleaseRepository.getListOfAirsideAwb(flightSeqNo, uldSeqNo, ULDType, userId, companyCode, menuId);

      emit(AirsideShipmentListSuccessState(airsideShipmentListModelData));
    } catch (e) {
      emit(AirsideShipmentListFailureState(e.toString()));
    }
  }


  Future<void> releaseULDorTrolley(String doorNo, String gatePassNo, int flightSeqNo, int uldSeqNo, String ULDType, int userId, int companyCode, int menuId) async {
    emit(AirSideMainLoadingState());
    try {
      final airsideReleaseDataModel = await airSideReleaseRepository.releaseULDorTrolley(doorNo, gatePassNo, flightSeqNo, uldSeqNo, ULDType, userId, companyCode, menuId);

      emit(AirsideReleaseDataSuccessState(airsideReleaseDataModel));
    } catch (e) {
      emit(AirsideReleaseDataFailureState(e.toString()));
    }
  }

  Future<void> airsideReleasePriorityUpdate(int SeqNo, int priority, String Mode, int userId, int companyCode, int menuId) async {
    emit(AirSideMainLoadingState());
    try {
      final airsideReleasePriorityUpdateModel = await airSideReleaseRepository.airsideReleasePriorityUpdate(SeqNo, priority, Mode, userId, companyCode, menuId);

      emit(AirsideReleasePriorityUpdateSuccessState(airsideReleasePriorityUpdateModel));
    } catch (e) {
      emit(AirsideReleasePriorityUpdateFailureState(e.toString()));
    }
  }


  void resetState() {
    emit(AirSideMainInitialState());
  }

}