// To parse this JSON data, do
//
//     final newProjectResponse = newProjectResponseFromJson(jsonString);

import 'dart:convert';

import 'package:arachnoit/infrastructure/common_response/attachment_response.dart';

NewProjectResponse newProjectResponseFromJson(String str) => NewProjectResponse.fromJson(json.decode(str));

String newProjectResponseToJson(NewProjectResponse data) => json.encode(data.toJson());

class NewProjectResponse {
    NewProjectResponse({
        this.name,
        this.startDate,
        this.endDate,
        this.url,
        this.description,
        this.files,
        this.removedFiles,
        this.id,
        this.isValid,
    });

    String name;
    DateTime startDate;
    DateTime endDate;
    String url;
    String description;
    List<AttachmentResponse> files;
    List<String> removedFiles;
    String id;
    bool isValid;

    factory NewProjectResponse.fromJson(Map<String, dynamic> json) => NewProjectResponse(
        name: json["name"] == null ? null : json["name"],
        startDate: json["startDate"] == null ? null : DateTime.parse(json["startDate"]),
        endDate: json["endDate"] == null ? null : DateTime.parse(json["endDate"]),
        url: json["url"] == null ? null : json["url"],
        description: json["description"] == null ? null : json["description"],
        files: json["files"] == null ? null : List<AttachmentResponse>.from(json["files"].map((x) => AttachmentResponse.fromJson(x))),
        removedFiles: json["removedFiles"] == null ? null : List<String>.from(json["removedFiles"].map((x) => x)),
        id: json["id"] == null ? null : json["id"],
        isValid: json["isValid"] == null ? null : json["isValid"],
    );

    Map<String, dynamic> toJson() => {
        "name": name == null ? null : name,
        "startDate": startDate == null ? null : startDate.toIso8601String(),
        "endDate": endDate == null ? null : endDate.toIso8601String(),
        "url": url == null ? null : url,
        "description": description == null ? null : description,
        "files": files == null ? null : List<dynamic>.from(files.map((x) => x.toJson())),
        "removedFiles": removedFiles == null ? null : List<dynamic>.from(removedFiles.map((x) => x)),
        "id": id == null ? null : id,
        "isValid": isValid == null ? null : isValid,
    };
}
