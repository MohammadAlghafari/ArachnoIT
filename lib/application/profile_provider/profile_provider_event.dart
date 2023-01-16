part of 'profile_provider_bloc.dart';

abstract class ProfileProviderEvent extends Equatable {
  const ProfileProviderEvent();

  @override
  List<Object> get props => [];
}

class GetProfileInfoEvent extends ProfileProviderEvent {
  final String userId;
  GetProfileInfoEvent({@required this.userId});
}

class DownloadFile extends ProfileProviderEvent {
  final String url;
  final String fileName;
  DownloadFile({this.url, this.fileName});
}

class UpdateContactInfo extends ProfileProviderEvent {
  final String personId;
  final String cityId;
  final String phone;
  final String workPhone;
  final String mobile;
  final String address;
  final BuildContext context;
  UpdateContactInfo({
    this.personId,
    this.cityId,
    this.phone,
    this.workPhone,
    this.mobile,
    this.address,
    @required this.context,
  });
}

class GetCountry extends ProfileProviderEvent {
  final BuildContext context;
  GetCountry({this.context});

}

class GetAllCityByCountryEvent extends ProfileProviderEvent {
  final String countryId;
  final BuildContext context;
  GetAllCityByCountryEvent({this.countryId,this.context});
}




class UpdateHealthCareContactInfo extends ProfileProviderEvent {
  final ContactResponse newContactValue;
  final ProfileInfoResponse profileInfo;
  final String country;
  final String city;
  UpdateHealthCareContactInfo({
    this.newContactValue,
    this.profileInfo,
    this.country,
    this.city,
  });
}

class UpdateSocailNetworkEvent extends ProfileProviderEvent {
  final String facebook;
  final String twiter;
  final String instagram;
  final String telegram;
  final String youtube;
  final String whatsApp;
  final String linkedIn;
  final BuildContext context;
  UpdateSocailNetworkEvent({
    this.facebook,
    this.instagram,
    this.linkedIn,
    this.telegram,
    this.whatsApp,
    this.context,
    this.youtube,
    this.twiter,
  });
}

class UpdateHealthCareSocailInfo extends ProfileProviderEvent {
  final ProfileInfoResponse profileInfo;
  final String facebook;
  final String twiter;
  final String instagram;
  final String telegram;
  final String youtube;
  final String whatsApp;
  final String linkedIn;
  UpdateHealthCareSocailInfo({
    this.profileInfo,
    this.youtube,
    this.twiter,
    this.whatsApp,
    this.telegram,
    this.instagram,
    this.facebook,
    this.linkedIn,
  });
}

class GetSpecificationsEvent extends ProfileProviderEvent {
  const GetSpecificationsEvent({this.accountTypeId,this.context});
  final int accountTypeId;
  final BuildContext context;
}

class GetSubSpecificationsEvent extends ProfileProviderEvent {
  const GetSubSpecificationsEvent({this.specificationId,this.context});
  final String specificationId;
  final BuildContext context;
  /* @override
  List<Object> get props => [specificationId]; */
}

class ChangeImageScreen extends ProfileProviderEvent {
  final File image;
  final bool isDeleteImage;
  final BuildContext context;
  ChangeImageScreen({this.image, this.isDeleteImage,@required this.context});
}

class ChangeUserInfo extends ProfileProviderEvent {
  final String firstName;
  final String lastName;
  final int gender;
  final String birthdate;
  final String summary;
  final String inTouchPointName;
  final String subSpecificationId;
  final String organizationTypeId;
  final BuildContext context;

  ChangeUserInfo(
      {@required this.firstName,
      @required this.lastName,
      @required this.gender,
      @required this.birthdate,
      @required this.summary,
      @required this.inTouchPointName,
      @required this.subSpecificationId,
      this.organizationTypeId,
      @required this.context});
}

class UpdateNormalUserContactInfoManual extends ProfileProviderEvent {
  final ContactResponse newContactValue;
  final ProfileInfoResponse profileInfo;
  final String country;
  final String city;
  UpdateNormalUserContactInfoManual({
    this.newContactValue,
    this.profileInfo,
    this.country,
    this.city,
  });
}


class ChangeNormalUserInfo extends ProfileProviderEvent{
  final String firstName;
  final String lastName;
  final int gender;
  final String birthdate;
  final String summary;
  final BuildContext context;

  ChangeNormalUserInfo(
      {@required this.firstName,
      @required this.lastName,
      @required this.gender,
      @required this.birthdate,
      @required this.summary,
      @required this.context});
}