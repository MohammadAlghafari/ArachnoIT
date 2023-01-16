part of 'blog_list_item_bloc.dart';

@immutable
abstract class BlogListItemEvent extends Equatable {
  const BlogListItemEvent();

  @override
  List<Object> get props => [];
}

class VoteEmphasisEvent extends BlogListItemEvent {
  const VoteEmphasisEvent({this.itemId, this.status});

  final String itemId;
  final bool status;
  @override
  List<Object> get props => [itemId, status];
}

class VoteUsefulEvent extends BlogListItemEvent {
  const VoteUsefulEvent({this.itemId, this.status});

  final String itemId;
  final bool status;
  @override
  List<Object> get props => [itemId, status];
}

class DownloadFileEvent extends BlogListItemEvent {
  const DownloadFileEvent({this.url, this.fileName});

  final String url;
  final String fileName;
  @override
  List<Object> get props => [url, fileName];
}

class GetProfileBridEvent extends BlogListItemEvent {
  final String userId;
  final BuildContext context;
  GetProfileBridEvent({this.userId,this.context});
}

class UpdateEmphasesAndUsefulManula extends BlogListItemEvent {
  final int usefulCount;
  final int emphasesCount;
  UpdateEmphasesAndUsefulManula({this.emphasesCount,this.usefulCount});
}

class SendReport extends BlogListItemEvent {
  final String blogId;
  final String description;
  SendReport({this.blogId, this.description});
}

class UpdateBlogPostObject extends BlogListItemEvent{
  final GetBlogsResponse newBlogItem;
  UpdateBlogPostObject({this.newBlogItem});
}