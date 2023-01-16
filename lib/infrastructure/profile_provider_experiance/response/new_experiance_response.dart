// To parse this JSON data, do
//
//     final newExperianceResponse = newExperianceResponseFromJson(jsonString);

import 'dart:convert';

import '../../common_response/attachment_response.dart';

NewExperianceResponse newExperianceResponseFromJson(String str) => NewExperianceResponse.fromJson(json.decode(str));

String newExperianceResponseToJson(NewExperianceResponse data) => json.encode(data.toJson());

class NewExperianceResponse {
    NewExperianceResponse({
        this.title,
        this.company,
        this.startDate,
        this.endDate,
        this.description,
        this.link,
        this.files,
        this.removedFiles,
        this.id,
        this.isValid,
    });

    String title;
    String company;
    DateTime startDate;
    DateTime endDate;
    String description;
    String link;
    List<AttachmentResponse> files;
    List<String> removedFiles;
    String id;
    bool isValid;

    factory NewExperianceResponse.fromJson(Map<String, dynamic> json) => NewExperianceResponse(
        title: json["title"] == null ? null : json["title"],
        company: json["company"] == null ? null : json["company"],
        startDate: json["startDate"] == null ? null : DateTime.parse(json["startDate"]),
        endDate: json["endDate"] == null ? null : DateTime.parse(json["endDate"]),
        description: json["description"] == null ? null : json["description"],
        link: json["link"] == null ? null : json["link"],
        files: json["files"] == null ? null : List<AttachmentResponse>.from(json["files"].map((x) => AttachmentResponse.fromJson(x))),
        removedFiles: json["removedFiles"] == null ? null : List<String>.from(json["removedFiles"].map((x) => x)),
        id: json["id"] == null ? null : json["id"],
        isValid: json["isValid"] == null ? null : json["isValid"],
    );

    Map<String, dynamic> toJson() => {
        "title": title == null ? null : title,
        "company": company == null ? null : company,
        "startDate": startDate == null ? null : startDate.toIso8601String(),
        "endDate": endDate == null ? null : endDate.toIso8601String(),
        "description": description == null ? null : description,
        "link": link == null ? null : link,
        "files": files == null ? null : List<dynamic>.from(files.map((x) => x.toJson())),
        "removedFiles": removedFiles == null ? null : List<dynamic>.from(removedFiles.map((x) => x)),
        "id": id == null ? null : id,
        "isValid": isValid == null ? null : isValid,
    };
}
