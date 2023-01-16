part of 'home_blog_bloc.dart';

@immutable
abstract class HomeBlogEvent {
  const HomeBlogEvent();
}

class HomeBlogPostFetched extends HomeBlogEvent {
  final String userId;
  final bool reloadData;
  HomeBlogPostFetched({this.userId = "", this.reloadData = false});
}

class ReloadHomeBlogPostFetched extends HomeBlogEvent {
  final String userId;
  final bool reloadData;
  ReloadHomeBlogPostFetched({this.userId = "", this.reloadData = false});
}

class DeleteBlog extends HomeBlogEvent {
  final String blogId;
  final int index;
  final BuildContext context;
  DeleteBlog({@required this.blogId, @required this.index, @required this.context});
}
