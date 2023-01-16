part of 'profile_provider_language_bloc.dart';

class ProfileProviderLanguageState {
  final bool hasReachedMax;
  final List<LanguageResponse> posts;
  final ProfileProviderStatus status;
  final String errorMessage;
  ProfileProviderLanguageState({
    this.hasReachedMax = false,
    this.posts = const <LanguageResponse>[],
    this.status = ProfileProviderStatus.initial,
    this.errorMessage = "",
  });
  copyWith({
    bool hasReachedMax,
    List<LanguageResponse> posts,
    ProfileProviderStatus status,
    String errorMessage,
  }) {
    return ProfileProviderLanguageState(
        hasReachedMax: (hasReachedMax) ?? this.hasReachedMax,
        posts: (posts) ?? this.posts,
        status: (status) ?? this.status,
        errorMessage: (errorMessage) ?? this.errorMessage);
  }
}

class SuccessAddNewLanguage extends ProfileProviderLanguageState {}

class ErrorsState extends ProfileProviderLanguageState {
  final String errorMessage;
  ErrorsState({this.errorMessage});
}

class SuccessShowLevel extends ProfileProviderLanguageState {}

class InvalidState extends ProfileProviderLanguageState {}