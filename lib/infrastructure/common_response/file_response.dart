// To parse this JSON data, do
//
//     final fileResponse = fileResponseFromJson(jsonString);

import 'dart:convert';

FileResponse fileResponseFromJson(String str) => FileResponse.fromMap(json.decode(str));

String fileResponseToJson(FileResponse data) => json.encode(data.toMap());

class FileResponse {
    FileResponse({
        this.name="",
        this.extension="",
        this.url="",
        this.id="",
        this.contentType="",
        this.contentLength=0,
        this.fileType=0,
        this.localeImage="",
    });

    String name;
    String extension;
    String url;
    String id;
    String contentType;
    int contentLength;
    int fileType;
    String localeImage;

    factory FileResponse.fromMap(Map<String, dynamic> json) => FileResponse(
        name: json["name"] == null ? "" : json["name"],
        extension: json["extension"] == null ? "" : json["extension"],
        url: json["url"] == null ? "" : json["url"],
        id: json["id"] == null ? "" : json["id"],
        contentType: json["contentType"] == null ? "" : json["contentType"],
        contentLength: json["contentLength"] == null ? 0 : json["contentLength"],
        fileType: json["fileType"] == null ? 0 : json["fileType"],
        localeImage: json["localeImage"] == null ? "" : json["localeImage"],
    );

    Map<String, dynamic> toMap() => {
        "name": name == null ? "" : name,
        "extension": extension == null ? "" : extension,
        "url": url == null ? "" : url,
        "id": id == null ? "" : id,
        "contentType": contentType == null ? "" : contentType,
        "contentLength": contentLength == null ? 0 : contentLength,
        "fileType": fileType == null ? 0 : fileType,
        "localeImage": localeImage == null ? "" : localeImage,
    };
}
