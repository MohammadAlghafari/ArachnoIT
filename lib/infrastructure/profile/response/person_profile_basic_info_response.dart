// To parse this JSON data, do
//
//     final personProfileBasicInfoResponse = personProfileBasicInfoResponseFromJson(jsonString);

import 'dart:convert';

PersonProfileBasicInfoResponse personProfileBasicInfoResponseFromJson(String str) => PersonProfileBasicInfoResponse.fromJson(json.decode(str));

String personProfileBasicInfoResponseToJson(PersonProfileBasicInfoResponse data) => json.encode(data.toJson());

class PersonProfileBasicInfoResponse {
    PersonProfileBasicInfoResponse({
        this.firstName,
        this.lastName,
        this.gender,
        this.birthdate,
        this.summary,
    });

    String firstName;
    String lastName;
    int gender;
    DateTime birthdate;
    String summary;

    factory PersonProfileBasicInfoResponse.fromJson(Map<String, dynamic> json) => PersonProfileBasicInfoResponse(
        firstName: json["firstName"] == null ? null : json["firstName"],
        lastName: json["lastName"] == null ? null : json["lastName"],
        gender: json["gender"] == null ? null : json["gender"],
        birthdate: json["birthdate"] == null ? null : DateTime.parse(json["birthdate"]),
        summary: json["summary"] == null ? null : json["summary"],
    );

    Map<String, dynamic> toJson() => {
        "firstName": firstName == null ? null : firstName,
        "lastName": lastName == null ? null : lastName,
        "gender": gender == null ? null : gender,
        "birthdate": birthdate == null ? null : birthdate.toIso8601String(),
        "summary": summary == null ? null : summary,
    };
}
