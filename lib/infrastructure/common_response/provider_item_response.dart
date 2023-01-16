import 'dart:convert';

class ProviderItemResponse {
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
  String coverUrl;
  double latitude;
  double longitude;
  double distance;
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
  ProviderItemResponse({
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

  ProviderItemResponse copyWith({
    String summary,
    String specification,
    String subSpecification,
    bool isLookingForJob,
    String country,
    String city,
    String mobile,
    String homePhone,
    String workPhone,
    String email,
    bool addedToFavoriteList,
    String coverUrl,
    double latitude,
    double longitude,
    double distance,
    bool isFollowing,
    String firstName,
    String lastName,
    String fullName,
    String inTouchPointName,
    String photo,
    int archiveStatus,
    int profileType,
    int accountType,
    bool isHealthcareProvider,
    String id,
    bool isValid,
  }) {
    return ProviderItemResponse(
      summary: summary ?? this.summary,
      specification: specification ?? this.specification,
      subSpecification: subSpecification ?? this.subSpecification,
      isLookingForJob: isLookingForJob ?? this.isLookingForJob,
      country: country ?? this.country,
      city: city ?? this.city,
      mobile: mobile ?? this.mobile,
      homePhone: homePhone ?? this.homePhone,
      workPhone: workPhone ?? this.workPhone,
      email: email ?? this.email,
      addedToFavoriteList: addedToFavoriteList ?? this.addedToFavoriteList,
      coverUrl: coverUrl ?? this.coverUrl,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      distance: distance ?? this.distance,
      isFollowing: isFollowing ?? this.isFollowing,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      fullName: fullName ?? this.fullName,
      inTouchPointName: inTouchPointName ?? this.inTouchPointName,
      photo: photo ?? this.photo,
      archiveStatus: archiveStatus ?? this.archiveStatus,
      profileType: profileType ?? this.profileType,
      accountType: accountType ?? this.accountType,
      isHealthcareProvider: isHealthcareProvider ?? this.isHealthcareProvider,
      id: id ?? this.id,
      isValid: isValid ?? this.isValid,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'summary': summary,
      'specification': specification,
      'subSpecification': subSpecification,
      'isLookingForJob': isLookingForJob,
      'country': country,
      'city': city,
      'mobile': mobile,
      'homePhone': homePhone,
      'workPhone': workPhone,
      'email': email,
      'addedToFavoriteList': addedToFavoriteList,
      'coverUrl': coverUrl,
      'latitude': latitude,
      'longitude': longitude,
      'distance': distance,
      'isFollowing': isFollowing,
      'firstName': firstName,
      'lastName': lastName,
      'fullName': fullName,
      'inTouchPointName': inTouchPointName,
      'photo': photo,
      'archiveStatus': archiveStatus,
      'profileType': profileType,
      'accountType': accountType,
      'isHealthcareProvider': isHealthcareProvider,
      'id': id,
      'isValid': isValid,
    };
  }

  factory ProviderItemResponse.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
  
    return ProviderItemResponse(
      summary: map['summary'],
      specification: map['specification'],
      subSpecification: map['subSpecification'],
      isLookingForJob: map['isLookingForJob'],
      country: map['country'],
      city: map['city'],
      mobile: map['mobile'],
      homePhone: map['homePhone'],
      workPhone: map['workPhone'],
      email: map['email'],
      addedToFavoriteList: map['addedToFavoriteList'],
      coverUrl: map['coverUrl'],
      latitude: map['latitude'],
      longitude: map['longitude'],
      distance: map['distance'],
      isFollowing: map['isFollowing'],
      firstName: map['firstName'],
      lastName: map['lastName'],
      fullName: map['fullName'],
      inTouchPointName: map['inTouchPointName'],
      photo: map['photo'],
      archiveStatus: map['archiveStatus'],
      profileType: map['profileType'],
      accountType: map['accountType'],
      isHealthcareProvider: map['isHealthcareProvider'],
      id: map['id'],
      isValid: map['isValid'],
    );
  }

  String toJson() => json.encode(toMap());

  factory ProviderItemResponse.fromJson(String source) => ProviderItemResponse.fromMap(json.decode(source));

  @override
  String toString() {
    return 'ProviderItemResponse(summary: $summary, specification: $specification, subSpecification: $subSpecification, isLookingForJob: $isLookingForJob, country: $country, city: $city, mobile: $mobile, homePhone: $homePhone, workPhone: $workPhone, email: $email, addedToFavoriteList: $addedToFavoriteList, coverUrl: $coverUrl, latitude: $latitude, longitude: $longitude, distance: $distance, isFollowing: $isFollowing, firstName: $firstName, lastName: $lastName, fullName: $fullName, inTouchPointName: $inTouchPointName, photo: $photo, archiveStatus: $archiveStatus, profileType: $profileType, accountType: $accountType, isHealthcareProvider: $isHealthcareProvider, id: $id, isValid: $isValid)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;
  
    return o is ProviderItemResponse &&
      o.summary == summary &&
      o.specification == specification &&
      o.subSpecification == subSpecification &&
      o.isLookingForJob == isLookingForJob &&
      o.country == country &&
      o.city == city &&
      o.mobile == mobile &&
      o.homePhone == homePhone &&
      o.workPhone == workPhone &&
      o.email == email &&
      o.addedToFavoriteList == addedToFavoriteList &&
      o.coverUrl == coverUrl &&
      o.latitude == latitude &&
      o.longitude == longitude &&
      o.distance == distance &&
      o.isFollowing == isFollowing &&
      o.firstName == firstName &&
      o.lastName == lastName &&
      o.fullName == fullName &&
      o.inTouchPointName == inTouchPointName &&
      o.photo == photo &&
      o.archiveStatus == archiveStatus &&
      o.profileType == profileType &&
      o.accountType == accountType &&
      o.isHealthcareProvider == isHealthcareProvider &&
      o.id == id &&
      o.isValid == isValid;
  }

  @override
  int get hashCode {
    return summary.hashCode ^
      specification.hashCode ^
      subSpecification.hashCode ^
      isLookingForJob.hashCode ^
      country.hashCode ^
      city.hashCode ^
      mobile.hashCode ^
      homePhone.hashCode ^
      workPhone.hashCode ^
      email.hashCode ^
      addedToFavoriteList.hashCode ^
      coverUrl.hashCode ^
      latitude.hashCode ^
      longitude.hashCode ^
      distance.hashCode ^
      isFollowing.hashCode ^
      firstName.hashCode ^
      lastName.hashCode ^
      fullName.hashCode ^
      inTouchPointName.hashCode ^
      photo.hashCode ^
      archiveStatus.hashCode ^
      profileType.hashCode ^
      accountType.hashCode ^
      isHealthcareProvider.hashCode ^
      id.hashCode ^
      isValid.hashCode;
  }
}
