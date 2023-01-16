import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../api/urls.dart';

class GetGroupQuestionsRemoteDataProvider {
  GetGroupQuestionsRemoteDataProvider({@required this.dio});

  final Dio dio;

  Future<dynamic> getGroupQuestions({
    @required String groupId,
    @required int pageNumber,
    @required int pageSize,
  }) async {
    final params = {
      'groupId': groupId ?? "",
      'pageNumber': pageNumber ?? "",
      'pageSize': pageSize ?? "",
    };
    Response response = await dio.get(Urls.GET_QAAS, queryParameters: params);
    return response;
  }
}
