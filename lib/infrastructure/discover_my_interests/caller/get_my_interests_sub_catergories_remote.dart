import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../api/urls.dart';

class GetMyInterestsSubCategoriesRemote {
  GetMyInterestsSubCategoriesRemote({@required this.dio});
  final Dio dio;

  Future<dynamic> getSubCategories() async {
    final params = {
      'hitPlatform': 0,
      'withDataOnly': false,
    };

    Response response = await dio.get(Urls.GET_CATEGORIES, queryParameters: params);

    return response;
  }
}
