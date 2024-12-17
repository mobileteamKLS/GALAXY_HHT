import 'package:galaxy/module/export/model/retriveuld/addtolistmodel.dart';

import '../../../../import/model/uldacceptance/locationvalidationmodel.dart';
import '../../../model/retriveuld/retriveulddetailmodel.dart';
import '../../../model/retriveuld/retriveuldlistmodel.dart';
import '../../../model/retriveuld/retriveuldloadmodel.dart';



class RetriveULDState {}


class RetriveULDInitialState extends RetriveULDState {}
class RetriveULDLoadingState extends RetriveULDState {}

class RetriveULDPageLoadSuccessState extends RetriveULDState {
  final RetriveULDPageLoadModel retriveULDPageLoadModel;
  RetriveULDPageLoadSuccessState(this.retriveULDPageLoadModel);
}

class RetriveULDPageLoadFailureState extends RetriveULDState {
  final String error;
  RetriveULDPageLoadFailureState(this.error);
}

class ValidateLocationSuccessState extends RetriveULDState {
  final LocationValidationModel validateLocationModel;
  ValidateLocationSuccessState(this.validateLocationModel);
}

class ValidateLocationFailureState extends RetriveULDState {
  final String error;
  ValidateLocationFailureState(this.error);
}

class RetriveULDDetailSuccessState extends RetriveULDState {
  final RetriveULDDetailLoadModel retriveULDDetailLoadModel;
  RetriveULDDetailSuccessState(this.retriveULDDetailLoadModel);
}

class RetriveULDDetailFailureState extends RetriveULDState {
  final String error;
  RetriveULDDetailFailureState(this.error);
}




class RetriveULDSearchSuccessState extends RetriveULDState {
  final RetriveULDDetailLoadModel retriveULDModel;
  RetriveULDSearchSuccessState(this.retriveULDModel);
}

class RetriveULDSearchFailureState extends RetriveULDState {
  final String error;
  RetriveULDSearchFailureState(this.error);
}

class RetriveULDListSuccessState extends RetriveULDState {
  final RetriveULDDetailLoadModel retriveULDListModel;
  RetriveULDListSuccessState(this.retriveULDListModel);
}

class RetriveULDListFailureState extends RetriveULDState {
  final String error;
  RetriveULDListFailureState(this.error);
}
class AddToListSuccessState extends RetriveULDState {
  final AddToListModel addToListModel;
  AddToListSuccessState(this.addToListModel);
}

class AddToListFailureState extends RetriveULDState {
  final String error;
  AddToListFailureState(this.error);
}





