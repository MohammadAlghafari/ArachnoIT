class GetGroupInviteMembersResponse {

  String requestStatus;
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

  GetGroupInviteMembersResponse(
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

  GetGroupInviteMembersResponse copyWith({
    String requestStatus,
    String firstName,
    String lastName,
    String fullName,
    String inTouchPointName,
    String photo,
    int archiveStatus,
    int profileType,
    int accountType,
    bool isHealthcareProvider,
    String id,
    bool isValid,
}){
    return  GetGroupInviteMembersResponse(
      id: id??this.id,
      requestStatus: requestStatus??this.requestStatus,
      firstName: firstName??this.firstName,
      lastName: lastName??this.lastName,
      fullName: fullName??this.fullName,
      inTouchPointName: inTouchPointName??this.inTouchPointName,
      photo: photo??this.photo,
      archiveStatus: archiveStatus??this.archiveStatus,
      accountType: accountType??this.accountType,
      profileType: profileType??this.profileType,
      isHealthcareProvider: isHealthcareProvider??this.isHealthcareProvider,
      isValid: isValid??this.isValid,
    );
  }



  GetGroupInviteMembersResponse.fromJson(Map<String, dynamic> json) {
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