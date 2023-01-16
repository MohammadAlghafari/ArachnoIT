import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../api/urls.dart';

class GetQaaRemoteDataProvider {
  GetQaaRemoteDataProvider({@required this.dio});

  final Dio dio;

  Future<dynamic> getQaas({
    @required int pageNumber,
    @required int pageSize,
  }) async {
    final params = {
      'pageNumber': pageNumber ?? "",
      'pageSize': pageSize ?? "",
    };
    Response response = await dio.get(Urls.GET_QAAS, queryParameters: params);
    return response;
  }
}
