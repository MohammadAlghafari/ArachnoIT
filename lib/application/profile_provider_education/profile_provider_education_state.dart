part of 'profile_provider_education_bloc.dart';

class ProfileProviderEducationState {
  final bool hasReachedMax;
  final List<EducationsResponse> posts;
  final ProfileProviderStatus status;
  final String message;
  ProfileProviderEducationState({
    this.hasReachedMax = false,
    this.posts = const <EducationsResponse>[],
    this.status = ProfileProviderStatus.initial,
    this.message = "",
  });

  copyWith(
      {bool hasReachedMax,
      List<EducationsResponse> posts,
      ProfileProviderStatus status,
      String message}) {
    return ProfileProviderEducationState(
        hasReachedMax: (hasReachedMax) ?? this.hasReachedMax,
        posts: (posts) ?? this.posts,
        status: (status) ?? this.status,
        message: (message) ?? this.message);
  }
}

class LoadingState extends ProfileProviderEducationState {}

class RemoteValidationErrorState extends ProfileProviderEducationState {
  final String remoteValidationErrorMessage;
  RemoteValidationErrorState({this.remoteValidationErrorMessage});
}

class RemoteServerErrorState extends ProfileProviderEducationState {
  RemoteServerErrorState({this.remoteServerErrorMessage});

  final String remoteServerErrorMessage;
}

class RemoteClientErrorState extends ProfileProviderEducationState {
  RemoteClientErrorState({this.remoteClientErrorMessage});
  final String remoteClientErrorMessage;
}

class SuccessAddNewEducations extends ProfileProviderEducationState {}

class AddItemToFileListState extends ProfileProviderEducationState {
  final List<ImageType> file;
  AddItemToFileListState({this.file});
}

class RemoveItemFromFileListState extends ProfileProviderEducationState {
  final int index;
  RemoveItemFromFileListState({this.index});
}

class InvalidState extends ProfileProviderEducationState {
  String message;
  InvalidState({this.message = ""});
}

class SuccessUpdateValue extends ProfileProviderEducationState {
  NewEducationResponse newEducationResponse;
  SuccessUpdateValue({this.newEducationResponse});
}
