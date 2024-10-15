


import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:galaxy/module/login/services/loginrepository.dart';

import '../../../../prefrence/savedprefrence.dart';
import 'loginstate.dart';

class LoginCubit extends Cubit<LoginState>{
  LoginCubit() : super( LoginInitial() );

  LoginRepository loginRepository = LoginRepository();
  final SavedPrefrence savedPrefrence = SavedPrefrence();


  Future<void> accessToken() async {
    emit(LoginLoading());
    try {
      await loginRepository.accessToken();
      emit(LoginLoading());
    } catch (e) {
      emit(LoginFailure(e.toString()));
    }
  }


  Future<void> login(String userId, String password, String authFlg, int companyCode) async {
    emit(LoginLoading());
    try {
     // await accessToken();
      final userData = await loginRepository.login(userId, password, authFlg, companyCode);

      emit(LoginSuccess(userData));
    } catch (e) {
      emit(LoginFailure(e.toString()));
    }
  }

  Future<void> loginActivate(String userId, String password, String authFlg, int companyCode) async {
    emit(LoginLoading());
    try {
      // await accessToken();
      final userData = await loginRepository.login(userId, password, authFlg, companyCode);

      emit(LoginActivateSuccess(userData));
    } catch (e) {
      emit(LoginActivateFailure(e.toString()));
    }
  }




}