// To parse this JSON data, do
//
//     final briefProfileResponse = briefProfileResponseFromJson(jsonString);

import 'dart:convert';

BriefProfileResponse briefProfileResponseFromJson(String str) => BriefProfileResponse.fromJson(json.decode(str));

String briefProfileResponseToJson(BriefProfileResponse data) => json.encode(data.toJson());

class BriefProfileResponse {
    BriefProfileResponse({
        this.endorsements,
        this.isFollowingHcp,
        this.followersCount,
        this.followingCount,
        this.questionsCount,
        this.answersCount,
        this.blogsCount,
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

    List<Endorsement> endorsements;
    bool isFollowingHcp;
    int followersCount;
    int followingCount;
    int questionsCount;
    int answersCount;
    int blogsCount;
    String summary;
    String specification;
    String subSpecification;
    bool isLookingForJob;
    String country;
    String city;
    String mobile;
    String homePhone;
    String workPhone;
    String email;
    bool addedToFavoriteList;
    dynamic coverUrl;
    double latitude;
    double longitude;
    dynamic distance;
    bool isFollowing;
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

    factory BriefProfileResponse.fromJson(Map<String, dynamic> json) => BriefProfileResponse(
        endorsements: json["endorsements"] == null ? null : List<Endorsement>.from(json["endorsements"].map((x) => Endorsement.fromJson(x))),
        isFollowingHcp: json["isFollowingHCP"] == null ? null : json["isFollowingHCP"],
        followersCount: json["followersCount"] == null ? null : json["followersCount"],
        followingCount: json["followingCount"] == null ? null : json["followingCount"],
        questionsCount: json["questionsCount"] == null ? null : json["questionsCount"],
        answersCount: json["answersCount"] == null ? null : json["answersCount"],
        blogsCount: json["blogsCount"] == null ? null : json["blogsCount"],
        summary: json["summary"] == null ? null : json["summary"],
        specification: json["specification"] == null ? null : json["specification"],
        subSpecification: json["subSpecification"] == null ? null : json["subSpecification"],
        isLookingForJob: json["isLookingForJob"] == null ? null : json["isLookingForJob"],
        country: json["country"] == null ? null : json["country"],
        city: json["city"] == null ? null : json["city"],
        mobile: json["mobile"] == null ? null : json["mobile"],
        homePhone: json["homePhone"] == null ? null : json["homePhone"],
        workPhone: json["workPhone"] == null ? null : json["workPhone"],
        email: json["email"] == null ? null : json["email"],
        addedToFavoriteList: json["addedToFavoriteList"] == null ? null : json["addedToFavoriteList"],
        coverUrl: json["coverUrl"],
        latitude: json["latitude"] == null ? null : json["latitude"].toDouble(),
        longitude: json["longitude"] == null ? null : json["longitude"].toDouble(),
        distance: json["distance"],
        isFollowing: json["isFollowing"] == null ? null : json["isFollowing"],
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
        "endorsements": endorsements == null ? null : List<dynamic>.from(endorsements.map((x) => x.toJson())),
        "isFollowingHCP": isFollowingHcp == null ? null : isFollowingHcp,
        "followersCount": followersCount == null ? null : followersCount,
        "followingCount": followingCount == null ? null : followingCount,
        "questionsCount": questionsCount == null ? null : questionsCount,
        "answersCount": answersCount == null ? null : answersCount,
        "blogsCount": blogsCount == null ? null : blogsCount,
        "summary": summary == null ? null : summary,
        "specification": specification == null ? null : specification,
        "subSpecification": subSpecification == null ? null : subSpecification,
        "isLookingForJob": isLookingForJob == null ? null : isLookingForJob,
        "country": country == null ? null : country,
        "city": city == null ? null : city,
        "mobile": mobile == null ? null : mobile,
        "homePhone": homePhone == null ? null : homePhone,
        "workPhone": workPhone == null ? null : workPhone,
        "email": email == null ? null : email,
        "addedToFavoriteList": addedToFavoriteList == null ? null : addedToFavoriteList,
        "coverUrl": coverUrl,
        "latitude": latitude == null ? null : latitude,
        "longitude": longitude == null ? null : longitude,
        "distance": distance,
        "isFollowing": isFollowing == null ? null : isFollowing,
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

class Endorsement {
    Endorsement({
        this.meanRate,
        this.ratersNumber,
        this.currentUserRating,
        this.title,
        this.iconUrl,
        this.id,
        this.isValid,
    });

    dynamic meanRate;
    int ratersNumber;
    dynamic currentUserRating;
    String title;
    String iconUrl;
    String id;
    bool isValid;

    factory Endorsement.fromJson(Map<String, dynamic> json) => Endorsement(
        meanRate: json["meanRate"],
        ratersNumber: json["ratersNumber"] == null ? null : json["ratersNumber"],
        currentUserRating: json["currentUserRating"],
        title: json["title"] == null ? null : json["title"],
        iconUrl: json["iconUrl"] == null ? null : json["iconUrl"],
        id: json["id"] == null ? null : json["id"],
        isValid: json["isValid"] == null ? null : json["isValid"],
    );

    Map<String, dynamic> toJson() => {
        "meanRate": meanRate,
        "ratersNumber": ratersNumber == null ? null : ratersNumber,
        "currentUserRating": currentUserRating,
        "title": title == null ? null : title,
        "iconUrl": iconUrl == null ? null : iconUrl,
        "id": id == null ? null : id,
        "isValid": isValid == null ? null : isValid,
    };
}
