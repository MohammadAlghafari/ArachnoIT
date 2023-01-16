// To parse this JSON data, do
//
//     final experianceResponse = experianceResponseFromJson(jsonString);

import 'dart:convert';

import 'package:arachnoit/infrastructure/common_response/attachment_response.dart';

List<ExperianceResponse> experianceResponseFromJson(String str) => List<ExperianceResponse>.from(json.decode(str).map((x) => ExperianceResponse.fromJson(x)));

String experianceResponseToJson(List<ExperianceResponse> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ExperianceResponse {
    ExperianceResponse({
        this.title,
        this.company,
        this.startDate,
        this.endDate,
        this.description,
        this.link,
        this.attachments,
        this.ownerId,
        this.id,
        this.isValid,
    });

    String title;
    String company;
    DateTime startDate;
    DateTime endDate;
    String description;
    String link;
    List<AttachmentResponse> attachments;
    String ownerId;
    String id;
    bool isValid;

    factory ExperianceResponse.fromJson(Map<String, dynamic> json) => ExperianceResponse(
        title: json["title"] == null ? null : json["title"],
        company: json["company"] == null ? null : json["company"],
        startDate: json["startDate"] == null ? null : DateTime.parse(json["startDate"]),
        endDate: json["endDate"] == null ? null : DateTime.parse(json["endDate"]),
        description: json["description"] == null ? null : json["description"],
        link: json["link"] == null ? null : json["link"],
        attachments: json["attachments"] == null ? null : List<AttachmentResponse>.from(json["attachments"].map((x) => AttachmentResponse.fromJson(x))),
        ownerId: json["ownerId"] == null ? null : json["ownerId"],
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
        "attachments": attachments == null ? null : List<dynamic>.from(attachments.map((x) => x.toJson())),
        "ownerId": ownerId == null ? null : ownerId,
        "id": id == null ? null : id,
        "isValid": isValid == null ? null : isValid,
    };
}