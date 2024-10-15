import 'package:flutter_bloc/flutter_bloc.dart';

import '../splashrepository.dart';
import 'splashstate.dart';

class SplashCubit extends Cubit<SplashState> {
  final SplashRepository splashRepository;

  SplashCubit(this.splashRepository) : super(SplashInitial());

  Future<void> getDefaultPageLoad(String airportCode) async {
    try {
      emit(SplashLoading());
      final splashDefaultModel = await splashRepository.getDefaultPageLoad(airportCode);
      emit(SplashLoaded(splashDefaultModel));
    } catch (e) {
      emit(SplashError(e.toString()));
    }
  }
}