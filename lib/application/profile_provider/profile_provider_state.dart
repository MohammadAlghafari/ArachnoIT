part of 'profile_provider_bloc.dart';

enum ProfileProviderStatus {
  initial,
  loading,
  success,
  failure,
  invalid,
  deleteItemSuccess,
  failedDelete
}

class QualificationItems {
  bool hasReachedMax;
  List<QualificationsResponse> posts;
  ProfileProviderStatus status;
  QualificationItems({
    this.hasReachedMax = false,
    this.posts = const <QualificationsResponse>[],
    this.status = ProfileProviderStatus.initial,
  });
}

class ProfileProviderState {
  final QualificationItems lectures;
  final QualificationItems projects;

  ProfileProviderState({this.projects, this.lectures});
  copyWith({QualificationItems lectures, QualificationItems projects}) {
    return ProfileProviderState(
        lectures: (lectures) ?? this.lectures,
        projects: (projects) ?? this.projects);
  }
}

class LoadingProviderInfo extends ProfileProviderState {}

class RemoteUserValidationErrorState extends ProfileProviderState {
  RemoteUserValidationErrorState({this.remoteValidationErrorMessage});
  final String remoteValidationErrorMessage;
}

class RemoteUserProviderServerErrorState extends ProfileProviderState {
  RemoteUserProviderServerErrorState({this.remoteServerErrorMessage});

  final String remoteServerErrorMessage;
}

class RemoteUserClientErrorState extends ProfileProviderState {
  RemoteUserClientErrorState({this.remoteClientErrorMessage});
  final String remoteClientErrorMessage;
}



class SuccessGetProviderProfile extends ProfileProviderState {
  final ProfileInfoResponse profileInfoResponse;
  SuccessGetProviderProfile({this.profileInfoResponse});
}

class SuccessUpdateContactInfo extends ProfileProviderState {
  final ContactResponse contactResponse;
  SuccessUpdateContactInfo({@required this.contactResponse});
}

class GetAllCountriesState extends ProfileProviderState {
  final List<CountryResponse> countriesList;
  GetAllCountriesState({this.countriesList});
}

class GetAllCitiesByCountrySuccessState extends ProfileProviderState {
  final List<CitiesByCountryResponse> citiesList;
  GetAllCitiesByCountrySuccessState({this.citiesList});
}

class SuccessUpdateSocial extends ProfileProviderState {}

class SuccessGetALLSpecification extends ProfileProviderState {
  final List<SpecificationResponse> items;
  SuccessGetALLSpecification({this.items});
}

class SuccessGetAllSubSpecification extends ProfileProviderState {
  final List<SubSpecificationResponse> items;
  SuccessGetAllSubSpecification({this.items});
}

class SuccessChangeImage extends ProfileProviderState {
  final File image;
  SuccessChangeImage({this.image});
}

class SuccessUpdateUserInfo extends ProfileProviderState {}

class InvalidState extends ProfileProviderState {}
