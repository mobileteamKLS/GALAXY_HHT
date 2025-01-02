import 'package:galaxy/module/export/model/closeuld/getscaleistmodel.dart';
import 'package:galaxy/module/export/model/closeuld/savecontourmodel.dart';
import 'package:galaxy/module/export/model/closeuld/saveequipmentmodel.dart';
import 'package:galaxy/module/export/model/closeuld/savescalemodel.dart';
import 'package:galaxy/module/export/model/closeuld/savetareweightmodel.dart';

import '../../../model/closeuld/closereopenmodel.dart';
import '../../../model/closeuld/closeuldsearchmodel.dart';
import '../../../model/closeuld/equipmentmodel.dart';
import '../../../model/closeuld/getcontourlistmodel.dart';
import '../../../model/closeuld/getdocumentlistmodel.dart';
import '../../../model/closeuld/getremarklistmodel.dart';
import '../../../model/closeuld/saveremarkmodel.dart';

class CloseULDState {}

class CloseULDInitialState extends CloseULDState {}
class CloseULDLoadingState extends CloseULDState {}

/*
class CloseULDPageLoadSuccessState extends CloseULDState {
  final EmptyULDtrolPageLoadModel emptyULDtrolPageLoadModel;
  CloseULDPageLoadSuccessState(this.emptyULDtrolPageLoadModel);
}

class CloseULDPageLoadFailureState extends CloseULDState {
  final String error;
  CloseULDPageLoadFailureState(this.error);
}
*/

class CloseULDSearchSuccessState extends CloseULDState {
  final CloseULDSearchModel closeULDSearchModel;
  CloseULDSearchSuccessState(this.closeULDSearchModel);
}

class CloseULDSearchFailureState extends CloseULDState {
  final String error;
  CloseULDSearchFailureState(this.error);
}


class CloseULDEquipmentSuccessState extends CloseULDState {
  final CloseULDEquipmentModel closeULDEquipmentModel;
  CloseULDEquipmentSuccessState(this.closeULDEquipmentModel);
}

class CloseULDEquipmentFailureState extends CloseULDState {
  final String error;
  CloseULDEquipmentFailureState(this.error);
}

class SaveEquipmentSuccessState extends CloseULDState {
  final SaveEquipmentModel saveEquipmentModel;
  SaveEquipmentSuccessState(this.saveEquipmentModel);
}

class SaveEquipmentFailureState extends CloseULDState {
  final String error;
  SaveEquipmentFailureState(this.error);
}

class GetContourListSuccessState extends CloseULDState {
  final GetContourListModel getContourListModel;
  GetContourListSuccessState(this.getContourListModel);
}

class GetContourListFailureState extends CloseULDState {
  final String error;
  GetContourListFailureState(this.error);
}

class SaveContourSuccessState extends CloseULDState {
  final SaveContourModel saveContourModel;
  SaveContourSuccessState(this.saveContourModel);
}

class SaveContourFailureState extends CloseULDState {
  final String error;
  SaveContourFailureState(this.error);
}


class GetScaleListSuccessState extends CloseULDState {
  final GetScaleListModel getScaleListModel;
  GetScaleListSuccessState(this.getScaleListModel);
}

class GetScaleListFailureState extends CloseULDState {
  final String error;
  GetScaleListFailureState(this.error);
}

class SaveScaleSuccessState extends CloseULDState {
  final SaveScaleModel saveScaleModel;
  SaveScaleSuccessState(this.saveScaleModel);
}

class SaveScaleFailureState extends CloseULDState {
  final String error;
  SaveScaleFailureState(this.error);
}




class GetRemarkListSuccessState extends CloseULDState {
  final GetRemarkListModel getRemarkListModel;
  GetRemarkListSuccessState(this.getRemarkListModel);
}

class GetRemarkListFailureState extends CloseULDState {
  final String error;
  GetRemarkListFailureState(this.error);
}

class SaveRemarkSuccessState extends CloseULDState {
  final SaveRemarkModel saveRemarkModel;
  SaveRemarkSuccessState(this.saveRemarkModel);
}

class SaveRemarkFailureState extends CloseULDState {
  final String error;
  SaveRemarkFailureState(this.error);
}


class SaveTareWeightSuccessState extends CloseULDState {
  final SaveTareWeightModel saveTareWeightModel;
  SaveTareWeightSuccessState(this.saveTareWeightModel);
}

class SaveTareWeightFailureState extends CloseULDState {
  final String error;
  SaveTareWeightFailureState(this.error);
}


class GetDocumentListSuccessState extends CloseULDState {
  final GetDocumentListModel getDocumentListModel;
  GetDocumentListSuccessState(this.getDocumentListModel);
}

class GetDocumentListFailureState extends CloseULDState {
  final String error;
  GetDocumentListFailureState(this.error);
}



class CloseReopenSuccessState extends CloseULDState {
  final CloseReopenModel closeReopenModel;
  CloseReopenSuccessState(this.closeReopenModel);
}

class CloseReopenFailureState extends CloseULDState {
  final String error;
  CloseReopenFailureState(this.error);
}
