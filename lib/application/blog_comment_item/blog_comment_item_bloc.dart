import 'dart:async';

import 'package:arachnoit/common/global_prupose_functions.dart';
import 'package:arachnoit/infrastructure/common_response/brief_profile_response.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../infrastructure/api/response_type.dart' as ResType;
import '../../infrastructure/api/response_wrapper.dart';
import '../../infrastructure/catalog_facade_service.dart';
import '../../infrastructure/common_response/vote_response.dart';

part 'blog_comment_item_event.dart';
part 'blog_comment_item_state.dart';

class CommentItemBloc
    extends Bloc<CommentItemEvent, CommentItemState> {
  CommentItemBloc({@required this.catalogService})
      : assert(catalogService != null),
        super(const CommentItemState());

  final CatalogFacadeService catalogService;

  @override
  Stream<CommentItemState> mapEventToState(
    CommentItemEvent event,
  ) async* {
    if (event is VoteUsefulEvent)
      yield* _mapSetUsefulToState(event);
    else if (event is GetProfileBridEvent)
      yield* _mapGetProfileBridEvent(event);
  }

  Stream<CommentItemState> _mapGetProfileBridEvent(
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
    }
  }

  Stream<CommentItemState> _mapSetUsefulToState(
      VoteUsefulEvent event) async* {
    try {
      final ResponseWrapper<VoteResponse> voteResponse =
          await catalogService.setUsefulVoteForComment(
        itemId: event.itemId,
        status: event.status,
      );
      switch (voteResponse.responseType) {
        case ResType.ResponseType.SUCCESS:
          yield VoteUsefulState(vote: voteResponse.data.status);
          break;
        case ResType.ResponseType.VALIDATION_ERROR:
          yield RemoteValidationErrorState(
            remoteValidationErrorMessage: voteResponse.errorMessage,
          );
          break;
        case ResType.ResponseType.SERVER_ERROR:
          yield RemoteServerErrorState(
            remoteServerErrorMessage: voteResponse.errorMessage,
          );
          break;
        case ResType.ResponseType.CLIENT_ERROR:
          yield RemoteClientErrorState(
            remoteClientErrorMessage: voteResponse.errorMessage,
          );
          break;
        case ResType.ResponseType.NETWORK_ERROR:
          break;
      }
    } on Exception catch (_) {}
  }
}
