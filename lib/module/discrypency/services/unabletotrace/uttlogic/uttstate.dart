import 'package:galaxy/module/discrypency/model/unabletotrace/getuttsearchmodel.dart';

import '../../../model/unabletotrace/uttrecordupdatemodel.dart';

class UTTState {}

class UTTInitialState extends UTTState {}
class UTTLoadingState extends UTTState {}


class GetUTTSearchSuccessState extends UTTState {
  final GetUTTSearchModel getUTTSearchModel;
  GetUTTSearchSuccessState(this.getUTTSearchModel);
}

class GetUTTSearchFailureState extends UTTState {
  final String error;
  GetUTTSearchFailureState(this.error);
}

class RecordUpdateSuccessState extends UTTState {
  final UTTRecordUpdateModel uttRecordUpdateModel;
  RecordUpdateSuccessState(this.uttRecordUpdateModel);
}

class RecordUpdateFailureState extends UTTState {
  final String error;
  RecordUpdateFailureState(this.error);
}


class RecordUpdateDSuccessState extends UTTState {
  final UTTRecordUpdateModel uttRecordUpdateModel;
  RecordUpdateDSuccessState(this.uttRecordUpdateModel);
}

class RecordUpdateDFailureState extends UTTState {
  final String error;
  RecordUpdateDFailureState(this.error);
}
