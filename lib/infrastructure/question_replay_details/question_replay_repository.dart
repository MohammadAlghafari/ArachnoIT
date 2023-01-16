







import 'package:arachnoit/common/app_const.dart';
import 'package:arachnoit/infrastructure/api/response_wrapper.dart';
import 'package:arachnoit/infrastructure/api/response_type.dart'as ResType;
import 'package:arachnoit/infrastructure/blog_details/response/comment_body_respose.dart';
import 'package:arachnoit/infrastructure/common_response/question_answer_response.dart';
import 'package:arachnoit/infrastructure/question_replay_details/question_replay_interface.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'caller/question_replay_remote_data_provider.dart';
import 'models/question_answer_replay_response.dart';





class QuestionReplayDetailRepository implements QuestionReplayDetailInterface {
final QuestionReplayRemoteDataProvider questionReplayRemoteDataProvider;
  QuestionReplayDetailRepository({
    @required this.questionReplayRemoteDataProvider,
  });
  @override
  Future<ResponseWrapper<bool>> questionDeleteSelectedReplay({String commentId}) async {
    try {
      Response response =
      await questionReplayRemoteDataProvider.questionDeleteSelectedReplay(commentId: commentId);
      return _prepareDeleteSelectedReplay(remoteResponse: response);
    } on DioError catch (e) {
      return _prepareDeleteSelectedReplay(remoteResponse: e.response.data);
    } catch (e) {
      return _prepareDeleteSelectedReplay(remoteResponse: e.request.data);
    }
  }

  ResponseWrapper<bool> _prepareDeleteSelectedReplay(
      {@required Response<dynamic> remoteResponse}) {
    var res = ResponseWrapper<bool>();
    if (remoteResponse != null) {
      if (remoteResponse.statusCode == 200) {
        res.data = true;
      } else {
        res.data = false;
      }
      res.enumResult = remoteResponse.data[AppConst.ENUM_RESULT] as int;
      res.errorMessage = remoteResponse.data[AppConst.ERROR_MESSAGES] as String;
      res.successEnum = remoteResponse.data[AppConst.SUCCESS_ENUM] as int;
      res.successMessage =
      remoteResponse.data[AppConst.SUCCESS_MESSAGE] as String;
      res.opertationName =
      remoteResponse.data[AppConst.OPERATON_NAME] as String;
      switch (remoteResponse.statusCode) {
        case 200:
          res.responseType = ResType.ResponseType.SUCCESS;
          break;
        case 400:
        case 401:
          res.responseType = ResType.ResponseType.VALIDATION_ERROR;
          break;
        case 500:
          res.responseType = ResType.ResponseType.SERVER_ERROR;
          break;
      }
    } else {
      res.responseType = ResType.ResponseType.CLIENT_ERROR;
    }
    return res;
  }

  @override
  Future<ResponseWrapper<QuestionAnswerReplayResponse>> questionSetNewReplay(
      {String comment, String postId}) async {
    try {
      Response response =
      await questionReplayRemoteDataProvider.questionAddNewReplay(message: comment, postId: postId);
      return _prepareSetNewReplay(remoteResponse: response);
    } on DioError catch (e) {
      return _prepareSetNewReplay(remoteResponse: e.response.data);
    } catch (e) {
      return _prepareSetNewReplay(remoteResponse: e.request.data);
    }
  }

  ResponseWrapper<QuestionAnswerReplayResponse> _prepareSetNewReplay(
      {@required Response<dynamic> remoteResponse}) {
    var res = ResponseWrapper<QuestionAnswerReplayResponse>();
    if (remoteResponse != null) {
      res.data =
          QuestionAnswerReplayResponse.fromJson(remoteResponse.data[AppConst.ENTITY]);
      res.enumResult = remoteResponse.data[AppConst.ENUM_RESULT] as int;
      res.errorMessage = remoteResponse.data[AppConst.ERROR_MESSAGES] as String;
      res.successEnum = remoteResponse.data[AppConst.SUCCESS_ENUM] as int;
      res.successMessage =
      remoteResponse.data[AppConst.SUCCESS_MESSAGE] as String;
      res.opertationName =
      remoteResponse.data[AppConst.OPERATON_NAME] as String;
      switch (remoteResponse.statusCode) {
        case 200:
          res.responseType = ResType.ResponseType.SUCCESS;
          break;
        case 400:
        case 401:
          res.responseType = ResType.ResponseType.VALIDATION_ERROR;
          break;
        case 500:
          res.responseType = ResType.ResponseType.SERVER_ERROR;
          break;
      }
    } else {
      res.responseType = ResType.ResponseType.CLIENT_ERROR;
    }
    return res;
  }

