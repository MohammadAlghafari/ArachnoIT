import 'dart:async';

import 'package:arachnoit/common/global_prupose_functions.dart';
import 'package:arachnoit/infrastructure/catalog_facade_service.dart';
import 'package:arachnoit/infrastructure/home_blog/response/get_blogs_response.dart';
import '../../infrastructure/api/response_type.dart' as ResType;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:rxdart/rxdart.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'discover_categories_sub_category_all_blogs_event.dart';
part 'discover_categories_sub_category_all_blogs_state.dart';

const _postLimit = 20;

class DiscoverCategoriesSubCategoryAllBlogsBloc extends Bloc<
    DiscoverCategoriesSubCategoryAllBlogsEvent, DiscoverCategoriesSubCategoryAllBlogsState> {
  DiscoverCategoriesSubCategoryAllBlogsBloc({@required this.catalogService})
      : assert(catalogService != null),
        super(const DiscoverCategoriesSubCategoryAllBlogsState());

  final CatalogFacadeService catalogService;

  @override
  Stream<
      Transition<DiscoverCategoriesSubCategoryAllBlogsEvent,
          DiscoverCategoriesSubCategoryAllBlogsState>> transformEvents(
    Stream<DiscoverCategoriesSubCategoryAllBlogsEvent> events,
    TransitionFunction<DiscoverCategoriesSubCategoryAllBlogsEvent,
            DiscoverCategoriesSubCategoryAllBlogsState>
        transitionFn,
  ) {
    return super.transformEvents(
      events.debounceTime(const Duration(milliseconds: 500)),
      transitionFn,
    );
  }

  @override
  Stream<DiscoverCategoriesSubCategoryAllBlogsState> mapEventToState(
    DiscoverCategoriesSubCategoryAllBlogsEvent event,
  ) async* {
    if (event is SubCategoryAllBlogPostFetchEvent) {
      yield* _mapSubCategoryAllBlogPostFetchedToState(state, event);
    }
  }

  Stream<DiscoverCategoriesSubCategoryAllBlogsState> _mapDeleteBlog(DeleteBlog event) async* {
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
          AppLocalizations.of(event.context).check_your_internet_connection, event.context);
      GlobalPurposeFunctions.showOrHideProgressDialog(event.context, false);
      yield state;
    }
  }

  Stream<DiscoverCategoriesSubCategoryAllBlogsState> _mapSubCategoryAllBlogPostFetchedToState(
    DiscoverCategoriesSubCategoryAllBlogsState state,
    SubCategoryAllBlogPostFetchEvent event,
  ) async* {
    if (state.hasReachedMax && !event.isReloadData) {
      yield state;
      return;
    }
    try {
      if (state.status == BLogPostStatus.initial || event.isReloadData) {
        if (!event.isReloadData) yield state.copyWith(status: BLogPostStatus.loading);
        final posts = await _fetchBlogPosts(0, event.subCategoryId);
        yield state.copyWith(
          status: BLogPostStatus.success,
          posts: posts,
          hasReachedMax: _hasReachedMax(posts.length),
        );
        return;
      }
      yield state.copyWith(status: BLogPostStatus.loading);
      final posts =
          await _fetchBlogPosts((state.posts.length / _postLimit).round(), event.subCategoryId);
      yield posts.isEmpty
          ? state.copyWith(hasReachedMax: true)
          : state.copyWith(
              status: BLogPostStatus.success,
              posts: List.of(state.posts)..addAll(posts),
              hasReachedMax: _hasReachedMax(posts.length),
            );
      return;
    } catch (e) {
      yield state.copyWith(status: BLogPostStatus.failure);
      return;
    }
  }

  // ignore: missing_return
  Future<List<GetBlogsResponse>> _fetchBlogPosts([int startIndex = 0, String subCategoryId]) async {
    try {
      final response = await catalogService.getSubCategoryAllBlogs(
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
