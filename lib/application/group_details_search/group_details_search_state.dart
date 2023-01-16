part of 'group_details_search_bloc.dart';

@immutable
class GroupDetailsSearchState {
  const GroupDetailsSearchState({
    this.searchText,
    this.categoryId,
    this.subCategoryId,
    this.accountType,
    this.tagsId = const <String>[],
    this.shouldDestroyWidget = true,
  });
  final List<String> tagsId;
  final String searchText;
  final String categoryId;
  final String subCategoryId;
  final int accountType;
  final bool shouldDestroyWidget;

  GroupDetailsSearchState copyWith({
    String searchText,
    String categoryId,
    String subCategoryId,
    int accountType,
    bool shouldDestroyWidget,
    List<String> tagsId,
  }) {
    return GroupDetailsSearchState(
        searchText: searchText,
        categoryId: categoryId,
        subCategoryId: subCategoryId,
        accountType: accountType,
        shouldDestroyWidget: shouldDestroyWidget,
        tagsId: (tagsId) ?? this.tagsId);
  }
}

class LoadingState extends GroupDetailsSearchState {}

class SearchCategoriesState extends GroupDetailsSearchState {
  SearchCategoriesState({this.categories});

  final List<CategoryResponse> categories;
}

class SearchSubCategoriesState extends GroupDetailsSearchState {
  SearchSubCategoriesState({this.subCategories});

  final List<SubCategoryResponse> subCategories;
}

class RemoteValidationErrorState extends GroupDetailsSearchState {
  RemoteValidationErrorState({this.remoteValidationErrorMessage});

  final String remoteValidationErrorMessage;
}

class RemoteServerErrorState extends GroupDetailsSearchState {
  RemoteServerErrorState({this.remoteServerErrorMessage});

  final String remoteServerErrorMessage;
}

class RemoteClientErrorState extends GroupDetailsSearchState {
  RemoteClientErrorState({this.remoteClientErrorMessage});

  final String remoteClientErrorMessage;
}

class SearchAddTagsState extends GroupDetailsSearchState {
  SearchAddTagsState({this.tagItems});

  final List<TagResponse> tagItems;
}

class ChanagSelectedTagListState extends GroupDetailsSearchState {
  final List<SearchModel> tagsItem;
  ChanagSelectedTagListState({this.tagsItem});
}
