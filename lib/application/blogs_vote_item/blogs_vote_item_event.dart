part of 'blogs_vote_item_bloc.dart';

abstract class BlogsVoteItemEvent extends Equatable {
  const BlogsVoteItemEvent();

  @override
  List<Object> get props => [];
}
class GetProfileBridEvent extends BlogsVoteItemEvent {
  final String userId;
  final BuildContext context;
  GetProfileBridEvent({this.userId,this.context});
}