import 'package:arachnoit/infrastructure/api/urls.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

class GetRemoteQuestionsSubCategory {
  GetRemoteQuestionsSubCategory({@required this.dio});
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
