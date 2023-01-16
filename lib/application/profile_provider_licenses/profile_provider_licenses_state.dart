part of 'profile_provider_licenses_bloc.dart';

class ProfileProviderLicensesState {
  final bool hasReachedMax;
  final List<LicensesResponse> posts;
  final ProfileProviderStatus status;
  final String message;
  ProfileProviderLicensesState({
    this.status = ProfileProviderStatus.initial,
    this.hasReachedMax = false,
    this.posts = const <LicensesResponse>[],
    this.message = "",
  });

  copyWith({
    bool hasReachedMax,
    List<LicensesResponse> posts,
    ProfileProviderStatus status,
    String message,
  }) {
    return ProfileProviderLicensesState(
        hasReachedMax: (hasReachedMax) ?? this.hasReachedMax,
        posts: (posts) ?? this.posts,
        status: (status) ?? this.status,
        message: (message) ?? this.message);
  }
}

class ChangeFileSuccess extends ProfileProviderLicensesState {
  final File file;
  final bool fileIsImage;
  ChangeFileSuccess({this.file, this.fileIsImage});
}

class AddLicenseSuccess extends ProfileProviderLicensesState {
  final NewLicenseResponse license;
  AddLicenseSuccess({this.license});
}

class LoadingState extends ProfileProviderLicensesState {}

class ErrorState extends ProfileProviderLicensesState {
  final String errosState;
  ErrorState({this.errosState});
}

class InvalidState extends ProfileProviderLicensesState {
}

class SuccessUpdateProfile extends ProfileProviderLicensesState {
  final NewLicenseResponse license;
  SuccessUpdateProfile({this.license});
}

class UpdateSelectedLicenseAfterSuccessState
    extends ProfileProviderLicensesState {
  final int index;
  final NewLicenseResponse license;
  UpdateSelectedLicenseAfterSuccessState({this.license, this.index});
}
