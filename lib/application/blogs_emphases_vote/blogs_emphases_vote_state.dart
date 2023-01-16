part of 'blogs_emphases_vote_bloc.dart';

enum BlogsEmphasesVoteStatus {
  success,
  initial,
  failure,
  loading,
}

class BlogsEmphasesVoteState {
  final bool hasReachedMax;
  final BlogsEmphasesVoteStatus status;
  final List<BlogsVoteResponse> votes;
  // List<>
  BlogsEmphasesVoteState({
    this.hasReachedMax = false,
    this.status = BlogsEmphasesVoteStatus.initial,
    this.votes = const <BlogsVoteResponse>[],
  });

  copyWith({
    bool hasReachedMax,
    BlogsEmphasesVoteStatus status,
    List<BlogsVoteResponse> votes,
  }) {
    return BlogsEmphasesVoteState(
      hasReachedMax: (hasReachedMax) ?? this.hasReachedMax,
      status: (status) ?? this.status,
      votes: (votes) ?? this.votes,
    );
  }
}
