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

part 'discover_categories_sub_category_all_questions_event.dart';
part 'discover_categories_sub_category_all_questions_state.dart';

const _postLimit = 20;

class DiscoverCategoriesSubCategoryAllQuestionsBloc extends Bloc<
    DiscoverCategoriesSubCategoryAllQuestionsEvent,
    DiscoverCategoriesSubCategoryAllQuestionsState> {
  DiscoverCategoriesSubCategoryAllQuestionsBloc({@required this.catalogService})
      : assert(catalogService != null),
        super(const DiscoverCategoriesSubCategoryAllQuestionsState());

  final CatalogFacadeService catalogService;

  @override
  Stream<
      Transition<DiscoverCategoriesSubCategoryAllQuestionsEvent,
          DiscoverCategoriesSubCategoryAllQuestionsState>> transformEvents(
    Stream<DiscoverCategoriesSubCategoryAllQuestionsEvent> events,
    TransitionFunction<DiscoverCategoriesSubCategoryAllQuestionsEvent,
            DiscoverCategoriesSubCategoryAllQuestionsState>
        transitionFn,
  ) {
    return super.transformEvents(
      events.debounceTime(const Duration(milliseconds: 500)),
      transitionFn,
    );
  }

  @override
  Stream<DiscoverCategoriesSubCategoryAllQuestionsState> mapEventToState(
    DiscoverCategoriesSubCategoryAllQuestionsEvent event,
  ) async* {
    if (event is SubCategoryAllQuestionsFetchEvent) {
      yield* _mapHomeQaaPostFetchToState(state, event);
    } else if (event is DeleteQuestion) yield* _mapDeleteQuestion(event);
  }

  Stream<DiscoverCategoriesSubCategoryAllQuestionsState> _mapDeleteQuestion(
      DeleteQuestion event) async* {
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

  Stream<DiscoverCategoriesSubCategoryAllQuestionsState> _mapHomeQaaPostFetchToState(
      DiscoverCategoriesSubCategoryAllQuestionsState state,
      SubCategoryAllQuestionsFetchEvent event) async* {
    if (state.hasReachedMax && !event.isUpdateData) {
      yield state;
      return;
    }
    try {
      if (state.status == QaaPostStatus.initial || event.isUpdateData) {
        final posts = await _fetchQaaPosts(0, event.subCategoryId);
        yield state.copyWith(
          status: QaaPostStatus.success,
          posts: posts,
          hasReachedMax: _hasReachedMax(posts.length),
        );
        return;
      }
      yield state.copyWith(status: QaaPostStatus.loading);
      final posts =
          await _fetchQaaPosts((state.posts.length / _postLimit).round(), event.subCategoryId);
      yield posts.isEmpty
          ? state.copyWith(hasReachedMax: true)
          : state.copyWith(
              status: QaaPostStatus.success,
              posts: List.of(state.posts)..addAll(posts),
              hasReachedMax: _hasReachedMax(posts.length),
            );
      return;
    } catch (e) {
      yield state.copyWith(status: QaaPostStatus.failure);
    }
  }

  // ignore: missing_return
  Future<List<QaaResponse>> _fetchQaaPosts([int startIndex = 0, String subCategoryId]) async {
    try {
      final response = await catalogService.getSubCategoryAllQuestions(
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
      throw Exception('error fetching qaas');
    } on Exception catch (_) {}
  }

  bool _hasReachedMax(int postsCount) => postsCount < _postLimit ? true : false;
}
