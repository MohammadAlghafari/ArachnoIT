import 'dart:async';

import 'package:arachnoit/infrastructure/api/response_wrapper.dart';
import 'package:arachnoit/infrastructure/common_response/brief_profile_response.dart';
import 'package:arachnoit/infrastructure/common_response/vote_response.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../common/global_prupose_functions.dart';
import '../../infrastructure/api/response_type.dart' as ResType;
import '../../infrastructure/catalog_facade_service.dart';

part 'question_answer_item_event.dart';
part 'question_answer_item_state.dart';

class QuestionAnswerItemBloc
    extends Bloc<QuestionAnswerItemEvent, QuestionAnswerItemState> {
  QuestionAnswerItemBloc({@required this.catalogService})
      : assert(catalogService != null),
        super(const QuestionAnswerItemState());

  final CatalogFacadeService catalogService;

  @override
  Stream<QuestionAnswerItemState> mapEventToState(
    QuestionAnswerItemEvent event,
  ) async* {
    if (event is DownloadFileEvent) yield* _mapDownloadFileToState(event);
    else if (event is VoteEmphasisEvent)
      yield* _mapSetEmphasisToState(event);
    else if (event is VoteUsefulEvent) yield* _mapSetUsefulToState(event);
     else if (event is GetProfileBridEvent) yield* _mapGetProfileBridEvent(event);
  }

  Stream<QuestionAnswerItemState> _mapDownloadFileToState(
    DownloadFileEvent event,
  ) async* {
    try {
      GlobalPurposeFunctions.downloadFile(event.url, event.fileName);
    } on Exception catch (_) {}
  }
 Stream<QuestionAnswerItemState> _mapGetProfileBridEvent(GetProfileBridEvent event) async* {
    GlobalPurposeFunctions.showOrHideProgressDialog(event.context, true);
    try {
      final ResponseWrapper<BriefProfileResponse> briefProfileResponse =
          await catalogService.getBriefProfile(id: event.userId);
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
      yield RemoteClientErrorState(remoteClientErrorMessage: "");
    }
  }
   Stream<QuestionAnswerItemState> _mapSetEmphasisToState(
      VoteEmphasisEvent event) async* {
    try {
      final ResponseWrapper<VoteResponse> voteResponse =
          await catalogService.setEmphasisVoteForAnswer(
        itemId: event.itemId,
        status: event.status,
      );
      switch (voteResponse.responseType) {
        case ResType.ResponseType.SUCCESS:
          yield VoteEmphasisState(vote: voteResponse.data.status);
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

  Stream<QuestionAnswerItemState> _mapSetUsefulToState(VoteUsefulEvent event) async* {
    try {
      final ResponseWrapper<VoteResponse> voteResponse =
          await catalogService.setUsefulVoteForAnswer(
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
