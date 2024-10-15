


import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:galaxy/module/dashboard/service/menuLogic/menustate.dart';
import 'package:galaxy/module/dashboard/service/menurepository.dart';

import '../../../../prefrence/savedprefrence.dart';


class MenuCubit extends Cubit<MenuState>{
  MenuCubit() : super( MenuStateInitial() );

  MenuRepository menuRepository = MenuRepository();
  final SavedPrefrence savedPrefrence = SavedPrefrence();

  Future<void> menuModelData(int userId, String userGroup, int companyCode) async {
    emit(MenuStateLoading());
    try {
      final menuModelData = await menuRepository.menuModelData(userId, userGroup, companyCode);

      emit(MenuStateSuccess(menuModelData));
    } catch (e) {
      emit(MenuStateFailure(e.toString()));
    }
  }
}