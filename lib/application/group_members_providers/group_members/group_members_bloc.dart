import 'dart:async';

import 'package:arachnoit/infrastructure/api/response_wrapper.dart';
import 'package:arachnoit/infrastructure/api/response_type.dart' as ResType;
import 'package:arachnoit/infrastructure/catalog_facade_service.dart';
import 'package:arachnoit/infrastructure/group_members_providers/group_members/response/get_group_members_response.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

part 'group_members_event.dart';

part 'group_members_state.dart';

const _MembersLimit = 20;

class GroupMembersBloc extends Bloc<GroupMembersEvent, GroupMembersState> {
  CatalogFacadeService catalogFacadeService;

  GroupMembersBloc({@required this.catalogFacadeService}) : super(GroupMembersState());

  @override
  Stream<Transition<GroupMembersEvent, GroupMembersState>> transformEvents(
      Stream<GroupMembersEvent> events, TransitionFunction<GroupMembersEvent, GroupMembersState> transitionFn) {
    return super.transformEvents(
      events.debounceTime(const Duration(milliseconds: 500)),
      transitionFn,
    );
  }

  @override
  Stream<GroupMembersState> mapEventToState(
    GroupMembersEvent event,
  ) async* {
    if (event is GetGroupMembers) {
     // yield state.copyWith(removeStatus: RemoveMembersFromGroupStatus.initial);
      yield* fetchGroupMembers(event.groupId, state);
    } else if (event is ReloadGetGroupMembers) {
      yield reloadMembersAfterInviteMembers(event.membersResponse, state);
    } else if (event is RemoveMemberFromGroup)
      yield* removeMemberFromGroup(event.groupId, event.memberId, state);
    else if (event is RefreshMemberGroupGetData)
      yield* refreshGroupMembers(event.groupId, state);
    else if (event is SubmittedSearchGroupMember) yield* searchGroupMembers(event.groupId, event.query, state);
  }


  Stream<GroupMembersState> searchGroupMembers(String groupId, String query, GroupMembersState state) async* {
    yield state.copyWith(status: GroupMembersStatus.loadingData);
    try {
      final ResponseWrapper<List<GetGroupMembersResponse>> response = await catalogFacadeService.getGroupMembers(
          idGroup: groupId,
          includeHealthcareProvidersOnly: false,
          query: query,
          enablePagination: true,
          pageNumber: 0,
          pageSize: _MembersLimit,
          getNonGroupMembersOnly: false);
      switch (response.responseType) {
        case ResType.ResponseType.SUCCESS:
          yield response.data.isEmpty
              ? state.copyWith(hasReachedMax: false)
              : state.copyWith(
                  status: GroupMembersStatus.success,
                  removeStatus: RemoveMembersFromGroupStatus.initial,
                  members: response.data,
                  hasReachedMax: _hasReachedMax(response.data.length),
                );
          break;
        case ResType.ResponseType.VALIDATION_ERROR:
          yield state.copyWith(status: GroupMembersStatus.failureValidation);
          break;
        case ResType.ResponseType.SERVER_ERROR:
          yield state.copyWith(status: GroupMembersStatus.serverError);
          break;
        case ResType.ResponseType.CLIENT_ERROR:
          yield state.copyWith(status: GroupMembersStatus.networkError);
          break;
        case ResType.ResponseType.NETWORK_ERROR:
          yield state.copyWith(status: GroupMembersStatus.networkError);
          break;
      }
    } catch (e) {
      yield  state.copyWith(status: GroupMembersStatus.networkError);
    }
  }

  GroupMembersState reloadMembersAfterInviteMembers(GetGroupMembersResponse member, GroupMembersState state) {
    state.members.add(member);
    print(state.members);
    return state.copyWith(members: state.members);
  }

  Stream<GroupMembersState> refreshGroupMembers(String groupId, GroupMembersState state) async* {
    try {
      print(state.hasReachedMax);
      final ResponseWrapper<List<GetGroupMembersResponse>> response = await catalogFacadeService.getGroupMembers(
          idGroup: groupId,
          includeHealthcareProvidersOnly: false,
          query: null,
          enablePagination: true,
          pageNumber: 0,
          pageSize: _MembersLimit,
          getNonGroupMembersOnly: false);
      switch (response.responseType) {
        case ResType.ResponseType.SUCCESS:
          yield response.data.isEmpty
              ? state.copyWith(
              noMembersYet: true,
              hasReachedMax: true,
              refreshMembersGroupStatus: RefreshMembersGroupStatus.success
          )
              : state.copyWith(
                  status: GroupMembersStatus.success,
                  removeStatus: RemoveMembersFromGroupStatus.initial,
                  members: response.data,
                  noMembersYet: false,
                  hasReachedMax: _hasReachedMax(response.data.length),
                  refreshMembersGroupStatus: RefreshMembersGroupStatus.success);
          break;
        case ResType.ResponseType.VALIDATION_ERROR:
          yield state.copyWith(refreshMembersGroupStatus: RefreshMembersGroupStatus.failureValidation);
          break;
        case ResType.ResponseType.SERVER_ERROR:
          yield state.copyWith(refreshMembersGroupStatus: RefreshMembersGroupStatus.serverError);
          break;
        case ResType.ResponseType.CLIENT_ERROR:
          yield state.copyWith(refreshMembersGroupStatus: RefreshMembersGroupStatus.networkError);
          break;
        case ResType.ResponseType.NETWORK_ERROR:
          yield state.copyWith(refreshMembersGroupStatus: RefreshMembersGroupStatus.networkError);
          break;
      }
    } catch (e) {
      print('timeOut');
      yield state.copyWith(refreshMembersGroupStatus: RefreshMembersGroupStatus.networkError);
    }
  }

