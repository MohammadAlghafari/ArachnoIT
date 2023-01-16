import 'dart:async';

import 'package:arachnoit/common/global_prupose_functions.dart';
import 'package:arachnoit/infrastructure/home_qaa/response/qaa_response.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import '../../infrastructure/api/response_type.dart' as ResType;

import '../../infrastructure/catalog_facade_service.dart';

part 'home_qaa_event.dart';

part 'home_qaa_state.dart';

const _postLimit = 20;

class HomeQaaBloc extends Bloc<HomeQaaEvent, HomeQaaState> {
  HomeQaaBloc({@required this.catalogService})
      : assert(catalogService != null),
        super(const HomeQaaState());

  final CatalogFacadeService catalogService;

  @override
  Stream<Transition<HomeQaaEvent, HomeQaaState>> transformEvents(
    Stream<HomeQaaEvent> events,
    TransitionFunction<HomeQaaEvent, HomeQaaState> transitionFn,
  ) {
    return super.transformEvents(
      events.debounceTime(const Duration(milliseconds: 500)),
      transitionFn,
    );
  }

  @override
  Stream<HomeQaaState> mapEventToState(
    HomeQaaEvent event,
  ) async* {
    if (event is HomeQaaPostsFetch) {
      if (state.status == QaaPostStatus.failure && state.posts.length == 0)
        yield state.copyWith(
          status: QaaPostStatus.initial,
          hasReachedMax: false,
        );
      else if (state.posts.length == 0)
        yield state.copyWith(
          status: QaaPostStatus.initial,
          hasReachedMax: false,
        );
      yield await _mapHomeQaaPostFetchToState(state, event);
    } else if (event is ReloadHomeQaaPostsFetch) {
      yield state.copyWith(status: QaaPostStatus.initial);
      yield await _mapHomeQaaPostFetchToState(state, event);
    } else if (event is DeleteQuestion) {
      yield* _mapDeleteQuestion(event);
    }
  }

  Stream<HomeQaaState> _mapDeleteQuestion(DeleteQuestion event) async* {
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

  Future<HomeQaaState> _mapHomeQaaPostFetchToState(HomeQaaState state, HomeQaaEvent event) async {
    if (event is ReloadHomeQaaPostsFetch) {
    } else {
      if (state.hasReachedMax) return state;
    }

    try {
      if (state.status == QaaPostStatus.initial || event is ReloadHomeQaaPostsFetch) {
        final posts = await _fetchQaaPosts();

        return posts.isEmpty
            ? state.copyWith(hasReachedMax: true, status: QaaPostStatus.success)
            : state.copyWith(
                status: QaaPostStatus.success,
                posts: posts,
                hasReachedMax: _hasReachedMax(posts.length),
              );
      }
      final posts = await _fetchQaaPosts((state.posts.length / _postLimit).round());
      return posts.isEmpty
          ? state.copyWith(hasReachedMax: true, status: QaaPostStatus.success)
          : state.copyWith(
              status: QaaPostStatus.success,
              posts: List.of(state.posts)..addAll(posts),
              hasReachedMax: _hasReachedMax(posts.length),
            );
    } catch (e) {
      return state.copyWith(status: QaaPostStatus.failure);
    }
  }

  // ignore: missing_return
  Future<List<QaaResponse>> _fetchQaaPosts([int startIndex = 0]) async {
    try {
      final response = await catalogService.getQaas(
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
