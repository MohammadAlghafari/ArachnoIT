import 'dart:async';

import 'package:arachnoit/common/global_prupose_functions.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:rxdart/rxdart.dart';

import '../../infrastructure/api/response_type.dart' as ResType;
import '../../infrastructure/catalog_facade_service.dart';
import '../../infrastructure/home_blog/response/get_blogs_response.dart';

part 'discover_my_interests_sub_categories_blogs_event.dart';
part 'discover_my_interests_sub_categories_blogs_state.dart';

const _postLimit = 20;

class DiscoverMyInterestsSubCategoriesBlogsBloc extends Bloc<
    DiscoverMyInterestsSubCategoriesBlogsEvent,
    DiscoverMyInterestsSubCategoriesBlogsState> {
  CatalogFacadeService catalogService;

  DiscoverMyInterestsSubCategoriesBlogsBloc({this.catalogService})
      : assert(catalogService != null),
        super(const DiscoverMyInterestsSubCategoriesBlogsState());

  @override
  Stream<
      Transition<DiscoverMyInterestsSubCategoriesBlogsEvent,
          DiscoverMyInterestsSubCategoriesBlogsState>> transformEvents(
    Stream<DiscoverMyInterestsSubCategoriesBlogsEvent> events,
    TransitionFunction<DiscoverMyInterestsSubCategoriesBlogsEvent,
            DiscoverMyInterestsSubCategoriesBlogsState>
        transitionFn,
  ) {
    return super.transformEvents(
      events.debounceTime(const Duration(milliseconds: 500)),
      transitionFn,
    );
  }

  @override
  Stream<DiscoverMyInterestsSubCategoriesBlogsState> mapEventToState(
      DiscoverMyInterestsSubCategoriesBlogsEvent event) async* {
    if (event is DiscoverMyInterestsSubCategoriesBlogsFetched) {
      yield await _mapInterestsSubCategoriesFetchedToState(
          state, event.subCategoryId);
    } else if (event is ReloadDiscoverMyInterestsSubCategoriesBlogsFetched) {
      yield state.copyWith(status: BLogPostStatus.initial,hasReachedMax: false,posts: []);
      yield await _mapInterestsSubCategoriesFetchedToState(
          state, event.subCategoryId);
    }else if (event is DeleteBlog) {
      yield* _mapDeleteBlog(event);
    }
  }

 Stream<DiscoverMyInterestsSubCategoriesBlogsState> _mapDeleteBlog(DeleteBlog event) async* {
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
      GlobalPurposeFunctions.showToast(
          AppLocalizations.of(event.context).check_your_internet_connection,
          event.context);
      GlobalPurposeFunctions.showOrHideProgressDialog(event.context, false);
      yield state;
    }
  }


  Future<DiscoverMyInterestsSubCategoriesBlogsState>
      _mapInterestsSubCategoriesFetchedToState(
          DiscoverMyInterestsSubCategoriesBlogsState state,
          String subCategoryId) async {
    if (state.hasReachedMax) return state;
    try {
      if (state.status == BLogPostStatus.initial) {
        final post = await _fetchInterestsSubCategoriesBlogPosts(subCategoryId);
        return state.copyWith(
          status: BLogPostStatus.success,
          posts: post,
          hasReachedMax: _hasReachedMax(post.length),
        );
      }
      final post = await _fetchInterestsSubCategoriesBlogPosts(
          subCategoryId, (state.posts.length / _postLimit).round());
      if (post.isEmpty) return state.copyWith(hasReachedMax: true);
      return state.copyWith(
        status: BLogPostStatus.success,
        posts: List.of(state.posts)..addAll(post),
        hasReachedMax: _hasReachedMax(post.length),
      );
    } catch (e) {
      return state.copyWith(status: BLogPostStatus.failure);
    }
  }

  // ignore: missing_return
  Future<List<GetBlogsResponse>> _fetchInterestsSubCategoriesBlogPosts(
      String subCategoryId,
      [int startIndex = 0]) async {
    try {
      final response = await catalogService.getMyInterestsSubCategoriesBlogs(
        subCategoryId: subCategoryId,
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
      throw Exception('error fetching posts');
    } on Exception catch (_) {}
  }

  bool _hasReachedMax(int postsCount) => postsCount < _postLimit ? true : false;
}
