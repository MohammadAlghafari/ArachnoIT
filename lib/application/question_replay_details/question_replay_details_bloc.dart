import 'dart:async';
import 'dart:convert';

import 'package:arachnoit/common/pref_keys.dart';
import 'package:arachnoit/infrastructure/api/response_wrapper.dart';
import 'package:arachnoit/infrastructure/blog_details/response/comment_body_respose.dart';
import 'package:arachnoit/infrastructure/catalog_facade_service.dart';
import 'package:arachnoit/infrastructure/common_response/blog_comment_reply_response.dart';
import 'package:arachnoit/infrastructure/common_response/blog_comment_response.dart';
import 'package:arachnoit/infrastructure/common_response/question_answer_comment_response.dart';
import 'package:arachnoit/infrastructure/common_response/question_answer_response.dart';
import 'package:arachnoit/infrastructure/login/response/login_response.dart';
import 'package:arachnoit/infrastructure/question_replay_details/models/question_answer_replay_response.dart';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../infrastructure/api/response_type.dart' as ResType;

part 'question_replay_details_event.dart';
part 'question_replay_details_state.dart';

class QuestionReplayDetailsBloc extends Bloc<QuestionReplayDetailsEvent, QuestionReplayDetailsState> {
  CatalogFacadeService catalogFacadeService;

  QuestionReplayDetailsBloc({@required this.catalogFacadeService}) : super(QuestionReplayDetailsState());

  @override
  Stream<QuestionReplayDetailsState> mapEventToState(
    QuestionReplayDetailsEvent event,
  ) async* {
    if (event is AddNewReplay) {
      yield* _mapAddNewReplay(event);
    } else if (event is UpdateReplay) {
      yield* _mapUpdateReplay(event);
    } else if (event is DeleteReplay) {
      yield* _mapDeleteReplay(event);
    } else if (event is FetchAllComment) {
      yield* _mapFetchQuestionDetailsToState(event);
    } else if (event is IsUpdateClickEvent)
      yield IsUpdateClickState(state: event.state);
    else if (event is SendReport) {
      yield* _mapSendReport(event);
    }
  }

  Stream<QuestionReplayDetailsState> _mapSendReport(SendReport event) async* {
    try {
      ResponseWrapper<bool> res = await catalogFacadeService.questionSendReplayReport(
          commentId: event.commentId, description: event.description);
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

  Stream<QuestionReplayDetailsState> _mapFetchQuestionDetailsToState(
      FetchAllComment event,
      ) async* {
    if(!event.isRefreshData)
    yield LoadingState();
    try {

      final ResponseWrapper<QuestionAnswerResponse> questionDetailsResponse =
      await catalogFacadeService.questionGetCommentReplay(
       answerId: event.answerId,
        questionId: event.questionId
      );
      switch (questionDetailsResponse.responseType) {
        case ResType.ResponseType.SUCCESS:
          yield SuccessGetAllComments(comment: questionDetailsResponse.data);
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
    } on Exception catch (_) {}
  }

  Stream<QuestionReplayDetailsState> _mapAddNewReplay(AddNewReplay event) async* {
    try {
      print("the id is ${event.postId}");
      ResponseWrapper<QuestionAnswerReplayResponse> responseWrapper =
      await catalogFacadeService.questionAddNewReplay(
        comment: event.comment,
        postId: event.postId,
      );
      if (responseWrapper.responseType == ResType.ResponseType.SUCCESS) {
        String formattedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
        SharedPreferences prefs = await SharedPreferences.getInstance();
        LoginResponse userInfo = LoginResponse.fromMap(
            json.decode(prefs.get(PrefsKeys.LOGIN_RESPONSE)));
        QuestionAnswerCommentResponse questionCommentReplyResponse =
        new QuestionAnswerCommentResponse(
            body: responseWrapper.data.body,
            commentId: responseWrapper.data.id,
            creationDate: formattedDate,
            firstName: userInfo.firstName,
            lastName: userInfo.lastName,
            inTouchPointName: userInfo.inTouchPointName,
            personId: userInfo.userId,
            photoUrl: userInfo.photoUrl,
            isHealthcareProvider: false);
        yield SuccessAddReplay(
            questionCommentReplyResponse: questionCommentReplyResponse);
        return;
      } else {
        yield ErrorState(errorMessage: responseWrapper.errorMessage);
        return;
      }
    } on DioError catch (e) {
      yield ErrorState(errorMessage: "Error Happened Try Again");
      return;
    } catch (e) {
      yield ErrorState(errorMessage: "Error Happened Try Again");
      return;
    }
  }

  Stream<QuestionReplayDetailsState> _mapUpdateReplay(UpdateReplay event) async* {
    try {
      ResponseWrapper<QuestionAnswerReplayResponse> responseWrapper =
      await catalogFacadeService.questionUpdateCommentReplay(
         replayCommentId: event.replayCommentId,
        message: event.message,answerId: event.answerId);
      if (responseWrapper.responseType == ResType.ResponseType.SUCCESS) {
        {
          yield SuccessUpdateReplay(index: event.selectCommentIndex);
          return;
        }
      }
    } catch (e) {
      yield ErrorState(errorMessage: "Error Happened Try Again");
    }
  }

  Stream<QuestionReplayDetailsState> _mapDeleteReplay(DeleteReplay event) async* {
    try {
      ResponseWrapper<bool> responseWrapper =
      await catalogFacadeService.questionDeleteCommentReplay(commentId: event.commentId);
      if (responseWrapper.responseType == ResType.ResponseType.SUCCESS) {
        {
          yield SuccessDeleteReplay(index: event.selectCommentIndex);
          return;
        }
      }
    } catch (e) {
      yield ErrorState(errorMessage: "Error Happened Try Again");
    }
  }
}
