class DamageDetailsModel {
  DamageAWBDetail? damageAWBDetail;
  List<ReferenceData9AList>? referenceData9AList;
  List<ReferenceData9BList>? referenceData9BList;
  List<ReferenceData10List>? referenceData10List;
  List<ReferenceData11List>? referenceData11List;
  List<ReferenceData12List>? referenceData12List;
  List<ReferenceData14AList>? referenceData14AList;
  List<ReferenceData14BList>? referenceData14BList;
  List<ReferenceData15List>? referenceData15List;
  List<ReferenceData17List>? referenceData17List;
  List<ReferenceData18List>? referenceData18List;
  List<ReferenceData21List>? referenceData21List;
  List<ReferenceData22List>? referenceData22List;
  List<ReferenceDataTypeOfDiscrepancyList>? referenceDataTypeOfDiscrepancyList;
  List<DamageImagesList>? damageImagesList;

  DamageDetail? damageDetail;
  DamageFlightDetail? damageFlightDetail;
  List<DamageHouseDetailList>? damageHouseDetailList;
  SystemDefaultsIsDmgWt? systemDefaultsIsDmgWt;
  String? status;
  String? statusMessage;

  DamageDetailsModel(
      {this.damageAWBDetail,
        this.referenceData9AList,
        this.referenceData9BList,
        this.referenceData11List,
        this.referenceData10List,
        this.referenceData12List,
        this.referenceData14AList,
        this.referenceData14BList,
        this.referenceData15List,
        this.referenceData18List,
        this.referenceData21List,
        this.referenceData22List,
        this.referenceDataTypeOfDiscrepancyList,
        this.referenceData17List,
        this.damageDetail,
        this.damageFlightDetail,
        this.damageHouseDetailList,
        this.systemDefaultsIsDmgWt,
        this.damageImagesList,
        this.status,
        this.statusMessage});

