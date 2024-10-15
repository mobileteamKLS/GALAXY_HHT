import '../../model/submenumodel.dart';

class SubMenuState {}

class SubMenuStateInitial extends SubMenuState {}

class SubMenuStateLoading extends SubMenuState {}

class SubMenuStateSuccess extends SubMenuState {
  final SubMenuModel subMenuModel;
  SubMenuStateSuccess(this.subMenuModel);
}

class SubMenuStateFailure extends SubMenuState {
  final String error;
  SubMenuStateFailure(this.error);
}