

import '../../model/splashdefaultmodel.dart';

abstract class SplashState {}

class SplashInitial extends SplashState {}

class SplashLoading extends SplashState {}

class SplashLoaded extends SplashState {
  final SplashDefaultModel splashDefaultModel;

  SplashLoaded(this.splashDefaultModel);
}

class SplashError extends SplashState {
  final String message;

  SplashError(this.message);
}