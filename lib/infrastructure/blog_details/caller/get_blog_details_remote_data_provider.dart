import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../api/urls.dart';

class GetBlogDetailsRemoteDataProvider {
  GetBlogDetailsRemoteDataProvider({@required this.dio});

  final Dio dio;

  Future<dynamic> getBlogDetails({
    @required String blogId,
  }) async {
    final params = {
      'id': blogId,
    };
    Response response =
        await dio.get(Urls.GET_BLOG_DETAILS, queryParameters: params);
    return response;
  }
}
