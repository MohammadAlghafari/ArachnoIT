import 'package:arachnoit/infrastructure/api/urls.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

class GetProfileLicenses {
  final Dio dio;
  GetProfileLicenses({@required this.dio});
  Future<dynamic> getProviderProfileLicenses({
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
        await dio.get(Urls.GET_LICENSES, queryParameters: _param);
    return response;
  }
}
