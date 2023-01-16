import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../api/urls.dart';

class VerificationRemoteDataConfrmRegistration {
  VerificationRemoteDataConfrmRegistration({@required this.dio});
  final Dio dio;

  Future<dynamic> confirmRegistration({
    @required email,
    @required activationCode,
  }) async {
    final body = {
      'email': email,
      'activationCode': activationCode,
    };
    Response response = await dio.post(Urls.CONFIRM_REGISTRATION, data: body);
    return response;
  }
}
