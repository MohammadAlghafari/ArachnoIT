import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../api/urls.dart';

class LoginRemoteDataRequestResetPassword {
  LoginRemoteDataRequestResetPassword({@required this.dio});

  final Dio dio;

  Future<dynamic> requestResetPassword(
      {@required String email,
      }) async {
    final body = {
      'email': email,
    };
    Response response = await dio.post(Urls.REQUEST_RESET_PASSWORD, data: body);
    return response;
  }
}
