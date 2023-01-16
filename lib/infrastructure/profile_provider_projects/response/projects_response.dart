// To parse this JSON data, do
//
//     final projectsResponse = projectsResponseFromJson(jsonString);

import 'dart:convert';

import 'package:arachnoit/infrastructure/common_response/attachment_response.dart';

List<ProjectsResponse> projectsResponseFromJson(String str) => List<ProjectsResponse>.from(json.decode(str).map((x) => ProjectsResponse.fromJson(x)));

String projectsResponseToJson(List<ProjectsResponse> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ProjectsResponse {
    ProjectsResponse({
        this.name,
        this.startDate,
        this.endDate,
        this.url,
        this.description,
        this.attachments,
        this.ownerId,
        this.id,
        this.isValid,
    });

    String name;
    DateTime startDate;
    DateTime endDate;
    String url;
    String description;
    List<AttachmentResponse> attachments;
    String ownerId;
    String id;
    bool isValid;

    factory ProjectsResponse.fromJson(Map<String, dynamic> json) => ProjectsResponse(
        name: json["name"] == null ? null : json["name"],
        startDate: json["startDate"] == null ? null : DateTime.parse(json["startDate"]),
        endDate: json["endDate"] == null ? null : DateTime.parse(json["endDate"]),
        url: json["url"] == null ? null : json["url"],
        description: json["description"] == null ? null : json["description"],
        attachments: json["attachments"] == null ? null : List<AttachmentResponse>.from(json["attachments"].map((x) => AttachmentResponse.fromJson(x))),
        ownerId: json["ownerId"] == null ? null : json["ownerId"],
        id: json["id"] == null ? null : json["id"],
        isValid: json["isValid"] == null ? null : json["isValid"],
    );

    Map<String, dynamic> toJson() => {
        "name": name == null ? null : name,
        "startDate": startDate == null ? null : startDate.toIso8601String(),
        "endDate": endDate == null ? null : endDate.toIso8601String(),
        "url": url == null ? null : url,
        "description": description == null ? null : description,
        "attachments": attachments == null ? null : List<dynamic>.from(attachments.map((x) => x.toJson())),
        "ownerId": ownerId == null ? null : ownerId,
        "id": id == null ? null : id,
        "isValid": isValid == null ? null : isValid,
    };
}
