import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../common/pref_keys.dart';
import '../../infrastructure/api/response_type.dart' as ResType;
import '../../infrastructure/catalog_facade_service.dart';
import '../../infrastructure/common_response/group_response.dart';
import '../../infrastructure/login/response/login_response.dart';

part 'all_groups_event.dart';
part 'all_groups_state.dart';

const _groupsLimit = 20;

class AllGroupsBloc extends Bloc<AllGroupsEvent, AllGroupsState> {
  AllGroupsBloc({@required this.catalogService})
      : assert(catalogService != null),
        super(const AllGroupsState());

  final CatalogFacadeService catalogService;

  @override
  Stream<Transition<AllGroupsEvent, AllGroupsState>> transformEvents(
    Stream<AllGroupsEvent> events,
    TransitionFunction<AllGroupsEvent, AllGroupsState> transitionFn,
  ) {
    return super.transformEvents(
      events.debounceTime(const Duration(milliseconds: 500)),
      transitionFn,
    );
  }

  @override
  Stream<AllGroupsState> mapEventToState(
    AllGroupsEvent event,
  ) async* {
    if (event is AllGroupsFetchEvent) {
      yield* _mapAllGroupsFetchToState(state, event);
    }
  }

  Stream<AllGroupsState> _mapAllGroupsFetchToState(
      AllGroupsState state, AllGroupsFetchEvent event) async* {
    if (event.reloadDataFromFirst) {
      state = AllGroupsState();
      yield state;
    }
    if (state.hasReachedMax) {
      yield state;
      return;
    }
    try {
      if (state.status == AllGroupsStatus.initial) {
        final groups = await _fetchAllGroups();
        yield state.copyWith(
          status: AllGroupsStatus.success,
          allGroups: groups,
          hasReachedMax: _hasReachedMax(groups.length),
        );
        return;
      }
      final groups = await _fetchAllGroups(
          (state.allGroups.length / _groupsLimit).round());
      yield groups.isEmpty
          ? state.copyWith(hasReachedMax: true)
          : state.copyWith(
              status: AllGroupsStatus.success,
              allGroups: List.of(state.allGroups)..addAll(groups),
              hasReachedMax: _hasReachedMax(groups.length),
            );
      return;
    } catch (e) {
      yield state.copyWith(status: AllGroupsStatus.failure);
      return;
    }
  }

  // ignore: missing_return
  Future<List<GroupResponse>> _fetchAllGroups([int startIndex = 0]) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String loginResponse = prefs.getString(PrefsKeys.LOGIN_RESPONSE);
      LoginResponse response = LoginResponse.fromJson(loginResponse);
      final groups = await catalogService.getPublicGroups(
        pageNumber: startIndex,
        pageSize: _groupsLimit,
        enablePagination: true,
        searchString: '',
        healthcareProviderId: response.userId,
        approvalListOnly: false,
        ownershipType: 0,
        categoryId: '',
        subCategoryId: '',
        mySubscriptionsOnly: false,
      );
      switch (groups.responseType) {
        case ResType.ResponseType.SUCCESS:
          return groups.data;
          break;
        case ResType.ResponseType.VALIDATION_ERROR:
        case ResType.ResponseType.SERVER_ERROR:
        case ResType.ResponseType.CLIENT_ERROR:
        case ResType.ResponseType.NETWORK_ERROR:
      }
      throw Exception('error fetching groups');
    } catch (_) {}
  }

  bool _hasReachedMax(int groupsCount) =>
      groupsCount < _groupsLimit ? true : false;
}
