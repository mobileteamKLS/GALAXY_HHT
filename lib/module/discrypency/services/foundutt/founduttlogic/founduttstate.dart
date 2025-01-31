

import 'package:galaxy/module/discrypency/model/foundutt/getfounduttgroupidmodel.dart';
import 'package:galaxy/module/discrypency/model/foundutt/getfounduttpageloadmodel.dart';

import '../../../model/foundutt/founduttrecordupdatemodel.dart';
import '../../../model/foundutt/getfounduttsearchmodel.dart';

class FoundUTTState {}

class FoundUTTInitialState extends FoundUTTState {}
class FoundUTTLoadingState extends FoundUTTState {}


class GetFoundUTTPageLoadSuccessState extends FoundUTTState {
  final GetFoundUTTPageLoadModel getFoundUTTPageLoadModel;
  GetFoundUTTPageLoadSuccessState(this.getFoundUTTPageLoadModel);
}

class GetFoundUTTPageLoadFailureState extends FoundUTTState {
  final String error;
  GetFoundUTTPageLoadFailureState(this.error);
}


class GetFoundUTTSearchSuccessState extends FoundUTTState {
  final GetFoundUTTSearchModel getFoundUTTSearchModel;
  GetFoundUTTSearchSuccessState(this.getFoundUTTSearchModel);
}

class GetFoundUTTSearchFailureState extends FoundUTTState {
  final String error;
  GetFoundUTTSearchFailureState(this.error);
}


class GetFoundUTTGroupIdSuccessState extends FoundUTTState {
  final GetFoundUTTGroupIdModel getFoundUTTGroupIdModel;
  GetFoundUTTGroupIdSuccessState(this.getFoundUTTGroupIdModel);
}

class GetFoundUTTGroupIdFailureState extends FoundUTTState {
  final String error;
  GetFoundUTTGroupIdFailureState(this.error);
}


class RecordFoundUTTUpdateSuccessState extends FoundUTTState {
  final FoundUTTRecordUpdateModel foundUTTRecordUpdateModel;
  RecordFoundUTTUpdateSuccessState(this.foundUTTRecordUpdateModel);
}

class RecordFoundUTTUpdateFailureState extends FoundUTTState {
  final String error;
  RecordFoundUTTUpdateFailureState(this.error);
}
