import 'dart:convert';

class LoginResponse {
  bool isLookingForJob;
  String specification;
  String subSpecification;
  String userId;
  String cultureCode;
  String firstName;
  String lastName;
  String inTouchPointName;
  int gender;
  String birthdate;
  String email;
  String photoUrl;
  String country;
  String city;
  String mobile;
  double latitude;
  double longitude;
  int userType;
  String accessToken;
  String tokenType;
  String tokenIssuedDate;
  String tokenExpiresDate;
  bool isProfileComplete;

  LoginResponse({
    this.isLookingForJob,
    this.specification,
    this.subSpecification,
    this.userId,
    this.cultureCode,
    this.firstName,
    this.lastName,
    this.inTouchPointName,
    this.gender,
    this.birthdate,
    this.email,
    this.photoUrl,
    this.country,
    this.city,
    this.mobile,
    this.latitude,
    this.longitude,
    this.userType,
    this.accessToken,
    this.tokenType,
    this.tokenIssuedDate,
    this.tokenExpiresDate,
    this.isProfileComplete,
  });

  Map<String, dynamic> toMap() {
    return {
      'isLookingForJob': isLookingForJob,
      'specification': specification,
      'subSpecification': subSpecification,
      'userId': userId,
      'cultureCode': cultureCode,
      'firstName': firstName,
      'lastName': lastName,
      'inTouchPointName': inTouchPointName,
      'gender': gender,
      'birthdate': birthdate,
      'email': email,
      'photoUrl': photoUrl,
      'country': country,
      'city': city,
      'mobile': mobile,
      'latitude': latitude,
      'longitude': longitude,
      'userType': userType,
      'accessToken': accessToken,
      'tokenType': tokenType,
      'tokenIssuedDate': tokenIssuedDate,
      'tokenExpiresDate': tokenExpiresDate,
      'isProfileComplete': isProfileComplete,
    };
  }

  factory LoginResponse.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return LoginResponse(
      isLookingForJob: map['isLookingForJob'],
      specification: map['specification'],
      subSpecification: map['subSpecification'],
      userId: map['userId'],
      cultureCode: map['cultureCode'],
      firstName: map['firstName'],
      lastName: map['lastName'],
      inTouchPointName: map['inTouchPointName'],
      gender: map['gender'],
      birthdate: map['birthdate'],
      email: map['email'],
      photoUrl: map['photoUrl'],
      country: map['country'],
      city: map['city'],
      mobile: map['mobile'],
      latitude: map['latitude'],
      longitude: map['longitude'],
      userType: map['userType'],
      accessToken: map['accessToken'],
      tokenType: map['tokenType'],
      tokenIssuedDate: map['tokenIssuedDate'],
      tokenExpiresDate: map['tokenExpiresDate'],
      isProfileComplete: map['isProfileComplete'],
    );
  }

  String toJson() => json.encode(toMap());

  factory LoginResponse.fromJson(String source) =>
      LoginResponse.fromMap(json.decode(source));
}
