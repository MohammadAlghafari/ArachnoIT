import 'package:arachnoit/infrastructure/api/urls.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class GetAllActiveSession {
  GetAllActiveSession({@required this.dio});

  final Dio dio;

  Future<dynamic> getAllActiveSession() async {
    Response response = await dio.get(Urls.GET_PERSON_LOCATIONS);
    return response;
  }
}
