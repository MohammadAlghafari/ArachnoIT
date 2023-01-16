import 'dart:async';
import 'dart:convert';

import 'package:arachnoit/common/pref_keys.dart';
import 'package:arachnoit/infrastructure/common_response/blog_comment_reply_response.dart';
import 'package:arachnoit/infrastructure/common_response/file_response.dart';
import 'package:arachnoit/infrastructure/common_response/question_answer_comment_response.dart';
import 'package:arachnoit/infrastructure/common_response/question_answer_response.dart';
import 'package:arachnoit/infrastructure/login/response/login_response.dart';
import 'package:arachnoit/infrastructure/question_details/response/action_answer_response.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../common/global_prupose_functions.dart';
import '../../infrastructure/api/response_type.dart' as ResType;
import '../../infrastructure/api/response_wrapper.dart';
import '../../infrastructure/catalog_facade_service.dart';
import '../../infrastructure/common_response/vote_response.dart';
import '../../infrastructure/question_details/response/question_details_response.dart';

part 'question_details_event.dart';
part 'question_details_state.dart';

class QuestionDetailsBloc
    extends Bloc<QuestionDetailsEvent, QuestionDetailsState> {
  QuestionDetailsBloc({@required this.catalogService})
      : assert(catalogService != null),
        super(const QuestionDetailsState());

  final CatalogFacadeService catalogService;

  @override
  Stream<QuestionDetailsState> mapEventToState(
    QuestionDetailsEvent event,
  ) async* {
    if (event is FetchQuestionDetailsEvent)
      yield* _mapFetchQuestionDetailsToState(event);
    else if (event is DownloadFileEvent)
      yield* _mapDownloadFileToState(event);
    else if (event is VoteUsefulEvent)
      yield* _mapSetUsefulToState(event);
    else if (event is AnswerUpdateFilesListEvent) {
      yield AnswerUpdatedFileListState(files: event.files);
    } else if (event is AnswerRemoveFileItem) {
      yield* _mapRemoveFileItem(state, event);
    } else if (event is AddNewAnswer)
      yield* _mapAddNewAnswer(event);
    else if (event is UpdateAnswer)
      yield* _mapUpdateAnswer(event);
    else if (event is IsUpdateClickEvent)
      yield IsUpdateClickState(state: event.state);
    else if(event is RemoveAnswerFromQuestion)
      yield*  _mapRemoveAnswer(event);
    else if(event is SendReport)
      yield* _mapSendReport(event);
  }

  Stream<QuestionDetailsState> _mapSendReport(SendReport event) async* {
    try {
      final ResponseWrapper<bool> questionDetailsResponse =
      await catalogService.sendReportAnswer(
          commentId: event.commentId, description: event.description);
      switch (questionDetailsResponse.responseType) {
        case ResType.ResponseType.SUCCESS:
          yield SendReportSuccess(
              message: questionDetailsResponse.successMessage );
          break;
        case ResType.ResponseType.VALIDATION_ERROR:
          yield RemoteValidationErrorState(
            remoteValidationErrorMessage: questionDetailsResponse.errorMessage,
          );
          break;
        case ResType.ResponseType.SERVER_ERROR:
          yield RemoteServerErrorScreenActionState(
            remoteServerErrorMessage: questionDetailsResponse.errorMessage,
          );
          break;
        case ResType.ResponseType.CLIENT_ERROR:
          yield RemoteClientErrorScreenActionState();
          break;
        case ResType.ResponseType.NETWORK_ERROR:
          break;
      }
    } catch (_) {
      yield RemoteClientErrorScreenActionState();
      return;
    }
  }



  Stream<QuestionDetailsState> _mapRemoveAnswer(RemoveAnswerFromQuestion event) async* {
    try {
      final ResponseWrapper<bool> questionDetailsResponse =
      await catalogService.removeAnswer(answerId:  event.answerId);
      switch (questionDetailsResponse.responseType) {
        case ResType.ResponseType.SUCCESS:
          yield SuccessDeleteAnswer(
              selectAnswerIndex: event.selectAnswerIndex);
          break;
        case ResType.ResponseType.VALIDATION_ERROR:
          yield RemoteValidationErrorState(
            remoteValidationErrorMessage: questionDetailsResponse.errorMessage,
          );
          break;
        case ResType.ResponseType.SERVER_ERROR:
          yield RemoteServerErrorScreenActionState(
            remoteServerErrorMessage: questionDetailsResponse.errorMessage,
          );
          break;
        case ResType.ResponseType.CLIENT_ERROR:
          yield RemoteClientErrorScreenActionState();
          break;
        case ResType.ResponseType.NETWORK_ERROR:
          break;
      }
    } catch (_) {
      yield RemoteClientErrorScreenActionState();
      return;
    }
  }

  Stream<QuestionDetailsState> _mapRemoveFileItem(
    QuestionDetailsState state,
    AnswerRemoveFileItem event,
  ) async* {
    List<FileResponse> items = <FileResponse>[];
    for (int i = 0; i < event.files.length; i++) {
      items.add(FileResponse(
        url: event.files[i].url,
        name: event.files[i].name,
        extension: event.files[i].extension,
        id: event.files[i].id,
      ));
    }
    items.removeAt(event.index);
    yield AnswerUpdatedFileListState(files: items);
  }






  Stream<QuestionDetailsState> _mapFetchQuestionDetailsToState(
    FetchQuestionDetailsEvent event,
  ) async* {
    if(!event.isRefreshData)
    yield LoadingState();
    try {
      final ResponseWrapper<QuestionDetailsResponse> questionDetailsResponse =
          await catalogService.getQuestionDetails(
        questionId: event.questionId,
      );
      switch (questionDetailsResponse.responseType) {
        case ResType.ResponseType.SUCCESS:
          yield QuestionDetailsFetchedState(
              questionDetails: questionDetailsResponse.data);
          break;
        case ResType.ResponseType.VALIDATION_ERROR:
          yield RemoteValidationErrorState(
            remoteValidationErrorMessage: questionDetailsResponse.errorMessage,
          );
          break;
        case ResType.ResponseType.SERVER_ERROR:

          yield RemoteServerErrorState(
            remoteServerErrorMessage: questionDetailsResponse.errorMessage,
          );
          break;
        case ResType.ResponseType.CLIENT_ERROR:
          yield RemoteClientErrorState();
          break;
        case ResType.ResponseType.NETWORK_ERROR:
          break;
      }
    }  catch (_) {
      yield RemoteClientErrorState();
    }
  }

  Stream<QuestionDetailsState> _mapSetUsefulToState(
      VoteUsefulEvent event) async* {
    try {
      final ResponseWrapper<VoteResponse> voteResponse =
          await catalogService.setUsefulVoteForQuestionDetails(
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
          yield RemoteServerErrorScreenActionState(
            remoteServerErrorMessage: voteResponse.errorMessage,
          );
          break;
        case ResType.ResponseType.CLIENT_ERROR:
          yield RemoteClientErrorScreenActionState(
            remoteClientErrorMessage: voteResponse.errorMessage,
          );
          break;
        case ResType.ResponseType.NETWORK_ERROR:
          break;
      }
    }  catch (_) {
      yield RemoteClientErrorScreenActionState();
    }
  }

  Stream<QuestionDetailsState> _mapDownloadFileToState(
    DownloadFileEvent event,
  ) async* {
    try {
      GlobalPurposeFunctions.downloadFile(event.url, event.fileName);
    } on Exception catch (_) {}
  }

  Stream<QuestionDetailsState> _mapAddNewAnswer(AddNewAnswer event) async* {
    try {
      final ResponseWrapper<ActionAnswerResponse> answerDetailsResponse =
          await catalogService.actionAnswer(
        id: null,
        questionId: event.postId,
        body: event.answer,
        files: event.files,
        removedFiles: null,
      );
      switch (answerDetailsResponse.responseType) {
        case ResType.ResponseType.SUCCESS:
          SharedPreferences prefs = await SharedPreferences.getInstance();
          LoginResponse userInfo = LoginResponse.fromMap(
              json.decode(prefs.get(PrefsKeys.LOGIN_RESPONSE)));
          String formattedDate =
              DateFormat('yyyy-MM-dd').format(DateTime.now());
          QuestionAnswerResponse answer = new QuestionAnswerResponse(
              answerId: answerDetailsResponse.data.id ?? "",
              answerBody: event.answer ?? "",
              creationDate: formattedDate,
              usefulCount: 0,
              emphasisCount: 0,
              firstName: userInfo.firstName ?? "",
              lastName: userInfo.lastName ?? "",
              photoUrl: userInfo.photoUrl ?? "",
              inTouchPointName: userInfo.inTouchPointName ?? "",
              personId: userInfo.userId ?? "",
              markedAsEmphasis: false,
              isHealthcareProvider: false,
              markedAsUseful: false,
              comments: <QuestionAnswerCommentResponse>[],
              files: answerDetailsResponse.data.files ?? <FileResponse>[]);
          yield SucessAddNewAnswer(answerResponse: answer);
          break;
        case ResType.ResponseType.VALIDATION_ERROR:
          yield RemoteValidationErrorState(
            remoteValidationErrorMessage: answerDetailsResponse.errorMessage,
          );
          break;
        case ResType.ResponseType.SERVER_ERROR:
          yield RemoteServerErrorScreenActionState(
            remoteServerErrorMessage: answerDetailsResponse.errorMessage,
          );
          break;
        case ResType.ResponseType.CLIENT_ERROR:
          yield RemoteClientErrorScreenActionState();
          break;
        case ResType.ResponseType.NETWORK_ERROR:
          break;
      }
    } catch (_) {
      yield RemoteClientErrorScreenActionState();
      return;
    }
  }

  Stream<QuestionDetailsState> _mapUpdateAnswer(UpdateAnswer event) async* {
    // print("the comment is ${event.commentId} and post id ${event.postId}");
    try {
      final ResponseWrapper<ActionAnswerResponse> blogDetailsResponse =
          await catalogService.actionAnswer(
        body: event.answer,
        files: event.files,
        id: event.answerId,
        questionId: event.postId,
        removedFiles: event.removedFiles,
      );
      switch (blogDetailsResponse.responseType) {
        case ResType.ResponseType.SUCCESS:
          yield SuccessUpdateAnswerSuccess(
            newBody: blogDetailsResponse.data.body,
            selectAnswerIndex: event.selectAnswerIndex,
            files: blogDetailsResponse.data.files,
          );
          break;
        case ResType.ResponseType.VALIDATION_ERROR:
          yield RemoteValidationErrorState(
            remoteValidationErrorMessage: blogDetailsResponse.errorMessage,
          );
          break;
        case ResType.ResponseType.SERVER_ERROR:
          yield RemoteServerErrorScreenActionState(
            remoteServerErrorMessage: blogDetailsResponse.errorMessage,
          );
          break;
        case ResType.ResponseType.CLIENT_ERROR:
          yield RemoteClientErrorScreenActionState();
          break;
        case ResType.ResponseType.NETWORK_ERROR:
          break;
      }
    } catch (_) {
      yield RemoteClientErrorScreenActionState();
      return;
    }
  }
}
