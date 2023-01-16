// To parse this JSON data, do
//
//     final newCertificateResponse = newCertificateResponseFromJson(jsonString);

import 'dart:convert';

import 'package:arachnoit/infrastructure/common_response/attachment_response.dart';

NewCertificateResponse newCertificateResponseFromJson(String str) => NewCertificateResponse.fromJson(json.decode(str));

String newCertificateResponseToJson(NewCertificateResponse data) => json.encode(data.toJson());

class NewCertificateResponse {
    NewCertificateResponse({
        this.name,
        this.organization,
        this.issueDate,
        this.expirationDate,
        this.url,
        this.files,
        this.removedFiles,
        this.id,
        this.isValid,
    });

    String name;
    String organization;
    DateTime issueDate;
    DateTime expirationDate;
    String url;
    List<AttachmentResponse> files;
    List<String> removedFiles;
    String id;
    bool isValid;

    factory NewCertificateResponse.fromJson(Map<String, dynamic> json) => NewCertificateResponse(
        name: json["name"] == null ? null : json["name"],
        organization: json["organization"] == null ? null : json["organization"],
        issueDate: json["issueDate"] == null ? null : DateTime.parse(json["issueDate"]),
        expirationDate: json["expirationDate"] == null ? null : DateTime.parse(json["expirationDate"]),
        url: json["url"] == null ? null : json["url"],
        files: json["files"] == null ? null : List<AttachmentResponse>.from(json["files"].map((x) => AttachmentResponse.fromJson(x))),
        removedFiles: json["removedFiles"] == null ? null : List<String>.from(json["removedFiles"].map((x) => x)),
        id: json["id"] == null ? null : json["id"],
        isValid: json["isValid"] == null ? null : json["isValid"],
    );

    Map<String, dynamic> toJson() => {
        "name": name == null ? null : name,
        "organization": organization == null ? null : organization,
        "issueDate": issueDate == null ? null : issueDate.toIso8601String(),
        "expirationDate": expirationDate == null ? null : expirationDate.toIso8601String(),
        "url": url == null ? null : url,
        "files": files == null ? null : List<dynamic>.from(files.map((x) => x.toJson())),
        "removedFiles": removedFiles == null ? null : List<dynamic>.from(removedFiles.map((x) => x)),
        "id": id == null ? null : id,
        "isValid": isValid == null ? null : isValid,
    };
}
