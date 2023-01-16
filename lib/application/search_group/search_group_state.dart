part of 'search_group_bloc.dart';

enum SearchGroupStateStatus { initial, loading, success, failure }

class SearchGroupState {
  final bool hasReachedMax;
  final SearchGroupStateStatus status;
  final List<GroupResponse> posts;
  SearchGroupState(
      {this.posts = const <GroupResponse>[],
      this.hasReachedMax = false,
      this.status = SearchGroupStateStatus.initial});

  SearchGroupState copyWith({
    bool hasReachedMax,
    SearchGroupStateStatus status,
    List<GroupResponse> posts,
  }) {
    return SearchGroupState(
        posts: (posts) ?? this.posts,
        hasReachedMax: (hasReachedMax) ?? this.hasReachedMax,
        status: (status) ?? this.status);
  }
}

class LoadingState extends SearchGroupState {}

class RemoteValidationErrorState extends SearchGroupState {
  RemoteValidationErrorState({this.remoteValidationErrorMessage});
  final String remoteValidationErrorMessage;
}

class RemoteServerErrorState extends SearchGroupState {
  RemoteServerErrorState({this.remoteServerErrorMessage});

  final String remoteServerErrorMessage;
}

class RemoteClientErrorState extends SearchGroupState {
  RemoteClientErrorState({this.remoteClientErrorMessage});
  final String remoteClientErrorMessage;
}

class ChangeAccountTypeState extends SearchGroupState {
  final int selectedIndex;
  ChangeAccountTypeState({this.selectedIndex});
}

class GetAdvanceSearchMainCategorySucces extends ChangeAccountTypeState {
  final List<CategoryResponse> categories;
  GetAdvanceSearchMainCategorySucces({this.categories});
}

class GetAdvanceSearchSubCategorySuccess extends ChangeAccountTypeState {
  final List<SubCategoryResponse> subCategories;
  GetAdvanceSearchSubCategorySuccess({this.subCategories});
}

class ResetAdvanceSearchValuesState extends ChangeAccountTypeState{}
