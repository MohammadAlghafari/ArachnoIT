import 'dart:async';

import 'package:arachnoit/common/pref_keys.dart';
import 'package:arachnoit/infrastructure/api/response_wrapper.dart';
import 'package:arachnoit/infrastructure/login/response/login_response.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../infrastructure/api/response_type.dart' as ResType;
import 'package:arachnoit/infrastructure/catalog_facade_service.dart';
import 'package:arachnoit/infrastructure/pendding_list_patents/response/patents_response.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';
part 'pending_list_patents_event.dart';
part 'pending_list_patents_state.dart';

const _postLimit = 20;

class PenddingListPatentsBloc extends Bloc<PenddingListPatentsEvent, PenddingListPatentsState> {
  CatalogFacadeService catalogService;
  PenddingListPatentsBloc({@required this.catalogService}) : super(PenddingListPatentsState());
  @override
  Stream<Transition<PenddingListPatentsEvent, PenddingListPatentsState>> transformEvents(
    Stream<PenddingListPatentsEvent> events,
    TransitionFunction<PenddingListPatentsEvent, PenddingListPatentsState> transitionFn,
  ) {
    return super.transformEvents(
      events.debounceTime(const Duration(milliseconds: 200)),
      transitionFn,
    );
  }

  @override
  Stream<PenddingListPatentsState> mapEventToState(PenddingListPatentsEvent event) async* {
    if (event is GetAllPatentsEvent) {
      yield* _mapGetAdvanceSearchValuesEvent(event, state);
    } else if (event is RejectPatentsEvent) {
      yield* _mapRejectPatentsEvent(event, state);
    } else if (event is AcceptPatentsEvent) {
      yield* _mapAcceptPatentsEvent(event, state);
    }
  }

  Stream<PenddingListPatentsState> _mapAcceptPatentsEvent(
      AcceptPatentsEvent event, PenddingListPatentsState state) async* {
    try {
      yield state.copyWith(status: PenddingListPatentsStatus.rejectOrAcceptEventLoading);
      ResponseWrapper<bool> favoriteResponse =
          await catalogService.acceptPatentsInovation(patentsId: event.patentsId);
      if (favoriteResponse.data == true) {
        List<PatentsResponse> items = state.posts;
        items[event.index].requestStatus = 1;
        yield state.copyWith(status: PenddingListPatentsStatus.successAcceptGroup);
        return;
      } else {
        yield state.copyWith(status: PenddingListPatentsStatus.failedRejectOrAccept);
      }
    } on Exception catch (_) {}
  }

  Stream<PenddingListPatentsState> _mapRejectPatentsEvent(
      RejectPatentsEvent event, PenddingListPatentsState state) async* {
    try {
      yield state.copyWith(status: PenddingListPatentsStatus.rejectOrAcceptEventLoading);
      ResponseWrapper<bool> favoriteResponse =
          await catalogService.rejectPatentsInovation(patentsId: event.patentsId);
      if (favoriteResponse.data == true) {
        List<PatentsResponse> items = state.posts;
        items.removeAt(event.index);
        yield state.copyWith(status: PenddingListPatentsStatus.successAcceptGroup);
        return;
      } else {
        yield state.copyWith(
            status: PenddingListPatentsStatus.failedRejectOrAccept,
            erroMessage: favoriteResponse.errorMessage);
      }
    } on Exception catch (_) {}
  }

  Stream<PenddingListPatentsState> _mapGetAdvanceSearchValuesEvent(
      GetAllPatentsEvent event, PenddingListPatentsState state) async* {
    if (state.hasReachedMax && !event.newRequest) {
      yield state;
      return;
    }
    try {
      if (state.status == PenddingListPatentsStatus.initial || event.newRequest) {
        yield state.copyWith(
          status: PenddingListPatentsStatus.loading,
          posts: state.posts,
          hasReachedMax: state.hasReachedMax,
        );
        final posts = await _fetchAllPatents();
        yield state.copyWith(
          status: PenddingListPatentsStatus.success,
          posts: posts,
          hasReachedMax: _hasReachedMax(posts.length),
        );
        return;
      }
      final posts = await _fetchAllPatents((state.posts.length / _postLimit).round());
      yield posts.isEmpty
          ? state.copyWith(hasReachedMax: true)
          : state.copyWith(
              status: PenddingListPatentsStatus.success,
              posts: List.of(state.posts)..addAll(posts),
              hasReachedMax: _hasReachedMax(posts.length),
            );
    } catch (e) {
      yield state.copyWith(status: PenddingListPatentsStatus.failure);
      return;
    }
  }

  Future<List<PatentsResponse>> _fetchAllPatents([int startIndex = 0]) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String loginResponse = prefs.getString(PrefsKeys.LOGIN_RESPONSE);
      LoginResponse responses = LoginResponse.fromJson(loginResponse);
      final response = await catalogService.getAllPatents(
          pageNumber: startIndex, pageSize: _postLimit, healthcareProviderId: responses.userId);
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
    } catch (e) {
      print("The errror is $e");
    }
  }

  bool _hasReachedMax(int postsCount) => postsCount < _postLimit ? true : false;
}
