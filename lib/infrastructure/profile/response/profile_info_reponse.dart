// To parse this JSON data, do
//
//     final profileInfoResponse = profileInfoResponseFromJson(jsonString);

import 'dart:convert';

ProfileInfoResponse profileInfoResponseFromJson(String str) => ProfileInfoResponse.fromJson(json.decode(str));

String profileInfoResponseToJson(ProfileInfoResponse data) => json.encode(data.toJson());

class ProfileInfoResponse {
    ProfileInfoResponse({
        this.accountType,
        this.healthcareProviderProfileDto,
        this.normalUserProfileDto,
    });

    int accountType;
    HealthCareProviderProfileDto healthcareProviderProfileDto;
    NormalUserProfileDto normalUserProfileDto;

    factory ProfileInfoResponse.fromJson(Map<String, dynamic> json) => ProfileInfoResponse(
        accountType: json["accountType"] == null ? null : json["accountType"],
        healthcareProviderProfileDto: json["healthcareProviderProfileDto"] == null ? null : HealthCareProviderProfileDto.fromJson(json["healthcareProviderProfileDto"]),
        normalUserProfileDto: json["normalUserProfileDto"] == null ? null : NormalUserProfileDto.fromJson(json["normalUserProfileDto"]),
    );

    Map<String, dynamic> toJson() => {
        "accountType": accountType == null ? null : accountType,
        "healthcareProviderProfileDto": healthcareProviderProfileDto == null ? null : healthcareProviderProfileDto.toJson(),
        "normalUserProfileDto": normalUserProfileDto == null ? null : normalUserProfileDto.toJson(),
    };
}

class HealthCareProviderProfileDto {
    HealthCareProviderProfileDto({
        this.isFollowingHcp,
        this.followersCount,
        this.isPaperSent,
        this.addedToFavoriteList,
        this.specification,
        this.specificationId,
        this.subSpecification,
        this.subSpecificationId,
        this.levels,
        this.whatWeDo,
        this.hasServices,
        this.services,
        this.endorsements,
        this.accountTypeId,
        this.accountType,
        this.isLookingForJob,
        this.organizationType,
        this.parentHealthcareProvider,
        this.lecturesCount,
        this.hasLectures,
        this.licensesCount,
        this.hasLicenses,
        this.coursesCount,
        this.hasCourses,
        this.certificatesCount,
        this.hasCertificates,
        this.educationsCount,
        this.hasEducations,
        this.experiencesCount,
        this.hasExperiences,
        this.projectsCount,
        this.hasProjects,
        this.skillsCount,
        this.hasSkills,
        this.languageSkillsCount,
        this.hasLanguageSkills,
        this.volunteeringCount,
        this.hasVolunteering,
        this.productsCount,
        this.hasProducts,
        this.awardsCount,
        this.hasAwards,
        this.patentsCount,
        this.hasPatents,
        this.departmentsCount,
        this.hasDepartment,
        this.blogsCount,
        this.answersCount,
        this.id,
        this.firstName,
        this.lastName,
        this.fullName,
        this.inTouchPointName,
        this.hasSlider,
        this.sliderContent,
        this.profilePhotoUrl,
        this.summary,
        this.email,
        this.country,
        this.countryId,
        this.city,
        this.cityId,
        this.gender,
        this.birthdate,
        this.followingCount,
        this.publicGroupsCount,
        this.hasMedia,
        this.mobile,
        this.homePhone,
        this.workPhone,
        this.address,
        this.longitude,
        this.latitude,
        this.questionsCount,
        this.facebook,
        this.twiter,
        this.instagram,
        this.telegram,
        this.youtube,
        this.whatsApp,
        this.linkedIn,
    });

