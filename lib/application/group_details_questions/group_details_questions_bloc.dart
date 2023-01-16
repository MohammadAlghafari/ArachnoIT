import 'dart:async';

import 'package:arachnoit/common/global_prupose_functions.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

import '../../infrastructure/api/response_type.dart' as ResType;
import '../../infrastructure/catalog_facade_service.dart';
import '../../infrastructure/home_qaa/response/qaa_response.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

part 'group_details_questions_event.dart';
part 'group_details_questions_state.dart';

const _postLimit = 20;

class GroupDetailsQuestionsBloc
    extends Bloc<GroupDetailsQuestionsEvent, GroupDetailsQuestionsState> {
  GroupDetailsQuestionsBloc({@required this.catalogService})
      : assert(catalogService != null),
        super(const GroupDetailsQuestionsState());

  final CatalogFacadeService catalogService;

  @override
  Stream<Transition<GroupDetailsQuestionsEvent, GroupDetailsQuestionsState>> transformEvents(
    Stream<GroupDetailsQuestionsEvent> events,
    TransitionFunction<GroupDetailsQuestionsEvent, GroupDetailsQuestionsState> transitionFn,
  ) {
    return super.transformEvents(
      events.debounceTime(const Duration(milliseconds: 500)),
      transitionFn,
    );
  }

  @override
  Stream<GroupDetailsQuestionsState> mapEventToState(
    GroupDetailsQuestionsEvent event,
  ) async* {
    if (event is GroupQuestionPostsFetched) {
      yield* _mapGroupQaaPostFetchToState(state, event);
    } else if (event is DeleteQuestion) yield* _mapDeleteQuestion(event);
  }

  Stream<GroupDetailsQuestionsState> _mapDeleteQuestion(DeleteQuestion event) async* {
    try {
      GlobalPurposeFunctions.showOrHideProgressDialog(event.context, true);
      final posts = await catalogService.deleteQuestion(questionId: event.questionId);
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

  Stream<GroupDetailsQuestionsState> _mapGroupQaaPostFetchToState(
      GroupDetailsQuestionsState state, GroupQuestionPostsFetched event) async* {
    if (state.hasReachedMax && !event.refreshData) {
      yield state;
      return;
    }
    try {
      if (state.status == QaaPostStatus.initial || event.refreshData) {
        yield state.copyWith(status: QaaPostStatus.loading);
        final posts = await _fetchQaaPosts(0, event.groupId);
        yield state.copyWith(
          status: QaaPostStatus.success,
          posts: posts,
          hasReachedMax: _hasReachedMax(posts.length),
        );
        return;
      }
      yield state.copyWith(status: QaaPostStatus.loading);
      final posts = await _fetchQaaPosts((state.posts.length / _postLimit).round(), event.groupId);
      yield posts.isEmpty
          ? state.copyWith(hasReachedMax: true)
          : state.copyWith(
              status: QaaPostStatus.success,
              posts: List.of(state.posts)..addAll(posts),
              hasReachedMax: _hasReachedMax(posts.length),
            );
      return;
    } catch (_) {
      yield state.copyWith(status: QaaPostStatus.failure);
    }
  }

  // ignore: missing_return
  Future<List<QaaResponse>> _fetchQaaPosts([int startIndex = 0, String groupId]) async {
    try {
      final response = await catalogService.getGroupQuestions(
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
    } catch (_) {}
  }

  bool _hasReachedMax(int postsCount) => postsCount < _postLimit ? true : false;
}
