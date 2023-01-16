// To parse this JSON data, do
//
//     final voteRespose = voteResposeFromJson(jsonString);

import 'dart:convert';

List<BlogsVoteResponse> voteResposeFromJson(String str) => List<BlogsVoteResponse>.from(json.decode(str).map((x) => BlogsVoteResponse.fromJson(x)));

String voteResposeToJson(List<BlogsVoteResponse> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class BlogsVoteResponse {
    BlogsVoteResponse({
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

    factory BlogsVoteResponse.fromJson(Map<String, dynamic> json) => BlogsVoteResponse(
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
