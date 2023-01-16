part of 'group_details_search_bloc_tags_bloc.dart';

class GroupDetailsSearchBlocTagsState {
  final List<SearchModel> tagsList;
  final List<SearchModel> searchedList;
  final List<bool> selectedBoolTagItems;
  final int maxSelectedNumber;
  GroupDetailsSearchBlocTagsState({
    this.searchedList = const <SearchModel>[],
    this.tagsList = const <SearchModel>[],
    this.selectedBoolTagItems = const <bool>[],
    this.maxSelectedNumber=0,
  });

  copyWith(
      {List<SearchModel> searchedList,
      List<SearchModel> tagsList,
      List<bool> selectedBoolTagItems,
      int maxSelectedNumber
      }) {
    return GroupDetailsSearchBlocTagsState(
      searchedList: (searchedList) ?? this.searchedList,
      tagsList: (tagsList) ?? this.tagsList,
      selectedBoolTagItems: (selectedBoolTagItems) ?? this.selectedBoolTagItems,
      maxSelectedNumber:(maxSelectedNumber)??this.maxSelectedNumber,
    );
  }
}