  DamageDetailsModel.fromJson(Map<String, dynamic> json) {
    damageAWBDetail = json['DamageAWBDetail'] != null
        ? new DamageAWBDetail.fromJson(json['DamageAWBDetail'])
        : null;
    if (json['ReferenceData9AList'] != null) {
      referenceData9AList = <ReferenceData9AList>[];
      json['ReferenceData9AList'].forEach((v) {
        referenceData9AList!.add(new ReferenceData9AList.fromJson(v));
      });
    }
    if (json['ReferenceData9BList'] != null) {
      referenceData9BList = <ReferenceData9BList>[];
      json['ReferenceData9BList'].forEach((v) {
        referenceData9BList!.add(new ReferenceData9BList.fromJson(v));
      });
    }
    if (json['ReferenceData11List'] != null) {
      referenceData11List = <ReferenceData11List>[];
      json['ReferenceData11List'].forEach((v) {
        referenceData11List!.add(new ReferenceData11List.fromJson(v));
      });
    }
    if (json['ReferenceData10List'] != null) {
      referenceData10List = <ReferenceData10List>[];
      json['ReferenceData10List'].forEach((v) {
        referenceData10List!.add(new ReferenceData10List.fromJson(v));
      });
    }
    if (json['ReferenceData12List'] != null) {
      referenceData12List = <ReferenceData12List>[];
      json['ReferenceData12List'].forEach((v) {
        referenceData12List!.add(new ReferenceData12List.fromJson(v));
      });
    }
    if (json['ReferenceData14AList'] != null) {
      referenceData14AList = <ReferenceData14AList>[];
      json['ReferenceData14AList'].forEach((v) {
        referenceData14AList!.add(new ReferenceData14AList.fromJson(v));
      });
    }
    if (json['ReferenceData14BList'] != null) {
      referenceData14BList = <ReferenceData14BList>[];
      json['ReferenceData14BList'].forEach((v) {
        referenceData14BList!.add(new ReferenceData14BList.fromJson(v));
      });
    }
    if (json['ReferenceData15List'] != null) {
      referenceData15List = <ReferenceData15List>[];
      json['ReferenceData15List'].forEach((v) {
        referenceData15List!.add(new ReferenceData15List.fromJson(v));
      });
    }
    if (json['ReferenceData18List'] != null) {
      referenceData18List = <ReferenceData18List>[];
      json['ReferenceData18List'].forEach((v) {
        referenceData18List!.add(new ReferenceData18List.fromJson(v));
      });
    }
    if (json['ReferenceData21List'] != null) {
      referenceData21List = <ReferenceData21List>[];
      json['ReferenceData21List'].forEach((v) {
        referenceData21List!.add(new ReferenceData21List.fromJson(v));
      });
    }
    if (json['ReferenceData22List'] != null) {
      referenceData22List = <ReferenceData22List>[];
      json['ReferenceData22List'].forEach((v) {
        referenceData22List!.add(new ReferenceData22List.fromJson(v));
      });
    }
    if (json['ReferenceDataTypeOfDiscrepancyList'] != null) {
      referenceDataTypeOfDiscrepancyList =
      <ReferenceDataTypeOfDiscrepancyList>[];
      json['ReferenceDataTypeOfDiscrepancyList'].forEach((v) {
        referenceDataTypeOfDiscrepancyList!
            .add(new ReferenceDataTypeOfDiscrepancyList.fromJson(v));
      });
    }
    if (json['ReferenceData17List'] != null) {
      referenceData17List = <ReferenceData17List>[];
      json['ReferenceData17List'].forEach((v) {
        referenceData17List!.add(new ReferenceData17List.fromJson(v));
      });
    }

    if (json['DamageImagesList'] != null) {
      damageImagesList = <DamageImagesList>[];
      json['DamageImagesList'].forEach((v) {
        damageImagesList!.add(new DamageImagesList.fromJson(v));
      });
    }

    damageDetail = json['DamageDetail'] != null
        ? new DamageDetail.fromJson(json['DamageDetail'])
        : null;
    damageFlightDetail = json['DamageFlightDetail'] != null
        ? new DamageFlightDetail.fromJson(json['DamageFlightDetail'])
        : null;
    if (json['DamageHouseDetailList'] != null) {
      damageHouseDetailList = <DamageHouseDetailList>[];
      json['DamageHouseDetailList'].forEach((v) {
        damageHouseDetailList!.add(new DamageHouseDetailList.fromJson(v));
      });
    }
    systemDefaultsIsDmgWt = json['SystemDefaultsIsDmgWt'] != null
        ? new SystemDefaultsIsDmgWt.fromJson(json['SystemDefaultsIsDmgWt'])
        : null;
    status = json['Status'];
    statusMessage = json['StatusMessage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.damageAWBDetail != null) {
      data['DamageAWBDetail'] = this.damageAWBDetail!.toJson();
    }
    if (this.referenceData9AList != null) {
      data['ReferenceData9AList'] =
          this.referenceData9AList!.map((v) => v.toJson()).toList();
    }
    if (this.referenceData9BList != null) {
      data['ReferenceData9BList'] =
          this.referenceData9BList!.map((v) => v.toJson()).toList();
    }
    if (this.referenceData11List != null) {
      data['ReferenceData11List'] =
          this.referenceData11List!.map((v) => v.toJson()).toList();
    }
    if (this.referenceData10List != null) {
      data['ReferenceData10List'] =
          this.referenceData10List!.map((v) => v.toJson()).toList();
    }
    if (this.referenceData12List != null) {
      data['ReferenceData12List'] =
          this.referenceData12List!.map((v) => v.toJson()).toList();
    }
    if (this.referenceData14AList != null) {
      data['ReferenceData14AList'] =
          this.referenceData14AList!.map((v) => v.toJson()).toList();
    }
    if (this.referenceData14BList != null) {
      data['ReferenceData14BList'] =
          this.referenceData14BList!.map((v) => v.toJson()).toList();
    }
    if (this.referenceData15List != null) {
      data['ReferenceData15List'] =
          this.referenceData15List!.map((v) => v.toJson()).toList();
    }
    if (this.referenceData18List != null) {
      data['ReferenceData18List'] =
          this.referenceData18List!.map((v) => v.toJson()).toList();
    }
    if (this.referenceData21List != null) {
      data['ReferenceData21List'] =
          this.referenceData21List!.map((v) => v.toJson()).toList();
    }
    if (this.referenceData22List != null) {
      data['ReferenceData22List'] =
          this.referenceData22List!.map((v) => v.toJson()).toList();
    }
    if (this.referenceDataTypeOfDiscrepancyList != null) {
      data['ReferenceDataTypeOfDiscrepancyList'] = this
          .referenceDataTypeOfDiscrepancyList!
          .map((v) => v.toJson())
          .toList();
    }
    if (this.referenceData17List != null) {
      data['ReferenceData17List'] =
          this.referenceData17List!.map((v) => v.toJson()).toList();
    }
    if (this.damageDetail != null) {
      data['DamageDetail'] = this.damageDetail!.toJson();
    }
    if (this.damageFlightDetail != null) {
      data['DamageFlightDetail'] = this.damageFlightDetail!.toJson();
    }
    if (this.damageHouseDetailList != null) {
      data['DamageHouseDetailList'] =
          this.damageHouseDetailList!.map((v) => v.toJson()).toList();
    }
    if (this.systemDefaultsIsDmgWt != null) {
      data['SystemDefaultsIsDmgWt'] = this.systemDefaultsIsDmgWt!.toJson();
    }
    data['Status'] = this.status;
    data['StatusMessage'] = this.statusMessage;
    return data;
  }
}

