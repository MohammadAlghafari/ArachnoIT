import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

import '../../infrastructure/api/response_type.dart' as ResType;
import '../../infrastructure/catalog_facade_service.dart';
import '../../infrastructure/home_qaa/response/qaa_response.dart';

part 'group_details_search_questions_event.dart';
part 'group_details_search_questions_state.dart';

const _postLimit = 20;

class GroupDetailsSearchQuestionsBloc
    extends Bloc<GroupDetailsSearchQuestionsEvent, GroupDetailsSearchQuestionsState> {
  GroupDetailsSearchQuestionsBloc({@required this.catalogService})
      : assert(catalogService != null),
        super(const GroupDetailsSearchQuestionsState());

  final CatalogFacadeService catalogService;

  @override
  Stream<Transition<GroupDetailsSearchQuestionsEvent, GroupDetailsSearchQuestionsState>>
      transformEvents(
    Stream<GroupDetailsSearchQuestionsEvent> events,
    TransitionFunction<GroupDetailsSearchQuestionsEvent, GroupDetailsSearchQuestionsState>
        transitionFn,
  ) {
    return super.transformEvents(
      events.debounceTime(const Duration(milliseconds: 500)),
      transitionFn,
    );
  }

  @override
  Stream<GroupDetailsSearchQuestionsState> mapEventToState(
    GroupDetailsSearchQuestionsEvent event,
  ) async* {
    if (event is SearchTextQuestionsFetchEvent) {
      yield* _mapSearchTextBlogsFetchToState(state, event);
    } else if (event is AdvancedSearchQuestionsFetchEvent) {
      yield* _mapAdvancedSearchQuestionsFetchToState(state, event);
    }
  }

  Stream<GroupDetailsSearchQuestionsState> _mapSearchTextBlogsFetchToState(
      GroupDetailsSearchQuestionsState state, SearchTextQuestionsFetchEvent event) async* {
    if (state.hasReachedMax && !event.newRequest) {
      yield state;
      return;
    }
    try {
      if (state.status == QaaPostStatus.initial || event.newRequest) {
        yield state.copyWith(
          status: QaaPostStatus.loading,
          posts: state.posts,
          hasReachedMax: state.hasReachedMax,
        );

        final posts = await _fetchTextSearchQaaPosts(
          event.groupId,
          event.query,
        );
        yield state.copyWith(
          status: QaaPostStatus.success,
          posts: posts,
          hasReachedMax: _hasReachedMax(posts.length),
        );
        return;
      }
      final posts = await _fetchTextSearchQaaPosts(
          event.groupId, event.query, (state.posts.length / _postLimit).round());
      yield posts.isEmpty
          ? state.copyWith(hasReachedMax: true)
          : state.copyWith(
              status: QaaPostStatus.success,
              posts: List.of(state.posts)..addAll(posts),
              hasReachedMax: _hasReachedMax(posts.length),
            );
    } catch (_) {
      yield state.copyWith(status: QaaPostStatus.failure);
    }
  }

  // ignore: missing_return
  Future<List<QaaResponse>> _fetchTextSearchQaaPosts(String groupId, String query,
      [int startIndex = 0]) async {
    try {
      final response = await catalogService.getSearchTextQuestions(
        groupId: groupId,
        query: query,
        pageNumber: startIndex,
        pageSize: _postLimit,
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
    } catch (_) {}
  }

  Stream<GroupDetailsSearchQuestionsState> _mapAdvancedSearchQuestionsFetchToState(
      GroupDetailsSearchQuestionsState state, AdvancedSearchQuestionsFetchEvent event) async* {
    if (state.hasReachedMax && !event.newRequest) {
      yield state;
      return;
    }
    try {
      if (state.status == QaaPostStatus.initial || event.newRequest) {
        yield state.copyWith(
          status: QaaPostStatus.loading,
          posts: state.posts,
          hasReachedMax: state.hasReachedMax,
        );

        final posts = await _fetchAdvancedSearchQaaPosts(
            event.groupId, event.categoryId, event.subCategoryId, event.accountType, event.tagsId);
        yield state.copyWith(
          status: QaaPostStatus.success,
          posts: posts,
          hasReachedMax: _hasReachedMax(posts.length),
        );
        return;
      }
      final posts = await _fetchAdvancedSearchQaaPosts(
          event.groupId,
          event.categoryId,
          event.subCategoryId,
          event.accountType,
          event.tagsId,
          (state.posts.length / _postLimit).round());
      yield posts.isEmpty
          ? state.copyWith(hasReachedMax: true)
          : state.copyWith(
              status: QaaPostStatus.success,
              posts: List.of(state.posts)..addAll(posts),
              hasReachedMax: _hasReachedMax(posts.length),
            );
    } catch (_) {
      yield state.copyWith(status: QaaPostStatus.failure);
    }
  }

  // ignore: missing_return
  Future<List<QaaResponse>> _fetchAdvancedSearchQaaPosts(
      String groupId, String categoryId, String subCategoryId, int accountType, List<String> tagsId,
      [int startIndex = 0]) async {
    try {
      final response = await catalogService.getAdvancedSearchQuestions(
        groupId: groupId,
        categoryId: categoryId,
        subCategoryId: subCategoryId,
        accountTypeId: accountType,
        tagsId: tagsId,
        pageNumber: startIndex,
        pageSize: _postLimit,
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
    } catch (_) {}
  }

  bool _hasReachedMax(int postsCount) => postsCount < _postLimit ? true : false;
}
