part of 'discover_my_interests_sub_categories_blogs_bloc.dart';

enum BLogPostStatus { initial, success, failure , loading}

class DiscoverMyInterestsSubCategoriesBlogsState {
  final BLogPostStatus status;
  final List<GetBlogsResponse> posts;
  final bool hasReachedMax;
  const DiscoverMyInterestsSubCategoriesBlogsState({
    this.hasReachedMax = false,
    this.posts = const <GetBlogsResponse>[],
    this.status = BLogPostStatus.initial,
  });
  DiscoverMyInterestsSubCategoriesBlogsState copyWith({
    bool hasReachedMax,
    List<GetBlogsResponse> posts,
    BLogPostStatus status,
  }) {
    return DiscoverMyInterestsSubCategoriesBlogsState(
        posts: (posts) ?? (this.posts),
        hasReachedMax: (hasReachedMax) ?? (this.hasReachedMax),
        status: (status) ?? this.status);
  }
}
