import 'package:arachnoit/infrastructure/api/urls.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

class GetBlogsMainCategory{
  GetBlogsMainCategory({@required this.dio});
  final Dio dio;

  Future<dynamic> getCategories() async {
    final params = {
      'hitPlatform': 0,
    };
    Response response = await dio.get(
      Urls.GET_SEARCH_CATEGORIES,
      queryParameters: params,
    );
    return response;
  }
}