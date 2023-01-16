import 'dart:convert';

import 'package:collection/collection.dart';

import '../../common_response/file_response.dart';
import '../../common_response/tag_response.dart';

class GetBlogsResponse {
  String htmlBody;
  List<FileResponse> files;
  int commentsCount;
  int attachmentsCount;
  String title;
  String contentUrl;
  String body;
  String creationDate;
  bool viewToHealthcareProvidersOnly;
  int viewsCount;
  int usefulCount;
  int emphasisCount;
  String categoryId;
  String category;
  String subCategoryId;
  String subCategory;
  List<TagResponse> tags;
  String healthcareProviderId;
  String firstName;
  String lastName;
  String specification;
  String subSpecification;
  String photoUrl;
  bool markedAsUseful;
  bool markedAsEmphasis;
  String id;
  int blogType;
  List<int> loginUserGroupPermissions;
  String groupId;
  String groupName;
  String inTouchPointName;
  GetBlogsResponse({
    this.htmlBody,
    this.files,
    this.commentsCount,
    this.attachmentsCount,
    this.title,
    this.contentUrl,
    this.body,
    this.creationDate,
    this.viewToHealthcareProvidersOnly,
    this.viewsCount,
    this.usefulCount,
    this.emphasisCount,
    this.categoryId,
    this.category,
    this.subCategoryId,
    this.subCategory,
    this.tags,
    this.healthcareProviderId,
    this.firstName,
    this.lastName,
    this.specification,
    this.subSpecification,
    this.photoUrl,
    this.markedAsUseful,
    this.markedAsEmphasis,
    this.id,
    this.blogType,
    this.loginUserGroupPermissions,
    this.groupId,
    this.groupName,
    this.inTouchPointName,
  });

  GetBlogsResponse copyWith({
    String htmlBody,
    List<FileResponse> files,
    int commentsCount,
    int attachmentsCount,
    String title,
    String contentUrl,
    String body,
    String creationDate,
    bool viewToHealthcareProvidersOnly,
    int viewsCount,
    int usefulCount,
    int emphasisCount,
    String categoryId,
    String category,
    String subCategoryId,
    String subCategory,
    List<TagResponse> tags,
    String healthcareProviderId,
    String firstName,
    String lastName,
    String specification,
    String subSpecification,
    String photoUrl,
    bool markedAsUseful,
    bool markedAsEmphasis,
    String id,
    int blogType,
    List<int> loginUserGroupPermissions,
    String groupId,
    String groupName,
    String inTouchPointName,
  }) {
    return GetBlogsResponse(
      htmlBody: htmlBody ?? this.htmlBody,
      files: files ?? this.files,
      commentsCount: commentsCount ?? this.commentsCount,
      attachmentsCount: attachmentsCount ?? this.attachmentsCount,
      title: title ?? this.title,
      contentUrl: contentUrl ?? this.contentUrl,
      body: body ?? this.body,
      creationDate: creationDate ?? this.creationDate,
      viewToHealthcareProvidersOnly:
          viewToHealthcareProvidersOnly ?? this.viewToHealthcareProvidersOnly,
      viewsCount: viewsCount ?? this.viewsCount,
      usefulCount: usefulCount ?? this.usefulCount,
      emphasisCount: emphasisCount ?? this.emphasisCount,
      categoryId: categoryId ?? this.categoryId,
      category: category ?? this.category,
      subCategoryId: subCategoryId ?? this.subCategoryId,
      subCategory: subCategory ?? this.subCategory,
      tags: tags ?? this.tags,
      healthcareProviderId: healthcareProviderId ?? this.healthcareProviderId,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      specification: specification ?? this.specification,
      subSpecification: subSpecification ?? this.subSpecification,
      photoUrl: photoUrl ?? this.photoUrl,
      markedAsUseful: markedAsUseful ?? this.markedAsUseful,
      markedAsEmphasis: markedAsEmphasis ?? this.markedAsEmphasis,
      id: id ?? this.id,
      blogType: blogType ?? this.blogType,
      loginUserGroupPermissions:
          loginUserGroupPermissions ?? this.loginUserGroupPermissions,
      groupId: groupId ?? this.groupId,
      groupName: groupName ?? this.groupName,
      inTouchPointName: inTouchPointName ?? this.inTouchPointName,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'htmlBody': htmlBody,
      'files': files?.map((x) => x?.toMap())?.toList(),
      'commentsCount': commentsCount,
      'attachmentsCount': attachmentsCount,
      'title': title,
      'contentUrl': contentUrl,
      'body': body,
      'creationDate': creationDate,
      'viewToHealthcareProvidersOnly': viewToHealthcareProvidersOnly,
      'viewsCount': viewsCount,
      'usefulCount': usefulCount,
      'emphasisCount': emphasisCount,
      'categoryId': categoryId,
      'category': category,
      'subCategoryId': subCategoryId,
      'subCategory': subCategory,
      'tags': tags?.map((x) => x?.toMap())?.toList(),
      'healthcareProviderId': healthcareProviderId,
      'firstName': firstName,
      'lastName': lastName,
      'specification': specification,
      'subSpecification': subSpecification,
      'photoUrl': photoUrl,
      'markedAsUseful': markedAsUseful,
      'markedAsEmphasis': markedAsEmphasis,
      'id': id,
      'blogType': blogType,
      'loginUserGroupPermissions': loginUserGroupPermissions,
      'groupId': groupId,
      'groupName': groupName,
      'inTouchPointName': inTouchPointName,
    };
  }

