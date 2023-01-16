import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../api/urls.dart';

class GetCategoriesRemoteDataProvider {
  GetCategoriesRemoteDataProvider({@required this.dio});
  final Dio dio;

  Future<dynamic> getCategories() async {
    final params = {
      'hitPlatform': 0,
      'withDataOnly': true,
    };

    Response response =
        await dio.get(Urls.GET_CATEGORIES, queryParameters: params);
    return response;
  }
}
