import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../api/urls.dart';

class ChangePasswordremoteDataChangePassword {
  ChangePasswordremoteDataChangePassword({@required this.dio});

  final Dio dio;

  Future<dynamic> changePassword(
      { @required String currentPassword,
        @required String newPassword,
        @required String confirmPassword,
      }) async {
    final body = {
      'oldPassword': currentPassword,
      'newPassword': newPassword,
      'confirmPassword': confirmPassword,
    };
    Response response = await dio.put(Urls.CHANGE_PASSWORD, data: body);
    return response;
  }
}
