part of 'profile_provider_projects_bloc.dart';

class ProfileProviderProjectsState {
  bool hasReachedMax;
  List<ProjectsResponse> posts;
  ProfileProviderStatus status;
  ProfileProviderProjectsState({
    this.hasReachedMax = false,
    this.posts = const <ProjectsResponse>[],
    this.status = ProfileProviderStatus.initial,
  });

  copyWith({
    bool hasReachedMax,
    List<ProjectsResponse> posts,
    ProfileProviderStatus status,
  }) {
    return ProfileProviderProjectsState(
      hasReachedMax: (hasReachedMax) ?? this.hasReachedMax,
      posts: (posts) ?? this.posts,
      status: (status) ?? this.status,
    );
  }
}

class AddItemToFileListState extends ProfileProviderProjectsState {
  final List<ImageType> file;
  AddItemToFileListState({this.file});
}

class RemoveItemFromFileListState extends ProfileProviderProjectsState {
  final int index;
  RemoveItemFromFileListState({this.index});
}

class InvalidState extends ProfileProviderProjectsState {}

class SuccessAddNewProject extends ProfileProviderProjectsState {}

class LoadingState extends ProfileProviderProjectsState {}

class RemoteValidationErrorState extends ProfileProviderProjectsState {
  final String remoteValidationErrorMessage;
  RemoteValidationErrorState({this.remoteValidationErrorMessage});
}

class RemoteServerErrorState extends ProfileProviderProjectsState {
  RemoteServerErrorState({this.remoteServerErrorMessage});

  final String remoteServerErrorMessage;
}

class RemoteClientErrorState extends ProfileProviderProjectsState {
  RemoteClientErrorState({this.remoteClientErrorMessage});
  final String remoteClientErrorMessage;
}

class SuccessUpdateProjects extends ProfileProviderProjectsState{
  NewProjectResponse newProject;
  SuccessUpdateProjects({this.newProject});
}