


import 'package:galaxy/module/dashboard/model/menumodel.dart';

class MenuState {}

class MenuStateInitial extends MenuState {}

class MenuStateLoading extends MenuState {}

class MenuStateSuccess extends MenuState {
  final MenuModel menuModel;
  MenuStateSuccess(this.menuModel);
}

class MenuStateFailure extends MenuState {
  final String error;
  MenuStateFailure(this.error);
}