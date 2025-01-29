import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:galaxy/module/discrypency/services/deactiveuld/deactiveuldlogic/deactiveduldstate.dart';
import 'package:galaxy/module/discrypency/services/deactiveuld/deactiveuldrepository.dart';



class DeactiveULDCubit extends Cubit<DeactiveULDState>{
  DeactiveULDCubit() : super( DeactiveULDInitialState() );

  DeactiveULDRepository deactiveULDRepository = DeactiveULDRepository();

  Future<void> getSearchDamagedULD(String scan, int userId, int companyCode, int menuId) async {
    emit(DeactiveULDLoadingState());
    try {
      final deactiveULDSearchModelData = await deactiveULDRepository.getSearchULD(
          scan, userId, companyCode, menuId);
      emit(GetDeactiveULDSearchSuccessState(deactiveULDSearchModelData));
    } catch (e) {
      emit(GetDeactiveULDSearchFailureState(e.toString()));
    }
  }

  Future<void> getULDDeactivate(
      int uldSeqNo,
      int flightSeqNo, int userId, int companyCode, int menuId) async {
    emit(DeactiveULDLoadingState());
    try {
      final deactiveULDModelData = await deactiveULDRepository.recordDeactivate(
          uldSeqNo, flightSeqNo, userId, companyCode, menuId);
      emit(GetDeactiveSuccessState(deactiveULDModelData));
    } catch (e) {
      emit(GetDeactiveFailureState(e.toString()));
    }
  }

  void resetState() {
    emit(DeactiveULDInitialState());
  }

}