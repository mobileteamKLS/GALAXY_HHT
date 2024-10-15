import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:galaxy/module/submenu/service/subMenuLogic/submenustate.dart';
import '../submenurepository.dart';

class SubMenuCubit extends Cubit<SubMenuState>{
  SubMenuCubit() : super( SubMenuStateInitial() );

  SubMenuRepository subMenuRepository = SubMenuRepository();

  Future<void> subMenuModelData(int userId, String userGroup, String menuId, int companyCode) async {
    emit(SubMenuStateLoading());
    try {
      final menuModelData = await subMenuRepository.subMenuModelData(userId, userGroup, menuId, companyCode);

      emit(SubMenuStateSuccess(menuModelData));
    } catch (e) {
      emit(SubMenuStateFailure(e.toString()));
    }
  }
}