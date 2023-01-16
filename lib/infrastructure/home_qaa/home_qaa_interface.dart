import 'package:flutter/material.dart';

import '../api/response_wrapper.dart';
import '../common_response/file_response.dart';
import '../common_response/vote_response.dart';
import 'response/qaa_response.dart';

abstract class HomeQaaInterface {
  Future<ResponseWrapper<List<QaaResponse>>> getQaas({
    @required int pageNumber,
    @required int pageSize,
  });

  Future<ResponseWrapper<List<FileResponse>>> getQuestionFiles({
    @required String questionId,
  });

  Future<ResponseWrapper<VoteResponse>> setUsefulVoteForQuestion({
    @required String itemId,
    @required bool status,
  });

   Future<ResponseWrapper<bool>> sendQaaReport(
      {String qaaId, String description});
    
    
    Future<ResponseWrapper<bool>> deleteQuestion(
      {String questionId});
}
