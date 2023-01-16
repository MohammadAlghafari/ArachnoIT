import 'package:arachnoit/infrastructure/api/urls.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

class GetProfileCertificate {
  final Dio dio;
  GetProfileCertificate({@required this.dio});
  Future<dynamic> getProviderProfileCertificate({
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
        await dio.get(Urls.GET_CERTIFICATE, queryParameters: _param);
    return response;
  }
}