class DamageAWBDetail {
  String? aWBNo;
  String? houseNo;
  String? flightNo;
  String? origin;
  String? destination;
  String? offLoadPoint;
  int? houseSeqNo;
  String? description;
  int? nPX;
  double? wtExp;
  int? nPR;
  double? wtRec;

  DamageAWBDetail(
      {this.aWBNo,
        this.houseNo,
        this.flightNo,
        this.origin,
        this.destination,
        this.offLoadPoint,
        this.houseSeqNo,
        this.description,
        this.nPX,
        this.wtExp,
        this.nPR,
        this.wtRec});

  DamageAWBDetail.fromJson(Map<String, dynamic> json) {
    aWBNo = json['AWBNo'];
    houseNo = json['HouseNo'];
    flightNo = json['FlightNo'];
    origin = json['Origin'];
    destination = json['Destination'];
    offLoadPoint = json['OffLoadPoint'];
    houseSeqNo = json['HouseSeqNo'];
    description = json['Description'];
    nPX = json['NPX'];
    wtExp = json['WtExp'];
    nPR = json['NPR'];
    wtRec = json['WtRec'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['AWBNo'] = this.aWBNo;
    data['HouseNo'] = this.houseNo;
    data['FlightNo'] = this.flightNo;
    data['Origin'] = this.origin;
    data['Destination'] = this.destination;
    data['OffLoadPoint'] = this.offLoadPoint;
    data['HouseSeqNo'] = this.houseSeqNo;
    data['Description'] = this.description;
    data['NPX'] = this.nPX;
    data['WtExp'] = this.wtExp;
    data['NPR'] = this.nPR;
    data['WtRec'] = this.wtRec;
    return data;
  }
}

class ReferenceData9AList {
  String? referenceDataIdentifier;
  String? referenceDescription;
  String? isSelected;
  String? tbl;

  ReferenceData9AList(
      {this.referenceDataIdentifier,
        this.referenceDescription,
        this.isSelected,
        this.tbl});

  ReferenceData9AList.fromJson(Map<String, dynamic> json) {
    referenceDataIdentifier = json['ReferenceDataIdentifier'];
    referenceDescription = json['ReferenceDescription'];
    isSelected = json['IsSelected'];
    tbl = json['Tbl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ReferenceDataIdentifier'] = this.referenceDataIdentifier;
    data['ReferenceDescription'] = this.referenceDescription;
    data['IsSelected'] = this.isSelected;
    data['Tbl'] = this.tbl;
    return data;
  }
}

class ReferenceData9BList {
  String? referenceDataIdentifier;
  String? referenceDescription;
  String? isSelected;
  String? tbl;

  ReferenceData9BList(
      {this.referenceDataIdentifier,
        this.referenceDescription,
        this.isSelected,
        this.tbl});

