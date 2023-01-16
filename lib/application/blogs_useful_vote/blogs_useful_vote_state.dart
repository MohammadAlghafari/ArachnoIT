part of 'blogs_useful_vote_bloc.dart';

enum BlogsUsefulVoteStatus {
  success,
  initial,
  failure,
  loading,
}

class BlogsUsefulVoteState {
  final bool hasReachedMax;
  final BlogsUsefulVoteStatus status;
  final List<BlogsVoteResponse> votes;
  // List<>
  BlogsUsefulVoteState({
    this.hasReachedMax = false,
    this.status = BlogsUsefulVoteStatus.initial,
    this.votes = const <BlogsVoteResponse>[],
  });

  copyWith({
    bool hasReachedMax,
    BlogsUsefulVoteStatus status,
    List<BlogsVoteResponse> votes,
  }) {
    return BlogsUsefulVoteState(
      hasReachedMax: (hasReachedMax) ?? this.hasReachedMax,
      status: (status) ?? this.status,
      votes: (votes) ?? this.votes,
    );
  }
}
