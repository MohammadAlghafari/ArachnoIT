import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../api/urls.dart';

class GetSubCategoryAllQuestionsRemoteDataProvider {
  GetSubCategoryAllQuestionsRemoteDataProvider({@required this.dio});

  final Dio dio;

  Future<dynamic> getAllQaas({
    @required String subCategoryId,
    @required int pageNumber,
    @required int pageSize,
  }) async {
    final params = {
      'subCategoryId': subCategoryId ?? "",
      'pageNumber': pageNumber ?? "",
      'pageSize': pageSize ?? "",
    };
    Response response = await dio.get(Urls.GET_QAAS, queryParameters: params);
    return response;
  }
}
