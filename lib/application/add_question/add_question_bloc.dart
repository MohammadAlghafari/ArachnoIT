import 'dart:async';

import 'package:arachnoit/infrastructure/add_questions/response/add_question_response.dart';
import 'package:arachnoit/infrastructure/api/response_wrapper.dart';
import 'package:arachnoit/infrastructure/api/search_model.dart';
import 'package:arachnoit/infrastructure/catalog_facade_service.dart';
import 'package:arachnoit/infrastructure/common_response/category_response.dart';
import 'package:arachnoit/infrastructure/common_response/file_response.dart';
import 'package:arachnoit/infrastructure/common_response/sub_category_response.dart';
import 'package:arachnoit/infrastructure/common_response/tag_response.dart';
import 'package:arachnoit/infrastructure/question_details/response/question_details_response.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import '../../infrastructure/api/response_type.dart' as ResType;

part 'add_question_event.dart';
part 'add_question_state.dart';

class AddQuestionBloc extends Bloc<AddQuestionEvent, AddQuestionState> {
  AddQuestionBloc({@required this.catalogService}) : super(AddQuestionInitial());

  final CatalogFacadeService catalogService;
  String categoriesId = "";
  List<SubCategoryResponse> subCategoryItem = [];
  String categoryName = "";
  bool shouldDestroyWidget = false;
  @override
  Stream<AddQuestionState> mapEventToState(
    AddQuestionEvent event,
  ) async* {
    if (event is AddQuestionGetMainCategoryEvent) {
      yield* _mapCategoriesToState(event);
    } else if (event is AddQuestionGetSubCategoryEvent) {
      yield* _mapSubCategoriesToState(event);
    } else if (event is AddQuestionGetTagsEvent) {
      yield* _mapSearchAddTagsState();
    } else if (event is AddQuestionChanagSelectedTagListEvent) {
      yield AddQuestionChanagSelectedTagListState(tagsItem: event.tagsItem);
    } else if (event is AddQuestionRemoveSelectedTagItem) {
      yield* _mapRemoveSelectedTagItem(state, event);
    } else if (event is AddQuestionUpdateFilesListEvent) {
      yield AddQuestionUpdatedFileListState(files: event.files);
    } else if (event is AddQuestionRemoveFileItem) {
      yield* _mapRemoveFileItem(state, event);
    } else if (event is AddQuestionAskButtonClicked) {
      yield* _mapAskButtonClickedToAskState(event);
    } else if (event is AddQuestionAskAnonymousEvent) {
      yield AddQuestionAskAnonymousState(event.askAnonymous);
    } else if (event is AddQuestionViewToHealthcareProvidersOnlyEvent) {
      yield AddQuestionViewToHealthcareOnlyState(event.viewToHealthcareProvidersOnly);
    } else if (event is AddQuestionGetQuestionInfoEvent) {
      yield* _mapGetQuestionInfoEventToGetQuestionInfoState(event.questionId);
    } else if (event is SetCategorieId) {
      categoriesId = event.categoriesId;
      categoryName = event.categoryName;
      subCategoryItem = [];
      yield ResetSubCategoryValue();
    } else if (event is UpdateCheckListValue) {
      yield* _mapUpdateCheckListValue(event);
    } else if (event is DeleteItemFromSubCategory) {
      yield* _mapDeleteItemFromSubCategory(event);
    } else if (event is ChangeShouldDestoryState) {
      shouldDestroyWidget = false;
      yield RefreshInfo();
    }
  }

  Stream<AddQuestionState> _mapDeleteItemFromSubCategory(DeleteItemFromSubCategory event) async* {
    int index = 0;
    for (SubCategoryResponse item in subCategoryItem) {
      if (item.id == event.subCategory) {
        subCategoryItem.removeAt(index);
        break;
      }
      index++;
    }
    yield RefreshInfo();
  }

  Stream<AddQuestionState> _mapUpdateCheckListValue(UpdateCheckListValue event) async* {
    if (event.isRemoveItem) {
      int index = 0;
      for (SubCategoryResponse item in subCategoryItem) {
        if (item == event.subCategoryItem) {
          subCategoryItem.removeAt(index);
          break;
        }
        index++;
      }
    } else {
      subCategoryItem.add(event.subCategoryItem);
    }
    yield UpdateCheckListValueState(subCategoryID: event.subCategoryItem.id);
  }

  Stream<AddQuestionState> _mapSearchAddTagsState() async* {
    try {
      yield LoadingState();
      final ResponseWrapper<List<TagResponse>> tagResponse =
          await catalogService.getQuestionAdvanceSearchAllTags();
      switch (tagResponse.responseType) {
        case ResType.ResponseType.SUCCESS:
          yield AddQuestionGetTagsState(
            tagItems: tagResponse.data,
          );
          break;
        case ResType.ResponseType.VALIDATION_ERROR:
          yield RemoteValidationErrorState(
            remoteValidationErrorMessage: tagResponse.errorMessage,
          );
          break;
        case ResType.ResponseType.SERVER_ERROR:
          yield RemoteServerErrorState(
            remoteServerErrorMessage: tagResponse.errorMessage,
          );
          break;
        case ResType.ResponseType.CLIENT_ERROR:
          yield RemoteClientErrorState();
          break;
        case ResType.ResponseType.NETWORK_ERROR:
          break;
      }
    } catch (e) {}
  }

