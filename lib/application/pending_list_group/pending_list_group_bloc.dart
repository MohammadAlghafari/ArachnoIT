import 'dart:async';
import 'package:arachnoit/common/pref_keys.dart';
import 'package:arachnoit/infrastructure/api/response_wrapper.dart';
import 'package:arachnoit/infrastructure/catalog_facade_service.dart';
import 'package:arachnoit/infrastructure/common_response/group_response.dart';
import 'package:arachnoit/infrastructure/login/response/login_response.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../infrastructure/api/response_type.dart' as ResType;
part 'pending_list_group_event.dart';
part 'pending_list_group_state.dart';

const _postLimit = 20;

class PendingListGroupBloc extends Bloc<PendingListGroupEvent, PendingListGroupState> {
  final CatalogFacadeService catalogService;
  PendingListGroupBloc({this.catalogService})
      : assert(catalogService != null),
        super(PenddingListGroupInitial());

  @override
  Stream<Transition<PendingListGroupEvent, PendingListGroupState>> transformEvents(
    Stream<PendingListGroupEvent> events,
    TransitionFunction<PendingListGroupEvent, PendingListGroupState> transitionFn,
  ) {
    return super.transformEvents(
      events.debounceTime(const Duration(milliseconds: 200)),
      transitionFn,
    );
  }

  @override
  Stream<PendingListGroupState> mapEventToState(PendingListGroupEvent event) async* {
    if (event is GetAllGroups) {
      yield* _mapGetAdvanceSearchValuesEvent(event, state);
    } else if (event is RemoveItemFromGroup) {
      yield* _mapRemoveItemFromGroup(event, state);
    } else if (event is AcceptGroupInovation) {
      yield* _mapAcceptGroupInovation(event, state);
    }
  }

  Stream<PendingListGroupState> _mapAcceptGroupInovation(
      AcceptGroupInovation event, PendingListGroupState state) async* {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String loginResponse = prefs.getString(PrefsKeys.LOGIN_RESPONSE);
      LoginResponse response = LoginResponse.fromJson(loginResponse);
      ResponseWrapper<bool> favoriteResponse = await catalogService.acceptGroupInvitation(
          userId: response.userId, groupId: event.groupId);
      if (favoriteResponse.data == true) {
        List<GroupResponse> items = state.posts;
        items[event.index].requestStatus = 1;
        yield state.copyWith(
            status: PendingListGroupStatus.successAcceptOrLeaveGroup, message: "done");
        return;
      } else {
        yield state.copyWith(
            status: PendingListGroupStatus.failedAcceptOrLeaveGroup, message: "failed");
        return;
      }
    } on Exception catch (_) {}
  }

  Stream<PendingListGroupState> _mapRemoveItemFromGroup(
      RemoveItemFromGroup event, PendingListGroupState state) async* {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String loginResponse = prefs.getString(PrefsKeys.LOGIN_RESPONSE);
      LoginResponse response = LoginResponse.fromJson(loginResponse);
      ResponseWrapper<bool> favoriteResponse = await catalogService.removeFromPenddingGroup(
          userId: response.userId, groupId: event.groupId);
      if (favoriteResponse.data == true) {
        List<GroupResponse> items = state.posts;
        items.removeAt(event.index);
        yield state.copyWith(
            status: PendingListGroupStatus.successAcceptOrLeaveGroup,
            message: "done",
            posts: items);
        return;
      } else {
        yield state.copyWith(
            status: PendingListGroupStatus.failedAcceptOrLeaveGroup, message: "failed");
        return;
      }
    } on Exception catch (_) {}
  }

  Stream<PendingListGroupState> _mapGetAdvanceSearchValuesEvent(
      GetAllGroups event, PendingListGroupState state) async* {
    if (state.hasReachedMax && !event.newRequest) {
      yield state;
      return;
    }
    try {
      if (state.status == PendingListGroupStatus.initial || event.newRequest) {
        yield state.copyWith(
          status: PendingListGroupStatus.loading,
          posts: state.posts,
          hasReachedMax: state.hasReachedMax,
        );
        final posts = await _fetchAllGroup();
        yield state.copyWith(
          status: PendingListGroupStatus.success,
          posts: posts,
          hasReachedMax: _hasReachedMax(posts.length),
        );
        return;
      }
      final posts = await _fetchAllGroup((state.posts.length / _postLimit).round());
      yield posts.isEmpty
          ? state.copyWith(hasReachedMax: true)
          : state.copyWith(
              status: PendingListGroupStatus.success,
              posts: List.of(state.posts)..addAll(posts),
              hasReachedMax: _hasReachedMax(posts.length),
            );
    } catch (e) {
      yield state.copyWith(status: PendingListGroupStatus.failure);
      return;
    }
  }

  Future<List<GroupResponse>> _fetchAllGroup([int startIndex = 0]) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String loginResponse = prefs.getString(PrefsKeys.LOGIN_RESPONSE);
      LoginResponse responses = LoginResponse.fromJson(loginResponse);
      final response = await catalogService.getPenddingListAllGroup(
        pageNumber: startIndex,
        pageSize: _postLimit,
        userId: responses.userId,
      );
      switch (response.responseType) {
        case ResType.ResponseType.SUCCESS:
          // List<GroupResponse> array = [];
          // for (GroupResponse item in response.data)
          //   if (item.requestStatus != 1) array.add(item);
          // response.data = array;
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
