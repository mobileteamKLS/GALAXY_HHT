import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:galaxy/module/discrypency/services/damageduld/damageduldlogic/damageduldstate.dart';
import 'package:galaxy/module/export/services/offload/offloadlogic/offloadstate.dart';
import 'package:galaxy/module/export/services/offload/offloadrepository.dart';

import '../damageduldrepository.dart';



class DamagedULDCubit extends Cubit<DamagedULDState>{
  DamagedULDCubit() : super( DamagedULDInitialState() );

  DamagedULDRepository damagedULDRepository = DamagedULDRepository();

  Future<void> getSearchDamagedULD(String scan, int userId, int companyCode, int menuId) async {
    emit(DamagedULDLoadingState());
    try {
      final damagedULDSearchModelData = await damagedULDRepository.getSearchDamagedULD(
          scan, userId, companyCode, menuId);
      emit(GetDamagedULDSearchSuccessState(damagedULDSearchModelData));
    } catch (e) {
      emit(GetDamagedULDSearchFailureState(e.toString()));
    }
  }


  void resetState() {
    emit(DamagedULDInitialState());
  }

}