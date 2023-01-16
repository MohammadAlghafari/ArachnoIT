part of 'profile_follow_list_bloc.dart';

abstract class ProfileFollowListState extends Equatable {
  const ProfileFollowListState();

  @override
  List<Object> get props => [];
}

class ProfileFollowListInitial extends ProfileFollowListState {}

class LoadingState extends ProfileFollowListState {}

class RemoteServerErrorState extends ProfileFollowListState {
  RemoteServerErrorState({
    this.remoteServerErrorMessage,
  });

  final String remoteServerErrorMessage;
}

class RemoteClientErrorState extends ProfileFollowListState {
  RemoteClientErrorState({
    this.remoteClientErrorMessage,
  });

  final String remoteClientErrorMessage;
}

class SuccessGetProfileFollowListState extends ProfileFollowListState {
  final ProfileFollowListResponse profileFollowListResponse;

  SuccessGetProfileFollowListState({
    this.profileFollowListResponse,
  });
}
