import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../api/urls.dart';

class LogoutUserRemoteDataProvider {
  LogoutUserRemoteDataProvider({@required this.dio});

  final Dio dio;

  Future<dynamic> logoutUser(
      {
      @required String model,
      @required String product,
      @required String brand,
      @required String ip,
      @required int osApiLevel}) async {
    final params = {
      'model': model,
      'product': product,
      'brand': brand,
      'ip': ip,
      'osApiLevel': osApiLevel,
    };
    Response response = await dio.post(Urls.LOGOUT_USER, data: params);
    return response;
  }
}
