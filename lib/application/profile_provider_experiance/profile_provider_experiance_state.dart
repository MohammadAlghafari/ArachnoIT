part of 'profile_provider_experiance_bloc.dart';

class ProfileProviderExperianceState {
  final bool hasReachedMax;
  final List<ExperianceResponse> posts;
  final ProfileProviderStatus status;
  final String message;
  ProfileProviderExperianceState({
    this.hasReachedMax = false,
    this.posts = const <ExperianceResponse>[],
    this.status = ProfileProviderStatus.initial,
    this.message = "",
  });
  copyWith({
    bool hasReachedMax,
    List<ExperianceResponse> posts,
    ProfileProviderStatus status,
    String message,
  }) {
    return ProfileProviderExperianceState(
        hasReachedMax: (hasReachedMax) ?? this.hasReachedMax,
        posts: (posts) ?? this.posts,
        status: (status) ?? this.status,
        message: (message) ?? this.message);
  }
}

class LoadingState extends ProfileProviderExperianceState {}

class RemoteValidationErrorState extends ProfileProviderExperianceState {
  final String remoteValidationErrorMessage;
  RemoteValidationErrorState({this.remoteValidationErrorMessage});
}

class RemoteServerErrorState extends ProfileProviderExperianceState {
  RemoteServerErrorState({this.remoteServerErrorMessage});

  final String remoteServerErrorMessage;
}

class RemoteClientErrorState extends ProfileProviderExperianceState {
  RemoteClientErrorState({this.remoteClientErrorMessage});
  final String remoteClientErrorMessage;
}

class SuccessAddNewExperiance extends ProfileProviderExperianceState {}

class AddItemToFileListState extends ProfileProviderExperianceState {
  final List<ImageType> file;
  AddItemToFileListState({this.file});
}

class RemoveItemFromFileListState extends ProfileProviderExperianceState {
  final int index;
  RemoveItemFromFileListState({this.index});
}

class InvalidState extends ProfileProviderExperianceState {
  final String message;
  InvalidState({this.message});
}

class SuccessUpdateExperiance extends ProfileProviderExperianceState {
  final NewExperianceResponse newExperianceResponse;
  SuccessUpdateExperiance({this.newExperianceResponse});
}
