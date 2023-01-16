part of 'add_blog_bloc.dart';

abstract class AddBlogState {
  const AddBlogState();

}

class AddBlogInitial extends AddBlogState {}

class LoadingState extends AddBlogState {}

class RemoteValidationErrorState extends AddBlogState {
  final String remoteValidationErrorMessage;
  RemoteValidationErrorState({this.remoteValidationErrorMessage});
}

class RemoteServerErrorState extends AddBlogState {
  RemoteServerErrorState({this.remoteServerErrorMessage});

  final String remoteServerErrorMessage;
}

class RemoteClientErrorState extends AddBlogState {
  RemoteClientErrorState({this.remoteClientErrorMessage});
  final String remoteClientErrorMessage;
}

class AddBlogGetMainCategoryState extends AddBlogState {
  final List<CategoryResponse> categories;
  AddBlogGetMainCategoryState({this.categories});
}

class AddBlogGetSubCategoryState extends AddBlogState {
  final List<SubCategoryResponse> subCategories;
  AddBlogGetSubCategoryState({this.subCategories});
}

class AddBlogGetTagsState extends AddBlogState {
  final List<TagResponse> tagItems;
  AddBlogGetTagsState({@required this.tagItems});
}

class AddBlogChanagSelectedTagListState extends AddBlogState {
  final List<SearchModel> tagsItem;
  AddBlogChanagSelectedTagListState({this.tagsItem});
}



class AddBlogViewToHealthcareOnlyState extends AddBlogState {
  const AddBlogViewToHealthcareOnlyState(
    this.viewToHealthcareOnly,
  );

  final bool viewToHealthcareOnly;
}

class AddBlogPostSuccessState extends AddBlogState {
  const AddBlogPostSuccessState(
    this.response,
  );

  final AddBlogResponse response;
}

class AddBlogUpdatedFileListState extends AddBlogState {
  final List<FileResponse> files;
  AddBlogUpdatedFileListState({this.files});
}

class AddBlogShowLinkPreviewState extends AddBlogState {
  const AddBlogShowLinkPreviewState(this.showPreview);

  final bool showPreview;
}

class AddBlogGetBlogInfoState extends AddBlogState {
  const AddBlogGetBlogInfoState(
    this.response,
  );

  final BlogDetailsResponse response;
}