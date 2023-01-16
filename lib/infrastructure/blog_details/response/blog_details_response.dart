import 'dart:convert';

import 'package:flutter/foundation.dart';

import '../../common_response/blog_comment_response.dart';
import '../../common_response/file_response.dart';
import '../../common_response/tag_response.dart';

class BlogDetailsResponse {
  int blogVisibility;
  List<FileResponse> files;
  List<CommentResponse> comments;
  String title;
  String body;
  int blogType;
  String groupOwnerId;
  int privacyLevel;
  String creationDate;
  String groupId;
  String groupName;
  List<int> loginUserGroupPermissions;
  bool viewToHealthcareProvidersOnly;
  String sharedBlogId;
  int viewsCount;
  int usefulCount;
  int emphasisCount;
  String categoryId;
  String category;
  String subCategoryId;
  String subCategory;
  List<TagResponse> tags;
  String createdBy;
  String createdByFirstName;
  String createdByLastName;
  String healthcareProviderId;
  String firstName;
  String lastName;
  String inTouchPointName;
  String specification;
  String subSpecification;
  String photoUrl;
  bool markedAsUseful;
  bool markedAsEmphasis;
  String id;
  bool isValid;
  BlogDetailsResponse({
    this.blogVisibility,
    this.files,
    this.comments,
    this.title,
    this.body,
    this.blogType,
    this.groupOwnerId,
    this.privacyLevel,
    this.creationDate,
    this.groupId,
    this.groupName,
    this.loginUserGroupPermissions,
    this.viewToHealthcareProvidersOnly,
    this.sharedBlogId,
    this.viewsCount,
    this.usefulCount,
    this.emphasisCount,
    this.categoryId,
    this.category,
    this.subCategoryId,
    this.subCategory,
    this.tags,
    this.createdBy,
    this.createdByFirstName,
    this.createdByLastName,
    this.healthcareProviderId,
    this.firstName,
    this.lastName,
    this.inTouchPointName,
    this.specification,
    this.subSpecification,
    this.photoUrl,
    this.markedAsUseful,
    this.markedAsEmphasis,
    this.id,
    this.isValid,
  });

