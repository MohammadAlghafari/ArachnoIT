import 'dart:async';

import 'package:arachnoit/common/global_prupose_functions.dart';
import 'package:arachnoit/infrastructure/api/response_type.dart';
import 'package:arachnoit/infrastructure/api/response_wrapper.dart' as ResType;
import 'package:arachnoit/infrastructure/api/response_wrapper.dart';
import 'package:arachnoit/infrastructure/catalog_facade_service.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';

part 'profile_actions_event.dart';
part 'profile_actions_state.dart';

class ProfileActionsBloc
    extends Bloc<ProfileActionsEvent, ProfileActionsState> {
  CatalogFacadeService catalogFacadeService;
  ProfileActionsBloc({@required this.catalogFacadeService})
      : super(ProfileActionsState());

  @override
  Stream<ProfileActionsState> mapEventToState(
    ProfileActionsEvent event,
  ) async* {
    if (event is ChangeFavoriteProfile)
      yield* _mapSetFavoriteProfileToState(event, state);
    else if (event is ChangeFollowProfile)
      yield* _mapSetFollowProfileToState(event, state);
  }

  Stream<ProfileActionsState> _mapSetFavoriteProfileToState(
      ChangeFavoriteProfile event, ProfileActionsState state) async* {
    yield LoadingProfileActionState();
    try {
      final ResponseWrapper<bool> favoriteProfileResponse =
          await catalogFacadeService.setFavoriteProvider(
        favoritePersonId: event.favoritePersonId,
        favoriteStatus: event.favoriteStatus,
      );
      switch (favoriteProfileResponse.responseType) {
        case ResponseType.SUCCESS:
          yield ChangeFavoriteProfileSuccess(
              messageStatus: favoriteProfileResponse.successMessage);
          break;
        case ResponseType.VALIDATION_ERROR:
          yield RemoteValidationErrorProfileState(
            remoteValidationErrorMessage: favoriteProfileResponse.errorMessage,
          );
          break;
        case ResponseType.SERVER_ERROR:
          yield RemoteServerErrorProfileState(
            remoteServerErrorMessage: favoriteProfileResponse.errorMessage,
          );
          break;
        case ResponseType.CLIENT_ERROR:
          yield RemoteClientErrorProfileState();
          break;
        case ResponseType.NETWORK_ERROR:
          break;
      }
    } on Exception catch (_) {}
  }

  Stream<ProfileActionsState> _mapSetFollowProfileToState(
      ChangeFollowProfile event, ProfileActionsState state) async* {
    GlobalPurposeFunctions.showOrHideProgressDialog(event.context, true);
    try {
      final ResponseWrapper<bool> followProfileResponse =
          await catalogFacadeService.setFollowProvider(
        followStatus: event.followStatus,
        healthCareProviderId: event.healthCareProviderId,
      );
      GlobalPurposeFunctions.showOrHideProgressDialog(event.context, false);
      switch (followProfileResponse.responseType) {
        case ResponseType.SUCCESS:
          yield ChangeFollowProfileSuccess(
              messageStatus: followProfileResponse.successMessage);
          break;
        case ResponseType.VALIDATION_ERROR:
          yield RemoteValidationErrorProfileState(
            remoteValidationErrorMessage: followProfileResponse.errorMessage,
          );
          break;
        case ResponseType.SERVER_ERROR:
          yield RemoteServerErrorProfileState(
            remoteServerErrorMessage: followProfileResponse.errorMessage,
          );
          break;
        case ResponseType.CLIENT_ERROR:
          yield RemoteClientErrorProfileState();
          break;
        case ResponseType.NETWORK_ERROR:
          break;
      }
    } catch (_) {
      GlobalPurposeFunctions.showOrHideProgressDialog(event.context, false);
      yield RemoteServerErrorProfileState(
          remoteServerErrorMessage: "error happened");
    }
  }
}
