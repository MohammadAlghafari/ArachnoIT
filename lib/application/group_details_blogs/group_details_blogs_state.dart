part of 'group_details_blogs_bloc.dart';

enum BLogPostStatus { initial, success, failure, loading }

@immutable
class GroupDetailsBlogsState {
  const GroupDetailsBlogsState({
    this.status = BLogPostStatus.initial,
    this.posts = const <GetBlogsResponse>[],
    this.hasReachedMax = false,
  });

  final BLogPostStatus status;
  final List<GetBlogsResponse> posts;
  final bool hasReachedMax;

  GroupDetailsBlogsState copyWith({
    BLogPostStatus status,
    List<GetBlogsResponse> posts,
    bool hasReachedMax,
  }) {
    return GroupDetailsBlogsState(
      status: status ?? this.status,
      posts: posts ?? this.posts,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }
}