  Stream<AddQuestionState> _mapSubCategoriesToState(AddQuestionGetSubCategoryEvent event) async* {
    try {
      if (!event.isRefreshData) yield LoadingState();
      final ResponseWrapper<List<SubCategoryResponse>> subCategoriesResponse =
          await catalogService.getQuestionSearchSubCategories(categoryId: event.categoryId);
      shouldDestroyWidget = false;
      switch (subCategoriesResponse.responseType) {
        case ResType.ResponseType.SUCCESS:
          yield AddQuestionGetSubCategoryState(
            subCategories: subCategoriesResponse.data,
          );

          break;
        case ResType.ResponseType.VALIDATION_ERROR:
          yield RemoteValidationErrorState(
            remoteValidationErrorMessage: subCategoriesResponse.errorMessage,
          );
          break;
        case ResType.ResponseType.SERVER_ERROR:
          yield RemoteServerErrorState(
            remoteServerErrorMessage: subCategoriesResponse.errorMessage,
          );
          break;
        case ResType.ResponseType.CLIENT_ERROR:
          yield RemoteClientErrorState();
          break;
        case ResType.ResponseType.NETWORK_ERROR:
          break;
      }
    } catch (e) {}
  }

  Stream<AddQuestionState> _mapCategoriesToState(AddQuestionGetMainCategoryEvent event) async* {
    try {
      if (!event.isRefreshData) yield LoadingState();
      final ResponseWrapper<List<CategoryResponse>> categoriesResponse =
          await catalogService.getQuestionSearchMainCategories();
      switch (categoriesResponse.responseType) {
        case ResType.ResponseType.SUCCESS:
          yield AddQuestionGetMainCategoryState(
            categories: categoriesResponse.data,
          );
          break;
        case ResType.ResponseType.VALIDATION_ERROR:
          yield RemoteValidationErrorState(
            remoteValidationErrorMessage: categoriesResponse.errorMessage,
          );
          break;
        case ResType.ResponseType.SERVER_ERROR:
          yield RemoteServerErrorState(
            remoteServerErrorMessage: categoriesResponse.errorMessage,
          );
          break;
        case ResType.ResponseType.CLIENT_ERROR:
          yield RemoteClientErrorState();
          break;
        case ResType.ResponseType.NETWORK_ERROR:
          break;
      }
    } catch (e) {}
  }

  Stream<AddQuestionState> _mapRemoveSelectedTagItem(
    AddQuestionState state,
    AddQuestionRemoveSelectedTagItem event,
  ) async* {
    List<SearchModel> items = <SearchModel>[];
    for (int i = 0; i < event.tagsItem.length; i++) {
      items.add(SearchModel(id: event.tagsItem[i].id, name: event.tagsItem[i].name));
    }
    items.removeAt(event.index);
    yield AddQuestionChanagSelectedTagListState(tagsItem: items);
  }

  Stream<AddQuestionState> _mapRemoveFileItem(
    AddQuestionState state,
    AddQuestionRemoveFileItem event,
  ) async* {
    List<FileResponse> items = <FileResponse>[];
    for (int i = 0; i < event.files.length; i++) {
      items.add(FileResponse(
        url: event.files[i].url,
        name: event.files[i].name,
        extension: event.files[i].extension,
        id: event.files[i].id,
      ));
    }
    items.removeAt(event.index);
    yield AddQuestionUpdatedFileListState(files: items);
  }

  Stream<AddQuestionState> _mapAskButtonClickedToAskState(
      AddQuestionAskButtonClicked event) async* {
    try {
      yield LoadingState();
      final ResponseWrapper<AddQuestionResponse> askQuestionResponse =
          await catalogService.addQuestion(
        id: event.id,
        subCategoryIds: event.subCategoryIds,
        groupId: event.groupId,
        title: event.title,
        body: event.body,
        viewToHealthcareProvidersOnly: event.viewToHealthcareProvidersOnly,
        askAnonymously: event.askAnonymously,
        questionTags: event.questionTags,
        files: event.files,
        removedFiles: event.removedFiles,
      );
      switch (askQuestionResponse.responseType) {
        case ResType.ResponseType.SUCCESS:
          yield AddQuestionAskSuccessState(
            askQuestionResponse.data,
          );
          break;
        case ResType.ResponseType.VALIDATION_ERROR:
          yield RemoteValidationErrorState(
            remoteValidationErrorMessage: askQuestionResponse.errorMessage,
          );
          break;
        case ResType.ResponseType.SERVER_ERROR:
          yield RemoteServerErrorState(
            remoteServerErrorMessage: askQuestionResponse.errorMessage,
          );
          break;
        case ResType.ResponseType.CLIENT_ERROR:
          yield RemoteClientErrorState();
          break;
        case ResType.ResponseType.NETWORK_ERROR:
          break;
      }
    } catch (e) {}
  }

  Stream<AddQuestionState> _mapGetQuestionInfoEventToGetQuestionInfoState(
      String questionId) async* {
    try {
      yield LoadingState();
      final ResponseWrapper<QuestionDetailsResponse> questionInfoResponse =
          await catalogService.getQuestionDetails(
        questionId: questionId,
      );
      switch (questionInfoResponse.responseType) {
        case ResType.ResponseType.SUCCESS:
          yield AddQuestionGetQuestionInfoState(
            questionInfoResponse.data,
          );
          break;
        case ResType.ResponseType.VALIDATION_ERROR:
          yield RemoteValidationErrorState(
            remoteValidationErrorMessage: questionInfoResponse.errorMessage,
          );
          break;
        case ResType.ResponseType.SERVER_ERROR:
          yield RemoteServerErrorState(
            remoteServerErrorMessage: questionInfoResponse.errorMessage,
          );
          break;
        case ResType.ResponseType.CLIENT_ERROR:
          yield RemoteClientErrorState();
          break;
        case ResType.ResponseType.NETWORK_ERROR:
          break;
      }
    } catch (e) {}
  }
}
