part of 'profile_provider_lectures_bloc.dart';

class ProfileProviderLecturesState {
  final bool hasReachedMax;
  final List<QualificationsResponse> posts;
  final ProfileProviderStatus status;
  ProfileProviderLecturesState({
    this.hasReachedMax = false,
    this.posts = const <QualificationsResponse>[],
    this.status = ProfileProviderStatus.initial,
  });

  copyWith({
    bool hasReachedMax,
    List<QualificationsResponse> posts,
    ProfileProviderStatus status,
  }) {
    return ProfileProviderLecturesState(
        hasReachedMax: (hasReachedMax) ?? this.hasReachedMax,
        posts: (posts) ?? this.posts,
        status: (status) ?? this.status);
  }
}

class AddItemToFileListState extends ProfileProviderLecturesState {
  final List<ImageType> file;
  AddItemToFileListState({this.file});
}

class RemoveItemFromFileListState extends ProfileProviderLecturesState {
  final int index;
  RemoveItemFromFileListState({this.index});
}

class InvalidState extends ProfileProviderLecturesState {}

class ErrorsState extends ProfileProviderLecturesState {
  final String errorMessage;
  ErrorsState({this.errorMessage});
}

class SuccessAddNewLectures extends ProfileProviderLecturesState {}

class SuccessUpdateLectures extends ProfileProviderLecturesState {
  final int index;
  final NewLecturesResponse newItem;
  SuccessUpdateLectures({this.index, this.newItem});
}