    bool isFollowingHcp;
    int followersCount;
    bool isPaperSent;
    bool addedToFavoriteList;
    String specification;
    String specificationId;
    String subSpecification;
    String subSpecificationId;
    List<OrganizationType> levels;
    String whatWeDo;
    bool hasServices;
    List<Service> services;
    List<Endorsement> endorsements;
    String accountTypeId;
    int accountType;
    bool isLookingForJob;
    OrganizationType organizationType;
    OrganizationType parentHealthcareProvider;
    int lecturesCount;
    bool hasLectures;
    int licensesCount;
    bool hasLicenses;
    int coursesCount;
    bool hasCourses;
    int certificatesCount;
    bool hasCertificates;
    int educationsCount;
    bool hasEducations;
    int experiencesCount;
    bool hasExperiences;
    int projectsCount;
    bool hasProjects;
    int skillsCount;
    bool hasSkills;
    int languageSkillsCount;
    bool hasLanguageSkills;
    int volunteeringCount;
    bool hasVolunteering;
    int productsCount;
    bool hasProducts;
    int awardsCount;
    bool hasAwards;
    int patentsCount;
    bool hasPatents;
    int departmentsCount;
    bool hasDepartment;
    int blogsCount;
    int answersCount;
    String id;
    String firstName;
    String lastName;
    String fullName;
    String inTouchPointName;
    bool hasSlider;
    List<SliderContent> sliderContent;
    String profilePhotoUrl;
    String summary;
    String email;
    String country;
    String countryId;
    String city;
    String cityId;
    int gender;
    DateTime birthdate;
    int followingCount;
    int publicGroupsCount;
    bool hasMedia;
    String mobile;
    String homePhone;
    String workPhone;
    String address;
    double longitude;
    double latitude;
    int questionsCount;
    String facebook;
    String twiter;
    String instagram;
    String telegram;
    String youtube;
    String whatsApp;
    String linkedIn;

