import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:arachnoit/infrastructure/group_details/response/group_permission_response.dart';

class GroupMemberResponse {
  String joinDate;
  int requestStatus;
  List<GroupPermissionResponse> groupPermissions;
  String email;
  String personId;
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
  GroupMemberResponse({
    this.joinDate,
    this.requestStatus,
    this.groupPermissions,
    this.email,
    this.personId,
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

  GroupMemberResponse copyWith({
    String joinDate,
    int requestStatus,
    List<GroupPermissionResponse> groupPermissions,
    String email,
    String personId,
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
    return GroupMemberResponse(
      joinDate: joinDate ?? this.joinDate,
      requestStatus: requestStatus ?? this.requestStatus,
      groupPermissions: groupPermissions ?? this.groupPermissions,
      email: email ?? this.email,
      personId: personId ?? this.personId,
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
      'joinDate': joinDate,
      'requestStatus': requestStatus,
      'groupPermissions': groupPermissions?.map((x) => x?.toMap())?.toList(),
      'email': email,
      'personId': personId,
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

  factory GroupMemberResponse.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
  
    return GroupMemberResponse(
      joinDate: map['joinDate'],
      requestStatus: map['requestStatus'],
      groupPermissions: List<GroupPermissionResponse>.from(map['groupPermissions']?.map((x) => GroupPermissionResponse.fromMap(x))),
      email: map['email'],
      personId: map['personId'],
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

  factory GroupMemberResponse.fromJson(String source) => GroupMemberResponse.fromMap(json.decode(source));

  @override
  String toString() {
    return 'GroupMemberResponse(joinDate: $joinDate, requestStatus: $requestStatus, groupPermissions: $groupPermissions, email: $email, personId: $personId, firstName: $firstName, lastName: $lastName, fullName: $fullName, inTouchPointName: $inTouchPointName, photo: $photo, archiveStatus: $archiveStatus, profileType: $profileType, accountType: $accountType, isHealthcareProvider: $isHealthcareProvider, id: $id, isValid: $isValid)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;
  
    return o is GroupMemberResponse &&
      o.joinDate == joinDate &&
      o.requestStatus == requestStatus &&
      listEquals(o.groupPermissions, groupPermissions) &&
      o.email == email &&
      o.personId == personId &&
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
    return joinDate.hashCode ^
      requestStatus.hashCode ^
      groupPermissions.hashCode ^
      email.hashCode ^
      personId.hashCode ^
      firstName.hashCode ^
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
