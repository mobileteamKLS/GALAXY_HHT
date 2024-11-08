import 'package:flutter_bloc/flutter_bloc.dart';

import '../binningrepository.dart';
import 'binningstate.dart';

class BinningCubit extends Cubit<BinningState>{
  BinningCubit() : super( MainInitialState() );

  BinningRepository binningRepository = BinningRepository();


// binning api call repo
  Future<void> getBinningDetailListApi(String groupId, int userId, int companyCode, int menuId) async {
     emit(MainLoadingState());
    try {
      final binningDetailListModel = await binningRepository.getBinningDetailListModel(groupId, userId, companyCode, menuId);
      emit(BinningDetailListSuccessState(binningDetailListModel));
    } catch (e) {
      emit(BinningDetailListFailureState(e.toString()));
    }
  }



  void resetState() {
    emit(MainInitialState());
  }

}