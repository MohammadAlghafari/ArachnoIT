import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../api/urls.dart';

class GetSubCategoryAllBlogsRemoteDataProvider {
  GetSubCategoryAllBlogsRemoteDataProvider({@required this.dio});

  final Dio dio;

  Future<dynamic> getSubCategoryAllBlogs({
    @required String subCategoryId,
    @required int pageNumber,
    @required int pageSize,
  }) async {
    final params = {
      'subCategoryId': subCategoryId ?? "",
      'pageNumber': pageNumber ?? "",
      'pageSize': pageSize ?? "",
    };
    Response response = await dio.get(Urls.GET_BLOGS, queryParameters: params);
    return response;
  }
}