  BlogDetailsResponse copyWith({
    int blogVisibility,
    List<FileResponse> files,
    List<CommentResponse> comments,
    String title,
    String body,
    int blogType,
    String groupOwnerId,
    int privacyLevel,
    String creationDate,
    String groupId,
    String groupName,
    List<int> loginUserGroupPermissions,
    bool viewToHealthcareProvidersOnly,
    String sharedBlogId,
    int viewsCount,
    int usefulCount,
    int emphasisCount,
    String categoryId,
    String category,
    String subCategoryId,
    String subCategory,
    List<TagResponse> tags,
    String createdBy,
    String createdByFirstName,
    String createdByLastName,
    String healthcareProviderId,
    String firstName,
    String lastName,
    String inTouchPointName,
    String specification,
    String subSpecification,
    String photoUrl,
    bool markedAsUseful,
    bool markedAsEmphasis,
    String id,
    bool isValid,
  }) {
    return BlogDetailsResponse(
      blogVisibility: blogVisibility ?? this.blogVisibility,
      files: files ?? this.files,
      comments: comments ?? this.comments,
      title: title ?? this.title,
      body: body ?? this.body,
      blogType: blogType ?? this.blogType,
      groupOwnerId: groupOwnerId ?? this.groupOwnerId,
      privacyLevel: privacyLevel ?? this.privacyLevel,
      creationDate: creationDate ?? this.creationDate,
      groupId: groupId ?? this.groupId,
      groupName: groupName ?? this.groupName,
      loginUserGroupPermissions: loginUserGroupPermissions ?? this.loginUserGroupPermissions,
      viewToHealthcareProvidersOnly: viewToHealthcareProvidersOnly ?? this.viewToHealthcareProvidersOnly,
      sharedBlogId: sharedBlogId ?? this.sharedBlogId,
      viewsCount: viewsCount ?? this.viewsCount,
      usefulCount: usefulCount ?? this.usefulCount,
      emphasisCount: emphasisCount ?? this.emphasisCount,
      categoryId: categoryId ?? this.categoryId,
      category: category ?? this.category,
      subCategoryId: subCategoryId ?? this.subCategoryId,
      subCategory: subCategory ?? this.subCategory,
      tags: tags ?? this.tags,
      createdBy: createdBy ?? this.createdBy,
      createdByFirstName: createdByFirstName ?? this.createdByFirstName,
      createdByLastName: createdByLastName ?? this.createdByLastName,
      healthcareProviderId: healthcareProviderId ?? this.healthcareProviderId,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      inTouchPointName: inTouchPointName ?? this.inTouchPointName,
      specification: specification ?? this.specification,
      subSpecification: subSpecification ?? this.subSpecification,
      photoUrl: photoUrl ?? this.photoUrl,
      markedAsUseful: markedAsUseful ?? this.markedAsUseful,
      markedAsEmphasis: markedAsEmphasis ?? this.markedAsEmphasis,
      id: id ?? this.id,
      isValid: isValid ?? this.isValid,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'blogVisibility': blogVisibility,
      'files': files?.map((x) => x?.toMap())?.toList(),
      'comments': comments?.map((x) => x?.toMap())?.toList(),
      'title': title,
      'body': body,
      'blogType': blogType,
      'groupOwnerId': groupOwnerId,
      'privacyLevel': privacyLevel,
      'creationDate': creationDate,
      'groupId': groupId,
      'groupName': groupName,
      'loginUserGroupPermissions': loginUserGroupPermissions,
      'viewToHealthcareProvidersOnly': viewToHealthcareProvidersOnly,
      'sharedBlogId': sharedBlogId,
      'viewsCount': viewsCount,
      'usefulCount': usefulCount,
      'emphasisCount': emphasisCount,
      'categoryId': categoryId,
      'category': category,
      'subCategoryId': subCategoryId,
      'subCategory': subCategory,
      'tags': tags?.map((x) => x?.toMap())?.toList(),
      'createdBy': createdBy,
      'createdByFirstName': createdByFirstName,
      'createdByLastName': createdByLastName,
      'healthcareProviderId': healthcareProviderId,
      'firstName': firstName,
      'lastName': lastName,
      'inTouchPointName': inTouchPointName,
      'specification': specification,
      'subSpecification': subSpecification,
      'photoUrl': photoUrl,
      'markedAsUseful': markedAsUseful,
      'markedAsEmphasis': markedAsEmphasis,
      'id': id,
      'isValid': isValid,
    };
  }

  factory BlogDetailsResponse.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
  
