part of 'home_group_members_bloc.dart';

@immutable
abstract class HomeGroupMembersEvent extends Equatable{


const HomeGroupMembersEvent();
  @override
  // TODO: implement props
  List<Object> get props => [];

}
class PersonSearchedGroupMember extends HomeGroupMembersEvent{
  final String groupId;
  final String query;
  const PersonSearchedGroupMember({@required this.groupId,@required this.query});
}

class ResetSearched extends HomeGroupMembersEvent{
  const ResetSearched();
}




class PersonSearchedInviteMember extends HomeGroupMembersEvent{
  final String groupId;
  final String query;
  const PersonSearchedInviteMember({@required this.groupId,@required this.query});
}