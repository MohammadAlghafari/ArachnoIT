// To parse this JSON data, do
//
//     final educationsResponse = educationsResponseFromJson(jsonString);

import 'dart:convert';

import 'package:arachnoit/infrastructure/common_response/attachment_response.dart';

List<EducationsResponse> educationsResponseFromJson(String str) => List<EducationsResponse>.from(json.decode(str).map((x) => EducationsResponse.fromJson(x)));

String educationsResponseToJson(List<EducationsResponse> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class EducationsResponse {
    EducationsResponse({
        this.school,
        this.degree,
        this.fieldOfStudy,
        this.startDate,
        this.endDate,
        this.grade,
        this.description,
        this.link,
        this.attachments,
        this.ownerId,
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
    List<AttachmentResponse> attachments;
    String ownerId;
    String id;
    bool isValid;

    factory EducationsResponse.fromJson(Map<String, dynamic> json) => EducationsResponse(
        school: json["school"] == null ? null : json["school"],
        degree: json["degree"] == null ? null : json["degree"],
        fieldOfStudy: json["fieldOfStudy"] == null ? null : json["fieldOfStudy"],
        startDate: json["startDate"] == null ? null : DateTime.parse(json["startDate"]),
        endDate: json["endDate"] == null ? null : DateTime.parse(json["endDate"]),
        grade: json["grade"] == null ? null : json["grade"],
        description: json["description"] == null ? null : json["description"],
        link: json["link"] == null ? null : json["link"],
        attachments: json["attachments"] == null ? null : List<AttachmentResponse>.from(json["attachments"].map((x) => AttachmentResponse.fromJson(x))),
        ownerId: json["ownerId"] == null ? null : json["ownerId"],
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
        "attachments": attachments == null ? null : List<dynamic>.from(attachments.map((x) => x.toJson())),
        "ownerId": ownerId == null ? null : ownerId,
        "id": id == null ? null : id,
        "isValid": isValid == null ? null : isValid,
    };
}