import 'dart:async';
import 'dart:convert';

import 'package:arachnoit/application/group_members_providers/group_permission/group_permission_bloc.dart';
import 'package:arachnoit/infrastructure/api/response_type.dart';
import 'package:arachnoit/infrastructure/api/response_wrapper.dart';
import 'package:arachnoit/infrastructure/catalog_facade_service.dart';
import 'package:arachnoit/infrastructure/group_details/response/group_permission_response.dart';
import 'package:arachnoit/infrastructure/group_members_providers/group_invite_members/response/Invite_member_to_group_response.dart';
import 'package:arachnoit/infrastructure/group_members_providers/group_invite_members/response/group_invite_members_response.dart';
import 'package:arachnoit/infrastructure/group_members_providers/group_invite_members/response/invite_member_json_body_request.dart';
import 'package:arachnoit/infrastructure/group_members_providers/group_invite_members/response/permission_group_type_request.dart';
import 'package:arachnoit/infrastructure/group_members_providers/group_permission/response/group_permission_response.dart';
import 'package:arachnoit/presentation/screens/group_members_provider/group_invite_members/dialog_add_permissions_to_invite_members_screen.dart';
import 'package:bloc/bloc.dart';
import 'package:arachnoit/infrastructure/api/response_type.dart' as ResType;
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

part 'group_invite_members_event.dart';

part 'group_invite_members_state.dart';

const _MembersInviteLimit = 20;

class GroupInviteMembersBloc extends Bloc<GroupInviteMembersEvent, GroupInviteMembersState> {
  final CatalogFacadeService catalogFacadeService;

  GroupInviteMembersBloc({@required this.catalogFacadeService}) : super(GroupInviteMembersState());

  @override
  Stream<Transition<GroupInviteMembersEvent, GroupInviteMembersState>> transformEvents(
      Stream<GroupInviteMembersEvent> events, TransitionFunction<GroupInviteMembersEvent, GroupInviteMembersState> transitionFn) {
    return super.transformEvents(events.debounceTime(const Duration(milliseconds: 300)), transitionFn);
  }

  @override
  Stream<GroupInviteMembersState> mapEventToState(
    GroupInviteMembersEvent event,
  ) async* {
    if (event is GetGroupInviteMembers) {
      yield state.copyWith(inviteMemberStatus: RequestState.initial);
      yield* fetchGroupInviteMembers(event.groupId, state);
    } else if (event is InviteMembersToGroup) {
      yield* inviteMembersToGroup(event, state);
    } else if (event is ChangeInviteStateMembers)
      yield* changeInviteStateMember(event.personId);
    else if (event is RefreshMemberInviteGetData)
      yield* refreshGroupInviteMembers(event.groupId, state);
    else if (event is SubmittedSearchInviteMembers) yield* searchInviteGroupMembers(event.groupId, event.query, state);
  }

  Stream<GroupInviteMembersState> searchInviteGroupMembers(String groupId, String query, GroupInviteMembersState state) async* {
    Map<String, bool> values = Map<String, bool>();
    yield state.copyWith(status: RequestState.loadingData);
    try {
      final ResponseWrapper<List<GetGroupInviteMembersResponse>> response = await catalogFacadeService.getGroupInviteMembers(
          idGroup: groupId,
          includeHealthcareProvidersOnly: false,
          query: query,
          enablePagination: true,
          pageNumber: 0,
          pageSize: _MembersInviteLimit,
          getNonGroupMembersOnly: true);
      print('response is ${response.responseType}');
      switch (response.responseType) {
        case ResType.ResponseType.SUCCESS:

          if (response.data.length > 0) {
            for (int i = 0; i < response.data.length; i++) {
              values['${response.data[i].id}'] = false;
            }
          } else {}
          yield response.data.length==0
              ? state.copyWith(hasReachedMax: false)
              : state.copyWith(
                  status: RequestState.success,
                  members: response.data,
                  isInvited: values,
                  hasReachedMax: _hasReachedMax(response.data.length),
                );
          break;
        case ResType.ResponseType.VALIDATION_ERROR:
          yield state.copyWith(status: RequestState.failureValidation);
          break;
        case ResType.ResponseType.SERVER_ERROR:
          yield state.copyWith(status: RequestState.serverError);
          break;
        case ResType.ResponseType.CLIENT_ERROR:
          yield state.copyWith(status: RequestState.networkError);
          break;
        case ResType.ResponseType.NETWORK_ERROR:
          yield state.copyWith(status: RequestState.networkError);
          break;
      }
    } catch (e) {
      yield state.copyWith();
    }
  }

