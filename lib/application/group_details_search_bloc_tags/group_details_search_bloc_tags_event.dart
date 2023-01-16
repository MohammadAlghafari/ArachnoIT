part of 'group_details_search_bloc_tags_bloc.dart';

abstract class GroupDetailsSearchBlocTagsEvent extends Equatable {
  const GroupDetailsSearchBlocTagsEvent();

  @override
  List<Object> get props => [];
}

class ChangeSearchValueEvent extends GroupDetailsSearchBlocTagsEvent {
  final String searchValue;
  ChangeSearchValueEvent({this.searchValue});
}

class ChangeInitialItemValue extends GroupDetailsSearchBlocTagsEvent {
  final List<SearchModel> newSearchArrayList;
  final List<bool> tagSelectedItem;
  final int numberOfSelectedValue;
  ChangeInitialItemValue({this.newSearchArrayList,this.tagSelectedItem,this.numberOfSelectedValue});
}

class ChangeSelectedTagItemsEvent extends GroupDetailsSearchBlocTagsEvent {
  final int index;
  final BuildContext context;
  ChangeSelectedTagItemsEvent({this.index,@required this.context});
}

class ChangeSelectedTagListEvent extends GroupDetailsSearchBlocTagsEvent {

}
