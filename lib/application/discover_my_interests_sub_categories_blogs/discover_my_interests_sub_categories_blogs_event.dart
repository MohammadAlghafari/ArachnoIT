part of 'discover_my_interests_sub_categories_blogs_bloc.dart';

abstract class DiscoverMyInterestsSubCategoriesBlogsEvent extends Equatable {
  const DiscoverMyInterestsSubCategoriesBlogsEvent();

  @override
  List<Object> get props => [];
}

class DiscoverMyInterestsSubCategoriesBlogsFetched
    extends DiscoverMyInterestsSubCategoriesBlogsEvent {
  final String subCategoryId;
  DiscoverMyInterestsSubCategoriesBlogsFetched({@required this.subCategoryId});
  @override
  List<Object> get props => [subCategoryId];
}

class ReloadDiscoverMyInterestsSubCategoriesBlogsFetched
    extends DiscoverMyInterestsSubCategoriesBlogsEvent {
  final String subCategoryId;
  ReloadDiscoverMyInterestsSubCategoriesBlogsFetched(
      {@required this.subCategoryId});
  @override
  List<Object> get props => [subCategoryId];
}

class DeleteBlog extends DiscoverMyInterestsSubCategoriesBlogsEvent{
  final String blogId;
  final int index;
  final BuildContext context;
  DeleteBlog({@required this.blogId,@required this.index,@required this.context});
}