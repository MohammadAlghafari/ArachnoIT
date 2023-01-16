import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../api/urls.dart';

class GetGroupsAdvancedSearchSubCategoriesRemoteDataProvider {
  GetGroupsAdvancedSearchSubCategoriesRemoteDataProvider({@required this.dio});
  final Dio dio;

  Future<dynamic> getSubCategories({
    @required String categoryId,
  }) async {
    final params = {
      'hitPlatform': 0,
      'categoryId': categoryId,
    };

    Response response = await dio.get(
      Urls.GET_SEARCH_SUB_CATEGORIES,
      queryParameters: params,
    );
    return response;
  }
}
