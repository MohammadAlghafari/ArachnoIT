import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../api/urls.dart';

class GetSearchTextBlogsRemoteDataProvider {
  GetSearchTextBlogsRemoteDataProvider({@required this.dio});

  final Dio dio;

  Future<dynamic> getSearchTextBlogs({
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
    Response response = await dio.get(Urls.GET_BLOGS, queryParameters: params);
    return response;
  }
}
