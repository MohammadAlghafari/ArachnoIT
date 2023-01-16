part of 'discover_categories_sub_category_all_blogs_bloc.dart';

abstract class DiscoverCategoriesSubCategoryAllBlogsEvent extends Equatable {
  const DiscoverCategoriesSubCategoryAllBlogsEvent();

  @override
  List<Object> get props => [];
}

class SubCategoryAllBlogPostFetchEvent extends DiscoverCategoriesSubCategoryAllBlogsEvent {
  SubCategoryAllBlogPostFetchEvent({
    this.subCategoryId,
    this.isReloadData=false
  });
  final String subCategoryId;
  final bool isReloadData;
   @override
  List<Object> get props => [subCategoryId];
}


class DeleteBlog extends DiscoverCategoriesSubCategoryAllBlogsEvent{
  final String blogId;
  final int index;
  final BuildContext context;
  DeleteBlog({@required this.blogId,@required this.index,@required this.context});
}