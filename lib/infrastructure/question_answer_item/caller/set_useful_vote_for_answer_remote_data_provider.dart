import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../api/urls.dart';

class SetUsefulVoteForAnswerRemoteDataProvider {
  SetUsefulVoteForAnswerRemoteDataProvider({@required this.dio});

  final Dio dio;

  Future<dynamic> setUsefulVoteForAnswer({
    @required String itemId,
    @required bool status,
  }) async {
    final params = {
      'itemId': itemId,
      'status': status,
    };
    Response response = await dio.put(Urls.SET_USEFUL_VOTE_FOR_ANSWER, data: params);
    return response;
  }
}
