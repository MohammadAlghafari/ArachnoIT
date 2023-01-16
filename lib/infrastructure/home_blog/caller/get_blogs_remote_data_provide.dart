import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../api/urls.dart';

class GetBlogsRemoteDataProvider {
  GetBlogsRemoteDataProvider({@required this.dio});

  final Dio dio;

  Future<dynamic> getBlogs({
    @required String personId,
    @required int accountTypeId,
    @required String blogId,
    @required String categoryId,
    @required String subCategoryId,
    @required String groupId,
    @required bool myFeed,
    @required List<String> tagsId,
    @required String query,
    @required bool isResearcher,
    @required int pageNumber,
    @required int pageSize,
    @required int orderByBlogs,
    @required bool mySubscriptionsOnly,
  }) async {
    final params = {
      'personId': personId ?? "",
      // 'accountTypeId': accountTypeId ?? "",
      // 'blogId': blogId ?? "",
      // 'categoryId': categoryId ?? "",
      // 'subCategoryId': subCategoryId ?? "",
      // 'groupId': groupId ?? "",
      // 'myFeed': myFeed ?? "",
      // 'tagsId': tagsId ?? "",
      // 'query': query ?? "",
      // 'isResearcher': isResearcher ?? "",
      'pageNumber': pageNumber ?? "",
      'pageSize': pageSize ?? "",
      // 'orderByBlogs': orderByBlogs ?? "",
      // 'mySubscriptionsOnly': mySubscriptionsOnly ?? ""
    };
    Response response = await dio.get(Urls.GET_BLOGS, queryParameters: params);
    return response;
  }
}
