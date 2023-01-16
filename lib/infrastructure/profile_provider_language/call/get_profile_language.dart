import 'package:arachnoit/infrastructure/api/urls.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

class GetProfileLanguage {
  final Dio dio;
  GetProfileLanguage({@required this.dio});
  Future<dynamic> getProviderProfileLanguage({
    String searchString,
    int pageNumber,
    int pageSize,
    bool enablePagination = true,
    String healthcareProviderId,
  }) async {
    final _param = {
      "searchString": searchString,
      "pageNumber": pageNumber,
      "pageSize": pageSize,
      "enablePagination": enablePagination,
      "healthcareProviderId": healthcareProviderId
    };
    Response response =
        await dio.get(Urls.GET_LANGUAGE_SKILLS, queryParameters: _param);
    return response;
  }
}
