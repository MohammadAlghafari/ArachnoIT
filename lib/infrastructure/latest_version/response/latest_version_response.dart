// To parse this JSON data, do
//
//     final latestVersionResponse = latestVersionResponseFromJson(jsonString);

import 'dart:convert';

LatestVersionResponse latestVersionResponseFromJson(String str) => LatestVersionResponse.fromJson(json.decode(str));

String latestVersionResponseToJson(LatestVersionResponse data) => json.encode(data.toJson());

class LatestVersionResponse {
    LatestVersionResponse({
        this.lastAggressiveVersion,
        this.lastNormalVersion,
    });

    LastVersion lastAggressiveVersion;
    LastVersion lastNormalVersion;

    factory LatestVersionResponse.fromJson(Map<String, dynamic> json) => LatestVersionResponse(
        lastAggressiveVersion: json["lastAggressiveVersion"] == null ? null : LastVersion.fromJson(json["lastAggressiveVersion"]),
        lastNormalVersion: json["lastNormalVersion"] == null ? null : LastVersion.fromJson(json["lastNormalVersion"]),
    );

    Map<String, dynamic> toJson() => {
        "lastAggressiveVersion": lastAggressiveVersion == null ? null : lastAggressiveVersion.toJson(),
        "lastNormalVersion": lastNormalVersion == null ? null : lastNormalVersion.toJson(),
    };
}

class LastVersion {
    LastVersion({
        this.versionCode,
        this.description,
        this.url,
        this.googlePlayUrl,
        this.isAggressive,
        this.id,
        this.isValid,
    });

    int versionCode;
    String description;
    String url;
    String googlePlayUrl;
    bool isAggressive;
    String id;
    bool isValid;

    factory LastVersion.fromJson(Map<String, dynamic> json) => LastVersion(
        versionCode: json["versionCode"] == null ? null : json["versionCode"],
        description: json["description"] == null ? null : json["description"],
        url: json["url"] == null ? null : json["url"],
        googlePlayUrl: json["googlePlayUrl"] == null ? null : json["googlePlayUrl"],
        isAggressive: json["isAggressive"] == null ? null : json["isAggressive"],
        id: json["id"] == null ? null : json["id"],
        isValid: json["isValid"] == null ? null : json["isValid"],
    );

    Map<String, dynamic> toJson() => {
        "versionCode": versionCode == null ? null : versionCode,
        "description": description == null ? null : description,
        "url": url == null ? null : url,
        "googlePlayUrl": googlePlayUrl == null ? null : googlePlayUrl,
        "isAggressive": isAggressive == null ? null : isAggressive,
        "id": id == null ? null : id,
        "isValid": isValid == null ? null : isValid,
    };
}
