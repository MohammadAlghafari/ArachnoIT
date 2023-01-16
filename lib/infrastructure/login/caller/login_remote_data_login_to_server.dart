import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../api/urls.dart';

class LoginRemoteDataLoginToServer {
  LoginRemoteDataLoginToServer({@required this.dio});

  final Dio dio;

  Future<dynamic> loginIntoServer(
      {@required String email,
      @required String password,
      @required String model,
      @required String product,
      @required String brand,
      @required String ip,
      @required int osApiLevel}) async {
    final params = {
      'email': email,
      'password': password,
      'model': model,
      'product': product,
      'brand': brand,
      'ip': ip,
      'osApiLevel': osApiLevel,
    };
    Response response = await dio.post(Urls.LOGIN_USER, data: params);
    return response;
  }
}