  Stream<GroupInviteMembersState> refreshGroupInviteMembers(String groupId, GroupInviteMembersState state) async* {
    Map<String, bool> values = Map<String, bool>();

    try {
      final ResponseWrapper<List<GetGroupInviteMembersResponse>> response = await catalogFacadeService.getGroupInviteMembers(
          idGroup: groupId,
          includeHealthcareProvidersOnly: false,
          query: null,
          enablePagination: true,
          pageNumber: 0,
          pageSize: _MembersInviteLimit,
          getNonGroupMembersOnly: true);
      switch (response.responseType) {
        case ResType.ResponseType.SUCCESS:
          if (response.data.length > 0) {
            for (int i = 0; i < response.data.length; i++) values['${response.data[i].id}'] = false;
          } else {}
          yield response.data.isEmpty
              ? state.copyWith(hasReachedMax: true,)
              : state.copyWith(
                  status: RequestState.success,
                  members: response.data,
                  hasReachedMax: _hasReachedMax(response.data.length),
                  isInvited: values,
                  inviteMemberStatus: RequestState.initial,
                  refreshGroupInviteMembersStatus: RequestState.success);
          break;
        case ResType.ResponseType.VALIDATION_ERROR:
          yield state.copyWith(
            refreshGroupInviteMembersStatus: RequestState.failureValidation,
            inviteMemberStatus: RequestState.initial,
          );
          break;
        case ResType.ResponseType.SERVER_ERROR:
          yield state.copyWith(
            refreshGroupInviteMembersStatus: RequestState.serverError,
            inviteMemberStatus: RequestState.initial,
          );
          break;
        case ResType.ResponseType.CLIENT_ERROR:
          yield state.copyWith(
            refreshGroupInviteMembersStatus: RequestState.networkError,
            inviteMemberStatus: RequestState.initial,
          );
          break;
        case ResType.ResponseType.NETWORK_ERROR:
          yield state.copyWith(
            refreshGroupInviteMembersStatus: RequestState.networkError,
            inviteMemberStatus: RequestState.initial,
          );
          break;
      }
    } catch (e) {
      print('error to fetch members');
    }
  }

