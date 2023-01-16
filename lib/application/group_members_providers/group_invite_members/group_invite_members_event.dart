part of 'group_invite_members_bloc.dart';

@immutable
abstract class GroupInviteMembersEvent extends Equatable {
  const GroupInviteMembersEvent();

  @override
  List<Object> get props => [];
}

class GetGroupInviteMembers extends GroupInviteMembersEvent {
  final String groupId;
  final String query;

  const GetGroupInviteMembers({
    @required this.query,
    @required this.groupId,
  });
}

class ChangeInviteStateMembers extends GroupInviteMembersEvent {
  final String personId;

  const ChangeInviteStateMembers({@required this.personId});
}

class SubmittedSearchInviteMembers extends GroupInviteMembersEvent {
  final String groupId;
  final String query;

  const SubmittedSearchInviteMembers({@required this.groupId, @required this.query});
}

class RefreshMemberInviteGetData extends GroupInviteMembersEvent {
  final String groupId;

  const RefreshMemberInviteGetData({@required this.groupId});
}

class InviteMembersToGroup extends GroupInviteMembersEvent {
  final List<GroupPermission> groupPermission;
  final MemberInvitePermissionType memberInvitePermissionType;
  final String groupId;
  final String personId;

  const InviteMembersToGroup({
    @required this.memberInvitePermissionType,
    @required this.groupPermission,
    @required this.groupId,
    @required this.personId,
  });
}