  ReferenceData9BList.fromJson(Map<String, dynamic> json) {
    referenceDataIdentifier = json['ReferenceDataIdentifier'];
    referenceDescription = json['ReferenceDescription'];
    isSelected = json['IsSelected'];
    tbl = json['Tbl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ReferenceDataIdentifier'] = this.referenceDataIdentifier;
    data['ReferenceDescription'] = this.referenceDescription;
    data['IsSelected'] = this.isSelected;
    data['Tbl'] = this.tbl;
    return data;
  }
}

class ReferenceData10List {
  String? referenceDataIdentifier;
  String? referenceDescription;
  String? isSelected;
  String? tbl;

  ReferenceData10List(
      {this.referenceDataIdentifier,
        this.referenceDescription,
        this.isSelected,
        this.tbl});

  ReferenceData10List.fromJson(Map<String, dynamic> json) {
    referenceDataIdentifier = json['ReferenceDataIdentifier'];
    referenceDescription = json['ReferenceDescription'];
    isSelected = json['IsSelected'];
    tbl = json['Tbl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ReferenceDataIdentifier'] = this.referenceDataIdentifier;
    data['ReferenceDescription'] = this.referenceDescription;
    data['IsSelected'] = this.isSelected;
    data['Tbl'] = this.tbl;
    return data;
  }
}

class ReferenceData11List {
  String? referenceDataIdentifier;
  String? referenceDescription;
  String? isSelected;
  String? tbl;

  ReferenceData11List(
      {this.referenceDataIdentifier,
        this.referenceDescription,
        this.isSelected,
        this.tbl});

  ReferenceData11List.fromJson(Map<String, dynamic> json) {
    referenceDataIdentifier = json['ReferenceDataIdentifier'];
    referenceDescription = json['ReferenceDescription'];
    isSelected = json['IsSelected'];
    tbl = json['Tbl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ReferenceDataIdentifier'] = this.referenceDataIdentifier;
    data['ReferenceDescription'] = this.referenceDescription;
    data['IsSelected'] = this.isSelected;
    data['Tbl'] = this.tbl;
    return data;
  }
}

class ReferenceData12List {
  String? referenceDataIdentifier;
  String? referenceDescription;
  String? isSelected;
  String? tbl;

  ReferenceData12List(
      {this.referenceDataIdentifier,
        this.referenceDescription,
        this.isSelected,
        this.tbl});

  ReferenceData12List.fromJson(Map<String, dynamic> json) {
    referenceDataIdentifier = json['ReferenceDataIdentifier'];
    referenceDescription = json['ReferenceDescription'];
    isSelected = json['IsSelected'];
    tbl = json['Tbl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ReferenceDataIdentifier'] = this.referenceDataIdentifier;
    data['ReferenceDescription'] = this.referenceDescription;
    data['IsSelected'] = this.isSelected;
    data['Tbl'] = this.tbl;
    return data;
  }
}

class ReferenceData14AList {
  String? referenceDataIdentifier;
  String? referenceDescription;
  String? isSelected;
  String? tbl;

  ReferenceData14AList(
      {this.referenceDataIdentifier,
        this.referenceDescription,
        this.isSelected,
        this.tbl});

  ReferenceData14AList.fromJson(Map<String, dynamic> json) {
    referenceDataIdentifier = json['ReferenceDataIdentifier'];
    referenceDescription = json['ReferenceDescription'];
    isSelected = json['IsSelected'];
    tbl = json['Tbl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ReferenceDataIdentifier'] = this.referenceDataIdentifier;
    data['ReferenceDescription'] = this.referenceDescription;
    data['IsSelected'] = this.isSelected;
    data['Tbl'] = this.tbl;
    return data;
  }
}

class ReferenceData14BList {
  String? referenceDataIdentifier;
  String? referenceDescription;
  String? isSelected;
  String? tbl;

  ReferenceData14BList(
      {this.referenceDataIdentifier,
        this.referenceDescription,
        this.isSelected,
        this.tbl});

