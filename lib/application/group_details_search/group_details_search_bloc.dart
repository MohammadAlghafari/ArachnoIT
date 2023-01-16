import 'dart:async';

import 'package:arachnoit/infrastructure/api/search_model.dart';
import 'package:arachnoit/infrastructure/common_response/tag_response.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../infrastructure/api/response_type.dart' as ResType;
import '../../infrastructure/api/response_wrapper.dart';
import '../../infrastructure/catalog_facade_service.dart';
import '../../infrastructure/common_response/category_response.dart';
import '../../infrastructure/common_response/sub_category_response.dart';

part 'group_details_search_event.dart';
part 'group_details_search_state.dart';

class GroupDetailsSearchBloc
    extends Bloc<GroupDetailsSearchEvent, GroupDetailsSearchState> {
  GroupDetailsSearchBloc({@required this.catalogService})
      : assert(catalogService != null),
        super(const GroupDetailsSearchState());

  final CatalogFacadeService catalogService;

  @override
  Stream<GroupDetailsSearchState> mapEventToState(
    GroupDetailsSearchEvent event,
  ) async* {
    if (event is SearchTextSubmittedEvent) {
      yield _mapSearchTextSubmittedToState(state, event);
    } else if (event is AdvancedSearchSubmittedEvent) {
      yield _mapAdvancedSearchSubmittedToState(state, event);
    } else if (event is GetAdvancedSearchCategories) {
      yield* _mapCategoriesToState();
    } else if (event is GetAdvancedSearchSubCategories) {
      yield* _mapSubCategoriesToState(event);
    } else if (event is GetAdvanceSearchAddTags) {
      yield* _mapSearchAddTagsState();
    } else if (event is ChanagSelectedTagListEvent) {
      yield* _mapChanagSelectedTagListEvent(state, event);
    } else if (event is RemoveSelectedTagItem) {
      yield* _mapRemoveSelectedTagItem(state, event);
    }
  }

  Stream<GroupDetailsSearchState> _mapRemoveSelectedTagItem(
    GroupDetailsSearchState state,
    RemoveSelectedTagItem event,
  ) async* {
    List<SearchModel> items = List<SearchModel>();
    for (int i = 0; i < event.tagsItem.length; i++) {
      items.add(
          SearchModel(id: event.tagsItem[i].id, name: event.tagsItem[i].name));
    }
    items.removeAt(event.index);
    yield ChanagSelectedTagListState(tagsItem: items);
  }

  Stream<GroupDetailsSearchState> _mapChanagSelectedTagListEvent(
    GroupDetailsSearchState state,
    ChanagSelectedTagListEvent event,
  ) async* {
    yield ChanagSelectedTagListState(tagsItem: event.tagsItem);
  }

  Stream<GroupDetailsSearchState> _mapSearchAddTagsState() async* {
    try {
      yield LoadingState();
      final ResponseWrapper<List<TagResponse>> tagResponse =
          await catalogService.getGroupAdvanceSearchAllTags();
      switch (tagResponse.responseType) {
        case ResType.ResponseType.SUCCESS:
          yield SearchAddTagsState(
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
    } catch (e) {
      yield RemoteValidationErrorState(
        remoteValidationErrorMessage: "Error happened try again",
      );
    }
  }

  GroupDetailsSearchState _mapSearchTextSubmittedToState(
    GroupDetailsSearchState state,
    SearchTextSubmittedEvent event,
  ) {
    return state.copyWith(
      searchText: event.query,
      categoryId: null,
      subCategoryId: null,
      accountType: null,
      shouldDestroyWidget: true,
    );
  }

  GroupDetailsSearchState _mapAdvancedSearchSubmittedToState(
    GroupDetailsSearchState state,
    AdvancedSearchSubmittedEvent event,
  ) {
    return state.copyWith(
      searchText: null,
      categoryId: event.categoryId,
      subCategoryId: event.subCategoryId,
      accountType: event.accountType,
      tagsId: event.tagsId,
      shouldDestroyWidget: false,
    );
  }

  Stream<GroupDetailsSearchState> _mapSubCategoriesToState(
      GetAdvancedSearchSubCategories event) async* {
    try {
      yield LoadingState();
      final ResponseWrapper<List<SubCategoryResponse>> subCategoriesResponse =
          await catalogService.getGroupSearchSubCategories(
              categoryId: event.categoryId);
      switch (subCategoriesResponse.responseType) {
        case ResType.ResponseType.SUCCESS:
          yield SearchSubCategoriesState(
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
    } catch (e) {
      yield RemoteValidationErrorState(
        remoteValidationErrorMessage: "Error happened try again",
      );
    }
  }

  Stream<GroupDetailsSearchState> _mapCategoriesToState() async* {
    try {
      yield LoadingState();
      final ResponseWrapper<List<CategoryResponse>> categoriesResponse =
          await catalogService.getGroupSearchCategories();
      switch (categoriesResponse.responseType) {
        case ResType.ResponseType.SUCCESS:
          yield SearchCategoriesState(
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
    } catch (e) {
      yield RemoteValidationErrorState(
        remoteValidationErrorMessage: "Error happened try again",
      );
    }
  }
}
