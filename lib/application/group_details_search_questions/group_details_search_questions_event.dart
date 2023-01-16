part of 'group_details_search_questions_bloc.dart';

abstract class GroupDetailsSearchQuestionsEvent {
  const GroupDetailsSearchQuestionsEvent();

}

class SearchTextQuestionsFetchEvent extends GroupDetailsSearchQuestionsEvent {
  SearchTextQuestionsFetchEvent({this.groupId, this.query, this.newRequest});

  final String groupId;
  final String query;
  final bool newRequest;

}

class AdvancedSearchQuestionsFetchEvent
    extends GroupDetailsSearchQuestionsEvent {
  AdvancedSearchQuestionsFetchEvent(
      {this.groupId,
      this.categoryId,
      this.subCategoryId,
      this.accountType,
      this.newRequest,
      @required this.tagsId,
      });
  final List<String>tagsId;
  final String groupId;
  final String categoryId;
  final String subCategoryId;
  final int accountType;
  final bool newRequest;

}
