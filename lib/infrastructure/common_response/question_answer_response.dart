import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:arachnoit/infrastructure/common_response/question_answer_comment_response.dart';
import 'package:arachnoit/infrastructure/common_response/file_response.dart';

class QuestionAnswerResponse {
  String answerId;
  String answerBody;
  String creationDate;
  List<FileResponse> files;
  List<int> loginUserGroupPermissions;
  String groupId;
  String personId;
  bool isHealthcareProvider;
  String firstName;
  String lastName;
  String inTouchPointName;
  String specification;
  String subSpecification;
  String photoUrl;
  String questionOwnerId;
  bool isQuestionAnonymous;
  bool markedAsUseful;
  bool markedAsEmphasis;
  int usefulCount;
  int emphasisCount;
  List<QuestionAnswerCommentResponse> comments;
  QuestionAnswerResponse({
    this.answerId,
    this.answerBody,
    this.creationDate,
    this.files,
    this.loginUserGroupPermissions,
    this.groupId,
    this.personId,
    this.isHealthcareProvider,
    this.firstName,
    this.lastName,
    this.inTouchPointName,
    this.specification,
    this.subSpecification,
    this.photoUrl,
    this.markedAsUseful,
    this.markedAsEmphasis,
    this.usefulCount,
    this.emphasisCount,
    this.comments,
    this.questionOwnerId,
    this.isQuestionAnonymous=false
  });



  QuestionAnswerResponse copyWith({
    String answerId,
    String answerBody,
    String creationDate,
    List<FileResponse> files,
    List<int> loginUserGroupPermissions,
    String groupId,
    String personId,
    bool isHealthcareProvider,
    String firstName,
    String lastName,
    String inTouchPointName,
    String specification,
    String subSpecification,
    String photoUrl,
    bool markedAsUseful,
    bool markedAsEmphasis,
    int usefulCount,
    String questionOwnerId,
    bool isQuestionAnonymous,
    int emphasisCount,
    List<QuestionAnswerCommentResponse> comments,
  }) {
    return QuestionAnswerResponse(
      answerId: answerId ?? this.answerId,
      answerBody: answerBody ?? this.answerBody,
      creationDate: creationDate ?? this.creationDate,
      files: files ?? this.files,
      loginUserGroupPermissions: loginUserGroupPermissions ?? this.loginUserGroupPermissions,
      groupId: groupId ?? this.groupId,
      personId: personId ?? this.personId,
      isHealthcareProvider: isHealthcareProvider ?? this.isHealthcareProvider,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      inTouchPointName: inTouchPointName ?? this.inTouchPointName,
      specification: specification ?? this.specification,
      subSpecification: subSpecification ?? this.subSpecification,
      photoUrl: photoUrl ?? this.photoUrl,
      markedAsUseful: markedAsUseful ?? this.markedAsUseful,
      markedAsEmphasis: markedAsEmphasis ?? this.markedAsEmphasis,
      usefulCount: usefulCount ?? this.usefulCount,
      emphasisCount: emphasisCount ?? this.emphasisCount,
      comments: comments ?? this.comments,
      questionOwnerId: questionOwnerId??this.questionOwnerId,
      isQuestionAnonymous:isQuestionAnonymous??this.isQuestionAnonymous
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'answerId': answerId,
      'answerBody': answerBody,
      'creationDate': creationDate,
      'files': files?.map((x) => x?.toMap())?.toList(),
      'loginUserGroupPermissions': loginUserGroupPermissions,
      'groupId': groupId,
      'personId': personId,
      'isHealthcareProvider': isHealthcareProvider,
      'firstName': firstName,
      'lastName': lastName,
      'inTouchPointName': inTouchPointName,
      'specification': specification,
      'subSpecification': subSpecification,
      'photoUrl': photoUrl,
      'markedAsUseful': markedAsUseful,
      'markedAsEmphasis': markedAsEmphasis,
      'usefulCount': usefulCount,
      'emphasisCount': emphasisCount,
      'comments': comments?.map((x) => x?.toMap())?.toList(),
      "questionOwnerId":questionOwnerId??"",
      "isQuestionAnonymous":isQuestionAnonymous??false
    };
  }

