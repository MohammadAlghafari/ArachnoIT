// To parse this JSON data, do
//
//     final certificateResponse = certificateResponseFromJson(jsonString);

import 'dart:convert';

import 'package:arachnoit/infrastructure/common_response/attachment_response.dart';

List<CertificateResponse> certificateResponseFromJson(String str) => List<CertificateResponse>.from(json.decode(str).map((x) => CertificateResponse.fromJson(x)));

String certificateResponseToJson(List<CertificateResponse> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CertificateResponse {
    CertificateResponse({
        this.name,
        this.organization,
        this.issueDate,
        this.expirationDate,
        this.url,
        this.attachments,
        this.ownerId,
        this.id,
        this.isValid,
    });

    String name;
    String organization;
    DateTime issueDate;
    DateTime expirationDate;
    String url;
    List<AttachmentResponse> attachments;
    String ownerId;
    String id;
    bool isValid;

    factory CertificateResponse.fromJson(Map<String, dynamic> json) => CertificateResponse(
        name: json["name"] == null ? null : json["name"],
        organization: json["organization"] == null ? null : json["organization"],
        issueDate: json["issueDate"] == null ? null : DateTime.parse(json["issueDate"]),
        expirationDate: json["expirationDate"] == null ? null : DateTime.parse(json["expirationDate"]),
        url: json["url"] == null ? null : json["url"],
        attachments: json["attachments"] == null ? null : List<AttachmentResponse>.from(json["attachments"].map((x) => AttachmentResponse.fromJson(x))),
        ownerId: json["ownerId"] == null ? null : json["ownerId"],
        id: json["id"] == null ? null : json["id"],
        isValid: json["isValid"] == null ? null : json["isValid"],
    );

    Map<String, dynamic> toJson() => {
        "name": name == null ? null : name,
        "organization": organization == null ? null : organization,
        "issueDate": issueDate == null ? null : issueDate.toIso8601String(),
        "expirationDate": expirationDate == null ? null : expirationDate.toIso8601String(),
        "url": url == null ? null : url,
        "attachments": attachments == null ? null : List<dynamic>.from(attachments.map((x) => x.toJson())),
        "ownerId": ownerId == null ? null : ownerId,
        "id": id == null ? null : id,
        "isValid": isValid == null ? null : isValid,
    };
}
