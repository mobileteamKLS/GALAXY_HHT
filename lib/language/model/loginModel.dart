class LoginModel {
  String? userId;
  String? password;
  String? mPin;
  String? login;
  String? loading;
  String? validatorUserId;
  String? validatorMpin;
  String? validatorPassword;
  String? validationBoundry;
  String? correctionMsgUserCredential;
  String? lockUserMsg;
  String? signInUserId;
  String? signInMPIN;
  String? or;
  String? dontHaveAnAccount;
  String? createOne;
  String? headingMessage1;
  String? headingMessage2;
  String? readThe;
  String? privacyPolicy;
  String? and;
  String? termsOfUse;
  String? recoverForgotPassword;


  LoginModel(
      {
        this.userId,
        this.password,
        this.mPin,
        this.login,
        this.loading,
        this.validatorUserId,
        this.validatorMpin,
        this.validatorPassword,
        this.correctionMsgUserCredential,
        this.validationBoundry,
        this.lockUserMsg,
        this.signInUserId,
        this.signInMPIN,
        this.or,
        this.dontHaveAnAccount,
        this.createOne,
        this.headingMessage1,
        this.headingMessage2,
        this.readThe,
        this.privacyPolicy,
        this.and,
        this.termsOfUse,
        this.recoverForgotPassword
      });

  LoginModel.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    password = json['password'];
    mPin = json['mPin'];
    login = json['login'];
    loading = json['loading'];
    validatorUserId = json['validatorUserId'];
    validatorMpin = json['validatorMpin'];
    validatorPassword = json['validatorPassword'];
    validationBoundry = json['validationBoundry'];
    correctionMsgUserCredential = json['correctionMsgUserCredential'];
    lockUserMsg = json['lockUserMsg'];
    signInUserId = json['signInUserId'];
    signInMPIN = json['signInMPIN'];
    or = json['or'];
    dontHaveAnAccount = json['dontHaveAnAccount'];
    createOne = json['createOne'];
    headingMessage1 = json['headingMessage1'];
    headingMessage2 = json['headingMessage2'];
    readThe = json['readThe'];
    privacyPolicy = json['privacyPolicy'];
    and = json['and'];
    termsOfUse = json['termsOfUse'];
    recoverForgotPassword = json['recoverForgotPassword'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userId'] = this.userId;
    data['password'] = this.password;
    data['mPin'] = this.mPin;
    data['login'] = this.login;
    data['loading'] = this.loading;
    data['validatorUserId'] = this.validatorUserId;
    data['validatorMpin'] = this.validatorMpin;
    data['validatorPassword'] = this.validatorPassword;
    data['validationBoundry'] = this.validationBoundry;

    data['correctionMsgUserCredential'] = this.correctionMsgUserCredential;
    data['lockUserMsg'] = this.lockUserMsg;
    data['signInUserId'] = this.signInUserId;
    data['signInMPIN'] = this.signInMPIN;
    data['or'] = this.or;
    data['dontHaveAnAccount'] = this.dontHaveAnAccount;
    data['createOne'] = this.createOne;
    data['headingMessage1'] = this.headingMessage1;
    data['headingMessage2'] = this.headingMessage2;
    data['readThe'] = this.readThe;
    data['privacyPolicy'] = this.privacyPolicy;
    data['and'] = this.and;
    data['termsOfUse'] = this.termsOfUse;
    data['recoverForgotPassword'] = this.recoverForgotPassword;
    return data;
  }



}
