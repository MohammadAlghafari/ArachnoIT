part of 'blogs_emphases_vote_bloc.dart';

abstract class BlogsEmphasesVoteEvent extends Equatable {
  const BlogsEmphasesVoteEvent();

  @override
  List<Object> get props => [];
}

class GetUsefulBlogsVote extends BlogsEmphasesVoteEvent {
  final bool newRequest;
  final String itemId;
  final int voteType;
  final int itemType;
  GetUsefulBlogsVote({
    @required this.newRequest,
    @required this.itemId,
    @required this.itemType,
    @required this.voteType,
  });
}
