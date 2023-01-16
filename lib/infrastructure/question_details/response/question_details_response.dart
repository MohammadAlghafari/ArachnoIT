import 'dart:convert';

import 'package:flutter/foundation.dart';

import '../../common_response/file_response.dart';
import '../../common_response/question_answer_response.dart';
import '../../common_response/tag_response.dart';

class QuestionDetailsResponse {
  int questionVisibility;
  List<QuestionAnswerResponse> answers;
  String questionId;
  String questionTitle;
  String questionBody;
  String htmlBody;
  String creationDate;
  String groupId;
  String groupName;
  int groupPrivacyLevel;
  bool askAnonymously;
  bool viewToHealthcareProvidersOnly;
  List<int> loginUserGroupPermissions;
  List<FileResponse> files;
  String sharedQuestionId;
  String categoryId;
  String category;
  String subCategoryId;
  String subCategory;
  List<TagResponse> tags;
  int answersCount;
  int viewsCount;
  int usefulCount;
  int emphasisCount;
  String personId;
  bool isHealthcareProvider;
  String specification;
  String createdBy;
  String createdByFirstName;
  String createdByLastName;
  String subSpecification;
  String firstName;
  String lastName;
  String inTouchPointName;
  String photoUrl;
  bool markedAsUseful;
  bool markedAsEmphasis;
  QuestionDetailsResponse({
    this.questionVisibility,
    this.answers,
    this.questionId,
    this.questionTitle,
    this.questionBody,
    this.htmlBody,
    this.creationDate,
    this.groupId,
    this.groupName,
    this.groupPrivacyLevel,
    this.askAnonymously,
    this.viewToHealthcareProvidersOnly,
    this.loginUserGroupPermissions,
    this.files,
    this.sharedQuestionId,
    this.categoryId,
    this.category,
    this.subCategoryId,
    this.subCategory,
    this.tags,
    this.answersCount,
    this.viewsCount,
    this.usefulCount,
    this.emphasisCount,
    this.personId,
    this.isHealthcareProvider,
    this.specification,
    this.createdBy,
    this.createdByFirstName,
    this.createdByLastName,
    this.subSpecification,
    this.firstName,
    this.lastName,
    this.inTouchPointName,
    this.photoUrl,
    this.markedAsUseful,
    this.markedAsEmphasis,
  });

