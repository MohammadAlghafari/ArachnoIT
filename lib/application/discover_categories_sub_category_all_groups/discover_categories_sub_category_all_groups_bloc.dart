import 'dart:async';

import 'package:arachnoit/infrastructure/catalog_facade_service.dart';
import 'package:arachnoit/infrastructure/common_response/group_response.dart';
import '../../infrastructure/api/response_type.dart' as ResType;
import 'package:rxdart/rxdart.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'discover_categories_sub_category_all_groups_event.dart';
part 'discover_categories_sub_category_all_groups_state.dart';

const _groupsLimit = 20;

class DiscoverCategoriesSubCategoryAllGroupsBloc extends Bloc<
    DiscoverCategoriesSubCategoryAllGroupsEvent, DiscoverCategoriesSubCategoryAllGroupsState> {
  DiscoverCategoriesSubCategoryAllGroupsBloc({@required this.catalogService})
      : assert(catalogService != null),
        super(const DiscoverCategoriesSubCategoryAllGroupsState());

  final CatalogFacadeService catalogService;

  @override
  Stream<
      Transition<DiscoverCategoriesSubCategoryAllGroupsEvent,
          DiscoverCategoriesSubCategoryAllGroupsState>> transformEvents(
    Stream<DiscoverCategoriesSubCategoryAllGroupsEvent> events,
    TransitionFunction<DiscoverCategoriesSubCategoryAllGroupsEvent,
            DiscoverCategoriesSubCategoryAllGroupsState>
        transitionFn,
  ) {
    return super.transformEvents(
      events.debounceTime(const Duration(milliseconds: 500)),
      transitionFn,
    );
  }

  @override
  Stream<DiscoverCategoriesSubCategoryAllGroupsState> mapEventToState(
    DiscoverCategoriesSubCategoryAllGroupsEvent event,
  ) async* {
    if (event is SubCategoryGroupsFetchEvent) {
      yield* _mapGroupsFetchToState(state, event);
    }
  }

  Stream<DiscoverCategoriesSubCategoryAllGroupsState> _mapGroupsFetchToState(
      DiscoverCategoriesSubCategoryAllGroupsState state, SubCategoryGroupsFetchEvent event) async* {
    if (state.hasReachedMax && !event.isReloadData) {
      yield state;
      return;
    }
    try {
      if (state.status == GroupsStatus.initial || event.isReloadData) {
        final groups = await _fetchAllGroups(0, event.subCategoryId);
        yield state.copyWith(
          status: GroupsStatus.success,
          allGroups: groups,
          hasReachedMax: _hasReachedMax(groups.length),
        );
        return;
      }
      yield state.copyWith(
        status: GroupsStatus.loading,
      );
      final groups = await _fetchAllGroups(
          (state.allGroups.length / _groupsLimit).round(), event.subCategoryId);
      yield groups.isEmpty
          ? state.copyWith(hasReachedMax: true)
          : state.copyWith(
              status: GroupsStatus.success,
              allGroups: List.of(state.allGroups)..addAll(groups),
              hasReachedMax: _hasReachedMax(groups.length),
            );
      return;
    } catch (e) {
      yield state.copyWith(status: GroupsStatus.failure);
    }
  }

  // ignore: missing_return
  Future<List<GroupResponse>> _fetchAllGroups([int startIndex = 0, String subCategoryId]) async {
    try {
      final groups = await catalogService.getPublicGroups(
        pageNumber: startIndex,
        pageSize: _groupsLimit,
        enablePagination: true,
        searchString: '',
        healthcareProviderId: '',
        approvalListOnly: false,
        ownershipType: 3,
        categoryId: '',
        subCategoryId: subCategoryId,
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
    } on Exception catch (_) {}
  }

  bool _hasReachedMax(int groupsCount) => groupsCount < _groupsLimit ? true : false;
}
