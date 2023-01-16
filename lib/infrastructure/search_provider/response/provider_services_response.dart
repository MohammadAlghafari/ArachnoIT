// To parse this JSON data, do
//
//     final providerServicesResponse = providerServicesResponseFromJson(jsonString);

import 'dart:convert';

List<ProviderServicesResponse> providerServicesResponseFromJson(String str) => List<ProviderServicesResponse>.from(json.decode(str).map((x) => ProviderServicesResponse.fromJson(x)));

String providerServicesResponseToJson(List<ProviderServicesResponse> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ProviderServicesResponse {
    ProviderServicesResponse({
        this.name,
        this.description,
        this.iconUrl,
        this.id,
        this.isValid,
    });

    String name;
    String description;
    String iconUrl;
    String id;
    bool isValid;

    factory ProviderServicesResponse.fromJson(Map<String, dynamic> json) => ProviderServicesResponse(
        name: json["name"] == null ? null : json["name"],
        description: json["description"] == null ? null : json["description"],
        iconUrl: json["iconUrl"] == null ? null : json["iconUrl"],
        id: json["id"] == null ? null : json["id"],
        isValid: json["isValid"] == null ? null : json["isValid"],
    );

    Map<String, dynamic> toJson() => {
        "name": name == null ? null : name,
        "description": description == null ? null : description,
        "iconUrl": iconUrl == null ? null : iconUrl,
        "id": id == null ? null : id,
        "isValid": isValid == null ? null : isValid,
    };
}
