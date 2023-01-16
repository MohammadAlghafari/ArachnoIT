import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../api/urls.dart';

class DeleteSelectedQuestion {
  DeleteSelectedQuestion({@required this.dio});

  final Dio dio;

  Future<dynamic> deletBlog({@required String questionId}) async {
    final params = {
      'itemId': questionId,
    };
    Response response =
        await dio.delete(Urls.DELETE_QUESTION, data: params);
    return response;
  }
}
