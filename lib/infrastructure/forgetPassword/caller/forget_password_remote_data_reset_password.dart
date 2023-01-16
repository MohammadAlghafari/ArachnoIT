import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../api/urls.dart';

class ForgetPasswordRemoteDataResetPassword {
  ForgetPasswordRemoteDataResetPassword({@required this.dio});
  final Dio dio;

  Future<dynamic> resetPassword({
    @required String newPassword,
    @required String confirmPassword,
    @required String email,
    @required String token,
  }) async {
    final body = {
      "newPassword": newPassword,
      "confirmPassword": confirmPassword,
      "email": email,
      "token": token
    };

    Response response = await dio.post(Urls.RESET_PASSWORD, data: body);
    return response;
  }
}
