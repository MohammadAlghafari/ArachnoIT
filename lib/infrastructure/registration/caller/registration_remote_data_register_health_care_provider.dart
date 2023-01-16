import 'dart:io';

import 'package:arachnoit/infrastructure/api/urls.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class RegistrationRemoteDataRegisterHealthCareProvider {
  RegistrationRemoteDataRegisterHealthCareProvider({@required this.dio});

  final Dio dio;

  Future<dynamic> registerHealthCareProvider({
    @required String inTouchPointName,
    @required String subSpecificationId,
    @required String email,
    @required String firstName,
    @required String lastName,
    @required String birthdate,
    @required int gender,
    @required String password,
    @required String mobile,
    @required String cityId,
  }) async {
    final body = {
      'isResearch': true,
      'inTouchPointName': inTouchPointName,
      'subSpecificationId': subSpecificationId,
      'levelsIds': [],
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'birthdate': birthdate,
      'gender': gender,
      'password': password,
      'mobile': mobile,
      'cityId': cityId,
      'agreeOnTerms': true,
    };
    print("the param is $body");
    Response response = await dio.post(Urls.REGISTER_HEALTH_CARE_PROVIDER, data: body);
    return response;
  }
}
