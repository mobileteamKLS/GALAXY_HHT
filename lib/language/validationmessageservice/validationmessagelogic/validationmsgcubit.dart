


import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:galaxy/language/validationmessageservice/validationmessagelogic/validationmsgstate.dart';
import 'package:galaxy/language/validationmessageservice/validationmsgrepository.dart';

import '../../../prefrence/savedprefrence.dart';



class ValidationMsgCubit extends Cubit<ValidationMsgState>{
  ValidationMsgCubit() : super( ValidationMsgInitial() );

  ValidationMsgRepository validationMsgRepository = ValidationMsgRepository();
  final SavedPrefrence savedPrefrence = SavedPrefrence();


  Future<void> validationMessage(String menuCode, String languageCode, int companyCode) async {
    emit(ValidationMsgLoading());
    try {
      final validationData = await validationMsgRepository.validationMessage(menuCode, languageCode, companyCode);

      Map<String, String> validationMessages = {};
      if (validationData.cultureMessage != null) {
        for (var message in validationData.cultureMessage!) {
          validationMessages[message.messageCode!] = message.message!;
        }
      }

      emit(ValidationMsgSuccess(validationMessages));
    } catch (e) {
      emit(ValidationMsgFailure(e.toString()));
    }
  }
}