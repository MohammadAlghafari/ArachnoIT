part of 'home_blog_bloc.dart';

enum BLogPostStatus { initial, success, failure,loadingData }


@immutable
class HomeBlogState  {
 const HomeBlogState({
    this.status = BLogPostStatus.initial,
    this.posts = const <GetBlogsResponse>[],
    this.hasReachedMax = false,
  });

  final BLogPostStatus status;
  final List<GetBlogsResponse> posts;
  final bool hasReachedMax;

  HomeBlogState copyWith({
    BLogPostStatus status,
    List<GetBlogsResponse> posts,
    bool hasReachedMax,
  }) {
    return HomeBlogState(
      status: status ?? this.status,
      posts: posts ?? this.posts,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

}
