import 'dart:convert';

class GroupOwnerResponse {
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
  GroupOwnerResponse({
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
    this.isValid,
  });

  GroupOwnerResponse copyWith({
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
  }) {
    return GroupOwnerResponse(
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      fullName: fullName ?? this.fullName,
      inTouchPointName: inTouchPointName ?? this.inTouchPointName,
      photo: photo ?? this.photo,
      archiveStatus: archiveStatus ?? this.archiveStatus,
      profileType: profileType ?? this.profileType,
      accountType: accountType ?? this.accountType,
      isHealthcareProvider: isHealthcareProvider ?? this.isHealthcareProvider,
      id: id ?? this.id,
      isValid: isValid ?? this.isValid,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'fullName': fullName,
      'inTouchPointName': inTouchPointName,
      'photo': photo,
      'archiveStatus': archiveStatus,
      'profileType': profileType,
      'accountType': accountType,
      'isHealthcareProvider': isHealthcareProvider,
      'id': id,
      'isValid': isValid,
    };
  }

  factory GroupOwnerResponse.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
  
    return GroupOwnerResponse(
      firstName: map['firstName'],
      lastName: map['lastName'],
      fullName: map['fullName'],
      inTouchPointName: map['inTouchPointName'],
      photo: map['photo'],
      archiveStatus: map['archiveStatus'],
      profileType: map['profileType'],
      accountType: map['accountType'],
      isHealthcareProvider: map['isHealthcareProvider'],
      id: map['id'],
      isValid: map['isValid'],
    );
  }

  String toJson() => json.encode(toMap());

  factory GroupOwnerResponse.fromJson(String source) => GroupOwnerResponse.fromMap(json.decode(source));

  @override
  String toString() {
    return 'GroupOwnerResponse(firstName: $firstName, lastName: $lastName, fullName: $fullName, inTouchPointName: $inTouchPointName, photo: $photo, archiveStatus: $archiveStatus, profileType: $profileType, accountType: $accountType, isHealthcareProvider: $isHealthcareProvider, id: $id, isValid: $isValid)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;
  
    return o is GroupOwnerResponse &&
      o.firstName == firstName &&
      o.lastName == lastName &&
      o.fullName == fullName &&
      o.inTouchPointName == inTouchPointName &&
      o.photo == photo &&
      o.archiveStatus == archiveStatus &&
      o.profileType == profileType &&
      o.accountType == accountType &&
      o.isHealthcareProvider == isHealthcareProvider &&
      o.id == id &&
      o.isValid == isValid;
  }

  @override
  int get hashCode {
    return firstName.hashCode ^
      lastName.hashCode ^
      fullName.hashCode ^
      inTouchPointName.hashCode ^
      photo.hashCode ^
      archiveStatus.hashCode ^
      profileType.hashCode ^
      accountType.hashCode ^
      isHealthcareProvider.hashCode ^
      id.hashCode ^
      isValid.hashCode;
  }
}
