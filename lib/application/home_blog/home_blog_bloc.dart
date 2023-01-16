import 'dart:async';

import 'package:arachnoit/common/global_prupose_functions.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:rxdart/rxdart.dart';

import '../../infrastructure/catalog_facade_service.dart';
import '../../infrastructure/home_blog/response/get_blogs_response.dart';
import '../../infrastructure/api/response_type.dart' as ResType;

part 'home_blog_event.dart';

part 'home_blog_state.dart';

const _postLimit = 20;

class HomeBlogBloc extends Bloc<HomeBlogEvent, HomeBlogState> {
  HomeBlogBloc({@required this.catalogService})
      : assert(catalogService != null),
        super(const HomeBlogState());

  final CatalogFacadeService catalogService;

  @override
  Stream<Transition<HomeBlogEvent, HomeBlogState>> transformEvents(
    Stream<HomeBlogEvent> events,
    TransitionFunction<HomeBlogEvent, HomeBlogState> transitionFn,
  ) {
    return super.transformEvents(
      events.debounceTime(const Duration(milliseconds: 500)),
      transitionFn,
    );
  }

  @override
  Stream<HomeBlogState> mapEventToState(
    HomeBlogEvent event,
  ) async* {
    if (event is HomeBlogPostFetched) {
      if (state.status == BLogPostStatus.failure && state.posts.length == 0)
        yield state.copyWith(
          status: BLogPostStatus.initial,
          hasReachedMax: false,
        );
      else if (state.posts.length == 0)
        yield state.copyWith(
          status: BLogPostStatus.initial,
          hasReachedMax: false,
        );
      yield await _mapHomeBlogPostFetchedToState(state, event.userId, event,event.reloadData);
    } else if (event is ReloadHomeBlogPostFetched) {
      yield state.copyWith(
        hasReachedMax: false,
        status: BLogPostStatus.loadingData
      );
      yield await _mapHomeBlogPostFetchedToState(state, event.userId, event,event.reloadData);
    } else if (event is DeleteBlog) {
      yield* _mapDeleteBlog(event);
    }
  }

  Stream<HomeBlogState> _mapDeleteBlog(DeleteBlog event) async* {
    try {
      GlobalPurposeFunctions.showOrHideProgressDialog(event.context, true);
      final posts = await catalogService.deleteBlog(blogID: event.blogId);
      GlobalPurposeFunctions.showOrHideProgressDialog(event.context, false);

      if (posts.data == true) {
        final list = state.posts;
        list.removeAt(event.index);
        yield state.copyWith(posts: list);
      } else {
        yield state;
      }
    } catch (e) {
      GlobalPurposeFunctions.showToast(AppLocalizations.of(event.context).check_your_internet_connection, event.context);
      GlobalPurposeFunctions.showOrHideProgressDialog(event.context, false);
      yield state;
    }
  }

  Future<HomeBlogState> _mapHomeBlogPostFetchedToState(HomeBlogState state, String userId, HomeBlogEvent event,bool isReloadData) async {
    if (state.hasReachedMax&&!isReloadData) return state;
    try {
      if (state.status == BLogPostStatus.initial || event is ReloadHomeBlogPostFetched||isReloadData) {

        final posts = await _fetchBlogPosts(userId);
        return posts.isEmpty
            ? state.copyWith(
                hasReachedMax: true,
                status: BLogPostStatus.success,
            )
            : state.copyWith(
                status: BLogPostStatus.success,
                posts: posts,
                hasReachedMax: _hasReachedMax(posts.length),
              );
      }
      print('not inital');
      final posts = await _fetchBlogPosts(userId, (state.posts.length / _postLimit).round());
      return posts.isEmpty
          ? state.copyWith(hasReachedMax: true)
          : state.copyWith(
              status: BLogPostStatus.success,
              posts: List.of(state.posts)..addAll(posts),
              hasReachedMax: _hasReachedMax(posts.length),
            );
    } catch (e) {
      return state.copyWith(status: BLogPostStatus.failure);
    }
  }

  // ignore: missing_return
  Future<List<GetBlogsResponse>> _fetchBlogPosts(String userId, [int startIndex = 0]) async {
    try {
      final response = await catalogService.getBlogs(
          personId: userId,
          accountTypeId: null,
          blogId: null,
          categoryId: null,
          subCategoryId: null,
          groupId: null,
          myFeed: null,
          tagsId: null,
          query: null,
          isResearcher: null,
          pageNumber: startIndex,
          pageSize: _postLimit,
          orderByBlogs: null,
          mySubscriptionsOnly: null);
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
    } catch (_) {}
  }

  bool _hasReachedMax(int postsCount) => postsCount < _postLimit ? true : false;
}
