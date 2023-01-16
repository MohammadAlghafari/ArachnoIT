part of 'all_groups_bloc.dart';

enum AllGroupsStatus { initial, success, failure }

@immutable
class AllGroupsState  {
  const AllGroupsState({
    this.status = AllGroupsStatus.initial,
    this.allGroups = const <GroupResponse>[],
    this.hasReachedMax = false,
  });

  final AllGroupsStatus status;
  final List<GroupResponse> allGroups;
  final bool hasReachedMax;

  AllGroupsState copyWith({
    AllGroupsStatus status,
    List<GroupResponse> allGroups,
    bool hasReachedMax,
  }) {
    return AllGroupsState(
      status: status ?? this.status,
      allGroups: allGroups ?? this.allGroups,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

}