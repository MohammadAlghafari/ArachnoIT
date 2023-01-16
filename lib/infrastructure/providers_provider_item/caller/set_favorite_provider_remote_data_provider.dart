import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../api/urls.dart';

class SetFavoriteProviderRemoteDataProvider {
  SetFavoriteProviderRemoteDataProvider({@required this.dio});

  final Dio dio;

  Future<dynamic> setFavoriteProvider({
    @required String favoritePersonId,
    @required bool favoriteStatus,
  }) async {
    final params = {
      'favoritePersonId': favoritePersonId,
      'favoriteStatus': favoriteStatus,
    };
    Response response = await dio.put(Urls.SET_FAVORITE_HEALTH_CARE_PROVIDER, data: params);
    return response;
  }
}
