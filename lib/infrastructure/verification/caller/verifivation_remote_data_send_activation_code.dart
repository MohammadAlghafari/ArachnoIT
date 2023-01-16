import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../api/urls.dart';

class VerificationRemoteDataSendActivationCode {
  VerificationRemoteDataSendActivationCode({@required this.dio});
  final Dio dio;

  Future<dynamic> sendActivationCode({
    @required email,
    @required phoneNumber,
  }) async {
    final body = {
      'email': email,
      'phoneNumbers': [phoneNumber],
    };
    Response response = await dio.post(Urls.SEND_ACTIVATION_CODE, data: body);
    return response;
  }
}
