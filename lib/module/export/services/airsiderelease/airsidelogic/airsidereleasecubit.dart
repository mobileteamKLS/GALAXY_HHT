
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





  void resetState() {
    emit(AirSideMainInitialState());
  }

}