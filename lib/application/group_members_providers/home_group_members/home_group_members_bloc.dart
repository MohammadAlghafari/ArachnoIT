import 'dart:async';

import 'package:arachnoit/infrastructure/api/response_wrapper.dart';
import 'package:arachnoit/infrastructure/catalog_facade_service.dart';
import 'package:arachnoit/infrastructure/group_members_providers/group_invite_members/response/group_invite_members_response.dart';
import 'package:arachnoit/infrastructure/group_members_providers/group_members/response/get_group_members_response.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:arachnoit/infrastructure/api/response_type.dart' as ResType;

part 'home_group_members_event.dart';
part 'home_group_members_state.dart';
const _MembersLimit = 20;

class HomeGroupMembersBloc extends Bloc<HomeGroupMembersEvent, HomeGroupMembersState> {
  CatalogFacadeService catalogFacadeService;
  HomeGroupMembersBloc({@required this.catalogFacadeService}) : super(HomeGroupMembersState());

  @override
  Stream<HomeGroupMembersState> mapEventToState(
    HomeGroupMembersEvent event,
  ) async* {
     if (event is PersonSearchedGroupMember) yield*   getSearchQueryGroupMembers(event.groupId, event.query, state);
     else if (event is PersonSearchedInviteMember) yield*   getSearchQueryInviteGroupMembers(event.groupId, event.query, state);
    else  if(event is ResetSearched) yield state.copyWith(personSearched: []);

  }
  Stream<HomeGroupMembersState> getSearchQueryGroupMembers(String groupId, String query, HomeGroupMembersState state) async* {
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
          List<String> personSearched = new List<String>();

          for (int i = 0; i < response.data.length; i++)
            personSearched.add(response.data[i].fullName);
          yield response.data.isEmpty ? state.copyWith(personSearched: []) : state.copyWith(personSearched: personSearched);
          break;
        case ResType.ResponseType.VALIDATION_ERROR:
          yield state.copyWith();
          break;
        case ResType.ResponseType.SERVER_ERROR:
          yield state.copyWith();
          break;
        case ResType.ResponseType.CLIENT_ERROR:
          yield state.copyWith();
          break;
        case ResType.ResponseType.NETWORK_ERROR:
          yield state.copyWith();
          break;
      }
    } catch (e) {
      yield state.copyWith();
    }
  }
  Stream<HomeGroupMembersState> getSearchQueryInviteGroupMembers(String groupId, String query, HomeGroupMembersState state) async* {
    try {
      final ResponseWrapper<List<GetGroupInviteMembersResponse>> response = await catalogFacadeService.getGroupInviteMembers(
          idGroup: groupId,
          includeHealthcareProvidersOnly: false,
          query: query,
          enablePagination: true,
          pageNumber: 0,
          pageSize: _MembersLimit,
          getNonGroupMembersOnly: true);
      switch (response.responseType) {
        case ResType.ResponseType.SUCCESS:
          List<String> personSearched = new List<String>();
          for (int i = 0; i < response.data.length; i++)
            personSearched.add(response.data[i].fullName);
          yield response.data.isEmpty ? state.copyWith(personSearched: []) : state.copyWith(personSearched: personSearched,);
          break;
        case ResType.ResponseType.VALIDATION_ERROR:
          yield state.copyWith();
          break;
        case ResType.ResponseType.SERVER_ERROR:
          yield state.copyWith();
          break;
        case ResType.ResponseType.CLIENT_ERROR:
          yield state.copyWith();
          break;
        case ResType.ResponseType.NETWORK_ERROR:
          yield state.copyWith();
          break;
      }
    } catch (e) {
      yield state.copyWith();
    }
  }


}
