import 'package:arachnoit/infrastructure/api/urls.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

class GetProfileCourses {
  final Dio dio;
  GetProfileCourses({@required this.dio});
  Future<dynamic> getProviderProfileCourses({
    String healthcareProviderId,
    String searchString,
    int pageNumber,
    int pageSize,
  }) async {
    final _param = {
      "healthcareProviderId": healthcareProviderId,
      "searchString": searchString,
      "pageNumber": pageNumber,
      "pageSize": pageSize,
      "enablePagination": true
    };
    Response response =
        await dio.get(Urls.GET_COURSES, queryParameters: _param);
    return response;
  }
}
