// To parse this JSON data, do
//
//     final profileFollowListResponse = profileFollowListResponseFromJson(jsonString);

import 'dart:convert';

ProfileFollowListResponse profileFollowListResponseFromJson(String str) =>
    ProfileFollowListResponse.fromJson(json.decode(str));

String profileFollowListResponseToJson(ProfileFollowListResponse data) =>
    json.encode(data.toJson());

class ProfileFollowListResponse {
  ProfileFollowListResponse({
    this.followers,
    this.following,
  });

  List<Follow> followers;
  List<Follow> following;

  factory ProfileFollowListResponse.fromJson(Map<String, dynamic> json) =>
      ProfileFollowListResponse(
        followers: json["followers"] == null
            ? null
            : List<Follow>.from(
                json["followers"].map((x) => Follow.fromJson(x))),
        following: json["following"] == null
            ? null
            : List<Follow>.from(
                json["following"].map((x) => Follow.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "followers": followers == null
            ? null
            : List<dynamic>.from(followers.map((x) => x.toJson())),
        "following": following == null
            ? null
            : List<dynamic>.from(following.map((x) => x.toJson())),
      };
}

class Follow {
  Follow({
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
    this.isVerified,
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
  String city;
  String mobile;
  String homePhone;
  String workPhone;
  String email;
  bool isVerified;
  bool addedToFavoriteList;
  String coverUrl;
  int latitude;
  int longitude;
  int distance;
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

  factory Follow.fromJson(Map<String, dynamic> json) => Follow(
        summary: json["summary"] == null ? null : json["summary"],
        specification:
            json["specification"] == null ? null : json["specification"],
        subSpecification:
            json["subSpecification"] == null ? null : json["subSpecification"],
        isLookingForJob:
            json["isLookingForJob"] == null ? null : json["isLookingForJob"],
        country: json["country"] == null ? null : json["country"],
        city: json["city"] == null ? null : json["city"],
        mobile: json["mobile"] == null ? null : json["mobile"],
        homePhone: json["homePhone"] == null ? null : json["homePhone"],
        workPhone: json["workPhone"] == null ? null : json["workPhone"],
        email: json["email"] == null ? null : json["email"],
        isVerified: json["isVerified"] == null ? null : json["isVerified"],
        addedToFavoriteList: json["addedToFavoriteList"] == null
            ? null
            : json["addedToFavoriteList"],
        coverUrl: json["coverUrl"] == null ? null : json["coverUrl"],
        latitude: json["latitude"] == null ? null : json["latitude"],
        longitude: json["longitude"] == null ? null : json["longitude"],
        distance: json["distance"] == null ? null : json["distance"],
        isFollowing: json["isFollowing"] == null ? null : json["isFollowing"],
        firstName: json["firstName"] == null ? null : json["firstName"],
        lastName: json["lastName"] == null ? null : json["lastName"],
        fullName: json["fullName"] == null ? null : json["fullName"],
        inTouchPointName:
            json["inTouchPointName"] == null ? null : json["inTouchPointName"],
        photo: json["photo"] == null ? null : json["photo"],
        archiveStatus:
            json["archiveStatus"] == null ? null : json["archiveStatus"],
        profileType: json["profileType"] == null ? null : json["profileType"],
        accountType: json["accountType"] == null ? null : json["accountType"],
        isHealthcareProvider: json["isHealthcareProvider"] == null
            ? null
            : json["isHealthcareProvider"],
        id: json["id"] == null ? null : json["id"],
        isValid: json["isValid"] == null ? null : json["isValid"],
      );

  Map<String, dynamic> toJson() => {
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
        "isVerified": isVerified == null ? null : isVerified,
        "addedToFavoriteList":
            addedToFavoriteList == null ? null : addedToFavoriteList,
        "coverUrl": coverUrl == null ? null : coverUrl,
        "latitude": latitude == null ? null : latitude,
        "longitude": longitude == null ? null : longitude,
        "distance": distance == null ? null : distance,
        "isFollowing": isFollowing == null ? null : isFollowing,
        "firstName": firstName == null ? null : firstName,
        "lastName": lastName == null ? null : lastName,
        "fullName": fullName == null ? null : fullName,
        "inTouchPointName": inTouchPointName == null ? null : inTouchPointName,
        "photo": photo == null ? null : photo,
        "archiveStatus": archiveStatus == null ? null : archiveStatus,
        "profileType": profileType == null ? null : profileType,
        "accountType": accountType == null ? null : accountType,
        "isHealthcareProvider":
            isHealthcareProvider == null ? null : isHealthcareProvider,
        "id": id == null ? null : id,
        "isValid": isValid == null ? null : isValid,
      };
}
