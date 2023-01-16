part of 'search_blogs_bloc.dart';

abstract class SearchBlogsEvent extends Equatable {
  const SearchBlogsEvent();

  @override
  List<Object> get props => [];
}

class GetAdvanceSearchMainCategory extends SearchBlogsEvent {}

class GetAdvanceSearchSubCategory extends SearchBlogsEvent {
  final String categoryId;
  GetAdvanceSearchSubCategory({this.categoryId});
}

class GetAdvanceSearchAccountType extends SearchBlogsEvent {}

class GetAdvanceSearchAllTags extends SearchBlogsEvent {}

class ChanagSelectedTagListEvent extends SearchBlogsEvent {
  final List<SearchModel> tagsItem;
  ChanagSelectedTagListEvent({this.tagsItem});
}

class RemoveSelectedTagItem extends SearchBlogsEvent {
  final int index;
  final List<SearchModel> tagsItem;
  RemoveSelectedTagItem({@required this.index, @required this.tagsItem});
}

class GetAdvanceSearchValuesEvent extends SearchBlogsEvent {
  final bool newRequest;
  final String categoryId;
  final String subCategoryId;
  final int accountTypeId;
  final int orderByBlogs;
  final List<String> tagsId;
  final bool myFeed;
  final String personId;
  GetAdvanceSearchValuesEvent(
      {this.newRequest,
      this.categoryId,
      this.subCategoryId,
      this.accountTypeId,
      this.myFeed,
      this.orderByBlogs,
      this.tagsId,
      this.personId});
}

class GetSearchTextEvent extends SearchBlogsEvent {
  final bool newRequest;
  final String query;
  GetSearchTextEvent({this.newRequest, this.query});
}

class ResetAdvanceSearchValues extends SearchBlogsEvent {}