    factory HealthCareProviderProfileDto.fromJson(Map<String, dynamic> json) => HealthCareProviderProfileDto(
        isFollowingHcp: json["isFollowingHCP"] == null ? null : json["isFollowingHCP"],
        followersCount: json["followersCount"] == null ? null : json["followersCount"],
        isPaperSent: json["isPaperSent"] == null ? null : json["isPaperSent"],
        addedToFavoriteList: json["addedToFavoriteList"] == null ? null : json["addedToFavoriteList"],
        specification: json["specification"] == null ? null : json["specification"],
        specificationId: json["specificationId"] == null ? null : json["specificationId"],
        subSpecification: json["subSpecification"] == null ? null : json["subSpecification"],
        subSpecificationId: json["subSpecificationId"] == null ? null : json["subSpecificationId"],
        levels: json["levels"] == null ? null : List<OrganizationType>.from(json["levels"].map((x) => OrganizationType.fromJson(x))),
        whatWeDo: json["whatWeDo"] == null ? null : json["whatWeDo"],
        hasServices: json["hasServices"] == null ? null : json["hasServices"],
        services: json["services"] == null ? null : List<Service>.from(json["services"].map((x) => Service.fromJson(x))),
        endorsements: json["endorsements"] == null ? null : List<Endorsement>.from(json["endorsements"].map((x) => Endorsement.fromJson(x))),
        accountTypeId: json["accountTypeId"] == null ? null : json["accountTypeId"],
        accountType: json["accountType"] == null ? null : json["accountType"],
        isLookingForJob: json["isLookingForJob"] == null ? null : json["isLookingForJob"],
        organizationType: json["organizationType"] == null ? null : OrganizationType.fromJson(json["organizationType"]),
        parentHealthcareProvider: json["parentHealthcareProvider"] == null ? null : OrganizationType.fromJson(json["parentHealthcareProvider"]),
        lecturesCount: json["lecturesCount"] == null ? null : json["lecturesCount"],
        hasLectures: json["hasLectures"] == null ? null : json["hasLectures"],
        licensesCount: json["licensesCount"] == null ? null : json["licensesCount"],
        hasLicenses: json["hasLicenses"] == null ? null : json["hasLicenses"],
        coursesCount: json["coursesCount"] == null ? null : json["coursesCount"],
        hasCourses: json["hasCourses"] == null ? null : json["hasCourses"],
        certificatesCount: json["certificatesCount"] == null ? null : json["certificatesCount"],
        hasCertificates: json["hasCertificates"] == null ? null : json["hasCertificates"],
        educationsCount: json["educationsCount"] == null ? null : json["educationsCount"],
        hasEducations: json["hasEducations"] == null ? null : json["hasEducations"],
        experiencesCount: json["experiencesCount"] == null ? null : json["experiencesCount"],
        hasExperiences: json["hasExperiences"] == null ? null : json["hasExperiences"],
        projectsCount: json["projectsCount"] == null ? null : json["projectsCount"],
        hasProjects: json["hasProjects"] == null ? null : json["hasProjects"],
        skillsCount: json["skillsCount"] == null ? null : json["skillsCount"],
        hasSkills: json["hasSkills"] == null ? null : json["hasSkills"],
        languageSkillsCount: json["languageSkillsCount"] == null ? null : json["languageSkillsCount"],
        hasLanguageSkills: json["hasLanguageSkills"] == null ? null : json["hasLanguageSkills"],
        volunteeringCount: json["volunteeringCount"] == null ? null : json["volunteeringCount"],
        hasVolunteering: json["hasVolunteering"] == null ? null : json["hasVolunteering"],
        productsCount: json["productsCount"] == null ? null : json["productsCount"],
        hasProducts: json["hasProducts"] == null ? null : json["hasProducts"],
        awardsCount: json["awardsCount"] == null ? null : json["awardsCount"],
        hasAwards: json["hasAwards"] == null ? null : json["hasAwards"],
        patentsCount: json["patentsCount"] == null ? null : json["patentsCount"],
        hasPatents: json["hasPatents"] == null ? null : json["hasPatents"],
        departmentsCount: json["departmentsCount"] == null ? null : json["departmentsCount"],
        hasDepartment: json["hasDepartment"] == null ? null : json["hasDepartment"],
        blogsCount: json["blogsCount"] == null ? null : json["blogsCount"],
        answersCount: json["answersCount"] == null ? null : json["answersCount"],
        id: json["id"] == null ? null : json["id"],
        firstName: json["firstName"] == null ? null : json["firstName"],
        lastName: json["lastName"] == null ? null : json["lastName"],
        fullName: json["fullName"] == null ? null : json["fullName"],
        inTouchPointName: json["inTouchPointName"] == null ? null : json["inTouchPointName"],
        hasSlider: json["hasSlider"] == null ? null : json["hasSlider"],
        sliderContent: json["sliderContent"] == null ? null : List<SliderContent>.from(json["sliderContent"].map((x) => SliderContent.fromJson(x))),
        profilePhotoUrl: json["profilePhotoUrl"] == null ? null : json["profilePhotoUrl"],
        summary: json["summary"] == null ? null : json["summary"],
        email: json["email"] == null ? null : json["email"],
        country: json["country"] == null ? null : json["country"],
        countryId: json["countryId"] == null ? null : json["countryId"],
        city: json["city"] == null ? null : json["city"],
        cityId: json["cityId"] == null ? null : json["cityId"],
        gender: json["gender"] == null ? null : json["gender"],
        birthdate: json["birthdate"] == null ? null : DateTime.parse(json["birthdate"]),
        followingCount: json["followingCount"] == null ? null : json["followingCount"],
        publicGroupsCount: json["publicGroupsCount"] == null ? null : json["publicGroupsCount"],
        hasMedia: json["hasMedia"] == null ? null : json["hasMedia"],
        mobile: json["mobile"] == null ? null : json["mobile"],
        homePhone: json["homePhone"] == null ? null : json["homePhone"],
        workPhone: json["workPhone"] == null ? null : json["workPhone"],
        address: json["address"] == null ? null : json["address"],
        longitude: json["longitude"] == null ? null : json["longitude"].toDouble(),
        latitude: json["latitude"] == null ? null : json["latitude"].toDouble(),
        questionsCount: json["questionsCount"] == null ? null : json["questionsCount"],
        facebook: json["facebook"] == null ? null : json["facebook"],
        twiter: json["twiter"] == null ? null : json["twiter"],
        instagram: json["instagram"] == null ? null : json["instagram"],
        telegram: json["telegram"] == null ? null : json["telegram"],
        youtube: json["youtube"] == null ? null : json["youtube"],
        whatsApp: json["whatsApp"] == null ? null : json["whatsApp"],
        linkedIn: json["linkedIn"] == null ? null : json["linkedIn"],
    );

