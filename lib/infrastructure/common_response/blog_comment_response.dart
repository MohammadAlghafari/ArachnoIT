import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'blog_comment_reply_response.dart';

class CommentResponse {
  String id;
  String body;
  String creationDate;
  List<int> loginUserGroupPermissions;
  String groupId;
  String groupOwnerId;
  String personId;
  String firstName;
  String lastName;
  String inTouchPointName;
  bool isHealthcareProvider;
  String specification;
  String subSpecification;
  String photoUrl;
  bool markedAsUseful;
  bool markedAsEmphasis;
  int usefulCount;
  int emphasisCount;
  List<CommentReplyResponse> replies;
  CommentResponse({
    this.id,
    this.body,
    this.creationDate,
    this.loginUserGroupPermissions,
    this.groupId,
    this.groupOwnerId,
    this.personId,
    this.firstName,
    this.lastName,
    this.inTouchPointName,
    this.isHealthcareProvider,
    this.specification,
    this.subSpecification,
    this.photoUrl,
    this.markedAsUseful,
    this.markedAsEmphasis,
    this.usefulCount,
    this.emphasisCount,
    this.replies,
  });

  CommentResponse copyWith({
    String id,
    String body,
    String creationDate,
    List<int> loginUserGroupPermissions,
    String groupId,
    String groupOwnerId,
    String personId,
    String firstName,
    String lastName,
    String inTouchPointName,
    bool isHealthcareProvider,
    String specification,
    String subSpecification,
    String photoUrl,
    bool markedAsUseful,
    bool markedAsEmphasis,
    int usefulCount,
    int emphasisCount,
    List<CommentReplyResponse> replies,
  }) {
    return CommentResponse(
      id: id ?? this.id,
      body: body ?? this.body,
      creationDate: creationDate ?? this.creationDate,
      loginUserGroupPermissions: loginUserGroupPermissions ?? this.loginUserGroupPermissions,
      groupId: groupId ?? this.groupId,
      groupOwnerId: groupOwnerId ?? this.groupOwnerId,
      personId: personId ?? this.personId,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      inTouchPointName: inTouchPointName ?? this.inTouchPointName,
      isHealthcareProvider: isHealthcareProvider ?? this.isHealthcareProvider,
      specification: specification ?? this.specification,
      subSpecification: subSpecification ?? this.subSpecification,
      photoUrl: photoUrl ?? this.photoUrl,
      markedAsUseful: markedAsUseful ?? this.markedAsUseful,
      markedAsEmphasis: markedAsEmphasis ?? this.markedAsEmphasis,
      usefulCount: usefulCount ?? this.usefulCount,
      emphasisCount: emphasisCount ?? this.emphasisCount,
      replies: replies ?? this.replies,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'body': body,
      'creationDate': creationDate,
      'loginUserGroupPermissions': loginUserGroupPermissions,
      'groupId': groupId,
      'groupOwnerId': groupOwnerId,
      'personId': personId,
      'firstName': firstName,
      'lastName': lastName,
      'inTouchPointName': inTouchPointName,
      'isHealthcareProvider': isHealthcareProvider,
      'specification': specification,
      'subSpecification': subSpecification,
      'photoUrl': photoUrl,
      'markedAsUseful': markedAsUseful,
      'markedAsEmphasis': markedAsEmphasis,
      'usefulCount': usefulCount,
      'emphasisCount': emphasisCount,
      'replies': replies?.map((x) => x?.toMap())?.toList(),
    };
  }

  factory CommentResponse.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
  
    return CommentResponse(
      id: map['id'],
      body: map['body'],
      creationDate: map['creationDate'],
      loginUserGroupPermissions:  map['loginUserGroupPermissions'] != null ?
          List<int>.from(map['loginUserGroupPermissions']) : null,
      groupId: map['groupId'],
      groupOwnerId: map['groupOwnerId'],
      personId: map['personId'],
      firstName: map['firstName'],
      lastName: map['lastName'],
      inTouchPointName: map['inTouchPointName'],
      isHealthcareProvider: map['isHealthcareProvider'],
      specification: map['specification'],
      subSpecification: map['subSpecification'],
      photoUrl: map['photoUrl'],
      markedAsUseful: map['markedAsUseful'],
      markedAsEmphasis: map['markedAsEmphasis'],
      usefulCount: map['usefulCount'],
      emphasisCount: map['emphasisCount'],
      replies: List<CommentReplyResponse>.from(map['replies']?.map((x) => CommentReplyResponse.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory CommentResponse.fromJson(String source) => CommentResponse.fromMap(json.decode(source));

  @override
  String toString() {
    return 'BlogCommentReponse(id: $id, body: $body, creationDate: $creationDate, loginUserGroupPermissions: $loginUserGroupPermissions, groupId: $groupId, groupOwnerId: $groupOwnerId, personId: $personId, firstName: $firstName, lastName: $lastName, inTouchPointName: $inTouchPointName, isHealthcareProvider: $isHealthcareProvider, specification: $specification, subSpecification: $subSpecification, photoUrl: $photoUrl, markedAsUseful: $markedAsUseful, markedAsEmphasis: $markedAsEmphasis, usefulCount: $usefulCount, emphasisCount: $emphasisCount, replies: $replies)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;
  
    return o is CommentResponse &&
      o.id == id &&
      o.body == body &&
      o.creationDate == creationDate &&
      listEquals(o.loginUserGroupPermissions, loginUserGroupPermissions) &&
      o.groupId == groupId &&
      o.groupOwnerId == groupOwnerId &&
      o.personId == personId &&
      o.firstName == firstName &&
      o.lastName == lastName &&
      o.inTouchPointName == inTouchPointName &&
      o.isHealthcareProvider == isHealthcareProvider &&
      o.specification == specification &&
      o.subSpecification == subSpecification &&
      o.photoUrl == photoUrl &&
      o.markedAsUseful == markedAsUseful &&
      o.markedAsEmphasis == markedAsEmphasis &&
      o.usefulCount == usefulCount &&
      o.emphasisCount == emphasisCount &&
      listEquals(o.replies, replies);
  }

  @override
  int get hashCode {
    return id.hashCode ^
      body.hashCode ^
      creationDate.hashCode ^
      loginUserGroupPermissions.hashCode ^
      groupId.hashCode ^
      groupOwnerId.hashCode ^
      personId.hashCode ^
      firstName.hashCode ^
      lastName.hashCode ^
      inTouchPointName.hashCode ^
      isHealthcareProvider.hashCode ^
      specification.hashCode ^
      subSpecification.hashCode ^
      photoUrl.hashCode ^
      markedAsUseful.hashCode ^
      markedAsEmphasis.hashCode ^
      usefulCount.hashCode ^
      emphasisCount.hashCode ^
      replies.hashCode;
  }
}