  ReferenceData14BList.fromJson(Map<String, dynamic> json) {
    referenceDataIdentifier = json['ReferenceDataIdentifier'];
    referenceDescription = json['ReferenceDescription'];
    isSelected = json['IsSelected'];
    tbl = json['Tbl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ReferenceDataIdentifier'] = this.referenceDataIdentifier;
    data['ReferenceDescription'] = this.referenceDescription;
    data['IsSelected'] = this.isSelected;
    data['Tbl'] = this.tbl;
    return data;
  }
}

class ReferenceData15List {
  String? referenceDataIdentifier;
  String? referenceDescription;
  String? isSelected;
  String? tbl;

  ReferenceData15List(
      {this.referenceDataIdentifier,
        this.referenceDescription,
        this.isSelected,
        this.tbl});

  ReferenceData15List.fromJson(Map<String, dynamic> json) {
    referenceDataIdentifier = json['ReferenceDataIdentifier'];
    referenceDescription = json['ReferenceDescription'];
    isSelected = json['IsSelected'];
    tbl = json['Tbl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ReferenceDataIdentifier'] = this.referenceDataIdentifier;
    data['ReferenceDescription'] = this.referenceDescription;
    data['IsSelected'] = this.isSelected;
    data['Tbl'] = this.tbl;
    return data;
  }
}

class ReferenceData17List {
  String? referenceDataIdentifier;
  String? referenceDescription;
  String? isSelected;
  String? tbl;

  ReferenceData17List(
      {this.referenceDataIdentifier,
        this.referenceDescription,
        this.isSelected,
        this.tbl});

  ReferenceData17List.fromJson(Map<String, dynamic> json) {
    referenceDataIdentifier = json['ReferenceDataIdentifier'];
    referenceDescription = json['ReferenceDescription'];
    isSelected = json['IsSelected'];
    tbl = json['Tbl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ReferenceDataIdentifier'] = this.referenceDataIdentifier;
    data['ReferenceDescription'] = this.referenceDescription;
    data['IsSelected'] = this.isSelected;
    data['Tbl'] = this.tbl;
    return data;
  }
}

class ReferenceData18List {
  String? referenceDataIdentifier;
  String? referenceDescription;
  String? isSelected;
  String? tbl;

  ReferenceData18List(
      {this.referenceDataIdentifier,
        this.referenceDescription,
        this.isSelected,
        this.tbl});

  ReferenceData18List.fromJson(Map<String, dynamic> json) {
    referenceDataIdentifier = json['ReferenceDataIdentifier'];
    referenceDescription = json['ReferenceDescription'];
    isSelected = json['IsSelected'];
    tbl = json['Tbl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ReferenceDataIdentifier'] = this.referenceDataIdentifier;
    data['ReferenceDescription'] = this.referenceDescription;
    data['IsSelected'] = this.isSelected;
    data['Tbl'] = this.tbl;
    return data;
  }
}

class ReferenceData21List {
  String? referenceDataIdentifier;
  String? referenceDescription;
  String? isSelected;
  String? tbl;

  ReferenceData21List(
      {this.referenceDataIdentifier,
        this.referenceDescription,
        this.isSelected,
        this.tbl});

  ReferenceData21List.fromJson(Map<String, dynamic> json) {
    referenceDataIdentifier = json['ReferenceDataIdentifier'];
    referenceDescription = json['ReferenceDescription'];
    isSelected = json['IsSelected'];
    tbl = json['Tbl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ReferenceDataIdentifier'] = this.referenceDataIdentifier;
    data['ReferenceDescription'] = this.referenceDescription;
    data['IsSelected'] = this.isSelected;
    data['Tbl'] = this.tbl;
    return data;
  }
}

class ReferenceData22List {
  String? referenceDataIdentifier;
  String? referenceDescription;
  String? isSelected;
  String? tbl;

  ReferenceData22List(
      {this.referenceDataIdentifier,
        this.referenceDescription,
        this.isSelected,
        this.tbl});

  ReferenceData22List.fromJson(Map<String, dynamic> json) {
    referenceDataIdentifier = json['ReferenceDataIdentifier'];
    referenceDescription = json['ReferenceDescription'];
    isSelected = json['IsSelected'];
    tbl = json['Tbl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ReferenceDataIdentifier'] = this.referenceDataIdentifier;
    data['ReferenceDescription'] = this.referenceDescription;
    data['IsSelected'] = this.isSelected;
    data['Tbl'] = this.tbl;
    return data;
  }
}

class ReferenceDataTypeOfDiscrepancyList {
  String? referenceDataIdentifier;
  String? referenceDescription;
  String? isSelected;
  String? tbl;

