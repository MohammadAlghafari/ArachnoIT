part of 'group_details_blogs_bloc.dart';

abstract class GroupDetailsBlogsEvent  {
  const GroupDetailsBlogsEvent();

}

class GroupBlogPostsFetched extends GroupDetailsBlogsEvent {
  GroupBlogPostsFetched({
    this.groupId,
    this.rebuildScreen=false,
  });
  final String groupId;
  final bool rebuildScreen;
}

class DeleteBlog extends GroupDetailsBlogsEvent{
  final String blogId;
  final int index;
  final BuildContext context;
  DeleteBlog({@required this.blogId,@required this.index,@required this.context});
}