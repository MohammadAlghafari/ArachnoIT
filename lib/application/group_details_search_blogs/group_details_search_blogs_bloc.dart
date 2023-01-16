import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

import '../../infrastructure/api/response_type.dart' as ResType;
import '../../infrastructure/catalog_facade_service.dart';
import '../../infrastructure/home_blog/response/get_blogs_response.dart';

part 'group_details_search_blogs_event.dart';
part 'group_details_search_blogs_state.dart';

const _postLimit = 20;

class GroupDetailsSearchBlogsBloc
    extends Bloc<GroupDetailsSearchBlogsEvent, GroupDetailsSearchBlogsState> {
  GroupDetailsSearchBlogsBloc({@required this.catalogService})
      : assert(catalogService != null),
        super(const GroupDetailsSearchBlogsState());

  final CatalogFacadeService catalogService;

  @override
  Stream<Transition<GroupDetailsSearchBlogsEvent, GroupDetailsSearchBlogsState>> transformEvents(
    Stream<GroupDetailsSearchBlogsEvent> events,
    TransitionFunction<GroupDetailsSearchBlogsEvent, GroupDetailsSearchBlogsState> transitionFn,
  ) {
    return super.transformEvents(
      events.debounceTime(const Duration(milliseconds: 500)),
      transitionFn,
    );
  }

  @override
  Stream<GroupDetailsSearchBlogsState> mapEventToState(
    GroupDetailsSearchBlogsEvent event,
  ) async* {
    if (event is SearchTextBlogsFetchEvent) {
      yield* _mapSearchTextBlogsFetchToState(state, event);
    } else if (event is AdvancedSearchBlogsFetchEvent) {
      yield* _mapAdvancedSearchBlogsFetchToState(state, event);
    }
  }

  Stream<GroupDetailsSearchBlogsState> _mapSearchTextBlogsFetchToState(
    GroupDetailsSearchBlogsState state,
    SearchTextBlogsFetchEvent event,
  ) async* {
    if (state.hasReachedMax && !event.newRequest) {
      yield state;
      return;
    }
    try {
      if (state.status == BlogPostStatus.initial || event.newRequest) {
        yield state.copyWith(
          status: BlogPostStatus.loading,
          posts: state.posts,
          hasReachedMax: state.hasReachedMax,
        );
        final posts = await _fetchSearchTextBlogPosts(
          event.groupId,
          event.query,
        );
        yield state.copyWith(
          status: BlogPostStatus.success,
          posts: posts,
          hasReachedMax: _hasReachedMax(posts.length),
        );
        return;
      }
      final posts = await _fetchSearchTextBlogPosts(
          event.groupId, event.query, (state.posts.length / _postLimit).round());
      yield posts.isEmpty
          ? state.copyWith(hasReachedMax: true)
          : state.copyWith(
              status: BlogPostStatus.success,
              posts: List.of(state.posts)..addAll(posts),
              hasReachedMax: _hasReachedMax(posts.length),
            );
    } catch (e) {
      yield state.copyWith(status: BlogPostStatus.failure);
    }
  }

  // ignore: missing_return
  Future<List<GetBlogsResponse>> _fetchSearchTextBlogPosts(String groupId, String query,
      [int startIndex = 0]) async {
    try {
      final response = await catalogService.getSearchTextBlogs(
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

  Stream<GroupDetailsSearchBlogsState> _mapAdvancedSearchBlogsFetchToState(
    GroupDetailsSearchBlogsState state,
    AdvancedSearchBlogsFetchEvent event,
  ) async* {
    if (state.hasReachedMax && !event.newRequest) {
      yield state;
      return;
    }
    try {
      if (state.status == BlogPostStatus.initial || event.newRequest) {
        yield state.copyWith(
          status: BlogPostStatus.loading,
          posts: state.posts,
          hasReachedMax: state.hasReachedMax,
        );
        final posts = await _fetchAdvancedSearchBlogPosts(
            event.groupId, event.categoryId, event.subCategoryId, event.accountType, event.tagsId);
        yield state.copyWith(
          status: BlogPostStatus.success,
          posts: posts,
          hasReachedMax: _hasReachedMax(posts.length),
        );
        return;
      }
      final posts = await _fetchAdvancedSearchBlogPosts(
          event.groupId,
          event.categoryId,
          event.subCategoryId,
          event.accountType,
          event.tagsId,
          (state.posts.length / _postLimit).round());
      yield posts.isEmpty
          ? state.copyWith(hasReachedMax: true)
          : state.copyWith(
              status: BlogPostStatus.success,
              posts: List.of(state.posts)..addAll(posts),
              hasReachedMax: _hasReachedMax(posts.length),
            );
    } catch (e) {
      yield state.copyWith(status: BlogPostStatus.failure);
    }
  }

  // ignore: missing_return
  Future<List<GetBlogsResponse>> _fetchAdvancedSearchBlogPosts(
      String groupId, String categoryId, String subCategoryId, int accountType, List<String> tagsId,
      [int startIndex = 0]) async {
    try {
      final response = await catalogService.getAdvancedSearchBlogs(
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
    } catch (e) {}
  }

  bool _hasReachedMax(int postsCount) => postsCount < _postLimit ? true : false;
}