    Map<String, dynamic> toJson() => {
        "isFollowingHCP": isFollowingHcp == null ? null : isFollowingHcp,
        "followersCount": followersCount == null ? null : followersCount,
        "isPaperSent": isPaperSent == null ? null : isPaperSent,
        "addedToFavoriteList": addedToFavoriteList == null ? null : addedToFavoriteList,
        "specification": specification == null ? null : specification,
        "specificationId": specificationId == null ? null : specificationId,
        "subSpecification": subSpecification == null ? null : subSpecification,
        "subSpecificationId": subSpecificationId == null ? null : subSpecificationId,
        "levels": levels == null ? null : List<dynamic>.from(levels.map((x) => x.toJson())),
        "whatWeDo": whatWeDo == null ? null : whatWeDo,
        "hasServices": hasServices == null ? null : hasServices,
        "services": services == null ? null : List<dynamic>.from(services.map((x) => x.toJson())),
        "endorsements": endorsements == null ? null : List<dynamic>.from(endorsements.map((x) => x.toJson())),
        "accountTypeId": accountTypeId == null ? null : accountTypeId,
        "accountType": accountType == null ? null : accountType,
        "isLookingForJob": isLookingForJob == null ? null : isLookingForJob,
        "organizationType": organizationType == null ? null : organizationType.toJson(),
        "parentHealthcareProvider": parentHealthcareProvider == null ? null : parentHealthcareProvider.toJson(),
        "lecturesCount": lecturesCount == null ? null : lecturesCount,
        "hasLectures": hasLectures == null ? null : hasLectures,
        "licensesCount": licensesCount == null ? null : licensesCount,
        "hasLicenses": hasLicenses == null ? null : hasLicenses,
        "coursesCount": coursesCount == null ? null : coursesCount,
        "hasCourses": hasCourses == null ? null : hasCourses,
        "certificatesCount": certificatesCount == null ? null : certificatesCount,
        "hasCertificates": hasCertificates == null ? null : hasCertificates,
        "educationsCount": educationsCount == null ? null : educationsCount,
        "hasEducations": hasEducations == null ? null : hasEducations,
        "experiencesCount": experiencesCount == null ? null : experiencesCount,
        "hasExperiences": hasExperiences == null ? null : hasExperiences,
        "projectsCount": projectsCount == null ? null : projectsCount,
        "hasProjects": hasProjects == null ? null : hasProjects,
        "skillsCount": skillsCount == null ? null : skillsCount,
        "hasSkills": hasSkills == null ? null : hasSkills,
        "languageSkillsCount": languageSkillsCount == null ? null : languageSkillsCount,
        "hasLanguageSkills": hasLanguageSkills == null ? null : hasLanguageSkills,
        "volunteeringCount": volunteeringCount == null ? null : volunteeringCount,
        "hasVolunteering": hasVolunteering == null ? null : hasVolunteering,
        "productsCount": productsCount == null ? null : productsCount,
        "hasProducts": hasProducts == null ? null : hasProducts,
        "awardsCount": awardsCount == null ? null : awardsCount,
        "hasAwards": hasAwards == null ? null : hasAwards,
        "patentsCount": patentsCount == null ? null : patentsCount,
        "hasPatents": hasPatents == null ? null : hasPatents,
        "departmentsCount": departmentsCount == null ? null : departmentsCount,
        "hasDepartment": hasDepartment == null ? null : hasDepartment,
        "blogsCount": blogsCount == null ? null : blogsCount,
        "answersCount": answersCount == null ? null : answersCount,
        "id": id == null ? null : id,
        "firstName": firstName == null ? null : firstName,
        "lastName": lastName == null ? null : lastName,
        "fullName": fullName == null ? null : fullName,
        "inTouchPointName": inTouchPointName == null ? null : inTouchPointName,
        "hasSlider": hasSlider == null ? null : hasSlider,
        "sliderContent": sliderContent == null ? null : List<dynamic>.from(sliderContent.map((x) => x.toJson())),
        "profilePhotoUrl": profilePhotoUrl == null ? null : profilePhotoUrl,
        "summary": summary == null ? null : summary,
        "email": email == null ? null : email,
        "country": country == null ? null : country,
        "countryId": countryId == null ? null : countryId,
        "city": city == null ? null : city,
        "cityId": cityId == null ? null : cityId,
        "gender": gender == null ? null : gender,
        "birthdate": birthdate == null ? null : birthdate.toIso8601String(),
        "followingCount": followingCount == null ? null : followingCount,
        "publicGroupsCount": publicGroupsCount == null ? null : publicGroupsCount,
        "hasMedia": hasMedia == null ? null : hasMedia,
        "mobile": mobile == null ? null : mobile,
        "homePhone": homePhone == null ? null : homePhone,
        "workPhone": workPhone == null ? null : workPhone,
        "address": address == null ? null : address,
        "longitude": longitude == null ? null : longitude,
        "latitude": latitude == null ? null : latitude,
        "questionsCount": questionsCount == null ? null : questionsCount,
        "facebook": facebook == null ? null : facebook,
        "twiter": twiter == null ? null : twiter,
        "instagram": instagram == null ? null : instagram,
        "telegram": telegram == null ? null : telegram,
        "youtube": youtube == null ? null : youtube,
        "whatsApp": whatsApp == null ? null : whatsApp,
        "linkedIn": linkedIn == null ? null : linkedIn,
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

    double meanRate;
    double ratersNumber;
    double currentUserRating;
    String title;
    String iconUrl;
    String id;
    bool isValid;

    factory Endorsement.fromJson(Map<String, dynamic> json) => Endorsement(
        meanRate: json["meanRate"] == null ? null : json["meanRate"].toDouble(),
        ratersNumber: json["ratersNumber"] == null ? null : json["ratersNumber"].toDouble(),
        currentUserRating: json["currentUserRating"] == null ? null : json["currentUserRating"].toDouble(),
        title: json["title"] == null ? null : json["title"],
        iconUrl: json["iconUrl"] == null ? null : json["iconUrl"],
        id: json["id"] == null ? null : json["id"],
        isValid: json["isValid"] == null ? null : json["isValid"],
    );

    Map<String, dynamic> toJson() => {
        "meanRate": meanRate == null ? null : meanRate,
        "ratersNumber": ratersNumber == null ? null : ratersNumber,
        "currentUserRating": currentUserRating == null ? null : currentUserRating,
        "title": title == null ? null : title,
        "iconUrl": iconUrl == null ? null : iconUrl,
        "id": id == null ? null : id,
        "isValid": isValid == null ? null : isValid,
    };
}

class OrganizationType {
    OrganizationType({
        this.name,
        this.id,
        this.isValid,
    });

