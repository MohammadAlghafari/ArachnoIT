import 'dart:async';

import 'package:arachnoit/infrastructure/add_blog/response/add_blog_response.dart';
import 'package:arachnoit/infrastructure/api/response_wrapper.dart';
import 'package:arachnoit/infrastructure/api/search_model.dart';
import 'package:arachnoit/infrastructure/blog_details/response/blog_details_response.dart';
import 'package:arachnoit/infrastructure/catalog_facade_service.dart';
import 'package:arachnoit/infrastructure/common_response/category_response.dart';
import 'package:arachnoit/infrastructure/common_response/file_response.dart';
import 'package:arachnoit/infrastructure/common_response/sub_category_response.dart';
import 'package:arachnoit/infrastructure/common_response/tag_response.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import '../../infrastructure/api/response_type.dart' as ResType;

part 'add_blog_event.dart';
part 'add_blog_state.dart';

class AddBlogBloc extends Bloc<AddBlogEvent, AddBlogState> {
  AddBlogBloc({@required this.catalogService}) : super(AddBlogInitial());

  final CatalogFacadeService catalogService;
  @override
  Stream<AddBlogState> mapEventToState(
    AddBlogEvent event,
  ) async* {
    if (event is AddBlogGetMainCategoryEvent) {
      yield* _mapCategoriesToState();
    } else if (event is AddBlogGetSubCategoryEvent) {
      yield* _mapSubCategoriesToState(event);
    } else if (event is AddBlogGetTagsEvent) {
      yield* _mapSearchAddTagsState();
    } else if (event is AddBlogChanagSelectedTagListEvent) {
      yield AddBlogChanagSelectedTagListState(tagsItem: event.tagsItem);
    } else if (event is AddBlogRemoveSelectedTagItem) {
      yield* _mapRemoveSelectedTagItem(state, event);
    } else if (event is AddBlogViewToHealthcareProvidersOnlyEvent) {
      yield AddBlogViewToHealthcareOnlyState(
          event.viewToHealthcareProvidersOnly);
    } else if (event is AddBlogPostButtonClicked) {
      yield* _mapPostButtonClickedToPostState(event);
    } else if (event is AddBlogUpdateFilesListEvent) {
      yield AddBlogUpdatedFileListState(files: event.files);
    } else if (event is AddBlogRemoveFileItem) {
      yield* _mapRemoveFileItem(state, event);
    } else if (event is AddBlogShowLinkPreviewEvent) {
      yield AddBlogShowLinkPreviewState(event.showPreview);
    } else if (event is AddBlogGetBlogInfoEvent) {
      yield* _mapGetBlogInfoEventToGetBlogInfoState(event.blogId);
    }
  }

  Stream<AddBlogState> _mapSearchAddTagsState() async* {
    try {
      yield LoadingState();
      final ResponseWrapper<List<TagResponse>> tagResponse =
          await catalogService.getQuestionAdvanceSearchAllTags();
      switch (tagResponse.responseType) {
        case ResType.ResponseType.SUCCESS:
          yield AddBlogGetTagsState(
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

  Stream<AddBlogState> _mapSubCategoriesToState(
      AddBlogGetSubCategoryEvent event) async* {
    try {
      yield LoadingState();
      final ResponseWrapper<List<SubCategoryResponse>> subCategoriesResponse =
          await catalogService.getQuestionSearchSubCategories(
              categoryId: event.categoryId);
      switch (subCategoriesResponse.responseType) {
        case ResType.ResponseType.SUCCESS:
          yield AddBlogGetSubCategoryState(
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

  Stream<AddBlogState> _mapCategoriesToState() async* {
    try {
      yield LoadingState();
      final ResponseWrapper<List<CategoryResponse>> categoriesResponse =
          await catalogService.getQuestionSearchMainCategories();
      switch (categoriesResponse.responseType) {
        case ResType.ResponseType.SUCCESS:
          yield AddBlogGetMainCategoryState(
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

  Stream<AddBlogState> _mapRemoveSelectedTagItem(
    AddBlogState state,
    AddBlogRemoveSelectedTagItem event,
  ) async* {
    List<SearchModel> items = <SearchModel>[];
    for (int i = 0; i < event.tagsItem.length; i++) {
      items.add(
          SearchModel(id: event.tagsItem[i].id, name: event.tagsItem[i].name));
    }
    items.removeAt(event.index);
    yield AddBlogChanagSelectedTagListState(tagsItem: items);
  }

  Stream<AddBlogState> _mapPostButtonClickedToPostState(
      AddBlogPostButtonClicked event) async* {
    try {
      yield LoadingState();
      final ResponseWrapper<AddBlogResponse> addBlogResponse =
          await catalogService.addBlog(
        id: event.id,
        subCategoryId: event.subCategoryId,
        groupId: event.groupId,
        title: event.title,
        body: event.body,
        blogType: event.blogType,
        viewToHealthcareProvidersOnly: event.viewToHealthcareProvidersOnly,
        blogTags: event.blogTags,
        publishByCreator: event.publishByCreator,
        files: event.files,
        externalFileUrl: event.externalFileUrl,
        externalFileType: event.externalFileType,
        removedFiles: event.removedFiles,
      );
      switch (addBlogResponse.responseType) {
        case ResType.ResponseType.SUCCESS:
          yield AddBlogPostSuccessState(
            addBlogResponse.data,
          );
          break;
        case ResType.ResponseType.VALIDATION_ERROR:
          yield RemoteValidationErrorState(
            remoteValidationErrorMessage: addBlogResponse.errorMessage,
          );
          break;
        case ResType.ResponseType.SERVER_ERROR:
          yield RemoteServerErrorState(
            remoteServerErrorMessage: addBlogResponse.errorMessage,
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

  Stream<AddBlogState> _mapRemoveFileItem(
    AddBlogState state,
    AddBlogRemoveFileItem event,
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
    yield AddBlogUpdatedFileListState(files: items);
  }

  Stream<AddBlogState> _mapGetBlogInfoEventToGetBlogInfoState(
      String blogId) async* {
    try {
      yield LoadingState();
      final ResponseWrapper<BlogDetailsResponse> addBlogResponse =
          await catalogService.getBlogDetails(blogId: blogId);
      switch (addBlogResponse.responseType) {
        case ResType.ResponseType.SUCCESS:
          yield AddBlogGetBlogInfoState(
            addBlogResponse.data,
          );
          break;
        case ResType.ResponseType.VALIDATION_ERROR:
          yield RemoteValidationErrorState(
            remoteValidationErrorMessage: addBlogResponse.errorMessage,
          );
          break;
        case ResType.ResponseType.SERVER_ERROR:
          yield RemoteServerErrorState(
            remoteServerErrorMessage: addBlogResponse.errorMessage,
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
