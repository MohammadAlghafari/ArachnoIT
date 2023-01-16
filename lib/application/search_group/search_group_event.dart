part of 'search_group_bloc.dart';

abstract class SearchGroupEvent extends Equatable {
  const SearchGroupEvent();

  @override
  List<Object> get props => [];
}

class GetAdvanceSearchMainCategory extends SearchGroupEvent {}

class GetAdvanceSearchSubCategory extends SearchGroupEvent {
  final String categoryId;
  GetAdvanceSearchSubCategory({this.categoryId});
}

class GetAdvanceSearchValuesEvent extends SearchGroupEvent {
  final bool newRequest;
  final String categoryId;
  final String subCategoryID;
  GetAdvanceSearchValuesEvent(
      {this.newRequest, this.categoryId, this.subCategoryID});
}

class GetGroupsSearchTextEvent extends SearchGroupEvent{
 final String searchText;
 final bool newRequest;
 GetGroupsSearchTextEvent({this.searchText,this.newRequest});
}

class ResetAdvanceSearchValues extends SearchGroupEvent{}
