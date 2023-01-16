import 'dart:async';

import 'package:arachnoit/common/global_prupose_functions.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../infrastructure/api/response_type.dart' as ResType;
import '../../infrastructure/catalog_facade_service.dart';
import '../../infrastructure/home_blog/response/get_blogs_response.dart';

part 'group_details_blogs_event.dart';

part 'group_details_blogs_state.dart';

const _postLimit = 20;

class GroupDetailsBlogsBloc extends Bloc<GroupDetailsBlogsEvent, GroupDetailsBlogsState> {
  GroupDetailsBlogsBloc({@required this.catalogService})
      : assert(catalogService != null),
        super(const GroupDetailsBlogsState());

  final CatalogFacadeService catalogService;

  @override
  Stream<Transition<GroupDetailsBlogsEvent, GroupDetailsBlogsState>> transformEvents(
    Stream<GroupDetailsBlogsEvent> events,
    TransitionFunction<GroupDetailsBlogsEvent, GroupDetailsBlogsState> transitionFn,
  ) {
    return super.transformEvents(
      events.debounceTime(const Duration(milliseconds: 500)),
      transitionFn,
    );
  }

  @override
  Stream<GroupDetailsBlogsState> mapEventToState(
    GroupDetailsBlogsEvent event,
  ) async* {
    if (event is GroupBlogPostsFetched) {
      yield* _mapGroupBlogPostsFetchedToState(state, event);
    } else if (event is DeleteBlog) {
      yield* _mapDeleteBlog(event);
    }
  }

  Stream<GroupDetailsBlogsState> _mapDeleteBlog(DeleteBlog event) async* {
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

  Stream<GroupDetailsBlogsState> _mapGroupBlogPostsFetchedToState(
      GroupDetailsBlogsState state, GroupBlogPostsFetched event) async* {
    if (state.hasReachedMax && !event.rebuildScreen) {
      yield state;
      return;
    }
    try {
      if (state.status == BLogPostStatus.initial || event.rebuildScreen) {
        yield state.copyWith(status: BLogPostStatus.loading);
        final posts = await _fetchBlogPosts(0, event.groupId);

        yield state.copyWith(
          status: BLogPostStatus.success,
          posts: posts,
          hasReachedMax: _hasReachedMax(posts.length),
        );

        return;
      }
      yield state.copyWith(status: BLogPostStatus.loading);
      final posts = await _fetchBlogPosts((state.posts.length / _postLimit).round(), event.groupId);
      yield posts.length == 0
          ? state.copyWith(
              hasReachedMax: true,
              status: BLogPostStatus.success,
            )
          : state.copyWith(
              status: BLogPostStatus.success,
              posts: List.of(state.posts)..addAll(posts),
              hasReachedMax: _hasReachedMax(posts.length),
            );
      return;
    } catch (_) {
      yield state.copyWith(status: BLogPostStatus.failure);
    }
  }

  // ignore: missing_return
  Future<List<GetBlogsResponse>> _fetchBlogPosts([int startIndex = 0, String groupId]) async {
    try {
      final response = await catalogService.getGroupBlogs(
        groupId: groupId,
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
    } catch (_) {}
  }

  bool _hasReachedMax(int postsCount) => postsCount < _postLimit ? true : false;
}
