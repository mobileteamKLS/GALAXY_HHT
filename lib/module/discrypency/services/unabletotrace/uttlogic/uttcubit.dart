import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:galaxy/module/discrypency/services/unabletotrace/uttlogic/uttstate.dart';
import '../unabletotracerepository.dart';



class UTTCubit extends Cubit<UTTState>{
  UTTCubit() : super( UTTInitialState() );

  UnableToTraceRepository unableToTraceRepository = UnableToTraceRepository();


  Future<void> getUTTSearchRecord(String scan, String scanType, String moduleType, int userId, int companyCode, int menuId) async {
    emit(UTTLoadingState());
    try {
      final uTTSearchModelData = await unableToTraceRepository.getUTTSearchRecord(scan, scanType, moduleType, userId, companyCode, menuId);
      emit(GetUTTSearchSuccessState(uTTSearchModelData));
    } catch (e) {
      emit(GetUTTSearchFailureState(e.toString()));
    }
  }


  Future<void> uttRecordUpdate(
      String uttType,
      int seqNo,
      int nop,
      double weight,
      String moduleType, int userId, int companyCode, int menuId) async {
    emit(UTTLoadingState());
    try {
      final recordUpdate = await unableToTraceRepository.UTTRecordUpdate(uttType, seqNo, nop, weight, moduleType, userId, companyCode, menuId);
      emit(RecordUpdateSuccessState(recordUpdate));
    } catch (e) {
      emit(RecordUpdateFailureState(e.toString()));
    }
  }

  Future<void> uttRecordUpdateDirect(
      String uttType,
      int seqNo,
      int nop,
      double weight,
      String moduleType, int userId, int companyCode, int menuId) async {
    emit(UTTLoadingState());
    try {
      final recordUpdate = await unableToTraceRepository.UTTRecordUpdate(uttType, seqNo, nop, weight, moduleType, userId, companyCode, menuId);
      emit(RecordUpdateDSuccessState(recordUpdate));
    } catch (e) {
      emit(RecordUpdateDFailureState(e.toString()));
    }
  }



  void resetState() {
    emit(UTTInitialState());
  }

}