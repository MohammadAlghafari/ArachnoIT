import 'dart:async';

import 'package:arachnoit/infrastructure/common_response/brief_profile_response.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../common/global_prupose_functions.dart';
import '../../infrastructure/api/response_type.dart' as ResType;
import '../../infrastructure/api/response_wrapper.dart';
import '../../infrastructure/catalog_facade_service.dart';

part 'provider_list_item_event.dart';
part 'provider_list_item_state.dart';

class ProviderListItemBloc
    extends Bloc<ProviderListItemEvent, ProviderListItemState> {
  ProviderListItemBloc({@required this.catalogService})
      : assert(catalogService != null),
        super(const ProviderListItemState());

  final CatalogFacadeService catalogService;

  @override
  Stream<ProviderListItemState> mapEventToState(
    ProviderListItemEvent event,
  ) async* {
    if (event is SetFavoriteProviderEvent)
      yield* _mapSetFavoriteProviderToState(event);
    else if (event is CopyToClipboardEvent)
      yield* _mapCopyToClipboardToState(event);
    else if (event is GetProfileBridEvent)
      yield* _mapGetProfileBridEvent(event);
  }

  Stream<ProviderListItemState> _mapGetProfileBridEvent(
      GetProfileBridEvent event) async* {
    try {
      GlobalPurposeFunctions.showOrHideProgressDialog(event.context, true);
      final ResponseWrapper<BriefProfileResponse> briefProfileResponse =
          await catalogService.getCommentBriefProfile(id: event.userId);
      GlobalPurposeFunctions.showOrHideProgressDialog(event.context, false);
      switch (briefProfileResponse.responseType) {
        case ResType.ResponseType.SUCCESS:
          yield GetBriedProfileSuceess(profileInfo: briefProfileResponse.data);
          break;
        case ResType.ResponseType.VALIDATION_ERROR:
          yield RemoteValidationErrorState(
            remoteValidationErrorMessage: briefProfileResponse.errorMessage,
          );
          break;
        case ResType.ResponseType.SERVER_ERROR:
          yield RemoteServerErrorState(
            remoteServerErrorMessage: briefProfileResponse.errorMessage,
          );
          break;
        case ResType.ResponseType.CLIENT_ERROR:
          yield RemoteClientErrorState(
            remoteClientErrorMessage: briefProfileResponse.errorMessage,
          );
          break;
        case ResType.ResponseType.NETWORK_ERROR:
          break;
      }
    } catch (e) {
      GlobalPurposeFunctions.showOrHideProgressDialog(event.context, false);
      yield RemoteClientErrorState(remoteClientErrorMessage: "");
      return;
    }
  }

  Stream<ProviderListItemState> _mapSetFavoriteProviderToState(
      SetFavoriteProviderEvent event) async* {
    try {
      GlobalPurposeFunctions.showOrHideProgressDialog(event.context, true);
      final ResponseWrapper<bool> favoriteResponse =
          await catalogService.setFavoriteProvider(
        favoritePersonId: event.favoritePersonId,
        favoriteStatus: event.favoriteStatus,
      );
      GlobalPurposeFunctions.showOrHideProgressDialog(event.context, false);
      switch (favoriteResponse.responseType) {
        case ResType.ResponseType.SUCCESS:
          yield SetFavoriteProviderState(status: favoriteResponse.data);
          break;
        case ResType.ResponseType.VALIDATION_ERROR:
          yield RemoteValidationErrorState(
            remoteValidationErrorMessage: favoriteResponse.errorMessage,
          );
          break;
        case ResType.ResponseType.SERVER_ERROR:
          yield RemoteServerErrorState(
            remoteServerErrorMessage: favoriteResponse.errorMessage,
          );
          break;
        case ResType.ResponseType.CLIENT_ERROR:
          yield RemoteClientErrorState(
            remoteClientErrorMessage: favoriteResponse.errorMessage,
          );
          break;
        case ResType.ResponseType.NETWORK_ERROR:
          break;
      }
    } catch (_) {
      GlobalPurposeFunctions.showOrHideProgressDialog(event.context, false);
      yield RemoteClientErrorState(remoteClientErrorMessage: "");
      return;
    }
  }

  Stream<ProviderListItemState> _mapCopyToClipboardToState(
    CopyToClipboardEvent event,
  ) async* {
    try {
      GlobalPurposeFunctions.copyToClipboard(text: event.text);
    } catch (_) {
      yield RemoteClientErrorState(remoteClientErrorMessage: "");
      return;
    }
  }
}
