import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:arachnoit/infrastructure/common_response/file_response.dart';

class ActionAnswerResponse {
  String questionId;
  String body;
  List<FileResponse> files;
  List<String> removedFiles;
  String id;
  bool isValid;
  ActionAnswerResponse({
    @required this.questionId,
    @required this.body,
    @required this.files,
    @required this.removedFiles,
    @required this.id,
    @required this.isValid,
  });

  ActionAnswerResponse copyWith({
    String questionId,
    String body,
    List<FileResponse> files,
    List<String> removedFiles,
    String id,
    bool isValid,
  }) {
    return ActionAnswerResponse(
      questionId: questionId ?? this.questionId,
      body: body ?? this.body,
      files: files ?? this.files,
      removedFiles: removedFiles ?? this.removedFiles,
      id: id ?? this.id,
      isValid: isValid ?? this.isValid,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'questionId': questionId,
      'body': body,
      'files': files?.map((x) => x.toMap())?.toList(),
      'removedFiles': removedFiles,
      'id': id,
      'isValid': isValid,
    };
  }

  factory ActionAnswerResponse.fromMap(Map<String, dynamic> map) {
    return ActionAnswerResponse(
      questionId: map['questionId'],
      body: map['body'],
      files: map['files'] != null
          ? List<FileResponse>.from(
              map['files']?.map((x) => FileResponse.fromMap(x)))
          : null,
      removedFiles: map['removedFiles'] != null
          ? List<String>.from(map['removedFiles'])
          : null,
      id: map['id'],
      isValid: map['isValid'],
    );
  }

  String toJson() => json.encode(toMap());

  factory ActionAnswerResponse.fromJson(String source) =>
      ActionAnswerResponse.fromMap(json.decode(source));

  @override
  String toString() {
    return 'ActionAnswerResponse(questionId: $questionId, body: $body, files: $files, removedFiles: $removedFiles, id: $id, isValid: $isValid)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ActionAnswerResponse &&
        other.questionId == questionId &&
        other.body == body &&
        listEquals(other.files, files) &&
        listEquals(other.removedFiles, removedFiles) &&
        other.id == id &&
        other.isValid == isValid;
  }

  @override
  int get hashCode {
    return questionId.hashCode ^
        body.hashCode ^
        files.hashCode ^
        removedFiles.hashCode ^
        id.hashCode ^
        isValid.hashCode;
  }
}
