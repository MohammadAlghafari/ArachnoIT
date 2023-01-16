part of 'group_details_search_bloc.dart';

abstract class GroupDetailsSearchEvent extends Equatable {
  const GroupDetailsSearchEvent();

  @override
  List<Object> get props => [];
}

class SearchTextSubmittedEvent extends GroupDetailsSearchEvent {
  SearchTextSubmittedEvent({this.query});
  final String query;

  @override
  List<Object> get props => [
        query,
      ];
}

class AdvancedSearchSubmittedEvent extends GroupDetailsSearchEvent {
  AdvancedSearchSubmittedEvent({
    this.categoryId,
    this.subCategoryId,
    this.accountType,
    
    @required this.tagsId,
  });
  final String categoryId;
  final String subCategoryId;
  final int accountType;
  final List<String>tagsId;
  @override
  List<Object> get props => [
        categoryId,
        subCategoryId,
        accountType,
        tagsId,
      ];
}

class GetAdvancedSearchCategories extends GroupDetailsSearchEvent {
  GetAdvancedSearchCategories();

  @override
  List<Object> get props => [];
}

class GetAdvancedSearchSubCategories extends GroupDetailsSearchEvent {
  GetAdvancedSearchSubCategories({this.categoryId});
  final String categoryId;

  @override
  List<Object> get props => [
        categoryId,
      ];
}

class GetAdvanceSearchAddTags extends GroupDetailsSearchEvent {}

class ChanagSelectedTagListEvent extends GroupDetailsSearchEvent{
    final List<SearchModel> tagsItem;
  ChanagSelectedTagListEvent({this.tagsItem});
}

class RemoveSelectedTagItem extends  GroupDetailsSearchEvent{
  final int index;
  final List<SearchModel>tagsItem;
  RemoveSelectedTagItem({@required this.index,@required this.tagsItem});
}