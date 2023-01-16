class GetGroupMembersResponse {
  int requestStatus;
  String firstName;
  String lastName;
  String fullName;
  String inTouchPointName;
  String photo;
  int archiveStatus;
  int profileType;
  int accountType;
  bool isHealthcareProvider;
  String id;
  bool isValid;

  GetGroupMembersResponse(
      {this.requestStatus,
        this.firstName,
        this.lastName,
        this.fullName,
        this.inTouchPointName,
        this.photo,
        this.archiveStatus,
        this.profileType,
        this.accountType,
        this.isHealthcareProvider,
        this.id,
        this.isValid});

  GetGroupMembersResponse.fromJson(Map<String, dynamic> json) {
    requestStatus = json['requestStatus'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    fullName = json['fullName'];
    inTouchPointName = json['inTouchPointName'];
    photo = json['photo'];
    archiveStatus = json['archiveStatus'];
    profileType = json['profileType'];
    accountType = json['accountType'];
    isHealthcareProvider = json['isHealthcareProvider'];
    id = json['id'];
    isValid = json['isValid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['requestStatus'] = this.requestStatus;
    data['firstName'] = this.firstName;
    data['lastName'] = this.lastName;
    data['fullName'] = this.fullName;
    data['inTouchPointName'] = this.inTouchPointName;
    data['photo'] = this.photo;
    data['archiveStatus'] = this.archiveStatus;
    data['profileType'] = this.profileType;
    data['accountType'] = this.accountType;
    data['isHealthcareProvider'] = this.isHealthcareProvider;
    data['id'] = this.id;
    data['isValid'] = this.isValid;
    return data;
  }
}