  @override
  Future<ResponseWrapper<QuestionAnswerReplayResponse>> questionUpdateSelectedReplay(
      {    String message,
        String answerId,
        String replayCommentId}) async {
    try {
      Response response = await questionReplayRemoteDataProvider.updateSelectedReplay(
answerId: answerId,
message: message,
replayCommentId: replayCommentId
      );
      return _prepareUpdateReplay(remoteResponse: response);
    } on DioError catch (e) {
      return _prepareUpdateReplay(remoteResponse: e.response.data);
    } catch (e) {
      return _prepareUpdateReplay(remoteResponse: e.request.data);
    }
  }

  ResponseWrapper<QuestionAnswerReplayResponse> _prepareUpdateReplay(
      {@required Response<dynamic> remoteResponse}) {
    var res = ResponseWrapper<QuestionAnswerReplayResponse>();
    if (remoteResponse != null) {
      res.data = QuestionAnswerReplayResponse.fromJson(remoteResponse.data);
      res.enumResult = null;
      res.errorMessage = null;
      res.successEnum = null;
      res.successMessage = null;
      res.opertationName = null;
      switch (remoteResponse.statusCode) {
        case 200:
          res.responseType = ResType.ResponseType.SUCCESS;
          break;
        case 400:
        case 401:
          res.responseType = ResType.ResponseType.VALIDATION_ERROR;
          break;
        case 500:
          res.responseType = ResType.ResponseType.SERVER_ERROR;
          break;
      }
    } else {
      res.responseType = ResType.ResponseType.CLIENT_ERROR;
    }
    return res;
  }

  @override
  Future<ResponseWrapper<QuestionAnswerResponse>> questionGetCommentReplay(
      {
        @required String answerId,
        @required String questionId,
      }) async {
    try {
      Response response =
      await questionReplayRemoteDataProvider.questionGetCommentReplay(
        answerId: answerId,
        questionId: questionId
      );
      return _prepareBlogDetailsResponse(
        remoteResponse: response,
      );
    } on DioError catch (e) {
      return _prepareBlogDetailsResponse(
        remoteResponse: e.response,
      );
    } catch (e) {
      return _prepareBlogDetailsResponse(
        remoteResponse: null,
      );
    }
  }

  ResponseWrapper<QuestionAnswerResponse> _prepareBlogDetailsResponse(
      {@required Response<dynamic> remoteResponse}) {
    var res = ResponseWrapper<QuestionAnswerResponse>();
    if (remoteResponse != null) {
      res.data = QuestionAnswerResponse.fromMap(remoteResponse.data);
      res.enumResult = null;
      res.errorMessage = null;
      res.successEnum = null;
      res.successMessage = null;
      res.opertationName = null;
      switch (remoteResponse.statusCode) {
        case 200:
          res.responseType = ResType.ResponseType.SUCCESS;
          break;
        case 400:
        case 401:
          res.responseType = ResType.ResponseType.VALIDATION_ERROR;
          break;
        case 500:
          res.responseType = ResType.ResponseType.SERVER_ERROR;
          break;
      }
    } else {
      res.responseType = ResType.ResponseType.CLIENT_ERROR;
    }
    return res;
  }

  @override
  Future<ResponseWrapper<bool>> sendReport(
      {String commentId, String description}) async {
    try {
      Response response = await questionReplayRemoteDataProvider.sendReport(
          commentId: commentId, description: description);
      return _prepareSendReport(remoteResponse: response);
    } on DioError catch (e) {
      return _prepareSendReport(remoteResponse: e.response);
    } catch (e) {
      return _prepareSendReport(remoteResponse: null);
    }
  }

  ResponseWrapper<bool> _prepareSendReport(
      {@required Response<dynamic> remoteResponse}) {
    var res = ResponseWrapper<bool>();
    if (remoteResponse != null) {
      if (remoteResponse.statusCode == 200) {
        res.data = true;
      } else {
        res.data = false;
      }
      res.enumResult = remoteResponse.data[AppConst.ENUM_RESULT] as int;
      res.errorMessage = remoteResponse.data[AppConst.ERROR_MESSAGES] as String;
      res.successEnum = remoteResponse.data[AppConst.SUCCESS_ENUM] as int;
      res.successMessage =
      remoteResponse.data[AppConst.SUCCESS_MESSAGE] as String;
      res.opertationName =
      remoteResponse.data[AppConst.OPERATON_NAME] as String;
      switch (remoteResponse.statusCode) {
        case 200:
          res.responseType = ResType.ResponseType.SUCCESS;
          break;
        case 400:
        case 401:
          res.responseType = ResType.ResponseType.VALIDATION_ERROR;
          break;
        case 500:
          res.responseType = ResType.ResponseType.SERVER_ERROR;
          break;
      }
    } else {
      res.responseType = ResType.ResponseType.CLIENT_ERROR;
    }
    return res;
  }

}
