import 'dart:async';

import 'package:arachnoit/application/blog_comment_item/blog_comment_item_bloc.dart';
import 'package:arachnoit/common/global_prupose_functions.dart';
import 'package:arachnoit/infrastructure/api/response_wrapper.dart';
import 'package:arachnoit/infrastructure/catalog_facade_service.dart';
import 'package:arachnoit/infrastructure/common_response/brief_profile_response.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import '../../infrastructure/api/response_type.dart' as ResType;
part 'blog_replay_item_event.dart';
part 'blog_replay_item_state.dart';

class ReplayItemBloc
    extends Bloc<ReplayItemEvent, ReplayItemState> {
  final CatalogFacadeService catalogService;
  ReplayItemBloc({this.catalogService}) : super(BlogReplayItemInitial());

  @override
  Stream<ReplayItemState> mapEventToState(
      ReplayItemEvent event) async* {
    if (event is GetProfileBridEvent) {
      yield* _mapGetProfileBridEvent(event);
    }
  }

  Stream<ReplayItemState> _mapGetProfileBridEvent(
      GetProfileBridEvent event) async* {
    try {
      GlobalPurposeFunctions.showOrHideProgressDialog(event.context, true);
      final ResponseWrapper<BriefProfileResponse> briefProfileResponse =
          await catalogService.getReplayBriefProfile(id: event.userId);
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
    }
  }
}
