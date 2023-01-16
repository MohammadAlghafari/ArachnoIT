part of 'blog_details_bloc.dart';

abstract class BlogDetailsEvent extends Equatable {
  const BlogDetailsEvent();

  @override
  List<Object> get props => [];
}

class FetchBlogDetailsEvent extends BlogDetailsEvent {
  const FetchBlogDetailsEvent({
    this.blogId,
    this.isRefreshData=false
  });

  final String blogId;
  final bool isRefreshData;
  @override
  List<Object> get props => [blogId];
}

class VoteEmphasisEvent extends BlogDetailsEvent {
  const VoteEmphasisEvent({this.itemId, this.status});

  final String itemId;
  final bool status;
  @override
  List<Object> get props => [itemId, status];
}

class VoteUsefulEvent extends BlogDetailsEvent {
  const VoteUsefulEvent({this.itemId, this.status});

  final String itemId;
  final bool status;
  @override
  List<Object> get props => [itemId, status];
}

class DownloadFileEvent extends BlogDetailsEvent {
  const DownloadFileEvent({this.url, this.fileName});

  final String url;
  final String fileName;
  @override
  List<Object> get props => [url, fileName];
}

class AddNewComment extends BlogDetailsEvent {
  final String comment;
  final String postId;
  AddNewComment({this.comment, this.postId});
}

class UpdateComment extends BlogDetailsEvent {
  final String comment;
  final String postId;
  final String commentId;
  final int selectCommentIndex;
  UpdateComment(
      {this.comment, this.postId, this.commentId, this.selectCommentIndex});
}

class DelteComment extends BlogDetailsEvent {
  final String commentId;
  final int selectCommentIndex;
  DelteComment({this.commentId, this.selectCommentIndex});
}

class IsUpdateClickEvent extends BlogDetailsEvent {
  final bool state;
  IsUpdateClickEvent({this.state});
}

class ChangeReplayCounterEvent extends BlogDetailsEvent {
  final int index;
  final int numberOfReplay;
  ChangeReplayCounterEvent({this.index, this.numberOfReplay});
}

class SendReport extends BlogDetailsEvent {
  final String commentId;
  final String description;
  SendReport({this.commentId, this.description});
}

class GetProfileBridEvent extends BlogDetailsEvent {
  final String userId;
  final BuildContext context;
  GetProfileBridEvent({this.userId,this.context});
}