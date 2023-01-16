// To parse this JSON data, do
//
//     final newEducationResponse = newEducationResponseFromJson(jsonString);

import 'dart:convert';

import '../../common_response/attachment_response.dart';

NewEducationResponse newEducationResponseFromJson(String str) => NewEducationResponse.fromJson(json.decode(str));

String newEducationResponseToJson(NewEducationResponse data) => json.encode(data.toJson());

class NewEducationResponse {
    NewEducationResponse({
        this.school,
        this.degree,
        this.fieldOfStudy,
        this.startDate,
        this.endDate,
        this.grade,
        this.description,
        this.link,
        this.files,
        this.removedFiles,
        this.id,
        this.isValid,
    });

    String school;
    String degree;
    String fieldOfStudy;
    DateTime startDate;
    DateTime endDate;
    String grade;
    String description;
    String link;
    List<AttachmentResponse> files;
    List<String> removedFiles;
    String id;
    bool isValid;

    factory NewEducationResponse.fromJson(Map<String, dynamic> json) => NewEducationResponse(
        school: json["school"] == null ? null : json["school"],
        degree: json["degree"] == null ? null : json["degree"],
        fieldOfStudy: json["fieldOfStudy"] == null ? null : json["fieldOfStudy"],
        startDate: json["startDate"] == null ? null : DateTime.parse(json["startDate"]),
        endDate: json["endDate"] == null ? null : DateTime.parse(json["endDate"]),
        grade: json["grade"] == null ? null : json["grade"],
        description: json["description"] == null ? null : json["description"],
        link: json["link"] == null ? null : json["link"],
        files: json["files"] == null ? null : List<AttachmentResponse>.from(json["files"].map((x) => AttachmentResponse.fromJson(x))),
        removedFiles: json["removedFiles"] == null ? null : List<String>.from(json["removedFiles"].map((x) => x)),
        id: json["id"] == null ? null : json["id"],
        isValid: json["isValid"] == null ? null : json["isValid"],
    );

    Map<String, dynamic> toJson() => {
        "school": school == null ? null : school,
        "degree": degree == null ? null : degree,
        "fieldOfStudy": fieldOfStudy == null ? null : fieldOfStudy,
        "startDate": startDate == null ? null : startDate.toIso8601String(),
        "endDate": endDate == null ? null : endDate.toIso8601String(),
        "grade": grade == null ? null : grade,
        "description": description == null ? null : description,
        "link": link == null ? null : link,
        "files": files == null ? null : List<dynamic>.from(files.map((x) => x.toJson())),
        "removedFiles": removedFiles == null ? null : List<dynamic>.from(removedFiles.map((x) => x)),
        "id": id == null ? null : id,
        "isValid": isValid == null ? null : isValid,
    };
}