    return BlogDetailsResponse(
      blogVisibility: map['blogVisibility'],
      files: List<FileResponse>.from(map['files']?.map((x) => FileResponse.fromMap(x))),
      comments: List<CommentResponse>.from(map['comments']?.map((x) => CommentResponse.fromMap(x))),
      title: map['title'],
      body: map['body'],
      blogType: map['blogType'],
      groupOwnerId: map['groupOwnerId'],
      privacyLevel: map['privacyLevel'],
      creationDate: map['creationDate'],
      groupId: map['groupId'],
      groupName: map['groupName'],
      loginUserGroupPermissions:  map['loginUserGroupPermissions'] != null ?
          List<int>.from(map['loginUserGroupPermissions']) : null,
      viewToHealthcareProvidersOnly: map['viewToHealthcareProvidersOnly'],
      sharedBlogId: map['sharedBlogId'],
      viewsCount: map['viewsCount'],
      usefulCount: map['usefulCount'],
      emphasisCount: map['emphasisCount'],
      categoryId: map['categoryId'],
      category: map['category'],
      subCategoryId: map['subCategoryId'],
      subCategory: map['subCategory'],
      tags: List<TagResponse>.from(map['tags']?.map((x) => TagResponse.fromMap(x))),
      createdBy: map['createdBy'],
      createdByFirstName: map['createdByFirstName'],
      createdByLastName: map['createdByLastName'],
      healthcareProviderId: map['healthcareProviderId'],
      firstName: map['firstName'],
      lastName: map['lastName'],
      inTouchPointName: map['inTouchPointName'],
      specification: map['specification'],
      subSpecification: map['subSpecification'],
      photoUrl: map['photoUrl'],
      markedAsUseful: map['markedAsUseful'],
      markedAsEmphasis: map['markedAsEmphasis'],
      id: map['id'],
      isValid: map['isValid'],
    );
  }

  String toJson() => json.encode(toMap());

  factory BlogDetailsResponse.fromJson(String source) => BlogDetailsResponse.fromMap(json.decode(source));

  @override
  String toString() {
    return 'BlogDetailsResponse(blogVisibility: $blogVisibility, files: $files, comments: $comments, title: $title, body: $body, blogType: $blogType, groupOwnerId: $groupOwnerId, privacyLevel: $privacyLevel, creationDate: $creationDate, groupId: $groupId, groupName: $groupName, loginUserGroupPermissions: $loginUserGroupPermissions, viewToHealthcareProvidersOnly: $viewToHealthcareProvidersOnly, sharedBlogId: $sharedBlogId, viewsCount: $viewsCount, usefulCount: $usefulCount, emphasisCount: $emphasisCount, categoryId: $categoryId, category: $category, subCategoryId: $subCategoryId, subCategory: $subCategory, tags: $tags, createdBy: $createdBy, createdByFirstName: $createdByFirstName, createdByLastName: $createdByLastName, healthcareProviderId: $healthcareProviderId, firstName: $firstName, lastName: $lastName, inTouchPointName: $inTouchPointName, specification: $specification, subSpecification: $subSpecification, photoUrl: $photoUrl, markedAsUseful: $markedAsUseful, markedAsEmphasis: $markedAsEmphasis, id: $id, isValid: $isValid)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;
  
    return o is BlogDetailsResponse &&
      o.blogVisibility == blogVisibility &&
      listEquals(o.files, files) &&
      listEquals(o.comments, comments) &&
      o.title == title &&
      o.body == body &&
      o.blogType == blogType &&
      o.groupOwnerId == groupOwnerId &&
      o.privacyLevel == privacyLevel &&
      o.creationDate == creationDate &&
      o.groupId == groupId &&
      o.groupName == groupName &&
      listEquals(o.loginUserGroupPermissions, loginUserGroupPermissions) &&
      o.viewToHealthcareProvidersOnly == viewToHealthcareProvidersOnly &&
      o.sharedBlogId == sharedBlogId &&
      o.viewsCount == viewsCount &&
      o.usefulCount == usefulCount &&
      o.emphasisCount == emphasisCount &&
      o.categoryId == categoryId &&
      o.category == category &&
      o.subCategoryId == subCategoryId &&
      o.subCategory == subCategory &&
      listEquals(o.tags, tags) &&
      o.createdBy == createdBy &&
      o.createdByFirstName == createdByFirstName &&
      o.createdByLastName == createdByLastName &&
      o.healthcareProviderId == healthcareProviderId &&
      o.firstName == firstName &&
      o.lastName == lastName &&
      o.inTouchPointName == inTouchPointName &&
      o.specification == specification &&
      o.subSpecification == subSpecification &&
      o.photoUrl == photoUrl &&
      o.markedAsUseful == markedAsUseful &&
      o.markedAsEmphasis == markedAsEmphasis &&
      o.id == id &&
      o.isValid == isValid;
  }

  @override
  int get hashCode {
    return blogVisibility.hashCode ^
      files.hashCode ^
      comments.hashCode ^
      title.hashCode ^
      body.hashCode ^
      blogType.hashCode ^
      groupOwnerId.hashCode ^
      privacyLevel.hashCode ^
      creationDate.hashCode ^
      groupId.hashCode ^
      groupName.hashCode ^
      loginUserGroupPermissions.hashCode ^
      viewToHealthcareProvidersOnly.hashCode ^
      sharedBlogId.hashCode ^
      viewsCount.hashCode ^
      usefulCount.hashCode ^
      emphasisCount.hashCode ^
      categoryId.hashCode ^
      category.hashCode ^
      subCategoryId.hashCode ^
      subCategory.hashCode ^
      tags.hashCode ^
      createdBy.hashCode ^
      createdByFirstName.hashCode ^
      createdByLastName.hashCode ^
      healthcareProviderId.hashCode ^
      firstName.hashCode ^
      lastName.hashCode ^
      inTouchPointName.hashCode ^
      specification.hashCode ^
      subSpecification.hashCode ^
      photoUrl.hashCode ^
      markedAsUseful.hashCode ^
      markedAsEmphasis.hashCode ^
      id.hashCode ^
      isValid.hashCode;
  }
}
