part of 'profile_actions_bloc.dart';

@immutable
class ProfileActionsEvent extends Equatable {
  const ProfileActionsEvent();
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class ChangeFavoriteProfile extends ProfileActionsEvent {
  final String favoritePersonId;
  final bool favoriteStatus;

  const ChangeFavoriteProfile(
      {@required this.favoritePersonId, @required this.favoriteStatus});
}

class ChangeFollowProfile extends ProfileActionsEvent {
  final String healthCareProviderId;
  final bool followStatus;
  final BuildContext context;
  const ChangeFollowProfile(
      {@required this.healthCareProviderId,
      @required this.followStatus,
      @required this.context});
}
