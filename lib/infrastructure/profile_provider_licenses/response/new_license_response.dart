// To parse this JSON data, do
//
//     final newLicenseResponse = newLicenseResponseFromJson(jsonString);

import 'dart:convert';

NewLicenseResponse newLicenseResponseFromJson(String str) => NewLicenseResponse.fromJson(json.decode(str));

String newLicenseResponseToJson(NewLicenseResponse data) => json.encode(data.toJson());

class NewLicenseResponse {
    NewLicenseResponse({
        this.title,
        this.description,
        this.fileDto,
        this.removeFile,
        this.id,
        this.isValid,
    });

    String title;
    String description;
    FileDto fileDto;
    bool removeFile;
    String id;
    bool isValid;

    factory NewLicenseResponse.fromJson(Map<String, dynamic> json) => NewLicenseResponse(
        title: json["title"] == null ? null : json["title"],
        description: json["description"] == null ? null : json["description"],
        fileDto: json["fileDto"] == null ? null : FileDto.fromJson(json["fileDto"]),
        removeFile: json["removeFile"] == null ? null : json["removeFile"],
        id: json["id"] == null ? null : json["id"],
        isValid: json["isValid"] == null ? null : json["isValid"],
    );

    Map<String, dynamic> toJson() => {
        "title": title == null ? null : title,
        "description": description == null ? null : description,
        "fileDto": fileDto == null ? null : fileDto.toJson(),
        "removeFile": removeFile == null ? null : removeFile,
        "id": id == null ? null : id,
        "isValid": isValid == null ? null : isValid,
    };
}

class FileDto {
    FileDto({
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

    factory FileDto.fromJson(Map<String, dynamic> json) => FileDto(
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