    String name;
    String id;
    bool isValid;

    factory OrganizationType.fromJson(Map<String, dynamic> json) => OrganizationType(
        name: json["name"] == null ? null : json["name"],
        id: json["id"] == null ? null : json["id"],
        isValid: json["isValid"] == null ? null : json["isValid"],
    );

    Map<String, dynamic> toJson() => {
        "name": name == null ? null : name,
        "id": id == null ? null : id,
        "isValid": isValid == null ? null : isValid,
    };
}

class Service {
    Service({
        this.name,
        this.description,
        this.iconUrl,
        this.fileDto,
        this.ownerId,
        this.id,
        this.isValid,
    });

    String name;
    String description;
    String iconUrl;
    FileDto fileDto;
    String ownerId;
    String id;
    bool isValid;

    factory Service.fromJson(Map<String, dynamic> json) => Service(
        name: json["name"] == null ? null : json["name"],
        description: json["description"] == null ? null : json["description"],
        iconUrl: json["iconUrl"] == null ? null : json["iconUrl"],
        fileDto: json["fileDto"] == null ? null : FileDto.fromJson(json["fileDto"]),
        ownerId: json["ownerId"] == null ? null : json["ownerId"],
        id: json["id"] == null ? null : json["id"],
        isValid: json["isValid"] == null ? null : json["isValid"],
    );

