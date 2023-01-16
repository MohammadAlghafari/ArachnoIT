import 'dart:async';

import 'package:arachnoit/infrastructure/api/response_wrapper.dart';
import 'package:arachnoit/infrastructure/api/search_model.dart';
import 'package:arachnoit/infrastructure/catalog_facade_service.dart';
import 'package:arachnoit/infrastructure/common_response/category_response.dart';
import 'package:arachnoit/infrastructure/common_response/sub_category_response.dart';
import 'package:arachnoit/infrastructure/common_response/tag_response.dart';
import 'package:arachnoit/infrastructure/home_blog/response/get_blogs_response.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';
import '../../infrastructure/api/response_type.dart' as ResType;
part 'search_blogs_event.dart';
part 'search_blogs_state.dart';

const _postLimit = 20;

class SearchBlogsBloc extends Bloc<SearchBlogsEvent, SearchBlogsState> {
  final CatalogFacadeService catalogService;
  SearchBlogsBloc({this.catalogService})
      : assert(catalogService != null),
        super(SearchBlogsState());
  @override
  Stream<Transition<SearchBlogsEvent, SearchBlogsState>> transformEvents(
    Stream<SearchBlogsEvent> events,
    TransitionFunction<SearchBlogsEvent, SearchBlogsState> transitionFn,
  ) {
    return super.transformEvents(
      events.debounceTime(const Duration(milliseconds: 200)),
      transitionFn,
    );
  }

  @override
  Stream<SearchBlogsState> mapEventToState(SearchBlogsEvent event) async* {
    if (event is GetAdvanceSearchMainCategory) {
      yield* _mapCategoriesToState();
    } else if (event is GetAdvanceSearchSubCategory) {
      yield* _mapSubCategoriesToState(event);
    } else if (event is GetAdvanceSearchAllTags) {
      yield* _mapSearchAddTagsState();
    } else if (event is ChanagSelectedTagListEvent) {
      yield ChanagSelectedTagListState(tagsItem: event.tagsItem);
    } else if (event is RemoveSelectedTagItem) {
      yield* _mapRemoveSelectedTagItem(state, event);
    } else if (event is GetAdvanceSearchValuesEvent) {
      yield* _mapGetAdvanceSearchValuesEvent(event, state);
    } else if (event is GetSearchTextEvent) {
      yield* _mapGetSearchTextEvent(event, state);
    } else if (event is ResetAdvanceSearchValues) {
      yield ResetAdvanceSearchValuesState();
    }
  }

