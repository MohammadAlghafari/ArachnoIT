part of 'search_question_bloc.dart';

abstract class SearchQuestionEvent extends Equatable {
  const SearchQuestionEvent();

  @override
  List<Object> get props => [];
}

class GetAdvanceSearchMainCategory extends SearchQuestionEvent {}

class GetAdvanceSearchSubCategory extends SearchQuestionEvent {
  final String categoryId;
  GetAdvanceSearchSubCategory({this.categoryId});
}

class GetAdvanceSearchAccountType extends SearchQuestionEvent {}

class GetAdvanceSearchAllTags extends SearchQuestionEvent {}

class ChanagSelectedTagListEvent extends SearchQuestionEvent {
  final List<SearchModel> tagsItem;
  ChanagSelectedTagListEvent({this.tagsItem});
}

class RemoveSelectedTagItem extends SearchQuestionEvent {
  final int index;
  final List<SearchModel> tagsItem;
  RemoveSelectedTagItem({@required this.index, @required this.tagsItem});
}

class GetAdvanceSearchValuesEvent extends SearchQuestionEvent {
  final bool newRequest;
  final String categoryId;
  final String subCategoryId;
  final int accountTypeId;
  final int orderByQuestions;
  final List<String> tagsId;
  final String personId;
  GetAdvanceSearchValuesEvent(
      {this.newRequest,
      this.categoryId,
      this.subCategoryId,
      this.accountTypeId,
      this.orderByQuestions,
      this.tagsId,
      this.personId});
}

class GetSearchTextEvent extends SearchQuestionEvent {
  final bool newRequest;
  final String query;
  GetSearchTextEvent({this.newRequest, this.query});
}

class ResetAdvanceSearchValues extends SearchQuestionEvent {}
