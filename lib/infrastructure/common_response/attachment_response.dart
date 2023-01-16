
class AttachmentResponse {
    AttachmentResponse({
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

    factory AttachmentResponse.fromJson(Map<String, dynamic> json) => AttachmentResponse(
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
