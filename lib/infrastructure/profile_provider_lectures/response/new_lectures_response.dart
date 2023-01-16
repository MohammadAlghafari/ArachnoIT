// To parse this JSON data, do
//
//     final newLecturesResponse = newLecturesResponseFromJson(jsonString);

import 'dart:convert';

import 'package:arachnoit/infrastructure/common_response/attachment_response.dart';

NewLecturesResponse newLecturesResponseFromJson(String str) => NewLecturesResponse.fromJson(json.decode(str));

String newLecturesResponseToJson(NewLecturesResponse data) => json.encode(data.toJson());

class NewLecturesResponse {
    NewLecturesResponse({
        this.title,
        this.description,
        this.files,
        this.removedFiles,
        this.id,
        this.isValid,
    });

    String title;
    String description;
    List<AttachmentResponse>files;
    List<String> removedFiles;
    String id;
    bool isValid;

    factory NewLecturesResponse.fromJson(Map<String, dynamic> json) => NewLecturesResponse(
        title: json["title"] == null ? null : json["title"],
        description: json["description"] == null ? null : json["description"],
        files: json["files"] == null ? null : List<AttachmentResponse>.from(json["files"].map((x) => AttachmentResponse.fromJson(x))),
        removedFiles: json["removedFiles"] == null ? null : List<String>.from(json["removedFiles"].map((x) => x)),
        id: json["id"] == null ? null : json["id"],
        isValid: json["isValid"] == null ? null : json["isValid"],
    );

    Map<String, dynamic> toJson() => {
        "title": title == null ? null : title,
        "description": description == null ? null : description,
        "files": files == null ? null : List<dynamic>.from(files.map((x) => x.toJson())),
        "removedFiles": removedFiles == null ? null : List<dynamic>.from(removedFiles.map((x) => x)),
        "id": id == null ? null : id,
        "isValid": isValid == null ? null : isValid,
    };
}
