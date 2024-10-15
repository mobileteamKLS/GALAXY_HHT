class ValidationMsgState {}

class ValidationMsgInitial extends ValidationMsgState {}

class ValidationMsgLoading extends ValidationMsgState {}

class ValidationMsgSuccess extends ValidationMsgState {
  final Map<String, String> validationMessages;
  ValidationMsgSuccess(this.validationMessages);
}

class ValidationMsgFailure extends ValidationMsgState {
  final String error;
  ValidationMsgFailure(this.error);
}