part of 'group_details_search_blogs_bloc.dart';

abstract class GroupDetailsSearchBlogsEvent extends Equatable {
  const GroupDetailsSearchBlogsEvent();

  @override
  List<Object> get props => [];
}

class SearchTextBlogsFetchEvent extends GroupDetailsSearchBlogsEvent {
  SearchTextBlogsFetchEvent({this.groupId, this.query, this.newRequest});

  final String groupId;
  final String query;
  final bool newRequest;

  @override
  List<Object> get props => [groupId, query, newRequest];
}

class AdvancedSearchBlogsFetchEvent extends GroupDetailsSearchBlogsEvent {
  AdvancedSearchBlogsFetchEvent(
      {this.groupId,
      this.categoryId,
      this.subCategoryId,
      this.accountType,
      this.newRequest,
      this.tagsId=const<String>[],
      });
  final List<String>tagsId;
  final String groupId;
  final String categoryId;
  final String subCategoryId;
  final int accountType;
  final bool newRequest;

  @override
  List<Object> get props =>
      [groupId, categoryId, subCategoryId, accountType, newRequest,tagsId];
}
