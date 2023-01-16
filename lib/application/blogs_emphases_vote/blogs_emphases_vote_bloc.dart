import 'dart:async';

import 'package:arachnoit/infrastructure/catalog_facade_service.dart';
import 'package:arachnoit/infrastructure/common_response/blogs_vote_respose.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';
import '../../infrastructure/api/response_type.dart' as ResType;
part 'blogs_emphases_vote_event.dart';
part 'blogs_emphases_vote_state.dart';

const _postLimit = 20;

class BlogsEmphasesVoteBloc
    extends Bloc<BlogsEmphasesVoteEvent, BlogsEmphasesVoteState> {
  CatalogFacadeService catalogService;
  BlogsEmphasesVoteBloc({this.catalogService})
      : super(BlogsEmphasesVoteState());
  @override
  Stream<Transition<BlogsEmphasesVoteEvent, BlogsEmphasesVoteState>>
      transformEvents(
    Stream<BlogsEmphasesVoteEvent> events,
    TransitionFunction<BlogsEmphasesVoteEvent, BlogsEmphasesVoteState>
        transitionFn,
  ) {
    return super.transformEvents(
      events.debounceTime(const Duration(milliseconds: 500)),
      transitionFn,
    );
  }

  @override
  Stream<BlogsEmphasesVoteState> mapEventToState(
      BlogsEmphasesVoteEvent event) async* {
    if (event is GetUsefulBlogsVote) {
      yield* _mapGetAdvanceSearchValuesEvent(event, state);
    }
  }

  Stream<BlogsEmphasesVoteState> _mapGetAdvanceSearchValuesEvent(
      GetUsefulBlogsVote event, BlogsEmphasesVoteState state) async* {
    if (event.newRequest) {
      state = state.copyWith(
        hasReachedMax: false,
        votes: [],
        status: BlogsEmphasesVoteStatus.initial,
      );
      yield state;
    }
    if (state.hasReachedMax) {
      yield state;
      return;
    }
    try {
      if (state.status == BlogsEmphasesVoteStatus.initial) {
        yield state.copyWith(
          status: BlogsEmphasesVoteStatus.loading,
          votes: state.votes,
          hasReachedMax: state.hasReachedMax,
        );
        List<BlogsVoteResponse> posts = await _fetchAdvanceSearchGroup(event);
        yield state.copyWith(
          status: BlogsEmphasesVoteStatus.success,
          votes: posts,
          hasReachedMax: _hasReachedMax(posts.length),
        );
        return;
      }
      final posts = await _fetchAdvanceSearchGroup(
          event, (state.votes.length / _postLimit).round());
      yield posts.isEmpty
          ? state.copyWith(hasReachedMax: true)
          : state.copyWith(
              status: BlogsEmphasesVoteStatus.success,
              votes: List.of(state.votes)..addAll(posts),
              hasReachedMax: _hasReachedMax(posts.length),
            );
    } catch (e) {
      yield state.copyWith(status: BlogsEmphasesVoteStatus.failure);
      return;
    }
  }

  //ignore: missing_return
  Future<List<BlogsVoteResponse>> _fetchAdvanceSearchGroup(
      GetUsefulBlogsVote event,
      [int startIndex = 0]) async {
    try {
      final response = await catalogService.getPostsVotes(
          pageNumber: startIndex,
          pageSize: _postLimit,
          itemId: event.itemId,
          voteType: event.voteType,
          itemType: event.itemType);
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
