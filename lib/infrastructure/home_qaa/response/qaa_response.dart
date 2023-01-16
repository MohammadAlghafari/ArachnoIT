import 'dart:convert';

import 'package:arachnoit/infrastructure/common_response/sub_category_response.dart';
import 'package:flutter/foundation.dart';

import 'package:arachnoit/infrastructure/common_response/file_response.dart';
import 'package:arachnoit/infrastructure/common_response/tag_response.dart';

class QaaResponse {
  int attachmentsCount;
  String coverUrl;
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
  List<SubCategoryResponse> subCategories;
  QaaResponse({
    this.attachmentsCount,
    this.coverUrl,
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
    this.subCategories = const <SubCategoryResponse>[],
  });

  QaaResponse copyWith({
    int attachmentsCount,
    String coverUrl,
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
    List<SubCategoryResponse> subCategories,
  }) {
    return QaaResponse(
        attachmentsCount: attachmentsCount ?? this.attachmentsCount,
        coverUrl: coverUrl ?? this.coverUrl,
        questionId: questionId ?? this.questionId,
        questionTitle: questionTitle ?? this.questionTitle,
        questionBody: questionBody ?? this.questionBody,
        htmlBody: htmlBody ?? this.htmlBody,
        creationDate: creationDate ?? this.creationDate,
        groupId: groupId ?? this.groupId,
        groupName: groupName ?? this.groupName,
        groupPrivacyLevel: groupPrivacyLevel ?? this.groupPrivacyLevel,
        askAnonymously: askAnonymously ?? this.askAnonymously,
        viewToHealthcareProvidersOnly:
            viewToHealthcareProvidersOnly ?? this.viewToHealthcareProvidersOnly,
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
        subCategories: subCategories ?? this.subCategories);
  }

  Map<String, dynamic> toMap() {
    return {
      'attachmentsCount': attachmentsCount,
      'coverUrl': coverUrl,
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
      "subCategories":subCategories!=null? subCategories?.map((x) => x?.toMap())?.toList():[],
    };
  }

  factory QaaResponse.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return QaaResponse(
      attachmentsCount: map['attachmentsCount'],
      coverUrl: map['coverUrl'],
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
      loginUserGroupPermissions: map['loginUserGroupPermissions'] != null
          ? List<int>.from(map['loginUserGroupPermissions'])
          : null,
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
      subCategories:map['subCategories']!=null? List<SubCategoryResponse>.from(map['subCategories']?.map((x) => SubCategoryResponse.fromMap(x))):[],
    );
  }

  String toJson() => json.encode(toMap());

  factory QaaResponse.fromJson(String source) => QaaResponse.fromMap(json.decode(source));

  @override
  String toString() {
    return 'QaaResponse(attachmentsCount: $attachmentsCount, coverUrl: $coverUrl, questionId: $questionId, questionTitle: $questionTitle, questionBody: $questionBody, htmlBody: $htmlBody, creationDate: $creationDate, groupId: $groupId, groupName: $groupName, groupPrivacyLevel: $groupPrivacyLevel, askAnonymously: $askAnonymously, viewToHealthcareProvidersOnly: $viewToHealthcareProvidersOnly, loginUserGroupPermissions: $loginUserGroupPermissions, files: $files, sharedQuestionId: $sharedQuestionId, categoryId: $categoryId, category: $category, subCategoryId: $subCategoryId, subCategory: $subCategory, tags: $tags, answersCount: $answersCount, viewsCount: $viewsCount, usefulCount: $usefulCount, emphasisCount: $emphasisCount, personId: $personId, isHealthcareProvider: $isHealthcareProvider, specification: $specification, createdBy: $createdBy, createdByFirstName: $createdByFirstName, createdByLastName: $createdByLastName, subSpecification: $subSpecification, firstName: $firstName, lastName: $lastName, inTouchPointName: $inTouchPointName, photoUrl: $photoUrl, markedAsUseful: $markedAsUseful, markedAsEmphasis: $markedAsEmphasis)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is QaaResponse &&
        o.attachmentsCount == attachmentsCount &&
        o.coverUrl == coverUrl &&
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
    return attachmentsCount.hashCode ^
        coverUrl.hashCode ^
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
