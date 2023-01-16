import 'dart:io';

import 'package:arachnoit/infrastructure/api/urls.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

class ValidateFaceBookToken {
  final Dio dio;
  ValidateFaceBookToken({@required this.dio});
  Future<dynamic> sendValidation({@required String token}) async {
    final _param = {"accessToken": token};
    Response response = await dio.get(Urls.VALIDATE_FACEBOOK_ACCESS_TOKEN,
        queryParameters: _param);
    return response;
  }
}
