import 'dart:async';
import 'dart:convert';

import 'package:arachnoit/common/global_prupose_functions.dart';
import 'package:arachnoit/common/pref_keys.dart';
import 'package:arachnoit/infrastructure/api/response_wrapper.dart';
import 'package:arachnoit/infrastructure/catalog_facade_service.dart';
import 'package:arachnoit/infrastructure/group_details/response/delete_group_response.dart';
import 'package:arachnoit/infrastructure/group_details/response/group_details_response.dart';
import 'package:arachnoit/infrastructure/group_details/response/joined_group_response.dart';
import 'package:arachnoit/infrastructure/login/response/login_response.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../infrastructure/api/response_type.dart' as ResType;
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'group_details_event.dart';

part 'group_details_state.dart';

class GroupDetailsBloc extends Bloc<GroupDetailsEvent, GroupDetailsState> {
  GroupDetailsBloc({@required this.catalogService, @required this.sharedPreferences})
      : assert(catalogService != null),
        super(const GroupDetailsState());
  final CatalogFacadeService catalogService;
  final SharedPreferences sharedPreferences;

  @override
  Stream<GroupDetailsState> mapEventToState(
    GroupDetailsEvent event,
  ) async* {
    if (event is FetchGroupDetailsEvent) {
      yield* _mapFetchGroupDetailsToState(event);
    } else if (event is DisableEncodedHintMessageEvent) {
      yield* _mapDisableEncodedMessageHintToState(event);
    } else if (event is JoinToGroupEvent) {
      yield* _mapJoinToGroupEvent(event);
    } else if (event is DeleteGroupEvent)
      yield* _mapDeleteGroupState(event, state);
    else if (event is RefreshChangeTabsEvent)
      yield RefreshChangeTabs();
    else if (event is InjectedInviteGroup)
      yield* acceptedOrInjectedInvitationGroup(event, state);
    else if (event is AcceptedInviteGroup) yield* acceptedOrInjectedInvitationGroup(event, state);
  }

  Stream<GroupDetailsState> acceptedOrInjectedInvitationGroup(GroupDetailsEvent event, GroupDetailsState state) async* {

    LoginResponse response = LoginResponse.fromJson(sharedPreferences.getString(PrefsKeys.LOGIN_RESPONSE));
    ResponseWrapper<bool> acceptedOrInjectedResponse;
    try {
      if (event is AcceptedInviteGroup)
        acceptedOrInjectedResponse = await catalogService.acceptGroupInvitation(userId: response.userId, groupId: event.groupId);
      else if (event is InjectedInviteGroup)
        acceptedOrInjectedResponse = await catalogService.removeFromPenddingGroup(userId: response.userId, groupId: event.groupId);
      switch (acceptedOrInjectedResponse.responseType) {
        case ResType.ResponseType.SUCCESS:

          yield SuccessToAcceptedToGroup(successOperation: acceptedOrInjectedResponse.successMessage);
          break;
        case ResType.ResponseType.VALIDATION_ERROR:
          yield RemoteValidationErrorState(
            remoteValidationErrorMessage: acceptedOrInjectedResponse.errorMessage,
          );
          break;
        case ResType.ResponseType.SERVER_ERROR:
          yield RemoteServerErrorState(
            remoteServerErrorMessage: acceptedOrInjectedResponse.errorMessage,
          );
          break;
        case ResType.ResponseType.CLIENT_ERROR:
          yield RemoteClientErrorState(remoteClientErrorMessage: acceptedOrInjectedResponse.errorMessage);
          break;
        case ResType.ResponseType.NETWORK_ERROR:
          yield RemoteClientErrorState(remoteClientErrorMessage: acceptedOrInjectedResponse.errorMessage);

          break;
      }
    } on Exception catch (_) {
      yield RemoteClientErrorState(remoteClientErrorMessage: acceptedOrInjectedResponse.errorMessage);
    }
  }

  Stream<GroupDetailsState> _mapDeleteGroupState(DeleteGroupEvent event, GroupDetailsState state) async* {
    yield DeleteGroupLoading();
    try {
      final ResponseWrapper<DeleteGroupResponse> response = await catalogService.deleteGroup(
        groupId: event.groupId,
      );
      switch (response.responseType) {
        case ResType.ResponseType.SUCCESS:
          yield SuccessDeleteGroup(deleteGroupResponse: response.data);
          break;
        case ResType.ResponseType.VALIDATION_ERROR:
          yield RemoteValidationErrorState(
            remoteValidationErrorMessage: response.errorMessage,
          );
          break;
        case ResType.ResponseType.SERVER_ERROR:
          yield RemoteServerErrorState(
            remoteServerErrorMessage: response.errorMessage,
          );
          break;
        case ResType.ResponseType.CLIENT_ERROR:
          yield RemoteClientErrorState();
          break;
        case ResType.ResponseType.NETWORK_ERROR:
          break;
      }
    } on Exception catch (_) {}
  }

  Stream<GroupDetailsState> _mapJoinToGroupEvent(JoinToGroupEvent event) async* {
    try {
      ResponseWrapper<JoinedGroupResponse> response = await catalogService.joinInGroup(groupId: event.groupId);
      if (response.responseType == ResType.ResponseType.SUCCESS) {
        print("the success message is ${response.successMessage}");
        yield SuccessJoinedToGroup(message: response.successMessage, joinedGroupResponse: response.data);
        return;
      } else {
        yield FailedJoinedToGroup(message: response.successMessage);
        return;
      }
    } on Exception catch (_) {
      yield FailedJoinedToGroup(message: "Error Happened Try Again");
    }
  }

  Stream<GroupDetailsState> _mapFetchGroupDetailsToState(
    FetchGroupDetailsEvent event,
  ) async* {
    yield LoadingState();
    try {
      final ResponseWrapper<GroupDetailsResponse> groupDetailsResponse = await catalogService.getGroupDetails(
        groupId: event.groupId,
      );
      switch (groupDetailsResponse.responseType) {
        case ResType.ResponseType.SUCCESS:
          yield GroupDetailsFetchedState(groupDetails: groupDetailsResponse.data);
          break;
        case ResType.ResponseType.VALIDATION_ERROR:
          yield RemoteValidationErrorState(
            remoteValidationErrorMessage: groupDetailsResponse.errorMessage,
          );
          break;
        case ResType.ResponseType.SERVER_ERROR:
          yield RemoteServerErrorState(
            remoteServerErrorMessage: groupDetailsResponse.errorMessage,
          );
          break;
        case ResType.ResponseType.CLIENT_ERROR:
          yield RemoteClientErrorState();
          break;
        case ResType.ResponseType.NETWORK_ERROR:
          break;
      }
    } on Exception catch (_) {}
  }

  Stream<GroupDetailsState> _mapDisableEncodedMessageHintToState(
    DisableEncodedHintMessageEvent event,
  ) async* {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    event.map[event.groupId] = false;
    prefs.setString(PrefsKeys.ENCODED_GROUP_HINT_MAP, jsonEncode(event.map));
    yield DisableEncodedHintMessageState();
  }
}