    Map<String, dynamic> toJson() => {
        "name": name == null ? null : name,
        "description": description == null ? null : description,
        "iconUrl": iconUrl == null ? null : iconUrl,
        "fileDto": fileDto == null ? null : fileDto.toJson(),
        "ownerId": ownerId == null ? null : ownerId,
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

class SliderContent {
    SliderContent({
        this.id,
        this.title,
        this.subTitle,
        this.imageUrl,
        this.order,
    });

    String id;
    String title;
    String subTitle;
    String imageUrl;
    int order;

    factory SliderContent.fromJson(Map<String, dynamic> json) => SliderContent(
        id: json["id"] == null ? null : json["id"],
        title: json["title"] == null ? null : json["title"],
        subTitle: json["subTitle"] == null ? null : json["subTitle"],
        imageUrl: json["imageUrl"] == null ? null : json["imageUrl"],
        order: json["order"] == null ? null : json["order"],
    );

    Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "title": title == null ? null : title,
        "subTitle": subTitle == null ? null : subTitle,
        "imageUrl": imageUrl == null ? null : imageUrl,
        "order": order == null ? null : order,
    };
}

class NormalUserProfileDto {
    NormalUserProfileDto({
        this.id,
        this.firstName,
        this.lastName,
        this.fullName,
        this.inTouchPointName,
        this.hasSlider,
        this.sliderContent,
        this.profilePhotoUrl,
        this.summary,
        this.email,
        this.country,
        this.countryId,
        this.city,
        this.cityId,
        this.gender,
        this.birthdate,
        this.followingCount,
        this.publicGroupsCount,
        this.hasMedia,
        this.mobile,
        this.homePhone,
        this.workPhone,
        this.address,
        this.longitude,
        this.latitude,
        this.questionsCount,
        this.facebook,
        this.twiter,
        this.instagram,
        this.telegram,
        this.youtube,
        this.whatsApp,
        this.linkedIn,
    });

    String id;
    String firstName;
    String lastName;
    String fullName;
    String inTouchPointName;
    bool hasSlider;
    List<SliderContent> sliderContent;
    String profilePhotoUrl;
    String summary;
    String email;
    String country;
    String countryId;
    String city;
    String cityId;
    int gender;
    DateTime birthdate;
    int followingCount;
    int publicGroupsCount;
    bool hasMedia;
    String mobile;
    String homePhone;
    String workPhone;
    String address;
    double longitude;
    double latitude;
    int questionsCount;
    String facebook;
    String twiter;
    String instagram;
    String telegram;
    String youtube;
    String whatsApp;
    String linkedIn;

