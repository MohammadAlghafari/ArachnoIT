part of 'group_details_search_blogs_bloc.dart';

enum BlogPostStatus { initial, loading, success, failure }

@immutable
 class GroupDetailsSearchBlogsState  {
  const GroupDetailsSearchBlogsState({
    this.status = BlogPostStatus.initial,
    this.posts = const <GetBlogsResponse>[],
    this.hasReachedMax = false,
  });

  final BlogPostStatus status;
  final List<GetBlogsResponse> posts;
  final bool hasReachedMax;

  GroupDetailsSearchBlogsState copyWith({
    BlogPostStatus status,
    List<GetBlogsResponse> posts,
    bool hasReachedMax,
  }) {
    return GroupDetailsSearchBlogsState(
      status: status ?? this.status,
      posts: posts ?? this.posts,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

}

