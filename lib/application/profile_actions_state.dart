part of 'profile_actions_bloc.dart';

@immutable
 class ProfileActionsState{
const ProfileActionsState();
}

class ChangeFavoriteProfileSuccess extends ProfileActionsState {
  ChangeFavoriteProfileSuccess({this.messageStatus});
  final String messageStatus;
}


class ChangeFollowProfileSuccess extends ProfileActionsState {
  ChangeFollowProfileSuccess({this.messageStatus});
  final String messageStatus;
}

class LoadingProfileActionState extends ProfileActionsState {
  LoadingProfileActionState();

}

class RemoteValidationErrorProfileState extends ProfileActionsState {
  RemoteValidationErrorProfileState({this.remoteValidationErrorMessage});
  final String remoteValidationErrorMessage;
}

class RemoteServerErrorProfileState extends ProfileActionsState {
  RemoteServerErrorProfileState({this.remoteServerErrorMessage});

  final String remoteServerErrorMessage;
}

class RemoteClientErrorProfileState extends ProfileActionsState {
  RemoteClientErrorProfileState({this.remoteClientErrorMessage});
  final String remoteClientErrorMessage;
}
