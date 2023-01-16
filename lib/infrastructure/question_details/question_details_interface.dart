import 'package:arachnoit/infrastructure/common_response/file_response.dart';
import 'package:arachnoit/infrastructure/question_details/response/action_answer_response.dart';
import 'package:flutter/material.dart';

import '../api/response_wrapper.dart';
import '../common_response/vote_response.dart';
import 'response/question_details_response.dart';

abstract class QuestionDetailsInterface {
  Future<ResponseWrapper<QuestionDetailsResponse>> getQuestionDetails({
    @required String questionId,
  });

  Future<ResponseWrapper<VoteResponse>> setUsefulVoteForQuestionDetails({
    @required String itemId,
    @required bool status,
  });

  Future<ResponseWrapper<bool>> removeAnswer({
    @required String answerId,

  });

  Future<ResponseWrapper<bool>> sendReportAnswer(
  {
    @required String description,
    @required  String commentId}

  );

  Future<ResponseWrapper<ActionAnswerResponse>> actionAnswer({
    @required String id,
    @required String questionId,
    @required String body,
    @required List<FileResponse> files,
    @required List<String> removedFiles,
  });
}
