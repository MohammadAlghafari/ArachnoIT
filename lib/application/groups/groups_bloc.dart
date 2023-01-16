import 'dart:async';

import 'package:arachnoit/common/pref_keys.dart';
import 'package:arachnoit/infrastructure/api/response_type.dart';
import 'package:arachnoit/infrastructure/api/response_wrapper.dart';
import 'package:arachnoit/infrastructure/common_response/file_response.dart';
import 'package:arachnoit/infrastructure/group_details/response/group_details_response.dart';
import 'package:arachnoit/infrastructure/login/response/login_response.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../infrastructure/api/response_type.dart' as ResType;
import '../../infrastructure/catalog_facade_service.dart';
import '../../infrastructure/common_response/group_response.dart';

part 'groups_event.dart';

part 'groups_state.dart';

const _groupsLimit = 20;

class GroupsBloc extends Bloc<GroupsEvent, GroupsState> {
  GroupsBloc({@required this.catalogService})
      : assert(catalogService != null),
        super(const GroupsState());

  final CatalogFacadeService catalogService;

  @override
  Stream<Transition<GroupsEvent, GroupsState>> transformEvents(
    Stream<GroupsEvent> events,
    TransitionFunction<GroupsEvent, GroupsState> transitionFn,
  ) {
    return super.transformEvents(
      events.debounceTime(const Duration(milliseconds: 500)),
      transitionFn,
    );
  }

  @override
  Stream<GroupsState> mapEventToState(
    GroupsEvent event,
  ) async* {
    if (event is PublicAndMyGroupsFetchEvent) {
      yield* _mapPublicAndMyGroupsFetchedToState(event, state);
    } else if (event is RefreshPublicAndMyGroupsFetchEvent) {
      yield* _mapPublicAndMyGroupsFetchedToState(event, state);
    } else if (event is MyGroupsFetchEvent) {
      yield await _mapMyGroupsFetchedToState(state);
    } else if (event is DeleteGroupAndRefreshed)
      yield await refreshedAfterDelete(event, state);
    else if (event is AddGroupAndRefreshed)
      yield* mapPublicAndMyGroupsRefreshedFetchedToState(state);
    else if (event is UpdateGroupAndRefreshed) yield* refreshedAfterUpdateGroup(event, state);
  }

  Stream<GroupsState> refreshedAfterUpdateGroup(
      UpdateGroupAndRefreshed event, GroupsState state) async* {
//    state.myGroups[state.myGroups.indexWhere((element) => element.id==event.groupDetailsResponse.id)]=
    GroupResponse groupResponse = new GroupResponse(
      membersCount: event.groupDetailsResponse.membersCount,
      privacyLevel: event.groupDetailsResponse.privacyLevel,
      name: event.groupDetailsResponse.name,
      description: event.groupDetailsResponse.description,
      groupId: event.groupDetailsResponse.groupId,
      image: event.groupDetailsResponse.image,
      requestStatus: event.groupDetailsResponse.requestStatus,
      owner: event.groupDetailsResponse.owner,
      loginUserGroupPermissions: event.groupDetailsResponse.loginUserGroupPermissions,
      parentGroup: event.groupDetailsResponse.parentGroup,
      id: event.groupDetailsResponse.id,
      blogsCount: event.groupDetailsResponse.blogsCount,
      category: event.groupDetailsResponse.category,
      isValid: event.groupDetailsResponse.isValid,
      ownerId: event.groupDetailsResponse.ownerId,
      questionsCount: event.groupDetailsResponse.questionsCount,
      subCategories: event.groupDetailsResponse.subCategories,
      researchesCount: event.groupDetailsResponse.researchesCount,
    );

    state.myGroups[state.myGroups
        .indexWhere((element) => element.id == event.groupDetailsResponse.id)] = groupResponse;
    if (state.publicGroups.indexWhere((element) => element.id == event.groupDetailsResponse.id) !=
        -1)
      state.publicGroups[state.publicGroups
          .indexWhere((element) => element.id == event.groupDetailsResponse.id)] = groupResponse;
    var newMyGroups = state.myGroups;
    var publicGroups = state.publicGroups;
    yield state.copyWith(myGroups: newMyGroups, publicGroups: publicGroups);
  }

