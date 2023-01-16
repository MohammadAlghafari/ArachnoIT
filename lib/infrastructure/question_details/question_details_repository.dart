import 'package:arachnoit/infrastructure/common_response/file_response.dart';
import 'package:arachnoit/infrastructure/question_details/response/action_answer_response.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../common/app_const.dart';
import '../api/response_type.dart' as ResType;
import '../api/response_wrapper.dart';
import '../common_response/vote_response.dart';
import 'caller/action_answer.dart';
import 'caller/get_question_details_remote_data_provider.dart';
import 'caller/set_useful_vote_for_question_details_remote_data_provider.dart';
import 'question_details_interface.dart';
import 'response/question_details_response.dart';

class QuestionDetailsRepository implements QuestionDetailsInterface {
  QuestionDetailsRepository({
    this.getQuestionDetailsRemoteDataProvider,
    this.setUsefulVoteForQuestionDetailsRemoteDataProvider,
    this.addAnswer,
  });

  final GetQuestionDetailsRemoteDataProvider getQuestionDetailsRemoteDataProvider;
  final SetUsefulVoteForQuestionDetailsRemoteDataProvider setUsefulVoteForQuestionDetailsRemoteDataProvider;
  final AddAnswer addAnswer;

  @override
  Future<ResponseWrapper<QuestionDetailsResponse>> getQuestionDetails({String questionId}) async {
    try {
      Response response = await getQuestionDetailsRemoteDataProvider.getQuestionDetails(
        questionId: questionId,
      );
      return _prepareQuestionDetailsResponse(
        remoteResponse: response,
      );
    } on DioError catch (e) {
      return _prepareQuestionDetailsResponse(
        remoteResponse: e.response,
      );
    } catch (e) {
      return _prepareQuestionDetailsResponse(
        remoteResponse: null,
      );
    }
  }

  @override
  Future<ResponseWrapper<VoteResponse>> setUsefulVoteForQuestionDetails({String itemId, bool status}) async {
    try {
      Response response = await setUsefulVoteForQuestionDetailsRemoteDataProvider.setUsefulVoteForQuestionDetails(
        itemId: itemId,
        status: status,
      );
      return _prepareVoteResponse(
        remoteResponse: response,
      );
    } on DioError catch (e) {
      return _prepareVoteResponse(
        remoteResponse: e.response,
      );
    } catch (e) {
      return _prepareVoteResponse(
        remoteResponse: null,
      );
    }
  }

  ResponseWrapper<QuestionDetailsResponse> _prepareQuestionDetailsResponse({@required Response<dynamic> remoteResponse}) {
    var res = ResponseWrapper<QuestionDetailsResponse>();
    if (remoteResponse != null) {
      res.data = QuestionDetailsResponse.fromMap(remoteResponse.data);
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

  ResponseWrapper<VoteResponse> _prepareVoteResponse({@required Response<dynamic> remoteResponse}) {
    var res = ResponseWrapper<VoteResponse>();
    if (remoteResponse != null) {
      res.data = VoteResponse.fromMap(remoteResponse.data[AppConst.ENTITY]);
      res.enumResult = remoteResponse.data[AppConst.ENUM_RESULT] as int;
      res.errorMessage = remoteResponse.data[AppConst.ERROR_MESSAGES] as String;
      res.successEnum = remoteResponse.data[AppConst.SUCCESS_ENUM] as int;
      res.successMessage = remoteResponse.data[AppConst.SUCCESS_MESSAGE] as String;
      res.opertationName = remoteResponse.data[AppConst.OPERATON_NAME] as String;
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
  Future<ResponseWrapper<ActionAnswerResponse>> actionAnswer({
    String id,
    String questionId,
    String body,
    List<FileResponse> files,
    List<String> removedFiles,
  }) async {
    try {
      Response response = await addAnswer.actionAnswer(
        id: id,
        questionId: questionId,
        body: body,
        files: files,
        removedFiles: removedFiles,
      );
      return _prepareActionAnswerResponse(
        remoteResponse: response,
      );
    } on DioError catch (e) {
      return _prepareActionAnswerResponse(
        remoteResponse: e.response,
      );
    } catch (e) {
      return _prepareActionAnswerResponse(
        remoteResponse: null,
      );
    }
  }

  @override
  Future<ResponseWrapper<bool>> removeAnswer({String answerId}) async {
    try {
      Response response = await getQuestionDetailsRemoteDataProvider.removeAnswer(answerId: answerId);
      return _prepareSetRemoveSelectedAnswer(
        remoteResponse: response,
      );
    } on DioError catch (e) {
      return _prepareSetRemoveSelectedAnswer(
        remoteResponse: e.response,
      );
    } catch (e) {
      return _prepareSetRemoveSelectedAnswer(
        remoteResponse: null,
      );
    }
  }


  @override
  Future<ResponseWrapper<bool>> sendReportAnswer({
  @required String description,
  @required  String commentId}) async {
    try {
      Response response = await getQuestionDetailsRemoteDataProvider.sendReportAnswer(commentId: commentId,description: description);
      return _prepareSendReportAnswer(
        remoteResponse: response,
      );
    } on DioError catch (e) {
      return _prepareSendReportAnswer(
        remoteResponse: e.response,
      );
    } catch (e) {
      return _prepareSendReportAnswer(
        remoteResponse: null,
      );
    }
  }

  ResponseWrapper<bool> _prepareSendReportAnswer({@required Response<dynamic> remoteResponse}) {
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
      res.successMessage = remoteResponse.data[AppConst.SUCCESS_MESSAGE] as String;
      res.opertationName = remoteResponse.data[AppConst.OPERATON_NAME] as String;
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


  ResponseWrapper<bool> _prepareSetRemoveSelectedAnswer({@required Response<dynamic> remoteResponse}) {
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
      res.successMessage = remoteResponse.data[AppConst.SUCCESS_MESSAGE] as String;
      res.opertationName = remoteResponse.data[AppConst.OPERATON_NAME] as String;
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

  ResponseWrapper<ActionAnswerResponse> _prepareActionAnswerResponse({@required Response<dynamic> remoteResponse}) {
    var res = ResponseWrapper<ActionAnswerResponse>();
    if (remoteResponse != null) {
      res.data = ActionAnswerResponse.fromMap(remoteResponse.data[AppConst.ENTITY]);
      res.enumResult = remoteResponse.data[AppConst.ENUM_RESULT] as int;
      res.errorMessage = remoteResponse.data[AppConst.ERROR_MESSAGES] as String;
      res.successEnum = remoteResponse.data[AppConst.SUCCESS_ENUM] as int;
      res.successMessage = remoteResponse.data[AppConst.SUCCESS_MESSAGE] as String;
      res.opertationName = remoteResponse.data[AppConst.OPERATON_NAME] as String;
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
