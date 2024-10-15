class UserDataModel {
  UserProfile? userProfile;
  String? status;
  String? statusMessage;

  UserDataModel({this.userProfile, this.status, this.statusMessage});

  UserDataModel.fromJson(Map<String, dynamic> json) {
    userProfile = json['UserProfile'] != null
        ? new UserProfile.fromJson(json['UserProfile'])
        : null;
    status = json['Status'];
    statusMessage = json['StatusMessage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.userProfile != null) {
      data['UserProfile'] = this.userProfile!.toJson();
    }
    data['Status'] = this.status;
    data['StatusMessage'] = this.statusMessage;
    return data;
  }
}

class UserProfile {
  String? userName;
  String? userGroup;
  String? preferredLanguage;
  String? iSOCulture;
  String? firstName;
  String? lastName;
  String? userId;
  int? userIdentity;

  UserProfile(
      {this.userName,
        this.userGroup,
        this.preferredLanguage,
        this.iSOCulture,
        this.firstName,
        this.lastName,
        this.userId,
        this.userIdentity});

  UserProfile.fromJson(Map<String, dynamic> json) {
    userName = json['UserName'];
    userGroup = json['UserGroup'];
    preferredLanguage = json['PreferredLanguage'];
    iSOCulture = json['ISOCulture'];
    firstName = json['FirstName'];
    lastName = json['LastName'];
    userId = json['UserId'];
    userIdentity = json['UserIdentity'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['UserName'] = this.userName;
    data['UserGroup'] = this.userGroup;
    data['PreferredLanguage'] = this.preferredLanguage;
    data['ISOCulture'] = this.iSOCulture;
    data['FirstName'] = this.firstName;
    data['LastName'] = this.lastName;
    data['UserId'] = this.userId;
    data['UserIdentity'] = this.userIdentity;
    return data;
  }
}
