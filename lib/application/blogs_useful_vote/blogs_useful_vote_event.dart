part of 'blogs_useful_vote_bloc.dart';

abstract class BlogsUsefulVoteEvent extends Equatable {
  const BlogsUsefulVoteEvent();

  @override
  List<Object> get props => [];
}

class GetUsefulBlogsVote extends BlogsUsefulVoteEvent {
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
