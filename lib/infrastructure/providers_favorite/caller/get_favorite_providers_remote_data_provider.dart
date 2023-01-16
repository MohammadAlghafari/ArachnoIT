import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../api/urls.dart';

class GetFavoriteProvidersRemoteDataProvider {
  GetFavoriteProvidersRemoteDataProvider({@required this.dio});

  final Dio dio;

  Future<dynamic> getFavoriteProviders({
    @required String searchString,
    @required int pageNumber,
    @required int pageSize,
  }) async {
    final params = {
      'searchString': searchString ?? "",
      'pageNumber': pageNumber ?? "",
      'pageSize': pageSize ?? "",
    };
    Response response = await dio.get(Urls.GET_FAVORITE_HEALTH_CARE_PROVIDERS,
        queryParameters: params);
    return response;
  }
}
