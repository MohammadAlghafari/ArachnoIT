import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../api/urls.dart';

class DeleteSelectedBlogs {
  DeleteSelectedBlogs({@required this.dio});

  final Dio dio;

  Future<dynamic> deletBlog({@required String blogId}) async {
    final params = {
      'itemId': blogId,
    };
    Response response =
        await dio.delete(Urls.DELETE_BLOG, data: params);
    return response;
  }
}
