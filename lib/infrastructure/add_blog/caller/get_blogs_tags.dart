import 'package:arachnoit/infrastructure/api/urls.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

class GetBlogsTags {
  Dio dio;
  GetBlogsTags({@required this.dio});
  final params = {
      'pageNumber': 0,
      'pageSize': 1000,
    };
  Future<dynamic> getAllTags() async {
    Response response = await dio.get(
      Urls.GET_QUESTION_TAGS,queryParameters: params

    );
    return response;
  }
}
