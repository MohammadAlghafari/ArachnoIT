part of 'groups_bloc.dart';

enum GroupsStatus { initial, success, failure }


@immutable
class GroupsState  {
  const GroupsState({
    this.status = GroupsStatus.initial,
    this.groupsRefreshStatus = RequestState.initial,
    this.publicGroups = const <GroupResponse>[],
    this.myGroups = const <GroupResponse>[],
    this.hasReachedMax = false,
  });
  final GroupsStatus status;
  final RequestState  groupsRefreshStatus;
  final List<GroupResponse> publicGroups;
  final List<GroupResponse> myGroups;
  final bool hasReachedMax;

  GroupsState copyWith({
    GroupsStatus status,
    RequestState groupsRefreshStatus,
    List<GroupResponse> publicGroups,
    List<GroupResponse> myGroups,
    bool hasReachedMax,
  }) {
    return GroupsState(
      status: status ?? this.status,
      groupsRefreshStatus: groupsRefreshStatus ?? this.groupsRefreshStatus,
      publicGroups: publicGroups ?? this.publicGroups,
      myGroups: myGroups ?? this.myGroups,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  List<Object> get props => [status, publicGroups, myGroups, hasReachedMax];
}

