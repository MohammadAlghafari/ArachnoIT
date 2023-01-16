part of 'add_blog_bloc.dart';

abstract class AddBlogEvent {
  const AddBlogEvent();
}

class AddBlogGetMainCategoryEvent extends AddBlogEvent {
  const AddBlogGetMainCategoryEvent();
}

class AddBlogGetSubCategoryEvent extends AddBlogEvent {
  const AddBlogGetSubCategoryEvent(
    this.categoryId,
  );

  final String categoryId;
}

class AddBlogGetTagsEvent extends AddBlogEvent {
  const AddBlogGetTagsEvent();
}

class AddBlogChanagSelectedTagListEvent extends AddBlogEvent {
  final List<SearchModel> tagsItem;
  AddBlogChanagSelectedTagListEvent({this.tagsItem});
}

class AddBlogRemoveSelectedTagItem extends AddBlogEvent {
  final int index;
  final List<SearchModel> tagsItem;
  AddBlogRemoveSelectedTagItem({@required this.index, @required this.tagsItem});
}

class AddBlogViewToHealthcareProvidersOnlyEvent extends AddBlogEvent {
  final bool viewToHealthcareProvidersOnly;
  AddBlogViewToHealthcareProvidersOnlyEvent({
    @required this.viewToHealthcareProvidersOnly,
  });
}

class AddBlogPostButtonClicked extends AddBlogEvent {
  const AddBlogPostButtonClicked({
    @required this.id,
    @required this.subCategoryId,
    @required this.groupId,
    @required this.title,
    @required this.body,
    @required this.blogType,
    @required this.viewToHealthcareProvidersOnly,
    @required this.publishByCreator,
    @required this.blogTags,
    @required this.files,
    @required this.externalFileUrl,
    @required this.externalFileType,
    @required this.removedFiles,
  });

  final String id;
  final String subCategoryId;
  final String groupId;
  final String title;
  final String body;
  final int blogType;
  final bool viewToHealthcareProvidersOnly;
  final bool publishByCreator;
  final List<String> blogTags;
  final List<FileResponse> files;
  final String externalFileUrl;
  final int externalFileType;
  final List<String> removedFiles;
}

class AddBlogUpdateFilesListEvent extends AddBlogEvent {
  final List<FileResponse> files;
  AddBlogUpdateFilesListEvent({this.files});
}

class AddBlogRemoveFileItem extends AddBlogEvent {
  final int index;
  final List<FileResponse> files;
  AddBlogRemoveFileItem({
    @required this.index,
    @required this.files,
  });
}

class AddBlogShowLinkPreviewEvent extends AddBlogEvent {
  const AddBlogShowLinkPreviewEvent(this.showPreview);

  final bool showPreview;
}

class AddBlogGetBlogInfoEvent extends AddBlogEvent {
  final String blogId;
  AddBlogGetBlogInfoEvent({
    @required this.blogId,
  });
}
