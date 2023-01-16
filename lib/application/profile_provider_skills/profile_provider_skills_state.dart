part of 'profile_provider_skills_bloc.dart';

class ProfileProviderSkillsState {
  bool hasReachedMax;
  List<SkillsResponse> posts;
  ProfileProviderStatus status;
  ProfileProviderSkillsState({
    this.hasReachedMax = false,
    this.posts = const <SkillsResponse>[],
    this.status = ProfileProviderStatus.initial,
  });

  copyWith({
    bool hasReachedMax,
    List<SkillsResponse> posts,
    ProfileProviderStatus status,
  }) {
    return ProfileProviderSkillsState(
      hasReachedMax: (hasReachedMax) ?? this.hasReachedMax,
      posts: (posts) ?? this.posts,
      status: (status) ?? this.status,
    );
  }
}

class LoadingState extends ProfileProviderSkillsState {}

class ErrorState extends ProfileProviderSkillsState {
  final String errorMessage;
  ErrorState({this.errorMessage});
}

class InvalidState extends ProfileProviderSkillsState {}

class SuccessAddNewSkill extends ProfileProviderSkillsState {}

class SuccessUpdateSkill extends ProfileProviderSkillsState {
  final NewSkillResponse newSkill;
  SuccessUpdateSkill({this.newSkill});
}
