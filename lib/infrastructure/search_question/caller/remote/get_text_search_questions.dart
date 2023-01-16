import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../../api/urls.dart';

class GetTextSearchQuestions {
  GetTextSearchQuestions({@required this.dio});
  final Dio dio;
  Future<dynamic> getBlogsTextSearch({
    @required int pageNumber,
    @required int pageSize,
    @required String query,
  }) async {
    final params = {
      'pageNumber': pageNumber ?? "",
      'pageSize': pageSize ?? "",
      'query': query,
    };
    Response response = await dio.get(Urls.GET_QAAS, queryParameters: params);
    return response;
  }
}
