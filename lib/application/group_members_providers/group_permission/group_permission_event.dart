part of 'group_permission_bloc.dart';

@immutable
abstract class GroupPermissionEvent extends Equatable {
  const GroupPermissionEvent();

  @override
  // TODO: implement props
  List<Object> get props => [];
}


class GetGroupPermission extends GroupPermissionEvent{

  const  GetGroupPermission();


}

class ChangeMemberPermissionType extends GroupPermissionEvent{
  final MemberInvitePermissionType memberInvitePermissionType;
  const  ChangeMemberPermissionType({@required this.memberInvitePermissionType});


}