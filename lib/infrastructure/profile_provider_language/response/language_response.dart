// To parse this JSON data, do
//
//     final languageResponse = languageResponseFromJson(jsonString);

import 'dart:convert';

List<LanguageResponse> languageResponseFromJson(String str) => List<LanguageResponse>.from(json.decode(str).map((x) => LanguageResponse.fromJson(x)));

String languageResponseToJson(List<LanguageResponse> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class LanguageResponse {
    LanguageResponse({
        this.nativeName,
        this.englishName,
        this.code,
        this.languageLevel,
        this.ownerId,
        this.id,
        this.isValid,
    });

    String nativeName;
    String englishName;
    String code;
    int languageLevel;
    String ownerId;
    String id;
    bool isValid;

    factory LanguageResponse.fromJson(Map<String, dynamic> json) => LanguageResponse(
        nativeName: json["nativeName"] == null ? null : json["nativeName"],
        englishName: json["englishName"] == null ? null : json["englishName"],
        code: json["code"] == null ? null : json["code"],
        languageLevel: json["languageLevel"] == null ? null : json["languageLevel"],
        ownerId: json["ownerId"] == null ? null : json["ownerId"],
        id: json["id"] == null ? null : json["id"],
        isValid: json["isValid"] == null ? null : json["isValid"],
    );

    Map<String, dynamic> toJson() => {
        "nativeName": nativeName == null ? null : nativeName,
        "englishName": englishName == null ? null : englishName,
        "code": code == null ? null : code,
        "languageLevel": languageLevel == null ? null : languageLevel,
        "ownerId": ownerId == null ? null : ownerId,
        "id": id == null ? null : id,
        "isValid": isValid == null ? null : isValid,
    };
}
