part of 'add_question_bloc.dart';

abstract class AddQuestionEvent {
  const AddQuestionEvent();
}

class AddQuestionGetMainCategoryEvent extends AddQuestionEvent {
  final bool isRefreshData;
  const AddQuestionGetMainCategoryEvent({this.isRefreshData=false});
}

class AddQuestionGetSubCategoryEvent extends AddQuestionEvent {
  
  final String categoryId;
  final bool isRefreshData;
   AddQuestionGetSubCategoryEvent(
    this.categoryId,
    {this.isRefreshData=false}
  );

}

class AddQuestionGetTagsEvent extends AddQuestionEvent {
  const AddQuestionGetTagsEvent();
}

class AddQuestionChanagSelectedTagListEvent extends AddQuestionEvent {
  final List<SearchModel> tagsItem;
  AddQuestionChanagSelectedTagListEvent({this.tagsItem});
}

class AddQuestionUpdateFilesListEvent extends AddQuestionEvent {
  final List<FileResponse> files;
  AddQuestionUpdateFilesListEvent({this.files});
}

class AddQuestionRemoveSelectedTagItem extends AddQuestionEvent {
  final int index;
  final List<SearchModel> tagsItem;
  AddQuestionRemoveSelectedTagItem({@required this.index, @required this.tagsItem});
}

class AddQuestionRemoveFileItem extends AddQuestionEvent {
  final int index;
  final List<FileResponse> files;
  AddQuestionRemoveFileItem({
    @required this.index,
    @required this.files,
  });
}

class AddQuestionAskButtonClicked extends AddQuestionEvent {
  const AddQuestionAskButtonClicked({
    @required this.id,
    @required this.subCategoryIds,
    @required this.groupId,
    @required this.title,
    @required this.body,
    @required this.viewToHealthcareProvidersOnly,
    @required this.askAnonymously,
    @required this.questionTags,
    @required this.files,
    @required this.removedFiles,
  });

  final String id;
  final List<String> subCategoryIds;
  final String groupId;
  final String title;
  final String body;
  final bool viewToHealthcareProvidersOnly;
  final bool askAnonymously;
  final List<String> questionTags;
  final List<FileResponse> files;
  final List<String> removedFiles;
}

class AddQuestionAskAnonymousEvent extends AddQuestionEvent {
  final bool askAnonymous;
  AddQuestionAskAnonymousEvent({
    @required this.askAnonymous,
  });
}

class AddQuestionViewToHealthcareProvidersOnlyEvent extends AddQuestionEvent {
  final bool viewToHealthcareProvidersOnly;
  AddQuestionViewToHealthcareProvidersOnlyEvent({
    @required this.viewToHealthcareProvidersOnly,
  });
}

class AddQuestionGetQuestionInfoEvent extends AddQuestionEvent {
  final String questionId;
  AddQuestionGetQuestionInfoEvent({
    @required this.questionId,
  });
}

class SetCategorieId extends AddQuestionEvent {
  final String categoriesId;
  final String categoryName;
  SetCategorieId({this.categoriesId, @required this.categoryName});
}

class UpdateCheckListValue extends AddQuestionEvent {
  SubCategoryResponse subCategoryItem;
  bool isRemoveItem;
  UpdateCheckListValue(
      { @required this.subCategoryItem, @required this.isRemoveItem});
}

class DeleteItemFromSubCategory extends AddQuestionEvent{
  final String subCategory ;
  DeleteItemFromSubCategory({this.subCategory});
}

class ChangeShouldDestoryState extends AddQuestionEvent{
}