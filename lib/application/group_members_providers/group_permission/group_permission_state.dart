part of 'group_permission_bloc.dart';

enum GroupPermissionStatus { initial, success, failureValidation, loadingData, serverError, networkError }
enum MemberInvitePermissionType { Admin, Editor, Coordinator, User }

@immutable
class GroupPermissionState extends Equatable {
  final MemberInvitePermissionType memberInvitePermissionType;
  final GroupPermissionStatus groupPermissionStatus;
  final List<GroupPermission> groupPermission;

  const GroupPermissionState({
    this.memberInvitePermissionType,
    this.groupPermission = const <GroupPermission>[],
    this.groupPermissionStatus = GroupPermissionStatus.initial,
  });

  GroupPermissionState copyWith({
    MemberInvitePermissionType memberInvitePermissionType,
    GroupPermissionStatus groupPermissionStatus,
    List<GroupPermission> groupPermission,
  }) {
    return GroupPermissionState(
      memberInvitePermissionType: memberInvitePermissionType ?? this.memberInvitePermissionType,
      groupPermission: groupPermission ?? this.groupPermission,
      groupPermissionStatus: groupPermissionStatus ?? this.groupPermissionStatus,
    );
  }

  @override
  // TODO: implement props
  List<Object> get props => [memberInvitePermissionType,groupPermissionStatus,groupPermission];
}