  ReferenceDataTypeOfDiscrepancyList(
      {this.referenceDataIdentifier,
        this.referenceDescription,
        this.isSelected,
        this.tbl});

  ReferenceDataTypeOfDiscrepancyList.fromJson(Map<String, dynamic> json) {
    referenceDataIdentifier = json['ReferenceDataIdentifier'];
    referenceDescription = json['ReferenceDescription'];
    isSelected = json['IsSelected'];
    tbl = json['Tbl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ReferenceDataIdentifier'] = this.referenceDataIdentifier;
    data['ReferenceDescription'] = this.referenceDescription;
    data['IsSelected'] = this.isSelected;
    data['Tbl'] = this.tbl;
    return data;
  }
}


class DamageDetail {
  int? seqNo;
  String? typeDiscrepancy;
  String? packContainerMaterial;
  String? packContainerType;
  String? packOuterPacking;
  String? packMarksLabels;
  String? packInnerPacking;
  String? packIsSufficient;
  String? damageContainer;
  String? damageContainers;
  String? damageDiscovered;
  String? damageSpaceMissing;
  String? damageVerifiedInvoice;
  String? damageApparentCause;
  String? damageEvidencePilferage;
  String? actionSalvage;
  String? actionDisposition;
  String? weatherCondition;
  double? totWtShippedAwb;
  int? totPcsShippedAwb;
  double? totWtActualCheck;
  int? totPcsActualCheck;
  double? totWtDifference;
  int? totPcsDifference;
  double? indWtPerDocument;
  double? indWtActualCheck;
  double? indWtDifference;
  String? remark;
  String? damageRemarked;
  String? gHARep;
  String? airlineRep;
  String? securityRep;

  DamageDetail(
      {this.seqNo,
        this.typeDiscrepancy,
        this.packContainerMaterial,
        this.packContainerType,
        this.packOuterPacking,
        this.packMarksLabels,
        this.packInnerPacking,
        this.packIsSufficient,
        this.damageContainer,
        this.damageContainers,
        this.damageDiscovered,
        this.damageSpaceMissing,
        this.damageVerifiedInvoice,
        this.damageApparentCause,
        this.damageEvidencePilferage,
        this.actionSalvage,
        this.actionDisposition,
        this.weatherCondition,
        this.totWtShippedAwb,
        this.totPcsShippedAwb,
        this.totWtActualCheck,
        this.totPcsActualCheck,
        this.totWtDifference,
        this.totPcsDifference,
        this.indWtPerDocument,
        this.indWtActualCheck,
        this.indWtDifference,
        this.remark,
        this.damageRemarked,
        this.gHARep,
        this.airlineRep,
        this.securityRep});

