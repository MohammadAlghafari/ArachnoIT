import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../api/urls.dart';

class GetQuestionFilesRemoteDataProvider {
  GetQuestionFilesRemoteDataProvider({@required this.dio});

  final Dio dio;

  Future<dynamic> getQuestionFiles({
    @required String questionId,
  }) async {
    final params = {
      'questionId': questionId ,
    };
    Response response = await dio.get(Urls.GET_QUESTION_FILES, queryParameters: params);
    return response;
  }
}
