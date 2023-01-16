import 'dart:io';

import 'package:arachnoit/infrastructure/api/urls.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

class ValidateGoogleToken {
  final Dio dio;
  ValidateGoogleToken({@required this.dio});
  Future<dynamic> sendValidation({@required String token}) async {
    final _param = {"accessToken": token};
    Response response = await dio.get(Urls.VALIDATE_GOOGLE_ACCESS_TOKEN,
        queryParameters: _param);
    return response;
  }
}
