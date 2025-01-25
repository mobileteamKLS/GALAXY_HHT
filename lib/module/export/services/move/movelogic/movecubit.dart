import 'package:flutter_bloc/flutter_bloc.dart';

import '../moverepository.dart';
import 'movestate.dart';


class MoveCubit extends Cubit<MoveState>{
  MoveCubit() : super( MoveInitialState() );

  MoveRepository moveRepository = MoveRepository();

  Future<void> getMoveSearch(
      String scanNo,
      String scanType,
      int containerItemCount,
      String containerItemType,
      int userId,
      int companyCode,
      int menuId) async {
    emit(MoveLoadingState());
    try {
      final getMoveSearchModelData = await moveRepository.getMoveSearch(
          scanNo,scanType,containerItemCount,containerItemType,
          userId,
          companyCode,
          menuId);
      emit(GetMoveSearchSuccessState(getMoveSearchModelData));
    } catch (e) {
      emit(GetMoveSearchFailureState(e.toString()));
    }
  }

  Future<void> moveLocation(
      String selectedType,
      String locationCode,
      String moveXml,
      int userId,
      int companyCode,
      int menuId) async {
    emit(MoveLoadingState());
    try {
      final getULDTrolleySaveModelData = await moveRepository.moveLocationUpdate(
          selectedType,
          locationCode,
          moveXml,
          userId,
          companyCode,
          menuId);
      emit(MoveLocationSuccessState(getULDTrolleySaveModelData));
    } catch (e) {
      emit(MoveLocationFailureState(e.toString()));
    }
  }


  Future<void> addShipment(
      int flightSeqNo, int awbRowID, int awbShipmentId, int ULDSeqNo,
      String awbPrefix, String aWBNumber,
      int nop, double weight, String offPoint, String SHC,
      String IsPartShipment, String DGIndicator, String ULDTrolleyType,
      String dgType, int dgSeqNo, String dgReference, int groupId, String warningInd, String shcWarning,
      String carrierCode,
      int userId, int companyCode, int menuId) async {
    emit(MoveLoadingState());
    try {
      final addShipment = await moveRepository.addShipment(
          flightSeqNo, awbRowID, awbShipmentId, ULDSeqNo,
          awbPrefix, aWBNumber,
          nop, weight, offPoint, SHC,
          IsPartShipment, DGIndicator, ULDTrolleyType,
          dgType, dgSeqNo, dgReference, groupId, warningInd, shcWarning,
          carrierCode,
          userId, companyCode, menuId);
      emit(AddShipmentMoveSuccessState(addShipment));
    } catch (e) {
      emit(AddShipmentMoveFailureState(e.toString()));
    }
  }


  Future<void> removeMovement(
      int sequenceNo,
      String type,
      int userId,
      int companyCode,
      int menuId) async {
    emit(MoveLoadingState());
    try {
      final removeMovementModelData = await moveRepository.removeMovement(
          sequenceNo,type,
          userId,
          companyCode,
          menuId);
      emit(RemoveMovementSuccessState(removeMovementModelData));
    } catch (e) {
      emit(RemoveMovementFailureState(e.toString()));
    }
  }







  void resetState() {
    emit(MoveInitialState());
  }

}