import 'dart:async';

import 'package:arachnoit/infrastructure/api/response_wrapper.dart';
import 'package:arachnoit/infrastructure/catalog_facade_service.dart';
import 'package:arachnoit/infrastructure/profile_follow_list/response/profile_follow_list_reponse.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../infrastructure/api/response_type.dart' as ResType;
import 'package:flutter/material.dart';

part 'profile_follow_list_event.dart';

part 'profile_follow_list_state.dart';

class ProfileFollowListBloc
    extends Bloc<ProfileFollowListEvent, ProfileFollowListState> {
  CatalogFacadeService catalogService;

  ProfileFollowListBloc({@required this.catalogService})
      : super(ProfileFollowListInitial());

  @override
  Stream<ProfileFollowListState> mapEventToState(
    ProfileFollowListEvent event,
  ) async* {
    if (event is GetProfileFollowListEvent) {
      yield* _mapGetProfileFollowListInfo(event);
    }
  }

  Stream<ProfileFollowListState> _mapGetProfileFollowListInfo(
      GetProfileFollowListEvent getProfileFollowListEvent) async* {
    try {
      yield LoadingState();
      ResponseWrapper<ProfileFollowListResponse> profileInfoResponse =
          await catalogService.getProfileFollowInfo(
        healthcareProvider: getProfileFollowListEvent.healthcareProviderId,
      );
      switch (profileInfoResponse.responseType) {
        case ResType.ResponseType.SUCCESS:
          yield SuccessGetProfileFollowListState(
              profileFollowListResponse: profileInfoResponse.data);
          break;
        case ResType.ResponseType.SERVER_ERROR:
          yield RemoteServerErrorState(
            remoteServerErrorMessage: profileInfoResponse.errorMessage,
          );
          break;
        case ResType.ResponseType.CLIENT_ERROR:
          yield RemoteClientErrorState();
          break;
        case ResType.ResponseType.NETWORK_ERROR:
          break;
      }
    } catch (_) {
      yield RemoteClientErrorState();
      return;
    }
  }
}
