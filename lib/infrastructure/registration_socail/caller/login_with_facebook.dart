import 'package:arachnoit/infrastructure/api/urls.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

class LoginWithFaceBook {
  final Dio dio;
  LoginWithFaceBook({@required this.dio});
  Future<dynamic> sendLoginFaceBook({
    @required String token,
    @required String email,
    @required String model,
    @required String product,
    @required String brand,
    @required String ip,
    @required int osApiLevel,
    @required bool rememberMe,
    @required String fcmId,
  }) async {
    final _param = {
      "email": email,
      "rememberMe": false,
      "fcmId": fcmId,
      "model": model,
      "product": product,
      "brand": brand,
      "ip": ip,
      "osApiLevel": osApiLevel
    };
    Response response = await dio.post(Urls.LOGIN_WITH_FACEBOOK, data: _param,queryParameters: {
      "accessToken": token,
    });
    return response;
  }
}
