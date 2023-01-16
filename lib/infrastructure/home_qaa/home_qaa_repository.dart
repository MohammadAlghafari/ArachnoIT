import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../common/app_const.dart';
import '../api/response_type.dart' as ResType;
import '../api/response_wrapper.dart';
import '../common_response/file_response.dart';
import '../common_response/vote_response.dart';
import 'caller/delete_selected_question.dart';
import 'caller/get_qaa_local_data_provider.dart';
import 'caller/get_qaa_remote_data_provider.dart';
import 'caller/get_question_files_remote_data_provider.dart';
import 'caller/report_qaa.dart';
import 'caller/set_useful_vote_for_question_remote_data_provider.dart';
import 'home_qaa_interface.dart';
import 'response/qaa_response.dart';

class HomeQaaRepository implements HomeQaaInterface {
  HomeQaaRepository({
    @required this.getQaaLocalDataProvider,
    @required this.getQaaRemoteDataProvider,
    @required this.getQuestionFilesRemoteDataProvider,
    @required this.setUsefulVoteForQuestionRemoteDataProvider,
    @required this.reportQaa,
    @required this.deleteSelectedQuestion,
  });
  final DeleteSelectedQuestion deleteSelectedQuestion;
  final GetQaaLocalDataProvider getQaaLocalDataProvider;
  final GetQaaRemoteDataProvider getQaaRemoteDataProvider;
  final GetQuestionFilesRemoteDataProvider getQuestionFilesRemoteDataProvider;
  final SetUsefulVoteForQuestionRemoteDataProvider
      setUsefulVoteForQuestionRemoteDataProvider;
  final ReportQaa reportQaa;

  @override
  Future<ResponseWrapper<List<QaaResponse>>> getQaas({
    @required int pageNumber,
    @required int pageSize,
  }) async {
    try {
      Response response = await getQaaRemoteDataProvider.getQaas(
        pageNumber: pageNumber,
        pageSize: pageSize,
      );
      return _prepareQaaResponse(
        remoteResponse: response,
      );
    } on DioError catch (e) {
      print("the error is $e");
      return _prepareQaaResponse(
        remoteResponse: e.response,
      );
    } catch (e) {
      print("the error is $e");
      return _prepareQaaResponse(
        remoteResponse: null,
      );
    }
  }

  @override
  Future<ResponseWrapper<List<FileResponse>>> getQuestionFiles(
      {String questionId}) async {
    try {
      Response response =
          await getQuestionFilesRemoteDataProvider.getQuestionFiles(
        questionId: questionId,
      );
      return _prepareQuestionFilesResponse(
        remoteResponse: response,
      );
    } on DioError catch (e) {
      return _prepareQuestionFilesResponse(
        remoteResponse: e.response,
      );
    } catch (e) {
      return _prepareQuestionFilesResponse(
        remoteResponse: null,
      );
    }
  }

  @override
  Future<ResponseWrapper<VoteResponse>> setUsefulVoteForQuestion(
      {String itemId, bool status}) async {
    try {
      Response response = await setUsefulVoteForQuestionRemoteDataProvider
          .setUsefulVoteForQuestion(
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

  ResponseWrapper<List<FileResponse>> _prepareQuestionFilesResponse(
      {@required Response<dynamic> remoteResponse}) {
    var res = ResponseWrapper<List<FileResponse>>();
    if (remoteResponse != null) {
      res.data = (remoteResponse.data as List)
          .map((x) => FileResponse.fromMap(x))
          .toList();
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

  ResponseWrapper<List<QaaResponse>> _prepareQaaResponse(
      {@required Response<dynamic> remoteResponse}) {
    var res = ResponseWrapper<List<QaaResponse>>();
    if (remoteResponse != null) {
      res.data = (remoteResponse.data as List)
          .map((x) => QaaResponse.fromMap(x))
          .toList();
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

  ResponseWrapper<VoteResponse> _prepareVoteResponse(
      {@required Response<dynamic> remoteResponse}) {
    var res = ResponseWrapper<VoteResponse>();
    if (remoteResponse != null) {
      res.data = VoteResponse.fromMap(remoteResponse.data[AppConst.ENTITY]);
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
  Future<ResponseWrapper<bool>> sendQaaReport(
      {String qaaId, String description}) async {
    try {
      Response response =
          await reportQaa.sendReport(qaaId: qaaId, description: description);
      return _prepareSendBlogsReport(remoteResponse: response);
    } on DioError catch (e) {
      return null;
    } catch (e) {
      return null;
    }
  }

  ResponseWrapper<bool> _prepareSendBlogsReport(
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
  Future<ResponseWrapper<bool>> deleteQuestion({String questionId}) async {
    try {
      Response response =
          await deleteSelectedQuestion.deletBlog(questionId: questionId);
      return _prepareDeleteQuestion(remoteResponse: response);
    } on DioError catch (e) {
      return null;
    } catch (e) {
      return null;
    }
  }

  ResponseWrapper<bool> _prepareDeleteQuestion(
      {@required Response<dynamic> remoteResponse}) {
    var res = ResponseWrapper<bool>();
    if (remoteResponse != null) {
      if (remoteResponse.statusCode == 200) {
        res.data = true;
      } else {
        res.data = false;
      }
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
}
