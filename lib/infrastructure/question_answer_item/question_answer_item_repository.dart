import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../common/app_const.dart';
import '../api/response_type.dart' as ResType;
import '../api/response_wrapper.dart';
import '../common_response/vote_response.dart';
import 'caller/set_emphasis_vote_for_answer_remote_data_provider.dart';
import 'caller/set_useful_vote_for_answer_remote_data_provider.dart';
import 'question_answer_item_interface.dart';

class QuestionAnswerItemRepository implements QuestionAnswerItemInterface {
  QuestionAnswerItemRepository({
    @required this.setUsefulVoteForAnswerRemoteDataProvider,
    @required this.setEmphasisVoteForAnswerRemoteDataProvider,
  });

  final SetUsefulVoteForAnswerRemoteDataProvider
      setUsefulVoteForAnswerRemoteDataProvider;
  final SetEmphasisVoteForAnswerRemoteDataProvider
      setEmphasisVoteForAnswerRemoteDataProvider;

  @override
  Future<ResponseWrapper<VoteResponse>> setEmphasisVoteForAnswer(
      {String itemId, bool status}) async {
    try {
      Response response = await setEmphasisVoteForAnswerRemoteDataProvider
          .setEmphasisVoteForAnswer(
        itemId: itemId,
        status: status,
      );
      return _prepareSetEmphasisResponse(
        remoteResponse: response,
      );
    } on DioError catch (e) {
      return _prepareSetEmphasisResponse(
        remoteResponse: e.response,
      );
    } catch (e) {
      return _prepareSetEmphasisResponse(
        remoteResponse: null,
      );
    }
  }

  @override
  Future<ResponseWrapper<VoteResponse>> setUsefulVoteForAnswer(
      {String itemId, bool status}) async {
    try {
      Response response =
          await setUsefulVoteForAnswerRemoteDataProvider.setUsefulVoteForAnswer(
        itemId: itemId,
        status: status,
      );
      return _prepareSetVoteResponse(
        remoteResponse: response,
      );
    } on DioError catch (e) {
      return _prepareSetVoteResponse(
        remoteResponse: e.response,
      );
    } catch (e) {
      return _prepareSetVoteResponse(
        remoteResponse: null,
      );
    }
  }

  ResponseWrapper<VoteResponse> _prepareSetEmphasisResponse(
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

  ResponseWrapper<VoteResponse> _prepareSetVoteResponse(
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
}
