import 'package:flutter/material.dart';

import '../api/response_wrapper.dart';
import '../common_response/vote_response.dart';

abstract class QuestionAnswerItemInterface {
  Future<ResponseWrapper<VoteResponse>> setEmphasisVoteForAnswer({
    @required String itemId,
    @required bool status,
  });

  Future<ResponseWrapper<VoteResponse>> setUsefulVoteForAnswer({
    @required String itemId,
    @required bool status,
  });
}
