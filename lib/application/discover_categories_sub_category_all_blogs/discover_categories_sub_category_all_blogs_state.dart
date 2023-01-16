part of 'discover_categories_sub_category_all_blogs_bloc.dart';

enum BLogPostStatus { initial, success, failure,loading }

@immutable
class DiscoverCategoriesSubCategoryAllBlogsState {
  const DiscoverCategoriesSubCategoryAllBlogsState({
    this.status = BLogPostStatus.initial,
    this.posts = const <GetBlogsResponse>[],
    this.hasReachedMax = false,
  });

  final BLogPostStatus status;
  final List<GetBlogsResponse> posts;
  final bool hasReachedMax;

  DiscoverCategoriesSubCategoryAllBlogsState copyWith({
    BLogPostStatus status,
    List<GetBlogsResponse> posts,
    bool hasReachedMax,
  }) {
    return DiscoverCategoriesSubCategoryAllBlogsState(
      status: status ?? this.status,
      posts: posts ?? this.posts,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }
}
