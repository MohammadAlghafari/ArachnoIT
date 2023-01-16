// To parse this JSON data, do
//
//     final licensesResponse = licensesResponseFromJson(jsonString);

import 'dart:convert';

List<LicensesResponse> licensesResponseFromJson(String str) => List<LicensesResponse>.from(json.decode(str).map((x) => LicensesResponse.fromJson(x)));

String licensesResponseToJson(List<LicensesResponse> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class LicensesResponse {
    LicensesResponse({
        this.title,
        this.description,
        this.licenseStatus,
        this.file,
        this.fileUrl,
        this.ownerId,
        this.id,
        this.isValid,
    });

    String title;
    String description;
    int licenseStatus;
    FileClass file;
    String fileUrl;
    String ownerId;
    String id;
    bool isValid;

    factory LicensesResponse.fromJson(Map<String, dynamic> json) => LicensesResponse(
        title: json["title"] == null ? null : json["title"],
        description: json["description"] == null ? null : json["description"],
        licenseStatus: json["licenseStatus"] == null ? null : json["licenseStatus"],
        file: json["file"] == null ? null : FileClass.fromJson(json["file"]),
        fileUrl: json["fileUrl"] == null ? null : json["fileUrl"],
        ownerId: json["ownerId"] == null ? null : json["ownerId"],
        id: json["id"] == null ? null : json["id"],
        isValid: json["isValid"] == null ? null : json["isValid"],
    );

    Map<String, dynamic> toJson() => {
        "title": title == null ? null : title,
        "description": description == null ? null : description,
        "licenseStatus": licenseStatus == null ? null : licenseStatus,
        "file": file == null ? null : file.toJson(),
        "fileUrl": fileUrl == null ? null : fileUrl,
        "ownerId": ownerId == null ? null : ownerId,
        "id": id == null ? null : id,
        "isValid": isValid == null ? null : isValid,
    };
}

class FileClass {
    FileClass({
        this.name,
        this.extension,
        this.url,
        this.contentType,
        this.contentLength,
        this.fileType,
        this.id,
        this.isValid,
    });

    String name;
    String extension;
    String url;
    String contentType;
    int contentLength;
    int fileType;
    String id;
    bool isValid;

    factory FileClass.fromJson(Map<String, dynamic> json) => FileClass(
        name: json["name"] == null ? null : json["name"],
        extension: json["extension"] == null ? null : json["extension"],
        url: json["url"] == null ? null : json["url"],
        contentType: json["contentType"] == null ? null : json["contentType"],
        contentLength: json["contentLength"] == null ? null : json["contentLength"],
        fileType: json["fileType"] == null ? null : json["fileType"],
        id: json["id"] == null ? null : json["id"],
        isValid: json["isValid"] == null ? null : json["isValid"],
    );

    Map<String, dynamic> toJson() => {
        "name": name == null ? null : name,
        "extension": extension == null ? null : extension,
        "url": url == null ? null : url,
        "contentType": contentType == null ? null : contentType,
        "contentLength": contentLength == null ? null : contentLength,
        "fileType": fileType == null ? null : fileType,
        "id": id == null ? null : id,
        "isValid": isValid == null ? null : isValid,
    };
}
