import 'package:arachnoit/infrastructure/api/urls.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

class SearchProviderRemoteGetServices {
  Dio dio;
  SearchProviderRemoteGetServices({@required this.dio});
  Future<dynamic> getSpecification() async {
    final params = {
      'pageNumber': 0,
      "pageSize":1000
    };
    Response response =
        await dio.get(Urls.PROVIDER_SERVICES_RESPONSE, queryParameters: params);
    return response;
  }
}
