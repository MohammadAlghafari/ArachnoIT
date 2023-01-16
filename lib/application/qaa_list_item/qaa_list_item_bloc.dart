import 'dart:async';

import 'package:arachnoit/infrastructure/common_response/brief_profile_response.dart';
import 'package:arachnoit/infrastructure/home_qaa/response/qaa_response.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../common/global_prupose_functions.dart';
import '../../infrastructure/api/response_type.dart' as ResType;
import '../../infrastructure/api/response_wrapper.dart';
import '../../infrastructure/catalog_facade_service.dart';
import '../../infrastructure/common_response/file_response.dart';
import '../../infrastructure/common_response/vote_response.dart';

part 'qaa_list_item_event.dart';
part 'qaa_list_item_state.dart';

class QaaListItemBloc extends Bloc<QaaListItemEvent, QaaListItemState> {
  QaaListItemBloc({@required this.catalogService})
      : assert(catalogService != null),
        super(const QaaListItemState());

  final CatalogFacadeService catalogService;

  @override
  Stream<QaaListItemState> mapEventToState(
    QaaListItemEvent event,
  ) async* {
    if (event is GetQuestionFilesEvent) {
      yield* _mapGetQuestionFilesToState(event);
    } else if (event is DownloadFileEvent)
      yield* _mapDownloadFileToState(event);
    else if (event is VoteUsefulEvent)
      yield* _mapSetUsefulToState(event);
    else if (event is VoteUsefulEvent)
      yield* _mapSetUsefulToState(event);
    else if (event is SendReport) {
      yield* _mapSendReport(event);
    } else if (event is GetProfileBridEvent)
      yield* _mapGetProfileBridEvent(event);
    else if (event is UpdateObjectWhenSuccessUpdate) {
      yield UpdateObjectWhenSuccessUpdateState(qaaResponse: event.qaaResponse);
    }
  }

  Stream<QaaListItemState> _mapGetProfileBridEvent(GetProfileBridEvent event) async* {
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

  Stream<QaaListItemState> _mapSendReport(SendReport event) async* {
    try {
      ResponseWrapper<bool> res =
          await catalogService.sendBlogsReport(blogID: event.blogId, message: event.description);
      if (res.data == true) {
        yield SendReportSuccess(message: res.successMessage);
        return;
      } else {
        yield FailedSendReport(message: res.errorMessage);
        return;
      }
    } catch (e) {
      yield FailedSendReport(message: "Error happened try again");
      return;
    }
  }

  Stream<QaaListItemState> _mapGetQuestionFilesToState(GetQuestionFilesEvent event) async* {
    try {
      yield LoadingState();
      final ResponseWrapper<List<FileResponse>> questionFilesResponse =
          await catalogService.getQuestionfiles(questionId: event.questionId);
      switch (questionFilesResponse.responseType) {
        case ResType.ResponseType.SUCCESS:
          yield QuestionFilesState(questionFiles: questionFilesResponse.data);
          break;
        case ResType.ResponseType.VALIDATION_ERROR:
          yield RemoteValidationErrorState();
          break;
        case ResType.ResponseType.SERVER_ERROR:
          yield RemoteServerErrorState();
          break;
        case ResType.ResponseType.CLIENT_ERROR:
          yield RemoteClientErrorState();
          break;
        case ResType.ResponseType.NETWORK_ERROR:
          break;
      }
    } catch (e) {}
  }

  Stream<QaaListItemState> _mapSetUsefulToState(VoteUsefulEvent event) async* {
    try {
      final ResponseWrapper<VoteResponse> voteResponse =
          await catalogService.setUsefulVoteForQuestion(
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

  Stream<QaaListItemState> _mapDownloadFileToState(
    DownloadFileEvent event,
  ) async* {
    try {
      GlobalPurposeFunctions.downloadFile(event.url, event.fileName);
    } on Exception catch (_) {}
  }
}