  Stream<SearchBlogsState> _mapRemoveSelectedTagItem(
    SearchBlogsState state,
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

  Stream<SearchBlogsState> _mapSearchAddTagsState() async* {
    try {
      yield LoadingState();
      final ResponseWrapper<List<TagResponse>> tagResponse =
          await catalogService.getBlogsAdvanceSearchAllTags();
      switch (tagResponse.responseType) {
        case ResType.ResponseType.SUCCESS:
          yield GetAdvanceSearchAllTagsSuccess(
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
      yield RemoteClientErrorState();
      return;
    }
  }

  Stream<SearchBlogsState> _mapSubCategoriesToState(
      GetAdvanceSearchSubCategory event) async* {
    try {
      yield LoadingState();
      final ResponseWrapper<List<SubCategoryResponse>> subCategoriesResponse =
          await catalogService.getBlogsSearchSubCategories(
              categoryId: event.categoryId);
      switch (subCategoriesResponse.responseType) {
        case ResType.ResponseType.SUCCESS:
          yield GetAdvanceSearchSubCategorySuccess(
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
      yield RemoteClientErrorState();
      return;
    }
  }

  Stream<SearchBlogsState> _mapCategoriesToState() async* {
    try {
      yield LoadingState();
      final ResponseWrapper<List<CategoryResponse>> categoriesResponse =
          await catalogService.getBlogsSearchMainCategories();
      switch (categoriesResponse.responseType) {
        case ResType.ResponseType.SUCCESS:
          yield GetAdvanceSearchMainCategorySuccess(
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
      yield RemoteClientErrorState();
      return;
    }
  }

  Stream<SearchBlogsState> _mapGetAdvanceSearchValuesEvent(
      GetAdvanceSearchValuesEvent event, SearchBlogsState state) async* {
    if (event.newRequest) {
      state = state.copyWith(
        hasReachedMax: false,
        posts: [],
        status: SearchBlogsStateStatus.initial,
      );
      yield state;
    }
    if (state.hasReachedMax) {
      yield state;
      return;
    }
    try {
      if (state.status == SearchBlogsStateStatus.initial) {
        yield state.copyWith(
          status: SearchBlogsStateStatus.loading,
          posts: state.posts,
          hasReachedMax: state.hasReachedMax,
        );
        final posts = await _fetchAdvanceSearchGroup(event);
        yield state.copyWith(
          status: SearchBlogsStateStatus.success,
          posts: posts,
          hasReachedMax: _hasReachedMax(posts.length),
        );
        return;
      }
      final posts = await _fetchAdvanceSearchGroup(
          event, (state.posts.length / _postLimit).round());
      yield posts.isEmpty
          ? state.copyWith(hasReachedMax: true)
          : state.copyWith(
              status: SearchBlogsStateStatus.success,
              posts: List.of(state.posts)..addAll(posts),
              hasReachedMax: _hasReachedMax(posts.length),
            );
    } catch (e) {
      yield state.copyWith(status: SearchBlogsStateStatus.failure);
      return;
    }
  }

  // ignore: missing_return
  Future<List<GetBlogsResponse>> _fetchAdvanceSearchGroup(
      GetAdvanceSearchValuesEvent event,
      [int startIndex = 0]) async {
    try {
      final response = await catalogService.getBlogsAdvanceSearch(
        accountTypeId: event.accountTypeId,
        categoryId: event.categoryId,
        myFeed: event.myFeed,
        orderByBlogs: event.orderByBlogs,
        pageNumber: startIndex,
        pageSize: _postLimit,
        subCategoryId: event.subCategoryId,
        tagsId: event.tagsId,
        personId: event.personId ?? "",
      );
      switch (response.responseType) {
        case ResType.ResponseType.SUCCESS:
          return response.data;
          break;
        case ResType.ResponseType.VALIDATION_ERROR:
        case ResType.ResponseType.SERVER_ERROR:
        case ResType.ResponseType.CLIENT_ERROR:
        case ResType.ResponseType.NETWORK_ERROR:
      }
      throw Exception('error fetching posts');
    } on Exception catch (_) {}
  }

  Stream<SearchBlogsState> _mapGetSearchTextEvent(
      GetSearchTextEvent event, SearchBlogsState state) async* {
    if (event.newRequest) {
      state = state.copyWith(
        hasReachedMax: false,
        posts: [],
        status: SearchBlogsStateStatus.initial,
      );
      yield state;
    }
    if (state.hasReachedMax) {
      yield state;
      return;
    }
    try {
      if (state.status == SearchBlogsStateStatus.initial) {
        yield state.copyWith(
          status: SearchBlogsStateStatus.loading,
          posts: state.posts,
          hasReachedMax: state.hasReachedMax,
        );
        final posts = await _fetchGetSearchTextEvent(event);
        yield state.copyWith(
          status: SearchBlogsStateStatus.success,
          posts: posts,
          hasReachedMax: _hasReachedMax(posts.length),
        );
        return;
      }
      final posts = await _fetchGetSearchTextEvent(
          event, (state.posts.length / _postLimit).round());
      yield posts.isEmpty
          ? state.copyWith(hasReachedMax: true)
          : state.copyWith(
              status: SearchBlogsStateStatus.success,
              posts: List.of(state.posts)..addAll(posts),
              hasReachedMax: _hasReachedMax(posts.length),
            );
    } catch (e) {
      yield state.copyWith(status: SearchBlogsStateStatus.failure);
      return;
    }
  }

  // ignore: missing_return
  Future<List<GetBlogsResponse>> _fetchGetSearchTextEvent(
      GetSearchTextEvent event,
      [int startIndex = 0]) async {
    try {
      final response = await catalogService.getBlogsTextSearch(
          pageNumber: startIndex, pageSize: _postLimit, query: event.query);
      switch (response.responseType) {
        case ResType.ResponseType.SUCCESS:
          return response.data;
          break;
        case ResType.ResponseType.VALIDATION_ERROR:
        case ResType.ResponseType.SERVER_ERROR:
        case ResType.ResponseType.CLIENT_ERROR:
        case ResType.ResponseType.NETWORK_ERROR:
      }
      throw Exception('error fetching posts');
    } on Exception catch (_) {}
  }

  bool _hasReachedMax(int postsCount) => postsCount < _postLimit ? true : false;
}
