import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../api/urls.dart';

class RegistrationRemoteDataIsEmailMobileAvailable {
  RegistrationRemoteDataIsEmailMobileAvailable(
      {@required this.dio});
  final Dio dio;

  Future<List<dynamic>> isEmailMobileAvailabe({
    @required email,
    @required phoneNumber,
  }) async {
    final emailParams = {
      'email': email,
    };
    final phoneNumberParams = {
      'phonenumber': phoneNumber,
    };
    List<Response> responses = await Future.wait([
      dio.post(Urls.EMAIL_AVAILABLE, queryParameters: emailParams),
      dio.post(Urls.PHONE_NUMBER_AVAILABLE, queryParameters: phoneNumberParams),
    ]);
    return responses;
  }
}
