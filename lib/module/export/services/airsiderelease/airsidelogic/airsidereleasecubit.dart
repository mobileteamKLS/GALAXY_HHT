
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:galaxy/module/export/services/airsiderelease/airsidereleaserepository.dart';

import 'airsidereleasestate.dart';


class AirSideReleaseCubit extends Cubit<AirSideReleaseState>{
  AirSideReleaseCubit() : super( AirSideMainInitialState() );

  AirSideReleaseRepository airSideReleaseRepository = AirSideReleaseRepository();

  // pageLoad api call repo
  Future<void> getPageLoad(int userId, int companyCode, int menuId) async {
    emit(AirSideMainLoadingState());
    try {
      final pageLoadModelData = await airSideReleaseRepository.airsidePageLoad(userId, companyCode, menuId);
      emit(AirsideReleasePageLoadSuccessState(pageLoadModelData));
    } catch (e) {
      emit(AirsideReleasePageLoadFailureState(e.toString()));
    }
  }

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

  Future<void> airsideSignUpload(int flightSeqNo, int uldSeqNo, String gatePassNo, String desigType, String image, int userId, int companyCode, int menuId) async {
    emit(AirSideMainLoadingState());
    try {
      final airsideSignUploadModel = await airSideReleaseRepository.airsideSignUpload(flightSeqNo, uldSeqNo, gatePassNo, desigType,image, userId, companyCode, menuId);

      emit(AirsideSignUploadSuccesState(airsideSignUploadModel));
    } catch (e) {
      emit(AirsideSignUploadFailureState(e.toString()));
    }
  }

  Future<void> airsideReleaseBatteryUpdate(int uldSeqNo, int batteryStrength, int userId, int companyCode, int menuId) async {
    emit(AirSideMainLoadingState());
    try {
      final airsideReleaseBatteryUpdateModel = await airSideReleaseRepository.airsideReleaseBatteryUpdate(uldSeqNo, batteryStrength, userId, companyCode, menuId);

      emit(AirsideReleaseBatteryUpdateSuccessState(airsideReleaseBatteryUpdateModel));
    } catch (e) {
      emit(AirsideReleaseBatteryUpdateFailureState(e.toString()));
    }
  }

  Future<void> airsideReleaseTempUpdate(int uldSeqNo, int tempreature, String tempUnit, int userId, int companyCode, int menuId) async {
    emit(AirSideMainLoadingState());
    try {
      final airsideReleaseTempUpdateModel = await airSideReleaseRepository.airsideReleaseTempUpdate(uldSeqNo, tempreature, tempUnit, userId, companyCode, menuId);

      emit(AirsideReleaseTempUpdateSuccessState(airsideReleaseTempUpdateModel));
    } catch (e) {
      emit(AirsideReleaseTempUpdateFailureState(e.toString()));
    }
  }


  void resetState() {
    emit(AirSideMainInitialState());
  }

}