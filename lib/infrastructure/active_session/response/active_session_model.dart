// To parse this JSON data, do
//
//     final activeSessionModel = activeSessionModelFromJson(jsonString);

import 'dart:convert';

List<ActiveSessionModel> activeSessionModelFromJson(String str) => List<ActiveSessionModel>.from(json.decode(str).map((x) => ActiveSessionModel.fromJson(x)));

String activeSessionModelToJson(List<ActiveSessionModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ActiveSessionModel {
    ActiveSessionModel({
        this.model,
        this.product,
        this.brand,
        this.ip,
        this.osApiLevel,
        this.id,
        this.isValid,
    });

    String model;
    String product;
    String brand;
    String ip;
    int osApiLevel;
    String id;
    bool isValid;

    factory ActiveSessionModel.fromJson(Map<String, dynamic> json) => ActiveSessionModel(
        model: json["model"] == null ? null : json["model"],
        product: json["product"] == null ? null : json["product"],
        brand: json["brand"] == null ? null : json["brand"],
        ip: json["ip"] == null ? null : json["ip"],
        osApiLevel: json["osApiLevel"] == null ? null : json["osApiLevel"],
        id: json["id"] == null ? null : json["id"],
        isValid: json["isValid"] == null ? null : json["isValid"],
    );

    Map<String, dynamic> toJson() => {
        "model": model == null ? null : model,
        "product": product == null ? null : product,
        "brand": brand == null ? null : brand,
        "ip": ip == null ? null : ip,
        "osApiLevel": osApiLevel == null ? null : osApiLevel,
        "id": id == null ? null : id,
        "isValid": isValid == null ? null : isValid,
    };
}
