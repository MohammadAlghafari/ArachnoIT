// To parse this JSON data, do
//
//     final advanceSearchResponse = advanceSearchResponseFromJson(jsonString);

import 'dart:convert';

List<AdvanceSearchResponse> advanceSearchResponseFromJson(String str) => List<AdvanceSearchResponse>.from(json.decode(str).map((x) => AdvanceSearchResponse.fromJson(x)));

String advanceSearchResponseToJson(List<AdvanceSearchResponse> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class AdvanceSearchResponse {
    AdvanceSearchResponse({
        this.summary,
        this.specification,
        this.subSpecification,
        this.isLookingForJob,
        this.country,
        this.city,
        this.mobile,
        this.homePhone,
        this.workPhone,
        this.email,
        this.addedToFavoriteList,
        this.coverUrl,
        this.latitude,
        this.longitude,
        this.distance,
        this.isFollowing,
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

    String summary;
    String specification;
    String subSpecification;
    bool isLookingForJob;
    String country;
    dynamic city;
    dynamic mobile;
    dynamic homePhone;
    dynamic workPhone;
    dynamic email;
    dynamic addedToFavoriteList;
    dynamic coverUrl;
    dynamic latitude;
    dynamic longitude;
    dynamic distance;
    dynamic isFollowing;
    dynamic firstName;
    dynamic lastName;
    dynamic fullName;
    dynamic inTouchPointName;
    dynamic photo;
    dynamic archiveStatus;
    dynamic profileType;
    dynamic accountType;
    dynamic isHealthcareProvider;
    String id;
    dynamic isValid;

    factory AdvanceSearchResponse.fromJson(Map<String, dynamic> json) => AdvanceSearchResponse(
        summary: json["summary"] == null ? "null" : json["summary"],
        specification: json["specification"] == null ? "null" : json["specification"],
        subSpecification: json["subSpecification"] == null ? "null" : json["subSpecification"],
        isLookingForJob: json["isLookingForJob"] == null ? "null" : json["isLookingForJob"],
        country: json["country"] == null ? "null" : json["country"],
        city: json["city"],
        mobile: json["mobile"],
        homePhone: json["homePhone"],
        workPhone: json["workPhone"],
        email: json["email"],
        addedToFavoriteList: json["addedToFavoriteList"],
        coverUrl: json["coverUrl"],
        latitude: json["latitude"],
        longitude: json["longitude"],
        distance: json["distance"],
        isFollowing: json["isFollowing"],
        firstName: json["firstName"],
        lastName: json["lastName"],
        fullName: json["fullName"],
        inTouchPointName: json["inTouchPointName"],
        photo: json["photo"],
        archiveStatus: json["archiveStatus"],
        profileType: json["profileType"],
        accountType: json["accountType"],
        isHealthcareProvider: json["isHealthcareProvider"],
        id: json["id"] == null ? "null" : json["id"],
        isValid: json["isValid"],
    );

    Map<String, dynamic> toJson() => {
        "summary": summary == null ? "null" : summary,
        "specification": specification == null ? "null" : specification,
        "subSpecification": subSpecification == null ? "null" : subSpecification,
        "isLookingForJob": isLookingForJob == null ? "null" : isLookingForJob,
        "country": country == null ? "null" : country,
        "city": city,
        "mobile": mobile,
        "homePhone": homePhone,
        "workPhone": workPhone,
        "email": email,
        "addedToFavoriteList": addedToFavoriteList,
        "coverUrl": coverUrl,
        "latitude": latitude,
        "longitude": longitude,
        "distance": distance,
        "isFollowing": isFollowing,
        "firstName": firstName,
        "lastName": lastName,
        "fullName": fullName,
        "inTouchPointName": inTouchPointName,
        "photo": photo,
        "archiveStatus": archiveStatus,
        "profileType": profileType,
        "accountType": accountType,
        "isHealthcareProvider": isHealthcareProvider,
        "id": id == null ? "null" : id,
        "isValid": isValid,
    };
}
