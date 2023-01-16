import 'package:arachnoit/infrastructure/api/urls.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

class GetProfileProjects {
  final Dio dio;
  GetProfileProjects({@required this.dio});
  Future<dynamic> getProviderProfileProjects({
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
        await dio.get(Urls.GET_PROJECTS, queryParameters: _param);
    return response;
  }
}
