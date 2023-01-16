import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../api/urls.dart';

class GetAdvancedSearchBlogsRemoteDataProvider {
  GetAdvancedSearchBlogsRemoteDataProvider({@required this.dio});

  final Dio dio;

  Future<dynamic> getAdvancedSearchBlogs({
    @required int accountTypeId,
    @required String categoryId,
    @required String subCategoryId,
    @required String groupId,
    @required List<String> tagsId,
    @required int pageNumber,
    @required int pageSize,
  }) async {
    final params = {
      'accountTypeId': accountTypeId ?? '',
      'categoryId': categoryId ?? '',
      'subCategoryId': subCategoryId ?? '',
      'groupId': groupId ?? '',
      'tagsId': tagsId ?? '',
      'pageNumber': pageNumber ?? '',
      'pageSize': pageSize ?? '',
    };
    Response response = await dio.get(Urls.GET_BLOGS, queryParameters: params);
    return response;
  }
}
