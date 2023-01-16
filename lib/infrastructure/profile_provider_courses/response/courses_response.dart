// To parse this JSON data, do
//
//     final coursesResponse = coursesResponseFromJson(jsonString);

import 'dart:convert';

import 'package:arachnoit/infrastructure/common_response/attachment_response.dart';

List<CoursesResponse> coursesResponseFromJson(String str) => List<CoursesResponse>.from(json.decode(str).map((x) => CoursesResponse.fromJson(x)));

String coursesResponseToJson(List<CoursesResponse> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CoursesResponse {
    CoursesResponse({
        this.name,
        this.date,
        this.place,
        this.attachments,
        this.ownerId,
        this.id,
        this.isValid,
    });

    String name;
    DateTime date;
    String place;
    List<AttachmentResponse> attachments;
    String ownerId;
    String id;
    bool isValid;

    factory CoursesResponse.fromJson(Map<String, dynamic> json) => CoursesResponse(
        name: json["name"] == null ? null : json["name"],
        date: json["date"] == null ? null : DateTime.parse(json["date"]),
        place: json["place"] == null ? null : json["place"],
        attachments: json["attachments"] == null ? null : List<AttachmentResponse>.from(json["attachments"].map((x) => AttachmentResponse.fromJson(x))),
        ownerId: json["ownerId"] == null ? null : json["ownerId"],
        id: json["id"] == null ? null : json["id"],
        isValid: json["isValid"] == null ? null : json["isValid"],
    );

    Map<String, dynamic> toJson() => {
        "name": name == null ? null : name,
        "date": date == null ? null : date.toIso8601String(),
        "place": place == null ? null : place,
        "attachments": attachments == null ? null : List<dynamic>.from(attachments.map((x) => x.toJson())),
        "ownerId": ownerId == null ? null : ownerId,
        "id": id == null ? null : id,
        "isValid": isValid == null ? null : isValid,
    };
}