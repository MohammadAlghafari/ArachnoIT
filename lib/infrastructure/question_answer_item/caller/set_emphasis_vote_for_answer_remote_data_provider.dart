import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../api/urls.dart';

class SetEmphasisVoteForAnswerRemoteDataProvider {
  SetEmphasisVoteForAnswerRemoteDataProvider({@required this.dio});

  final Dio dio;

  Future<dynamic> setEmphasisVoteForAnswer({
    @required String itemId,
    @required bool status,
  }) async {
    final params = {
      'itemId': itemId,
      'status': status,
    };
    Response response = await dio.put(Urls.SET_EMPHASIS_VOTE_FOR_ANSWER, data: params);
    return response;
  }
}
