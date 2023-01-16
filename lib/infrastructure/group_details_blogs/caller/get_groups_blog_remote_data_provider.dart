import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../api/urls.dart';

class GetGroupBlogsRemoteDataProvider {
  GetGroupBlogsRemoteDataProvider({@required this.dio});

  final Dio dio;

  Future<dynamic> getGroupBlogs({
    @required String groupId,
    @required int pageNumber,
    @required int pageSize,
  }) async {
    final params = {
       'groupId': groupId ?? "",
      'pageNumber': pageNumber ?? "",
      'pageSize': pageSize ?? "",
    };
    Response response = await dio.get(Urls.GET_BLOGS, queryParameters: params);
    return response;
  }
}