  factory QuestionAnswerResponse.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
  
    return QuestionAnswerResponse(
      answerId: map['answerId'],
      answerBody: map['answerBody'],
      creationDate: map['creationDate'],
      files: List<FileResponse>.from(map['files']?.map((x) => FileResponse.fromMap(x))),
      loginUserGroupPermissions: null,
      groupId: map['groupId'],
      personId: map['personId'],
      isHealthcareProvider: map['isHealthcareProvider'],
      firstName: map['firstName'],
      lastName: map['lastName'],
      inTouchPointName: map['inTouchPointName'],
      specification: map['specification'],
      subSpecification: map['subSpecification'],
      photoUrl: map['photoUrl'],
      markedAsUseful: map['markedAsUseful'],
      markedAsEmphasis: map['markedAsEmphasis'],
      usefulCount: map['usefulCount'],
      emphasisCount: map['emphasisCount'],
      comments: List<QuestionAnswerCommentResponse>.from(map['comments']?.map((x) => QuestionAnswerCommentResponse.fromMap(x))),
      questionOwnerId: map['questionOwnerId'],
      isQuestionAnonymous:map["isQuestionAnonymous"],
    );
  }

  String toJson() => json.encode(toMap());

  factory QuestionAnswerResponse.fromJson(String source) => QuestionAnswerResponse.fromMap(json.decode(source));

  @override
  String toString() {
    return 'AnswerResponse(answerId: $answerId, answerBody: $answerBody, creationDate: $creationDate, files: $files, loginUserGroupPermissions: $loginUserGroupPermissions, groupId: $groupId, personId: $personId, isHealthcareProvider: $isHealthcareProvider, firstName: $firstName, lastName: $lastName, inTouchPointName: $inTouchPointName, specification: $specification, subSpecification: $subSpecification, photoUrl: $photoUrl, markedAsUseful: $markedAsUseful, markedAsEmphasis: $markedAsEmphasis, usefulCount: $usefulCount, emphasisCount: $emphasisCount, comments: $comments)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;
  
    return o is QuestionAnswerResponse &&
      o.answerId == answerId &&
      o.answerBody == answerBody &&
      o.creationDate == creationDate &&
      listEquals(o.files, files) &&
      listEquals(o.loginUserGroupPermissions, loginUserGroupPermissions) &&
      o.groupId == groupId &&
      o.personId == personId &&
      o.isHealthcareProvider == isHealthcareProvider &&
      o.firstName == firstName &&
      o.lastName == lastName &&
      o.inTouchPointName == inTouchPointName &&
      o.specification == specification &&
      o.subSpecification == subSpecification &&
      o.photoUrl == photoUrl &&
      o.markedAsUseful == markedAsUseful &&
      o.markedAsEmphasis == markedAsEmphasis &&
      o.usefulCount == usefulCount &&
      o.emphasisCount == emphasisCount &&
      listEquals(o.comments, comments);
  }

  @override
  int get hashCode {
    return answerId.hashCode ^
      answerBody.hashCode ^
      creationDate.hashCode ^
      files.hashCode ^
      loginUserGroupPermissions.hashCode ^
      groupId.hashCode ^
      personId.hashCode ^
      isHealthcareProvider.hashCode ^
      firstName.hashCode ^
      lastName.hashCode ^
      inTouchPointName.hashCode ^
      specification.hashCode ^
      subSpecification.hashCode ^
      photoUrl.hashCode ^
      markedAsUseful.hashCode ^
      markedAsEmphasis.hashCode ^
      usefulCount.hashCode ^
      emphasisCount.hashCode ^
      comments.hashCode;
  }
}
