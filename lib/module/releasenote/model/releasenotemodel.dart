class ReleaseNoteModel {
  List<ReleaseNoteList>? releaseNoteList;

  ReleaseNoteModel({this.releaseNoteList});

  ReleaseNoteModel.fromJson(Map<String, dynamic> json) {
    if (json['releaseNoteList'] != null) {
      releaseNoteList = <ReleaseNoteList>[];
      json['releaseNoteList'].forEach((v) {
        releaseNoteList!.add(new ReleaseNoteList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.releaseNoteList != null) {
      data['releaseNoteList'] =
          this.releaseNoteList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ReleaseNoteList {
  String? date;
  List<String>? notes;

  ReleaseNoteList({this.date, this.notes});

  ReleaseNoteList.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    notes = json['notes'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['date'] = this.date;
    data['notes'] = this.notes;
    return data;
  }
}
