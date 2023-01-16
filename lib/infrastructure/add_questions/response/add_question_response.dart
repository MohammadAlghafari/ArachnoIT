import 'dart:convert';

import 'package:arachnoit/infrastructure/common_response/file_response.dart';
import 'package:flutter/foundation.dart';

class AddQuestionResponse {
  String title;
  String body;
  bool viewToHealthcareProvidersOnly;
  bool askAnonymously;
  String subCategoryId;
  List<String> questionTags;
  List<String> tags;
  bool publishbyCreator;
  int questionVisibility;
  String groupId;
  String sharedQuestionId;
  List<FileResponse> files;
  List<String> removedFiles;
  String id;
  bool isValid;
  AddQuestionResponse({
    @required this.title,
    @required this.body,
    @required this.viewToHealthcareProvidersOnly,
    @required this.askAnonymously,
    @required this.subCategoryId,
    @required this.questionTags,
    @required this.tags,
    @required this.publishbyCreator,
    @required this.questionVisibility,
    @required this.groupId,
    @required this.sharedQuestionId,
    @required this.files,
    @required this.removedFiles,
    @required this.id,
    @required this.isValid,
  });

  AddQuestionResponse copyWith({
    String title,
    String body,
    bool viewToHealthcareProvidersOnly,
    bool askAnonymously,
    String subCategoryId,
    List<String> questionTags,
    List<String> tags,
    bool publishbyCreator,
    int questionVisibility,
    String groupId,
    String sharedQuestionId,
    List<FileResponse> files,
    List<String> removedFiles,
    String id,
    bool isValid,
  }) {
    return AddQuestionResponse(
      title: title ?? this.title,
      body: body ?? this.body,
      viewToHealthcareProvidersOnly:
          viewToHealthcareProvidersOnly ?? this.viewToHealthcareProvidersOnly,
      askAnonymously: askAnonymously ?? this.askAnonymously,
      subCategoryId: subCategoryId ?? this.subCategoryId,
      questionTags: questionTags ?? this.questionTags,
      tags: tags ?? this.tags,
      publishbyCreator: publishbyCreator ?? this.publishbyCreator,
      questionVisibility: questionVisibility ?? this.questionVisibility,
      groupId: groupId ?? this.groupId,
      sharedQuestionId: sharedQuestionId ?? this.sharedQuestionId,
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
      'viewToHealthcareProvidersOnly': viewToHealthcareProvidersOnly,
      'askAnonymously': askAnonymously,
      'subCategoryId': subCategoryId,
      'questionTags': questionTags,
      'tags': tags,
      'publishbyCreator': publishbyCreator,
      'questionVisibility': questionVisibility,
      'groupId': groupId,
      'sharedQuestionId': sharedQuestionId,
      'files': files?.map((x) => x?.toMap())?.toList(),
      'removedFiles': removedFiles,
      'id': id,
      'isValid': isValid,
    };
  }

  factory AddQuestionResponse.fromMap(Map<String, dynamic> map) {
    return AddQuestionResponse(
      title: map['title'],
      body: map['body'],
      viewToHealthcareProvidersOnly: map['viewToHealthcareProvidersOnly'],
      askAnonymously: map['askAnonymously'],
      subCategoryId: map['subCategoryId'],
      questionTags: null,
      tags: null,
      publishbyCreator: map['publishbyCreator'],
      questionVisibility: map['questionVisibility'],
      groupId: map['groupId'],
      sharedQuestionId: map['sharedQuestionId'],
      files: null,
      removedFiles: null,
      id: map['id'],
      isValid: map['isValid'],
    );
  }

  String toJson() => json.encode(toMap());

  factory AddQuestionResponse.fromJson(String source) =>
      AddQuestionResponse.fromMap(json.decode(source));

  @override
  String toString() {
    return 'AddQuestionResponse(title: $title, body: $body, viewToHealthcareProvidersOnly: $viewToHealthcareProvidersOnly, askAnonymously: $askAnonymously, subCategoryId: $subCategoryId, questionTags: $questionTags, tags: $tags, publishbyCreator: $publishbyCreator, questionVisibility: $questionVisibility, groupId: $groupId, sharedQuestionId: $sharedQuestionId, files: $files, removedFiles: $removedFiles, id: $id, isValid: $isValid)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AddQuestionResponse &&
        other.title == title &&
        other.body == body &&
        other.viewToHealthcareProvidersOnly == viewToHealthcareProvidersOnly &&
        other.askAnonymously == askAnonymously &&
        other.subCategoryId == subCategoryId &&
        listEquals(other.questionTags, questionTags) &&
        listEquals(other.tags, tags) &&
        other.publishbyCreator == publishbyCreator &&
        other.questionVisibility == questionVisibility &&
        other.groupId == groupId &&
        other.sharedQuestionId == sharedQuestionId &&
        listEquals(other.files, files) &&
        listEquals(other.removedFiles, removedFiles) &&
        other.id == id &&
        other.isValid == isValid;
  }

  @override
  int get hashCode {
    return title.hashCode ^
        body.hashCode ^
        viewToHealthcareProvidersOnly.hashCode ^
        askAnonymously.hashCode ^
        subCategoryId.hashCode ^
        questionTags.hashCode ^
        tags.hashCode ^
        publishbyCreator.hashCode ^
        questionVisibility.hashCode ^
        groupId.hashCode ^
        sharedQuestionId.hashCode ^
        files.hashCode ^
        removedFiles.hashCode ^
        id.hashCode ^
        isValid.hashCode;
  }
}
