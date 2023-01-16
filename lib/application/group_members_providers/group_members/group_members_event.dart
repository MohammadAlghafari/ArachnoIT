part of 'group_members_bloc.dart';

abstract class GroupMembersEvent extends Equatable {
  const GroupMembersEvent();

  @override
  // TODO: implement props
  List<Object> get props => [];
}

class GetGroupMembers extends GroupMembersEvent {
  final String groupId;
  final String query;
  const GetGroupMembers({
    @required this.query,
    @required this.groupId,


  });
}

class RemoveMemberFromGroup extends GroupMembersEvent {
final  String groupId;
final  List<String> memberId;

  const RemoveMemberFromGroup({@required this.groupId,@required this.memberId});

}

class SubmittedSearchGroupMember extends GroupMembersEvent{
  final String groupId;
  final String query;
  const SubmittedSearchGroupMember({@required this.groupId,@required this.query});
}






class RefreshMemberGroupGetData extends GroupMembersEvent{
  final String groupId;
  const RefreshMemberGroupGetData({@required this.groupId});
}


class ReloadGetGroupMembers extends GroupMembersEvent {
  final GetGroupMembersResponse membersResponse;

  const ReloadGetGroupMembers({
    @required this.membersResponse,
  });
}