  factory GetBlogsResponse.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return GetBlogsResponse(
      htmlBody: map['htmlBody'],
      files: List<FileResponse>.from(
          map['files']?.map((x) => FileResponse.fromMap(x))),
      commentsCount: map['commentsCount'],
      attachmentsCount: map['attachmentsCount'],
      title: map['title'],
      contentUrl: map['contentUrl'],
      body: map['body'],
      creationDate: map['creationDate'],
      viewToHealthcareProvidersOnly: map['viewToHealthcareProvidersOnly'],
      viewsCount: map['viewsCount'],
      usefulCount: map['usefulCount'],
      emphasisCount: map['emphasisCount'],
      categoryId: map['categoryId'],
      category: map['category'],
      subCategoryId: map['subCategoryId'],
      subCategory: map['subCategory'],
      tags: List<TagResponse>.from(
          map['tags']?.map((x) => TagResponse.fromMap(x))),
      healthcareProviderId: map['healthcareProviderId'],
      firstName: map['firstName'],
      lastName: map['lastName'],
      specification: map['specification'],
      subSpecification: map['subSpecification'],
      photoUrl: map['photoUrl'],
      markedAsUseful: map['markedAsUseful'],
      markedAsEmphasis: map['markedAsEmphasis'],
      id: map['id'],
      blogType: map['blogType'],
      loginUserGroupPermissions: map['loginUserGroupPermissions'] != null ?
          List<int>.from(map['loginUserGroupPermissions']) : null,
      groupId: map['groupId'],
      groupName: map['groupName'],
      inTouchPointName: map['inTouchPointName'],
    );
  }

  String toJson() => json.encode(toMap());

  factory GetBlogsResponse.fromJson(String source) =>
      GetBlogsResponse.fromMap(json.decode(source));

  @override
  String toString() {
    return 'GetBlogsResponse(htmlBody: $htmlBody, files: $files, commentsCount: $commentsCount, attachmentsCount: $attachmentsCount, title: $title, contentUrl: $contentUrl, body: $body, creationDate: $creationDate, viewToHealthcareProvidersOnly: $viewToHealthcareProvidersOnly, viewsCount: $viewsCount, usefulCount: $usefulCount, emphasisCount: $emphasisCount, categoryId: $categoryId, category: $category, subCategoryId: $subCategoryId, subCategory: $subCategory, tags: $tags, healthcareProviderId: $healthcareProviderId, firstName: $firstName, lastName: $lastName, specification: $specification, subSpecification: $subSpecification, photoUrl: $photoUrl, markedAsUseful: $markedAsUseful, markedAsEmphasis: $markedAsEmphasis, id: $id, blogType: $blogType, loginUserGroupPermissions: $loginUserGroupPermissions, groupId: $groupId, groupName: $groupName, inTouchPointName: $inTouchPointName)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;
    final listEquals = const DeepCollectionEquality().equals;

    return o is GetBlogsResponse &&
        o.htmlBody == htmlBody &&
        listEquals(o.files, files) &&
        o.commentsCount == commentsCount &&
        o.attachmentsCount == attachmentsCount &&
        o.title == title &&
        o.contentUrl == contentUrl &&
        o.body == body &&
        o.creationDate == creationDate &&
        o.viewToHealthcareProvidersOnly == viewToHealthcareProvidersOnly &&
        o.viewsCount == viewsCount &&
        o.usefulCount == usefulCount &&
        o.emphasisCount == emphasisCount &&
        o.categoryId == categoryId &&
        o.category == category &&
        o.subCategoryId == subCategoryId &&
        o.subCategory == subCategory &&
        listEquals(o.tags, tags) &&
        o.healthcareProviderId == healthcareProviderId &&
        o.firstName == firstName &&
        o.lastName == lastName &&
        o.specification == specification &&
        o.subSpecification == subSpecification &&
        o.photoUrl == photoUrl &&
        o.markedAsUseful == markedAsUseful &&
        o.markedAsEmphasis == markedAsEmphasis &&
        o.id == id &&
        o.blogType == blogType &&
        listEquals(o.loginUserGroupPermissions, loginUserGroupPermissions) &&
        o.groupId == groupId &&
        o.groupName == groupName &&
        o.inTouchPointName == inTouchPointName;
  }

  @override
  int get hashCode {
    return htmlBody.hashCode ^
        files.hashCode ^
        commentsCount.hashCode ^
        attachmentsCount.hashCode ^
        title.hashCode ^
        contentUrl.hashCode ^
        body.hashCode ^
        creationDate.hashCode ^
        viewToHealthcareProvidersOnly.hashCode ^
        viewsCount.hashCode ^
        usefulCount.hashCode ^
        emphasisCount.hashCode ^
        categoryId.hashCode ^
        category.hashCode ^
        subCategoryId.hashCode ^
        subCategory.hashCode ^
        tags.hashCode ^
        healthcareProviderId.hashCode ^
        firstName.hashCode ^
        lastName.hashCode ^
        specification.hashCode ^
        subSpecification.hashCode ^
        photoUrl.hashCode ^
        markedAsUseful.hashCode ^
        markedAsEmphasis.hashCode ^
        id.hashCode ^
        blogType.hashCode ^
        loginUserGroupPermissions.hashCode ^
        groupId.hashCode ^
        groupName.hashCode ^
        inTouchPointName.hashCode;
  }
}
