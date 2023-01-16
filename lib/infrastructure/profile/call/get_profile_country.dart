import 'package:arachnoit/infrastructure/api/urls.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class GetProfileCountry {
  GetProfileCountry({@required this.dio});
  final Dio dio;

  Future<dynamic> getCountries() async {
    Response response = await dio.get(
      Urls.COUNTRIES,
    );
    return response;
  }
}
