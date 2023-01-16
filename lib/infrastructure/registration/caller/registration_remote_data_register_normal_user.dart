import 'package:arachnoit/infrastructure/api/urls.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class RegistrationRemoteDataRegisterNormalUser {
  RegistrationRemoteDataRegisterNormalUser({@required this.dio});

  final Dio dio;

  Future<dynamic> registerNormalUser(
      {
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
    Response response = await dio.post(Urls.REGISTER_NORMAL_USER, data: body);
    return response;
  }
}
