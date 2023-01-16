import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../api/urls.dart';

class RegistrationRemoteDataIsTouchPointNameEmailMobileAvailable {
  RegistrationRemoteDataIsTouchPointNameEmailMobileAvailable(
      {@required this.dio});
  final Dio dio;

  Future<List<dynamic>> isTouchPointNameEmailMobileAvailabe({
    @required touchPointName,
    @required email,
    @required phoneNumber,
  }) async {
    final touchPointNameParams = {
      'touchPointName': touchPointName,
    };
    final emailParams = {
      'email': email,
    };
    final phoneNumberParams = {
      'phonenumber': phoneNumber,
    };
    List<Response> responses = await Future.wait([
      dio.post(Urls.TOUCH_POINT_NAME_AVAILABLE,
          queryParameters: touchPointNameParams),
      dio.post(Urls.EMAIL_AVAILABLE, queryParameters: emailParams),
      dio.post(Urls.PHONE_NUMBER_AVAILABLE, queryParameters: phoneNumberParams),
    ]);
    return responses;
  }
}
