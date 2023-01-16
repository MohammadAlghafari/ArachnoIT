import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../api/urls.dart';

class SetUsefulVoteForQuestionDetailsRemoteDataProvider {
  SetUsefulVoteForQuestionDetailsRemoteDataProvider({@required this.dio});

  final Dio dio;

  Future<dynamic> setUsefulVoteForQuestionDetails({
    @required String itemId,
    @required bool status,
  }) async {
    final params = {
      'itemId': itemId,
      'status': status,
    };
    Response response = await dio.put(Urls.SET_USEFUL_VOTE_FOR_QUESTION, data: params);
    return response;
  }
}
