
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:galaxy/module/export/services/uldtould/uldtouldlogic/uldtouldstate.dart';
import 'package:galaxy/module/export/services/uldtould/uldtouldrepository.dart';




class ULDToULDCubit extends Cubit<ULDToULDState>{
  ULDToULDCubit() : super( ULDToULDStateInitialState() );

  ULDToULDRepository uldToULDRepository = ULDToULDRepository();

  // sourceULD api call repo
  Future<void> sourceULD(String scanNo, int userId, int companyCode, int menuId) async {
    emit(ULDToULDStateLoadingState());
    try {
      final sourceULDModelData = await uldToULDRepository.sourceULDLoad(scanNo, userId, companyCode, menuId);
      emit(SourceULDLoadSuccessState(sourceULDModelData));
    } catch (e) {
      emit(SourceULDLoadFailureState(e.toString()));
    }
  }

  // targetULD api call repo
  Future<void> targetULD(String scanNo, int userId, int companyCode, int menuId) async {
    emit(ULDToULDStateLoadingState());
    try {
      final targetULDModelData = await uldToULDRepository.targetULDLoad(scanNo, userId, companyCode, menuId);
      emit(TargetULDLoadSuccessState(targetULDModelData));
    } catch (e) {
      emit(TargetULDLoadFailureState(e.toString()));
    }
  }

  // targetULD api call repo
  Future<void> moveULD(int sourceFlightSeqNo, int sourceULDSeqNo, String sourceULDType, int targetFlightSeqNo, int targetULDSeqNo, String targetULDType, int userId, int companyCode, int menuId) async {
    emit(ULDToULDStateLoadingState());
    try {
      final moveULDModelData = await uldToULDRepository.moveULDLoad(sourceFlightSeqNo, sourceULDSeqNo, sourceULDType, targetFlightSeqNo, targetULDSeqNo, targetULDType, userId, companyCode, menuId);
      emit(MoveULDLoadSuccessState(moveULDModelData));
    } catch (e) {
      emit(MoveULDLoadFailureState(e.toString()));
    }
  }

  void resetState() {
    emit(ULDToULDStateInitialState());
  }

}