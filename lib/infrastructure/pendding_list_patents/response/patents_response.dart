// To parse this JSON data, do
//
//     final patentsResponse = patentsResponseFromJson(jsonString);

import 'dart:convert';

List<PatentsResponse> patentsResponseFromJson(String str) => List<PatentsResponse>.from(json.decode(str).map((x) => PatentsResponse.fromJson(x)));

String patentsResponseToJson(List<PatentsResponse> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class PatentsResponse {
    PatentsResponse({
        this.title,
        this.office,
        this.number,
        this.patentStatus,
        this.requestStatus,
        this.url,
        this.description,
        this.date,
        this.attachments,
        this.patentContributers,
        this.owner,
        this.ownerId,
        this.id,
        this.isValid,
    });

    String title;
    String office;
    String number;
    int patentStatus;
    int requestStatus;
    String url;
    String description;
    DateTime date;
    List<Attachment> attachments;
    List<PatentContributer> patentContributers;
    Owner owner;
    String ownerId;
    String id;
    bool isValid;

    factory PatentsResponse.fromJson(Map<String, dynamic> json) => PatentsResponse(
        title: json["title"] == null ? null : json["title"],
        office: json["office"] == null ? null : json["office"],
        number: json["number"] == null ? null : json["number"],
        patentStatus: json["patentStatus"] == null ? null : json["patentStatus"],
        requestStatus: json["requestStatus"] == null ? null : json["requestStatus"],
        url: json["url"] == null ? null : json["url"],
        description: json["description"] == null ? null : json["description"],
        date: json["date"] == null ? null : DateTime.parse(json["date"]),
        attachments: json["attachments"] == null ? null : List<Attachment>.from(json["attachments"].map((x) => Attachment.fromJson(x))),
        patentContributers: json["patentContributers"] == null ? null : List<PatentContributer>.from(json["patentContributers"].map((x) => PatentContributer.fromJson(x))),
        owner: json["owner"] == null ? null : Owner.fromJson(json["owner"]),
        ownerId: json["ownerId"] == null ? null : json["ownerId"],
        id: json["id"] == null ? null : json["id"],
        isValid: json["isValid"] == null ? null : json["isValid"],
    );

    Map<String, dynamic> toJson() => {
        "title": title == null ? null : title,
        "office": office == null ? null : office,
        "number": number == null ? null : number,
        "patentStatus": patentStatus == null ? null : patentStatus,
        "requestStatus": requestStatus == null ? null : requestStatus,
        "url": url == null ? null : url,
        "description": description == null ? null : description,
        "date": date == null ? null : date.toIso8601String(),
        "attachments": attachments == null ? null : List<dynamic>.from(attachments.map((x) => x.toJson())),
        "patentContributers": patentContributers == null ? null : List<dynamic>.from(patentContributers.map((x) => x.toJson())),
        "owner": owner == null ? null : owner.toJson(),
        "ownerId": ownerId == null ? null : ownerId,
        "id": id == null ? null : id,
        "isValid": isValid == null ? null : isValid,
    };
}

class Attachment {
    Attachment({
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

    factory Attachment.fromJson(Map<String, dynamic> json) => Attachment(
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

class Owner {
    Owner({
        this.firstName,
        this.lastName,
        this.fullName,
        this.inTouchPointName,
        this.photo,
        this.archiveStatus,
        this.profileType,
        this.accountType,
        this.isHealthcareProvider,
        this.id,
        this.isValid,
    });

    String firstName;
    String lastName;
    String fullName;
    String inTouchPointName;
    String photo;
    int archiveStatus;
    int profileType;
    int accountType;
    bool isHealthcareProvider;
    String id;
    bool isValid;

    factory Owner.fromJson(Map<String, dynamic> json) => Owner(
        firstName: json["firstName"] == null ? null : json["firstName"],
        lastName: json["lastName"] == null ? null : json["lastName"],
        fullName: json["fullName"] == null ? null : json["fullName"],
        inTouchPointName: json["inTouchPointName"] == null ? null : json["inTouchPointName"],
        photo: json["photo"] == null ? null : json["photo"],
        archiveStatus: json["archiveStatus"] == null ? null : json["archiveStatus"],
        profileType: json["profileType"] == null ? null : json["profileType"],
        accountType: json["accountType"] == null ? null : json["accountType"],
        isHealthcareProvider: json["isHealthcareProvider"] == null ? null : json["isHealthcareProvider"],
        id: json["id"] == null ? null : json["id"],
        isValid: json["isValid"] == null ? null : json["isValid"],
    );

    Map<String, dynamic> toJson() => {
        "firstName": firstName == null ? null : firstName,
        "lastName": lastName == null ? null : lastName,
        "fullName": fullName == null ? null : fullName,
        "inTouchPointName": inTouchPointName == null ? null : inTouchPointName,
        "photo": photo == null ? null : photo,
        "archiveStatus": archiveStatus == null ? null : archiveStatus,
        "profileType": profileType == null ? null : profileType,
        "accountType": accountType == null ? null : accountType,
        "isHealthcareProvider": isHealthcareProvider == null ? null : isHealthcareProvider,
        "id": id == null ? null : id,
        "isValid": isValid == null ? null : isValid,
    };
}

class PatentContributer {
    PatentContributer({
        this.firstName,
        this.lastName,
        this.fullName,
        this.inTouchPointName,
        this.email,
        this.mobile,
        this.photo,
        this.contributionType,
        this.requestStatus,
        this.healthcareProviderId,
        this.id,
        this.isValid,
    });

    String firstName;
    String lastName;
    String fullName;
    String inTouchPointName;
    String email;
    String mobile;
    String photo;
    int contributionType;
    int requestStatus;
    String healthcareProviderId;
    String id;
    bool isValid;

    factory PatentContributer.fromJson(Map<String, dynamic> json) => PatentContributer(
        firstName: json["firstName"] == null ? null : json["firstName"],
        lastName: json["lastName"] == null ? null : json["lastName"],
        fullName: json["fullName"] == null ? null : json["fullName"],
        inTouchPointName: json["inTouchPointName"] == null ? null : json["inTouchPointName"],
        email: json["email"] == null ? null : json["email"],
        mobile: json["mobile"] == null ? null : json["mobile"],
        photo: json["photo"] == null ? null : json["photo"],
        contributionType: json["contributionType"] == null ? null : json["contributionType"],
        requestStatus: json["requestStatus"] == null ? null : json["requestStatus"],
        healthcareProviderId: json["healthcareProviderId"] == null ? null : json["healthcareProviderId"],
        id: json["id"] == null ? null : json["id"],
        isValid: json["isValid"] == null ? null : json["isValid"],
    );

    Map<String, dynamic> toJson() => {
        "firstName": firstName == null ? null : firstName,
        "lastName": lastName == null ? null : lastName,
        "fullName": fullName == null ? null : fullName,
        "inTouchPointName": inTouchPointName == null ? null : inTouchPointName,
        "email": email == null ? null : email,
        "mobile": mobile == null ? null : mobile,
        "photo": photo == null ? null : photo,
        "contributionType": contributionType == null ? null : contributionType,
        "requestStatus": requestStatus == null ? null : requestStatus,
        "healthcareProviderId": healthcareProviderId == null ? null : healthcareProviderId,
        "id": id == null ? null : id,
        "isValid": isValid == null ? null : isValid,
    };
}