  QuestionDetailsResponse copyWith({
    int questionVisibility,
    List<QuestionAnswerResponse> answers,
    String questionId,
    String questionTitle,
    String questionBody,
    String htmlBody,
    String creationDate,
    String groupId,
    String groupName,
    int groupPrivacyLevel,
    bool askAnonymously,
    bool viewToHealthcareProvidersOnly,
    List<int> loginUserGroupPermissions,
    List<FileResponse> files,
    String sharedQuestionId,
    String categoryId,
    String category,
    String subCategoryId,
    String subCategory,
    List<TagResponse> tags,
    int answersCount,
    int viewsCount,
    int usefulCount,
    int emphasisCount,
    String personId,
    bool isHealthcareProvider,
    String specification,
    String createdBy,
    String createdByFirstName,
    String createdByLastName,
    String subSpecification,
    String firstName,
    String lastName,
    String inTouchPointName,
    String photoUrl,
    bool markedAsUseful,
    bool markedAsEmphasis,
  }) {
    return QuestionDetailsResponse(
      questionVisibility: questionVisibility ?? this.questionVisibility,
      answers: answers ?? this.answers,
      questionId: questionId ?? this.questionId,
      questionTitle: questionTitle ?? this.questionTitle,
      questionBody: questionBody ?? this.questionBody,
      htmlBody: htmlBody ?? this.htmlBody,
      creationDate: creationDate ?? this.creationDate,
      groupId: groupId ?? this.groupId,
      groupName: groupName ?? this.groupName,
      groupPrivacyLevel: groupPrivacyLevel ?? this.groupPrivacyLevel,
      askAnonymously: askAnonymously ?? this.askAnonymously,
      viewToHealthcareProvidersOnly: viewToHealthcareProvidersOnly ?? this.viewToHealthcareProvidersOnly,
      loginUserGroupPermissions: loginUserGroupPermissions ?? this.loginUserGroupPermissions,
      files: files ?? this.files,
      sharedQuestionId: sharedQuestionId ?? this.sharedQuestionId,
      categoryId: categoryId ?? this.categoryId,
      category: category ?? this.category,
      subCategoryId: subCategoryId ?? this.subCategoryId,
      subCategory: subCategory ?? this.subCategory,
      tags: tags ?? this.tags,
      answersCount: answersCount ?? this.answersCount,
      viewsCount: viewsCount ?? this.viewsCount,
      usefulCount: usefulCount ?? this.usefulCount,
      emphasisCount: emphasisCount ?? this.emphasisCount,
      personId: personId ?? this.personId,
      isHealthcareProvider: isHealthcareProvider ?? this.isHealthcareProvider,
      specification: specification ?? this.specification,
      createdBy: createdBy ?? this.createdBy,
      createdByFirstName: createdByFirstName ?? this.createdByFirstName,
      createdByLastName: createdByLastName ?? this.createdByLastName,
      subSpecification: subSpecification ?? this.subSpecification,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      inTouchPointName: inTouchPointName ?? this.inTouchPointName,
      photoUrl: photoUrl ?? this.photoUrl,
      markedAsUseful: markedAsUseful ?? this.markedAsUseful,
      markedAsEmphasis: markedAsEmphasis ?? this.markedAsEmphasis,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'questionVisibility': questionVisibility,
      'answers': answers?.map((x) => x?.toMap())?.toList(),
      'questionId': questionId,
      'questionTitle': questionTitle,
      'questionBody': questionBody,
      'htmlBody': htmlBody,
      'creationDate': creationDate,
      'groupId': groupId,
      'groupName': groupName,
      'groupPrivacyLevel': groupPrivacyLevel,
      'askAnonymously': askAnonymously,
      'viewToHealthcareProvidersOnly': viewToHealthcareProvidersOnly,
      'loginUserGroupPermissions': loginUserGroupPermissions,
      'files': files?.map((x) => x?.toMap())?.toList(),
      'sharedQuestionId': sharedQuestionId,
      'categoryId': categoryId,
      'category': category,
      'subCategoryId': subCategoryId,
      'subCategory': subCategory,
      'tags': tags?.map((x) => x?.toMap())?.toList(),
      'answersCount': answersCount,
      'viewsCount': viewsCount,
      'usefulCount': usefulCount,
      'emphasisCount': emphasisCount,
      'personId': personId,
      'isHealthcareProvider': isHealthcareProvider,
      'specification': specification,
      'createdBy': createdBy,
      'createdByFirstName': createdByFirstName,
      'createdByLastName': createdByLastName,
      'subSpecification': subSpecification,
      'firstName': firstName,
      'lastName': lastName,
      'inTouchPointName': inTouchPointName,
      'photoUrl': photoUrl,
      'markedAsUseful': markedAsUseful,
      'markedAsEmphasis': markedAsEmphasis,
    };
  }

  factory QuestionDetailsResponse.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
  
