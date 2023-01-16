import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:arachnoit/infrastructure/common_response/file_response.dart';

class AddBlogResponse {
 String title;
 String body;
 int blogType;
 bool viewToHealthcareProvidersOnly;
 String subCategoryId;
 List<String> blogTags;
 bool publishbyCreator;
 int blogVisibility;
 String groupId;
 String sharedBlogId;
 List<FileResponse> files;
 List<String> removedFiles;
 String id;
 bool isValid;
  AddBlogResponse({
    @required this.title,
    @required this.body,
    @required this.blogType,
    @required this.viewToHealthcareProvidersOnly,
    @required this.subCategoryId,
    @required this.blogTags,
    @required this.publishbyCreator,
    @required this.blogVisibility,
    @required this.groupId,
    @required this.sharedBlogId,
    @required this.files,
    @required this.removedFiles,
    @required this.id,
    @required this.isValid,
  });

  AddBlogResponse copyWith({
    String title,
    String body,
    int blogType,
    bool viewToHealthcareProvidersOnly,
    String subCategoryId,
    List<String> blogTags,
    bool publishbyCreator,
    int blogVisibility,
    String groupId,
    String sharedBlogId,
    List<FileResponse> files,
    List<String> removedFiles,
    String id,
    bool isValid,
  }) {
    return AddBlogResponse(
      title: title ?? this.title,
      body: body ?? this.body,
      blogType: blogType ?? this.blogType,
      viewToHealthcareProvidersOnly: viewToHealthcareProvidersOnly ?? this.viewToHealthcareProvidersOnly,
      subCategoryId: subCategoryId ?? this.subCategoryId,
      blogTags: blogTags ?? this.blogTags,
      publishbyCreator: publishbyCreator ?? this.publishbyCreator,
      blogVisibility: blogVisibility ?? this.blogVisibility,
      groupId: groupId ?? this.groupId,
      sharedBlogId: sharedBlogId ?? this.sharedBlogId,
      files: files ?? this.files,
      removedFiles: removedFiles ?? this.removedFiles,
      id: id ?? this.id,
      isValid: isValid ?? this.isValid,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'body': body,
      'blogType': blogType,
      'viewToHealthcareProvidersOnly': viewToHealthcareProvidersOnly,
      'subCategoryId': subCategoryId,
      'blogTags': blogTags,
      'publishbyCreator': publishbyCreator,
      'blogVisibility': blogVisibility,
      'groupId': groupId,
      'sharedBlogId': sharedBlogId,
      "files": files == null ? null : List<dynamic>.from(files.map((x) => x.toMap())),
      'removedFiles': removedFiles,
      'id': id,
      'isValid': isValid,
    };
  }

  factory AddBlogResponse.fromMap(Map<String, dynamic> map) {
    return AddBlogResponse(
      title: map['title'],
      body: map['body'],
      blogType: map['blogType'],
      viewToHealthcareProvidersOnly: map['viewToHealthcareProvidersOnly'],
      subCategoryId: map['subCategoryId'],
      blogTags: null,
      publishbyCreator: map['publishbyCreator'],
      blogVisibility: map['blogVisibility'],
      groupId: map['groupId'],
      sharedBlogId: map['sharedBlogId'],
      files: map["files"] == null ? null : List<FileResponse>.from(map["files"].map((x) => FileResponse.fromMap(x))),
      removedFiles: null,
      id: map['id'],
      isValid: map['isValid'],
    );
  }

  String toJson() => json.encode(toMap());

  factory AddBlogResponse.fromJson(String source) => AddBlogResponse.fromMap(json.decode(source));

  @override
  String toString() {
    return 'AddBlogResponse(title: $title, body: $body, blogType: $blogType, viewToHealthcareProvidersOnly: $viewToHealthcareProvidersOnly, subCategoryId: $subCategoryId, blogTags: $blogTags, publishbyCreator: $publishbyCreator, blogVisibility: $blogVisibility, groupId: $groupId, sharedBlogId: $sharedBlogId, files: $files, removedFiles: $removedFiles, id: $id, isValid: $isValid)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is AddBlogResponse &&
      other.title == title &&
      other.body == body &&
      other.blogType == blogType &&
      other.viewToHealthcareProvidersOnly == viewToHealthcareProvidersOnly &&
      other.subCategoryId == subCategoryId &&
      listEquals(other.blogTags, blogTags) &&
      other.publishbyCreator == publishbyCreator &&
      other.blogVisibility == blogVisibility &&
      other.groupId == groupId &&
      other.sharedBlogId == sharedBlogId &&
      listEquals(other.files, files) &&
      listEquals(other.removedFiles, removedFiles) &&
      other.id == id &&
      other.isValid == isValid;
  }

  @override
  int get hashCode {
    return title.hashCode ^
      body.hashCode ^
      blogType.hashCode ^
      viewToHealthcareProvidersOnly.hashCode ^
      subCategoryId.hashCode ^
      blogTags.hashCode ^
      publishbyCreator.hashCode ^
      blogVisibility.hashCode ^
      groupId.hashCode ^
      sharedBlogId.hashCode ^
      files.hashCode ^
      removedFiles.hashCode ^
      id.hashCode ^
      isValid.hashCode;
  }
}
