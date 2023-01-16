// To parse this JSON data, do
//
//     final newSkillResponse = newSkillResponseFromJson(jsonString);

import 'dart:convert';

NewSkillResponse newSkillResponseFromJson(String str) => NewSkillResponse.fromJson(json.decode(str));

String newSkillResponseToJson(NewSkillResponse data) => json.encode(data.toJson());

class NewSkillResponse {
    NewSkillResponse({
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

    factory NewSkillResponse.fromJson(Map<String, dynamic> json) => NewSkillResponse(
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
