part of 'blog_replay_comment_item_bloc.dart';

abstract class BlogReplayDetailEvent extends Equatable {
  const BlogReplayDetailEvent();

  @override
  List<Object> get props => [];
}

class AddNewReplay extends BlogReplayDetailEvent {
  final String comment;
  final String postId;
  AddNewReplay({this.comment, this.postId});
}

class UpdateReplay extends BlogReplayDetailEvent {
  final String comment;
  final String postId;
  final String commentId;
  final int selectCommentIndex;
  UpdateReplay(
      {this.comment, this.postId, this.commentId, this.selectCommentIndex});
}

class DeleteReplay extends BlogReplayDetailEvent {
  final String commentId;
  final int selectCommentIndex;
  DeleteReplay({this.commentId, this.selectCommentIndex});
}

class FetchAllComment extends BlogReplayDetailEvent {
  final String blogId;
  final String commentId;
  final bool isRefreshData;
  FetchAllComment({this.blogId,this.commentId,this.isRefreshData=false});
}

class IsUpdateClickEvent extends BlogReplayDetailEvent {
  final bool state;
  IsUpdateClickEvent({this.state});
}

class SendReport extends BlogReplayDetailEvent {
  final String commentId;
  final String description;
  SendReport({this.commentId, this.description});
}
