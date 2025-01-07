import 'package:galaxy/module/export/model/closetrolley/gettrolleydocumentlistmodel.dart';
import '../../../model/closetrolley/closetrolleyreopenmodel.dart';
import '../../../model/closetrolley/closetrolleysearchmodel.dart';
import '../../../model/closetrolley/gettrolleyscalelistmodel.dart';
import '../../../model/closetrolley/savetrolleyscalemodel.dart';


class CloseTrolleyState {}

class CloseTrolleyInitialState extends CloseTrolleyState {}
class CloseTrolleyLoadingState extends CloseTrolleyState {}

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

class CloseTrolleySearchSuccessState extends CloseTrolleyState {
  final CloseTrolleySearchModel closeTrolleySearchModel;
  CloseTrolleySearchSuccessState(this.closeTrolleySearchModel);
}

class CloseTrolleySearchFailureState extends CloseTrolleyState {
  final String error;
  CloseTrolleySearchFailureState(this.error);
}

class GetTrolleyDocumentListSuccessState extends CloseTrolleyState {
  final GetTrolleyDocumentListModel getTrolleyDocumentListModel;
  GetTrolleyDocumentListSuccessState(this.getTrolleyDocumentListModel);
}

class GetTrolleyDocumentListFailureState extends CloseTrolleyState {
  final String error;
  GetTrolleyDocumentListFailureState(this.error);
}

class GetTrolleyScaleListSuccessState extends CloseTrolleyState {
  final GetTrolleyScaleListModel getTrolleyScaleListModel;
  GetTrolleyScaleListSuccessState(this.getTrolleyScaleListModel);
}

class GetTrolleyScaleListFailureState extends CloseTrolleyState {
  final String error;
  GetTrolleyScaleListFailureState(this.error);
}

class SaveTrolleyScaleSuccessState extends CloseTrolleyState {
  final SaveTrolleyScaleModel saveTrolleyScaleModel;
  SaveTrolleyScaleSuccessState(this.saveTrolleyScaleModel);
}

class SaveTrolleyScaleFailureState extends CloseTrolleyState {
  final String error;
  SaveTrolleyScaleFailureState(this.error);
}

class CloseTrolleyReopenSuccessState extends CloseTrolleyState {
  final CloseTrolleyReopenModel closeTrolleyReopenModel;
  CloseTrolleyReopenSuccessState(this.closeTrolleyReopenModel);
}

class CloseTrolleyReopenFailureState extends CloseTrolleyState {
  final String error;
  CloseTrolleyReopenFailureState(this.error);
}


/*
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
*/