    factory NormalUserProfileDto.fromJson(Map<String, dynamic> json) => NormalUserProfileDto(
        id: json["id"] == null ? null : json["id"],
        firstName: json["firstName"] == null ? null : json["firstName"],
        lastName: json["lastName"] == null ? null : json["lastName"],
        fullName: json["fullName"] == null ? null : json["fullName"],
        inTouchPointName: json["inTouchPointName"] == null ? null : json["inTouchPointName"],
        hasSlider: json["hasSlider"] == null ? null : json["hasSlider"],
        sliderContent: json["sliderContent"] == null ? null : List<SliderContent>.from(json["sliderContent"].map((x) => SliderContent.fromJson(x))),
        profilePhotoUrl: json["profilePhotoUrl"] == null ? null : json["profilePhotoUrl"],
        summary: json["summary"] == null ? null : json["summary"],
        email: json["email"] == null ? null : json["email"],
        country: json["country"] == null ? null : json["country"],
        countryId: json["countryId"] == null ? null : json["countryId"],
        city: json["city"] == null ? null : json["city"],
        cityId: json["cityId"] == null ? null : json["cityId"],
        gender: json["gender"] == null ? null : json["gender"],
        birthdate: json["birthdate"] == null ? null : DateTime.parse(json["birthdate"]),
        followingCount: json["followingCount"] == null ? null : json["followingCount"],
        publicGroupsCount: json["publicGroupsCount"] == null ? null : json["publicGroupsCount"],
        hasMedia: json["hasMedia"] == null ? null : json["hasMedia"],
        mobile: json["mobile"] == null ? null : json["mobile"],
        homePhone: json["homePhone"] == null ? null : json["homePhone"],
        workPhone: json["workPhone"] == null ? null : json["workPhone"],
        address: json["address"] == null ? null : json["address"],
        longitude: json["longitude"] == null ? null : json["longitude"].toDouble(),
        latitude: json["latitude"] == null ? null : json["latitude"].toDouble(),
        questionsCount: json["questionsCount"] == null ? null : json["questionsCount"],
        facebook: json["facebook"] == null ? null : json["facebook"],
        twiter: json["twiter"] == null ? null : json["twiter"],
        instagram: json["instagram"] == null ? null : json["instagram"],
        telegram: json["telegram"] == null ? null : json["telegram"],
        youtube: json["youtube"] == null ? null : json["youtube"],
        whatsApp: json["whatsApp"] == null ? null : json["whatsApp"],
        linkedIn: json["linkedIn"] == null ? null : json["linkedIn"],
    );

    Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "firstName": firstName == null ? null : firstName,
        "lastName": lastName == null ? null : lastName,
        "fullName": fullName == null ? null : fullName,
        "inTouchPointName": inTouchPointName == null ? null : inTouchPointName,
        "hasSlider": hasSlider == null ? null : hasSlider,
        "sliderContent": sliderContent == null ? null : List<dynamic>.from(sliderContent.map((x) => x.toJson())),
        "profilePhotoUrl": profilePhotoUrl == null ? null : profilePhotoUrl,
        "summary": summary == null ? null : summary,
        "email": email == null ? null : email,
        "country": country == null ? null : country,
        "countryId": countryId == null ? null : countryId,
        "city": city == null ? null : city,
        "cityId": cityId == null ? null : cityId,
        "gender": gender == null ? null : gender,
        "birthdate": birthdate == null ? null : birthdate.toIso8601String(),
        "followingCount": followingCount == null ? null : followingCount,
        "publicGroupsCount": publicGroupsCount == null ? null : publicGroupsCount,
        "hasMedia": hasMedia == null ? null : hasMedia,
        "mobile": mobile == null ? null : mobile,
        "homePhone": homePhone == null ? null : homePhone,
        "workPhone": workPhone == null ? null : workPhone,
        "address": address == null ? null : address,
        "longitude": longitude == null ? null : longitude,
        "latitude": latitude == null ? null : latitude,
        "questionsCount": questionsCount == null ? null : questionsCount,
        "facebook": facebook == null ? null : facebook,
        "twiter": twiter == null ? null : twiter,
        "instagram": instagram == null ? null : instagram,
        "telegram": telegram == null ? null : telegram,
        "youtube": youtube == null ? null : youtube,
        "whatsApp": whatsApp == null ? null : whatsApp,
        "linkedIn": linkedIn == null ? null : linkedIn,
    };
}
