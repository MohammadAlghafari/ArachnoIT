part of 'profile_provider_certificate_bloc.dart';

class ProfileProviderCertificateState {
  final bool hasReachedMax;
  final List<CertificateResponse> posts;
  final ProfileProviderStatus status;
  final String errorsMessage;
  ProfileProviderCertificateState({
    this.hasReachedMax = false,
    this.posts = const <CertificateResponse>[],
    this.status = ProfileProviderStatus.initial,
    this.errorsMessage = "",
  });
  copyWith(
      {bool hasReachedMax,
      List<CertificateResponse> posts,
      ProfileProviderStatus status,
      String errosMessage}) {
    return ProfileProviderCertificateState(
        hasReachedMax: (hasReachedMax) ?? this.hasReachedMax,
        posts: (posts) ?? this.posts,
        status: (status) ?? this.status,
        errorsMessage: (errorsMessage) ?? this.errorsMessage);
  }
}

class ChangeFileSuccess extends ProfileProviderCertificateState {
  final File file;
  final bool fileIsImage;
  ChangeFileSuccess({this.file, this.fileIsImage});
}

class NewEndDateTimeState extends ProfileProviderCertificateState {
  final bool state;
  NewEndDateTimeState({this.state});
}

class EndDateStartFrom extends ProfileProviderCertificateState {
  int endDateValue;
}

class SucceessAddNewCertificate extends ProfileProviderCertificateState {}

class LoadingState extends ProfileProviderCertificateState {}

class RemoteValidationErrorState extends ProfileProviderCertificateState {
  final String remoteValidationErrorMessage;
  RemoteValidationErrorState({this.remoteValidationErrorMessage});
}

class RemoteServerErrorState extends ProfileProviderCertificateState {
  RemoteServerErrorState({this.remoteServerErrorMessage});

  final String remoteServerErrorMessage;
}

class RemoteClientErrorState extends ProfileProviderCertificateState {
  RemoteClientErrorState({this.remoteClientErrorMessage});
  final String remoteClientErrorMessage;
}

class InvalidState extends ProfileProviderCertificateState {
  final String message;
  InvalidState({this.message = ""});
}

class SucceessUpdateCertificate extends ProfileProviderCertificateState {
  final NewCertificateResponse newResponse;
  SucceessUpdateCertificate({this.newResponse});
}

class UpdateSelectedCertificateAfterSuccessState
    extends ProfileProviderCertificateState {
  UpdateSelectedCertificateAfterSuccessState();
}
