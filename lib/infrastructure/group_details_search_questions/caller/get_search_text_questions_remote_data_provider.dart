import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../api/urls.dart';

class GetSearchTextQuestionsRemoteDataProvider {
  GetSearchTextQuestionsRemoteDataProvider({@required this.dio});

  final Dio dio;

  Future<dynamic> getSearchTextQuestions({
    @required String groupId,
    @required String query,
    @required int pageNumber,
    @required int pageSize,
  }) async {
    final params = {
      'groupId': groupId ?? "",
      'query': query ?? "",
      'pageNumber': pageNumber ?? "",
      'pageSize': pageSize ?? "",
    };
    Response response = await dio.get(Urls.GET_QAAS, queryParameters: params);
    return response;
  }
}
