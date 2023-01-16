import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../api/urls.dart';

class GetAllProvidersRemoteDataProvider {
  GetAllProvidersRemoteDataProvider({@required this.dio});

  final Dio dio;

  Future<dynamic> getAllProviders({
    @required int pageNumber,
    @required int pageSize,
  }) async {
    final params = {
      'pageNumber': pageNumber ?? "",
      'pageSize': pageSize ?? "",
    };
    Response response = await dio.get(Urls.GET_NEWEST_HEALTH_CARE_PROVIDERS,
        queryParameters: params);
    return response;
  }
}
