import 'package:arachnoit/infrastructure/api/urls.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

class GetProfileSkills {
  final Dio dio;
  GetProfileSkills({@required this.dio});
  Future<dynamic> getProviderProfileSkills({
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
    Response response = await dio.get(Urls.GET_SKILLS, queryParameters: _param);
    return response;
  }
}