    return QuestionDetailsResponse(
      questionVisibility: map['questionVisibility'],
      answers: List<QuestionAnswerResponse>.from(map['answers']?.map((x) => QuestionAnswerResponse.fromMap(x))),
      questionId: map['questionId'],
      questionTitle: map['questionTitle'],
      questionBody: map['questionBody'],
      htmlBody: map['htmlBody'],
      creationDate: map['creationDate'],
      groupId: map['groupId'],
      groupName: map['groupName'],
      groupPrivacyLevel: map['groupPrivacyLevel'],
      askAnonymously: map['askAnonymously'],
      viewToHealthcareProvidersOnly: map['viewToHealthcareProvidersOnly'],
      loginUserGroupPermissions: map['loginUserGroupPermissions'] != null ?
          List<int>.from(map['loginUserGroupPermissions']) : null,
      files: List<FileResponse>.from(map['files']?.map((x) => FileResponse.fromMap(x))),
      sharedQuestionId: map['sharedQuestionId'],
      categoryId: map['categoryId'],
      category: map['category'],
      subCategoryId: map['subCategoryId'],
      subCategory: map['subCategory'],
      tags: List<TagResponse>.from(map['tags']?.map((x) => TagResponse.fromMap(x))),
      answersCount: map['answersCount'],
      viewsCount: map['viewsCount'],
      usefulCount: map['usefulCount'],
      emphasisCount: map['emphasisCount'],
      personId: map['personId'],
      isHealthcareProvider: map['isHealthcareProvider'],
      specification: map['specification'],
      createdBy: map['createdBy'],
      createdByFirstName: map['createdByFirstName'],
      createdByLastName: map['createdByLastName'],
      subSpecification: map['subSpecification'],
      firstName: map['firstName'],
      lastName: map['lastName'],
      inTouchPointName: map['inTouchPointName'],
      photoUrl: map['photoUrl'],
      markedAsUseful: map['markedAsUseful'],
      markedAsEmphasis: map['markedAsEmphasis'],
    );
  }

  String toJson() => json.encode(toMap());

  factory QuestionDetailsResponse.fromJson(String source) => QuestionDetailsResponse.fromMap(json.decode(source));

  @override
  String toString() {
    return 'QuestionDetailsResponse(questionVisibility: $questionVisibility, answers: $answers, questionId: $questionId, questionTitle: $questionTitle, questionBody: $questionBody, htmlBody: $htmlBody, creationDate: $creationDate, groupId: $groupId, groupName: $groupName, groupPrivacyLevel: $groupPrivacyLevel, askAnonymously: $askAnonymously, viewToHealthcareProvidersOnly: $viewToHealthcareProvidersOnly, loginUserGroupPermissions: $loginUserGroupPermissions, files: $files, sharedQuestionId: $sharedQuestionId, categoryId: $categoryId, category: $category, subCategoryId: $subCategoryId, subCategory: $subCategory, tags: $tags, answersCount: $answersCount, viewsCount: $viewsCount, usefulCount: $usefulCount, emphasisCount: $emphasisCount, personId: $personId, isHealthcareProvider: $isHealthcareProvider, specification: $specification, createdBy: $createdBy, createdByFirstName: $createdByFirstName, createdByLastName: $createdByLastName, subSpecification: $subSpecification, firstName: $firstName, lastName: $lastName, inTouchPointName: $inTouchPointName, photoUrl: $photoUrl, markedAsUseful: $markedAsUseful, markedAsEmphasis: $markedAsEmphasis)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;
  
    return o is QuestionDetailsResponse &&
      o.questionVisibility == questionVisibility &&
      listEquals(o.answers, answers) &&
      o.questionId == questionId &&
      o.questionTitle == questionTitle &&
      o.questionBody == questionBody &&
      o.htmlBody == htmlBody &&
      o.creationDate == creationDate &&
      o.groupId == groupId &&
      o.groupName == groupName &&
      o.groupPrivacyLevel == groupPrivacyLevel &&
      o.askAnonymously == askAnonymously &&
      o.viewToHealthcareProvidersOnly == viewToHealthcareProvidersOnly &&
      listEquals(o.loginUserGroupPermissions, loginUserGroupPermissions) &&
      listEquals(o.files, files) &&
      o.sharedQuestionId == sharedQuestionId &&
      o.categoryId == categoryId &&
      o.category == category &&
      o.subCategoryId == subCategoryId &&
      o.subCategory == subCategory &&
      listEquals(o.tags, tags) &&
      o.answersCount == answersCount &&
      o.viewsCount == viewsCount &&
      o.usefulCount == usefulCount &&
      o.emphasisCount == emphasisCount &&
      o.personId == personId &&
      o.isHealthcareProvider == isHealthcareProvider &&
      o.specification == specification &&
      o.createdBy == createdBy &&
      o.createdByFirstName == createdByFirstName &&
      o.createdByLastName == createdByLastName &&
      o.subSpecification == subSpecification &&
      o.firstName == firstName &&
      o.lastName == lastName &&
      o.inTouchPointName == inTouchPointName &&
      o.photoUrl == photoUrl &&
      o.markedAsUseful == markedAsUseful &&
      o.markedAsEmphasis == markedAsEmphasis;
  }

  @override
  int get hashCode {
    return questionVisibility.hashCode ^
      answers.hashCode ^
      questionId.hashCode ^
      questionTitle.hashCode ^
      questionBody.hashCode ^
      htmlBody.hashCode ^
      creationDate.hashCode ^
      groupId.hashCode ^
      groupName.hashCode ^
      groupPrivacyLevel.hashCode ^
      askAnonymously.hashCode ^
      viewToHealthcareProvidersOnly.hashCode ^
      loginUserGroupPermissions.hashCode ^
      files.hashCode ^
      sharedQuestionId.hashCode ^
      categoryId.hashCode ^
      category.hashCode ^
      subCategoryId.hashCode ^
      subCategory.hashCode ^
      tags.hashCode ^
      answersCount.hashCode ^
      viewsCount.hashCode ^
      usefulCount.hashCode ^
      emphasisCount.hashCode ^
      personId.hashCode ^
      isHealthcareProvider.hashCode ^
      specification.hashCode ^
      createdBy.hashCode ^
      createdByFirstName.hashCode ^
      createdByLastName.hashCode ^
      subSpecification.hashCode ^
      firstName.hashCode ^
      lastName.hashCode ^
      inTouchPointName.hashCode ^
      photoUrl.hashCode ^
      markedAsUseful.hashCode ^
      markedAsEmphasis.hashCode;
  }
}
