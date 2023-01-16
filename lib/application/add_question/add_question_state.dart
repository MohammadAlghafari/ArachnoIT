part of 'add_question_bloc.dart';

abstract class AddQuestionState {
  String categoriesId;
  AddQuestionState({this.categoriesId});
}

class AddQuestionInitial extends AddQuestionState {}

class LoadingState extends AddQuestionState {}

class RemoteValidationErrorState extends AddQuestionState {
  final String remoteValidationErrorMessage;
  RemoteValidationErrorState({this.remoteValidationErrorMessage});
}

class RemoteServerErrorState extends AddQuestionState {
  RemoteServerErrorState({this.remoteServerErrorMessage});

  final String remoteServerErrorMessage;
}

class RemoteClientErrorState extends AddQuestionState {
  RemoteClientErrorState({this.remoteClientErrorMessage});
  final String remoteClientErrorMessage;
}

class AddQuestionGetMainCategoryState extends AddQuestionState {
  final List<CategoryResponse> categories;
  AddQuestionGetMainCategoryState({this.categories});
}

class AddQuestionGetSubCategoryState extends AddQuestionState {
  final List<SubCategoryResponse> subCategories;
  AddQuestionGetSubCategoryState({this.subCategories});
}

class AddQuestionGetTagsState extends AddQuestionState {
  final List<TagResponse> tagItems;
  AddQuestionGetTagsState({@required this.tagItems});
}

class AddQuestionChanagSelectedTagListState extends AddQuestionState {
  final List<SearchModel> tagsItem;
  AddQuestionChanagSelectedTagListState({this.tagsItem});
}

class AddQuestionUpdatedFileListState extends AddQuestionState {
  final List<FileResponse> files;
  AddQuestionUpdatedFileListState({this.files});
}

class AddQuestionAskSuccessState extends AddQuestionState {
  AddQuestionAskSuccessState(
    this.response,
  );

  final AddQuestionResponse response;
}

class AddQuestionAskAnonymousState extends AddQuestionState {
  AddQuestionAskAnonymousState(
    this.askAnonymous,
  );

  final bool askAnonymous;
}

class AddQuestionViewToHealthcareOnlyState extends AddQuestionState {
  AddQuestionViewToHealthcareOnlyState(
    this.viewToHealthcareOnly,
  );

  final bool viewToHealthcareOnly;
}

class AddQuestionGetQuestionInfoState extends AddQuestionState {
  AddQuestionGetQuestionInfoState(
    this.response,
  );

  final QuestionDetailsResponse response;
}

class UpdateCheckListValueState extends AddQuestionState {
  final int index;
  final String subCategoryID;
  UpdateCheckListValueState({this.index,@required this.subCategoryID});
}

class RefreshInfo extends AddQuestionState {}

class ResetSubCategoryValue extends AddQuestionState {}