  Stream<GroupsState> mapPublicAndMyGroupsRefreshedFetchedToState(GroupsState state) async* {
    yield state.copyWith(groupsRefreshStatus: RequestState.loadingData);
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String loginResponse = prefs.getString(PrefsKeys.LOGIN_RESPONSE);
      LoginResponse response = LoginResponse.fromJson(loginResponse);
      final ResponseWrapper<List<dynamic>> publicAndMyGroupsResponse =
          await catalogService.getPublicAndMyGroups(
        publicPageNumber: 0,
        publicPageSize: _groupsLimit,
        publicEnablePagination: false,
        publicSearchString: '',
        publicHealthcareProviderId: '',
        publicApprovalListOnly: false,
        publicOwnershipType: 3,
        publicCategoryId: '',
        publicSubCategoryId: '',
        publicMySubscriptionsOnly: false,
        myPageNumber: 0,
        myPageSize: _groupsLimit,
        myEnablePagination: true,
        mySearchString: '',
        myHealthcareProviderId: response.userId,
        myApprovalListOnly: false,
        myOwnershipType: 0,
        myCategoryId: '',
        mySubCategoryId: '',
        myMySubscriptionsOnly: true,
      );
      switch (publicAndMyGroupsResponse.responseType) {
        case ResType.ResponseType.SUCCESS:
          List<GroupResponse> publicGroups = publicAndMyGroupsResponse.data[0];
          List<GroupResponse> myGroups = publicAndMyGroupsResponse.data[1];
          yield state.copyWith(
            groupsRefreshStatus: RequestState.success,
            status: GroupsStatus.success,
            publicGroups: publicGroups,
            myGroups: myGroups,
            hasReachedMax: _hasReachedMax(myGroups.length),
          );
          break;
        case ResType.ResponseType.VALIDATION_ERROR:
          yield state.copyWith(groupsRefreshStatus: RequestState.failureValidation);
          break;
        case ResType.ResponseType.SERVER_ERROR:
          yield state.copyWith(groupsRefreshStatus: RequestState.serverError);
          break;
        case ResType.ResponseType.CLIENT_ERROR:
          yield state.copyWith(groupsRefreshStatus: RequestState.networkError);
          break;
        case ResType.ResponseType.NETWORK_ERROR:
          throw Exception("Error on server");
      }
    } catch (e) {
      yield state.copyWith(
        groupsRefreshStatus: RequestState.networkError,
      );
    }
  }

  Future<GroupsState> refreshedAfterDelete(DeleteGroupAndRefreshed event, GroupsState state) async {
    state.myGroups.removeWhere((element) => element.id == event.groupId);
    state.publicGroups.removeWhere((element) => element.id == event.groupId);
    var newMyGroups = state.myGroups;
    var publicGroups = state.publicGroups;
    return state.copyWith(myGroups: newMyGroups, publicGroups: publicGroups);
  }

  Stream<GroupsState> _mapPublicAndMyGroupsFetchedToState(
      GroupsEvent event, GroupsState state) async* {
    if (event is RefreshPublicAndMyGroupsFetchEvent)
      yield state;
    else
      yield state.copyWith(status: GroupsStatus.initial);
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String loginResponse = prefs.getString(PrefsKeys.LOGIN_RESPONSE);
      LoginResponse response = LoginResponse.fromJson(loginResponse);
      final ResponseWrapper<List<dynamic>> publicAndMyGroupsResponse =
          await catalogService.getPublicAndMyGroups(
        publicPageNumber: 0,
        publicPageSize: _groupsLimit,
        publicEnablePagination: false,
        publicSearchString: '',
        publicHealthcareProviderId: '',
        publicApprovalListOnly: false,
        publicOwnershipType: 3,
        publicCategoryId: '',
        publicSubCategoryId: '',
        publicMySubscriptionsOnly: false,
        myPageNumber: 0,
        myPageSize: _groupsLimit,
        myEnablePagination: true,
        mySearchString: '',
        myHealthcareProviderId: response.userId,
        myApprovalListOnly: false,
        myOwnershipType: 0,
        myCategoryId: '',
        mySubCategoryId: '',
        myMySubscriptionsOnly: true,
      );
      switch (publicAndMyGroupsResponse.responseType) {
        case ResType.ResponseType.SUCCESS:
          List<GroupResponse> publicGroups = publicAndMyGroupsResponse.data[0];
          List<GroupResponse> myGroups = publicAndMyGroupsResponse.data[1];
          if (event is RefreshPublicAndMyGroupsFetchEvent)
            yield state.copyWith(
              groupsRefreshStatus: RequestState.success,
              publicGroups: publicGroups,
              myGroups: myGroups,
              hasReachedMax: _hasReachedMax(myGroups.length),
            );
          else
            yield state.copyWith(
              status: GroupsStatus.success,
              publicGroups: publicGroups,
              myGroups: myGroups,
              hasReachedMax: _hasReachedMax(myGroups.length),
            );
          break;
        case ResType.ResponseType.VALIDATION_ERROR:
          yield state.copyWith(
            groupsRefreshStatus: RequestState.failureValidation,
          );
          break;
        case ResType.ResponseType.SERVER_ERROR:
          yield state.copyWith(
            groupsRefreshStatus: RequestState.serverError,
          );
          break;
        case ResType.ResponseType.CLIENT_ERROR:
          yield state.copyWith(
            groupsRefreshStatus: RequestState.networkError,
          );
          break;
        case ResType.ResponseType.NETWORK_ERROR:
          yield state.copyWith(groupsRefreshStatus: RequestState.networkError);
          break;
          throw Exception("Error on server");
      }
    } catch (e) {
      if (event is RefreshPublicAndMyGroupsFetchEvent) {
        print('refresh_catch');
        yield state.copyWith(
          groupsRefreshStatus: RequestState.failureValidation,
        );
      } else
        yield state.copyWith(
          status: GroupsStatus.failure,
        );
    }
  }

  Future<GroupsState> _mapMyGroupsFetchedToState(GroupsState state) async {
    if (state.hasReachedMax) return state;
    try {
      final myGroups = await _fetchMyGroups((state.myGroups.length / _groupsLimit).round());
      return myGroups.isEmpty
          ? state.copyWith(hasReachedMax: true)
          : state.copyWith(
              status: GroupsStatus.success,
              myGroups: List.of(state.myGroups)..addAll(myGroups),
              publicGroups: state.publicGroups,
              hasReachedMax: _hasReachedMax(myGroups.length),
            );
    } on Exception catch (_) {
      return state.copyWith(status: GroupsStatus.failure);
    }
  }

  // ignore: missing_return
  Future<List<GroupResponse>> _fetchMyGroups([int startIndex]) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String loginResponse = prefs.getString(PrefsKeys.LOGIN_RESPONSE);
      LoginResponse response = LoginResponse.fromJson(loginResponse);
      final groups = await catalogService.getMyGroups(
        pageNumber: startIndex,
        pageSize: _groupsLimit,
        enablePagination: true,
        searchString: '',
        healthcareProviderId: response.userId,
        approvalListOnly: false,
        ownershipType: 0,
        categoryId: '',
        subCategoryId: '',
        mySubscriptionsOnly: true,
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
