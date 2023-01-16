part of 'discover_categories_sub_category_all_groups_bloc.dart';

enum GroupsStatus { initial, success, failure ,loading}

@immutable
class DiscoverCategoriesSubCategoryAllGroupsState  {
  const DiscoverCategoriesSubCategoryAllGroupsState({
    this.status = GroupsStatus.initial,
    this.allGroups = const <GroupResponse>[],
    this.hasReachedMax = false,
  });

  final GroupsStatus status;
  final List<GroupResponse> allGroups;
  final bool hasReachedMax;

  DiscoverCategoriesSubCategoryAllGroupsState copyWith({
    GroupsStatus status,
    List<GroupResponse> allGroups,
    bool hasReachedMax,
  }) {
    return DiscoverCategoriesSubCategoryAllGroupsState(
      status: status ?? this.status,
      allGroups: allGroups ?? this.allGroups,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }
}