  Stream<GroupMembersState> fetchGroupMembers(String groupId, GroupMembersState state) async* {
    if (state.hasReachedMax && state.members.length!=0){
      yield state;
    }else{
      try {
        print( state.members.length);
        if (state.status == GroupMembersStatus.initial ||
            state.status == GroupMembersStatus.serverError ||
            state.status == GroupMembersStatus.networkError ||
            state.status == GroupMembersStatus.failureValidation|| state.members.length==0) {
          yield state.copyWith(status: GroupMembersStatus.loadingData);
          try {
            final ResponseWrapper<List<GetGroupMembersResponse>> response = await catalogFacadeService.getGroupMembers(
                idGroup: groupId,
                includeHealthcareProvidersOnly: false,
                query: null,
                enablePagination: true,
                pageNumber: 0,
                pageSize: _MembersLimit,
                getNonGroupMembersOnly: false);

            switch (response.responseType) {
              case ResType.ResponseType.SUCCESS:
                yield response.data.length==0
                    ? state.copyWith(hasReachedMax: true,status:GroupMembersStatus.success,noMembersYet: true)
                    : state.copyWith(status: GroupMembersStatus.success,noMembersYet: false, members: response.data, hasReachedMax: _hasReachedMax(response.data.length));
                break;
              case ResType.ResponseType.VALIDATION_ERROR:
                yield state.copyWith(status: GroupMembersStatus.failureValidation);
                break;
              case ResType.ResponseType.SERVER_ERROR:
                yield state.copyWith(status: GroupMembersStatus.serverError);
                break;
              case ResType.ResponseType.CLIENT_ERROR:
                yield state.copyWith(status: GroupMembersStatus.networkError);
                break;
              case ResType.ResponseType.NETWORK_ERROR:
                yield state.copyWith(status: GroupMembersStatus.networkError);
                break;
            }
          } catch (e) {
            print('error to fetch members');
          }
        } else {
          try {

            final ResponseWrapper<List<GetGroupMembersResponse>> response = await catalogFacadeService.getGroupMembers(
                idGroup: groupId,
                includeHealthcareProvidersOnly: true,
                query: null,
                enablePagination: true,
                pageNumber: (state.members.length / _MembersLimit).round(),
                pageSize: _MembersLimit,
                getNonGroupMembersOnly: false);

            switch (response.responseType) {
              case ResType.ResponseType.SUCCESS:
                yield response.data.length==0
                    ? state.copyWith(hasReachedMax: true)
                    : state.copyWith(
                    status: GroupMembersStatus.success,
                    members: List.of(state.members)..addAll(response.data),
                    hasReachedMax: _hasReachedMax(response.data.length));
                break;
              case ResType.ResponseType.VALIDATION_ERROR:
              //  return state.copyWith(status: GroupMembersStatus.failureValidation);
                break;
              case ResType.ResponseType.SERVER_ERROR:
              //   return state.copyWith(status: GroupMembersStatus.serverError);
                break;
              case ResType.ResponseType.CLIENT_ERROR:
              //   return state.copyWith(status: GroupMembersStatus.networkError);
                break;
              case ResType.ResponseType.NETWORK_ERROR:
              //   return state.copyWith(status: GroupMembersStatus.networkError);
                break;
            }
          } catch (e) {
            print('error to fetch members');
          }
        }
        //    return state.copyWith(status: GroupMembersStatus.loadingData);
      } catch (e) {
        yield state.copyWith(status: GroupMembersStatus.failureValidation);
      }
    }
  }

  Stream<GroupMembersState> removeMemberFromGroup(String groupId, List<String> membersId, GroupMembersState state) async* {
    yield state.copyWith(removeStatus: RemoveMembersFromGroupStatus.loadingData);
    try {
      final ResponseWrapper<bool> response = await catalogFacadeService.removeMemberFromGroup(groupId: groupId, memberId: membersId);
      switch (response.responseType) {
        case ResType.ResponseType.SUCCESS:
          for (int i = 0; i < membersId.length; i++) state.members.removeWhere((element) => element.id == membersId[i]);
          yield response.data
              ? state.copyWith(
                  removeStatus: RemoveMembersFromGroupStatus.success,
                  members: state.members,
                  personIdRemoved: membersId.first.toString(),
                )
              : state.copyWith(
                  removeStatus: RemoveMembersFromGroupStatus.errorRemove,
                );
          break;
        case ResType.ResponseType.VALIDATION_ERROR:
          yield state.copyWith(removeStatus: RemoveMembersFromGroupStatus.failureValidation);
          break;
        case ResType.ResponseType.SERVER_ERROR:
          yield state.copyWith(removeStatus: RemoveMembersFromGroupStatus.serverError);
          break;
        case ResType.ResponseType.CLIENT_ERROR:
          yield state.copyWith(removeStatus: RemoveMembersFromGroupStatus.networkError);
          break;
        case ResType.ResponseType.NETWORK_ERROR:
          yield state.copyWith(removeStatus: RemoveMembersFromGroupStatus.networkError);
          break;
      }
    } catch (e) {
      print('error to fetch members');
      yield state.copyWith(removeStatus: RemoveMembersFromGroupStatus.failureValidation);
    }
  }

  bool _hasReachedMax(int membersCount) => membersCount < _MembersLimit ? true : false;
}
