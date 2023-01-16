part of 'search_question_bloc.dart';

enum SearchQuestionStatus { initial, loading, success, failure }

class SearchQuestionState {
  final bool hasReachedMax;
  final SearchQuestionStatus status;
  final List<QaaResponse> posts;
  const SearchQuestionState({
    this.hasReachedMax = false,
    this.status = SearchQuestionStatus.initial,
    this.posts = const <QaaResponse>[],
  });

  SearchQuestionState copyWith({
    bool hasReachedMax,
    SearchQuestionStatus status,
    List<QaaResponse> posts,
  }) {
    return SearchQuestionState(
        hasReachedMax: (hasReachedMax) ?? this.hasReachedMax,
        status: (status) ?? this.status,
        posts: (posts) ?? this.posts);
  }

}

class LoadingState extends SearchQuestionState {}

class RemoteValidationErrorState extends SearchQuestionState {
  final String remoteValidationErrorMessage;
  RemoteValidationErrorState({this.remoteValidationErrorMessage});
}

class RemoteServerErrorState extends SearchQuestionState {
  RemoteServerErrorState({this.remoteServerErrorMessage});

  final String remoteServerErrorMessage;
  @override
  List<Object> get props => [remoteServerErrorMessage];
}

class RemoteClientErrorState extends SearchQuestionState {
  RemoteClientErrorState({this.remoteClientErrorMessage});
  final String remoteClientErrorMessage;
}

class ChangeAccountTypeState extends SearchQuestionState {
  final int selectedIndex;
  ChangeAccountTypeState({this.selectedIndex});
}

class GetAdvanceSearchMainCategorySuccess extends SearchQuestionState {
  final List<CategoryResponse> categories;
  GetAdvanceSearchMainCategorySuccess({this.categories});
}

class GetAdvanceSearchSubCategorySuccess extends SearchQuestionState {
  final List<SubCategoryResponse> subCategories;
  GetAdvanceSearchSubCategorySuccess({this.subCategories});
}

class GetAdvanceSearchAllTagsSuccess extends SearchQuestionState {
  final List<TagResponse> tagItems;
  GetAdvanceSearchAllTagsSuccess({@required this.tagItems});
}

class ChanagSelectedTagListState extends SearchQuestionState {
  final List<SearchModel> tagsItem;
  ChanagSelectedTagListState({this.tagsItem});
}

class ResetAdvanceSearchValuesState extends SearchQuestionState {}
