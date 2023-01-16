part of 'group_invite_members_bloc.dart';


@immutable
class GroupInviteMembersState  {
  final List<GetGroupInviteMembersResponse> members;
  final Map<String,bool> isInvited;
  final bool hasReachedMax;
  final RequestState status;
  final RequestState refreshGroupInviteMembersStatus;
  final RequestState inviteMemberStatus;

  const GroupInviteMembersState(
      {
      this.status = RequestState.initial,
      this.inviteMemberStatus = RequestState.initial,
      this.refreshGroupInviteMembersStatus = RequestState.initial,
      this.members = const <GetGroupInviteMembersResponse>[],
      this.hasReachedMax = false,
      this.isInvited= const <String,bool>{}});

  GroupInviteMembersState copyWith({
    List<GetGroupInviteMembersResponse> members,
    Map<String,bool> isInvited,
    bool hasReachedMax,
    RequestState status,
    RequestState refreshGroupInviteMembersStatus,
    RequestState inviteMemberStatus,
  }) {
    return GroupInviteMembersState(
      status: status ?? this.status,
      isInvited: isInvited ?? this.isInvited,
      refreshGroupInviteMembersStatus: refreshGroupInviteMembersStatus ?? this.refreshGroupInviteMembersStatus,
      inviteMemberStatus: inviteMemberStatus ?? this.inviteMemberStatus,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      members: members ?? this.members,
    );
  }

  @override
  // TODO: implement props
  List<Object> get props => [status, hasReachedMax, members,isInvited, inviteMemberStatus,refreshGroupInviteMembersStatus];
}
