import 'package:flutter/material.dart';

import '../api/response_wrapper.dart';
import '../home_qaa/response/qaa_response.dart';

abstract class GroupDetailsQuestionsInterface {
  Future<ResponseWrapper<List<QaaResponse>>> getGroupQuestions({
    @required String groupId,
    @required int pageNumber,
    @required int pageSize,
  });
}
