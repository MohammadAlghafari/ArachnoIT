part of 'profile_follow_list_bloc.dart';

abstract class ProfileFollowListEvent extends Equatable {
  const ProfileFollowListEvent();

  @override
  List<Object> get props => [];
}

class GetProfileFollowListEvent extends ProfileFollowListEvent {
  final String healthcareProviderId;

  GetProfileFollowListEvent({
    this.healthcareProviderId,
  });
}
