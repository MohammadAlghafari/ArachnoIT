part of 'blog_comment_item_bloc.dart';

abstract class CommentItemEvent extends Equatable {
  const CommentItemEvent();

  @override
  List<Object> get props => [];
}

class VoteUsefulEvent extends CommentItemEvent {
  const VoteUsefulEvent({this.itemId, this.status});

  final String itemId;
  final bool status;
  @override
  List<Object> get props => [itemId, status];
}

class GetProfileBridEvent extends CommentItemEvent {
  final String userId;
  final BuildContext context;
  GetProfileBridEvent({this.userId,this.context});
}
