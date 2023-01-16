part of 'profile_provider_courses_bloc.dart';

class ProfileProviderCoursesState {
  final bool hasReachedMax;
  final List<CoursesResponse> posts;
  final ProfileProviderStatus status;
  ProfileProviderCoursesState({
    this.hasReachedMax = false,
    this.posts = const <CoursesResponse>[],
    this.status = ProfileProviderStatus.initial,
  });
  copyWith({
    bool hasReachedMax,
    List<CoursesResponse> posts,
    ProfileProviderStatus status,
  }) {
    return ProfileProviderCoursesState(
      hasReachedMax: (hasReachedMax) ?? this.hasReachedMax,
      posts: (posts) ?? this.posts,
      status: (status) ?? this.status,
    );
  }
}

class AddItemToFileListState extends ProfileProviderCoursesState {
  final List<ImageType> file;
  AddItemToFileListState({this.file});
}

class RemoveItemFromFileListState extends ProfileProviderCoursesState {
  final int index;
  RemoveItemFromFileListState({this.index});
}

class InvalidState extends ProfileProviderCoursesState {}

class SuccessAddNewItem extends ProfileProviderCoursesState {}

class LoadingState extends ProfileProviderCoursesState {}

class RemoteValidationErrorState extends ProfileProviderCoursesState {
  final String remoteValidationErrorMessage;
  RemoteValidationErrorState({this.remoteValidationErrorMessage});
}

class RemoteServerErrorState extends ProfileProviderCoursesState {
  RemoteServerErrorState({this.remoteServerErrorMessage});

  final String remoteServerErrorMessage;
}

class RemoteClientErrorState extends ProfileProviderCoursesState {
  RemoteClientErrorState({this.remoteClientErrorMessage});
  final String remoteClientErrorMessage;
}

class SuccessUpdateCourses extends ProfileProviderCoursesState {
  final NewCourseResponse newCourseResponse;
  SuccessUpdateCourses({this.newCourseResponse});
}

