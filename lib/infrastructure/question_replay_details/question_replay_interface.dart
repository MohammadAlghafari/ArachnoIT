



import 'package:arachnoit/infrastructure/api/response_wrapper.dart';
import 'package:arachnoit/infrastructure/blog_details/response/comment_body_respose.dart';
import 'package:arachnoit/infrastructure/common_response/question_answer_response.dart';
import 'package:flutter/material.dart';

import 'models/question_answer_replay_response.dart';

abstract class QuestionReplayDetailInterface {
  Future<ResponseWrapper<QuestionAnswerReplayResponse>> questionSetNewReplay(
      {@required String comment, String postId});

  Future<ResponseWrapper<QuestionAnswerReplayResponse>> questionUpdateSelectedReplay(
      {  String message,
        String answerId,
        String replayCommentId});

  Future<ResponseWrapper<bool>> questionDeleteSelectedReplay(
      {@required String commentId});

  Future<ResponseWrapper<QuestionAnswerResponse>> questionGetCommentReplay({
    @required String answerId,
    @required String questionId,
  });

  Future<ResponseWrapper<bool>> sendReport(
      {String commentId,String description});

}