  Stream<GroupInviteMembersState> fetchGroupInviteMembers(String groupId, GroupInviteMembersState state) async* {
    Map<String, bool> values = Map<String, bool>();
    if (state.hasReachedMax&& state.members.length!=0) {
      yield state;
    } else
      try {
        if (state.status == RequestState.initial ||
            state.status == RequestState.serverError ||
            state.status == RequestState.networkError ||
            state.status == RequestState.failureValidation) {
          yield state.copyWith(status: RequestState.loadingData);
          try {
            final ResponseWrapper<List<GetGroupInviteMembersResponse>> response = await catalogFacadeService.getGroupInviteMembers(
                idGroup: groupId,
                includeHealthcareProvidersOnly: false,
                query: null,
                enablePagination: true,
                pageNumber: 0,
                pageSize: _MembersInviteLimit,
                getNonGroupMembersOnly: true);
            switch (response.responseType) {
              case ResType.ResponseType.SUCCESS:
                if (response.data.length > 0) {
                  for (int i = 0; i < response.data.length; i++) {
                    values['${response.data[i].id}'] = false;
                  }
                } else {}
                print(values);
                yield response.data.isEmpty
                    ? state.copyWith(hasReachedMax: true)
                    : state.copyWith(
                        status: RequestState.success, members: response.data, hasReachedMax: _hasReachedMax(response.data.length), isInvited: values);
                break;
              case ResType.ResponseType.VALIDATION_ERROR:
                yield state.copyWith(status: RequestState.failureValidation);
                break;
              case ResType.ResponseType.SERVER_ERROR:
                yield state.copyWith(status: RequestState.serverError);
                break;
              case ResType.ResponseType.CLIENT_ERROR:
                yield state.copyWith(status: RequestState.networkError);
                break;
              case ResType.ResponseType.NETWORK_ERROR:
                yield state.copyWith(status: RequestState.networkError);
                break;
            }
          } catch (e) {
            print('error to fetch members');
          }
        } else {
          values = state.isInvited;
          try {
            final ResponseWrapper<List<GetGroupInviteMembersResponse>> response = await catalogFacadeService.getGroupInviteMembers(
                idGroup: groupId,
                includeHealthcareProvidersOnly: true,
                query: null,
                enablePagination: true,
                pageNumber: (state.members.length / _MembersInviteLimit).round(),
                pageSize: _MembersInviteLimit,
                getNonGroupMembersOnly: true);

            if (response.data.length > 0) {
              for (int i = 0; i < response.data.length; i++) values['${response.data[i].id}'] = false;
            } else {}

            switch (response.responseType) {
              case ResType.ResponseType.SUCCESS:
                yield response.data.isEmpty
                    ? state.copyWith(hasReachedMax: true)
                    : state.copyWith(
                        status: RequestState.success,
                        members: List.of(state.members)..addAll(response.data),
                        hasReachedMax: _hasReachedMax(response.data.length),
                        isInvited: values);
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
        yield state.copyWith(status: RequestState.failureValidation);
      }
  }

  Stream<GroupInviteMembersState> changeInviteStateMember(String personId) async* {
    if (state.isInvited.containsKey(personId)) state.isInvited.update(personId, (value) => false);
    yield state.copyWith(isInvited: state.isInvited, inviteMemberStatus: RequestState.initial);
  }

  Stream<GroupInviteMembersState> inviteMembersToGroup(InviteMembersToGroup event, GroupInviteMembersState state) async* {
    yield state.copyWith(inviteMemberStatus: RequestState.loadingData);
    try {

      final ResponseWrapper<InviteMemberToGroupResponse> response = await catalogFacadeService.inviteMembersToGroup(
          inviteMemberPermission: memberTypePermission(event.groupPermission, event.memberInvitePermissionType),
          groupId: event.groupId,
          personId: event.personId);
print(state.isInvited);
      switch (response.responseType) {
        case ResType.ResponseType.SUCCESS:

          state.isInvited.update(event.personId, (value) => true);
          // state.members.removeWhere((element) => element.id==event.personId);
          yield state.copyWith(
            inviteMemberStatus: RequestState.success,
            isInvited: state.isInvited,
            members: state.members,
          );
          break;
        case ResType.ResponseType.VALIDATION_ERROR:
          yield state.copyWith(inviteMemberStatus: RequestState.failureValidation);
          break;
        case ResType.ResponseType.SERVER_ERROR:
          yield state.copyWith(inviteMemberStatus: RequestState.serverError);
          break;
        case ResType.ResponseType.CLIENT_ERROR:
          yield state.copyWith(inviteMemberStatus: RequestState.networkError);
          break;
        case ResType.ResponseType.NETWORK_ERROR:
          yield state.copyWith(inviteMemberStatus: RequestState.networkError);
          break;
      }

      //    return state.copyWith(status: GroupMembersStatus.loadingData);
    } catch (e) {
      yield state.copyWith(inviteMemberStatus: RequestState.failureValidation);
    }
    yield state.copyWith(inviteMemberStatus: RequestState.initial);
  }

  List<dynamic> memberTypePermission(List<GroupPermission> groupPermission, MemberInvitePermissionType memberType) {
    List<GroupPermission> newGroupPermission = new List<GroupPermission>();
    switch (memberType) {
      case MemberInvitePermissionType.Admin:
        return groupPermission;
        break;
      case MemberInvitePermissionType.Editor:
        groupPermission.forEach((element) {
          switch (element.permissionType) {
            case 0:
            case 1:
            case 2:
            case 3:
            case 4:
            case 5:
            case 11:
            case 12:
            case 13:
              break;
            default:
              newGroupPermission.add(element);
          }
        });
        return newGroupPermission;
        break;
      case MemberInvitePermissionType.Coordinator:
        groupPermission.forEach((element) {
          switch (element.permissionType) {
            case 5:
            case 3:
            case 0:
              newGroupPermission.add(element);
              break;
          }
        });
        return newGroupPermission;

        break;
      case MemberInvitePermissionType.User:
        Iterable<GroupPermission> item = groupPermission.where((element) => element.permissionType == 14);
        newGroupPermission.add(item.first);
        return newGroupPermission;
        break;
    }
  }

  bool _hasReachedMax(int membersCount) => membersCount < _MembersInviteLimit ? true : false;
}
