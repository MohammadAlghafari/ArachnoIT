import 'dart:async';

import 'package:arachnoit/common/pref_keys.dart';
import 'package:arachnoit/infrastructure/api/response_wrapper.dart';
import 'package:arachnoit/infrastructure/catalog_facade_service.dart';
import 'package:arachnoit/infrastructure/common_response/category_response.dart';
import 'package:arachnoit/infrastructure/common_response/sub_category_response.dart';
import 'package:arachnoit/infrastructure/common_response/group_response.dart';
import 'package:arachnoit/infrastructure/login/response/login_response.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../infrastructure/api/response_type.dart' as ResType;

part 'search_group_event.dart';
part 'search_group_state.dart';

const _postLimit = 20;

class SearchGroupBloc extends Bloc<SearchGroupEvent, SearchGroupState> {
  CatalogFacadeService catalogService;

  SearchGroupBloc({this.catalogService})
      : assert(catalogService != null),
        super(SearchGroupState());

  @override
  Stream<SearchGroupState> mapEventToState(SearchGroupEvent event) async* {
    if (event is GetAdvanceSearchMainCategory) {
      yield* _mapCategoriesToState();
    } else if (event is GetAdvanceSearchSubCategory) {
      yield* _mapSubCategoriesToState(event);
    } else if (event is GetAdvanceSearchValuesEvent) {
      yield* _mapGetAdvanceSearchValuesEvent(event, state);
    } else if (event is GetGroupsSearchTextEvent) {
      yield* _mapGetTextSearchValuesEvent(event, state);
    }else if(event is ResetAdvanceSearchValues){
      yield ResetAdvanceSearchValuesState();
    }
  }

  @override
  Stream<Transition<SearchGroupEvent, SearchGroupState>> transformEvents(
    Stream<SearchGroupEvent> events,
    TransitionFunction<SearchGroupEvent, SearchGroupState> transitionFn,
  ) {
    return super.transformEvents(
      events.debounceTime(const Duration(milliseconds: 200)),
      transitionFn,
    );
  }

  Future<List<GroupResponse>> _fetchAdvanceSearchGroup(
      String categoryId, String subCategoryID,
      [int startIndex = 0]) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String loginResponse = prefs.getString(PrefsKeys.LOGIN_RESPONSE);
      LoginResponse responses = LoginResponse.fromJson(loginResponse);
      final response = await catalogService.getAdvanceSearchGroups(
        categoryId: categoryId,
        subCategoryID: subCategoryID,
        pageNumber: startIndex,
        pageSize: _postLimit,
        userId: responses.userId,
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

  // ignore: missing_return
  Future<List<GroupResponse>> _fetchTextSearchGroup(String searchText,
      [int startIndex = 0]) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String loginResponse = prefs.getString(PrefsKeys.LOGIN_RESPONSE);
      LoginResponse responses = LoginResponse.fromJson(loginResponse);
      final response = await catalogService.getGroupsSearchText(
          searchText: searchText,
          pageNumber: startIndex,
          pageSize: _postLimit,
          userId: responses.userId);
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

  // ignore: missing_return
  Stream<SearchGroupState> _mapCategoriesToState() async* {
    try {
      yield LoadingState();
      final ResponseWrapper<List<CategoryResponse>> categoriesResponse =
          await catalogService.getGroupSearchCategories();
      switch (categoriesResponse.responseType) {
        case ResType.ResponseType.SUCCESS:
          yield GetAdvanceSearchMainCategorySucces(
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

  Stream<SearchGroupState> _mapGetAdvanceSearchValuesEvent(
      GetAdvanceSearchValuesEvent event, SearchGroupState state) async* {
    if (event.newRequest) {
      state = state.copyWith(
        hasReachedMax: false,
        posts: [],
        status: SearchGroupStateStatus.initial,
      );
      yield state;
    }
    if (state.hasReachedMax) {
      yield state;
      return;
    }
    try {
      if (state.status == SearchGroupStateStatus.initial) {
        yield state.copyWith(
          status: SearchGroupStateStatus.loading,
          posts: state.posts,
          hasReachedMax: state.hasReachedMax,
        );
        final posts = await _fetchAdvanceSearchGroup(
            event.categoryId, event.subCategoryID);
        yield state.copyWith(
          status: SearchGroupStateStatus.success,
          posts: posts,
          hasReachedMax: _hasReachedMax(posts.length),
        );
        return;
      }
      final posts = await _fetchAdvanceSearchGroup(event.categoryId,
          event.subCategoryID, (state.posts.length / _postLimit).round());
      yield posts.isEmpty
          ? state.copyWith(hasReachedMax: true)
          : state.copyWith(
              status: SearchGroupStateStatus.success,
              posts: List.of(state.posts)..addAll(posts),
              hasReachedMax: _hasReachedMax(posts.length),
            );
    } catch (e) {
      print("hello inside DioError ee ");
      yield state.copyWith(status: SearchGroupStateStatus.failure);
      return;
    }
  }

  Stream<SearchGroupState> _mapGetTextSearchValuesEvent(
      GetGroupsSearchTextEvent event, SearchGroupState state) async* {
    if (event.newRequest) {
      state = state.copyWith(
        hasReachedMax: false,
        posts: [],
        status: SearchGroupStateStatus.initial,
      );
      yield state;
    }
    if (state.hasReachedMax) {
      yield state;
      return;
    }
    try {
      if (state.status == SearchGroupStateStatus.initial) {
        yield state.copyWith(
          status: SearchGroupStateStatus.loading,
          posts: state.posts,
          hasReachedMax: state.hasReachedMax,
        );
        final posts = await _fetchTextSearchGroup(event.searchText);
        yield state.copyWith(
          status: SearchGroupStateStatus.success,
          posts: posts,
          hasReachedMax: _hasReachedMax(posts.length),
        );
        return;
      }
      final posts = await _fetchTextSearchGroup(
          event.searchText, (state.posts.length / _postLimit).round());
      yield posts.isEmpty
          ? state.copyWith(hasReachedMax: true)
          : state.copyWith(
              status: SearchGroupStateStatus.success,
              posts: List.of(state.posts)..addAll(posts),
              hasReachedMax: _hasReachedMax(posts.length),
            );
    } catch (e) {
      yield state.copyWith(status: SearchGroupStateStatus.failure);
      return;
    }
  }

  Stream<SearchGroupState> _mapSubCategoriesToState(
      GetAdvanceSearchSubCategory event) async* {
    try {
      yield LoadingState();
      final ResponseWrapper<List<SubCategoryResponse>> subCategoriesResponse =
          await catalogService.getGroupSearchSubCategories(
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
}
