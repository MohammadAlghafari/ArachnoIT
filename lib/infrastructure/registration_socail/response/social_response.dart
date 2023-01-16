// To parse this JSON data, do
//
//     final socialResponse = socialResponseFromJson(jsonString);

import 'dart:convert';

SocialResponse socialResponseFromJson(String str) => SocialResponse.fromJson(json.decode(str));

String socialResponseToJson(SocialResponse data) => json.encode(data.toJson());

class SocialResponse {
    SocialResponse({
        this.isTokenvalid,
        this.isExist,
    });

    bool isTokenvalid;
    bool isExist;

    factory SocialResponse.fromJson(Map<String, dynamic> json) => SocialResponse(
        isTokenvalid: json["isTokenvalid"] == null ? null : json["isTokenvalid"],
        isExist: json["isExist"] == null ? null : json["isExist"],
    );

    Map<String, dynamic> toJson() => {
        "isTokenvalid": isTokenvalid == null ? null : isTokenvalid,
        "isExist": isExist == null ? null : isExist,
    };
}
