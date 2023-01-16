part of 'discover_categories_details_bloc.dart';

class DiscoverCategoriesDetailsState {
  const DiscoverCategoriesDetailsState({
    this.selectedItemIndex = 0,
    this.blogs = const <GetBlogsResponse>[],
    this.groups = const <GroupResponse>[],
    this.questions = const <QaaResponse>[],
    this.loading = false,
    this.isError = false,
  });

  final int selectedItemIndex;
  final List<GetBlogsResponse> blogs;
  final List<GroupResponse> groups;
  final List<QaaResponse> questions;
  final bool loading;
  final bool isError;

  DiscoverCategoriesDetailsState copyWith({
    int selectedItemIndex,
    List<GetBlogsResponse> blogs,
    List<GroupResponse> groups,
    List<QaaResponse> questions,
    bool loading,
    bool isError,
  }) {
    return DiscoverCategoriesDetailsState(
      selectedItemIndex: selectedItemIndex ?? this.selectedItemIndex,
      blogs: blogs ?? this.blogs,
      groups: groups ?? this.groups,
      questions: questions ?? this.questions,
      loading: loading ?? this.loading,
      isError: isError ?? this.isError,
    );
  }
}
