// To parse this JSON data, do
//
//     final skillsResponse = skillsResponseFromJson(jsonString);

import 'dart:convert';

List<SkillsResponse> skillsResponseFromJson(String str) => List<SkillsResponse>.from(json.decode(str).map((x) => SkillsResponse.fromJson(x)));

String skillsResponseToJson(List<SkillsResponse> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class SkillsResponse {
    SkillsResponse({
        this.name,
        this.description,
        this.startDate,
        this.endDate,
        this.ownerId,
        this.id,
        this.isValid,
    });

    String name;
    String description;
    DateTime startDate;
    DateTime endDate;
    String ownerId;
    String id;
    bool isValid;

    factory SkillsResponse.fromJson(Map<String, dynamic> json) => SkillsResponse(
        name: json["name"] == null ? null : json["name"],
        description: json["description"] == null ? null : json["description"],
        startDate: json["startDate"] == null ? null : DateTime.parse(json["startDate"]),
        endDate: json["endDate"] == null ? null : DateTime.parse(json["endDate"]),
        ownerId: json["ownerId"] == null ? null : json["ownerId"],
        id: json["id"] == null ? null : json["id"],
        isValid: json["isValid"] == null ? null : json["isValid"],
    );

    Map<String, dynamic> toJson() => {
        "name": name == null ? null : name,
        "description": description == null ? null : description,
        "startDate": startDate == null ? null : startDate.toIso8601String(),
        "endDate": endDate == null ? null : endDate.toIso8601String(),
        "ownerId": ownerId == null ? null : ownerId,
        "id": id == null ? null : id,
        "isValid": isValid == null ? null : isValid,
    };
}
