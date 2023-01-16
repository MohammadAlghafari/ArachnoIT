import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../api/urls.dart';

class GetBlogsDetail {
  GetBlogsDetail({@required this.dio});

  final Dio dio;

  Future<dynamic> getCommentReplay({
    @required String commentId,
  }) async {
    final params = {
      'commentId': commentId,
    };
    Response response = await dio.get(Urls.GET_COMMENT_INFO, queryParameters: params);
    return response;
  }
}
