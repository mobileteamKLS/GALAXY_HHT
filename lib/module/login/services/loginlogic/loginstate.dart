
import 'package:galaxy/module/login/model/userlogindatamodel.dart';

class LoginState {}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class LoginSuccess extends LoginState {
  final UserDataModel userDataModel;
  LoginSuccess(this.userDataModel);
}

class LoginFailure extends LoginState {
  final String error;
  LoginFailure(this.error);
}


class LoginActivateSuccess extends LoginState {
  final UserDataModel userDataModel;
  LoginActivateSuccess(this.userDataModel);
}

class LoginActivateFailure extends LoginState {
  final String error;
  LoginActivateFailure(this.error);
}