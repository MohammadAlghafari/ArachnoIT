part of 'search_blogs_bloc.dart';

enum SearchBlogsStateStatus { initial, loading, success, failure }

@immutable
class SearchBlogsState  {
  final bool hasReachedMax;
  final SearchBlogsStateStatus status;
  final List<GetBlogsResponse> posts;
  const SearchBlogsState({
    this.hasReachedMax = false,
    this.status = SearchBlogsStateStatus.initial,
    this.posts = const <GetBlogsResponse>[],
  });

  SearchBlogsState copyWith({
    bool hasReachedMax,
    SearchBlogsStateStatus status,
    List<GetBlogsResponse> posts,
  }) {
    return SearchBlogsState(
        hasReachedMax: (hasReachedMax) ?? this.hasReachedMax,
        status: (status) ?? this.status,
        posts: (posts) ?? this.posts);
  }

}

class LoadingState extends SearchBlogsState {}

class RemoteValidationErrorState extends SearchBlogsState {
  final String remoteValidationErrorMessage;
  RemoteValidationErrorState({this.remoteValidationErrorMessage});
}

class RemoteServerErrorState extends SearchBlogsState {
  RemoteServerErrorState({this.remoteServerErrorMessage});

  final String remoteServerErrorMessage;
}

class RemoteClientErrorState extends SearchBlogsState {
  RemoteClientErrorState({this.remoteClientErrorMessage});
  final String remoteClientErrorMessage;
}

class ChangeAccountTypeState extends SearchBlogsState {
  final int selectedIndex;
  ChangeAccountTypeState({this.selectedIndex});
}

class GetAdvanceSearchMainCategorySuccess extends SearchBlogsState {
  final List<CategoryResponse> categories;
  GetAdvanceSearchMainCategorySuccess({this.categories});
}

class GetAdvanceSearchSubCategorySuccess extends SearchBlogsState {
  final List<SubCategoryResponse> subCategories;
  GetAdvanceSearchSubCategorySuccess({this.subCategories});
}

class GetAdvanceSearchAllTagsSuccess extends SearchBlogsState {
  final List<TagResponse> tagItems;
  GetAdvanceSearchAllTagsSuccess({@required this.tagItems});
}

class ChanagSelectedTagListState extends SearchBlogsState {
  final List<SearchModel> tagsItem;
  ChanagSelectedTagListState({this.tagsItem});
}

class ResetAdvanceSearchValuesState extends SearchBlogsState {}
