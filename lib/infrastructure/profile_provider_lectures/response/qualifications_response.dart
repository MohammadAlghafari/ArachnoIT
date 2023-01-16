// To parse this JSON data, do
//
//     final qualificationsResponse = qualificationsResponseFromJson(jsonString);

import 'dart:convert';

import 'package:arachnoit/infrastructure/common_response/attachment_response.dart';

import '../../profile_provider_certificate/repository/certificate_response.dart';

List<QualificationsResponse> qualificationsResponseFromJson(String str) => List<QualificationsResponse>.from(json.decode(str).map((x) => QualificationsResponse.fromJson(x)));

String qualificationsResponseToJson(List<QualificationsResponse> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class QualificationsResponse {
    QualificationsResponse({
        this.title,
        this.description,
        this.attachments,
        this.ownerId,
        this.id,
        this.isValid,
    });

    String title;
    String description;
    List<AttachmentResponse> attachments;
    String ownerId;
    String id;
    bool isValid;

    factory QualificationsResponse.fromJson(Map<String, dynamic> json) => QualificationsResponse(
        title: json["title"] == null ? null : json["title"],
        description: json["description"] == null ? null : json["description"],
        attachments: json["attachments"] == null ? null : List<AttachmentResponse>.from(json["attachments"].map((x) => AttachmentResponse.fromJson(x))),
        ownerId: json["ownerId"] == null ? null : json["ownerId"],
        id: json["id"] == null ? null : json["id"],
        isValid: json["isValid"] == null ? null : json["isValid"],
    );

    Map<String, dynamic> toJson() => {
        "title": title == null ? null : title,
        "description": description == null ? null : description,
        "attachments": attachments == null ? null : List<dynamic>.from(attachments.map((x) => x.toJson())),
        "ownerId": ownerId == null ? null : ownerId,
        "id": id == null ? null : id,
        "isValid": isValid == null ? null : isValid,
    };
}