  DamageDetail.fromJson(Map<String, dynamic> json) {
    seqNo = json['SeqNo'];
    typeDiscrepancy = json['TypeDiscrepancy'];
    packContainerMaterial = json['PackContainerMaterial'];
    packContainerType = json['PackContainerType'];
    packOuterPacking = json['PackOuterPacking'];
    packMarksLabels = json['PackMarksLabels'];
    packInnerPacking = json['PackInnerPacking'];
    packIsSufficient = json['PackIsSufficient'];
    damageContainer = json['DamageContainer'];
    damageContainers = json['DamageContainers'];
    damageDiscovered = json['DamageDiscovered'];
    damageSpaceMissing = json['DamageSpaceMissing'];
    damageVerifiedInvoice = json['DamageVerifiedInvoice'];
    damageApparentCause = json['DamageApparentCause'];
    damageEvidencePilferage = json['DamageEvidencePilferage'];
    actionSalvage = json['ActionSalvage'];
    actionDisposition = json['ActionDisposition'];
    weatherCondition = json['WeatherCondition'];
    totWtShippedAwb = json['TotWtShippedAwb'];
    totPcsShippedAwb = json['TotPcsShippedAwb'];
    totWtActualCheck = json['TotWtActualCheck'];
    totPcsActualCheck = json['TotPcsActualCheck'];
    totWtDifference = json['TotWtDifference'];
    totPcsDifference = json['TotPcsDifference'];
    indWtPerDocument = json['IndWtPerDocument'];
    indWtActualCheck = json['IndWtActualCheck'];
    indWtDifference = json['IndWtDifference'];
    remark = json['Remark'];
    damageRemarked = json['DamageRemarked'];
    gHARep = json['GHARep'];
    airlineRep = json['AirlineRep'];
    securityRep = json['SecurityRep'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['SeqNo'] = this.seqNo;
    data['TypeDiscrepancy'] = this.typeDiscrepancy;
    data['PackContainerMaterial'] = this.packContainerMaterial;
    data['PackContainerType'] = this.packContainerType;
    data['PackOuterPacking'] = this.packOuterPacking;
    data['PackMarksLabels'] = this.packMarksLabels;
    data['PackInnerPacking'] = this.packInnerPacking;
    data['PackIsSufficient'] = this.packIsSufficient;
    data['DamageContainer'] = this.damageContainer;
    data['DamageContainers'] = this.damageContainers;
    data['DamageDiscovered'] = this.damageDiscovered;
    data['DamageSpaceMissing'] = this.damageSpaceMissing;
    data['DamageVerifiedInvoice'] = this.damageVerifiedInvoice;
    data['DamageApparentCause'] = this.damageApparentCause;
    data['DamageEvidencePilferage'] = this.damageEvidencePilferage;
    data['ActionSalvage'] = this.actionSalvage;
    data['ActionDisposition'] = this.actionDisposition;
    data['WeatherCondition'] = this.weatherCondition;
    data['TotWtShippedAwb'] = this.totWtShippedAwb;
    data['TotPcsShippedAwb'] = this.totPcsShippedAwb;
    data['TotWtActualCheck'] = this.totWtActualCheck;
    data['TotPcsActualCheck'] = this.totPcsActualCheck;
    data['TotWtDifference'] = this.totWtDifference;
    data['TotPcsDifference'] = this.totPcsDifference;
    data['IndWtPerDocument'] = this.indWtPerDocument;
    data['IndWtActualCheck'] = this.indWtActualCheck;
    data['IndWtDifference'] = this.indWtDifference;
    data['Remark'] = this.remark;
    data['DamageRemarked'] = this.damageRemarked;
    data['GHARep'] = this.gHARep;
    data['AirlineRep'] = this.airlineRep;
    data['SecurityRep'] = this.securityRep;
    return data;
  }
}

class DamageFlightDetail {
  String? flightNo;
  String? flightDate;

  DamageFlightDetail({this.flightNo, this.flightDate});

  DamageFlightDetail.fromJson(Map<String, dynamic> json) {
    flightNo = json['FlightNo'];
    flightDate = json['FlightDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['FlightNo'] = this.flightNo;
    data['FlightDate'] = this.flightDate;
    return data;
  }
}

class DamageHouseDetailList {
  String? houseNo;
  String? rowId;

  DamageHouseDetailList({this.houseNo, this.rowId});

  DamageHouseDetailList.fromJson(Map<String, dynamic> json) {
    houseNo = json['HouseNo'];
    rowId = json['RowId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['HouseNo'] = this.houseNo;
    data['RowId'] = this.rowId;
    return data;
  }
}

class SystemDefaultsIsDmgWt {
  String? isDmgWtChar;

  SystemDefaultsIsDmgWt({this.isDmgWtChar});

  SystemDefaultsIsDmgWt.fromJson(Map<String, dynamic> json) {
    isDmgWtChar = json['IsDmgWtChar'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['IsDmgWtChar'] = this.isDmgWtChar;
    return data;
  }
}

class DamageImagesList {
  String? FileName;
  String? BinaryFile;

  DamageImagesList(
      {this.FileName,
        this.BinaryFile});

  DamageImagesList.fromJson(Map<String, dynamic> json) {
    FileName = json['FileName'];
    BinaryFile = json['BinaryFile'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['FileName'] = this.FileName;
    data['BinaryFile'] = this.BinaryFile;
    return data;
  }
}
